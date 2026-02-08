/// Riverpod providers for SSH key state management.
///
/// Exposes reactive streams of SSH key metadata from the
/// database for use in UI widgets.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Provides a reactive stream of all non-deleted SSH keys.
final allKeysProvider = StreamProvider<List<SshKey>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.keyDao.watchAllKeys();
});

/// Provides a single SSH key by ID.
final keyByIdProvider = FutureProvider.family<SshKey?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.keyDao.getKeyById(id);
});

/// Provides a reactive stream of hosts that use a specific SSH key.
final hostsByKeyIdProvider = StreamProvider.family<List<Host>, String>((ref, keyId) {
  final db = ref.watch(databaseProvider);
  return db.hostDao.watchHostsByKeyId(keyId);
});
