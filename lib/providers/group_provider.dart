/// Riverpod providers for host group state management.
///
/// Exposes reactive streams of host group data from the
/// database for use in UI widgets.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Provides a reactive stream of all non-deleted host groups.
///
/// Rebuilds whenever a group is created, updated, or soft-deleted in the database.
final allGroupsProvider = StreamProvider<List<HostGroup>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.groupDao.watchAllGroups();
});

/// Provides top-level groups that have no parent (root of the group hierarchy).
///
/// Rebuilds when any group's parentGroupId changes or groups are added/removed.
final topLevelGroupsProvider = StreamProvider<List<HostGroup>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.groupDao.watchTopLevelGroups();
});

/// Provides child groups for a given parent group ID in the nested group hierarchy.
///
/// Parameterized by parent group ID. Rebuilds when children are added, removed,
/// or re-parented under the specified group.
final childGroupsProvider =
    StreamProvider.family<List<HostGroup>, String>((ref, parentId) {
  final db = ref.watch(databaseProvider);
  return db.groupDao.watchChildGroups(parentId);
});

/// Provides a single group by ID as a one-shot future lookup.
///
/// Returns null if the group does not exist. Does not stream updates.
final groupByIdProvider = FutureProvider.family<HostGroup?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.groupDao.getGroupById(id);
});
