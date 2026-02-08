/// Centralized error handler for CloudShell.
///
/// Provides consistent error logging and user-facing message
/// generation across all app domains.
library;

import 'package:logger/logger.dart';

import 'app_exception.dart';

/// Handles errors across the application with structured logging
/// and user-friendly message generation.
///
/// Usage:
/// ```dart
/// try {
///   await sshService.connect(host);
/// } on AppException catch (e) {
///   ErrorHandler.handle(e);
///   showSnackBar(ErrorHandler.userMessage(e));
/// }
/// ```
class ErrorHandler {
  ErrorHandler._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 80,
      noBoxingByDefault: true,
    ),
  );

  /// Logs the error with appropriate severity level.
  static void handle(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      _handleAppException(error, stackTrace);
    } else {
      _logger.e('Unhandled error', error: error, stackTrace: stackTrace);
    }
  }

  /// Generates a user-friendly error message for display in UI.
  ///
  /// Strips technical details and provides actionable guidance
  /// where possible.
  static String userMessage(Object error) {
    if (error is SshAuthException) {
      return 'Authentication failed. Check your credentials and try again.';
    }
    if (error is SshTimeoutException) {
      return 'Connection timed out. Verify the server address and port.';
    }
    if (error is SshHostKeyException) {
      return 'Host key verification failed. The server identity could not be verified.';
    }
    if (error is SshException) {
      return 'SSH connection error: ${error.message}';
    }
    if (error is SftpException) {
      return 'File transfer error: ${error.message}';
    }
    if (error is InvalidPasswordException) {
      return 'Incorrect master password. Please try again.';
    }
    if (error is CryptoException) {
      return 'Encryption error. Your data may be corrupted.';
    }
    if (error is DatabaseException) {
      return 'Database error. Please restart the app.';
    }
    if (error is SyncException) {
      return 'Sync failed. Check your network connection.';
    }
    if (error is AuthException) {
      return 'Authentication error. Please sign in again.';
    }
    if (error is SecureStorageException) {
      return 'Secure storage error. Your keychain may be locked.';
    }
    if (error is KeyException) {
      return 'SSH key error: ${error.message}';
    }
    if (error is PortForwardException) {
      return 'Port forwarding error: ${error.message}';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  static void _handleAppException(AppException error, StackTrace? stackTrace) {
    switch (error) {
      case SshAuthException():
        _logger.w('SSH auth failed: ${error.message}');
      case SshTimeoutException():
        _logger.w('SSH timeout: ${error.message}');
      case SshHostKeyException():
        _logger.w('Host key mismatch: ${error.fingerprint}');
      case SshException():
        _logger.e('SSH error: ${error.message}', error: error.cause, stackTrace: stackTrace);
      case SftpException():
        _logger.e('SFTP error: ${error.message}', error: error.cause, stackTrace: stackTrace);
      case InvalidPasswordException():
        _logger.w('Invalid master password attempt');
      case CryptoException():
        _logger.e('Crypto error: ${error.message}', error: error.cause, stackTrace: stackTrace);
      case DatabaseException():
        _logger.e('DB error: ${error.message}', error: error.cause, stackTrace: stackTrace);
      case SyncException():
        _logger.w('Sync error: ${error.message}');
      case AuthException():
        _logger.w('Auth error: ${error.message}');
      case SecureStorageException():
        _logger.e(
          'Secure storage error: ${error.message}',
          error: error.cause,
          stackTrace: stackTrace,
        );
      case KeyException():
        _logger.e('Key error: ${error.message}', error: error.cause, stackTrace: stackTrace);
      case PortForwardException():
        _logger.e(
          'Port forward error: ${error.message}',
          error: error.cause,
          stackTrace: stackTrace,
        );
    }
  }
}
