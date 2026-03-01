// Smoke test for CloudShell app startup.
// Verifies that the app widget tree initializes without errors.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cloudshell/app.dart';
import 'package:cloudshell/data/database/app_database.dart';
import 'package:cloudshell/providers/settings_provider.dart';
import 'package:cloudshell/router/app_router.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    final testDb = AppDatabase(NativeDatabase.memory());

    // Minimal router that avoids cascading provider dependencies
    final testRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('Test')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
          themeModeProvider.overrideWithValue(ThemeMode.dark),
          localeProvider.overrideWithValue(null),
          appRouterProvider.overrideWithValue(testRouter),
        ],
        child: const CloudShellApp(),
      ),
    );

    await tester.pump();

    expect(find.byType(CloudShellApp), findsOneWidget);

    await testDb.close();
  });
}
