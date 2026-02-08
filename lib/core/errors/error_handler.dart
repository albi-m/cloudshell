/// Centralized error handler for CloudShell.
///
/// Provides consistent error logging and user-facing message
/// generation across all app domains. Sensitive data (hostnames,
/// usernames, IPs) is never included in log output.
library;

import 'package:flutter/foundation.dart';
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
      methodCount: kDebugMode ? 2 : 0,
      errorMethodCount: kDebugMode ? 5 : 2,
      lineLength: 80,
      noBoxingByDefault: true,
    ),
    level: kDebugMode ? Level.debug : Level.warning,
  );

  /// Logs the error with appropriate severity level.
  ///
  /// Sensitive connection details (hostnames, usernames, IPs)
  /// are stripped from log output to prevent information leakage.
  static void handle(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      _handleAppException(error, stackTrace);
    } else {
      _logger.e('Unhandled error', error: error, stackTrace: stackTrace);
    }
  }

  /// Generates a user-friendly error message for display in UI.
  ///
  /// Strips technical details and provides actionable guidance.
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
      return 'SSH connection error. Please try again.';
    }
    if (error is SftpException) {
      return 'File transfer error. Please try again.';
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
      return 'SSH key error. Please check the key file.';
    }
    if (error is PortForwardException) {
      return 'Port forwarding error. Please try again.';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  /// Routes exceptions to the correct log level.
  ///
  /// Sensitive details are redacted: hostnames, usernames,
  /// and IP addresses are never logged.
  static void _handleAppException(AppException error, StackTrace? stackTrace) {
    switch (error) {
      case SshAuthException():
        _logger.w('SSH authentication failed');
      case SshTimeoutException():
        _logger.w('SSH connection timeout');
      case SshHostKeyException():
        _logger.w('Host key verification failed');
      case SshException():
        _logger.e('SSH error', error: error.cause, stackTrace: stackTrace);
      case SftpException():
        _logger.e('SFTP error', error: error.cause, stackTrace: stackTrace);
      case InvalidPasswordException():
        _logger.w('Invalid master password attempt');
      case CryptoException():
        _logger.e('Crypto error', error: error.cause, stackTrace: stackTrace);
      case DatabaseException():
        _logger.e('Database error', error: error.cause, stackTrace: stackTrace);
      case SyncException():
        _logger.w('Sync error');
      case AuthException():
        _logger.w('Auth error');
      case SecureStorageException():
        _logger.e(
          'Secure storage error',
          error: error.cause,
          stackTrace: stackTrace,
        );
      case KeyException():
        _logger.e('Key error', error: error.cause, stackTrace: stackTrace);
      case PortForwardException():
        _logger.e(
          'Port forward error',
          error: error.cause,
          stackTrace: stackTrace,
        );
    }
  }
}
