/// Riverpod providers for application settings state management.
///
/// Provides reactive access to user preferences stored in
/// the settings key-value table.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

/// Provides a reactive stream of a single setting value by key.
///
/// Usage:
/// ```dart
/// final theme = ref.watch(settingProvider('terminal_theme'));
/// ```
final settingProvider = StreamProvider.family<String?, String>((ref, key) {
  final db = ref.watch(databaseProvider);
  return db.settingsDao.watchValue(key);
});

/// Provides all settings as a map for batch reads.
final allSettingsProvider = FutureProvider<Map<String, String>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.settingsDao.getAllSettings();
});

/// Notifier for updating settings values.
///
/// Usage:
/// ```dart
/// ref.read(settingsNotifierProvider.notifier).set('terminal_theme', 'dracula');
/// ```
final settingsNotifierProvider = AsyncNotifierProvider<SettingsNotifier, void>(
  SettingsNotifier.new,
);

/// Async notifier that provides methods for modifying settings.
class SettingsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Sets a setting value by key.
  Future<void> set(String key, String value) async {
    final db = ref.read(databaseProvider);
    await db.settingsDao.setValue(key, value);
  }

  /// Deletes a setting by key.
  Future<void> delete(String key) async {
    final db = ref.read(databaseProvider);
    await db.settingsDao.deleteValue(key);
  }
}
