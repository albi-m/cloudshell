import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';

import 'package:cloudshell/data/database/app_database.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  // ignore: no_leading_underscores_for_local_identifiers
  SnippetsCompanion _makeSnippet({
    String id = 'snip-1',
    String name = 'List Files',
    String command = 'ls -la',
    String? category,
  }) {
    final now = DateTime.now();
    return SnippetsCompanion(
      id: Value(id),
      name: Value(name),
      command: Value(command),
      category: Value(category),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  group('SnippetDao', () {
    test('insertSnippet and getSnippetById', () async {
      await db.snippetDao.insertSnippet(_makeSnippet());
      final snippet = await db.snippetDao.getSnippetById('snip-1');
      expect(snippet, isNotNull);
      expect(snippet!.name, 'List Files');
      expect(snippet.command, 'ls -la');
    });

    test('watchAllSnippets emits inserted snippets', () async {
      await db.snippetDao.insertSnippet(
          _makeSnippet(id: 's1', name: 'Alpha'));
      await db.snippetDao.insertSnippet(
          _makeSnippet(id: 's2', name: 'Beta'));

      final snippets = await db.snippetDao.watchAllSnippets().first;
      expect(snippets, hasLength(2));
    });

    test('watchSnippetsByCategory filters correctly', () async {
      await db.snippetDao.insertSnippet(
          _makeSnippet(id: 's1', name: 'Docker PS', category: 'Docker'));
      await db.snippetDao.insertSnippet(
          _makeSnippet(id: 's2', name: 'Git Status', category: 'Git'));

      final docker =
          await db.snippetDao.watchSnippetsByCategory('Docker').first;
      expect(docker, hasLength(1));
      expect(docker[0].name, 'Docker PS');
    });

    test('softDeleteSnippet filters from watchAllSnippets', () async {
      await db.snippetDao.insertSnippet(_makeSnippet());
      await db.snippetDao.softDeleteSnippet('snip-1');

      final snippets = await db.snippetDao.watchAllSnippets().first;
      expect(snippets, isEmpty);
    });

    test('getCategories returns unique non-null categories', () async {
      await db.snippetDao.insertSnippet(
          _makeSnippet(id: 's1', category: 'Docker'));
      await db.snippetDao.insertSnippet(
          _makeSnippet(id: 's2', category: 'Docker'));
      await db.snippetDao.insertSnippet(
          _makeSnippet(id: 's3', category: 'Git'));
      await db.snippetDao.insertSnippet(
          _makeSnippet(id: 's4'));

      final categories = await db.snippetDao.getCategories();
      expect(categories, containsAll(['Docker', 'Git']));
      expect(categories, hasLength(2));
    });
  });
}
