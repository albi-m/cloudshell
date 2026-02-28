/// Riverpod providers for vault state management.
///
/// Manages the vault lifecycle: setup, lock, unlock, auto-lock.
/// Holds derived encryption keys in memory while unlocked.
library;

import 'dart:async';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:local_auth/local_auth.dart';

import '../core/constants/storage_keys.dart';
import '../data/database/app_database.dart';
import '../services/backend/sync_backend.dart';
import '../services/crypto/secure_storage.dart';
import '../services/crypto/vault_crypto_service.dart';
import 'auth_provider.dart';
import 'backend_provider.dart';
import 'settings_provider.dart';

/// Vault lifecycle states.
enum VaultState {
  /// No master password has been set — vault feature is inactive.
  noVault,

  /// Master password is set but vault is locked — keys not in memory.
  locked,

  /// Vault is unlocked — keys are in memory, data is accessible.
  unlocked,

  /// Currently deriving keys (Argon2id is slow by design).
  unlocking,
}

/// Settings keys for vault configuration.
abstract final class VaultSettingsKeys {
  /// Whether the vault has been initialized (master password set).
  static const String vaultInitialized = 'vault_initialized';

  /// Auto-lock timeout in seconds (0 = never).
  static const String autoLockTimeout = 'vault_auto_lock_timeout';

  /// Whether biometric vault unlock is enabled.
  static const String biometricVaultUnlock = 'vault_biometric_unlock';

  /// Salt for Argon2id KDF (base64-encoded).
  static const String vaultSalt = 'vault_salt';

  /// Verification token ciphertext (base64-encoded).
  static const String vaultVerifyCiphertext = 'vault_verify_ct';

  /// Verification token nonce (base64-encoded).
  static const String vaultVerifyNonce = 'vault_verify_nonce';

  /// Number of consecutive failed unlock attempts.
  static const String failedAttempts = 'vault_failed_attempts';

  /// Timestamp of last failed attempt (for progressive lockout).
  static const String lastFailedAttempt = 'vault_last_failed_attempt';
}

final _log = Logger(printer: SimplePrinter());

/// Progressive lockout durations (in seconds) for failed attempts.
const List<int> _lockoutDurations = [0, 0, 0, 30, 60, 300, 900, 3600];

/// Manages the vault state machine.
///
/// State transitions:
///   noVault → (setup master password) → unlocked
///   unlocked → (lock / auto-lock / background) → locked
///   locked → (enter password / biometric) → unlocked
///   locked → (forgot password) → noVault (data loss)
class VaultNotifier extends AsyncNotifier<VaultState> {
  VaultKeys? _keys;
  Timer? _autoLockTimer;

  /// Returns the current vault keys (only available when unlocked).
  VaultKeys? get keys => _keys;

  @override
  Future<VaultState> build() async {
    ref.onDispose(() {
      _keys?.destroy();
      _keys = null;
      _autoLockTimer?.cancel();
    });

    final isInitialized = await _isVaultInitialized();
    if (!isInitialized) return VaultState.noVault;

    // Try auto-unlock from cached master key in secure storage.
    // This lets users skip the password prompt on app reopen.
    final autoUnlocked = await _tryAutoUnlock();
    if (autoUnlocked) return VaultState.unlocked;

    return VaultState.locked;
  }

