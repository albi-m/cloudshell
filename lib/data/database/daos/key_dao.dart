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

  /// Updates an existing SSH key record.
  Future<bool> updateKey(SshKeysCompanion key) {
    return (update(sshKeys)..where((k) => k.id.equals(key.id.value)))
        .write(key)
        .then((rows) => rows > 0);
  }

  /// Soft-deletes an SSH key by setting the isDeleted tombstone.
  Future<int> softDeleteKey(String id) {
    return (update(sshKeys)..where((k) => k.id.equals(id))).write(
      SshKeysCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
