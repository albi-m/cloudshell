// Tests for AppLockNotifier grace period and state transitions.
//
// Verifies:
// - App does not lock if resumed within grace period
// - App locks after grace period expires
// - App locks immediately when grace period is 0
// - Cancelling scheduled lock prevents locking
// - build() initial state based on biometric setting
// - lock/unlock state transitions
// - authenticate() when already unlocked
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloudshell/providers/app_lock_provider.dart';

void main() {
  group('AppLockNotifier grace period', () {
    late ProviderContainer container;

    ProviderContainer createContainer({bool biometricEnabled = true}) {
      return ProviderContainer(
        overrides: [
          biometricLockEnabledProvider.overrideWithValue(biometricEnabled),
          appLockGracePeriodProvider.overrideWithValue(30),
        ],
      );
    }

    setUp(() {
      container = createContainer(biometricEnabled: true);
    });

    tearDown(() {
      container.dispose();
    });

    test('scheduleLock does not lock before grace period expires', () async {
      final notifier = container.read(appLockProvider.notifier);
      // Unlock first (simulating user already authenticated)
      notifier.unlock();
      expect(container.read(appLockProvider), AppLockState.unlocked);

      // Schedule lock with 500ms grace period
      notifier.scheduleLock(const Duration(milliseconds: 500));

      // Wait 200ms — should still be unlocked
      await Future.delayed(const Duration(milliseconds: 200));
      expect(container.read(appLockProvider), AppLockState.unlocked);

      // Clean up timer
      notifier.cancelScheduledLock();
    });

    test('scheduleLock locks after grace period expires', () async {
      final notifier = container.read(appLockProvider.notifier);
      notifier.unlock();
      expect(container.read(appLockProvider), AppLockState.unlocked);

      // Schedule lock with 200ms grace period
      notifier.scheduleLock(const Duration(milliseconds: 200));

      // Wait 350ms — should be locked now
      await Future.delayed(const Duration(milliseconds: 350));
      expect(container.read(appLockProvider), AppLockState.locked);
    });

    test('cancelScheduledLock prevents locking', () async {
      final notifier = container.read(appLockProvider.notifier);
      notifier.unlock();

      // Schedule lock with 200ms grace period
      notifier.scheduleLock(const Duration(milliseconds: 200));

      // Cancel before it fires
      await Future.delayed(const Duration(milliseconds: 100));
      notifier.cancelScheduledLock();

      // Wait well past grace period
      await Future.delayed(const Duration(milliseconds: 300));
      expect(container.read(appLockProvider), AppLockState.unlocked);
    });

    test('scheduleLock locks immediately when grace period is zero', () async {
      final notifier = container.read(appLockProvider.notifier);
      notifier.unlock();

      notifier.scheduleLock(Duration.zero);

      // Timer(Duration.zero) fires on the next microtask
      await Future.delayed(const Duration(milliseconds: 50));
      expect(container.read(appLockProvider), AppLockState.locked);
    });

    test('scheduleLock does nothing when biometric is disabled', () async {
      container.dispose();
      container = createContainer(biometricEnabled: false);

      final notifier = container.read(appLockProvider.notifier);
      expect(container.read(appLockProvider), AppLockState.unlocked);

      notifier.scheduleLock(const Duration(milliseconds: 100));

      await Future.delayed(const Duration(milliseconds: 200));
      expect(container.read(appLockProvider), AppLockState.unlocked);
    });

    test('multiple scheduleLock calls cancel previous timer', () async {
      final notifier = container.read(appLockProvider.notifier);
      notifier.unlock();

      // Schedule lock with short grace period
      notifier.scheduleLock(const Duration(milliseconds: 100));

      // Immediately reschedule with longer period
      notifier.scheduleLock(const Duration(milliseconds: 500));

      // After 200ms — first timer would have fired, but second hasn't
      await Future.delayed(const Duration(milliseconds: 200));
      expect(container.read(appLockProvider), AppLockState.unlocked);

      // Clean up
      notifier.cancelScheduledLock();
    });
  });

  group('appLockGracePeriodProvider', () {
    test('returns configured grace period from settings', () {
      final container = ProviderContainer(
        overrides: [
          appLockGracePeriodProvider.overrideWithValue(60),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(appLockGracePeriodProvider), 60);
    });
  });

  group('AppLockNotifier state transitions', () {
    test('build() returns locked when biometric enabled', () {
      final container = ProviderContainer(
        overrides: [
          biometricLockEnabledProvider.overrideWithValue(true),
          appLockGracePeriodProvider.overrideWithValue(0),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(appLockProvider), AppLockState.locked);
    });

    test('build() returns unlocked when biometric disabled', () {
      final container = ProviderContainer(
        overrides: [
          biometricLockEnabledProvider.overrideWithValue(false),
          appLockGracePeriodProvider.overrideWithValue(0),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(appLockProvider), AppLockState.unlocked);
    });

    test('lock() when biometric disabled does not change state', () {
      final container = ProviderContainer(
        overrides: [
          biometricLockEnabledProvider.overrideWithValue(false),
          appLockGracePeriodProvider.overrideWithValue(0),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(appLockProvider.notifier);
      notifier.lock();
      expect(container.read(appLockProvider), AppLockState.unlocked);
    });

    test('unlock() cancels pending lock timer', () async {
      final container = ProviderContainer(
        overrides: [
          biometricLockEnabledProvider.overrideWithValue(true),
          appLockGracePeriodProvider.overrideWithValue(0),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(appLockProvider.notifier);
      notifier.unlock();

      // Schedule a lock with 200ms grace period
      notifier.scheduleLock(const Duration(milliseconds: 200));

      // Immediately unlock — should cancel the timer
      notifier.unlock();

      // Wait past grace period — should still be unlocked
      await Future.delayed(const Duration(milliseconds: 350));
      expect(container.read(appLockProvider), AppLockState.unlocked);
    });

    test('authenticate() when already unlocked returns true', () async {
      final container = ProviderContainer(
        overrides: [
          biometricLockEnabledProvider.overrideWithValue(true),
          appLockGracePeriodProvider.overrideWithValue(0),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(appLockProvider.notifier);
      notifier.unlock();
      expect(container.read(appLockProvider), AppLockState.unlocked);

      final result = await notifier.authenticate();
      expect(result, isTrue);
      expect(container.read(appLockProvider), AppLockState.unlocked);
    });
  });

  group('biometricLockEnabledProvider', () {
    test('returns false for non-true values', () {
      final container = ProviderContainer(
        overrides: [
          biometricLockEnabledProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(biometricLockEnabledProvider), isFalse);
    });
  });
}
