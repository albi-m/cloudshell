/// Data Access Object for the offline sync queue.
///
/// Manages queued changes that need to be pushed to the server
/// when connectivity is restored.
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

/// DAO for the sync_queue table.
@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  /// Enqueues a change for later sync.
  Future<int> enqueue({
    required String entityType,
    required String entityId,
    required SyncOperation operation,
    String? encryptedPayload,
    int syncVersion = 0,
  }) {
    return into(syncQueue).insert(
      SyncQueueCompanion.insert(
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        encryptedPayload: Value(encryptedPayload),
        syncVersion: Value(syncVersion),
        queuedAt: DateTime.now(),
      ),
    );
  }

  /// Gets pending items ordered by queue time, with optional limit.
  Future<List<SyncQueueData>> getPendingItems({int? limit}) {
    final query = select(syncQueue)
      ..orderBy([(t) => OrderingTerm.asc(t.queuedAt)]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  /// Watches the count of pending items.
  Stream<int> watchPendingCount() {
    final expr = syncQueue.id.count();
    final query = selectOnly(syncQueue)..addColumns([expr]);
    return query.map((row) => row.read(expr) ?? 0).watchSingle();
  }

  /// Increments the retry count for a failed item.
  Future<void> markRetry(int itemId) async {
    await customStatement(
      'UPDATE sync_queue SET retry_count = retry_count + 1 WHERE id = ?',
      [itemId],
    );
  }

  /// Deletes a successfully pushed item.
  Future<void> deleteItem(int itemId) {
    return (delete(syncQueue)..where((t) => t.id.equals(itemId))).go();
  }

  /// Clears the entire queue (used on logout or full resync).
  Future<void> clearAll() {
    return delete(syncQueue).go();
  }

  /// Counts pending items.
  Future<int> pendingCount() async {
    final expr = syncQueue.id.count();
    final query = selectOnly(syncQueue)..addColumns([expr]);
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }
}
