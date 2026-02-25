/// Application settings screen.
///
/// Provides access to appearance, terminal, connection, security,
/// sync, and about sub-sections.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/terminal_themes.dart';
import '../../core/utils/platform_utils.dart';
import '../../data/database/app_database.dart';
import '../../core/constants/route_names.dart';
import '../../providers/app_lock_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth/auth_service.dart';
import '../../providers/settings_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/vault_provider.dart';
import '../../services/crypto/secure_storage.dart';
import '../../services/crypto/vault_crypto_service.dart';
import '../../services/sync/sync_service.dart';
import '../../services/data/data_export_service.dart';
import 'package:file_picker/file_picker.dart';
import '../auth/totp_setup_screen.dart';
import '../tools/password_generator_screen.dart';
import '../vault/master_password_setup_screen.dart';
import '../../services/auth/totp_service.dart';
import 'custom_theme_editor_screen.dart';
import 'known_hosts_screen.dart';
import 'legal_screen.dart';
import 'session_logs_screen.dart';
import 'workspace_manager_screen.dart';
import 'cloud_import/aws_import_screen.dart';
import 'cloud_import/do_import_screen.dart';
import 'ssh_config_import_screen.dart';

/// Settings screen with categorized setting groups.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _themeModeLabel(ThemeMode mode, AppLocalizations l10n) => switch (mode) {
        ThemeMode.dark => l10n.themeModeDark,
        ThemeMode.light => l10n.themeModeLight,
        ThemeMode.system => l10n.themeModeSystem,
      };

  String _fontDisplayName(String family) => switch (family) {
        'JetBrainsMono' => 'JetBrains Mono',
        'FiraCode' || 'Fira Code' => 'Fira Code',
        'SourceCodePro' || 'Source Code Pro' => 'Source Code Pro',
        'RobotoMono' || 'Roboto Mono' => 'Roboto Mono',
        'IBMPlexMono' || 'IBM Plex Mono' => 'IBM Plex Mono',
        'UbuntuMono' || 'Ubuntu Mono' => 'Ubuntu Mono',
        'AnonymousPro' || 'Anonymous Pro' => 'Anonymous Pro',
        'PTMono' || 'PT Mono' => 'PT Mono',
        _ => family,
      };

  String _cursorStyleLabel(String style, AppLocalizations l10n) => switch (style) {
        'underline' => l10n.cursorStyleUnderline,
        'bar' => l10n.cursorStyleVerticalBar,
        _ => l10n.cursorStyleBlock,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final terminalThemeId = ref.watch(terminalThemeIdProvider);
    final terminalFontSize = ref.watch(terminalFontSizeProvider);
    final terminalFontFamily = ref.watch(terminalFontFamilyProvider);
    final terminalCursorStyle = ref.watch(terminalCursorStyleProvider);
    final terminalLigatures = ref.watch(terminalLigaturesProvider);
    final defaultPort = ref.watch(defaultSshPortProvider);
    final defaultTimeout = ref.watch(defaultTimeoutProvider);
    final defaultKeepAlive = ref.watch(defaultKeepAliveProvider);
    final commandNotifyEnabled = ref.watch(commandNotifyEnabledProvider);
    final commandNotifyThreshold = ref.watch(commandNotifyThresholdProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle, style: AppTypography.h1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSection(
            title: l10n.sectionAppearance,
            children: [
              _SettingsTile(
                icon: LucideIcons.palette,
                title: l10n.settingThemeTitle,
                subtitle: _themeModeLabel(themeMode, l10n),
                onTap: () => _showThemePicker(context, ref, themeMode),
              ),
              _SettingsTile(
                icon: LucideIcons.monitor,
                title: l10n.settingTerminalThemeTitle,
                subtitle: ref.watch(allTerminalThemesProvider)[terminalThemeId]?.name ??
                    TerminalThemes.byId(terminalThemeId).name,
                onTap: () =>
                    _showTerminalThemePicker(context, ref, terminalThemeId),
              ),
              _SettingsTile(
                icon: LucideIcons.type,
                title: l10n.settingFontFamilyTitle,
                subtitle: _fontDisplayName(terminalFontFamily),
                onTap: () => _showFontFamilyPicker(
                    context, ref, terminalFontFamily),
              ),
              _SettingsTile(
                icon: LucideIcons.caseSensitive,
                title: l10n.settingFontSizeTitle,
                subtitle: l10n.settingFontSizeSuffix(terminalFontSize.toInt().toString()),
                onTap: () =>
                    _showFontSizePicker(context, ref, terminalFontSize),
              ),
              _SettingsTile(
                icon: LucideIcons.textCursorInput,
                title: l10n.settingCursorStyleTitle,
                subtitle: _cursorStyleLabel(terminalCursorStyle, l10n),
                onTap: () => _showCursorStylePicker(
                    context, ref, terminalCursorStyle),
              ),
              _SettingsTile(
                icon: LucideIcons.link,
                title: l10n.settingFontLigaturesTitle,
                subtitle: terminalLigatures
                    ? l10n.settingFontLigaturesEnabled
                    : l10n.settingFontLigaturesDisabled,
                trailing: Switch(
                  value: terminalLigatures,
                  onChanged: (value) {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .set(SettingsKeys.terminalLigatures,
                            value.toString());
                  },
                ),
              ),
              _SettingsTile(
                icon: LucideIcons.languages,
                title: l10n.settingLanguageTitle,
                subtitle: _languageDisplayName(
                  ref.watch(settingProvider(SettingsKeys.language)).valueOrNull ?? 'system',
                  l10n,
                ),
                onTap: () => _showLanguagePicker(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: l10n.sectionConnection,
            children: [
              _SettingsTile(
                icon: LucideIcons.hash,
                title: l10n.settingDefaultSshPortTitle,
                subtitle: '$defaultPort',
                onTap: () => _showNumberInput(
                  context,
                  ref,
                  title: l10n.dialogDefaultSshPort,
                  key: SettingsKeys.defaultSshPort,
                  current: defaultPort,
                  min: 1,
                  max: 65535,
                ),
              ),
              _SettingsTile(
                icon: LucideIcons.clock,
                title: l10n.settingConnectionTimeoutTitle,
                subtitle: l10n.settingTimeoutSuffix(defaultTimeout.toString()),
                onTap: () => _showNumberInput(
                  context,
                  ref,
                  title: l10n.dialogConnectionTimeout,
                  key: SettingsKeys.defaultTimeout,
                  current: defaultTimeout,
                  min: 5,
                  max: 120,
                ),
              ),
              _SettingsTile(
                icon: LucideIcons.heartPulse,
                title: l10n.settingKeepAliveTitle,
                subtitle: l10n.settingTimeoutSuffix(defaultKeepAlive.toString()),
                onTap: () => _showNumberInput(
                  context,
                  ref,
                  title: l10n.dialogKeepAliveInterval,
                  key: SettingsKeys.defaultKeepAlive,
                  current: defaultKeepAlive,
                  min: 0,
                  max: 300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: l10n.sectionNotifications,
            children: [
              _SettingsTile(
                icon: LucideIcons.bell,
                title: l10n.settingCommandCompletionSoundTitle,
                subtitle: commandNotifyEnabled
                    ? l10n.settingCommandNotifyEnabled(commandNotifyThreshold.toString())
                    : l10n.disabled,
                trailing: Switch(
                  value: commandNotifyEnabled,
                  onChanged: (value) {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .set(SettingsKeys.commandNotifyEnabled,
                            value.toString());
                  },
                ),
              ),
              if (commandNotifyEnabled)
                _SettingsTile(
                  icon: LucideIcons.timer,
                  title: l10n.settingNotificationThresholdTitle,
                  subtitle: l10n.settingTimeoutSuffix(commandNotifyThreshold.toString()),
                  onTap: () => _showNumberInput(
                    context,
                    ref,
                    title: l10n.dialogNotificationThreshold,
                    key: SettingsKeys.commandNotifyThreshold,
                    current: commandNotifyThreshold,
                    min: 5,
                    max: 300,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: l10n.sectionSecurity,
            children: [
              _VaultTile(),
              if (PlatformUtils.supportsBiometrics)
                _BiometricLockTile(),
              if (PlatformUtils.supportsBiometrics)
                _AppLockGracePeriodTile(),
              _AutoLockTile(),
              _TotpTile(),
              _SettingsTile(
                icon: LucideIcons.shieldCheck,
                title: l10n.settingKnownHostsTitle,
                subtitle: l10n.settingKnownHostsSubtitle,
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                      builder: (_) => const KnownHostsScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: l10n.sectionTools,
            children: [
              _SettingsTile(
                icon: LucideIcons.layout,
                title: l10n.settingWorkspacesTitle,
                subtitle: l10n.settingWorkspacesSubtitle,
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                      builder: (_) => const WorkspaceManagerScreen()),
                ),
              ),
              _SettingsTile(
                icon: LucideIcons.keyRound,
                title: l10n.settingPasswordGeneratorTitle,
                subtitle: l10n.settingPasswordGeneratorSubtitle,
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                      builder: (_) => const PasswordGeneratorScreen()),
                ),
              ),
              _SettingsTile(
                icon: LucideIcons.fileText,
                title: l10n.settingSessionLogsTitle,
                subtitle: l10n.settingSessionLogsSubtitle,
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                      builder: (_) => const SessionLogsScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: l10n.sectionData,
            children: [
              _SettingsTile(
                icon: LucideIcons.fileCode,
                title: l10n.settingImportSshConfigTitle,
                subtitle: l10n.settingImportSshConfigSubtitle,
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                      builder: (_) => const SshConfigImportScreen()),
                ),
              ),
              _SettingsTile(
                icon: LucideIcons.download,
                title: l10n.settingExportDataTitle,
                subtitle: l10n.settingExportDataSubtitle,
                onTap: () => _exportData(context, ref),
              ),
              _SettingsTile(
                icon: LucideIcons.upload,
                title: l10n.settingImportDataTitle,
                subtitle: l10n.settingImportDataSubtitle,
                onTap: () => _importData(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: l10n.sectionCloudImport,
            children: [
              _SettingsTile(
                icon: LucideIcons.cloud,
                title: l10n.settingAwsEc2Title,
                subtitle: l10n.settingAwsEc2Subtitle,
                onTap: () =>
                    Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                      builder: (_) => const AwsImportScreen()),
                ),
              ),
              _SettingsTile(
                icon: LucideIcons.cloud,
                title: l10n.settingDigitalOceanTitle,
                subtitle: l10n.settingDigitalOceanSubtitle,
                onTap: () =>
                    Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                      builder: (_) => const DoImportScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: l10n.sectionSync,
            children: [
              _SyncAccountTile(),
              _SyncToggleTile(),
              _SyncNowTile(),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: l10n.sectionAbout,
            children: [
              _SettingsTile(
                icon: LucideIcons.info,
                title: l10n.settingVersionTitle,
                subtitle: l10n.settingVersionSubtitle('1.1.0'),
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: AppConstants.appName,
                  applicationVersion: '1.1.0',
                  applicationIcon: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.terminal,
                      color: colors.onPrimary,
                      size: 28,
                    ),
                  ),
                ),
              ),
              _SettingsTile(
                icon: LucideIcons.shieldCheck,
                title: l10n.settingPrivacyPolicyTitle,
                subtitle: l10n.settingPrivacyPolicySubtitle,
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => LegalScreen(
                      title: l10n.settingPrivacyPolicyTitle,
                      assetPath: 'assets/legal/privacy_policy.md',
                    ),
                  ),
                ),
              ),
              _SettingsTile(
                icon: LucideIcons.fileText,
                title: l10n.settingTermsOfServiceTitle,
                subtitle: l10n.settingTermsOfServiceSubtitle,
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => LegalScreen(
                      title: l10n.settingTermsOfServiceTitle,
                      assetPath: 'assets/legal/terms_of_service.md',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, String> _supportedLanguages(AppLocalizations l10n) => {
    'system': l10n.languageSystem,
    'en': l10n.languageEnglish,
    'es': l10n.languageSpanish,
    'de': l10n.languageGerman,
    'fr': l10n.languageFrench,
    'ja': l10n.languageJapanese,
    'zh': l10n.languageChinese,
    'ko': l10n.languageKorean,
  };

  String _languageDisplayName(String code, AppLocalizations l10n) =>
      _supportedLanguages(l10n)[code] ?? code;

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current =
        ref.read(settingProvider(SettingsKeys.language)).valueOrNull ?? 'system';
    final languages = _supportedLanguages(l10n);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingLanguageTitle, style: AppTypography.h2),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        content: RadioGroup<String>(
          groupValue: current,
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .set(SettingsKeys.language, value);
              Navigator.of(dialogContext).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in languages.entries)
                RadioListTile<String>(
                  title: Text(entry.value),
                  value: entry.key,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showThemePicker(
      BuildContext context, WidgetRef ref, ThemeMode current) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.themePickerTitle, style: AppTypography.h2),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        content: RadioGroup<ThemeMode>(
          groupValue: current,
          onChanged: (value) {
            if (value != null) {
              final modeStr = switch (value) {
                ThemeMode.dark => 'dark',
                ThemeMode.light => 'light',
                ThemeMode.system => 'system',
              };
              ref
                  .read(settingsNotifierProvider.notifier)
                  .set(SettingsKeys.themeMode, modeStr);
              Navigator.of(dialogContext).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final mode
                  in [ThemeMode.dark, ThemeMode.light, ThemeMode.system])
                RadioListTile<ThemeMode>(
                  title: Text(_themeModeLabel(mode, l10n)),
                  value: mode,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showTerminalThemePicker(
      BuildContext context, WidgetRef ref, String currentId) {
    showDialog(
      context: context,
      builder: (_) => _TerminalThemePickerDialog(
        currentId: currentId,
        onSelect: (id) {
          ref
              .read(settingsNotifierProvider.notifier)
              .set(SettingsKeys.terminalTheme, id);
        },
        onCreateCustom: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => const CustomThemeEditorScreen(),
            ),
          );
        },
        onEditCustom: (id) {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => CustomThemeEditorScreen(existingThemeId: id),
            ),
          );
        },
        onDeleteCustom: (id) async {
          await ref
              .read(settingsNotifierProvider.notifier)
              .delete('custom_theme_$id');
          // If this was the active theme, reset to default
          if (currentId == id) {
            await ref
                .read(settingsNotifierProvider.notifier)
                .set(SettingsKeys.terminalTheme, 'cloudshell_default');
          }
        },
      ),
    );
  }

  void _showFontSizePicker(
      BuildContext context, WidgetRef ref, double currentSize) {
    showDialog(
      context: context,
      builder: (_) => _FontSizePickerDialog(
        currentSize: currentSize,
        onSave: (size) {
          ref
              .read(settingsNotifierProvider.notifier)
              .set(SettingsKeys.terminalFontSize, size.toString());
        },
      ),
    );
  }

  void _showFontFamilyPicker(
      BuildContext context, WidgetRef ref, String currentFamily) {
    showDialog(
      context: context,
      builder: (_) => _FontFamilyPickerDialog(
        currentFamily: currentFamily,
        onSelect: (family) {
          ref
              .read(settingsNotifierProvider.notifier)
              .set(SettingsKeys.terminalFontFamily, family);
        },
      ),
    );
  }

  void _showCursorStylePicker(
      BuildContext context, WidgetRef ref, String currentStyle) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.cursorStylePickerTitle, style: AppTypography.h2),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        content: RadioGroup<String>(
          groupValue: currentStyle,
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .set(SettingsKeys.terminalCursorStyle, value);
              Navigator.of(dialogContext).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in [
                ('block', l10n.cursorStyleBlock, '\u2588'),
                ('underline', l10n.cursorStyleUnderline, '_'),
                ('bar', l10n.cursorStyleVerticalBar, '\u2502'),
              ])
                RadioListTile<String>(
                  title: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text(
                          entry.$3,
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(entry.$2),
                    ],
                  ),
                  value: entry.$1,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showNumberInput(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String key,
    required int current,
    required int min,
    required int max,
  }) {
    showDialog(
      context: context,
      builder: (_) => _NumberInputDialog(
        title: title,
        current: current,
        min: min,
        max: max,
        onSave: (value) {
          ref
              .read(settingsNotifierProvider.notifier)
              .set(key, value.toString());
        },
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    // Ask user which export type
    final choice = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.exportDataTitle, style: AppTypography.h2),
        content: Text(l10n.exportDataMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(null),
            child: Text(l10n.cancel),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(dialogContext).pop('plaintext'),
            child: Text(l10n.exportDataPlaintext),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop('encrypted'),
            child: Text(l10n.exportDataEncryptedVault),
          ),
        ],
      ),
    );

    if (choice == null || !context.mounted) return;

    if (choice == 'plaintext') {
      await _doPlaintextExport(context, ref);
    } else {
      await _doEncryptedExport(context, ref);
    }
  }

  Future<void> _doPlaintextExport(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      final db = ref.read(databaseProvider);
      final service = DataExportService(db);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportDataExporting)),
      );

      final path = await service.exportData();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportedToFile(path.split('/').last)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportFailed(e.toString())),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Future<void> _doEncryptedExport(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final password = await _showPasswordDialog(
      context,
      title: l10n.encryptedExportTitle,
      message: l10n.encryptedExportMessage,
      confirmLabel: l10n.encryptedExportConfirmLabel,
      requireConfirmation: true,
      minLength: 10,
    );

    if (password == null || !context.mounted) return;

    try {
      final db = ref.read(databaseProvider);
      final storage = ref.read(secureStorageProvider);
      final crypto = ref.read(vaultCryptoServiceProvider);
      final service = DataExportService(
        db,
        secureStorage: storage,
        vaultCrypto: crypto,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportDataEncrypting)),
      );

      final path = await service.exportEncryptedVault(password);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.vaultExportedToFile(path.split('/').last)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportFailed(e.toString())),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: l10n.importDataFileDialogTitle,
    );

    if (result == null || result.files.isEmpty || !context.mounted) return;

    final filePath = result.files.single.path;
    if (filePath == null || !context.mounted) return;

    // Detect if encrypted
    final content = await File(filePath).readAsString();
    final isEncrypted = DataExportService.isEncryptedExport(content);

    if (!context.mounted) return;

    if (isEncrypted) {
      await _doEncryptedImport(context, ref, filePath);
    } else {
      await _doPlaintextImport(context, ref, filePath);
    }
  }

  Future<void> _doPlaintextImport(
      BuildContext context, WidgetRef ref, String filePath) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.importDataPlaintextTitle, style: AppTypography.h2),
        content: Text(l10n.importDataPlaintextMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.importDataPlaintextImport),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final db = ref.read(databaseProvider);
      final service = DataExportService(db);
      final importResult = await service.importData(filePath);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(importResult.summary),
            duration: const Duration(seconds: 4),
            backgroundColor:
                importResult.hasError ? AppColors.accentRed : null,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.importFailed(e.toString())),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Future<void> _doEncryptedImport(
      BuildContext context, WidgetRef ref, String filePath) async {
    final l10n = AppLocalizations.of(context);
    final password = await _showPasswordDialog(
      context,
      title: l10n.importDataDecryptTitle,
      message: l10n.importDataDecryptMessage,
      confirmLabel: l10n.importDataDecryptConfirmLabel,
    );

    if (password == null || !context.mounted) return;

    try {
      final db = ref.read(databaseProvider);
      final storage = ref.read(secureStorageProvider);
      final crypto = ref.read(vaultCryptoServiceProvider);
      final service = DataExportService(
        db,
        secureStorage: storage,
        vaultCrypto: crypto,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.importDataDecrypting)),
      );

      final importResult =
          await service.importEncryptedVault(filePath, password);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(importResult.summary),
            duration: const Duration(seconds: 4),
            backgroundColor:
                importResult.hasError ? AppColors.accentRed : null,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.importFailed(e.toString())),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  /// Shows a password input dialog with optional confirmation field.
  Future<String?> _showPasswordDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    bool requireConfirmation = false,
    int minLength = 1,
  }) async {
    final l10n = AppLocalizations.of(context);
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    try {
      return await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (ctx, setState) {
              final pwd = passwordController.text;
              final confirm = confirmController.text;
              final tooShort = pwd.length < minLength;
              final mismatch =
                  requireConfirmation && pwd.isNotEmpty && pwd != confirm;
              final canSubmit = pwd.isNotEmpty &&
                  !tooShort &&
                  (!requireConfirmation || pwd == confirm);

              return AlertDialog(
                title: Text(title, style: AppTypography.h2),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message, style: AppTypography.body),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: l10n.passwordDialogLabelPassword,
                        errorText: tooShort && pwd.isNotEmpty
                            ? l10n.passwordMinLength(minLength.toString())
                            : null,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    if (requireConfirmation) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: confirmController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: l10n.passwordDialogLabelConfirmPassword,
                          errorText:
                              mismatch ? l10n.passwordDialogErrorPasswordsDoNotMatch : null,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(null),
                    child: Text(l10n.cancel),
                  ),
                  FilledButton(
                    onPressed: canSubmit
                        ? () => Navigator.of(dialogContext).pop(pwd)
                        : null,
                    child: Text(confirmLabel ?? l10n.confirm),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      passwordController.dispose();
      confirmController.dispose();
    }
  }

}

