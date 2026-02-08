/// Riverpod providers for command snippet state management.
///
/// Exposes reactive streams of snippets from the database,
/// organized by category for the snippet picker UI.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Provides a reactive stream of all non-deleted snippets.
final allSnippetsProvider = StreamProvider<List<Snippet>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.snippetDao.watchAllSnippets();
});

/// Provides snippets filtered by category.
final snippetsByCategoryProvider = StreamProvider.family<List<Snippet>, String>((ref, category) {
  final db = ref.watch(databaseProvider);
  return db.snippetDao.watchSnippetsByCategory(category);
});

/// Provides the list of unique snippet category names.
final snippetCategoriesProvider = FutureProvider<List<String>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.snippetDao.getCategories();
});
