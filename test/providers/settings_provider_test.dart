import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudshell/providers/settings_provider.dart';

/// Helper: creates a ProviderContainer that overrides a single settingProvider
/// key with the given value using [overrideWithValue] so the provider
/// is immediately in the [AsyncData] state.
ProviderContainer _containerWithSetting(String key, String? value) {
  return ProviderContainer(overrides: [
    settingProvider(key).overrideWithValue(AsyncData(value)),
  ]);
}

void main() {
  group('themeModeProvider', () {
    test('defaults to dark when no setting', () async {
      final container = _containerWithSetting('theme_mode', null);
      addTearDown(container.dispose);
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('returns light when setting is light', () async {
      final container = _containerWithSetting('theme_mode', 'light');
      addTearDown(container.dispose);
      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    test('returns dark when setting is dark', () async {
      final container = _containerWithSetting('theme_mode', 'dark');
      addTearDown(container.dispose);
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('returns dark for unknown values', () async {
      final container = _containerWithSetting('theme_mode', 'garbage');
      addTearDown(container.dispose);
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });
  });

  group('terminalThemeIdProvider', () {
    test('defaults to cloudshell_default when null', () async {
      final container =
          _containerWithSetting('terminal_theme', null);
      addTearDown(container.dispose);
      expect(container.read(terminalThemeIdProvider), 'cloudshell_default');
    });

    test('returns stored theme ID', () async {
      final container =
          _containerWithSetting('terminal_theme', 'dracula');
      addTearDown(container.dispose);
      expect(container.read(terminalThemeIdProvider), 'dracula');
    });
  });

  group('terminalCursorStyleProvider', () {
    test('defaults to block when null', () async {
      final container =
          _containerWithSetting('terminal_cursor_style', null);
      addTearDown(container.dispose);
      expect(container.read(terminalCursorStyleProvider), 'block');
    });

    test('returns stored cursor style', () async {
      final container =
          _containerWithSetting('terminal_cursor_style', 'underline');
      addTearDown(container.dispose);
      expect(container.read(terminalCursorStyleProvider), 'underline');
    });

    test('returns bar style', () async {
      final container =
          _containerWithSetting('terminal_cursor_style', 'bar');
      addTearDown(container.dispose);
      expect(container.read(terminalCursorStyleProvider), 'bar');
    });
  });

  group('onboardingCompleteProvider', () {
    test('returns false when setting is false', () async {
      final container =
          _containerWithSetting('onboarding_complete', 'false');
      addTearDown(container.dispose);
      expect(container.read(onboardingCompleteProvider), isFalse);
    });

    test('returns true when setting is true', () async {
      final container =
          _containerWithSetting('onboarding_complete', 'true');
      addTearDown(container.dispose);
      expect(container.read(onboardingCompleteProvider), isTrue);
    });

    test('returns false when setting is null', () async {
      final container =
          _containerWithSetting('onboarding_complete', null);
      addTearDown(container.dispose);
      expect(container.read(onboardingCompleteProvider), isFalse);
    });
  });

  group('localeProvider', () {
    test('returns null for system', () async {
      final container = _containerWithSetting('language', 'system');
      addTearDown(container.dispose);
      expect(container.read(localeProvider), isNull);
    });

    test('returns null for empty string', () async {
      final container = _containerWithSetting('language', '');
      addTearDown(container.dispose);
      expect(container.read(localeProvider), isNull);
    });

    test('returns null for null', () async {
      final container = _containerWithSetting('language', null);
      addTearDown(container.dispose);
      expect(container.read(localeProvider), isNull);
    });

    test('returns Locale for valid language code', () async {
      final container = _containerWithSetting('language', 'ja');
      addTearDown(container.dispose);
      expect(container.read(localeProvider), const Locale('ja'));
    });

    test('returns Locale for Spanish', () async {
      final container = _containerWithSetting('language', 'es');
      addTearDown(container.dispose);
      expect(container.read(localeProvider), const Locale('es'));
    });
  });

  group('terminalLigaturesProvider', () {
    test('returns false when null (only true for explicit "true")', () async {
      final container =
          _containerWithSetting('terminal_ligatures', null);
      addTearDown(container.dispose);
      // value == 'true' is false when value is null
      expect(container.read(terminalLigaturesProvider), isFalse);
    });

    test('returns false when setting is false', () async {
      final container =
          _containerWithSetting('terminal_ligatures', 'false');
      addTearDown(container.dispose);
      expect(container.read(terminalLigaturesProvider), isFalse);
    });

    test('returns true when setting is true', () async {
      final container =
          _containerWithSetting('terminal_ligatures', 'true');
      addTearDown(container.dispose);
      expect(container.read(terminalLigaturesProvider), isTrue);
    });
  });

  group('terminalZoomOffsetProvider', () {
    test('defaults to 0.0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(terminalZoomOffsetProvider), 0.0);
    });

    test('can be updated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(terminalZoomOffsetProvider.notifier).state = 2.5;
      expect(container.read(terminalZoomOffsetProvider), 2.5);
    });

    test('can be set to negative value', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(terminalZoomOffsetProvider.notifier).state = -3.0;
      expect(container.read(terminalZoomOffsetProvider), -3.0);
    });
  });

  group('commandNotifyEnabledProvider', () {
    test('defaults to true when null', () async {
      final container =
          _containerWithSetting('command_notify_enabled', null);
      addTearDown(container.dispose);
      expect(container.read(commandNotifyEnabledProvider), isTrue);
    });

    test('returns false when setting is false', () async {
      final container =
          _containerWithSetting('command_notify_enabled', 'false');
      addTearDown(container.dispose);
      expect(container.read(commandNotifyEnabledProvider), isFalse);
    });

    test('returns true when setting is true', () async {
      final container =
          _containerWithSetting('command_notify_enabled', 'true');
      addTearDown(container.dispose);
      expect(container.read(commandNotifyEnabledProvider), isTrue);
    });
  });

  group('SettingsKeys', () {
    test('contains expected keys', () {
      expect(SettingsKeys.themeMode, 'theme_mode');
      expect(SettingsKeys.terminalTheme, 'terminal_theme');
      expect(SettingsKeys.terminalFontSize, 'terminal_font_size');
      expect(SettingsKeys.terminalFontFamily, 'terminal_font_family');
      expect(SettingsKeys.terminalCursorStyle, 'terminal_cursor_style');
      expect(SettingsKeys.terminalLigatures, 'terminal_ligatures');
      expect(SettingsKeys.language, 'language');
      expect(SettingsKeys.onboardingComplete, 'onboarding_complete');
      expect(SettingsKeys.defaultSshPort, 'default_ssh_port');
      expect(SettingsKeys.defaultTimeout, 'default_timeout');
      expect(SettingsKeys.defaultKeepAlive, 'default_keep_alive');
      expect(SettingsKeys.appLockGracePeriod, 'app_lock_grace_period');
    });
  });
}
