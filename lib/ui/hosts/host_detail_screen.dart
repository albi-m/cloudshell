/// Host detail screen showing full information for a single host.
///
/// Displays all connection details, authentication info, group,
/// notes, and provides actions to connect, edit, and delete.
/// Matches wireframe S2.2.
library;

import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../data/database/app_database.dart';
import '../../data/database/tables/hosts_table.dart';
import '../../providers/connection_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/host_provider.dart';
import '../../providers/key_provider.dart';
import '../../providers/terminal_tab_provider.dart';
import '../../providers/workspace_provider.dart';
import '../../services/port_forwarding/port_forward_service.dart';
import '../../services/connection/protocol_connector.dart';
import '../../services/ssh/ssh_session.dart';
import '../shared/confirmation_dialog.dart';
import '../shared/error_display.dart';
import '../shared/loading_indicator.dart';
import 'host_form_screen.dart';

/// Detail view for a single SSH host.
///
/// Shows all host metadata and provides connect, edit, delete,
/// and favorite toggle actions.
class HostDetailScreen extends ConsumerWidget {
  const HostDetailScreen({super.key, required this.hostId});

  final String hostId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hostAsync = ref.watch(hostByIdProvider(hostId));

    return hostAsync.when(
      data: (host) {
        if (host == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.hostDetailNotFound)),
          );
        }
        return _HostDetailView(host: host);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: LoadingIndicator(message: l10n.hostDetailLoading),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorDisplay(
          error: error,
          onRetry: () => ref.invalidate(hostByIdProvider(hostId)),
        ),
      ),
    );
  }
}

class _HostDetailView extends ConsumerWidget {
  const _HostDetailView({required this.host});

