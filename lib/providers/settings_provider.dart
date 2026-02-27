/// Riverpod providers for application settings state management.
///
/// Provides reactive access to user preferences stored in
/// the settings key-value table.
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/terminal_themes.dart';
import '../core/utils/platform_utils.dart';
import '../data/database/app_database.dart';

/// Provides a reactive stream of a single setting value by key.
///
/// Usage:
/// ```dart
/// final theme = ref.watch(settingProvider('terminal_theme'));
/// ```
final settingProvider = StreamProvider.family<String?, String>((ref, key) {
  final db = ref.watch(databaseProvider);
  return db.settingsDao.watchValue(key);
});

/// Provides all settings as a map for batch reads.
final allSettingsProvider = FutureProvider<Map<String, String>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.settingsDao.getAllSettings();
});

/// Notifier for updating settings values.
///
/// Usage:
/// ```dart
/// ref.read(settingsNotifierProvider.notifier).set('terminal_theme', 'dracula');
/// ```
final settingsNotifierProvider = AsyncNotifierProvider<SettingsNotifier, void>(
  SettingsNotifier.new,
);

/// Async notifier that provides methods for modifying settings.
class SettingsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Sets a setting value by key.
  Future<void> set(String key, String value) async {
    final db = ref.read(databaseProvider);
    await db.settingsDao.setValue(key, value);
  }

  /// Deletes a setting by key.
  Future<void> delete(String key) async {
    final db = ref.read(databaseProvider);
    await db.settingsDao.deleteValue(key);
  }
}

/// Settings key constants.
abstract final class SettingsKeys {
  static const String themeMode = 'theme_mode';
  static const String onboardingComplete = 'onboarding_complete';
  static const String terminalTheme = 'terminal_theme';
  static const String terminalFontSize = 'terminal_font_size';
  static const String terminalFontFamily = 'terminal_font_family';
  static const String terminalCursorStyle = 'terminal_cursor_style';
  static const String terminalLigatures = 'terminal_ligatures';
  static const String defaultSshPort = 'default_ssh_port';
  static const String defaultTimeout = 'default_timeout';
  static const String defaultKeepAlive = 'default_keep_alive';
  static const String commandNotifyEnabled = 'command_notify_enabled';
  static const String commandNotifyThreshold = 'command_notify_threshold';

  // Auth & Sync
  static const String authMode = 'auth_mode';
  static const String userEmail = 'user_email';
  static const String syncServerUrl = 'sync_server_url';
  static const String syncEnabled = 'sync_enabled';

  // Localization
  static const String language = 'language';

  // Security
  static const String appLockGracePeriod = 'app_lock_grace_period';
}

/// Provides the current theme mode, persisted via the settings table.
final themeModeProvider = Provider<ThemeMode>((ref) {
  final setting = ref.watch(settingProvider(SettingsKeys.themeMode));
  return setting.when(
    data: (value) => switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.dark, // default to dark
    },
    loading: () => ThemeMode.dark,
    error: (_, _) => ThemeMode.dark,
  );
});

/// Provides whether onboarding has been completed.
final onboardingCompleteProvider = Provider<bool>((ref) {
  final setting = ref.watch(settingProvider(SettingsKeys.onboardingComplete));
  return setting.when(
    data: (value) => value == 'true',
    loading: () => true, // assume complete while loading to avoid flash
    error: (_, _) => true,
  );
});

/// Provides the current terminal theme ID.
final terminalThemeIdProvider = Provider<String>((ref) {
  final setting = ref.watch(settingProvider(SettingsKeys.terminalTheme));
  return setting.when(
    data: (value) => value ?? 'cloudshell_default',
    loading: () => 'cloudshell_default',
    error: (_, _) => 'cloudshell_default',
  );
});

