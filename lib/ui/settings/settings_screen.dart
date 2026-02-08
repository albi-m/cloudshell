/// Application settings screen.
///
/// Provides access to appearance, terminal, security,
/// sync, and about sub-sections.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/platform_utils.dart';

/// Settings screen with categorized setting groups.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
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
                subtitle: 'Dark mode',
                onTap: () {
                  // TODO: Navigate to appearance settings
                },
              ),
              _SettingsTile(
                icon: LucideIcons.type,
                title: 'Terminal Font',
                subtitle: 'JetBrains Mono, 14px',
                onTap: () {
                  // TODO: Navigate to terminal settings
                },
              ),
              _SettingsTile(
                icon: LucideIcons.monitor,
                title: 'Terminal Theme',
                subtitle: 'CloudShell Default',
                onTap: () {
                  // TODO: Navigate to terminal theme picker
                },
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
                  subtitle: 'Use ${PlatformUtils.isMacOS ? "Touch ID" : "biometrics"} to unlock',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle biometric unlock
                    },
                  ),
                ),
              _SettingsTile(
                icon: LucideIcons.lock,
                title: 'Auto-Lock',
                subtitle: 'After 5 minutes of inactivity',
                onTap: () {
                  // TODO: Navigate to auto-lock settings
                },
              ),
              _SettingsTile(
                icon: LucideIcons.shieldCheck,
                title: 'Security',
                subtitle: 'Master password, clipboard timeout',
                onTap: () {
                  // TODO: Navigate to security settings
                },
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
                onTap: () {
                  // TODO: Navigate to sync settings
                },
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
                onTap: () {
                  // TODO: Navigate to about screen
                },
              ),
            ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppTypography.overline.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            children: List.generate(children.length * 2 - 1, (index) {
              if (index.isOdd) {
                return const Divider(
                  height: 1,
                  indent: 52,
                  color: AppColors.borderSubtle,
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.body),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
          ],
        ),
      ),
    );
  }
}
