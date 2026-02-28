/// Riverpod providers for authentication state management.
///
/// Manages the auth lifecycle: unauthenticated, authenticated,
/// local-only mode. Auth is always optional — the app works
/// fully without an account.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logger/logger.dart';

import '../data/database/app_database.dart';
import '../services/auth/auth_service.dart';
import '../services/backend/auth_backend.dart';
import 'backend_provider.dart';
import 'settings_provider.dart';
import 'vault_provider.dart';

final _log = Logger(printer: SimplePrinter());

/// Authentication states.
enum AuthState {
  /// No account — user hasn't signed in or chosen local-only.
  unauthenticated,

  /// Currently authenticating (sign-in or sign-up in progress).
  authenticating,

  /// Signed in with a sync account.
  authenticated,

  /// User explicitly chose to use the app without an account.
  localOnly,
}

/// Manages authentication state.
///
/// Auth is optional — the app works fully in local-only mode.
/// When authenticated, sync features become available.
///
/// Uses the AuthBackend interface (Supabase by default) for
/// all auth operations. No vault requirement for signing in.
class AuthNotifier extends AsyncNotifier<AuthState> {
  StreamSubscription<BackendAuthState>? _authSub;

  @override
  Future<AuthState> build() async {
    // If no backend is configured, force local-only
    final backend = ref.read(authBackendProvider);
    if (backend == null) return AuthState.localOnly;

    // Check if user explicitly chose local-only
    final db = ref.read(databaseProvider);
    final authMode = await db.settingsDao.getValue(SettingsKeys.authMode);
    if (authMode == 'local') return AuthState.localOnly;

    // Check if backend has an active session
    if (backend.isSignedIn) {
      // Store email in settings for display
      final email = backend.currentUserEmail;
      if (email != null) {
        final settings = ref.read(settingsNotifierProvider.notifier);
        await settings.set(SettingsKeys.userEmail, email);
      }
      return AuthState.authenticated;
    }

    // Listen for auth state changes from backend
    _authSub?.cancel();
    _authSub = backend.authStateChanges.listen((event) {
      switch (event) {
        case BackendAuthState.signedIn:
        case BackendAuthState.tokenRefreshed:
          state = const AsyncValue.data(AuthState.authenticated);
        case BackendAuthState.signedOut:
          state = const AsyncValue.data(AuthState.unauthenticated);
        case BackendAuthState.passwordRecovery:
          break; // handled by UI
      }
    });

    ref.onDispose(() => _authSub?.cancel());

    return AuthState.unauthenticated;
  }

  /// Signs up for a new account.
  ///
  /// After successful signup, auto-creates the vault using the same
  /// password so the user only needs to remember one password.
  Future<String?> signUp(String email, String password) async {
    state = const AsyncValue.data(AuthState.authenticating);

    final authService = ref.read(authServiceProvider);
    final result = await authService.signUp(
      email: email,
      password: password,
    );

    if (result.success) {
      final settings = ref.read(settingsNotifierProvider.notifier);
      await settings.set(SettingsKeys.authMode, 'cloud');
      await settings.set(SettingsKeys.userEmail, email.toLowerCase().trim());

      // Auto-create vault with account password (one password for everything)
      await _autoSetupVault(password);

      state = const AsyncValue.data(AuthState.authenticated);
      return null;
    }

    state = const AsyncValue.data(AuthState.unauthenticated);
    return result.error;
  }

  /// Logs in to an existing account.
  ///
  /// After successful login, auto-unlocks (or creates) the vault
  /// using the same password. Returns a [LoginResult] that may
  /// indicate 2FA is required.
  Future<LoginResult> logIn(String email, String password) async {
    state = const AsyncValue.data(AuthState.authenticating);

    final authService = ref.read(authServiceProvider);
    final result = await authService.logIn(
      email: email,
      password: password,
    );

    if (result.requires2fa) {
      // 2FA required — keep authenticating state, return factor info
      // Password is saved temporarily for vault unlock after MFA
      _pendingPassword = password;
      _pendingEmail = email;
      return LoginResult.needs2fa(
        factorId: result.factorId!,
        tempToken: result.tempToken,
      );
    }

    if (result.success) {
      final settings = ref.read(settingsNotifierProvider.notifier);
      await settings.set(SettingsKeys.authMode, 'cloud');
      await settings.set(SettingsKeys.userEmail, email.toLowerCase().trim());

      // Auto-unlock or create vault with account password
      await _autoUnlockOrCreateVault(password);

      state = const AsyncValue.data(AuthState.authenticated);
      return const LoginResult.success();
    }

    state = const AsyncValue.data(AuthState.unauthenticated);
    return LoginResult.failure(result.error ?? 'Login failed');
  }

  // Temporarily held for vault unlock after MFA verification.
  String? _pendingPassword;
  String? _pendingEmail;

  /// Completes login after successful MFA verification.
  Future<void> completeMfaLogin() async {
    final password = _pendingPassword;
    final email = _pendingEmail;
    _pendingPassword = null;
    _pendingEmail = null;

    if (email != null) {
      final settings = ref.read(settingsNotifierProvider.notifier);
      await settings.set(SettingsKeys.authMode, 'cloud');
      await settings.set(SettingsKeys.userEmail, email.toLowerCase().trim());
    }

    if (password != null) {
      await _autoUnlockOrCreateVault(password);
    }

    state = const AsyncValue.data(AuthState.authenticated);
  }