  final Host host;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final connections = ref.watch(activeConnectionsProvider);
    final isConnected = connections.values.any(
      (c) => c.hostId == host.id && c.status == ConnectionStatus.connected,
    );

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text(host.label, style: AppTypography.h2),
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.star,
              color: host.isFavorite
                  ? AppColors.accentOrange
                  : AppColors.textTertiary,
            ),
            tooltip: l10n.hostDetailFavoriteTooltip,
            onPressed: () => _toggleFavorite(ref),
          ),
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _edit(context);
                case 'delete':
                  _delete(context, ref);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(LucideIcons.pencil, size: 16),
                    const SizedBox(width: 8),
                    Text(l10n.hostDetailEditTooltip),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(LucideIcons.trash2,
                        size: 16, color: AppColors.accentRed),
                    const SizedBox(width: 8),
                    Text(l10n.hostDetailDeleteTooltip),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Connection status banner
          _StatusBanner(isConnected: isConnected),
          const SizedBox(height: 16),

          // Connect button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _connect(context, ref),
              icon: Icon(
                isConnected ? LucideIcons.terminal : LucideIcons.play,
                size: 18,
              ),
              label: Text(isConnected ? l10n.hostsMenuConnect : l10n.hostDetailConnect),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Connection details
          _SectionCard(
            title: l10n.hostDetailSectionConnection,
            children: [
              _DetailRow(
                icon: LucideIcons.globe,
                label: l10n.hostDetailLabelHostname,
                value: host.hostname,
              ),
              _DetailRow(
                icon: LucideIcons.hash,
                label: l10n.hostDetailLabelPort,
                value: '${host.port}',
              ),
              _DetailRow(
                icon: LucideIcons.user,
                label: l10n.hostDetailLabelUsername,
                value: host.username,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Authentication
          _SectionCard(
            title: l10n.hostDetailSectionAuthentication,
            children: [
              _DetailRow(
                icon: LucideIcons.shieldCheck,
                label: l10n.hostDetailLabelAuthMethod,
                value: switch (host.authMethod) {
                  AuthMethodType.key => l10n.hostFormAuthMethodKey,
                  AuthMethodType.password => l10n.hostFormAuthMethodPassword,
                  AuthMethodType.keyAndPassword => l10n.hostFormAuthMethodKeyAndPassword,
                  AuthMethodType.interactive => 'Interactive',
                },
              ),
              if (host.keyId != null)
                _KeyDetailRow(keyId: host.keyId!),
            ],
          ),
          const SizedBox(height: 12),

          // Group & metadata
          _SectionCard(
            title: l10n.hostDetailTitle,
            children: [
              if (host.groupId != null)
                _GroupDetailRow(groupId: host.groupId!),
              if (host.jumpHostId != null)
                _JumpHostDetailRow(jumpHostId: host.jumpHostId!),
              if (host.tags.isNotEmpty) _TagsRow(tags: host.tags),
              _DetailRow(
                icon: LucideIcons.clock,
                label: l10n.hostDetailLabelLastConnected,
                value: host.lastConnectedAt != null
                    ? Formatters.relativeTime(host.lastConnectedAt!)
                    : l10n.hostsNeverConnected,
              ),
              _DetailRow(
                icon: LucideIcons.calendar,
                label: l10n.hostDetailLabelCreated,
                value: Formatters.relativeTime(host.createdAt),
              ),
            ],
          ),

          // Advanced settings
          if (host.startupCommand != null ||
              host.keepAliveSeconds != 60 ||
              host.notes != null) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: l10n.hostDetailSectionAdvanced,
              children: [
                if (host.startupCommand != null)
                  _DetailRow(
                    icon: LucideIcons.terminal,
                    label: l10n.hostDetailLabelStartupCommand,
                    value: host.startupCommand!,
                  ),
                if (host.keepAliveSeconds != 60)
                  _DetailRow(
                    icon: LucideIcons.heartPulse,
                    label: l10n.hostDetailLabelKeepAlive,
                    value: '${host.keepAliveSeconds}s',
                  ),
                if (host.notes != null)
                  _DetailRow(
                    icon: LucideIcons.stickyNote,
                    label: l10n.hostDetailSectionNotes,
                    value: host.notes!,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _connect(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    // Check if already connected — if so, switch to existing tab
    final terminalTabs = ref.read(terminalTabsProvider);
    final existingTab = terminalTabs.tabs
        .where((t) => t.session.hostId == host.id && t.isConnected)
        .firstOrNull;
    if (existingTab != null) {
      ref.read(terminalTabsProvider.notifier).switchToTab(existingTab.id);
      ref.read(workspaceProvider.notifier).openTerminalTab(
            existingTab.id,
            existingTab.hostLabel,
          );
      if (context.mounted) Navigator.of(context).pop();
      return;
    }

    final connections = ref.read(activeConnectionsProvider.notifier);

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.hostsMenuConnect}: ${host.label}...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final session = await connectByProtocol(ref.read, host);

      connections.addConnection(session.sessionId, host.id);
      connections.updateStatus(session.sessionId, ConnectionStatus.connected);

      // Update last connected timestamp
      final db = ref.read(databaseProvider);
      await db.hostDao.updateLastConnected(host.id);

      // Auto-start port forwards for SSH connections only (fire-and-forget)
      if (session is SshSessionWrapper) {
        final pfService = ref.read(portForwardServiceProvider);
        unawaited(pfService.autoStartForwards(session.client, host.id));
      }

      // Add terminal tab + workspace tab (provider owns xterm state)
      await ref.read(terminalTabsProvider.notifier).addTab(
            session,
            host.label,
            startupCommand: host.startupCommand,
          );
      ref.read(workspaceProvider.notifier).openTerminalTab(
            session.sessionId,
            host.label,
          );

      // Navigate back to the shell (workspace tab bar will show the terminal)
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ErrorHandler.handle(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.userMessage(e)),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  void _edit(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => HostFormScreen(host: host),
      ),
    );
  }

  Future<void> _toggleFavorite(WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    await db.hostDao.updateHost(HostsCompanion(
      id: Value(host.id),
      isFavorite: Value(!host.isFavorite),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmationDialog(
      context: context,
      title: l10n.hostDetailDeleteDialogTitle,
      message: l10n.hostDetailDeleteDialogMessage(host.label),
      confirmLabel: l10n.delete,
      isDestructive: true,
    );

    if (!confirmed) return;

    final db = ref.read(databaseProvider);
    await db.hostDao.softDeleteHost(host.id);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

/// Status banner showing connected/disconnected state.
class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isConnected
            ? AppColors.statusOnline.withValues(alpha: 0.1)
            : AppColors.bgSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isConnected
              ? AppColors.statusOnline.withValues(alpha: 0.3)
              : AppColors.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isConnected ? AppColors.statusOnline : AppColors.statusIdle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            isConnected ? l10n.hostsMenuConnect : l10n.hostsNeverConnected,
            style: AppTypography.body.copyWith(
              color: isConnected
                  ? AppColors.statusOnline
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section card with a title label and list of detail rows.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.overline
                  .copyWith(color: AppColors.textTertiary),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Single detail row with icon, label, and value.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style:
                  AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.body,
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail row that resolves a key ID to show the key label.
class _KeyDetailRow extends ConsumerWidget {
  const _KeyDetailRow({required this.keyId});

  final String keyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final keyAsync = ref.watch(keyByIdProvider(keyId));
    final keyLabel = keyAsync.whenOrNull(data: (k) => k?.label) ?? l10n.loading;

    return _DetailRow(
      icon: LucideIcons.keyRound,
      label: l10n.hostDetailLabelKey,
      value: keyLabel,
    );
  }
}

/// Detail row that resolves a group ID to show the group name.
class _GroupDetailRow extends ConsumerWidget {
  const _GroupDetailRow({required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final groupAsync = ref.watch(groupByIdProvider(groupId));
    final groupName =
        groupAsync.whenOrNull(data: (g) => g?.name) ?? l10n.loading;

    return _DetailRow(
      icon: LucideIcons.folder,
      label: l10n.hostDetailLabelGroup,
      value: groupName,
    );
  }
}

/// Detail row that resolves a jump host ID to show the host label.
class _JumpHostDetailRow extends ConsumerWidget {
  const _JumpHostDetailRow({required this.jumpHostId});

  final String jumpHostId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hostAsync = ref.watch(hostByIdProvider(jumpHostId));
    final hostLabel = hostAsync.whenOrNull(
          data: (h) => h != null ? '${h.label} (${h.hostname})' : null,
        ) ??
        l10n.loading;

    return _DetailRow(
      icon: LucideIcons.gitBranch,
      label: l10n.hostDetailLabelJumpHost,
      value: hostLabel,
    );
  }
}

/// Detail row showing tags as colored badges.
class _TagsRow extends StatelessWidget {
  const _TagsRow({required this.tags});

  final String tags;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tagList =
        tags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.tags, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              l10n.hostDetailSectionTags,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: tagList
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            AppColors.accentPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.accentPrimary
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: AppTypography.caption.copyWith(
                          fontSize: 11,
                          color: AppColors.accentPrimary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
