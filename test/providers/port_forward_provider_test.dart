import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudshell/data/database/app_database.dart';
import 'package:cloudshell/data/database/tables/hosts_table.dart';
import 'package:cloudshell/data/database/tables/port_forwards_table.dart';
import 'package:cloudshell/providers/port_forward_provider.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.now();

  setUp(() async {
    db = createTestDatabase();
    // Insert common test hosts used across tests.
    await db.hostDao.insertHost(HostsCompanion.insert(
      id: 'h1',
      label: 'Host One',
      hostname: 'h1.example.com',
      username: 'user1',
      authMethod: AuthMethodType.password,
      createdAt: now,
      updatedAt: now,
    ));
    await db.hostDao.insertHost(HostsCompanion.insert(
      id: 'h2',
      label: 'Host Two',
      hostname: 'h2.example.com',
      username: 'user2',
      authMethod: AuthMethodType.password,
      createdAt: now,
      updatedAt: now,
    ));
  });

  tearDown(() async {
    await db.close();
  });

  group('allPortForwardsProvider', () {
    test('emits empty list initially', () async {
      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(allPortForwardsProvider, (_, _) {});
      final forwards =
          await container.read(allPortForwardsProvider.future);
      expect(forwards, isEmpty);
    });

    test('emits inserted port forwards', () async {
      await db.portForwardDao.insertPortForward(
        PortForwardsCompanion.insert(
          id: 'pf1',
          hostId: 'h1',
          label: 'Web Forward',
          type: PortForwardTypeEnum.local,
          sourcePort: 8080,
          destinationHost: const Value('localhost'),
          destinationPort: const Value(80),
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(allPortForwardsProvider, (_, _) {});
      final forwards =
          await container.read(allPortForwardsProvider.future);
      expect(forwards, hasLength(1));
      expect(forwards.first.label, 'Web Forward');
      expect(forwards.first.sourcePort, 8080);
    });

    test('excludes soft-deleted port forwards', () async {
      await db.portForwardDao.insertPortForward(
        PortForwardsCompanion.insert(
          id: 'pf1',
          hostId: 'h1',
          label: 'Active',
          type: PortForwardTypeEnum.local,
          sourcePort: 8080,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.portForwardDao.insertPortForward(
        PortForwardsCompanion.insert(
          id: 'pf2',
          hostId: 'h1',
          label: 'Deleted',
          type: PortForwardTypeEnum.remote,
          sourcePort: 9090,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.portForwardDao.softDeletePortForward('pf2');

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(allPortForwardsProvider, (_, _) {});
      final forwards =
          await container.read(allPortForwardsProvider.future);
      expect(forwards, hasLength(1));
      expect(forwards.first.label, 'Active');
    });
  });

  group('portForwardsByHostProvider', () {
    test('filters by host ID', () async {
      await db.portForwardDao.insertPortForward(
        PortForwardsCompanion.insert(
          id: 'pf1',
          hostId: 'h1',
          label: 'H1 Forward',
          type: PortForwardTypeEnum.local,
          sourcePort: 8080,
          destinationHost: const Value('localhost'),
          destinationPort: const Value(80),
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.portForwardDao.insertPortForward(
        PortForwardsCompanion.insert(
          id: 'pf2',
          hostId: 'h2',
          label: 'H2 Forward',
          type: PortForwardTypeEnum.local,
          sourcePort: 9090,
          destinationHost: const Value('localhost'),
          destinationPort: const Value(90),
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(portForwardsByHostProvider('h1'), (_, _) {});
      final h1Forwards =
          await container.read(portForwardsByHostProvider('h1').future);
      expect(h1Forwards, hasLength(1));
      expect(h1Forwards.first.label, 'H1 Forward');

      container.listen(portForwardsByHostProvider('h2'), (_, _) {});
      final h2Forwards =
          await container.read(portForwardsByHostProvider('h2').future);
      expect(h2Forwards, hasLength(1));
      expect(h2Forwards.first.label, 'H2 Forward');
    });

    test('returns empty list for host with no forwards', () async {
      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(portForwardsByHostProvider('h1'), (_, _) {});
      final forwards =
          await container.read(portForwardsByHostProvider('h1').future);
      expect(forwards, isEmpty);
    });

    test('returns multiple forwards for the same host', () async {
      await db.portForwardDao.insertPortForward(
        PortForwardsCompanion.insert(
          id: 'pf1',
          hostId: 'h1',
          label: 'HTTP',
          type: PortForwardTypeEnum.local,
          sourcePort: 8080,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.portForwardDao.insertPortForward(
        PortForwardsCompanion.insert(
          id: 'pf2',
          hostId: 'h1',
          label: 'DB',
          type: PortForwardTypeEnum.local,
          sourcePort: 5432,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(portForwardsByHostProvider('h1'), (_, _) {});
      final forwards =
          await container.read(portForwardsByHostProvider('h1').future);
      expect(forwards, hasLength(2));
    });
  });

  group('portForwardByIdProvider', () {
    test('returns specific port forward by ID', () async {
      await db.portForwardDao.insertPortForward(
        PortForwardsCompanion.insert(
          id: 'pf1',
          hostId: 'h1',
          label: 'My Forward',
          type: PortForwardTypeEnum.local,
          sourcePort: 8080,
          destinationHost: const Value('localhost'),
          destinationPort: const Value(80),
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      final pf =
          await container.read(portForwardByIdProvider('pf1').future);
      expect(pf, isNotNull);
      expect(pf!.label, 'My Forward');
      expect(pf.sourcePort, 8080);
      expect(pf.hostId, 'h1');
    });

    test('returns null for nonexistent ID', () async {
      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      final pf = await container
          .read(portForwardByIdProvider('nonexistent').future);
      expect(pf, isNull);
    });

    test('returns dynamic type port forward', () async {
      await db.portForwardDao.insertPortForward(
        PortForwardsCompanion.insert(
          id: 'pf-dyn',
          hostId: 'h1',
          label: 'SOCKS Proxy',
          type: PortForwardTypeEnum.dynamic,
          sourcePort: 1080,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      final pf =
          await container.read(portForwardByIdProvider('pf-dyn').future);
      expect(pf, isNotNull);
      expect(pf!.label, 'SOCKS Proxy');
      expect(pf.type, PortForwardTypeEnum.dynamic);
      expect(pf.sourcePort, 1080);
    });
  });
}
