// Tests for SshService host key verification (TOFU model).
//
// Verifies:
// - Unknown hosts trigger the verify callback
// - Trusted (known) hosts are accepted without callback
// - Changed fingerprints trigger the verify callback with 'changed' status
// - Rejected verifications return false
// - Accepted unknown hosts are stored in known_hosts table
// - Accepted changed hosts replace old entry in known_hosts table
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

  group('Host key verification (TOFU)', () {
    final testFingerprint = Uint8List.fromList(List.generate(32, (i) => i));
    const hostname = 'example.com';
    const port = 22;
    const keyType = 'ssh-ed25519';

    test('unknown host with accepting callback returns true and stores key',
        () async {
      HostKeyInfo? receivedInfo;
      final result = await sshService.verifyHostKey(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprintBytes: testFingerprint,
        onVerify: (info) async {
          receivedInfo = info;
          return true; // User accepts
        },
      );

      expect(result, isTrue);
      expect(receivedInfo != null, isTrue);
      expect(receivedInfo!.hostname, hostname);
      expect(receivedInfo!.port, port);
      expect(receivedInfo!.keyType, keyType);
      expect(receivedInfo!.status, HostKeyStatus.unknown);

      // Verify key was stored in database
      final stored = await db.select(db.knownHosts).get();
      expect(stored, hasLength(1));
      expect(stored.first.hostname, hostname);
      expect(stored.first.port, port);
      expect(stored.first.isTrusted, isTrue);
    });

    test(
        'unknown host with rejecting callback returns false and stores nothing',
        () async {
      final result = await sshService.verifyHostKey(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprintBytes: testFingerprint,
        onVerify: (info) async {
          expect(info.status, HostKeyStatus.unknown);
          return false; // User rejects
        },
      );

      expect(result, isFalse);

      // Verify nothing stored
      final stored = await db.select(db.knownHosts).get();
      expect(stored, isEmpty);
    });

    test('unknown host with no callback auto-accepts', () async {
      final result = await sshService.verifyHostKey(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprintBytes: testFingerprint,
        onVerify: null,
      );

      expect(result, isTrue);
    });

    test('known host with matching fingerprint returns true without callback',
        () async {
      // Pre-store the host key
      final fingerprint = SshService.computeFingerprint(testFingerprint);
      await sshService.trustHostKey(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprint: fingerprint,
        publicKey: 'base64pubkey',
      );

      var callbackCalled = false;
      final result = await sshService.verifyHostKey(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprintBytes: testFingerprint,
        onVerify: (info) async {
          callbackCalled = true;
          return false;
        },
      );

      expect(result, isTrue);
      expect(callbackCalled, isFalse,
          reason: 'Known host should not trigger callback');
    });

    test('changed fingerprint triggers callback with changed status',
        () async {
      // Pre-store an old fingerprint
      await sshService.trustHostKey(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprint: 'SHA256:OldFingerprint',
        publicKey: 'oldkey',
      );

      // Connect with different fingerprint
      HostKeyInfo? receivedInfo;
      final result = await sshService.verifyHostKey(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprintBytes: testFingerprint, // Different from stored
        onVerify: (info) async {
          receivedInfo = info;
          return true; // Accept the new key
        },
      );

      expect(result, isTrue);
      expect(receivedInfo != null, isTrue);
      expect(receivedInfo!.status, HostKeyStatus.changed);

      // Old entry should be replaced
      final stored = await db.select(db.knownHosts).get();
      expect(stored, hasLength(1));
      expect(stored.first.fingerprint,
          SshService.computeFingerprint(testFingerprint));
    });

    test('changed fingerprint rejected returns false and keeps old entry',
        () async {
      await sshService.trustHostKey(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprint: 'SHA256:OldFingerprint',
        publicKey: 'oldkey',
      );

      final result = await sshService.verifyHostKey(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprintBytes: testFingerprint,
        onVerify: (info) async {
          expect(info.status, HostKeyStatus.changed);
          return false; // Reject
        },
      );

      expect(result, isFalse);

      // Old entry should remain
      final stored = await db.select(db.knownHosts).get();
      expect(stored, hasLength(1));
      expect(stored.first.fingerprint, 'SHA256:OldFingerprint');
    });

    test('computeFingerprint produces SHA256: prefixed string', () {
      final fp = SshService.computeFingerprint(testFingerprint);
      expect(fp, startsWith('SHA256:'));
    });
  });
}
