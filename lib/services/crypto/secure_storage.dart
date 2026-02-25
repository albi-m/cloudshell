/// Platform secure storage wrapper for CloudShell.
///
/// Stores sensitive data (SSH keys, passwords, tokens) encrypted
/// with AES-256-GCM in the local Drift database. This replaces
/// flutter_secure_storage to avoid macOS keychain password prompts
/// that occur with ad-hoc code signing on every rebuild.
///
/// The encryption key is derived from the machine's hardware UUID,
/// so secrets are device-bound. The database file is protected by
/// macOS file permissions and the user's login password.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/errors/app_exception.dart';
import '../../data/database/app_database.dart';
import 'app_crypto_service.dart';

/// Wrapper around encrypted Drift database storage with typed
/// accessors for CloudShell's secure data storage needs.
///
/// All sensitive material (private keys, passwords, encryption keys,
/// auth tokens) flows through this service. Data is encrypted with
/// AES-256-GCM before being stored in the database.
class SecureStorageService {
  SecureStorageService({
    required AppDatabase db,
    required AppCryptoService crypto,
  })  : _db = db,
        _crypto = crypto;

  final AppDatabase _db;
  final AppCryptoService _crypto;

  // ---------------------------------------------------------------------------
  // SSH Private Keys
  // ---------------------------------------------------------------------------

  /// Stores an SSH private key encrypted in the database.
  Future<void> storeSshPrivateKey(String keyId, String privateKeyPem) async {
    try {
      await _writeSecret(StorageKeys.sshPrivateKey(keyId), privateKeyPem);
    } catch (e) {
      throw SecureStorageException(
          'Failed to store SSH private key: ${e.runtimeType}', e);
    }
  }

  /// Retrieves an SSH private key from the database.
  Future<String?> getSshPrivateKey(String keyId) async {
    try {
      return await _readSecret(StorageKeys.sshPrivateKey(keyId));
    } catch (e) {
      throw SecureStorageException('Failed to read SSH private key', e);
    }
  }

  /// Deletes an SSH private key from the database.
  Future<void> deleteSshPrivateKey(String keyId) async {
    try {
      await _deleteSecret(StorageKeys.sshPrivateKey(keyId));
      // Also delete passphrase if one exists
      await _deleteSecret(StorageKeys.sshPassphrase(keyId));
    } catch (e) {
      throw SecureStorageException('Failed to delete SSH private key', e);
    }
  }

  /// Stores a passphrase for an SSH private key.
  Future<void> storeSshPassphrase(String keyId, String passphrase) async {
    try {
      await _writeSecret(StorageKeys.sshPassphrase(keyId), passphrase);
    } catch (e) {
      throw SecureStorageException('Failed to store SSH passphrase', e);
    }
  }

  /// Retrieves a passphrase for an SSH private key.
  Future<String?> getSshPassphrase(String keyId) async {
    try {
      return await _readSecret(StorageKeys.sshPassphrase(keyId));
    } catch (e) {
      throw SecureStorageException('Failed to read SSH passphrase', e);
    }
  }

  // ---------------------------------------------------------------------------
  // Host Passwords
  // ---------------------------------------------------------------------------

  /// Stores a host connection password.
  Future<void> storeHostPassword(String hostId, String password) async {
    try {
      await _writeSecret(StorageKeys.hostPassword(hostId), password);
    } catch (e) {
      throw SecureStorageException('Failed to store host password', e);
    }
  }

  /// Retrieves a host connection password.
  Future<String?> getHostPassword(String hostId) async {
    try {
      return await _readSecret(StorageKeys.hostPassword(hostId));
    } catch (e) {
      throw SecureStorageException('Failed to read host password', e);
    }
  }

  /// Deletes a host connection password.
  Future<void> deleteHostPassword(String hostId) async {
    try {
      await _deleteSecret(StorageKeys.hostPassword(hostId));
    } catch (e) {
      throw SecureStorageException('Failed to delete host password', e);
    }
  }

  // ---------------------------------------------------------------------------
  // Generic Key-Value
  // ---------------------------------------------------------------------------

  /// Reads a raw value by key.
  Future<String?> read(String key) async {
    try {
      return await _readSecret(key);
    } catch (e) {
      throw SecureStorageException('Failed to read from secure storage', e);
    }
  }

  /// Writes a raw value by key.
  Future<void> write(String key, String value) async {
    try {
      await _writeSecret(key, value);
    } catch (e) {
      throw SecureStorageException('Failed to write to secure storage', e);
    }
  }

  /// Deletes a value by key.
  Future<void> delete(String key) async {
    try {
      await _deleteSecret(key);
    } catch (e) {
      throw SecureStorageException('Failed to delete from secure storage', e);
    }
  }

  /// Checks whether a key exists in secure storage.
  Future<bool> containsKey(String key) async {
    try {
      return await _db.secretsDao.containsSecret(key);
    } catch (e) {
      throw SecureStorageException('Failed to check secure storage key', e);
    }
  }

  // ---------------------------------------------------------------------------
  // Internal encrypt/decrypt helpers
  // ---------------------------------------------------------------------------

  Future<void> _writeSecret(String key, String plaintext) async {
    final encrypted = await _crypto.encrypt(plaintext);
    await _db.secretsDao.setSecret(key, encrypted.ciphertext, encrypted.nonce);
  }

  Future<String?> _readSecret(String key) async {
    final row = await _db.secretsDao.getSecret(key);
    if (row == null) return null;
    return await _crypto.decrypt(row.encryptedValue, row.nonce);
  }

  Future<void> _deleteSecret(String key) async {
    await _db.secretsDao.deleteSecret(key);
  }
}

/// Riverpod provider for the secure storage service singleton.
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  final db = ref.watch(databaseProvider);
  final crypto = ref.watch(appCryptoServiceProvider);
  return SecureStorageService(db: db, crypto: crypto);
});