/// Provides the current terminal font size.
final terminalFontSizeProvider = Provider<double>((ref) {
  final setting = ref.watch(settingProvider(SettingsKeys.terminalFontSize));
  final defaultSize = PlatformUtils.isDesktop
      ? AppConstants.defaultTerminalFontSizeDesktop
      : AppConstants.defaultTerminalFontSizeMobile;
  return setting.when(
    data: (value) => double.tryParse(value ?? '') ?? defaultSize,
    loading: () => defaultSize,
    error: (_, _) => defaultSize,
  );
});

/// Provides the current terminal font family.
final terminalFontFamilyProvider = Provider<String>((ref) {
  final setting =
      ref.watch(settingProvider(SettingsKeys.terminalFontFamily));
  return setting.when(
    data: (value) => value ?? AppConstants.defaultTerminalFontFamily,
    loading: () => AppConstants.defaultTerminalFontFamily,
    error: (_, _) => AppConstants.defaultTerminalFontFamily,
  );
});

/// Provides the current terminal cursor style.
final terminalCursorStyleProvider = Provider<String>((ref) {
  final setting =
      ref.watch(settingProvider(SettingsKeys.terminalCursorStyle));
  return setting.when(
    data: (value) => value ?? 'block',
    loading: () => 'block',
    error: (_, _) => 'block',
  );
});

/// Provides the default SSH port from settings.
final defaultSshPortProvider = Provider<int>((ref) {
  final setting = ref.watch(settingProvider(SettingsKeys.defaultSshPort));
  return setting.when(
    data: (value) =>
        int.tryParse(value ?? '') ?? AppConstants.defaultSshPort,
    loading: () => AppConstants.defaultSshPort,
    error: (_, _) => AppConstants.defaultSshPort,
  );
});

/// Provides the default connection timeout from settings.
final defaultTimeoutProvider = Provider<int>((ref) {
  final setting = ref.watch(settingProvider(SettingsKeys.defaultTimeout));
  return setting.when(
    data: (value) =>
        int.tryParse(value ?? '') ?? AppConstants.defaultConnectionTimeout,
    loading: () => AppConstants.defaultConnectionTimeout,
    error: (_, _) => AppConstants.defaultConnectionTimeout,
  );
});

/// Provides the default keep-alive interval from settings.
final defaultKeepAliveProvider = Provider<int>((ref) {
  final setting = ref.watch(settingProvider(SettingsKeys.defaultKeepAlive));
  return setting.when(
    data: (value) =>
        int.tryParse(value ?? '') ?? AppConstants.defaultKeepAliveInterval,
    loading: () => AppConstants.defaultKeepAliveInterval,
    error: (_, _) => AppConstants.defaultKeepAliveInterval,
  );
});

/// Provides whether terminal font ligatures are enabled.
final terminalLigaturesProvider = Provider<bool>((ref) {
  final setting =
      ref.watch(settingProvider(SettingsKeys.terminalLigatures));
  return setting.when(
    data: (value) => value == 'true',
    loading: () => true, // ligatures on by default
    error: (_, _) => true,
  );
});

/// Provides whether command completion notification sounds are enabled.
final commandNotifyEnabledProvider = Provider<bool>((ref) {
  final setting =
      ref.watch(settingProvider(SettingsKeys.commandNotifyEnabled));
  return setting.when(
    data: (value) => value != 'false', // enabled by default
    loading: () => true,
    error: (_, _) => true,
  );
});

/// Provides the threshold in seconds for command notification sounds.
final commandNotifyThresholdProvider = Provider<int>((ref) {
  final setting =
      ref.watch(settingProvider(SettingsKeys.commandNotifyThreshold));
  return setting.when(
    data: (value) =>
        int.tryParse(value ?? '') ??
        AppConstants.defaultCommandNotifyThreshold,
    loading: () => AppConstants.defaultCommandNotifyThreshold,
    error: (_, _) => AppConstants.defaultCommandNotifyThreshold,
  );
});

/// Session-scoped zoom offset for terminal Cmd+=/- zoom.
final terminalZoomOffsetProvider = StateProvider<double>((ref) => 0.0);