// ---------------------------------------------------------------------------
// Biometric Lock Toggle Tile
// ---------------------------------------------------------------------------

class _BiometricLockTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isEnabled = ref.watch(biometricLockEnabledProvider);
    final biometricLabel = PlatformUtils.isMacOS
        ? l10n.biometricLabelTouchId
        : PlatformUtils.isIOS
            ? l10n.biometricLabelFaceId
            : l10n.biometricLabelBiometrics;

    return _SettingsTile(
      icon: LucideIcons.fingerprint,
      title: l10n.biometricUnlockTitle,
      subtitle: biometricLabel,
      trailing: Switch(
        value: isEnabled,
        onChanged: (value) async {
          if (value) {
            // Verify biometrics are available before enabling
            final available =
                await ref.read(appLockProvider.notifier).isBiometricAvailable();
            if (!available) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.biometricNotAvailable),
                  ),
                );
              }
              return;
            }
          }
          await setBiometricLockEnabled(ref, value);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// App Lock Grace Period Tile
// ---------------------------------------------------------------------------

class _AppLockGracePeriodTile extends ConsumerWidget {
  List<(int, String)> _gracePeriods(AppLocalizations l10n) => [
    (0, l10n.appLockGracePeriodImmediate),
    (30, l10n.appLockGracePeriod30Seconds),
    (60, l10n.appLockGracePeriod1Minute),
    (300, l10n.appLockGracePeriod5Minutes),
    (900, l10n.appLockGracePeriod15Minutes),
  ];

