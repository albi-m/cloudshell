/// Vault encryption service implementing the CloudShell zero-knowledge
/// key hierarchy.
///
/// Key derivation chain:
///   Master Password → Argon2id → Master Key (256-bit)
///   Master Key → HKDF("cloudshell-enc") → EncKey (256-bit)
///   Master Key → HKDF("cloudshell-mac") → MACKey (256-bit)
///
/// Per-item encryption:
///   ItemKey = random AES-256
///   EncryptedData = AES-GCM(ItemKey, plaintext)
///   EncryptedItemKey = AES-GCM(EncKey, ItemKey)
///   AuthTag = HMAC-SHA256(MACKey, EncryptedData ‖ EncryptedItemKey)
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Holds the derived vault keys (in-memory only, never persisted).
class VaultKeys {
  const VaultKeys({
    required this.masterKey,
    required this.encKey,
    required this.macKey,
  });

  /// The 256-bit master key derived from the password via Argon2id.
  final SecretKey masterKey;

  /// The 256-bit encryption key derived from master key via HKDF.
  final SecretKey encKey;

  /// The 256-bit MAC key derived from master key via HKDF.
  final SecretKey macKey;

  /// Wipes all key material from memory.
  void destroy() {
    masterKey.destroy();
    encKey.destroy();
    macKey.destroy();
  }
}

/// Result of per-item encryption.
class EncryptedItem {
  const EncryptedItem({
    required this.ciphertext,
    required this.nonce,
    required this.encryptedItemKey,
    required this.itemKeyNonce,
    required this.hmac,
  });

  /// AES-256-GCM encrypted data (base64, includes GCM auth tag).
  final String ciphertext;

  /// Nonce used for data encryption (base64, 12 bytes).
  final String nonce;

  /// AES-256-GCM encrypted per-item key (base64, includes GCM auth tag).
  final String encryptedItemKey;

  /// Nonce used for item key encryption (base64, 12 bytes).
  final String itemKeyNonce;

  /// HMAC-SHA256 over ciphertext ‖ encryptedItemKey (base64).
  final String hmac;

  /// Serializes to a JSON-compatible map.
  Map<String, String> toMap() => {
        'ct': ciphertext,
        'n': nonce,
        'ek': encryptedItemKey,
        'ekn': itemKeyNonce,
        'h': hmac,
      };

  /// Deserializes from a JSON-compatible map.
  factory EncryptedItem.fromMap(Map<String, dynamic> map) => EncryptedItem(
        ciphertext: map['ct'] as String,
        nonce: map['n'] as String,
        encryptedItemKey: map['ek'] as String,
        itemKeyNonce: map['ekn'] as String,
        hmac: map['h'] as String,
      );

  /// Serializes to a single JSON string.
  String toJson() => jsonEncode(toMap());

  /// Deserializes from a JSON string.
  factory EncryptedItem.fromJson(String json) =>
      EncryptedItem.fromMap(jsonDecode(json) as Map<String, dynamic>);
}

/// Stateless cryptographic operations for the vault.
///
/// All methods are pure functions operating on inputs — no internal
/// state. The calling service (VaultProvider) manages key lifecycle.
class VaultCryptoService {
  static final _log = Logger();

  // Argon2id parameters matching the security plan (release builds)
  static const int _argon2MemoryRelease = 65536; // 64 MB in KB
  static const int _argon2IterationsRelease = 3;
  static const int _argon2ParallelismRelease = 4;

  // Lightweight params for debug builds (pure Dart Argon2id is ~100x slower)
  static const int _argon2MemoryDebug = 1024; // 1 MB
  static const int _argon2IterationsDebug = 1;
  static const int _argon2ParallelismDebug = 1;

  static const int _argon2HashLength = 32; // 256 bits

  // Select parameters based on build mode
  static int get _argon2Memory =>
      kDebugMode ? _argon2MemoryDebug : _argon2MemoryRelease;
  static int get _argon2Iterations =>
      kDebugMode ? _argon2IterationsDebug : _argon2IterationsRelease;
  static int get _argon2Parallelism =>
      kDebugMode ? _argon2ParallelismDebug : _argon2ParallelismRelease;

  /// Public accessors for KDF params (used by vault config sync).
  /// Always returns release params for server storage.
  static int get argon2Memory => _argon2MemoryRelease;
  static int get argon2Iterations => _argon2IterationsRelease;
  static int get argon2Parallelism => _argon2ParallelismRelease;

