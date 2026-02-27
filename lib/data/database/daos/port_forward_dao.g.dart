// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'port_forward_dao.dart';

// ignore_for_file: type=lint
mixin _$PortForwardDaoMixin on DatabaseAccessor<AppDatabase> {
  $PortForwardsTable get portForwards => attachedDatabase.portForwards;
  PortForwardDaoManager get managers => PortForwardDaoManager(this);
}

class PortForwardDaoManager {
  final _$PortForwardDaoMixin _db;
  PortForwardDaoManager(this._db);
  $$PortForwardsTableTableManager get portForwards =>
      $$PortForwardsTableTableManager(_db.attachedDatabase, _db.portForwards);
}
