/// Riverpod providers for SSH host state management.
///
/// Exposes reactive streams of host data from the database
/// and provides methods for host CRUD operations.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Provides a reactive stream of all non-deleted SSH hosts.
///
/// Rebuilds whenever hosts are added, modified, or soft-deleted in the database.
/// Watched by the hosts list screen and any widget needing the full host inventory.
final allHostsProvider = StreamProvider<List<Host>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.hostDao.watchAllHosts();
});

/// Provides a reactive stream of hosts marked as favorites.
///
/// Rebuilds when a host's favorite flag changes or a favorite host is added/removed.
final favoriteHostsProvider = StreamProvider<List<Host>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.hostDao.watchFavoriteHosts();
});

/// Provides hosts filtered by a specific group ID.
///
/// Parameterized by group ID. Rebuilds when hosts are added to, removed from,
/// or moved between groups.
final hostsByGroupProvider = StreamProvider.family<List<Host>, String>((ref, groupId) {
  final db = ref.watch(databaseProvider);
  return db.hostDao.watchHostsByGroup(groupId);
});

/// Provides a single host by ID as a one-shot future lookup.
///
/// Returns null if the host does not exist. Does not stream updates.
final hostByIdProvider = FutureProvider.family<Host?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.hostDao.getHostById(id);
});
