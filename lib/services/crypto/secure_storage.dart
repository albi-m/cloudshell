/// Platform secure storage wrapper for CloudShell.
///
/// Abstracts flutter_secure_storage operations and provides
/// typed methods for storing SSH keys, passwords, and tokens
/// in the platform keychain (iOS Keychain, Android Keystore,
/// Windows DPAPI).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/errors/app_exception.dart';

/// Wrapper around flutter_secure_storage with typed accessors
/// for CloudShell's secure data storage needs.
///
/// All sensitive material (private keys, passwords, encryption keys,
/// auth tokens) flows through this service. Data is encrypted
/// at rest by the platform's native secure enclave.
class SecureStorageService {
  SecureStorageService() : _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
    mOptions: MacOsOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  final FlutterSecureStorage _storage;

  // ---------------------------------------------------------------------------
  // SSH Private Keys
  // ---------------------------------------------------------------------------

  /// Stores an SSH private key in the platform keychain.
  Future<void> storeSshPrivateKey(String keyId, String privateKeyPem) async {
    try {
      await _storage.write(
        key: StorageKeys.sshPrivateKey(keyId),
        value: privateKeyPem,
      );
    } catch (e) {
      throw SecureStorageException('Failed to store SSH private key', e);
    }
  }

  /// Retrieves an SSH private key from the platform keychain.
  Future<String?> getSshPrivateKey(String keyId) async {
    try {
      return await _storage.read(key: StorageKeys.sshPrivateKey(keyId));
    } catch (e) {
      throw SecureStorageException('Failed to read SSH private key', e);
    }
  }

  /// Deletes an SSH private key from the platform keychain.
  Future<void> deleteSshPrivateKey(String keyId) async {
    try {
      await _storage.delete(key: StorageKeys.sshPrivateKey(keyId));
      // Also delete passphrase if one exists
      await _storage.delete(key: StorageKeys.sshPassphrase(keyId));
    } catch (e) {
      throw SecureStorageException('Failed to delete SSH private key', e);
    }
  }

  /// Stores a passphrase for an SSH private key.
  Future<void> storeSshPassphrase(String keyId, String passphrase) async {
    try {
      await _storage.write(
        key: StorageKeys.sshPassphrase(keyId),
        value: passphrase,
      );
    } catch (e) {
      throw SecureStorageException('Failed to store SSH passphrase', e);
    }
  }

  /// Retrieves a passphrase for an SSH private key.
  Future<String?> getSshPassphrase(String keyId) async {
    try {
      return await _storage.read(key: StorageKeys.sshPassphrase(keyId));
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
      await _storage.write(
        key: StorageKeys.hostPassword(hostId),
        value: password,
      );
    } catch (e) {
      throw SecureStorageException('Failed to store host password', e);
    }
  }

  /// Retrieves a host connection password.
  Future<String?> getHostPassword(String hostId) async {
    try {
      return await _storage.read(key: StorageKeys.hostPassword(hostId));
    } catch (e) {
      throw SecureStorageException('Failed to read host password', e);
    }
  }

  /// Deletes a host connection password.
  Future<void> deleteHostPassword(String hostId) async {
    try {
      await _storage.delete(key: StorageKeys.hostPassword(hostId));
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
      return await _storage.read(key: key);
    } catch (e) {
      throw SecureStorageException('Failed to read from secure storage', e);
    }
  }

  /// Writes a raw value by key.
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw SecureStorageException('Failed to write to secure storage', e);
    }
  }

  /// Deletes a value by key.
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw SecureStorageException('Failed to delete from secure storage', e);
    }
  }

  /// Checks whether a key exists in secure storage.
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      throw SecureStorageException('Failed to check secure storage key', e);
    }
  }
}

/// Riverpod provider for the secure storage service singleton.
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