/// Provides the current locale based on user language setting.
///
/// Returns null for 'system' (use platform default), or the
/// selected locale code.
final localeProvider = Provider<Locale?>((ref) {
  final setting = ref.watch(settingProvider(SettingsKeys.language));
  return setting.when(
    data: (value) {
      if (value == null || value.isEmpty || value == 'system') return null;
      return Locale(value);
    },
    loading: () => null,
    error: (_, _) => null,
  );
});

/// Provides all custom terminal themes as a map of ID → TerminalTheme.
///
/// Custom themes are stored as JSON in settings with keys like
/// `custom_theme_custom_<name>`. This provider loads and deserializes them.
final customTerminalThemesProvider =
    Provider<Map<String, TerminalTheme>>((ref) {
  final allSettings = ref.watch(allSettingsProvider);
  return allSettings.when(
    data: (settings) {
      final themes = <String, TerminalTheme>{};
      for (final entry in settings.entries) {
        if (entry.key.startsWith('custom_theme_custom_')) {
          try {
            final themeId = entry.key.replaceFirst('custom_theme_', '');
            final theme = _deserializeTheme(entry.value);
            if (theme != null) {
              themes[themeId] = theme;
            }
          } catch (e) {
            debugPrint('Theme deserialization failed for ${entry.key}: $e');
          }
        }
      }
      return themes;
    },
    loading: () => {},
    error: (_, _) => {},
  );
});

TerminalTheme? _deserializeTheme(String jsonStr) {
  try {
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final name = data['name'] as String? ?? 'Custom';
    final colors = data['colors'] as Map<String, dynamic>? ?? {};

    Color parseColor(String key, Color fallback) {
      final hex = colors[key] as String?;
      if (hex == null) return fallback;
      final cleaned = hex.replaceAll('#', '');
      final value = int.tryParse(cleaned, radix: 16);
      if (value == null) return fallback;
      return Color(0xFF000000 | value);
    }

    return TerminalTheme(
      name: name,
      background: parseColor('background', const Color(0xFF1A1B26)),
      foreground: parseColor('foreground', const Color(0xFFC0CAF5)),
      cursor: parseColor('cursor', const Color(0xFFC0CAF5)),
      selection: parseColor('selection', const Color(0xFF33467C)),
      black: parseColor('black', const Color(0xFF15161E)),
      red: parseColor('red', const Color(0xFFF7768E)),
      green: parseColor('green', const Color(0xFF9ECE6A)),
      yellow: parseColor('yellow', const Color(0xFFE0AF68)),
      blue: parseColor('blue', const Color(0xFF7AA2F7)),
      magenta: parseColor('magenta', const Color(0xFFBB9AF7)),
      cyan: parseColor('cyan', const Color(0xFF7DCFFF)),
      white: parseColor('white', const Color(0xFFA9B1D6)),
      brightBlack: parseColor('brightBlack', const Color(0xFF414868)),
      brightRed: parseColor('brightRed', const Color(0xFFF7768E)),
      brightGreen: parseColor('brightGreen', const Color(0xFF9ECE6A)),
      brightYellow: parseColor('brightYellow', const Color(0xFFE0AF68)),
      brightBlue: parseColor('brightBlue', const Color(0xFF7AA2F7)),
      brightMagenta: parseColor('brightMagenta', const Color(0xFFBB9AF7)),
      brightCyan: parseColor('brightCyan', const Color(0xFF7DCFFF)),
      brightWhite: parseColor('brightWhite', const Color(0xFFC0CAF5)),
    );
  } catch (e) {
    debugPrint('Theme JSON deserialization failed: $e');
    return null;
  }
}

/// Provides all terminal themes (built-in + custom) merged.
final allTerminalThemesProvider =
    Provider<Map<String, TerminalTheme>>((ref) {
  final custom = ref.watch(customTerminalThemesProvider);
  return {...TerminalThemes.all, ...custom};
});
