/// Application settings screen.
///
/// Provides access to appearance, terminal, connection, security,
/// sync, and about sub-sections.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import 'sections/about_section.dart';
import 'sections/appearance_section.dart';
import 'sections/cloud_import_section.dart';
import 'sections/connection_section.dart';
import 'sections/data_section.dart';
import 'sections/notification_section.dart';
import 'sections/security_section.dart';
import 'sections/sync_section.dart';
import 'sections/tools_section.dart';

/// Settings screen with categorized setting groups.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle, style: AppTypography.h1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AppearanceSection(),
          SizedBox(height: 16),
          ConnectionSection(),
          SizedBox(height: 16),
          NotificationSection(),
          SizedBox(height: 16),
          SecuritySection(),
          SizedBox(height: 16),
          ToolsSection(),
          SizedBox(height: 16),
          DataSection(),
          SizedBox(height: 16),
          CloudImportSection(),
          SizedBox(height: 16),
          SyncSection(),
          SizedBox(height: 16),
          AboutSection(),
        ],
      ),
    );
  }
}
