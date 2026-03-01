/// Cloud import settings section.
///
/// AWS EC2 and DigitalOcean import wizards.
library;

import 'package:flutter/material.dart';

import 'package:lucide_icons/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../cloud_import/aws_import_screen.dart';
import '../cloud_import/do_import_screen.dart';
import '../widgets/settings_section.dart';

/// Cloud import section of the settings screen.
class CloudImportSection extends StatelessWidget {
  const CloudImportSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SettingsSection(
      title: l10n.sectionCloudImport,
      children: [
        SettingsTile(
          icon: LucideIcons.cloud,
          title: l10n.settingAwsEc2Title,
          subtitle: l10n.settingAwsEc2Subtitle,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => const AwsImportScreen()),
          ),
        ),
        SettingsTile(
          icon: LucideIcons.cloud,
          title: l10n.settingDigitalOceanTitle,
          subtitle: l10n.settingDigitalOceanSubtitle,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => const DoImportScreen()),
          ),
        ),
      ],
    );
  }
}
