// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secrets_dao.dart';

// ignore_for_file: type=lint
mixin _$SecretsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SecretsTable get secrets => attachedDatabase.secrets;
  SecretsDaoManager get managers => SecretsDaoManager(this);
}

class SecretsDaoManager {
  final _$SecretsDaoMixin _db;
  SecretsDaoManager(this._db);
  $$SecretsTableTableManager get secrets =>
      $$SecretsTableTableManager(_db.attachedDatabase, _db.secrets);
}
