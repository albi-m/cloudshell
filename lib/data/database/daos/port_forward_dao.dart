/// Data Access Object for port forwarding rule operations.
///
/// Provides typed queries for CRUD operations on the port_forwards
/// table, including filtering by host and auto-start status.
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/port_forwards_table.dart';

part 'port_forward_dao.g.dart';

/// DAO for port forwarding rule database operations.
@DriftAccessor(tables: [PortForwards])
class PortForwardDao extends DatabaseAccessor<AppDatabase>
    with _$PortForwardDaoMixin {
  PortForwardDao(super.db);

  /// Watches all non-deleted port forward rules, ordered by creation date.
  Stream<List<PortForward>> watchAllPortForwards() {
    return (select(portForwards)
          ..where((pf) => pf.isDeleted.equals(false))
          ..orderBy([(pf) => OrderingTerm.desc(pf.createdAt)]))
        .watch();
  }

  /// Watches port forward rules for a specific host.
  Stream<List<PortForward>> watchPortForwardsByHost(String hostId) {
    return (select(portForwards)
          ..where(
            (pf) =>
                pf.isDeleted.equals(false) & pf.hostId.equals(hostId),
          )
          ..orderBy([(pf) => OrderingTerm.desc(pf.createdAt)]))
        .watch();
  }

  /// Gets a single port forward rule by ID.
  Future<PortForward?> getPortForwardById(String id) {
    return (select(portForwards)..where((pf) => pf.id.equals(id)))
        .getSingleOrNull();
  }

  /// Gets all auto-start rules for a host (used on connect).
  Future<List<PortForward>> getAutoStartForwards(String hostId) {
    return (select(portForwards)
          ..where(
            (pf) =>
                pf.isDeleted.equals(false) &
                pf.hostId.equals(hostId) &
                pf.autoStart.equals(true),
          )
          ..orderBy([(pf) => OrderingTerm.asc(pf.sourcePort)]))
        .get();
  }

  /// Inserts a new port forward rule.
  Future<int> insertPortForward(PortForwardsCompanion rule) {
    return into(portForwards).insert(rule);
  }

  /// Updates an existing port forward rule (bumps syncVersion).
  Future<bool> updatePortForward(PortForwardsCompanion rule) async {
    final rows = await (update(portForwards)
            ..where((pf) => pf.id.equals(rule.id.value)))
        .write(rule);
    if (rows > 0) await _bumpSyncVersion(rule.id.value);
    return rows > 0;
  }

  /// Soft-deletes a port forward rule by setting the isDeleted tombstone (bumps syncVersion).
  Future<int> softDeletePortForward(String id) async {
    final rows = await (update(portForwards)..where((pf) => pf.id.equals(id))).write(
      PortForwardsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (rows > 0) await _bumpSyncVersion(id);
    return rows;
  }

  // ---------------------------------------------------------------------------
  // Sync operations
  // ---------------------------------------------------------------------------

  /// Gets all port forwards changed since [version] (includes soft-deleted).
  Future<List<PortForward>> getChangedSince(int version) {
    return (select(portForwards)
          ..where((pf) => pf.syncVersion.isBiggerThanValue(version))
          ..orderBy([(pf) => OrderingTerm.asc(pf.syncVersion)]))
        .get();
  }

  /// Gets the maximum syncVersion across all port forward rows.
  Future<int> getMaxSyncVersion() async {
    final expr = portForwards.syncVersion.max();
    final query = selectOnly(portForwards)..addColumns([expr]);
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  /// Upserts a port forward from a remote sync operation.
  Future<void> upsertFromRemote(PortForwardsCompanion companion) {
    return into(portForwards).insertOnConflictUpdate(companion);
  }

  /// Bumps the syncVersion for a port forward after a local change.
  Future<void> _bumpSyncVersion(String id) async {
    await customStatement(
      'UPDATE port_forwards SET sync_version = sync_version + 1 WHERE id = ?',
      [id],
    );
  }
}
