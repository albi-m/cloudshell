/// Riverpod providers for port forwarding rule state management.
///
/// Exposes reactive streams of port forward rules from the database,
/// with filtering by host and lookup by ID.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Provides a reactive stream of all non-deleted port forward rules.
final allPortForwardsProvider = StreamProvider<List<PortForward>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.portForwardDao.watchAllPortForwards();
});

/// Provides port forward rules filtered by host ID.
final portForwardsByHostProvider =
    StreamProvider.family<List<PortForward>, String>((ref, hostId) {
  final db = ref.watch(databaseProvider);
  return db.portForwardDao.watchPortForwardsByHost(hostId);
});

/// Provides a single port forward rule by ID.
final portForwardByIdProvider =
    FutureProvider.family<PortForward?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.portForwardDao.getPortForwardById(id);
});
