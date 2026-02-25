/// Riverpod providers for known SSH host key management.
///
/// Provides reactive access to trusted host fingerprints
/// used in the TOFU verification model.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Watches all known hosts reactively.
final allKnownHostsProvider = StreamProvider<List<KnownHost>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.knownHostDao.watchAllKnownHosts();
});