  static const int _saltLength = 16; // 128-bit salt

  /// Generates a cryptographically secure random salt (128-bit).
  Future<Uint8List> generateSalt() async {
    final key = await SecretKeyData.random(length: _saltLength).extract();
    return Uint8List.fromList(key.bytes);
  }

  /// Derives the master key from a password using Argon2id.
  ///
  /// Parameters match the security plan:
  /// - Memory: 64 MB
  /// - Iterations: 3
  /// - Parallelism: 4
  /// - Output: 256 bits
  Future<SecretKey> deriveMasterKey(String password, Uint8List salt) async {
    final algorithm = Argon2id(
      memory: _argon2Memory,
      parallelism: _argon2Parallelism,
      iterations: _argon2Iterations,
      hashLength: _argon2HashLength,
    );

    return algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
  }

  /// Expands the master key into EncKey and MACKey using HKDF-SHA256.
  ///
  /// EncKey = HKDF(masterKey, info="cloudshell-enc")
  /// MACKey = HKDF(masterKey, info="cloudshell-mac")
  Future<({SecretKey encKey, SecretKey macKey})> expandKey(
      SecretKey masterKey) async {
    final hkdfEnc = Hkdf(
      hmac: Hmac.sha256(),
      outputLength: 32,
    );
    final hkdfMac = Hkdf(
      hmac: Hmac.sha256(),
      outputLength: 32,
    );

    final encKey = await hkdfEnc.deriveKey(
      secretKey: masterKey,
      nonce: const <int>[],
      info: utf8.encode('cloudshell-enc'),
    );

    final macKey = await hkdfMac.deriveKey(
      secretKey: masterKey,
      nonce: const <int>[],
      info: utf8.encode('cloudshell-mac'),
    );

    return (encKey: encKey, macKey: macKey);
  }

  /// Derives the complete key set from a password and salt.
  Future<VaultKeys> deriveKeys(String password, Uint8List salt) async {
    final masterKey = await deriveMasterKey(password, salt);
    final expanded = await expandKey(masterKey);
    return VaultKeys(
      masterKey: masterKey,
      encKey: expanded.encKey,
      macKey: expanded.macKey,
    );
  }

  /// Creates a password verification hash.
  ///
  /// Encrypts a known constant with the enc key. If decryption succeeds
  /// on unlock, the password is correct.
  Future<({String ciphertext, String nonce})> createVerificationToken(
      SecretKey encKey) async {
    const verificationPlaintext = 'CLOUDSHELL_VAULT_VERIFICATION_v1';
    final algorithm = AesGcm.with256bits();
    final secretBox = await algorithm.encryptString(
      verificationPlaintext,
      secretKey: encKey,
    );
    return (
      ciphertext:
          base64Encode(secretBox.concatenation(nonce: false, mac: true)),
      nonce: base64Encode(secretBox.nonce),
    );
  }

