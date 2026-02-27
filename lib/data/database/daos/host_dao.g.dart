// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_dao.dart';

// ignore_for_file: type=lint
mixin _$HostDaoMixin on DatabaseAccessor<AppDatabase> {
  $HostsTable get hosts => attachedDatabase.hosts;
  HostDaoManager get managers => HostDaoManager(this);
}

class HostDaoManager {
  final _$HostDaoMixin _db;
  HostDaoManager(this._db);
  $$HostsTableTableManager get hosts =>
      $$HostsTableTableManager(_db.attachedDatabase, _db.hosts);
}
