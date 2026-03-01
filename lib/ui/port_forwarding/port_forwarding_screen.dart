/// Port forwarding rules management screen.
///
/// Displays all configured port forwarding rules with their
/// status (active/inactive), grouped by host. Provides actions
/// to add, start, stop, and delete rules.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../data/database/tables/port_forwards_table.dart';
import '../../providers/host_provider.dart';
import '../../providers/port_forward_provider.dart';
import '../../providers/terminal_tab_provider.dart';
import '../../services/port_forwarding/port_forward_service.dart';
import '../../services/ssh/ssh_session.dart';
import '../shared/empty_state.dart';
import '../shared/error_display.dart';
import '../shared/loading_indicator.dart';
import 'port_forward_form_dialog.dart';

/// Screen listing all port forwarding rules.
class PortForwardingScreen extends ConsumerWidget {
  const PortForwardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final forwardsAsync = ref.watch(allPortForwardsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.portForwardingTitle, style: AppTypography.h1),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            tooltip: l10n.portForwardingAddTooltip,
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: forwardsAsync.when(
        data: (forwards) {
          if (forwards.isEmpty) {
            return EmptyState(
              icon: LucideIcons.arrowLeftRight,
              title: l10n.portForwardingEmptyTitle,
              subtitle: l10n.portForwardingEmptySubtitle,
              actionLabel: l10n.portForwardingEmptyAction,
              onAction: () => _showAddDialog(context),
            );
          }

          // Group by hostId
          final grouped = <String, List<PortForward>>{};
          for (final rule in forwards) {
            grouped.putIfAbsent(rule.hostId, () => []).add(rule);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final hostId = grouped.keys.elementAt(index);
              final rules = grouped[hostId]!;
              return _HostRuleGroup(
                hostId: hostId,
                rules: rules,
              );
            },
          );
        },
        loading: () =>
            LoadingIndicator(message: l10n.portForwardingLoading),
        error: (error, _) => ErrorDisplay(
          error: error,
          onRetry: () => ref.invalidate(allPortForwardsProvider),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const PortForwardFormDialog(),
    );
  }
}

/// Group of port forward rules for a single host.
class _HostRuleGroup extends ConsumerWidget {
  const _HostRuleGroup({
    required this.hostId,
    required this.rules,
  });

  final String hostId;
  final List<PortForward> rules;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hostAsync = ref.watch(hostByIdProvider(hostId));
    final hostLabel = hostAsync.whenOrNull(
          data: (h) => h != null ? h.label : 'Unknown Host',
        ) ??
        l10n.loading;

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
          child: Row(
            children: [
              Icon(LucideIcons.server,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 8),
              Text(
                hostLabel,
                style: AppTypography.overline.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        ...rules.map((rule) => _PortForwardTile(rule: rule)),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Single port forward rule tile with type badge, ports, and actions.
class _PortForwardTile extends ConsumerWidget {
  const _PortForwardTile({required this.rule});

  final PortForward rule;

  String _typeLabel(AppLocalizations l10n) => switch (rule.type) {
        PortForwardTypeEnum.local => l10n.portForwardingTypeLocal,
        PortForwardTypeEnum.remote => l10n.portForwardingTypeRemote,
        PortForwardTypeEnum.dynamic => l10n.portForwardingTypeDynamic,
      };

  Color _typeColor(BuildContext context) => switch (rule.type) {
        PortForwardTypeEnum.local => AppColors.accentPrimary,
        PortForwardTypeEnum.remote => AppColors.accentOrange,
        PortForwardTypeEnum.dynamic => AppColors.accentPurple,
      };

  String get _portsLabel {
    final dest = rule.destinationHost ?? 'localhost';
    final destPort = rule.destinationPort ?? rule.sourcePort;
    if (rule.type == PortForwardTypeEnum.local) {
      return ':${rule.sourcePort} → $dest:$destPort';
    } else if (rule.type == PortForwardTypeEnum.remote) {
      return '$dest:${rule.sourcePort} → :$destPort';
    }
    return ':${rule.sourcePort}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final service = ref.watch(portForwardServiceProvider);
    final isActive = service.isActive(rule.id);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Active indicator
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.statusOnline
                    : AppColors.statusIdle,
              ),
            ),
            const SizedBox(width: 12),
            // Type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _typeColor(context).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _typeLabel(l10n),
                style: AppTypography.caption.copyWith(
                  color: _typeColor(context),
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Label and ports
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rule.label,
                    style: AppTypography.body.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _portsLabel,
                    style: AppTypography.caption.copyWith(
                      fontFamily: 'JetBrains Mono',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Auto-start indicator
            if (rule.autoStart)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Tooltip(
                  message: 'Auto-start on connect',
                  child: Icon(
                    LucideIcons.zap,
                    size: 14,
                    color: isDark
                        ? AppColors.accentOrange.withValues(alpha: 0.7)
                        : AppColors.accentOrange,
                  ),
                ),
              ),
            // Start/Stop toggle
            Switch(
              value: isActive,
              onChanged: (value) =>
                  _toggleForward(context, ref, value),
            ),
            // Actions
            PopupMenuButton<String>(
              icon: Icon(
                LucideIcons.moreVertical,
                size: 18,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              onSelected: (value) {
                switch (value) {
                  case 'delete':
                    _deleteRule(context, ref);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(LucideIcons.trash2,
                          size: 16, color: AppColors.accentRed),
                      const SizedBox(width: 8),
                      Text(l10n.delete),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleForward(
      BuildContext context, WidgetRef ref, bool activate) async {
    final service = ref.read(portForwardServiceProvider);

    if (!activate) {
      await service.stopForward(rule.id);
      return;
    }

    // Find an active SSH connection for this host
    final termState = ref.read(terminalTabsProvider);
    final connectedTab = termState.tabs
        .where((t) => t.session.hostId == rule.hostId && t.isConnected)
        .firstOrNull;

    if (connectedTab == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Connect to the host first to start this forward.'),
          ),
        );
      }
      return;
    }

    // Port forwarding requires an SSH connection
    if (connectedTab.session is! SshSessionWrapper) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Port forwarding is only available for SSH connections.'),
          ),
        );
      }
      return;
    }

    final sshSession = connectedTab.session as SshSessionWrapper;

    try {
      switch (rule.type) {
        case PortForwardTypeEnum.local:
          await service.startLocalForward(sshSession.client, rule);
        case PortForwardTypeEnum.remote:
          await service.startRemoteForward(sshSession.client, rule);
        case PortForwardTypeEnum.dynamic:
          await service.startDynamicForward(sshSession.client, rule);
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.userMessage(e))),
        );
      }
    }
  }

  Future<void> _deleteRule(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final service = ref.read(portForwardServiceProvider);

    // Stop if active
    if (service.isActive(rule.id)) {
      await service.stopForward(rule.id);
    }

    await db.portForwardDao.softDeletePortForward(rule.id);
  }
}
