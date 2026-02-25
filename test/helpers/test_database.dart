// Test helper for creating in-memory databases.
//
// Used across all DAO and provider tests to avoid touching
// the real database file.
import 'package:drift/native.dart';

import 'package:cloudshell/data/database/app_database.dart';

/// Creates a fresh in-memory [AppDatabase] for testing.
///
/// Each call returns a new database instance — no state is shared
/// between tests. Caller must close the database in `tearDown`.
AppDatabase createTestDatabase() {
  return AppDatabase(NativeDatabase.memory());
}
