/// Data Access Object for SSH key operations.
///
/// Provides typed queries for CRUD operations on the SSH keys
/// table, including search and filtering.
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/keys_table.dart';

part 'key_dao.g.dart';

/// DAO for SSH key metadata database operations.
///
/// Private key material is stored in flutter_secure_storage,
/// not in this table. Only metadata and public keys are here.
@DriftAccessor(tables: [SshKeys])
class KeyDao extends DatabaseAccessor<AppDatabase> with _$KeyDaoMixin {
  KeyDao(super.db);

  /// Watches all non-deleted SSH keys, ordered by label.
  Stream<List<SshKey>> watchAllKeys() {
    return (select(sshKeys)
          ..where((k) => k.isDeleted.equals(false))
          ..orderBy([(k) => OrderingTerm.asc(k.label)]))
        .watch();
  }

  /// Gets a single SSH key by ID.
  Future<SshKey?> getKeyById(String id) {
    return (select(sshKeys)..where((k) => k.id.equals(id))).getSingleOrNull();
  }

  /// Inserts a new SSH key record.
  Future<int> insertKey(SshKeysCompanion key) {
    return into(sshKeys).insert(key);
  }

  /// Updates an existing SSH key record (bumps syncVersion).
  Future<bool> updateKey(SshKeysCompanion key) async {
    final rows = await (update(sshKeys)..where((k) => k.id.equals(key.id.value)))
        .write(key);
    if (rows > 0) await _bumpSyncVersion(key.id.value);
    return rows > 0;
  }

  /// Soft-deletes an SSH key by setting the isDeleted tombstone (bumps syncVersion).
  Future<int> softDeleteKey(String id) async {
    final rows = await (update(sshKeys)..where((k) => k.id.equals(id))).write(
      SshKeysCompanion(
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

  /// Gets all keys changed since [version] (includes soft-deleted).
  Future<List<SshKey>> getChangedSince(int version) {
    return (select(sshKeys)
          ..where((k) => k.syncVersion.isBiggerThanValue(version))
          ..orderBy([(k) => OrderingTerm.asc(k.syncVersion)]))
        .get();
  }

  /// Gets the maximum syncVersion across all key rows.
  Future<int> getMaxSyncVersion() async {
    final expr = sshKeys.syncVersion.max();
    final query = selectOnly(sshKeys)..addColumns([expr]);
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  /// Upserts a key from a remote sync operation.
  Future<void> upsertFromRemote(SshKeysCompanion companion) {
    return into(sshKeys).insertOnConflictUpdate(companion);
  }

  /// Bumps the syncVersion for a key after a local change.
  Future<void> _bumpSyncVersion(String id) async {
    await customStatement(
      'UPDATE ssh_keys SET sync_version = sync_version + 1 WHERE id = ?',
      [id],
    );
  }
}
