// Smoke test for CloudShell app startup.
// Verifies that the app widget tree initializes without errors.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloudshell/app.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CloudShellApp(),
      ),
    );

    // Verify the app renders the hosts screen title
    expect(find.text('Hosts'), findsOneWidget);
  });
}
