/// Application settings screen.
///
/// Provides access to appearance, terminal, security,
/// sync, and about sub-sections.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/platform_utils.dart';
import '../../providers/settings_provider.dart';

/// Settings screen with categorized setting groups.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _themeModeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.dark => 'Dark',
        ThemeMode.light => 'Light',
        ThemeMode.system => 'System',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppTypography.h1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSection(
            title: 'Appearance',
            children: [
              _SettingsTile(
                icon: LucideIcons.palette,
                title: 'Theme',
                subtitle: _themeModeLabel(themeMode),
                onTap: () => _showThemePicker(context, ref, themeMode),
              ),
              _SettingsTile(
                icon: LucideIcons.type,
                title: 'Terminal Font',
                subtitle: 'JetBrains Mono, 14px',
                onTap: () {},
              ),
              _SettingsTile(
                icon: LucideIcons.monitor,
                title: 'Terminal Theme',
                subtitle: 'CloudShell Default',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Security',
            children: [
              if (PlatformUtils.supportsBiometrics)
                _SettingsTile(
                  icon: LucideIcons.fingerprint,
                  title: 'Biometric Unlock',
                  subtitle:
                      'Use ${PlatformUtils.isMacOS ? "Touch ID" : "biometrics"} to unlock',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
              _SettingsTile(
                icon: LucideIcons.lock,
                title: 'Auto-Lock',
                subtitle: 'After 5 minutes of inactivity',
                onTap: () {},
              ),
              _SettingsTile(
                icon: LucideIcons.shieldCheck,
                title: 'Security',
                subtitle: 'Master password, clipboard timeout',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Sync',
            children: [
              _SettingsTile(
                icon: LucideIcons.cloud,
                title: 'Cloud Sync',
                subtitle: 'Not configured',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'About',
            children: [
              _SettingsTile(
                icon: LucideIcons.info,
                title: AppConstants.appName,
                subtitle: 'Version 0.1.0',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: AppConstants.appName,
                  applicationVersion: '0.1.0',
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
            ],
          ),
        ],
      ),
    );
  }

  void _showThemePicker(
      BuildContext context, WidgetRef ref, ThemeMode current) {
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text('Theme', style: AppTypography.h2),
        children: [
          RadioGroup<ThemeMode>(
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
              children: [
                for (final mode in [ThemeMode.dark, ThemeMode.light, ThemeMode.system])
                  RadioListTile<ThemeMode>(
                    title: Text(_themeModeLabel(mode)),
                    value: mode,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
            color: isDark
                ? theme.cardColor
                : theme.colorScheme.surface,
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
            Icon(icon, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.body.copyWith(
                    color: theme.colorScheme.onSurface,
                  )),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
          ],
        ),
      ),
    );
  }
}
