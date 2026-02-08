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

  /// Watches all non-deleted hosts, ordered by last connected.
  Stream<List<Host>> watchAllHosts() {
    return (select(hosts)
          ..where((h) => h.isDeleted.equals(false))
          ..orderBy([
            (h) => OrderingTerm.desc(h.lastConnectedAt),
            (h) => OrderingTerm.asc(h.label),
          ]))
        .watch();
  }

  /// Watches hosts in a specific group.
  Stream<List<Host>> watchHostsByGroup(String groupId) {
    return (select(hosts)
          ..where((h) => h.isDeleted.equals(false) & h.groupId.equals(groupId))
          ..orderBy([(h) => OrderingTerm.asc(h.label)]))
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

  /// Updates an existing host record.
  Future<bool> updateHost(HostsCompanion host) {
    return (update(hosts)..where((h) => h.id.equals(host.id.value))).write(host).then((rows) => rows > 0);
  }

  /// Soft-deletes a host by setting the isDeleted tombstone.
  Future<int> softDeleteHost(String id) {
    return (update(hosts)..where((h) => h.id.equals(id))).write(
      HostsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
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
}
