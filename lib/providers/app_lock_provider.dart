/// Riverpod providers for app-level biometric lock.
///
/// Manages the lock state, biometric authentication via local_auth,
/// and auto-lock on app background. One biometric check unlocks the
/// app for the session — individual keychain reads are silent.
/// Supports a configurable grace period before locking on background.
library;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import 'settings_provider.dart';

/// Settings key for biometric lock enabled/disabled.
const String _biometricLockKey = 'biometric_lock_enabled';

/// Settings key for the app lock grace period in seconds.
const String _appLockGracePeriodKey = 'app_lock_grace_period';

/// Whether the biometric lock feature is enabled by the user.
final biometricLockEnabledProvider = Provider<bool>((ref) {
  final setting = ref.watch(settingProvider(_biometricLockKey));
  return setting.when(
    data: (value) => value == 'true',
    loading: () => false,
    error: (_, _) => false,
  );
});

/// Grace period in seconds before locking when app goes to background.
///
/// Options: 0 (immediate), 30, 60, 300 (5m), 900 (15m).
/// Default: 0 (lock immediately for backward compatibility).
final appLockGracePeriodProvider = Provider<int>((ref) {
  final setting = ref.watch(settingProvider(_appLockGracePeriodKey));
  return setting.when(
    data: (value) => int.tryParse(value ?? '') ?? 0,
    loading: () => 0,
    error: (_, _) => 0,
  );
});

/// Toggles the biometric lock setting on/off.
Future<void> setBiometricLockEnabled(WidgetRef ref, bool enabled) async {
  await ref
      .read(settingsNotifierProvider.notifier)
      .set(_biometricLockKey, enabled ? 'true' : 'false');
}

/// The current lock state of the app.
enum AppLockState {
  /// App is unlocked — normal usage.
  unlocked,

  /// App is locked — show lock screen.
  locked,

  /// Biometric prompt is being shown.
  authenticating,
}

/// Manages the app lock lifecycle.
///
/// When biometric lock is enabled:
/// - App starts locked
/// - User authenticates via Touch ID / Face ID
/// - App stays unlocked until backgrounded
/// - When app goes to background, a grace period timer starts
/// - If user returns before timer fires, lock is cancelled
/// - After grace period expires, app locks
///
/// When biometric lock is disabled:
/// - App is always unlocked, no prompts ever
class AppLockNotifier extends Notifier<AppLockState> {
  final _localAuth = LocalAuthentication();

  /// Timer for the grace period before locking.
  Timer? _lockTimer;

  @override
  AppLockState build() {
    final biometricEnabled = ref.watch(biometricLockEnabledProvider);
    if (!biometricEnabled) return AppLockState.unlocked;
    return AppLockState.locked;
  }

  /// Attempts biometric authentication. Returns true if successful.
  Future<bool> authenticate() async {
    if (state == AppLockState.unlocked) return true;

    state = AppLockState.authenticating;

    try {
      final canAuthenticate = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        // Device doesn't support biometrics — unlock anyway
        state = AppLockState.unlocked;
        return true;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock CloudShell',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allow PIN/password fallback
        ),
      );

      if (authenticated) {
        state = AppLockState.unlocked;
        return true;
      } else {
        state = AppLockState.locked;
        return false;
      }
    } on PlatformException {
      // Auth not available — unlock to avoid locking user out
      state = AppLockState.unlocked;
      return true;
    }
  }

  /// Schedules locking after a grace period.
  ///
  /// Called when the app goes to background. If the user returns
  /// before the timer fires, [cancelScheduledLock] prevents locking.
  void scheduleLock(Duration gracePeriod) {
    final biometricEnabled = ref.read(biometricLockEnabledProvider);
    if (!biometricEnabled) return;

    // Cancel any existing timer
    _lockTimer?.cancel();

    _lockTimer = Timer(gracePeriod, () {
      lock();
    });
  }

  /// Cancels a pending lock timer (called when app returns to foreground).
  void cancelScheduledLock() {
    _lockTimer?.cancel();
    _lockTimer = null;
  }

  /// Locks the app immediately.
  void lock() {
    _lockTimer?.cancel();
    _lockTimer = null;
    final biometricEnabled = ref.read(biometricLockEnabledProvider);
    if (biometricEnabled) {
      state = AppLockState.locked;
    }
  }

  /// Unlocks without authentication (for programmatic use).
  void unlock() {
    cancelScheduledLock();
    state = AppLockState.unlocked;
  }

  /// Checks if biometrics are available on this device.
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
    } catch (e, stackTrace) {
      // Log but don't crash — biometric check is best-effort
      assert(() {
        // ignore: avoid_print
        print('Biometric check failed: $e\n$stackTrace');
        return true;
      }());
      return false;
    }
  }
}

/// Provider for the app lock state.
final appLockProvider = NotifierProvider<AppLockNotifier, AppLockState>(
  AppLockNotifier.new,
);