  String _gracePeriodLabel(int seconds, AppLocalizations l10n) {
    for (final (value, label) in _gracePeriods(l10n)) {
      if (value == seconds) return label;
    }
    return '$seconds seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isEnabled = ref.watch(biometricLockEnabledProvider);
    final gracePeriod = ref.watch(appLockGracePeriodProvider);

    if (!isEnabled) {
      return _SettingsTile(
        icon: LucideIcons.timer,
        title: l10n.appLockGracePeriodTitle,
        subtitle: l10n.appLockGracePeriodEnableBiometricFirst,
      );
    }

    return _SettingsTile(
      icon: LucideIcons.timer,
      title: l10n.appLockGracePeriodTitle,
      subtitle: _gracePeriodLabel(gracePeriod, l10n),
      onTap: () => _showGracePeriodPicker(context, ref, gracePeriod),
    );
  }

  void _showGracePeriodPicker(
      BuildContext context, WidgetRef ref, int current) {
    final l10n = AppLocalizations.of(context);
    final periods = _gracePeriods(l10n);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title:
            Text(l10n.appLockGracePeriodDialogTitle, style: AppTypography.h2),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        content: RadioGroup<int>(
          groupValue: current,
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .set(SettingsKeys.appLockGracePeriod, value.toString());
              Navigator.of(dialogContext).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (value, label) in periods)
                RadioListTile<int>(
                  title: Text(label),
                  value: value,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vault Encryption Tile
// ---------------------------------------------------------------------------

class _VaultTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final vaultState = ref.watch(vaultProvider);

    return vaultState.when(
      data: (state) {
        switch (state) {
          case VaultState.noVault:
            return _SettingsTile(
              icon: LucideIcons.shield,
              title: l10n.vaultEncryptionTitle,
              subtitle: l10n.vaultNotConfiguredSubtitle,
              onTap: () async {
                final result = await Navigator.of(context, rootNavigator: true)
                    .push<bool>(MaterialPageRoute(
                  builder: (_) => const MasterPasswordSetupScreen(),
                ));
                if (result == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.vaultEncryptionEnabled)),
                  );
                }
              },
            );
          case VaultState.unlocked:
            return _SettingsTile(
              icon: LucideIcons.shieldCheck,
              title: l10n.vaultEncryptionTitle,
              subtitle: l10n.vaultEncryptedUnlockedSubtitle,
              onTap: () => _showVaultOptions(context, ref),
            );
          case VaultState.locked:
          case VaultState.unlocking:
            return _SettingsTile(
              icon: LucideIcons.lock,
              title: l10n.vaultEncryptionTitle,
              subtitle: l10n.vaultLockedSubtitle,
            );
        }
      },
      loading: () => _SettingsTile(
        icon: LucideIcons.shield,
        title: l10n.vaultMasterPasswordTitle,
        subtitle: l10n.vaultLoadingSubtitle,
      ),
      error: (_, _) => _SettingsTile(
        icon: LucideIcons.shield,
        title: l10n.vaultMasterPasswordTitle,
        subtitle: l10n.vaultErrorSubtitle,
      ),
    );
  }

  void _showVaultOptions(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.vaultDialogTitle, style: AppTypography.h2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.lock, size: 20),
              title: Text(l10n.vaultLockNow),
              onTap: () {
                Navigator.of(dialogContext).pop();
                ref.read(vaultProvider.notifier).lock();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.vaultLocked)),
                );
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.keyRound, size: 20),
              title: Text(l10n.vaultChangePassword),
              onTap: () {
                Navigator.of(dialogContext).pop();
                _showChangePasswordDialog(context, ref);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.changePasswordTitle, style: AppTypography.h2),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.changePasswordCurrentLabel,
                  prefixIcon: const Icon(LucideIcons.lock, size: 18),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.changePasswordNewLabel,
                  prefixIcon: const Icon(LucideIcons.keyRound, size: 18),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.changePasswordConfirmLabel,
                  prefixIcon: const Icon(LucideIcons.lock, size: 18),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (newController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.changePasswordMismatch)),
                );
                return;
              }
              if (newController.text.length < 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.changePasswordMinLength)),
                );
                return;
              }
              final error = await ref
                  .read(vaultProvider.notifier)
                  .changePassword(currentController.text, newController.text);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(error ?? l10n.changePasswordSuccess),
                  ),
                );
              }
            },
            child: Text(l10n.changePasswordSubmit),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Auto-Lock Tile
