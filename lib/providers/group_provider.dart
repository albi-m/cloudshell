/// Riverpod providers for host group state management.
///
/// Exposes reactive streams of host group data from the
/// database for use in UI widgets.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Provides a reactive stream of all non-deleted host groups.
final allGroupsProvider = StreamProvider<List<HostGroup>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.groupDao.watchAllGroups();
});

/// Provides a single group by ID.
final groupByIdProvider = FutureProvider.family<HostGroup?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.groupDao.getGroupById(id);
});
