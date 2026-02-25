import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';

import 'package:cloudshell/data/database/app_database.dart';
import 'package:cloudshell/data/database/tables/hosts_table.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  // ignore: no_leading_underscores_for_local_identifiers
  HostsCompanion _makeHost({
    String id = 'host-1',
    String label = 'Test Server',
    String hostname = '192.168.1.1',
    String username = 'root',
    int port = 22,
    String? groupId,
    bool isFavorite = false,
  }) {
    final now = DateTime.now();
    return HostsCompanion.insert(
      id: id,
      label: label,
      hostname: hostname,
      port: Value(port),
      username: username,
      authMethod: AuthMethodType.password,
      tags: const Value(''),
      keepAliveSeconds: const Value(60),
      isFavorite: Value(isFavorite),
      groupId: Value(groupId),
      createdAt: now,
      updatedAt: now,
    );
  }

  group('HostDao', () {
    test('insertHost and getHostById', () async {
      await db.hostDao.insertHost(_makeHost());
      final host = await db.hostDao.getHostById('host-1');
      expect(host, isNotNull);
      expect(host!.label, 'Test Server');
      expect(host.hostname, '192.168.1.1');
    });

    test('getHostById returns null for non-existent ID', () async {
      final host = await db.hostDao.getHostById('non-existent');
      expect(host, isNull);
    });

    test('watchAllHosts emits inserted hosts', () async {
      await db.hostDao.insertHost(_makeHost(id: 'h1', label: 'Alpha'));
      await db.hostDao.insertHost(_makeHost(id: 'h2', label: 'Beta'));

      final hosts = await db.hostDao.watchAllHosts().first;
      expect(hosts, hasLength(2));
      expect(hosts[0].label, 'Alpha');
      expect(hosts[1].label, 'Beta');
    });

    test('softDeleteHost filters host from watchAllHosts', () async {
      await db.hostDao.insertHost(_makeHost());
      await db.hostDao.softDeleteHost('host-1');

      final hosts = await db.hostDao.watchAllHosts().first;
      expect(hosts, isEmpty);
    });

    test('watchHostsByGroup returns only matching group', () async {
      await db.hostDao.insertHost(
          _makeHost(id: 'h1', label: 'In Group', groupId: 'g1'));
      await db.hostDao.insertHost(
          _makeHost(id: 'h2', label: 'No Group'));

      final grouped = await db.hostDao.watchHostsByGroup('g1').first;
      expect(grouped, hasLength(1));
      expect(grouped[0].label, 'In Group');
    });

    test('watchFavoriteHosts returns only favorites', () async {
      await db.hostDao.insertHost(
          _makeHost(id: 'h1', label: 'Favorite', isFavorite: true));
      await db.hostDao.insertHost(
          _makeHost(id: 'h2', label: 'Normal'));

      final favorites = await db.hostDao.watchFavoriteHosts().first;
      expect(favorites, hasLength(1));
      expect(favorites[0].label, 'Favorite');
    });

    test('updateLastConnected sets timestamp', () async {
      await db.hostDao.insertHost(_makeHost());
      await db.hostDao.updateLastConnected('host-1');

      final host = await db.hostDao.getHostById('host-1');
      expect(host!.lastConnectedAt, isNotNull);
    });

    test('searchHosts finds by label', () async {
      await db.hostDao.insertHost(
          _makeHost(id: 'h1', label: 'Production'));
      await db.hostDao.insertHost(
          _makeHost(id: 'h2', label: 'Staging'));

      final results = await db.hostDao.searchHosts('Prod');
      expect(results, hasLength(1));
      expect(results[0].label, 'Production');
    });

    test('clearKeyReferences removes keyId from hosts', () async {
      await db.hostDao.insertHost(HostsCompanion.insert(
        id: 'h1',
        label: 'With Key',
        hostname: '10.0.0.1',
        port: const Value(22),
        username: 'admin',
        authMethod: AuthMethodType.key,
        tags: const Value(''),
        keepAliveSeconds: const Value(60),
        keyId: const Value('key-1'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await db.hostDao.clearKeyReferences('key-1');
      final host = await db.hostDao.getHostById('h1');
      expect(host!.keyId, isNull);
    });
  });
}
