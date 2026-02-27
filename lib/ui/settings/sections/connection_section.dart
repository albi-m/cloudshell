/// Connection settings section.
///
/// Default SSH port, connection timeout, and keep-alive interval.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/settings_provider.dart';
import '../widgets/number_input_dialog.dart';
import '../widgets/settings_section.dart';

/// Connection section of the settings screen.
class ConnectionSection extends ConsumerWidget {
  const ConnectionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final defaultPort = ref.watch(defaultSshPortProvider);
    final defaultTimeout = ref.watch(defaultTimeoutProvider);
    final defaultKeepAlive = ref.watch(defaultKeepAliveProvider);

    return SettingsSection(
      title: l10n.sectionConnection,
      children: [
        SettingsTile(
          icon: LucideIcons.hash,
          title: l10n.settingDefaultSshPortTitle,
          subtitle: '$defaultPort',
          onTap: () => showNumberInput(
            context,
            ref,
            title: l10n.dialogDefaultSshPort,
            key: SettingsKeys.defaultSshPort,
            current: defaultPort,
            min: 1,
            max: 65535,
          ),
        ),
        SettingsTile(
          icon: LucideIcons.clock,
          title: l10n.settingConnectionTimeoutTitle,
          subtitle:
              l10n.settingTimeoutSuffix(defaultTimeout.toString()),
          onTap: () => showNumberInput(
            context,
            ref,
            title: l10n.dialogConnectionTimeout,
            key: SettingsKeys.defaultTimeout,
            current: defaultTimeout,
            min: 5,
            max: 120,
          ),
        ),
        SettingsTile(
          icon: LucideIcons.heartPulse,
          title: l10n.settingKeepAliveTitle,
          subtitle:
              l10n.settingTimeoutSuffix(defaultKeepAlive.toString()),
          onTap: () => showNumberInput(
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
    );
  }
}