// ---------------------------------------------------------------------------

class _AutoLockTile extends ConsumerWidget {
  List<(int, String)> _timeouts(AppLocalizations l10n) => [
    (0, l10n.autoLockTimeoutNever),
    (60, l10n.autoLockTimeout1Min),
    (300, l10n.autoLockTimeout5Min),
    (900, l10n.autoLockTimeout15Min),
    (1800, l10n.autoLockTimeout30Min),
    (3600, l10n.autoLockTimeout1Hour),
  ];

  String _timeoutLabel(int seconds, AppLocalizations l10n) {
    for (final (value, label) in _timeouts(l10n)) {
      if (value == seconds) return label;
    }
    return '$seconds seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final timeout = ref.watch(vaultAutoLockTimeoutProvider);
    final vaultState = ref.watch(vaultProvider);
    final hasVault = vaultState.valueOrNull != VaultState.noVault;

    if (!hasVault) {
      return _SettingsTile(
        icon: LucideIcons.clock,
        title: l10n.autoLockTitle,
        subtitle: l10n.autoLockSetUpVaultFirst,
      );
    }

    return _SettingsTile(
      icon: LucideIcons.clock,
      title: l10n.autoLockTitle,
      subtitle: _timeoutLabel(timeout, l10n),
      onTap: () => _showAutoLockPicker(context, ref, timeout),
    );
  }

