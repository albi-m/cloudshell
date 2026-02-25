/// Data Access Object for host group operations.
///
/// Provides typed queries for CRUD operations on the host
/// groups table, including hierarchy and host count queries.
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/groups_table.dart';
import '../tables/hosts_table.dart';

part 'group_dao.g.dart';

/// DAO for host group database operations.
///
/// All queries filter out soft-deleted records by default.
@DriftAccessor(tables: [HostGroups, Hosts])
class GroupDao extends DatabaseAccessor<AppDatabase> with _$GroupDaoMixin {
  GroupDao(super.db);

  /// Watches all non-deleted groups, ordered by sort order then name.
  Stream<List<HostGroup>> watchAllGroups() {
    return (select(hostGroups)
          ..where((g) => g.isDeleted.equals(false))
          ..orderBy([
            (g) => OrderingTerm.asc(g.sortOrder),
            (g) => OrderingTerm.asc(g.name),
          ]))
        .watch();
  }

  /// Gets a single group by ID.
  Future<HostGroup?> getGroupById(String id) {
    return (select(hostGroups)..where((g) => g.id.equals(id)))
        .getSingleOrNull();
  }

  /// Inserts a new group record.
  Future<int> insertGroup(HostGroupsCompanion group) {
    return into(hostGroups).insert(group);
  }

  /// Updates an existing group record (bumps syncVersion).
  Future<bool> updateGroup(HostGroupsCompanion group) async {
    final rows = await (update(hostGroups)..where((g) => g.id.equals(group.id.value)))
        .write(group);
    if (rows > 0) await _bumpSyncVersion(group.id.value);
    return rows > 0;
  }

  /// Watches top-level groups (no parent).
  Stream<List<HostGroup>> watchTopLevelGroups() {
    return (select(hostGroups)
          ..where((g) =>
              g.isDeleted.equals(false) & g.parentGroupId.isNull())
          ..orderBy([
            (g) => OrderingTerm.asc(g.sortOrder),
            (g) => OrderingTerm.asc(g.name),
          ]))
        .watch();
  }

  /// Watches child groups of a specific parent group.
  Stream<List<HostGroup>> watchChildGroups(String parentId) {
    return (select(hostGroups)
          ..where((g) =>
              g.isDeleted.equals(false) &
              g.parentGroupId.equals(parentId))
          ..orderBy([
            (g) => OrderingTerm.asc(g.sortOrder),
            (g) => OrderingTerm.asc(g.name),
          ]))
        .watch();
  }

  /// Soft-deletes a group by setting the isDeleted tombstone (bumps syncVersion).
  ///
  /// Unparents child groups (moves to top level) and unassigns
  /// hosts from this group.
  Future<void> softDeleteGroup(String id) async {
    // Unassign all hosts from this group
    await (update(hosts)..where((h) => h.groupId.equals(id))).write(
      HostsCompanion(
        groupId: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Move child groups to top level
    await (update(hostGroups)
          ..where((g) => g.parentGroupId.equals(id)))
        .write(
      HostGroupsCompanion(
        parentGroupId: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Soft-delete the group
    await (update(hostGroups)..where((g) => g.id.equals(id))).write(
      HostGroupsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _bumpSyncVersion(id);
  }

  /// Returns the count of non-deleted hosts in a specific group.
  Future<int> hostCountForGroup(String groupId) async {
    final query = selectOnly(hosts)
      ..addColumns([hosts.id.count()])
      ..where(hosts.isDeleted.equals(false) & hosts.groupId.equals(groupId));
    final result = await query.getSingle();
    return result.read(hosts.id.count()) ?? 0;
  }

  // ---------------------------------------------------------------------------
  // Sync operations
  // ---------------------------------------------------------------------------

  /// Gets all groups changed since [version] (includes soft-deleted).
  Future<List<HostGroup>> getChangedSince(int version) {
    return (select(hostGroups)
          ..where((g) => g.syncVersion.isBiggerThanValue(version))
          ..orderBy([(g) => OrderingTerm.asc(g.syncVersion)]))
        .get();
  }

  /// Gets the maximum syncVersion across all group rows.
  Future<int> getMaxSyncVersion() async {
    final expr = hostGroups.syncVersion.max();
    final query = selectOnly(hostGroups)..addColumns([expr]);
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  /// Upserts a group from a remote sync operation.
  Future<void> upsertFromRemote(HostGroupsCompanion companion) {
    return into(hostGroups).insertOnConflictUpdate(companion);
  }

  /// Bumps the syncVersion for a group after a local change.
  Future<void> _bumpSyncVersion(String id) async {
    await customStatement(
      'UPDATE host_groups SET sync_version = sync_version + 1 WHERE id = ?',
      [id],
    );
  }
}
