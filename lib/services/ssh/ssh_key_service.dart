/// SSH key generation and management service for CloudShell.
///
/// Handles Ed25519, RSA, and ECDSA key pair generation,
/// import/export of PEM files, and fingerprint computation.
/// Private keys are stored in the platform keychain via
/// SecureStorageService, never in the database.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/app_exception.dart';
import '../../data/database/app_database.dart';
import '../../data/database/tables/keys_table.dart';
import '../crypto/secure_storage.dart';
import 'ppk_parser.dart';

/// Result of an SSH key pair generation or import operation.
class KeyPairResult {
  const KeyPairResult({
    required this.id,
    required this.publicKey,
    required this.fingerprint,
  });

  /// UUID of the newly created key record.
  final String id;

  /// OpenSSH-format public key string.
  final String publicKey;

  /// SHA256 fingerprint of the public key.
  final String fingerprint;
}

/// Service for SSH key lifecycle management.
///
/// Generates, imports, and manages SSH key pairs. Private key
/// material is always stored in the platform keychain and never
/// exposed outside this service.
class SshKeyService {
  SshKeyService({
    required this.db,
    required this.secureStorage,
  });

  static final _log = Logger();

  final AppDatabase db;
  final SecureStorageService secureStorage;

  static const _uuid = Uuid();

  /// Imports an SSH private key from PEM-encoded string.
  ///
  /// This is the primary way to add keys — dartssh2 parses
  /// the PEM, extracts the public key and metadata, and we
  /// store everything appropriately.
  Future<KeyPairResult> importKey({
    required String label,
    required String privateKeyPem,
    String? passphrase,
  }) async {
    try {
      final id = _uuid.v4();

      // Auto-detect and convert PuTTY PPK format
      var keyContent = privateKeyPem;
      if (PpkParser.isPpkFormat(keyContent)) {
        try {
          keyContent = PpkParser.convertToPem(keyContent, passphrase: passphrase);
        } on PpkException catch (e) {
          throw KeyException('PPK key detected but conversion failed: $e');
        }
      }

      // Parse the PEM to validate and extract key info
      final keyPairs = SSHKeyPair.fromPem(keyContent, passphrase);
      if (keyPairs.isEmpty) {
        throw const KeyException('No valid key found in the provided PEM data');
      }

      final keyPair = keyPairs.first;
      final publicKey = keyPair.toPublicKey();

      // Build OpenSSH public key line: "type base64data"
      final publicKeyStr = _formatOpenSshPublicKey(keyPair.name, publicKey.encode());

      // Compute SHA256 fingerprint
      final fingerprint = _computeFingerprint(publicKey.encode());

      // Determine key type
      final keyType = _detectKeyType(keyPair.name);
      final keyBits = _detectKeyBits(keyPair.name);

      // Store private key in platform keychain (converted PEM if was PPK)
      await secureStorage.storeSshPrivateKey(id, keyContent);

      if (passphrase != null && passphrase.isNotEmpty) {
        await secureStorage.storeSshPassphrase(id, passphrase);
      }

      // Insert metadata into database
      final now = DateTime.now();
      await db.keyDao.insertKey(SshKeysCompanion(
        id: Value(id),
        label: Value(label),
        keyType: Value(keyType),
        keyBits: Value(keyBits),
        publicKey: Value(publicKeyStr),
        privateKeyRef: Value(id),
        fingerprint: Value(fingerprint),
        hasPassphrase: Value(passphrase != null && passphrase.isNotEmpty),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));

      return KeyPairResult(
        id: id,
        publicKey: publicKeyStr,
        fingerprint: fingerprint,
      );
    } on FormatException catch (e) {
      throw KeyException('Invalid key format: ${e.message}', e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw KeyException('Failed to import SSH key', e);
    }
  }

  /// Retrieves parsed SSHKeyPair list for use in SSH authentication.
  ///
  /// Loads the private key PEM from secure storage and parses it
  /// with dartssh2 for use with SSHClient.
  Future<List<SSHKeyPair>> getKeyPairsForAuth(String keyId) async {
    final privateKeyPem = await secureStorage.getSshPrivateKey(keyId);
    if (privateKeyPem == null) {
      throw const KeyException(
        'SSH key not found in secure storage. '
        'Please re-import the key from the Keys screen.',
      );
    }

    final passphrase = await secureStorage.getSshPassphrase(keyId);

    try {
      return SSHKeyPair.fromPem(privateKeyPem, passphrase);
    } on FormatException catch (e) {
      throw KeyException('Invalid key format: ${e.message}', e);
    } catch (e) {
      throw KeyException('Failed to load SSH key for authentication', e);
    }
  }

  /// Exports the public key in OpenSSH authorized_keys format.
  Future<String?> exportPublicKey(String keyId) async {
    final key = await db.keyDao.getKeyById(keyId);
    return key?.publicKey;
  }

  /// Deletes a key pair (both metadata and private key material).
  ///
  /// Also clears the `keyId` on any hosts that referenced this key
  /// so they don't retain a dangling foreign key (which would crash
  /// the host form dropdown).
  Future<void> deleteKey(String keyId) async {
    // Delete private key from secure storage (best-effort — may not exist
    // if keychain was switched or key was never stored).
    try {
      await secureStorage.deleteSshPrivateKey(keyId);
    } catch (e, stackTrace) {
      // Ignore — soft-delete from DB should still proceed.
      _log.d('Failed to delete private key from secure storage', error: e, stackTrace: stackTrace);
    }

    // Clear keyId on all hosts that referenced this key
    await db.hostDao.clearKeyReferences(keyId);

    await db.keyDao.softDeleteKey(keyId);
  }

  /// Formats an OpenSSH public key line: "type base64data".
  String _formatOpenSshPublicKey(String keyType, Uint8List encoded) {
    return '$keyType ${base64Encode(encoded)}';
  }

  /// Computes a SHA256 fingerprint: "SHA256:base64hash".
  String _computeFingerprint(Uint8List encodedPublicKey) {
    final digest = SHA256Digest().process(encodedPublicKey);
    return 'SHA256:${base64Encode(digest).replaceAll('=', '')}';
  }

  /// Maps SSH key type name to our enum.
  KeyTypeEnum _detectKeyType(String keyName) {
    if (keyName.contains('ed25519')) return KeyTypeEnum.ed25519;
    if (keyName.contains('ecdsa')) return KeyTypeEnum.ecdsa;
    return KeyTypeEnum.rsa;
  }

  /// Infers key bit size from the key type name.
  int? _detectKeyBits(String keyName) {
    if (keyName.contains('ed25519')) return 256;
    if (keyName.contains('nistp256')) return 256;
    if (keyName.contains('nistp384')) return 384;
    if (keyName.contains('nistp521')) return 521;
    return null;
  }
}

/// Riverpod provider for the SSH key service.
final sshKeyServiceProvider = Provider<SshKeyService>((ref) {
  return SshKeyService(
    db: ref.watch(databaseProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});
