// Tests for biometric authentication rate limiting.
//
// Verifies:
// - No lockout for fewer than 3 failures
// - 30s lockout after 3 consecutive failures
// - 2min lockout after 5 consecutive failures
// - 15min lockout after 10 consecutive failures
// - Lockout resets on successful authentication
// - isLockedOut and lockoutRemaining report correctly
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloudshell/providers/app_lock_provider.dart';

void main() {
  late ProviderContainer container;

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        biometricLockEnabledProvider.overrideWithValue(true),
        appLockGracePeriodProvider.overrideWithValue(0),
      ],
    );
  }

  setUp(() {
    container = createContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('Biometric rate limiting', () {
    test('no lockout for fewer than 3 failures', () {
      final notifier = container.read(appLockProvider.notifier);
      notifier.recordFailedAttempt();
      notifier.recordFailedAttempt();
      expect(notifier.isLockedOut, isFalse);
      expect(notifier.failedAttempts, 2);
    });

    test('lockout after 3 consecutive failures', () {
      final notifier = container.read(appLockProvider.notifier);
      for (var i = 0; i < 3; i++) {
        notifier.recordFailedAttempt();
      }
      expect(notifier.isLockedOut, isTrue);
      expect(notifier.failedAttempts, 3);
      // Should be 30s lockout
      expect(notifier.lockoutRemaining.inSeconds, greaterThanOrEqualTo(25));
      expect(notifier.lockoutRemaining.inSeconds, lessThanOrEqualTo(30));
    });

    test('lockout after 5 consecutive failures is 2 minutes', () {
      final notifier = container.read(appLockProvider.notifier);
      for (var i = 0; i < 5; i++) {
        notifier.recordFailedAttempt();
      }
      expect(notifier.isLockedOut, isTrue);
      expect(notifier.failedAttempts, 5);
      // Should be 2min lockout
      expect(notifier.lockoutRemaining.inSeconds, greaterThanOrEqualTo(115));
      expect(notifier.lockoutRemaining.inSeconds, lessThanOrEqualTo(120));
    });

    test('lockout after 10 consecutive failures is 15 minutes', () {
      final notifier = container.read(appLockProvider.notifier);
      for (var i = 0; i < 10; i++) {
        notifier.recordFailedAttempt();
      }
      expect(notifier.isLockedOut, isTrue);
      expect(notifier.failedAttempts, 10);
      // Should be 15min lockout
      expect(notifier.lockoutRemaining.inSeconds, greaterThanOrEqualTo(895));
      expect(notifier.lockoutRemaining.inSeconds, lessThanOrEqualTo(900));
    });

    test('successful auth resets failed attempts and lockout', () {
      final notifier = container.read(appLockProvider.notifier);
      for (var i = 0; i < 5; i++) {
        notifier.recordFailedAttempt();
      }
      expect(notifier.isLockedOut, isTrue);

      notifier.resetFailedAttempts();
      expect(notifier.isLockedOut, isFalse);
      expect(notifier.failedAttempts, 0);
      expect(notifier.lockoutRemaining, Duration.zero);
    });

    test('lockout is not active when deadline has passed', () {
      final notifier = container.read(appLockProvider.notifier);
      // Simulate 3 failures but with an already-expired lockout
      notifier.setLockoutForTest(
        failedAttempts: 3,
        lockoutUntil: DateTime.now().subtract(const Duration(seconds: 1)),
      );
      expect(notifier.isLockedOut, isFalse);
    });

    test('lockoutRemaining returns zero when not locked out', () {
      final notifier = container.read(appLockProvider.notifier);
      expect(notifier.lockoutRemaining, Duration.zero);
    });
  });
}
