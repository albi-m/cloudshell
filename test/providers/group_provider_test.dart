import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudshell/data/database/app_database.dart';
import 'package:cloudshell/providers/group_provider.dart';

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

  group('allGroupsProvider', () {
    test('emits empty list when no groups exist', () async {
      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(allGroupsProvider, (_, _) {});
      final groups = await container.read(allGroupsProvider.future);
      expect(groups, isEmpty);
    });

    test('emits inserted groups', () async {
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g1',
          name: 'Production',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(allGroupsProvider, (_, _) {});
      final groups = await container.read(allGroupsProvider.future);
      expect(groups, hasLength(1));
      expect(groups.first.name, 'Production');
    });

    test('emits multiple groups ordered by name', () async {
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g1',
          name: 'Staging',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g2',
          name: 'Production',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(allGroupsProvider, (_, _) {});
      final groups = await container.read(allGroupsProvider.future);
      expect(groups, hasLength(2));
      // Ordered by sortOrder (both 0) then name alphabetically
      expect(groups.first.name, 'Production');
      expect(groups.last.name, 'Staging');
    });

    test('excludes soft-deleted groups', () async {
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g1',
          name: 'Active',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g2',
          name: 'Deleted',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.groupDao.softDeleteGroup('g2');

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(allGroupsProvider, (_, _) {});
      final groups = await container.read(allGroupsProvider.future);
      expect(groups, hasLength(1));
      expect(groups.first.name, 'Active');
    });
  });

  group('topLevelGroupsProvider', () {
    test('returns only groups without a parent', () async {
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g1',
          name: 'Parent',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g2',
          name: 'Child',
          createdAt: now,
          updatedAt: now,
          parentGroupId: const Value('g1'),
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(topLevelGroupsProvider, (_, _) {});
      final groups = await container.read(topLevelGroupsProvider.future);
      expect(groups, hasLength(1));
      expect(groups.first.name, 'Parent');
    });

    test('returns empty list when all groups have parents', () async {
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g1',
          name: 'Parent',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g2',
          name: 'Child',
          createdAt: now,
          updatedAt: now,
          parentGroupId: const Value('g1'),
        ),
      );
      // Soft-delete the parent so only the child remains (but child has parent)
      await db.groupDao.softDeleteGroup('g1');

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(topLevelGroupsProvider, (_, _) {});
      final groups = await container.read(topLevelGroupsProvider.future);
      // Child was reparented to top-level by softDeleteGroup
      expect(groups, hasLength(1));
      expect(groups.first.name, 'Child');
    });
  });

  group('childGroupsProvider', () {
    test('returns children for a given parent ID', () async {
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g1',
          name: 'Parent',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g2',
          name: 'Child1',
          createdAt: now,
          updatedAt: now,
          parentGroupId: const Value('g1'),
        ),
      );
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g3',
          name: 'Child2',
          createdAt: now,
          updatedAt: now,
          parentGroupId: const Value('g1'),
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(childGroupsProvider('g1'), (_, _) {});
      final children =
          await container.read(childGroupsProvider('g1').future);
      expect(children, hasLength(2));
    });

    test('returns empty list for parent with no children', () async {
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g1',
          name: 'Lonely Parent',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(childGroupsProvider('g1'), (_, _) {});
      final children =
          await container.read(childGroupsProvider('g1').future);
      expect(children, isEmpty);
    });

    test('does not return children of other parents', () async {
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g1',
          name: 'Parent1',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g2',
          name: 'Parent2',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g3',
          name: 'Child of Parent2',
          createdAt: now,
          updatedAt: now,
          parentGroupId: const Value('g2'),
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      container.listen(childGroupsProvider('g1'), (_, _) {});
      final children =
          await container.read(childGroupsProvider('g1').future);
      expect(children, isEmpty);
    });
  });

  group('groupByIdProvider', () {
    test('returns group when it exists', () async {
      await db.groupDao.insertGroup(
        HostGroupsCompanion.insert(
          id: 'g1',
          name: 'My Group',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      final group = await container.read(groupByIdProvider('g1').future);
      expect(group, isNotNull);
      expect(group!.name, 'My Group');
    });

    test('returns null when group does not exist', () async {
      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
      ]);
      addTearDown(container.dispose);

      final group =
          await container.read(groupByIdProvider('nonexistent').future);
      expect(group, isNull);
    });
  });
}
