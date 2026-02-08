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

  /// Updates an existing group record.
  Future<bool> updateGroup(HostGroupsCompanion group) {
    return (update(hostGroups)..where((g) => g.id.equals(group.id.value)))
        .write(group)
        .then((rows) => rows > 0);
  }

  /// Soft-deletes a group by setting the isDeleted tombstone.
  ///
  /// Does NOT cascade to hosts — hosts in this group will have
  /// their groupId set to null (ungrouped).
  Future<void> softDeleteGroup(String id) async {
    // Unassign all hosts from this group
    await (update(hosts)..where((h) => h.groupId.equals(id))).write(
      HostsCompanion(
        groupId: const Value(null),
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
  }

  /// Returns the count of non-deleted hosts in a specific group.
  Future<int> hostCountForGroup(String groupId) async {
    final query = selectOnly(hosts)
      ..addColumns([hosts.id.count()])
      ..where(hosts.isDeleted.equals(false) & hosts.groupId.equals(groupId));
    final result = await query.getSingle();
    return result.read(hosts.id.count()) ?? 0;
  }
}
