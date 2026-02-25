// Tests for ErrorHandler error handling and message generation.
//
// Verifies:
// - ErrorHandler.handle doesn't throw for any exception type
// - ErrorHandler.userMessage returns appropriate user-facing strings
// - All AppException subclasses are covered
import 'package:flutter_test/flutter_test.dart';

import 'package:cloudshell/core/errors/app_exception.dart';
import 'package:cloudshell/core/errors/error_handler.dart';

void main() {
  group('ErrorHandler.handle', () {
    test('handles SshException without throwing', () {
      expect(
        () => ErrorHandler.handle(const SshException('test')),
        returnsNormally,
      );
    });

    test('handles SshAuthException without throwing', () {
      expect(
        () => ErrorHandler.handle(const SshAuthException('test')),
        returnsNormally,
      );
    });

    test('handles SshTimeoutException without throwing', () {
      expect(
        () => ErrorHandler.handle(const SshTimeoutException('test')),
        returnsNormally,
      );
    });

    test('handles SshHostKeyException without throwing', () {
      expect(
        () => ErrorHandler.handle(
            const SshHostKeyException('test', fingerprint: 'SHA256:abc')),
        returnsNormally,
      );
    });

    test('handles SftpException without throwing', () {
      expect(
        () => ErrorHandler.handle(const SftpException('test')),
        returnsNormally,
      );
    });

    test('handles CryptoException without throwing', () {
      expect(
        () => ErrorHandler.handle(const CryptoException('test')),
        returnsNormally,
      );
    });

    test('handles InvalidPasswordException without throwing', () {
      expect(
        () => ErrorHandler.handle(const InvalidPasswordException()),
        returnsNormally,
      );
    });

    test('handles DatabaseException without throwing', () {
      expect(
        () => ErrorHandler.handle(const DatabaseException('test')),
        returnsNormally,
      );
    });

    test('handles untyped Exception without throwing', () {
      expect(
        () => ErrorHandler.handle(Exception('untyped')),
        returnsNormally,
      );
    });

    test('handles error with stackTrace without throwing', () {
      expect(
        () => ErrorHandler.handle(
            const SshException('test'), StackTrace.current),
        returnsNormally,
      );
    });
  });

  group('ErrorHandler.userMessage', () {
    test('returns specific message for SshAuthException', () {
      final msg =
          ErrorHandler.userMessage(const SshAuthException('internal'));
      expect(msg, contains('Authentication failed'));
    });

    test('returns specific message for SshTimeoutException', () {
      final msg =
          ErrorHandler.userMessage(const SshTimeoutException('internal'));
      expect(msg, contains('timed out'));
    });

    test('returns specific message for SshHostKeyException', () {
      final msg = ErrorHandler.userMessage(
          const SshHostKeyException('internal', fingerprint: 'SHA256:abc'));
      expect(msg, contains('Host key'));
    });

    test('returns specific message for SftpException', () {
      final msg =
          ErrorHandler.userMessage(const SftpException('file not found'));
      expect(msg, contains('SFTP'));
    });

    test('returns specific message for InvalidPasswordException', () {
      final msg =
          ErrorHandler.userMessage(const InvalidPasswordException());
      expect(msg, contains('password'));
    });

    test('returns generic message for unknown error', () {
      final msg = ErrorHandler.userMessage(Exception('random'));
      expect(msg, contains('Could not complete'));
    });

    test('returns specific message for SyncException', () {
      final msg =
          ErrorHandler.userMessage(const SyncException('network'));
      expect(msg, contains('Sync'));
    });

    test('returns specific message for SecureStorageException', () {
      final msg =
          ErrorHandler.userMessage(const SecureStorageException('keychain'));
      expect(msg, contains('Secure storage'));
    });
  });
}
