/// Riverpod providers for port forwarding rule state management.
///
/// Exposes reactive streams of port forward rules from the database,
/// with filtering by host and lookup by ID.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Provides a reactive stream of all non-deleted port forward rules.
///
/// Rebuilds whenever a rule is created, updated, or soft-deleted in the database.
final allPortForwardsProvider = StreamProvider<List<PortForward>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.portForwardDao.watchAllPortForwards();
});

/// Provides port forward rules filtered by host ID.
///
/// Parameterized by host ID. Rebuilds when the host's forwarding rules change.
final portForwardsByHostProvider =
    StreamProvider.family<List<PortForward>, String>((ref, hostId) {
  final db = ref.watch(databaseProvider);
  return db.portForwardDao.watchPortForwardsByHost(hostId);
});

/// Provides a single port forward rule by ID as a one-shot future lookup.
///
/// Returns null if the rule does not exist. Does not stream updates.
final portForwardByIdProvider =
    FutureProvider.family<PortForward?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.portForwardDao.getPortForwardById(id);
});
