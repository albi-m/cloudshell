/// Riverpod providers for SSH host state management.
///
/// Exposes reactive streams of host data from the database
/// and provides methods for host CRUD operations.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Provides a reactive stream of all non-deleted hosts.
///
/// Automatically updates when hosts are added, modified,
/// or soft-deleted in the database.
final allHostsProvider = StreamProvider<List<Host>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.hostDao.watchAllHosts();
});

/// Provides a reactive stream of favorite hosts only.
final favoriteHostsProvider = StreamProvider<List<Host>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.hostDao.watchFavoriteHosts();
});

/// Provides hosts filtered by a specific group ID.
final hostsByGroupProvider = StreamProvider.family<List<Host>, String>((ref, groupId) {
  final db = ref.watch(databaseProvider);
  return db.hostDao.watchHostsByGroup(groupId);
});

/// Provides a single host by ID.
final hostByIdProvider = FutureProvider.family<Host?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.hostDao.getHostById(id);
});
