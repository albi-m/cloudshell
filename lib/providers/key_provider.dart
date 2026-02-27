/// Riverpod providers for SSH key state management.
///
/// Exposes reactive streams of SSH key metadata from the
/// database for use in UI widgets.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Provides a reactive stream of all non-deleted SSH key metadata.
///
/// Rebuilds whenever keys are imported, removed, or renamed in the database.
/// Private key material is stored separately in secure storage, not in this stream.
final allKeysProvider = StreamProvider<List<SshKey>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.keyDao.watchAllKeys();
});

/// Provides a single SSH key by ID as a one-shot future lookup.
///
/// Returns null if the key does not exist. Does not stream updates.
final keyByIdProvider = FutureProvider.family<SshKey?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.keyDao.getKeyById(id);
});

/// Provides a reactive stream of hosts that reference a specific SSH key.
///
/// Parameterized by key ID. Rebuilds when hosts are assigned to or unassigned
/// from the given key. Used on the key detail screen to show associated hosts.
final hostsByKeyIdProvider = StreamProvider.family<List<Host>, String>((ref, keyId) {
  final db = ref.watch(databaseProvider);
  return db.hostDao.watchHostsByKeyId(keyId);
});
