import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import 'package:cloudshell/providers/app_lock_provider.dart';
import 'package:cloudshell/providers/auth_provider.dart';
import 'package:cloudshell/providers/backend_provider.dart';
import 'package:cloudshell/providers/settings_provider.dart';
import 'package:cloudshell/providers/sync_provider.dart';
import 'package:cloudshell/providers/totp_provider.dart';
import 'package:cloudshell/providers/vault_provider.dart';
import 'package:cloudshell/ui/settings/settings_screen.dart';

import '../../helpers/widget_test_helpers.dart';

class _TestVaultNotifier extends VaultNotifier {
  @override
  Future<VaultState> build() async => VaultState.noVault;
}

class _TestAuthNotifier extends AuthNotifier {
  @override
  Future<AuthState> build() async => AuthState.localOnly;
}

void main() {
  // Override ALL streaming/async providers so no Drift database streams
  // are created. This prevents pending timer errors on widget disposal.
  List<Override> buildOverrides() => [
        // Root settings stream — override family to skip database entirely
        settingProvider.overrideWith((ref, key) => Stream.value(null)),
        allSettingsProvider.overrideWith((ref) async => <String, String>{}),

        // Derived settings providers with sensible defaults
        themeModeProvider.overrideWithValue(ThemeMode.dark),
        terminalThemeIdProvider.overrideWithValue('cloudshell_default'),
        terminalFontSizeProvider.overrideWithValue(14.0),
        terminalFontFamilyProvider.overrideWithValue('JetBrainsMono'),
        terminalCursorStyleProvider.overrideWithValue('block'),
        terminalLigaturesProvider.overrideWithValue(true),
        defaultSshPortProvider.overrideWithValue(22),
        defaultTimeoutProvider.overrideWithValue(30),
        defaultKeepAliveProvider.overrideWithValue(60),
        commandNotifyEnabledProvider.overrideWithValue(true),
        commandNotifyThresholdProvider.overrideWithValue(10),

        // Auth & vault
        vaultProvider.overrideWith(() => _TestVaultNotifier()),
        authProvider.overrideWith(() => _TestAuthNotifier()),
        authBackendProvider.overrideWithValue(null),
        backendAvailableProvider.overrideWithValue(false),
        isAuthenticatedProvider.overrideWithValue(false),
        isVaultUnlockedProvider.overrideWithValue(false),
        totpEnabledProvider.overrideWith((ref) async => false),
        vaultAutoLockTimeoutProvider.overrideWithValue(0),
        biometricLockEnabledProvider.overrideWithValue(false),
        appLockGracePeriodProvider.overrideWithValue(0),

        // Sync
        syncEnabledProvider.overrideWithValue(false),
        syncReadyProvider.overrideWithValue(false),
        pendingSyncCountProvider.overrideWith((ref) => Stream.value(0)),
        lastSyncTimeProvider.overrideWith((ref) async => null),
      ];

  group('SettingsScreen', () {
    testWidgets('renders Settings title', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const SettingsScreen(),
          overrides: buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders Appearance section', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const SettingsScreen(),
          overrides: buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // SettingsSection calls title.toUpperCase()
      expect(find.text('APPEARANCE'), findsOneWidget);
    });

    testWidgets('renders Connection section', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const SettingsScreen(),
          overrides: buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('CONNECTION'), findsOneWidget);
    });

    testWidgets('renders Security section', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const SettingsScreen(),
          overrides: buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Security section is below the fold — scroll down to render it
      await tester.scrollUntilVisible(
        find.text('SECURITY'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('SECURITY'), findsOneWidget);
    });
  });
}
