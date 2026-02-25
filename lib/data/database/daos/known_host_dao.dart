/// Data Access Object for SSH known hosts management.
///
/// Provides typed queries for viewing and managing trusted
/// SSH host key fingerprints (TOFU model).
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/known_hosts_table.dart';

part 'known_host_dao.g.dart';

/// DAO for managing known SSH host keys.
@DriftAccessor(tables: [KnownHosts])
class KnownHostDao extends DatabaseAccessor<AppDatabase>
    with _$KnownHostDaoMixin {
  KnownHostDao(super.db);

  /// Watches all known hosts, ordered by hostname then port.
  Stream<List<KnownHost>> watchAllKnownHosts() {
    return (select(knownHosts)
          ..orderBy([
            (kh) => OrderingTerm.asc(kh.hostname),
            (kh) => OrderingTerm.asc(kh.port),
          ]))
        .watch();
  }

  /// Gets a known host by ID.
  Future<KnownHost?> getById(String id) {
    return (select(knownHosts)..where((kh) => kh.id.equals(id)))
        .getSingleOrNull();
  }

  /// Deletes a known host entry (removes trust).
  Future<int> deleteKnownHost(String id) {
    return (delete(knownHosts)..where((kh) => kh.id.equals(id))).go();
  }

  /// Searches known hosts by hostname pattern.
  Stream<List<KnownHost>> searchKnownHosts(String query) {
    final pattern = '%$query%';
    return (select(knownHosts)
          ..where((kh) => kh.hostname.like(pattern))
          ..orderBy([(kh) => OrderingTerm.asc(kh.hostname)]))
        .watch();
  }
}