  void _showAutoLockPicker(BuildContext context, WidgetRef ref, int current) {
    final l10n = AppLocalizations.of(context);
    final timeouts = _timeouts(l10n);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.autoLockDialogTitle, style: AppTypography.h2),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        content: RadioGroup<int>(
          groupValue: current,
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .set(VaultSettingsKeys.autoLockTimeout, value.toString());
              Navigator.of(dialogContext).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (value, label) in timeouts)
                RadioListTile<int>(
                  title: Text(label),
                  value: value,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sync Account Tile
// ---------------------------------------------------------------------------

class _SyncAccountTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (state) {
        switch (state) {
          case AuthState.authenticated:
            final emailAsync = ref.watch(currentUserEmailProvider);
            final email = emailAsync.valueOrNull ?? l10n.syncSignedInDefault;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SettingsTile(
                  icon: LucideIcons.cloudCog,
                  title: l10n.syncAccountTitle,
                  subtitle: email,
                  onTap: () => _showAccountOptions(context, ref, email),
                ),
              ],
            );

          case AuthState.localOnly:
            return _SettingsTile(
              icon: LucideIcons.cloudOff,
              title: l10n.syncLocalOnlyTitle,
              subtitle: l10n.syncLocalOnlySubtitle,
              onTap: () async {
                await ref.read(authProvider.notifier).clearLocalOnly();
                if (context.mounted) {
                  GoRouter.of(context).push(RouteNames.login);
                }
              },
            );

          case AuthState.unauthenticated:
          case AuthState.authenticating:
            return _SettingsTile(
              icon: LucideIcons.cloud,
              title: l10n.syncCloudSyncTitle,
              subtitle: l10n.syncCloudSyncSubtitle,
              onTap: () => GoRouter.of(context).push(RouteNames.login),
            );
        }
      },
      loading: () => _SettingsTile(
        icon: LucideIcons.cloud,
        title: l10n.syncCloudSyncTitle,
        subtitle: l10n.loading,
      ),
      error: (_, _) => _SettingsTile(
        icon: LucideIcons.cloud,
        title: l10n.syncCloudSyncTitle,
        subtitle: l10n.syncCloudSyncSubtitle,
        onTap: () => GoRouter.of(context).push(RouteNames.login),
      ),
    );
  }

  void _showAccountOptions(
      BuildContext context, WidgetRef ref, String email) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.accountDialogTitle, style: AppTypography.h2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.user, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    email,
                    style: AppTypography.body,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.logOut, size: 20),
              title: Text(l10n.accountSignOut),
              onTap: () async {
                Navigator.of(dialogContext).pop();
                await ref.read(authProvider.notifier).logOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.accountSignedOut)),
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.trash2,
                  size: 20, color: AppColors.accentRed),
              title: Text(
                l10n.accountDeleteAccount,
                style: const TextStyle(color: AppColors.accentRed),
              ),
              onTap: () {
                Navigator.of(dialogContext).pop();
                _showDeleteAccountDialog(context, ref);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        return StatefulBuilder(
          builder: (ctx, setState) {
            final canDelete = controller.text == 'DELETE';
            return AlertDialog(
              title: Text(l10n.deleteAccountTitle, style: AppTypography.h2),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.accentRed.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.alertTriangle,
                            size: 20, color: AppColors.accentRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.deleteAccountWarning,
                            style: AppTypography.body.copyWith(
                              color: AppColors.accentRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.deleteAccountWillDelete,
                    style: AppTypography.body,
                  ),
                  const SizedBox(height: 8),
                  Text('  \u2022 ${l10n.deleteAccountItemAccount}'),
                  Text('  \u2022 ${l10n.deleteAccountItemSyncedData}'),
                  Text('  \u2022 ${l10n.deleteAccountItemVault}'),
                  const SizedBox(height: 8),
                  Text(
                    l10n.deleteAccountLocalDataNote,
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.deleteAccountConfirmPrompt,
                    style: AppTypography.body
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: l10n.deleteAccountHint,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.dispose();
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentRed,
                  ),
                  onPressed: canDelete
                      ? () async {
                          Navigator.of(dialogContext).pop();
                          controller.dispose();
                          await _performAccountDeletion(context, ref);
                        }
                      : null,
                  child: Text(l10n.deleteAccountSubmit),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _performAccountDeletion(
      BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteAccountDeleting)),
      );

      // Delete account on server
      final authService = ref.read(authServiceProvider);
      final result = await authService.deleteAccount();

      if (!result.success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.error ?? l10n.deleteAccountFailedDefault),
              backgroundColor: AppColors.accentRed,
            ),
          );
        }
        return;
      }

      // Lock vault and clear auth state
      ref.read(vaultProvider.notifier).lock();
      await ref.read(authProvider.notifier).logOut();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deleteAccountSuccess),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.importFailed(e.toString())),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Sync Toggle Tile
