/// Custom exception hierarchy for CloudShell.
///
/// Provides typed exceptions for different failure domains,
/// enabling structured error handling throughout the app.
library;

/// Base exception class for all CloudShell errors.
///
/// All domain-specific exceptions extend this class to allow
/// catching any app error with a single type.
sealed class AppException implements Exception {
  const AppException(this.message, [this.cause]);

  /// Human-readable error description.
  final String message;

  /// Optional underlying error that caused this exception.
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

/// SSH connection and session errors.
class SshException extends AppException {
  const SshException(super.message, [super.cause]);
}

/// SSH authentication failures (wrong password, rejected key, etc.).
class SshAuthException extends SshException {
  const SshAuthException(super.message, [super.cause]);
}

/// SSH connection timeout.
class SshTimeoutException extends SshException {
  const SshTimeoutException(super.message, [super.cause]);
}

/// SSH host key verification failure.
class SshHostKeyException extends SshException {
  const SshHostKeyException(
    String message, {
    required this.fingerprint,
    Object? cause,
  }) : super(message, cause);

  /// The SHA256 fingerprint of the unverified host key.
  final String fingerprint;
}

/// SFTP file transfer errors.
class SftpException extends AppException {
  const SftpException(super.message, [super.cause]);
}

/// Vault encryption/decryption errors.
class CryptoException extends AppException {
  const CryptoException(super.message, [super.cause]);
}

/// Master password verification failure.
class InvalidPasswordException extends CryptoException {
  const InvalidPasswordException() : super('Invalid master password');
}

/// Local database errors.
class DatabaseException extends AppException {
  const DatabaseException(super.message, [super.cause]);
}

/// Sync service errors (network, conflict, etc.).
class SyncException extends AppException {
  const SyncException(super.message, [super.cause]);
}

/// Authentication errors (login, token refresh, etc.).
class AuthException extends AppException {
  const AuthException(super.message, [super.cause]);
}

/// Platform-specific secure storage errors.
class SecureStorageException extends AppException {
  const SecureStorageException(super.message, [super.cause]);
}

/// SSH key generation or import errors.
class KeyException extends AppException {
  const KeyException(super.message, [super.cause]);
}

/// Port forwarding errors.
class PortForwardException extends AppException {
  const PortForwardException(super.message, [super.cause]);
}

/// Cloud provider import errors (AWS, DigitalOcean, etc.).
class CloudImportException extends AppException {
  const CloudImportException(super.message, [super.cause]);
}
