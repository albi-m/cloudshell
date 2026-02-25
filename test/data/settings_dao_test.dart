import 'package:flutter_test/flutter_test.dart';

import 'package:cloudshell/data/database/app_database.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('SettingsDao', () {
    test('setValue and getValue round-trip', () async {
      await db.settingsDao.setValue('theme', 'dark');
      final value = await db.settingsDao.getValue('theme');
      expect(value, 'dark');
    });

    test('getValue returns null for non-existent key', () async {
      final value = await db.settingsDao.getValue('missing-key');
      expect(value, isNull);
    });

    test('setValue overwrites existing value', () async {
      await db.settingsDao.setValue('theme', 'dark');
      await db.settingsDao.setValue('theme', 'light');
      final value = await db.settingsDao.getValue('theme');
      expect(value, 'light');
    });

    test('deleteValue removes the key', () async {
      await db.settingsDao.setValue('theme', 'dark');
      await db.settingsDao.deleteValue('theme');
      final value = await db.settingsDao.getValue('theme');
      expect(value, isNull);
    });

    test('watchValue emits updates', () async {
      // Listen to the stream before making changes
      final values = <String?>[];
      final sub = db.settingsDao.watchValue('font_size').listen(values.add);

      // Wait for initial emission
      await Future.delayed(const Duration(milliseconds: 100));
      expect(values, contains(isNull));

      // Set a value and wait for the stream update
      await db.settingsDao.setValue('font_size', '14');
      await Future.delayed(const Duration(milliseconds: 100));
      expect(values, contains('14'));

      await sub.cancel();
    });

    test('getAllSettings returns all key-value pairs', () async {
      await db.settingsDao.setValue('theme', 'dark');
      await db.settingsDao.setValue('font_size', '14');

      final all = await db.settingsDao.getAllSettings();
      expect(all, hasLength(2));
      expect(all['theme'], 'dark');
      expect(all['font_size'], '14');
    });
  });
}