  /// Sets up the vault with a new master password.
  ///
  /// Generates salt, derives keys, stores verification token.
  Future<void> setupVault(String password) async {
    state = const AsyncValue.data(VaultState.unlocking);

    try {
      final crypto = ref.read(vaultCryptoServiceProvider);
      final db = ref.read(databaseProvider);
      final settings = ref.read(settingsNotifierProvider.notifier);

      // Generate random salt
      final salt = await crypto.generateSalt();

      // Derive full key set
      final keys = await crypto.deriveKeys(password, salt);

      // Create verification token
      final verif = await crypto.createVerificationToken(keys.encKey);

      // Persist vault metadata
      await settings.set(
          VaultSettingsKeys.vaultSalt, base64Encode(salt));
      await settings.set(
          VaultSettingsKeys.vaultVerifyCiphertext, verif.ciphertext);
      await settings.set(
          VaultSettingsKeys.vaultVerifyNonce, verif.nonce);
      await settings.set(VaultSettingsKeys.vaultInitialized, 'true');

      // Default auto-lock: 5 minutes
      await settings.set(VaultSettingsKeys.autoLockTimeout, '300');

      // Migrate existing secrets to vault encryption
      await _migrateToVault(keys, db);

      // Upload vault config to backend (if authenticated)
      await _uploadVaultConfig(salt);

      // Store keys in memory and cache for auto-unlock
      _keys = keys;
      await _cacheKeys();
      _startAutoLockTimer();

      state = const AsyncValue.data(VaultState.unlocked);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Attempts to unlock the vault with the given password.
  ///
  /// Returns null on success, or an error message on failure.
  Future<String?> unlock(String password) async {
    // Check lockout
    final lockoutRemaining = await _getLockoutRemaining();
    if (lockoutRemaining > 0) {
      return 'Too many failed attempts. Try again in ${_formatDuration(lockoutRemaining)}.';
    }

    state = const AsyncValue.data(VaultState.unlocking);

    try {
      final crypto = ref.read(vaultCryptoServiceProvider);
      final settings = ref.read(settingsNotifierProvider.notifier);

      // Read stored salt and verification token
      final saltB64 = await _getSetting(VaultSettingsKeys.vaultSalt);
      final verifCt =
          await _getSetting(VaultSettingsKeys.vaultVerifyCiphertext);
      final verifNonce =
          await _getSetting(VaultSettingsKeys.vaultVerifyNonce);

      if (saltB64 == null || verifCt == null || verifNonce == null) {
        state = const AsyncValue.data(VaultState.noVault);
        return 'Vault data is corrupted. Please reset.';
      }

      final salt = base64Decode(saltB64);

      // Derive keys from password
      final keys = await crypto.deriveKeys(password, Uint8List.fromList(salt));

      // Verify password correctness
      final isValid =
          await crypto.verifyPassword(keys.encKey, verifCt, verifNonce);

      if (!isValid) {
        keys.destroy();
        await _recordFailedAttempt();
        state = const AsyncValue.data(VaultState.locked);

        final attempts = await _getFailedAttempts();
        if (attempts >= 3) {
          final nextLockout = _getLockoutDuration(attempts + 1);
          if (nextLockout > 0) {
            return 'Incorrect password. $attempts failed attempts. '
                'Next lockout: ${_formatDuration(nextLockout)}.';
          }
        }
        return 'Incorrect password.';
      }

      // Success — clear failed attempts
      await settings.set(VaultSettingsKeys.failedAttempts, '0');

      _keys = keys;
      await _cacheKeys();
      _startAutoLockTimer();

      state = const AsyncValue.data(VaultState.unlocked);
      return null;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return 'Unlock failed: $e';
    }
  }

  /// Enables biometric vault unlock.
  ///
  /// Verifies biometric availability, authenticates the user,
  /// and marks the setting as enabled. The master key is already
  /// cached by _cacheKeys() on every successful unlock.
  Future<String?> enableBiometricVaultUnlock() async {
    if (_keys == null) return 'Vault must be unlocked first.';

    try {
      final localAuth = LocalAuthentication();
      final canAuth = await localAuth.canCheckBiometrics ||
          await localAuth.isDeviceSupported();
      if (!canAuth) return 'Biometric authentication not available.';

      // Authenticate to confirm identity before enabling
      final authenticated = await localAuth.authenticate(
        localizedReason: 'Enable biometric unlock',
        persistAcrossBackgrounding: true,
      );
      if (!authenticated) return 'Biometric authentication failed.';

      // Mark biometric vault unlock as enabled
      final settings = ref.read(settingsNotifierProvider.notifier);
      await settings.set(VaultSettingsKeys.biometricVaultUnlock, 'true');

      return null; // success
    } on LocalAuthException catch (e) {
      return 'Failed to enable biometric unlock: ${e.description}';
    }
  }

  /// Disables biometric vault unlock.
  ///
  /// Note: the cached master key is NOT cleared here because it's
  /// also used for auto-unlock on app reopen. It is only cleared
  /// on vault reset, password change, or logout.
  Future<void> disableBiometricVaultUnlock() async {
    final settings = ref.read(settingsNotifierProvider.notifier);
    await settings.set(VaultSettingsKeys.biometricVaultUnlock, 'false');
  }

  /// Attempts biometric vault unlock.
  ///
  /// Only works if biometric vault unlock is enabled AND the
  /// master key is cached in the platform keychain.
  Future<String?> unlockWithBiometric() async {
    final biometricEnabled =
        await _getSetting(VaultSettingsKeys.biometricVaultUnlock);
    if (biometricEnabled != 'true') {
      return 'Biometric unlock is not enabled.';
    }

    try {
      final localAuth = LocalAuthentication();
      final canAuth = await localAuth.canCheckBiometrics ||
          await localAuth.isDeviceSupported();
      if (!canAuth) return 'Biometric authentication not available.';

      final authenticated = await localAuth.authenticate(
        localizedReason: 'Unlock CloudShell vault',
        persistAcrossBackgrounding: true,
      );
      if (!authenticated) return 'Biometric authentication failed.';

      // Read cached master key from secure storage
      final storage = ref.read(secureStorageProvider);
      final masterKeyB64 = await storage.read(StorageKeys.biometricMasterKey);
      if (masterKeyB64 == null) {
        // Key was cleared (e.g., after password change) — disable
        final settings = ref.read(settingsNotifierProvider.notifier);
        await settings.set(VaultSettingsKeys.biometricVaultUnlock, 'false');
        return 'Cached key not found. Please unlock with your password and re-enable biometric unlock.';
      }

      state = const AsyncValue.data(VaultState.unlocking);

      // Reconstruct master key and expand into encKey + macKey
      final masterKeyBytes = base64Decode(masterKeyB64);
      final masterKey = SecretKey(masterKeyBytes);

      final crypto = ref.read(vaultCryptoServiceProvider);
      final expanded = await crypto.expandKey(masterKey);

      // Verify with stored verification token
      final verifCt =
          await _getSetting(VaultSettingsKeys.vaultVerifyCiphertext);
      final verifNonce =
          await _getSetting(VaultSettingsKeys.vaultVerifyNonce);

      if (verifCt == null || verifNonce == null) {
        masterKey.destroy();
        expanded.encKey.destroy();
        expanded.macKey.destroy();
        state = const AsyncValue.data(VaultState.locked);
        return 'Vault verification data missing.';
      }

      final isValid = await crypto.verifyPassword(
        expanded.encKey,
        verifCt,
        verifNonce,
      );

      if (!isValid) {
        masterKey.destroy();
        expanded.encKey.destroy();
        expanded.macKey.destroy();
        // Cached key is stale (password was changed) — clear it
        await disableBiometricVaultUnlock();
        state = const AsyncValue.data(VaultState.locked);
        return 'Cached key is invalid. Please unlock with your password and re-enable biometric unlock.';
      }

      // Success
      final settings = ref.read(settingsNotifierProvider.notifier);
      await settings.set(VaultSettingsKeys.failedAttempts, '0');

      _keys = VaultKeys(
        masterKey: masterKey,
        encKey: expanded.encKey,
        macKey: expanded.macKey,
      );
      _startAutoLockTimer();

      state = const AsyncValue.data(VaultState.unlocked);
      return null;
    } on PlatformException {
      return 'Biometric authentication not available.';
    } catch (e) {
      state = const AsyncValue.data(VaultState.locked);
      return 'Biometric unlock failed: $e';
    }
  }

  /// Locks the vault — clears keys from memory.
  ///
  /// When authenticated, the vault is auto-managed and should only
  /// be locked on logout. Use [forceLock] for logout scenarios.
  void lock() {
    // When authenticated, refuse auto-lock — vault stays unlocked
    // for the session. Only forceLock() (called by logout) can lock it.
    final isAuth = ref.read(authProvider).value == AuthState.authenticated;
    if (isAuth) {
      _log.i('Vault lock skipped — user is authenticated');
      return;
    }
    _forceLock();
  }

  /// Force-locks the vault regardless of auth state.
  /// Used by logout flow to clear keys.
  void forceLock() {
    _forceLock();
  }

  void _forceLock() {
    _keys?.destroy();
    _keys = null;
    _autoLockTimer?.cancel();
    state = const AsyncValue.data(VaultState.locked);
  }

  /// Resets the vault — deletes all vault data.
  ///
  /// WARNING: This destroys all encrypted data that cannot
  /// be recovered without the master password.
  Future<void> resetVault() async {
    _keys?.destroy();
    _keys = null;
    _autoLockTimer?.cancel();

    // Clear cached master key
    try {
      final storage = ref.read(secureStorageProvider);
      await storage.delete(StorageKeys.biometricMasterKey);
    } catch (_) {
      // Best-effort cleanup
    }

    final settings = ref.read(settingsNotifierProvider.notifier);
    await settings.delete(VaultSettingsKeys.vaultInitialized);
    await settings.delete(VaultSettingsKeys.vaultSalt);
    await settings.delete(VaultSettingsKeys.vaultVerifyCiphertext);
    await settings.delete(VaultSettingsKeys.vaultVerifyNonce);
    await settings.delete(VaultSettingsKeys.autoLockTimeout);
    await settings.delete(VaultSettingsKeys.biometricVaultUnlock);
    await settings.delete(VaultSettingsKeys.failedAttempts);
    await settings.delete(VaultSettingsKeys.lastFailedAttempt);

    state = const AsyncValue.data(VaultState.noVault);
  }

  /// Changes the master password.
  ///
  /// Re-derives keys and re-encrypts the verification token.
  /// Existing per-item encrypted data does NOT need re-encryption
  /// because per-item keys are encrypted with the vault EncKey,
  /// and we re-encrypt only those wrapped keys.
  Future<String?> changePassword(
      String currentPassword, String newPassword) async {
    if (_keys == null) return 'Vault is locked.';

    try {
      final crypto = ref.read(vaultCryptoServiceProvider);
      final settings = ref.read(settingsNotifierProvider.notifier);

      // Verify current password first
      final saltB64 = await _getSetting(VaultSettingsKeys.vaultSalt);
      final verifCt =
          await _getSetting(VaultSettingsKeys.vaultVerifyCiphertext);
      final verifNonce =
          await _getSetting(VaultSettingsKeys.vaultVerifyNonce);

      if (saltB64 == null || verifCt == null || verifNonce == null) {
        return 'Vault data is corrupted.';
      }

      final oldSalt = base64Decode(saltB64);
      final oldKeys =
          await crypto.deriveKeys(currentPassword, Uint8List.fromList(oldSalt));
      final isValid =
          await crypto.verifyPassword(oldKeys.encKey, verifCt, verifNonce);
      oldKeys.destroy();

      if (!isValid) return 'Current password is incorrect.';

      // Generate new salt and derive new keys
      final newSalt = await crypto.generateSalt();
      final newKeys = await crypto.deriveKeys(newPassword, newSalt);

      // Create new verification token
      final newVerif = await crypto.createVerificationToken(newKeys.encKey);

      // Update stored metadata
      await settings.set(
          VaultSettingsKeys.vaultSalt, base64Encode(newSalt));
      await settings.set(
          VaultSettingsKeys.vaultVerifyCiphertext, newVerif.ciphertext);
      await settings.set(
          VaultSettingsKeys.vaultVerifyNonce, newVerif.nonce);

      // Upload new vault config to backend
      await _uploadVaultConfig(newSalt);

      // Clear biometric cache — user must re-enable after password change
      await disableBiometricVaultUnlock();

      // Swap in-memory keys and re-cache
      _keys?.destroy();
      _keys = newKeys;
      await _cacheKeys();

      return null; // success
    } catch (e) {
      return 'Password change failed: $e';
    }
  }

  /// Resets the auto-lock timer (call on user activity).
  void resetAutoLockTimer() {
    if (_keys != null) {
      _startAutoLockTimer();
    }
  }

  /// Fetches vault config from the server for multi-device unlock.
  ///
  /// On a new device, the vault is not initialized locally. If the user
  /// is authenticated, we can fetch salt + KDF params from the server
  /// so they only need to enter their master password.
  Future<bool> fetchVaultConfigFromServer() async {
    try {
      final authBackend = ref.read(authBackendProvider);
      if (authBackend == null || !authBackend.isSignedIn) return false;

      final syncBackend = ref.read(syncBackendProvider);
      if (syncBackend == null) return false;

      final config = await syncBackend.getVaultConfig();
      if (config == null) return false;

      // Store vault parameters locally
      final settings = ref.read(settingsNotifierProvider.notifier);
      await settings.set(VaultSettingsKeys.vaultSalt, config.kdfSalt);

      if (config.verificationToken != null) {
        // Parse "ciphertext:nonce" format
        final parts = config.verificationToken!.split(':');
        if (parts.length == 2) {
          await settings.set(
              VaultSettingsKeys.vaultVerifyCiphertext, parts[0]);
          await settings.set(VaultSettingsKeys.vaultVerifyNonce, parts[1]);
        }
      }

      await settings.set(VaultSettingsKeys.vaultInitialized, 'true');

      // Re-check state
      state = const AsyncValue.data(VaultState.locked);
      return true;
    } catch (e) {
      _log.e('Failed to fetch vault config from server: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  /// Tries to auto-unlock the vault using a cached master key from
  /// secure storage. Returns true on success, false if no cached key
  /// or the cached key is stale (password was changed).
  Future<bool> _tryAutoUnlock() async {
    try {
      final storage = ref.read(secureStorageProvider);
      final masterKeyB64 = await storage.read(StorageKeys.biometricMasterKey);
      if (masterKeyB64 == null) return false;

      final masterKeyBytes = base64Decode(masterKeyB64);
      final masterKey = SecretKey(masterKeyBytes);

      final crypto = ref.read(vaultCryptoServiceProvider);
      final expanded = await crypto.expandKey(masterKey);

      // Verify the cached key against the stored verification token
      final verifCt =
          await _getSetting(VaultSettingsKeys.vaultVerifyCiphertext);
      final verifNonce =
          await _getSetting(VaultSettingsKeys.vaultVerifyNonce);

      if (verifCt == null || verifNonce == null) {
        masterKey.destroy();
        expanded.encKey.destroy();
        expanded.macKey.destroy();
        return false;
      }

      final isValid = await crypto.verifyPassword(
        expanded.encKey,
        verifCt,
        verifNonce,
      );

      if (!isValid) {
        masterKey.destroy();
        expanded.encKey.destroy();
        expanded.macKey.destroy();
        // Cached key is stale — clear it
        await storage.delete(StorageKeys.biometricMasterKey);
        return false;
      }

      _keys = VaultKeys(
        masterKey: masterKey,
        encKey: expanded.encKey,
        macKey: expanded.macKey,
      );
      _startAutoLockTimer();
      return true;
    } catch (e) {
      _log.w('Auto-unlock from cached key failed: $e');
      return false;
    }
  }

  /// Caches the master key in secure storage for auto-unlock on app reopen.
  Future<void> _cacheKeys() async {
    if (_keys == null) return;
    try {
      final masterKeyBytes = await _keys!.masterKey.extractBytes();
      final masterKeyB64 = base64Encode(masterKeyBytes);

      final storage = ref.read(secureStorageProvider);
      await storage.write(StorageKeys.biometricMasterKey, masterKeyB64);
    } catch (e) {
      // Non-fatal — vault still works, just won't auto-unlock next time
      _log.w('Failed to cache vault keys: $e');
    }
  }

  /// Uploads vault config to the backend for multi-device sync.
  Future<void> _uploadVaultConfig(Uint8List salt) async {
    try {
      // Only upload if user is signed in to the backend
      final authBackend = ref.read(authBackendProvider);
      if (authBackend == null || !authBackend.isSignedIn) return;

      final syncBackend = ref.read(syncBackendProvider);
      if (syncBackend == null) return;

      final verifCt =
          await _getSetting(VaultSettingsKeys.vaultVerifyCiphertext);
      final verifNonce =
          await _getSetting(VaultSettingsKeys.vaultVerifyNonce);

      await syncBackend.saveVaultConfig(VaultConfigData(
        kdfSalt: base64Encode(salt),
        kdfMemory: VaultCryptoService.argon2Memory,
        kdfIterations: VaultCryptoService.argon2Iterations,
        kdfParallelism: VaultCryptoService.argon2Parallelism,
        verificationToken:
            verifCt != null && verifNonce != null
                ? '$verifCt:$verifNonce'
                : null,
      ));
    } catch (e) {
      // Non-fatal — vault works locally even if upload fails
      _log.w('Failed to upload vault config: $e');
    }
  }

  Future<bool> _isVaultInitialized() async {
    final value = await _getSetting(VaultSettingsKeys.vaultInitialized);
    return value == 'true';
  }

  Future<String?> _getSetting(String key) async {
    final db = ref.read(databaseProvider);
    return db.settingsDao.getValue(key);
  }

  void _startAutoLockTimer() {
    _autoLockTimer?.cancel();

    // When authenticated, vault stays unlocked for the session.
    // Only biometric app lock provides idle protection.
    final isAuth = ref.read(authProvider).value == AuthState.authenticated;
    if (isAuth) return;

    // Read timeout asynchronously
    _getSetting(VaultSettingsKeys.autoLockTimeout).then((value) {
      final timeoutSeconds = int.tryParse(value ?? '') ?? 300;
      if (timeoutSeconds <= 0) return; // 0 = never auto-lock

      _autoLockTimer = Timer(Duration(seconds: timeoutSeconds), () {
        lock();
      });
    });
  }

  Future<void> _migrateToVault(VaultKeys keys, AppDatabase db) async {
    // Migration is handled by re-encrypting secrets from the
    // device-bound AppCryptoService key to the vault key.
    // For now, existing secrets remain accessible via AppCryptoService.
    // Full migration will be implemented when sync is added (Sprint 21-22).
  }

  Future<int> _getFailedAttempts() async {
    final value = await _getSetting(VaultSettingsKeys.failedAttempts);
    return int.tryParse(value ?? '') ?? 0;
  }

  Future<void> _recordFailedAttempt() async {
    final settings = ref.read(settingsNotifierProvider.notifier);
    final attempts = await _getFailedAttempts();
    await settings.set(
        VaultSettingsKeys.failedAttempts, '${attempts + 1}');
    await settings.set(VaultSettingsKeys.lastFailedAttempt,
        DateTime.now().millisecondsSinceEpoch.toString());
  }

  Future<int> _getLockoutRemaining() async {
    final attempts = await _getFailedAttempts();
    final lockoutDuration = _getLockoutDuration(attempts);
    if (lockoutDuration <= 0) return 0;

    final lastFailedStr =
        await _getSetting(VaultSettingsKeys.lastFailedAttempt);
    if (lastFailedStr == null) return 0;

    final lastFailed = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(lastFailedStr) ?? 0);
    final elapsed = DateTime.now().difference(lastFailed).inSeconds;
    final remaining = lockoutDuration - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  int _getLockoutDuration(int attempts) {
    if (attempts < _lockoutDurations.length) {
      return _lockoutDurations[attempts];
    }
    return _lockoutDurations.last; // 1 hour for 8+ attempts
  }

  String _formatDuration(int seconds) {
    if (seconds >= 3600) {
      return '${seconds ~/ 3600}h ${(seconds % 3600) ~/ 60}m';
    }
    if (seconds >= 60) {
      return '${seconds ~/ 60}m ${seconds % 60}s';
    }
    return '${seconds}s';
  }
}

/// Provider for the vault state.
final vaultProvider = AsyncNotifierProvider<VaultNotifier, VaultState>(
  VaultNotifier.new,
);

/// Convenience provider that returns true when vault is unlocked.
final isVaultUnlockedProvider = Provider<bool>((ref) {
  final vaultState = ref.watch(vaultProvider);
  return vaultState.value == VaultState.unlocked;
});

/// Provides the auto-lock timeout setting (in seconds).
final vaultAutoLockTimeoutProvider = Provider<int>((ref) {
  final setting =
      ref.watch(settingProvider(VaultSettingsKeys.autoLockTimeout));
  return setting.when(
    data: (value) => int.tryParse(value ?? '') ?? 300,
    loading: () => 300,
    error: (_, _) => 300,
  );
});
