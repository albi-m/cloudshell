import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloudshell/ui/keys/keys_screen.dart';
import 'package:cloudshell/ui/shared/empty_state.dart';
import 'package:cloudshell/providers/key_provider.dart';
import 'package:cloudshell/data/database/app_database.dart';
import 'package:cloudshell/data/database/tables/keys_table.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('KeysScreen', () {
    final now = DateTime.now();

    final testKey = SshKey(
      id: 'k1',
      label: 'My Key',
      keyType: KeyTypeEnum.ed25519,
      publicKey: 'ssh-ed25519 AAAA...',
      privateKeyRef: 'ref_k1',
      fingerprint: 'SHA256:abc123def456',
      createdAt: now,
      updatedAt: now,
      syncVersion: 0,
      isDeleted: false,
      hasPassphrase: false,
    );

    testWidgets('shows empty state when no keys', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const KeysScreen(),
          overrides: [
            allKeysProvider.overrideWith((ref) => Stream.value([])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyState), findsOneWidget);
    });

    testWidgets('renders key list with data', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const KeysScreen(),
          overrides: [
            allKeysProvider.overrideWith((ref) => Stream.value([testKey])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Key'), findsOneWidget);
    });

    testWidgets('shows import button in app bar', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const KeysScreen(),
          overrides: [
            allKeysProvider.overrideWith((ref) => Stream.value([])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.plus), findsOneWidget);
    });
  });
}
