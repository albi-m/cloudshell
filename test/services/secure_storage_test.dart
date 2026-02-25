import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cloudshell/data/database/app_database.dart';
import 'package:cloudshell/services/crypto/app_crypto_service.dart';
import 'package:cloudshell/services/crypto/secure_storage.dart';

void main() {
  late AppDatabase db;
  late AppCryptoService crypto;
  late SecureStorageService storage;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    crypto = AppCryptoService();
    storage = SecureStorageService(db: db, crypto: crypto);
  });

  tearDown(() async {
    await db.close();
  });

  group('SecureStorageService', () {
    test('storeSshPrivateKey and getSshPrivateKey round-trip', () async {
      const keyId = 'test-key-1';
      const pem = '-----BEGIN OPENSSH PRIVATE KEY-----\nfakedata\n-----END OPENSSH PRIVATE KEY-----';

      await storage.storeSshPrivateKey(keyId, pem);
      final retrieved = await storage.getSshPrivateKey(keyId);
      expect(retrieved, pem);
    });

    test('getSshPrivateKey returns null for non-existent key', () async {
      final result = await storage.getSshPrivateKey('non-existent');
      expect(result, isNull);
    });

    test('deleteSshPrivateKey removes the key', () async {
      const keyId = 'delete-me';
      await storage.storeSshPrivateKey(keyId, 'secret-pem');
      await storage.deleteSshPrivateKey(keyId);
      final result = await storage.getSshPrivateKey(keyId);
      expect(result, isNull);
    });

    test('storeHostPassword and getHostPassword round-trip', () async {
      const hostId = 'host-1';
      const password = 'P@ssw0rd!';

      await storage.storeHostPassword(hostId, password);
      final retrieved = await storage.getHostPassword(hostId);
      expect(retrieved, password);
    });

    test('deleteHostPassword removes the password', () async {
      const hostId = 'host-2';
      await storage.storeHostPassword(hostId, 'secret');
      await storage.deleteHostPassword(hostId);
      final result = await storage.getHostPassword(hostId);
      expect(result, isNull);
    });

    test('containsKey returns true for existing key', () async {
      await storage.write('test-key', 'test-value');
      final exists = await storage.containsKey('test-key');
      expect(exists, isTrue);
    });

    test('containsKey returns false for missing key', () async {
      final exists = await storage.containsKey('non-existent');
      expect(exists, isFalse);
    });

    test('write and read generic key-value', () async {
      await storage.write('generic-key', 'generic-value');
      final result = await storage.read('generic-key');
      expect(result, 'generic-value');
    });

    test('delete removes generic key', () async {
      await storage.write('to-delete', 'value');
      await storage.delete('to-delete');
      final result = await storage.read('to-delete');
      expect(result, isNull);
    });

    test('overwrite updates existing value', () async {
      await storage.write('key', 'value-1');
      await storage.write('key', 'value-2');
      final result = await storage.read('key');
      expect(result, 'value-2');
    });
  });
}
