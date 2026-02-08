/// Data Access Object for application settings.
///
/// Provides typed queries for the key-value settings store,
/// with convenience methods for common setting types.
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/settings_table.dart';

part 'settings_dao.g.dart';

/// DAO for application settings key-value store.
///
/// Settings are stored as string values. Callers are responsible
/// for encoding/decoding typed values.
@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(super.db);

  /// Gets a setting value by key, or null if not set.
  Future<String?> getValue(String key) async {
    final result =
        await (select(settings)..where((s) => s.key.equals(key))).getSingleOrNull();
    return result?.value;
  }

  /// Sets a setting value, creating or updating as needed.
  Future<void> setValue(String key, String value) async {
    await into(settings).insertOnConflictUpdate(
      SettingsCompanion(
        key: Value(key),
        value: Value(value),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Deletes a setting by key.
  Future<int> deleteValue(String key) {
    return (delete(settings)..where((s) => s.key.equals(key))).go();
  }

  /// Watches a setting value reactively.
  Stream<String?> watchValue(String key) {
    return (select(settings)..where((s) => s.key.equals(key)))
        .watchSingleOrNull()
        .map((row) => row?.value);
  }

  /// Gets all settings as a key-value map.
  Future<Map<String, String>> getAllSettings() async {
    final results = await select(settings).get();
    return {for (final row in results) row.key: row.value};
  }
}
