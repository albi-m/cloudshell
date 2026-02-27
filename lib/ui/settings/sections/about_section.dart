/// About settings section.
///
/// App version, privacy policy, and terms of service.
library;

import 'package:flutter/material.dart';

import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../legal_screen.dart';
import '../widgets/settings_section.dart';

/// About section of the settings screen.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return SettingsSection(
      title: l10n.sectionAbout,
      children: [
        SettingsTile(
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
        SettingsTile(
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
        SettingsTile(
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
    );
  }
}