  /// Verifies a password by attempting to decrypt the verification token.
  ///
  /// Returns true if the password is correct.
  Future<bool> verifyPassword(
    SecretKey encKey,
    String ciphertextBase64,
    String nonceBase64,
  ) async {
    try {
      final algorithm = AesGcm.with256bits();
      final ciphertextAndMac = base64Decode(ciphertextBase64);
      final nonce = base64Decode(nonceBase64);

      const macLength = 16;
      final ciphertext =
          ciphertextAndMac.sublist(0, ciphertextAndMac.length - macLength);
      final mac = Mac(
          ciphertextAndMac.sublist(ciphertextAndMac.length - macLength));

      final secretBox = SecretBox(ciphertext, nonce: nonce, mac: mac);
      final cleartext = await algorithm.decrypt(secretBox, secretKey: encKey);
      final decoded = utf8.decode(cleartext);
      return decoded == 'CLOUDSHELL_VAULT_VERIFICATION_v1';
    } catch (e, stackTrace) {
      _log.d('Password verification failed', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Encrypts a vault item with a random per-item key.
  ///
  /// The per-item key is itself encrypted with the vault EncKey,
  /// and the entire package is authenticated with HMAC-SHA256 using MACKey.
  Future<EncryptedItem> encryptItem(
    String plaintext,
    SecretKey encKey,
    SecretKey macKey,
  ) async {
    final aes = AesGcm.with256bits();
    final hmacAlgo = Hmac.sha256();

    // Generate random per-item key (AES-256)
    final itemKey = await aes.newSecretKey();

    // Encrypt data with per-item key
    final dataBox = await aes.encryptString(plaintext, secretKey: itemKey);
    final dataCiphertext =
        dataBox.concatenation(nonce: false, mac: true);
    final dataNonce = dataBox.nonce;

    // Encrypt the per-item key with vault EncKey
    final itemKeyBytes = await itemKey.extractBytes();
    final keyBox = await aes.encrypt(
      itemKeyBytes,
      secretKey: encKey,
    );
    final keyCiphertext =
        keyBox.concatenation(nonce: false, mac: true);
    final keyNonce = keyBox.nonce;

    // HMAC-SHA256 over ciphertext ‖ encryptedItemKey
    final hmacInput = Uint8List.fromList([...dataCiphertext, ...keyCiphertext]);
    final mac = await hmacAlgo.calculateMac(
      hmacInput,
      secretKey: macKey,
    );

    return EncryptedItem(
      ciphertext: base64Encode(dataCiphertext),
      nonce: base64Encode(dataNonce),
      encryptedItemKey: base64Encode(keyCiphertext),
      itemKeyNonce: base64Encode(keyNonce),
      hmac: base64Encode(mac.bytes),
    );
  }

  /// Decrypts a vault item by first verifying HMAC, then decrypting
  /// the per-item key with EncKey, then decrypting data with the item key.
  Future<String> decryptItem(
    EncryptedItem item,
    SecretKey encKey,
    SecretKey macKey,
  ) async {
    final aes = AesGcm.with256bits();
    final hmacAlgo = Hmac.sha256();

    final dataCiphertext = base64Decode(item.ciphertext);
    final dataNonce = base64Decode(item.nonce);
    final keyCiphertext = base64Decode(item.encryptedItemKey);
    final keyNonce = base64Decode(item.itemKeyNonce);
    final storedHmac = base64Decode(item.hmac);

    // Verify HMAC
    final hmacInput = Uint8List.fromList([...dataCiphertext, ...keyCiphertext]);
    final computedMac = await hmacAlgo.calculateMac(
      hmacInput,
      secretKey: macKey,
    );
    if (!_constantTimeEquals(
        Uint8List.fromList(computedMac.bytes), storedHmac)) {
      throw const FormatException('HMAC verification failed — data tampered');
    }

    // Decrypt per-item key
    const macLen = 16;
    final keyPlain =
        keyCiphertext.sublist(0, keyCiphertext.length - macLen);
    final keyMac =
        Mac(keyCiphertext.sublist(keyCiphertext.length - macLen));
    final keyBox = SecretBox(keyPlain, nonce: keyNonce, mac: keyMac);
    final itemKeyBytes = await aes.decrypt(keyBox, secretKey: encKey);
    final itemKey = SecretKey(itemKeyBytes);

    // Decrypt data with per-item key
    final dataPlain =
        dataCiphertext.sublist(0, dataCiphertext.length - macLen);
    final dataMac =
        Mac(dataCiphertext.sublist(dataCiphertext.length - macLen));
    final dataBox = SecretBox(dataPlain, nonce: dataNonce, mac: dataMac);
    final plainBytes = await aes.decrypt(dataBox, secretKey: itemKey);
    return utf8.decode(plainBytes);
  }

  /// Constant-time comparison to prevent timing attacks.
  bool _constantTimeEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }

  /// Computes the auth hash for server authentication.
  ///
  /// AuthHash = PBKDF2-SHA256(masterKey, salt=email, 1 iteration)
  /// This will be sent to the server for login (Phase 3 Sprint 19-20).
  Future<Uint8List> computeAuthHash(
      SecretKey masterKey, String email) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 1, // Already derived from Argon2id
      bits: 256,
    );
    final authKey = await pbkdf2.deriveKey(
      secretKey: masterKey,
      nonce: utf8.encode(email.toLowerCase().trim()),
    );
    final bytes = await authKey.extractBytes();
    return Uint8List.fromList(bytes);
  }
}

/// Riverpod provider for the vault crypto service.
final vaultCryptoServiceProvider = Provider<VaultCryptoService>((ref) {
  return VaultCryptoService();
});
