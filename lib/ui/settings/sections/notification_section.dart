/// Notification settings section.
///
/// Command completion sound and notification threshold.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/settings_provider.dart';
import '../widgets/number_input_dialog.dart';
import '../widgets/settings_section.dart';

/// Notification section of the settings screen.
class NotificationSection extends ConsumerWidget {
  const NotificationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final commandNotifyEnabled = ref.watch(commandNotifyEnabledProvider);
    final commandNotifyThreshold = ref.watch(commandNotifyThresholdProvider);

    return SettingsSection(
      title: l10n.sectionNotifications,
      children: [
        SettingsTile(
          icon: LucideIcons.bell,
          title: l10n.settingCommandCompletionSoundTitle,
          subtitle: commandNotifyEnabled
              ? l10n.settingCommandNotifyEnabled(
                  commandNotifyThreshold.toString())
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
          SettingsTile(
            icon: LucideIcons.timer,
            title: l10n.settingNotificationThresholdTitle,
            subtitle: l10n.settingTimeoutSuffix(
                commandNotifyThreshold.toString()),
            onTap: () => showNumberInput(
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
    );
  }
}
