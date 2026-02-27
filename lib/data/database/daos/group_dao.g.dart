// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_dao.dart';

// ignore_for_file: type=lint
mixin _$GroupDaoMixin on DatabaseAccessor<AppDatabase> {
  $HostGroupsTable get hostGroups => attachedDatabase.hostGroups;
  $HostsTable get hosts => attachedDatabase.hosts;
  GroupDaoManager get managers => GroupDaoManager(this);
}

class GroupDaoManager {
  final _$GroupDaoMixin _db;
  GroupDaoManager(this._db);
  $$HostGroupsTableTableManager get hostGroups =>
      $$HostGroupsTableTableManager(_db.attachedDatabase, _db.hostGroups);
  $$HostsTableTableManager get hosts =>
      $$HostsTableTableManager(_db.attachedDatabase, _db.hosts);
}
