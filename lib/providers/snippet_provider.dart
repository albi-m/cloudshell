/// Riverpod providers for command snippet state management.
///
/// Exposes reactive streams of snippets from the database,
/// organized by category for the snippet picker UI.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Provides a reactive stream of all non-deleted command snippets.
///
/// Rebuilds whenever a snippet is created, updated, or soft-deleted in the database.
final allSnippetsProvider = StreamProvider<List<Snippet>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.snippetDao.watchAllSnippets();
});

/// Provides snippets filtered by category name.
///
/// Parameterized by category string. Rebuilds when snippets in the given
/// category are added, removed, or have their category changed.
final snippetsByCategoryProvider = StreamProvider.family<List<Snippet>, String>((ref, category) {
  final db = ref.watch(databaseProvider);
  return db.snippetDao.watchSnippetsByCategory(category);
});

/// Provides the list of unique snippet category names as a one-shot future.
///
/// Used to populate category filter dropdowns. Does not stream updates;
/// invalidate manually after creating a snippet with a new category.
final snippetCategoriesProvider = FutureProvider<List<String>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.snippetDao.getCategories();
});
