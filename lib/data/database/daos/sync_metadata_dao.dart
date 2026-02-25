/// Data Access Object for sync metadata.
///
/// Tracks the last-synced version for each entity type.
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/sync_metadata_table.dart';

part 'sync_metadata_dao.g.dart';

/// DAO for the sync_metadata table.
@DriftAccessor(tables: [SyncMetadata])
class SyncMetadataDao extends DatabaseAccessor<AppDatabase>
    with _$SyncMetadataDaoMixin {
  SyncMetadataDao(super.db);

  /// Gets sync metadata for a specific entity type.
  Future<SyncMetadataData?> getByEntityType(String entityType) {
    return (select(syncMetadata)
          ..where((t) => t.entityType.equals(entityType)))
        .getSingleOrNull();
  }

  /// Gets the last sync version for an entity type (-1 if never synced).
  ///
  /// Returns -1 so that `getChangedSince(-1)` with `syncVersion > -1`
  /// captures all existing items (including those at version 0).
  Future<int> getLastSyncVersion(String entityType) async {
    final row = await getByEntityType(entityType);
    return row?.lastSyncVersion ?? -1;
  }

  /// Upserts sync metadata after a successful sync.
  Future<void> upsertMetadata(
    String entityType,
    int version,
    DateTime syncedAt,
  ) async {
    await into(syncMetadata).insertOnConflictUpdate(
      SyncMetadataCompanion.insert(
        entityType: entityType,
        lastSyncVersion: Value(version),
        lastSyncAt: Value(syncedAt),
      ),
    );
  }

  /// Watches all sync metadata entries.
  Stream<List<SyncMetadataData>> watchAll() {
    return select(syncMetadata).watch();
  }

  /// Resets all sync metadata (used on logout or account switch).
  Future<void> resetAll() {
    return delete(syncMetadata).go();
  }
}
