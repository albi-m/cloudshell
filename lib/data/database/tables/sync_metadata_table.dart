/// Drift table for sync metadata tracking.
///
/// Stores the last-synced version for each entity type so the
/// sync engine knows which changes to pull from the server.
library;

import 'package:drift/drift.dart';

/// Tracks sync state per entity type (host, ssh_key, group, etc.).
class SyncMetadata extends Table {
  /// Entity type name (primary key): 'host', 'ssh_key', 'group', etc.
  TextColumn get entityType => text()();

  /// Last sync version successfully pulled from the server.
  IntColumn get lastSyncVersion => integer().withDefault(const Constant(0))();

  /// Timestamp of last successful sync.
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {entityType};
}
