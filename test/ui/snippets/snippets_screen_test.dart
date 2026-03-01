import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloudshell/ui/snippets/snippets_screen.dart';
import 'package:cloudshell/ui/shared/empty_state.dart';
import 'package:cloudshell/providers/snippet_provider.dart';
import 'package:cloudshell/data/database/app_database.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('SnippetsScreen', () {
    final now = DateTime.now();

    final testSnippet = Snippet(
      id: 's1',
      name: 'List Files',
      command: 'ls -la',
      category: 'System',
      variables: '[]',
      createdAt: now,
      updatedAt: now,
      syncVersion: 0,
      isDeleted: false,
    );

    testWidgets('shows empty state when no snippets', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const SnippetsScreen(),
          overrides: [
            allSnippetsProvider.overrideWith((ref) => Stream.value([])),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(EmptyState), findsOneWidget);
    });

    testWidgets('renders snippet list with data', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const SnippetsScreen(),
          overrides: [
            allSnippetsProvider
                .overrideWith((ref) => Stream.value([testSnippet])),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('List Files'), findsOneWidget);
      expect(find.byType(EmptyState), findsNothing);
    });

    testWidgets('shows add button in app bar', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const SnippetsScreen(),
          overrides: [
            allSnippetsProvider
                .overrideWith((ref) => Stream.value([testSnippet])),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.plus), findsOneWidget);
    });
  });
}
