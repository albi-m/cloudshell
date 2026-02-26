import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloudshell/ui/onboarding/onboarding_screen.dart';
import 'package:cloudshell/data/database/app_database.dart';
import '../../helpers/test_database.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('renders first slide with page indicators', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const OnboardingScreen(),
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Verify PageView exists
    expect(find.byType(PageView), findsOneWidget);

    // Verify 4 page indicator dots (AnimatedContainer)
    final indicators = find.descendant(
      of: find.byType(Row),
      matching: find.byType(AnimatedContainer),
    );
    expect(indicators, findsNWidgets(4));
  });

  testWidgets('shows Skip button', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const OnboardingScreen(),
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Verify Skip button exists
    expect(find.widgetWithText(TextButton, 'Skip'), findsOneWidget);
  });

  testWidgets('shows Next button on first page', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const OnboardingScreen(),
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Verify Next button exists on first page
    expect(find.widgetWithText(ElevatedButton, 'Next'), findsOneWidget);
  });
}
