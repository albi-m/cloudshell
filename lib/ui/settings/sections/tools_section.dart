/// Tools settings section.
///
/// Workspaces, password generator, and session logs.
library;

import 'package:flutter/material.dart';

import 'package:lucide_icons/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../tools/password_generator_screen.dart';
import '../session_logs_screen.dart';
import '../workspace_manager_screen.dart';
import '../widgets/settings_section.dart';

/// Tools section of the settings screen.
class ToolsSection extends StatelessWidget {
  const ToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SettingsSection(
      title: l10n.sectionTools,
      children: [
        SettingsTile(
          icon: LucideIcons.layout,
          title: l10n.settingWorkspacesTitle,
          subtitle: l10n.settingWorkspacesSubtitle,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => const WorkspaceManagerScreen()),
          ),
        ),
        SettingsTile(
          icon: LucideIcons.keyRound,
          title: l10n.settingPasswordGeneratorTitle,
          subtitle: l10n.settingPasswordGeneratorSubtitle,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => const PasswordGeneratorScreen()),
          ),
        ),
        SettingsTile(
          icon: LucideIcons.fileText,
          title: l10n.settingSessionLogsTitle,
          subtitle: l10n.settingSessionLogsSubtitle,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => const SessionLogsScreen()),
          ),
        ),
      ],
    );
  }
}
