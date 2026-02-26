import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudshell/data/database/app_database.dart';
import 'package:cloudshell/providers/known_host_provider.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.now();

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('allKnownHostsProvider', () {
    test('emits empty list initially', () async {
      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      final hosts = await container.read(allKnownHostsProvider.future);
      expect(hosts, isEmpty);
    });

    test('emits known hosts after insertion', () async {
      await db.into(db.knownHosts).insert(
        KnownHostsCompanion.insert(
          id: 'kh1',
          hostname: 'example.com',
          port: 22,
          keyType: 'ssh-ed25519',
          fingerprint: 'SHA256:abc123',
          publicKey: 'AAAAC3NzaC1lZDI1NTE5base64key',
          firstSeen: now,
          lastSeen: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      final hosts = await container.read(allKnownHostsProvider.future);
      expect(hosts, hasLength(1));
      expect(hosts.first.hostname, 'example.com');
      expect(hosts.first.keyType, 'ssh-ed25519');
      expect(hosts.first.fingerprint, 'SHA256:abc123');
    });

    test('emits multiple known hosts ordered by hostname', () async {
      await db.into(db.knownHosts).insert(
        KnownHostsCompanion.insert(
          id: 'kh1',
          hostname: 'zeta.example.com',
          port: 22,
          keyType: 'ssh-rsa',
          fingerprint: 'SHA256:zzz',
          publicKey: 'rsapubkey',
          firstSeen: now,
          lastSeen: now,
        ),
      );
      await db.into(db.knownHosts).insert(
        KnownHostsCompanion.insert(
          id: 'kh2',
          hostname: 'alpha.example.com',
          port: 22,
          keyType: 'ssh-ed25519',
          fingerprint: 'SHA256:aaa',
          publicKey: 'ed25519pubkey',
          firstSeen: now,
          lastSeen: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      final hosts = await container.read(allKnownHostsProvider.future);
      expect(hosts, hasLength(2));
      // Ordered by hostname ascending
      expect(hosts.first.hostname, 'alpha.example.com');
      expect(hosts.last.hostname, 'zeta.example.com');
    });

    test('emits known hosts on different ports as separate entries', () async {
      await db.into(db.knownHosts).insert(
        KnownHostsCompanion.insert(
          id: 'kh1',
          hostname: 'server.example.com',
          port: 22,
          keyType: 'ssh-ed25519',
          fingerprint: 'SHA256:port22',
          publicKey: 'key22',
          firstSeen: now,
          lastSeen: now,
        ),
      );
      await db.into(db.knownHosts).insert(
        KnownHostsCompanion.insert(
          id: 'kh2',
          hostname: 'server.example.com',
          port: 2222,
          keyType: 'ssh-ed25519',
          fingerprint: 'SHA256:port2222',
          publicKey: 'key2222',
          firstSeen: now,
          lastSeen: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      final hosts = await container.read(allKnownHostsProvider.future);
      expect(hosts, hasLength(2));
      // Same hostname, ordered by port ascending
      expect(hosts.first.port, 22);
      expect(hosts.last.port, 2222);
    });

    test('reflects deletion of known hosts', () async {
      await db.into(db.knownHosts).insert(
        KnownHostsCompanion.insert(
          id: 'kh1',
          hostname: 'to-delete.example.com',
          port: 22,
          keyType: 'ssh-rsa',
          fingerprint: 'SHA256:del',
          publicKey: 'delkey',
          firstSeen: now,
          lastSeen: now,
        ),
      );
      await db.knownHostDao.deleteKnownHost('kh1');

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      final hosts = await container.read(allKnownHostsProvider.future);
      expect(hosts, isEmpty);
    });
  });
}
