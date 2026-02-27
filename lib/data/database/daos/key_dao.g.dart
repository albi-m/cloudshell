// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_dao.dart';

// ignore_for_file: type=lint
mixin _$KeyDaoMixin on DatabaseAccessor<AppDatabase> {
  $SshKeysTable get sshKeys => attachedDatabase.sshKeys;
  KeyDaoManager get managers => KeyDaoManager(this);
}

class KeyDaoManager {
  final _$KeyDaoMixin _db;
  KeyDaoManager(this._db);
  $$SshKeysTableTableManager get sshKeys =>
      $$SshKeysTableTableManager(_db.attachedDatabase, _db.sshKeys);
}