// ---------------------------------------------------------------------------

class _SyncToggleTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isAuthenticated =
        authState.valueOrNull == AuthState.authenticated;
    final syncEnabled = ref.watch(syncEnabledProvider);
    final isVaultUnlocked = ref.watch(isVaultUnlockedProvider);

    if (!isAuthenticated) {
      return const SizedBox.shrink();
    }

    final canSync = isAuthenticated && isVaultUnlocked;

    return _SettingsTile(
      icon: LucideIcons.refreshCw,
      title: l10n.syncAutoSyncTitle,
      subtitle: !isVaultUnlocked
          ? l10n.syncUnlockVault
          : syncEnabled
              ? l10n.syncEvery5Minutes
              : l10n.syncDisabled,
      trailing: Switch(
        value: syncEnabled,
        onChanged: canSync
            ? (value) {
                if (value) {
                  ref.read(syncProvider.notifier).enableSync();
                } else {
                  ref.read(syncProvider.notifier).disableSync();
                }
              }
            : null,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sync Now Tile
// ---------------------------------------------------------------------------

class _SyncNowTile extends ConsumerWidget {
  String _formatLastSync(DateTime? time, AppLocalizations l10n) {
    if (time == null) return l10n.syncNeverSynced;
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return l10n.syncJustNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final syncReady = ref.watch(syncReadyProvider);
    if (!syncReady) return const SizedBox.shrink();

    final syncStatus = ref.watch(syncProvider);
    final status = syncStatus.valueOrNull ?? SyncStatus.disabled;
    final lastSync = ref.watch(lastSyncTimeProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider);
    final pending = pendingCount.valueOrNull ?? 0;

    final isSyncing = status == SyncStatus.syncing;

    final lastSyncStr = lastSync.when(
      data: (time) => _formatLastSync(time, l10n),
      loading: () => l10n.loading,
      error: (_, _) => l10n.unknown,
    );

    final subtitle = isSyncing
        ? l10n.syncSyncing
        : pending > 0
            ? '$lastSyncStr \u2022 $pending pending'
            : lastSyncStr;

    return _SettingsTile(
      icon: isSyncing ? LucideIcons.loader : LucideIcons.cloud,
      title: l10n.syncNowTitle,
      subtitle: subtitle,
      onTap: isSyncing
          ? null
          : () async {
              final result = await ref.read(syncProvider.notifier).sync();
              if (result != null && context.mounted) {
                final msg = result.success
                    ? l10n.syncResult(result.pulled, result.pushed)
                    : l10n.syncFailed(result.error ?? l10n.unknown);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg)),
                );
              }
            },
    );
  }
}

