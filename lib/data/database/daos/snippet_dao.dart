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

  /// Updates an existing snippet record.
  Future<bool> updateSnippet(SnippetsCompanion snippet) {
    return (update(snippets)..where((s) => s.id.equals(snippet.id.value)))
        .write(snippet)
        .then((rows) => rows > 0);
  }

  /// Soft-deletes a snippet by setting the isDeleted tombstone.
  Future<int> softDeleteSnippet(String id) {
    return (update(snippets)..where((s) => s.id.equals(id))).write(
      SnippetsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
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
}
