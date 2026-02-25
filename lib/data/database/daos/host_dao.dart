/// Data Access Object for SSH host operations.
///
/// Provides typed queries for CRUD operations on the hosts
/// table, including filtering by group, favorites, and search.
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/hosts_table.dart';

part 'host_dao.g.dart';

/// DAO for SSH host database operations.
///
/// All queries filter out soft-deleted records by default.
@DriftAccessor(tables: [Hosts])
class HostDao extends DatabaseAccessor<AppDatabase> with _$HostDaoMixin {
  HostDao(super.db);

  /// Watches all non-deleted hosts, ordered by sort order then label.
  Stream<List<Host>> watchAllHosts() {
    return (select(hosts)
          ..where((h) => h.isDeleted.equals(false))
          ..orderBy([
            (h) => OrderingTerm.asc(h.sortOrder),
            (h) => OrderingTerm.asc(h.label),
          ]))
        .watch();
  }

  /// Watches hosts in a specific group, ordered by sort order then label.
  Stream<List<Host>> watchHostsByGroup(String groupId) {
    return (select(hosts)
          ..where((h) => h.isDeleted.equals(false) & h.groupId.equals(groupId))
          ..orderBy([
            (h) => OrderingTerm.asc(h.sortOrder),
            (h) => OrderingTerm.asc(h.label),
          ]))
        .watch();
  }

  /// Watches favorite hosts only.
  Stream<List<Host>> watchFavoriteHosts() {
    return (select(hosts)
          ..where((h) => h.isDeleted.equals(false) & h.isFavorite.equals(true))
          ..orderBy([(h) => OrderingTerm.asc(h.label)]))
        .watch();
  }

  /// Gets a single host by ID.
  Future<Host?> getHostById(String id) {
    return (select(hosts)..where((h) => h.id.equals(id))).getSingleOrNull();
  }

  /// Inserts a new host record.
  Future<int> insertHost(HostsCompanion host) {
    return into(hosts).insert(host);
  }

  /// Updates an existing host record (bumps syncVersion).
  Future<bool> updateHost(HostsCompanion host) async {
    final rows = await (update(hosts)..where((h) => h.id.equals(host.id.value))).write(host);
    if (rows > 0) await _bumpSyncVersion(host.id.value);
    return rows > 0;
  }

  /// Soft-deletes a host by setting the isDeleted tombstone (bumps syncVersion).
  Future<int> softDeleteHost(String id) async {
    final rows = await (update(hosts)..where((h) => h.id.equals(id))).write(
      HostsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (rows > 0) await _bumpSyncVersion(id);
    return rows;
  }

  /// Updates the last connected timestamp for a host.
  Future<int> updateLastConnected(String id) {
    return (update(hosts)..where((h) => h.id.equals(id))).write(
      HostsCompanion(
        lastConnectedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Watches hosts that use a specific SSH key for authentication.
  Stream<List<Host>> watchHostsByKeyId(String keyId) {
    return (select(hosts)
          ..where((h) => h.isDeleted.equals(false) & h.keyId.equals(keyId))
          ..orderBy([(h) => OrderingTerm.asc(h.label)]))
        .watch();
  }

  /// Clears the keyId on all hosts referencing the given SSH key.
  ///
  /// Called when an SSH key is deleted so hosts don't retain
  /// dangling references that crash the host form dropdown.
  Future<int> clearKeyReferences(String keyId) {
    return (update(hosts)..where((h) => h.keyId.equals(keyId))).write(
      HostsCompanion(
        keyId: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Updates the sort order for a list of hosts by their IDs.
  Future<void> updateSortOrders(List<(String id, int sortOrder)> updates) async {
    await batch((b) {
      for (final (id, order) in updates) {
        b.update(hosts, HostsCompanion(sortOrder: Value(order)),
            where: (h) => h.id.equals(id));
      }
    });
  }

  /// Searches hosts by label, hostname, or tags.
  Future<List<Host>> searchHosts(String query) {
    final pattern = '%$query%';
    return (select(hosts)
          ..where(
            (h) =>
                h.isDeleted.equals(false) &
                (h.label.like(pattern) |
                    h.hostname.like(pattern) |
                    h.tags.like(pattern)),
          ))
        .get();
  }

  // ---------------------------------------------------------------------------
  // Sync operations
  // ---------------------------------------------------------------------------

  /// Gets all hosts changed since [version] (includes soft-deleted).
  Future<List<Host>> getChangedSince(int version) {
    return (select(hosts)
          ..where((h) => h.syncVersion.isBiggerThanValue(version))
          ..orderBy([(h) => OrderingTerm.asc(h.syncVersion)]))
        .get();
  }

  /// Gets the maximum syncVersion across all host rows.
  Future<int> getMaxSyncVersion() async {
    final expr = hosts.syncVersion.max();
    final query = selectOnly(hosts)..addColumns([expr]);
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  /// Upserts a host from a remote sync operation.
  Future<void> upsertFromRemote(HostsCompanion companion) {
    return into(hosts).insertOnConflictUpdate(companion);
  }

  /// Bumps the syncVersion for a host after a local change.
  Future<void> _bumpSyncVersion(String id) async {
    await customStatement(
      'UPDATE hosts SET sync_version = sync_version + 1 WHERE id = ?',
      [id],
    );
  }
}
