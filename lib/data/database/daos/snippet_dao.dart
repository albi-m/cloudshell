/// Data Access Object for command snippet operations.
///
/// Provides typed queries for CRUD operations on the snippets
/// table, including filtering by category.
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/snippets_table.dart';

part 'snippet_dao.g.dart';

/// DAO for command snippet database operations.
@DriftAccessor(tables: [Snippets])
class SnippetDao extends DatabaseAccessor<AppDatabase> with _$SnippetDaoMixin {
  SnippetDao(super.db);

  /// Watches all non-deleted snippets, ordered by category then name.
  Stream<List<Snippet>> watchAllSnippets() {
    return (select(snippets)
          ..where((s) => s.isDeleted.equals(false))
          ..orderBy([
            (s) => OrderingTerm.asc(s.category),
            (s) => OrderingTerm.asc(s.name),
          ]))
        .watch();
  }

  /// Watches snippets in a specific category.
  Stream<List<Snippet>> watchSnippetsByCategory(String category) {
    return (select(snippets)
          ..where(
            (s) => s.isDeleted.equals(false) & s.category.equals(category),
          )
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .watch();
  }

  /// Gets a single snippet by ID.
  Future<Snippet?> getSnippetById(String id) {
    return (select(snippets)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  /// Inserts a new snippet record.
  Future<int> insertSnippet(SnippetsCompanion snippet) {
    return into(snippets).insert(snippet);
  }

  /// Updates an existing snippet record (bumps syncVersion).
  Future<bool> updateSnippet(SnippetsCompanion snippet) async {
    final rows = await (update(snippets)..where((s) => s.id.equals(snippet.id.value)))
        .write(snippet);
    if (rows > 0) await _bumpSyncVersion(snippet.id.value);
    return rows > 0;
  }

  /// Soft-deletes a snippet by setting the isDeleted tombstone (bumps syncVersion).
  Future<int> softDeleteSnippet(String id) async {
    final rows = await (update(snippets)..where((s) => s.id.equals(id))).write(
      SnippetsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (rows > 0) await _bumpSyncVersion(id);
    return rows;
  }

  /// Gets all unique category names for grouping.
  Future<List<String>> getCategories() async {
    final results = await (selectOnly(snippets, distinct: true)
          ..addColumns([snippets.category])
          ..where(snippets.isDeleted.equals(false))
          ..where(snippets.category.isNotNull()))
        .get();
    return results.map((row) => row.read(snippets.category)!).toList();
  }

  // ---------------------------------------------------------------------------
  // Sync operations
  // ---------------------------------------------------------------------------

  /// Gets all snippets changed since [version] (includes soft-deleted).
  Future<List<Snippet>> getChangedSince(int version) {
    return (select(snippets)
          ..where((s) => s.syncVersion.isBiggerThanValue(version))
          ..orderBy([(s) => OrderingTerm.asc(s.syncVersion)]))
        .get();
  }

  /// Gets the maximum syncVersion across all snippet rows.
  Future<int> getMaxSyncVersion() async {
    final expr = snippets.syncVersion.max();
    final query = selectOnly(snippets)..addColumns([expr]);
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  /// Upserts a snippet from a remote sync operation.
  Future<void> upsertFromRemote(SnippetsCompanion companion) {
    return into(snippets).insertOnConflictUpdate(companion);
  }

  /// Resets syncVersion to 0 so the sync engine re-pushes the item.
  Future<void> _bumpSyncVersion(String id) async {
    await customStatement(
      'UPDATE snippets SET sync_version = 0 WHERE id = ?',
      [id],
    );
  }
}
