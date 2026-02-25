/// Drift table for the offline sync queue.
///
/// Queues local changes when the device is offline. The sync
/// engine drains this queue when connectivity is restored.
library;

import 'package:drift/drift.dart';

/// Sync operation type.
enum SyncOperation { create, update, delete }

/// Offline sync queue for changes that haven't been pushed yet.
class SyncQueue extends Table {
  /// Auto-incrementing ID.
  IntColumn get id => integer().autoIncrement()();

  /// Entity type: 'host', 'ssh_key', 'group', 'snippet', 'port_forward'.
  TextColumn get entityType => text()();

  /// Local UUID of the entity.
  TextColumn get entityId => text()();

  /// Type of change.
  IntColumn get operation => intEnum<SyncOperation>()();

  /// Pre-encrypted payload ready to push (null for deletes).
  TextColumn get encryptedPayload => text().nullable()();

  /// Sync version at time of queuing.
  IntColumn get syncVersion => integer().withDefault(const Constant(0))();

  /// When the change was queued.
  DateTimeColumn get queuedAt => dateTime()();

  /// Number of push retry attempts.
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}