// ---------------------------------------------------------------------------
// Terminal Theme Picker Dialog
// ---------------------------------------------------------------------------

class _TerminalThemePickerDialog extends ConsumerWidget {
  const _TerminalThemePickerDialog({
    required this.currentId,
    required this.onSelect,
    this.onCreateCustom,
    this.onEditCustom,
    this.onDeleteCustom,
  });

  final String currentId;
  final ValueChanged<String> onSelect;
  final VoidCallback? onCreateCustom;
  final ValueChanged<String>? onEditCustom;
  final ValueChanged<String>? onDeleteCustom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final customThemes = ref.watch(customTerminalThemesProvider);
    final builtInEntries = TerminalThemes.all.entries.toList();
    final customEntries = customThemes.entries.toList();

    return AlertDialog(
      title: Text(l10n.terminalThemePickerTitle, style: AppTypography.h2),
      contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
      content: SizedBox(
        width: 400,
        child: ListView(
          shrinkWrap: true,
          children: [
            // Custom themes section
            if (customEntries.isNotEmpty) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Text(
                  l10n.terminalThemeCustomThemesHeader,
                  style: AppTypography.overline.copyWith(
                    color: AppColors.accentPrimary,
                    fontSize: 10,
                  ),
                ),
              ),
              for (final entry in customEntries)
                _buildThemeRow(
                  context,
                  id: entry.key,
                  theme: entry.value,
                  isCustom: true,
                ),
              const Divider(height: 16, indent: 16, endIndent: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Text(
                  l10n.terminalThemeBuiltInThemesHeader,
                  style: AppTypography.overline.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
            // Built-in themes
            for (final entry in builtInEntries)
              _buildThemeRow(
                context,
                id: entry.key,
                theme: entry.value,
                isCustom: false,
              ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onCreateCustom?.call();
          },
          icon: const Icon(LucideIcons.plus, size: 16),
          label: Text(l10n.terminalThemeNewTheme),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  Widget _buildThemeRow(
    BuildContext context, {
    required String id,
    required TerminalTheme theme,
    required bool isCustom,
  }) {
    final l10n = AppLocalizations.of(context);
    final isSelected = id == currentId;

    return InkWell(
      onTap: () {
        onSelect(id);
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.accentPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Row(
          children: [
            _ThemeSwatches(theme: theme),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                theme.name,
                style: AppTypography.body.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isCustom) ...[
              IconButton(
                icon: const Icon(LucideIcons.pencil, size: 14),
                tooltip: l10n.terminalThemeEditTooltip,
                onPressed: () {
                  Navigator.of(context).pop();
                  onEditCustom?.call(id);
                },
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2,
                    size: 14, color: AppColors.accentRed),
                tooltip: l10n.terminalThemeDeleteTooltip,
                onPressed: () {
                  onDeleteCustom?.call(id);
                  Navigator.of(context).pop();
                },
                visualDensity: VisualDensity.compact,
              ),
            ],
            if (isSelected)
              const Icon(LucideIcons.check,
                  size: 18, color: AppColors.accentPrimary),
          ],
        ),
      ),
    );
  }
}

/// Row of color swatches showing a theme's palette.
class _ThemeSwatches extends StatelessWidget {
  const _ThemeSwatches({required this.theme});

  final TerminalTheme theme;

  @override
  Widget build(BuildContext context) {
    final colors = [
      theme.background,
      theme.foreground,
      theme.red,
      theme.green,
      theme.blue,
      theme.cyan,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: colors
          .map((c) => Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(right: 2),
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Font Size Picker Dialog
// ---------------------------------------------------------------------------

class _FontSizePickerDialog extends StatefulWidget {
  const _FontSizePickerDialog({
    required this.currentSize,
    required this.onSave,
  });

  final double currentSize;
  final ValueChanged<double> onSave;

  @override
  State<_FontSizePickerDialog> createState() => _FontSizePickerDialogState();
}

class _FontSizePickerDialogState extends State<_FontSizePickerDialog> {
  late double _size;

  double get _defaultSize => PlatformUtils.isDesktop
      ? AppConstants.defaultTerminalFontSizeDesktop
      : AppConstants.defaultTerminalFontSizeMobile;

  @override
  void initState() {
    super.initState();
    _size = widget.currentSize;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.fontSizePickerTitle, style: AppTypography.h2),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Preview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgDeepest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              l10n.fontSizePreviewText,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: _size,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Slider with label
          Row(
            children: [
              Text(l10n.settingFontSizeSuffix(_size.toInt().toString()),
                  style: AppTypography.body
                      .copyWith(fontWeight: FontWeight.w600)),
              Expanded(
                child: Slider(
                  value: _size,
                  min: 10,
                  max: 24,
                  divisions: 14,
                  onChanged: (v) => setState(() => _size = v),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() => _size = _defaultSize);
          },
          child: Text(l10n.fontSizeReset),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            widget.onSave(_size);
            Navigator.of(context).pop();
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Font Family Picker Dialog
// ---------------------------------------------------------------------------

class _FontFamilyPickerDialog extends StatelessWidget {
  const _FontFamilyPickerDialog({
    required this.currentFamily,
    required this.onSelect,
  });

  final String currentFamily;
  final ValueChanged<String> onSelect;

  /// Returns a TextStyle for the given font family.
  ///
  /// JetBrainsMono is bundled; others are loaded via Google Fonts.
  TextStyle _fontStyle(String family) {
    return switch (family) {
      'JetBrainsMono' => const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 14,
        ),
      'Fira Code' => GoogleFonts.firaCode(fontSize: 14),
      'Source Code Pro' => GoogleFonts.sourceCodePro(fontSize: 14),
      'Roboto Mono' => GoogleFonts.robotoMono(fontSize: 14),
      'IBM Plex Mono' => GoogleFonts.ibmPlexMono(fontSize: 14),
      'Inconsolata' => GoogleFonts.inconsolata(fontSize: 14),
      'Ubuntu Mono' => GoogleFonts.ubuntuMono(fontSize: 14),
      'Cousine' => GoogleFonts.cousine(fontSize: 14),
      'Anonymous Pro' => GoogleFonts.anonymousPro(fontSize: 14),
      'PT Mono' => GoogleFonts.ptMono(fontSize: 14),
      _ => TextStyle(fontFamily: family, fontSize: 14),
    };
  }

  String _displayName(String family) => switch (family) {
        'JetBrainsMono' => 'JetBrains Mono',
        _ => family,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.fontFamilyPickerTitle, style: AppTypography.h2),
      contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
      content: SizedBox(
        width: 400,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: AppConstants.terminalFonts.length,
          itemBuilder: (context, index) {
            final family = AppConstants.terminalFonts[index];
            final isSelected = family == currentFamily;

            return InkWell(
              onTap: () {
                onSelect(family);
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: isSelected
                    ? BoxDecoration(
                        color:
                            AppColors.accentPrimary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _displayName(family),
                            style: AppTypography.body.copyWith(
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.fontFamilyPreviewText,
                            style: _fontStyle(family).copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(LucideIcons.check,
                          size: 18, color: AppColors.accentPrimary),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Number Input Dialog
// ---------------------------------------------------------------------------

class _NumberInputDialog extends StatefulWidget {
  const _NumberInputDialog({
    required this.title,
    required this.current,
    required this.min,
    required this.max,
    required this.onSave,
  });

  final String title;
  final int current;
  final int min;
  final int max;
  final ValueChanged<int> onSave;

  @override
  State<_NumberInputDialog> createState() => _NumberInputDialogState();
}

class _NumberInputDialogState extends State<_NumberInputDialog> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.current}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validate() {
    final l10n = AppLocalizations.of(context);
    final val = int.tryParse(_controller.text);
    if (val == null) {
      setState(() => _error = l10n.numberInputInvalidNumber);
    } else if (val < widget.min || val > widget.max) {
      setState(
          () => _error = l10n.numberInputRangeError(widget.min.toString(), widget.max.toString()));
    } else {
      setState(() => _error = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title, style: AppTypography.h2),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
          errorText: _error,
          hintText: '${widget.current}',
        ),
        onChanged: (_) => _validate(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            _validate();
            if (_error != null) return;
            final val = int.parse(_controller.text);
            widget.onSave(val);
            Navigator.of(context).pop();
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared Widgets
// ---------------------------------------------------------------------------

/// A grouped section of settings with a header.
class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppTypography.overline.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? theme.cardColor : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            children: List.generate(children.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Divider(
                  height: 1,
                  indent: 52,
                  color: theme.colorScheme.outlineVariant,
                );
              }
              return children[index ~/ 2];
            }),
          ),
        ),
      ],
    );
  }
}

/// Individual settings row with icon, title, subtitle, and optional trailing widget.
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.body.copyWith(
                        color: theme.colorScheme.onSurface,
                      )),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
          ],
        ),
      ),
    );
  }
}

/// Two-factor authentication settings tile.
class _TotpTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isAuth = ref.watch(isAuthenticatedProvider);
    final totpAsync = ref.watch(totpEnabledProvider);

    if (!isAuth) {
      return _SettingsTile(
        icon: LucideIcons.shieldAlert,
        title: l10n.totp2faTitle,
        subtitle: l10n.totpSignInToEnable,
      );
    }

    final isEnabled = totpAsync.valueOrNull ?? false;

    return _SettingsTile(
      icon: isEnabled ? LucideIcons.shieldCheck : LucideIcons.shieldAlert,
      title: l10n.totp2faTitle,
      subtitle: isEnabled ? l10n.totpEnabled : l10n.totpNotConfigured,
      onTap: () {
        if (isEnabled) {
          _showDisable2faDialog(context, ref);
        } else {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (_) => const TotpSetupScreen()),
          );
        }
      },
    );
  }

  void _showDisable2faDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.totpDisable2faTitle, style: AppTypography.h2),
        content: Text(l10n.totpDisable2faMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentRed,
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                final service = ref.read(totpServiceProvider);
                final factor = await service.getVerifiedTotpFactor();
                if (factor != null) {
                  await service.unenroll(factor.id);
                  ref.invalidate(totpEnabledProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.totpDisabled),
                      ),
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.totpDisable2faTitle}: $e'),
                      backgroundColor: AppColors.accentRed,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.totpDisable2faSubmit),
          ),
        ],
      ),
    );
  }
}
