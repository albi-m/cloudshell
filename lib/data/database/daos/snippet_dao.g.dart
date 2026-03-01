// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snippet_dao.dart';

// ignore_for_file: type=lint
mixin _$SnippetDaoMixin on DatabaseAccessor<AppDatabase> {
  $SnippetsTable get snippets => attachedDatabase.snippets;
  SnippetDaoManager get managers => SnippetDaoManager(this);
}

class SnippetDaoManager {
  final _$SnippetDaoMixin _db;
  SnippetDaoManager(this._db);
  $$SnippetsTableTableManager get snippets =>
      $$SnippetsTableTableManager(_db.attachedDatabase, _db.snippets);
}