  /// Cancels a pending MFA login (user backed out).
  void cancelMfaLogin() {
    _pendingPassword = null;
    _pendingEmail = null;
    state = const AsyncValue.data(AuthState.unauthenticated);
  }

  /// Logs out and clears all auth state.
  Future<void> logOut() async {
    final authService = ref.read(authServiceProvider);
    await authService.logOut();

    // Force-lock vault and clear cached keys on logout
    ref.read(vaultProvider.notifier).forceLock();

    final settings = ref.read(settingsNotifierProvider.notifier);
    await settings.delete(SettingsKeys.authMode);
    await settings.delete(SettingsKeys.userEmail);

    state = const AsyncValue.data(AuthState.unauthenticated);
  }

  /// Sets the app to local-only mode (no sync account).
  Future<void> setLocalOnly() async {
    final settings = ref.read(settingsNotifierProvider.notifier);
    await settings.set(SettingsKeys.authMode, 'local');

    state = const AsyncValue.data(AuthState.localOnly);
  }

  /// Switches from local-only back to unauthenticated (allows sign-in).
  Future<void> clearLocalOnly() async {
    final settings = ref.read(settingsNotifierProvider.notifier);
    await settings.delete(SettingsKeys.authMode);

    state = const AsyncValue.data(AuthState.unauthenticated);
  }

  // ---------------------------------------------------------------------------
  // Vault integration helpers
  // ---------------------------------------------------------------------------

  /// Creates a new vault using the account password.
  Future<void> _autoSetupVault(String password) async {
    try {
      final vaultNotifier = ref.read(vaultProvider.notifier);
      await vaultNotifier.setupVault(password);
      _log.i('Vault auto-created with account password');
    } catch (e, stackTrace) {
      _log.w('Failed to auto-create vault: $e', error: e, stackTrace: stackTrace);
    }
  }

  /// Unlocks an existing vault or creates one on a new device.
  ///
  /// If the vault was created with a different password (e.g. old
  /// master password from before unification), resets and recreates
  /// it with the account password.
  Future<void> _autoUnlockOrCreateVault(String password) async {
    try {
      final vaultNotifier = ref.read(vaultProvider.notifier);
      final vaultState = ref.read(vaultProvider).value;

      if (vaultState == VaultState.noVault) {
        // No vault locally — try to fetch config from server
        final fetched = await vaultNotifier.fetchVaultConfigFromServer();
        if (fetched) {
          final error = await vaultNotifier.unlock(password);
          if (error != null) {
            // Password mismatch — reset and recreate
            _log.i('Server vault password mismatch, recreating');
            await vaultNotifier.resetVault();
            await vaultNotifier.setupVault(password);
          }
        } else {
          // No vault anywhere — create a new one
          await vaultNotifier.setupVault(password);
        }
      } else if (vaultState == VaultState.locked) {
        // Try account password on existing vault
        final error = await vaultNotifier.unlock(password);
        if (error != null) {
          // Old vault had different password — reset and recreate
          _log.i('Old vault password mismatch, recreating with account password');
          await vaultNotifier.resetVault();
          await vaultNotifier.setupVault(password);
        }
      }
      // If already unlocked (e.g. auto-unlock from cached key), nothing to do
    } catch (e, stackTrace) {
      _log.w('Failed to auto-unlock vault: $e', error: e, stackTrace: stackTrace);
    }
  }
}

/// Provider for the auth state.
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Convenience provider: true when authenticated with a sync account.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.value == AuthState.authenticated;
});

/// Provides the current user's email (null if not authenticated).
final currentUserEmailProvider = FutureProvider<String?>((ref) async {
  final isAuth = ref.watch(isAuthenticatedProvider);
  if (!isAuth) return null;

  // Try backend first
  final backend = ref.read(authBackendProvider);
  if (backend?.currentUserEmail != null) {
    return backend!.currentUserEmail;
  }

  // Fall back to settings
  final db = ref.read(databaseProvider);
  return db.settingsDao.getValue(SettingsKeys.userEmail);
});

/// Provides the current auth mode as a string.
final authModeProvider = Provider<String>((ref) {
  final authState = ref.watch(authProvider);
  return switch (authState.value) {
    AuthState.authenticated => 'authenticated',
    AuthState.localOnly => 'local',
    _ => 'unauthenticated',
  };
});

/// Result of a login attempt.
///
/// Can indicate success, failure, or that 2FA verification is needed.
class LoginResult {
  const LoginResult.success()
      : error = null,
        needs2fa = false,
        factorId = null,
        tempToken = null;

  const LoginResult.failure(String message)
      : error = message,
        needs2fa = false,
        factorId = null,
        tempToken = null;

  const LoginResult.needs2fa({required this.factorId, this.tempToken})
      : error = null,
        needs2fa = true;

  final String? error;
  final bool needs2fa;
  final String? factorId;
  final String? tempToken;

  bool get isSuccess => error == null && !needs2fa;
}
