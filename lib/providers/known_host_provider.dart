/// Riverpod providers for known SSH host key management.
///
/// Provides reactive access to trusted host fingerprints
/// used in the TOFU verification model.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Watches all known (trusted) SSH host fingerprints reactively.
///
/// Rebuilds whenever a host fingerprint is added, removed, or updated
/// in the TOFU (Trust On First Use) verification store.
final allKnownHostsProvider = StreamProvider<List<KnownHost>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.knownHostDao.watchAllKnownHosts();
});
