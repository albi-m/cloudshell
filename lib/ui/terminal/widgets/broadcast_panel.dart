/// Broadcast panel for selecting which terminal tabs receive broadcast input.
///
/// Shown as a modal bottom sheet from the terminal status bar.
/// Lists all connected terminal tabs with checkboxes for selective
/// broadcast, plus a "Broadcast All" toggle.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/terminal_tab_provider.dart';

/// Shows the broadcast panel as a modal bottom sheet.
///
/// Lets the user toggle broadcast mode to send keyboard input to all
/// connected terminal tabs at once, or select individual tabs for
/// selective broadcast.
void showBroadcastPanel(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _BroadcastPanel(),
  );
}

class _BroadcastPanel extends ConsumerWidget {
  const _BroadcastPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tabsState = ref.watch(terminalTabsProvider);
    final notifier = ref.read(terminalTabsProvider.notifier);
    final broadcastEnabled = notifier.broadcastEnabled;
    final broadcastGroup = notifier.broadcastGroup;
    final isAllMode = broadcastEnabled && broadcastGroup.isEmpty;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Icon(LucideIcons.radio, size: 18, color: AppColors.accentOrange),
                const SizedBox(width: 8),
                Text(l10n.broadcastPanelTitle, style: AppTypography.h3),
                const Spacer(),
                if (broadcastEnabled)
                  TextButton(
                    onPressed: () {
                      notifier.disableBroadcast();
                      Navigator.of(context).pop();
                    },
                    child: Text(l10n.broadcastPanelDisable),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              l10n.broadcastPanelDescription,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Broadcast All toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Material(
              color: isAllMode
                  ? AppColors.accentOrange.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: ListTile(
                leading: Icon(
                  LucideIcons.radio,
                  size: 18,
                  color: isAllMode
                      ? AppColors.accentOrange
                      : AppColors.textTertiary,
                ),
                title: Text(l10n.broadcastPanelBroadcastToAll,
                    style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600)),
                subtitle: Text(
                    l10n.broadcastPanelConnectedSessions(tabsState.tabs.where((t) => t.isConnected).length),
                    style: AppTypography.caption),
                trailing: Switch(
                  value: isAllMode,
                  onChanged: (v) {
                    if (v) {
                      notifier.broadcastAll();
                    } else {
                      notifier.disableBroadcast();
                    }
                  },
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () {
                  if (isAllMode) {
                    notifier.disableBroadcast();
                  } else {
                    notifier.broadcastAll();
                  }
                },
              ),
            ),
          ),

          const Divider(indent: 20, endIndent: 20),

          // Individual tab list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              itemCount: tabsState.tabs.length,
              itemBuilder: (context, index) {
                final tab = tabsState.tabs[index];
                final isInGroup = broadcastGroup.contains(tab.id);
                final isActive = tab.id == tabsState.activeTabId;

                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    dense: true,
                    leading: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tab.isConnected
                            ? AppColors.statusOnline
                            : AppColors.statusOffline,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            tab.hostLabel,
                            style: AppTypography.body.copyWith(
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isActive)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.accentPrimary
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.broadcastPanelActiveLabel,
                              style: AppTypography.caption.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(
                      tab.isConnected ? l10n.broadcastPanelTabConnected : l10n.broadcastPanelTabDisconnected,
                      style: AppTypography.caption.copyWith(fontSize: 11),
                    ),
                    trailing: Checkbox(
                      value: isAllMode || isInGroup,
                      onChanged: tab.isConnected
                          ? (_) => notifier.toggleBroadcastTab(tab.id)
                          : null,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: tab.isConnected
                        ? () => notifier.toggleBroadcastTab(tab.id)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
