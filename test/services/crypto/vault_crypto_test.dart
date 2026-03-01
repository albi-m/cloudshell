// Unit tests for VaultCryptoService.
//
// Verifies:
// - Salt generation (16 bytes, unique)
// - Key derivation consistency (Argon2id + HKDF)
// - Encrypt/decrypt roundtrip for various data sizes
// - HMAC tamper detection
// - Verification token roundtrip
// - EncryptedItem serialization
// - Auth hash determinism
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:cloudshell/services/crypto/vault_crypto_service.dart';

void main() {
  late VaultCryptoService crypto;

  setUp(() {
    crypto = VaultCryptoService();
  });

  group('generateSalt', () {
    test('returns 16 bytes', () async {
      final salt = await crypto.generateSalt();
      expect(salt.length, 16);
    });

    test('each call returns unique salt', () async {
      final salt1 = await crypto.generateSalt();
      final salt2 = await crypto.generateSalt();
      expect(salt1, isNot(equals(salt2)));
    });
  });

  group('deriveMasterKey', () {
    test('same password and salt produces same key', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final key1 = await crypto.deriveMasterKey('testPassword123', salt);
      final key2 = await crypto.deriveMasterKey('testPassword123', salt);

      final bytes1 = await key1.extractBytes();
      final bytes2 = await key2.extractBytes();
      expect(bytes1, equals(bytes2));
    });

    test('different passwords produce different keys', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final key1 = await crypto.deriveMasterKey('password1', salt);
      final key2 = await crypto.deriveMasterKey('password2', salt);

      final bytes1 = await key1.extractBytes();
      final bytes2 = await key2.extractBytes();
      expect(bytes1, isNot(equals(bytes2)));
    });
  });

  group('expandKey', () {
    test('produces distinct encKey and macKey', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final masterKey = await crypto.deriveMasterKey('password', salt);
      final expanded = await crypto.expandKey(masterKey);

      final encBytes = await expanded.encKey.extractBytes();
      final macBytes = await expanded.macKey.extractBytes();
      expect(encBytes, isNot(equals(macBytes)));
    });

    test('same masterKey always produces same derived keys', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final masterKey = await crypto.deriveMasterKey('password', salt);
      final expanded1 = await crypto.expandKey(masterKey);
      final expanded2 = await crypto.expandKey(masterKey);

      final enc1 = await expanded1.encKey.extractBytes();
      final enc2 = await expanded2.encKey.extractBytes();
      expect(enc1, equals(enc2));

      final mac1 = await expanded1.macKey.extractBytes();
      final mac2 = await expanded2.macKey.extractBytes();
      expect(mac1, equals(mac2));
    });
  });

  group('deriveKeys', () {
    test('full pipeline produces valid VaultKeys with 32-byte keys', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final keys = await crypto.deriveKeys('TestPassword!', salt);

      final masterBytes = await keys.masterKey.extractBytes();
      final encBytes = await keys.encKey.extractBytes();
      final macBytes = await keys.macKey.extractBytes();

      expect(masterBytes.length, 32);
      expect(encBytes.length, 32);
      expect(macBytes.length, 32);
    });
  });

  group('verification token', () {
    test('createVerificationToken + verifyPassword roundtrip succeeds',
        () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final keys = await crypto.deriveKeys('CorrectPassword', salt);

      final token = await crypto.createVerificationToken(keys.encKey);
      final result = await crypto.verifyPassword(
        keys.encKey,
        token.ciphertext,
        token.nonce,
      );
      expect(result, isTrue);
    });

    test('verifyPassword with wrong key returns false', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final correctKeys = await crypto.deriveKeys('CorrectPassword', salt);
      final wrongKeys = await crypto.deriveKeys('WrongPassword', salt);

      final token = await crypto.createVerificationToken(correctKeys.encKey);
      final result = await crypto.verifyPassword(
        wrongKeys.encKey,
        token.ciphertext,
        token.nonce,
      );
      expect(result, isFalse);
    });
  });

  group('encryptItem / decryptItem', () {
    late VaultKeys keys;

    setUp(() async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      keys = await crypto.deriveKeys('TestPassword', salt);
    });

    test('roundtrip with small data', () async {
      const plaintext = 'Hello, Vault!';
      final encrypted =
          await crypto.encryptItem(plaintext, keys.encKey, keys.macKey);
      final decrypted =
          await crypto.decryptItem(encrypted, keys.encKey, keys.macKey);
      expect(decrypted, plaintext);
    });

    test('roundtrip with large data (10KB)', () async {
      final plaintext = 'A' * 10240;
      final encrypted =
          await crypto.encryptItem(plaintext, keys.encKey, keys.macKey);
      final decrypted =
          await crypto.decryptItem(encrypted, keys.encKey, keys.macKey);
      expect(decrypted, plaintext);
    });

    test('each encryption produces unique nonces', () async {
      const plaintext = 'Same data';
      final enc1 =
          await crypto.encryptItem(plaintext, keys.encKey, keys.macKey);
      final enc2 =
          await crypto.encryptItem(plaintext, keys.encKey, keys.macKey);

      expect(enc1.nonce, isNot(equals(enc2.nonce)));
      expect(enc1.ciphertext, isNot(equals(enc2.ciphertext)));
    });

    test('tampered HMAC throws FormatException', () async {
      const plaintext = 'Secret data';
      final encrypted =
          await crypto.encryptItem(plaintext, keys.encKey, keys.macKey);

      // Tamper with HMAC — flip first byte
      final hmacBytes = base64Decode(encrypted.hmac);
      hmacBytes[0] ^= 0xFF;
      final tampered = EncryptedItem(
        ciphertext: encrypted.ciphertext,
        nonce: encrypted.nonce,
        encryptedItemKey: encrypted.encryptedItemKey,
        itemKeyNonce: encrypted.itemKeyNonce,
        hmac: base64Encode(hmacBytes),
      );

      expect(
        () => crypto.decryptItem(tampered, keys.encKey, keys.macKey),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('HMAC verification failed'),
        )),
      );
    });

    test('tampered ciphertext throws', () async {
      const plaintext = 'Secret data';
      final encrypted =
          await crypto.encryptItem(plaintext, keys.encKey, keys.macKey);

      // Tamper with ciphertext — flip first byte
      final ctBytes = base64Decode(encrypted.ciphertext);
      ctBytes[0] ^= 0xFF;
      final tampered = EncryptedItem(
        ciphertext: base64Encode(ctBytes),
        nonce: encrypted.nonce,
        encryptedItemKey: encrypted.encryptedItemKey,
        itemKeyNonce: encrypted.itemKeyNonce,
        hmac: encrypted.hmac,
      );

      // HMAC check fails first (ciphertext changed → HMAC mismatch)
      expect(
        () => crypto.decryptItem(tampered, keys.encKey, keys.macKey),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('EncryptedItem serialization', () {
    test('toJson / fromJson roundtrip', () {
      const item = EncryptedItem(
        ciphertext: 'ct_base64',
        nonce: 'n_base64',
        encryptedItemKey: 'ek_base64',
        itemKeyNonce: 'ekn_base64',
        hmac: 'h_base64',
      );

      final json = item.toJson();
      final restored = EncryptedItem.fromJson(json);

      expect(restored.ciphertext, item.ciphertext);
      expect(restored.nonce, item.nonce);
      expect(restored.encryptedItemKey, item.encryptedItemKey);
      expect(restored.itemKeyNonce, item.itemKeyNonce);
      expect(restored.hmac, item.hmac);
    });

    test('toMap / fromMap roundtrip', () {
      const item = EncryptedItem(
        ciphertext: 'ct_val',
        nonce: 'n_val',
        encryptedItemKey: 'ek_val',
        itemKeyNonce: 'ekn_val',
        hmac: 'h_val',
      );

      final map = item.toMap();
      final restored = EncryptedItem.fromMap(map);

      expect(restored.ciphertext, item.ciphertext);
      expect(restored.nonce, item.nonce);
      expect(restored.encryptedItemKey, item.encryptedItemKey);
      expect(restored.itemKeyNonce, item.itemKeyNonce);
      expect(restored.hmac, item.hmac);
    });
  });

  group('computeAuthHash', () {
    test('same inputs produce same hash', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final keys = await crypto.deriveKeys('password', salt);

      final hash1 = await crypto.computeAuthHash(keys.masterKey, 'user@test.com');
      final hash2 = await crypto.computeAuthHash(keys.masterKey, 'user@test.com');
      expect(hash1, equals(hash2));
    });

    test('different emails produce different hashes', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final keys = await crypto.deriveKeys('password', salt);

      final hash1 = await crypto.computeAuthHash(keys.masterKey, 'alice@test.com');
      final hash2 = await crypto.computeAuthHash(keys.masterKey, 'bob@test.com');
      expect(hash1, isNot(equals(hash2)));
    });
  });
}
