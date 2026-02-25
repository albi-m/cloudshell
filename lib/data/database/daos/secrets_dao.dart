/// Data Access Object for encrypted secrets storage.
///
/// Provides typed queries for the secrets key-value store.
/// Values are stored pre-encrypted — this DAO handles only
/// the database operations, not encryption/decryption.
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/secrets_table.dart';

part 'secrets_dao.g.dart';

/// DAO for encrypted secrets key-value store.
///
/// All values stored and retrieved are already encrypted/decrypted
/// by the calling service (SecureStorageService).
@DriftAccessor(tables: [Secrets])
class SecretsDao extends DatabaseAccessor<AppDatabase> with _$SecretsDaoMixin {
  SecretsDao(super.db);

  /// Gets a secret row by key, or null if not found.
  Future<Secret?> getSecret(String key) {
    return (select(secrets)..where((s) => s.key.equals(key)))
        .getSingleOrNull();
  }

  /// Upserts a secret (insert or update on conflict).
  Future<void> setSecret(String key, String encryptedValue, String nonce) {
    return into(secrets).insertOnConflictUpdate(
      SecretsCompanion(
        key: Value(key),
        encryptedValue: Value(encryptedValue),
        nonce: Value(nonce),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Deletes a secret by key.
  Future<int> deleteSecret(String key) {
    return (delete(secrets)..where((s) => s.key.equals(key))).go();
  }

  /// Checks whether a secret exists.
  Future<bool> containsSecret(String key) async {
    final row = await (select(secrets)..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return row != null;
  }
}
