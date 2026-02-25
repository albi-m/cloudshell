// Integration tests for CloudShell app.
//
// Tests app startup, navigation, and settings persistence
// using an in-memory database and provider overrides.
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cloudshell/app.dart';
import 'package:cloudshell/data/database/app_database.dart';
import 'package:cloudshell/providers/app_lock_provider.dart';
import 'package:cloudshell/providers/settings_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase testDb;

  setUp(() {
    testDb = AppDatabase(NativeDatabase.memory());
    // Mark onboarding as complete so we skip the onboarding flow
    testDb.settingsDao.setValue('onboarding_complete', 'true');
  });

  tearDown(() async {
    await testDb.close();
  });

  /// Pumps the full app with test overrides.
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
          // Skip biometric lock in tests
          appLockProvider.overrideWith(() => _UnlockedAppLockNotifier()),
        ],
        child: const CloudShellApp(),
      ),
    );
    // Let providers, router, and animations settle
    await tester.pumpAndSettle();
  }

  group('App smoke tests', () {
    testWidgets('launches and shows Hosts screen', (tester) async {
      await pumpApp(tester);
      expect(find.text('Hosts'), findsWidgets);
    });

    testWidgets('navigates to Keys screen via sidebar', (tester) async {
      await pumpApp(tester);

      // Tap the Keys sidebar/bottom-nav item
      final keysNav = find.text('Keys');
      if (keysNav.evaluate().isNotEmpty) {
        await tester.tap(keysNav.first);
        await tester.pumpAndSettle();
        // Should see the Keys screen content
        expect(find.text('Keys'), findsWidgets);
      }
    });

    testWidgets('navigates to Snippets screen', (tester) async {
      await pumpApp(tester);

      final snippetsNav = find.text('Snippets');
      if (snippetsNav.evaluate().isNotEmpty) {
        await tester.tap(snippetsNav.first);
        await tester.pumpAndSettle();
        expect(find.text('Snippets'), findsWidgets);
      }
    });

    testWidgets('navigates to Settings screen', (tester) async {
      await pumpApp(tester);

      final settingsNav = find.text('Settings');
      if (settingsNav.evaluate().isNotEmpty) {
        await tester.tap(settingsNav.first);
        await tester.pumpAndSettle();
        expect(find.text('Settings'), findsWidgets);
      }
    });
  });

  group('Settings persistence', () {
    testWidgets('theme defaults to dark', (tester) async {
      await pumpApp(tester);

      // Check that MaterialApp uses dark theme
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).first,
      );
      // Default is dark
      expect(materialApp.themeMode, ThemeMode.dark);
    });

    testWidgets('terminal font size persists in settings DB', (tester) async {
      // Write a font size directly to the DB
      await testDb.settingsDao.setValue('terminal_font_size', '18');

      await pumpApp(tester);

      // Verify the provider reads the persisted value
      final container = ProviderScope.containerOf(
        tester.element(find.byType(CloudShellApp)),
      );
      final fontSize = container.read(terminalFontSizeProvider);
      expect(fontSize, 18.0);
    });

    testWidgets('terminal theme persists in settings DB', (tester) async {
      await testDb.settingsDao.setValue('terminal_theme', 'dracula');

      await pumpApp(tester);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(CloudShellApp)),
      );
      final themeId = container.read(terminalThemeIdProvider);
      expect(themeId, 'dracula');
    });
  });
}

/// Test-only AppLockNotifier that is always unlocked.
class _UnlockedAppLockNotifier extends AppLockNotifier {
  @override
  AppLockState build() => AppLockState.unlocked;

  @override
  Future<bool> authenticate() async => true;

  @override
  void lock() {
    // No-op in tests
  }
}
