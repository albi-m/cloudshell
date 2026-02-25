/// Secure storage key constants for flutter_secure_storage.
///
/// These keys are used to store and retrieve sensitive data
/// from the platform keychain (iOS Keychain, Android Keystore,
/// Windows DPAPI). Never log or expose these key names in
/// production builds.
library;

/// Key names for the platform-secure key-value store.
///
/// All sensitive credentials and encryption keys are stored
/// under these keys using flutter_secure_storage.
abstract final class StorageKeys {
  // --- Database Encryption ---

  /// AES-256 key used to encrypt the local SQLCipher database.
  /// Generated once on first launch, stored in platform keychain.
  static const String dbEncryptionKey = 'cloudshell_db_encryption_key';

  // --- Vault Encryption ---

  /// Salt used for Argon2id key derivation from master password.
  /// Random 32 bytes, generated when vault is first created.
  static const String masterKeySalt = 'cloudshell_master_key_salt';

  /// Encrypted master key (encrypted with key derived from master password).
  /// Used to verify master password correctness on unlock.
  static const String encryptedMasterKey = 'cloudshell_encrypted_master_key';

  /// MAC key derived from master key via HKDF.
  /// Used for HMAC-SHA256 authentication of encrypted vault items.
  static const String macKey = 'cloudshell_mac_key';

  // --- SSH Keys ---

  /// Prefix for SSH private key storage. Actual key is "{prefix}_{keyId}".
  static const String sshKeyPrefix = 'cloudshell_ssh_key';

  /// Constructs the storage key for an SSH private key by its ID.
  static String sshPrivateKey(String keyId) => '${sshKeyPrefix}_$keyId';

  /// Prefix for SSH key passphrases. Actual key is "{prefix}_{keyId}".
  static const String sshPassphrasePrefix = 'cloudshell_ssh_passphrase';

  /// Constructs the storage key for an SSH key passphrase by its ID.
  static String sshPassphrase(String keyId) => '${sshPassphrasePrefix}_$keyId';

  // --- Host Passwords ---

  /// Prefix for host passwords stored in secure storage.
  static const String hostPasswordPrefix = 'cloudshell_host_password';

  /// Constructs the storage key for a host password by host ID.
  static String hostPassword(String hostId) => '${hostPasswordPrefix}_$hostId';

  // --- Auth Tokens ---

  /// JWT access token for sync API authentication.
  static const String accessToken = 'cloudshell_access_token';

  /// JWT refresh token for renewing access tokens.
  static const String refreshToken = 'cloudshell_refresh_token';

  // --- App State ---

  /// Whether the vault has been initialized (master password set).
  static const String vaultInitialized = 'cloudshell_vault_initialized';

  /// Whether onboarding has been completed.
  static const String onboardingComplete = 'cloudshell_onboarding_complete';

  /// Timestamp of last successful vault unlock (for auto-lock timeout).
  static const String lastUnlockTimestamp = 'cloudshell_last_unlock';

  // --- Biometric Vault Cache ---

  /// Master key cached behind biometric gate (base64, stored in
  /// flutter_secure_storage with biometric access control).
  static const String biometricMasterKey = 'cloudshell_biometric_vault_key';
}
