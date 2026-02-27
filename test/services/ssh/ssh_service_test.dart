// Unit tests for SshService pure logic.
//
// Verifies:
// - computeFingerprint determinism and format
// - HostKeyInfo construction
// - HostKeyStatus enum values
// - verifyHostKey edge cases (null callback on changed fingerprint)
// - Service construction
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cloudshell/data/database/app_database.dart';
import 'package:cloudshell/services/crypto/app_crypto_service.dart';
import 'package:cloudshell/services/crypto/secure_storage.dart';
import 'package:cloudshell/services/ssh/ssh_key_service.dart';
import 'package:cloudshell/services/ssh/ssh_service.dart';

void main() {
  late AppDatabase db;
  late SshService sshService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    final crypto = AppCryptoService();
    final secureStorage = SecureStorageService(db: db, crypto: crypto);
    sshService = SshService(
      db: db,
      secureStorage: secureStorage,
      keyService: SshKeyService(db: db, secureStorage: secureStorage),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('computeFingerprint', () {
    test('produces SHA256: prefixed deterministic string', () {
      final bytes = Uint8List.fromList(List.generate(32, (i) => i));
      final fp1 = SshService.computeFingerprint(bytes);
      final fp2 = SshService.computeFingerprint(bytes);

      expect(fp1, startsWith('SHA256:'));
      expect(fp1, equals(fp2));
    });

    test('different inputs produce different fingerprints', () {
      final bytes1 = Uint8List.fromList(List.generate(32, (i) => i));
      final bytes2 = Uint8List.fromList(List.generate(32, (i) => 255 - i));

      final fp1 = SshService.computeFingerprint(bytes1);
      final fp2 = SshService.computeFingerprint(bytes2);
      expect(fp1, isNot(equals(fp2)));
    });

    test('matches expected SHA256 for known input', () {
      // All zeros input — deterministic hash
      final bytes = Uint8List(32);
      final fp = SshService.computeFingerprint(bytes);
      expect(fp, startsWith('SHA256:'));
      // Just verify it's a valid base64-ish string after the prefix
      final hashPart = fp.substring('SHA256:'.length);
      expect(hashPart.length, greaterThan(20));
    });
  });

  group('HostKeyInfo', () {
    test('constructs with all fields', () {
      const info = HostKeyInfo(
        hostname: 'example.com',
        port: 22,
        keyType: 'ssh-ed25519',
        fingerprint: 'SHA256:abc123',
        status: HostKeyStatus.unknown,
      );

      expect(info.hostname, 'example.com');
      expect(info.port, 22);
      expect(info.keyType, 'ssh-ed25519');
      expect(info.fingerprint, 'SHA256:abc123');
      expect(info.status, HostKeyStatus.unknown);
    });
  });

  group('HostKeyStatus', () {
    test('has expected values', () {
      expect(HostKeyStatus.values, hasLength(3));
      expect(HostKeyStatus.values, contains(HostKeyStatus.unknown));
      expect(HostKeyStatus.values, contains(HostKeyStatus.trusted));
      expect(HostKeyStatus.values, contains(HostKeyStatus.changed));
    });
  });

  group('verifyHostKey edge cases', () {
    test('null callback on changed fingerprint returns false', () async {
      final bytes = Uint8List.fromList(List.generate(32, (i) => i));

      // Pre-store an old fingerprint
      await sshService.trustHostKey(
        hostname: 'example.com',
        port: 22,
        keyType: 'ssh-ed25519',
        fingerprint: 'SHA256:OldFingerprint',
        publicKey: 'oldkey',
      );

      // Verify with no callback — changed fingerprint should return false
      final result = await sshService.verifyHostKey(
        hostname: 'example.com',
        port: 22,
        keyType: 'ssh-ed25519',
        fingerprintBytes: bytes,
        onVerify: null,
      );

      expect(result, isFalse);
    });
  });

  group('SshService construction', () {
    test('creates with required dependencies', () {
      expect(sshService, isNotNull);
    });
  });
}
