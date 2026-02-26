import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloudshell/ui/hosts/hosts_screen.dart';
import 'package:cloudshell/ui/shared/empty_state.dart';
import 'package:cloudshell/providers/host_provider.dart';
import 'package:cloudshell/providers/group_provider.dart';
import 'package:cloudshell/data/database/app_database.dart';
import 'package:cloudshell/data/database/tables/hosts_table.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('HostsScreen', () {
    final now = DateTime.now();

    final testHost = Host(
      id: 'h1',
      label: 'My Server',
      hostname: 'example.com',
      port: 22,
      username: 'admin',
      authMethod: AuthMethodType.password,
      tags: '',
      keepAliveSeconds: 60,
      sortOrder: 0,
      isFavorite: false,
      createdAt: now,
      updatedAt: now,
      syncVersion: 0,
      isDeleted: false,
      protocol: ProtocolType.ssh,
    );

    testWidgets('shows empty state when no hosts', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const HostsScreen(),
          overrides: [
            allHostsProvider.overrideWith((ref) => Stream.value([])),
            allGroupsProvider.overrideWith((ref) => Stream.value([])),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(EmptyState), findsOneWidget);
    });

    testWidgets('renders host list with data', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const HostsScreen(),
          overrides: [
            allHostsProvider.overrideWith((ref) => Stream.value([testHost])),
            allGroupsProvider.overrideWith((ref) => Stream.value([])),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('My Server'), findsOneWidget);
      expect(find.byType(EmptyState), findsNothing);
    });

    testWidgets('shows search bar when hosts exist', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const HostsScreen(),
          overrides: [
            allHostsProvider.overrideWith((ref) => Stream.value([testHost])),
            allGroupsProvider.overrideWith((ref) => Stream.value([])),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows quick connect button in app bar', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const HostsScreen(),
          overrides: [
            allHostsProvider.overrideWith((ref) => Stream.value([testHost])),
            allGroupsProvider.overrideWith((ref) => Stream.value([])),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.zap), findsOneWidget);
    });

    testWidgets('shows add host button in app bar', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const HostsScreen(),
          overrides: [
            allHostsProvider.overrideWith((ref) => Stream.value([testHost])),
            allGroupsProvider.overrideWith((ref) => Stream.value([])),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.plus), findsOneWidget);
    });
  });
}
