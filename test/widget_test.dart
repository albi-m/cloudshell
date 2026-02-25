// Smoke test for CloudShell app startup.
// Verifies that the app widget tree initializes without errors.

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloudshell/app.dart';
import 'package:cloudshell/data/database/app_database.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    final testDb = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
        ],
        child: const CloudShellApp(),
      ),
    );

    // Let async providers settle
    await tester.pumpAndSettle();

    // Verify the app renders
    expect(find.byType(CloudShellApp), findsOneWidget);

    await testDb.close();
  });
}
