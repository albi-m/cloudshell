/// Hosts list screen — the default home screen of CloudShell.
///
/// Displays all saved SSH hosts organized by groups,
/// with search, filtering, and quick connect functionality.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/database/app_database.dart';
import '../../providers/connection_provider.dart';
import '../../providers/host_provider.dart';
import '../../services/ssh/ssh_service.dart';
import '../shared/confirmation_dialog.dart';
import '../shared/empty_state.dart';
import '../shared/loading_indicator.dart';
import '../terminal/terminal_screen.dart';
import 'host_form_screen.dart';

/// Main hosts list screen showing all saved SSH connections.
class HostsScreen extends ConsumerWidget {
  const HostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostsAsync = ref.watch(allHostsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text('Hosts', style: AppTypography.h1),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            tooltip: 'Add host',
            onPressed: () => _openHostForm(context),
          ),
        ],
      ),
      body: hostsAsync.when(
        data: (hosts) {
          if (hosts.isEmpty) {
            return EmptyState(
              icon: LucideIcons.server,
              title: 'No hosts yet',
              subtitle: 'Add your first SSH server to get started.',
              actionLabel: 'Add Host',
              onAction: () => _openHostForm(context),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: hosts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              return _HostListItem(
                host: hosts[index],
                onTap: () => _connectToHost(context, ref, hosts[index]),
                onEdit: () => _openHostForm(context, host: hosts[index]),
                onDelete: () => _deleteHost(context, ref, hosts[index]),
              );
            },
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading hosts...'),
        error: (error, _) => Center(
          child: Text(
            'Failed to load hosts: $error',
            style: AppTypography.body.copyWith(color: AppColors.accentRed),
          ),
        ),
      ),
    );
  }

  void _openHostForm(BuildContext context, {Host? host}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HostFormScreen(host: host),
      ),
    );
  }

  Future<void> _connectToHost(BuildContext context, WidgetRef ref, Host host) async {
    final sshService = ref.read(sshServiceProvider);
    final connections = ref.read(activeConnectionsProvider.notifier);

    try {
      // Show connecting indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connecting to ${host.label}...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final session = await sshService.connect(host: host);

      connections.addConnection(session.sessionId, host.id);
      connections.updateStatus(session.sessionId, ConnectionStatus.connected);

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TerminalScreen(session: session),
          ),
        );
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

  Future<void> _deleteHost(BuildContext context, WidgetRef ref, Host host) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Host',
      message: 'Are you sure you want to delete "${host.label}"? This cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (confirmed) {
      final db = ref.read(databaseProvider);
      await db.hostDao.softDeleteHost(host.id);
    }
  }
}

/// Individual host list item with connection info and actions.
class _HostListItem extends StatelessWidget {
  const _HostListItem({
    required this.host,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Host host;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Server icon with status
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.bgRaised,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.server,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (host.isFavorite)
                    const Positioned(
                      right: -2,
                      top: -2,
                      child: Icon(
                        LucideIcons.star,
                        size: 12,
                        color: AppColors.accentOrange,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Host info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      host.label,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${host.username}@${host.hostname}:${host.port}',
                      style: AppTypography.code(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (host.lastConnectedAt != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        Formatters.relativeTime(host.lastConnectedAt!),
                        style: AppTypography.caption,
                      ),
                    ],
                  ],
                ),
              ),

              // Action menu
              PopupMenuButton<String>(
                icon: const Icon(
                  LucideIcons.moreVertical,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(LucideIcons.pencil, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(LucideIcons.trash2, size: 16, color: AppColors.accentRed),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
