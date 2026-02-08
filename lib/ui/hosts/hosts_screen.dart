/// Hosts list screen — the default home screen of CloudShell.
///
/// Displays all saved SSH hosts organized by groups,
/// with search, filtering, and quick connect functionality.
/// Matches wireframe S2.1.
library;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/database/app_database.dart';
import '../../providers/connection_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/host_provider.dart';
import '../../services/ssh/ssh_service.dart';
import '../shared/confirmation_dialog.dart';
import '../shared/empty_state.dart';
import '../shared/loading_indicator.dart';
import '../terminal/terminal_screen.dart';
import 'group_form_dialog.dart';
import 'host_detail_screen.dart';
import 'host_form_screen.dart';
import 'quick_connect_dialog.dart';

/// Main hosts list screen showing all saved SSH connections.
///
/// Features per wireframe S2.1:
/// - Search bar with filter
/// - Group headers with host counts
/// - Status indicators (online/offline dots)
/// - Favorite toggle per host
/// - Quick connect, detail view, edit, delete actions
class HostsScreen extends ConsumerStatefulWidget {
  const HostsScreen({super.key});

  @override
  ConsumerState<HostsScreen> createState() => _HostsScreenState();
}

class _HostsScreenState extends ConsumerState<HostsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hostsAsync = ref.watch(allHostsProvider);
    final groupsAsync = ref.watch(allGroupsProvider);
    final connections = ref.watch(activeConnectionsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text('Hosts', style: AppTypography.h1),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.zap),
            tooltip: 'Quick connect',
            onPressed: () => showQuickConnectDialog(context),
          ),
          IconButton(
            icon: const Icon(LucideIcons.plus),
            tooltip: 'Add host',
            onPressed: () => _openHostForm(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical),
            onSelected: (value) {
              if (value == 'manage_groups') _openGroupManagement(context);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'manage_groups',
                child: Row(
                  children: [
                    Icon(LucideIcons.folderPlus, size: 16),
                    SizedBox(width: 8),
                    Text('Manage Groups'),
                  ],
                ),
              ),
            ],
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

          // Build a group name lookup map
          final groupNames = <String, String>{};
          groupsAsync.whenData((groups) {
            for (final g in groups) {
              groupNames[g.id] = g.name;
            }
          });

          // Filter hosts by search query
          final filteredHosts = _searchQuery.isEmpty
              ? hosts
              : hosts.where((h) {
                  final q = _searchQuery.toLowerCase();
                  return h.label.toLowerCase().contains(q) ||
                      h.hostname.toLowerCase().contains(q) ||
                      h.username.toLowerCase().contains(q) ||
                      h.tags.toLowerCase().contains(q);
                }).toList();

          // Group hosts by groupId
          final grouped = <String?, List<Host>>{};
          for (final host in filteredHosts) {
            grouped.putIfAbsent(host.groupId, () => []).add(host);
          }

          // Sort groups: named groups first (alphabetical), then ungrouped
          final groupKeys = grouped.keys.toList()
            ..sort((a, b) {
              if (a == null && b == null) return 0;
              if (a == null) return 1;
              if (b == null) return -1;
              return a.compareTo(b);
            });

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search hosts...',
                    prefixIcon: const Icon(LucideIcons.search, size: 18),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),

              // Host list grouped by group
              Expanded(
                child: filteredHosts.isEmpty
                    ? Center(
                        child: Text(
                          'No hosts match "$_searchQuery"',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                        children: _buildListItems(
                          groupKeys,
                          grouped,
                          connections,
                          groupNames,
                        ),
                      ),
              ),
            ],
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading hosts...'),
        error: (error, _) => Center(
          child: Text(
            'Failed to load hosts',
            style: AppTypography.body.copyWith(color: AppColors.accentRed),
          ),
        ),
      ),
    );
  }

  /// Builds a flat list of widgets with group headers and host items.
  List<Widget> _buildListItems(
    List<String?> groupKeys,
    Map<String?, List<Host>> grouped,
    Map<String, SshConnectionState> connections,
    Map<String, String> groupNames,
  ) {
    final items = <Widget>[];

    for (final groupId in groupKeys) {
      final hosts = grouped[groupId]!;
      // Resolve group name from the lookup map
      final groupLabel =
          groupId != null ? (groupNames[groupId] ?? groupId) : 'Ungrouped';
      final hostCount = hosts.length;

      // Group header
      items.add(
        _GroupHeader(
          label: groupLabel,
          hostCount: hostCount,
        ),
      );

      // Host items
      for (final host in hosts) {
        final isConnected = connections.values.any(
          (c) =>
              c.hostId == host.id && c.status == ConnectionStatus.connected,
        );

        items.add(
          _HostListItem(
            host: host,
            isConnected: isConnected,
            onTap: () => _openHostDetail(context, host),
            onConnect: () => _connectToHost(context, ref, host),
            onEdit: () => _openHostForm(context, host: host),
            onDelete: () => _deleteHost(context, ref, host),
            onToggleFavorite: () => _toggleFavorite(ref, host),
          ),
        );
      }

      // Spacing after group
      items.add(const SizedBox(height: 8));
    }

    return items;
  }

  void _openHostDetail(BuildContext context, Host host) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HostDetailScreen(hostId: host.id),
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

  void _openGroupManagement(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const _GroupManagementScreen(),
      ),
    );
  }

  Future<void> _connectToHost(
      BuildContext context, WidgetRef ref, Host host) async {
    final sshService = ref.read(sshServiceProvider);
    final connections = ref.read(activeConnectionsProvider.notifier);

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connecting to ${host.label}...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final session = await sshService.connect(host: host);

      connections.addConnection(session.sessionId, host.id);
      connections.updateStatus(session.sessionId, ConnectionStatus.connected);

      // Update last connected timestamp
      final db = ref.read(databaseProvider);
      await db.hostDao.updateLastConnected(host.id);

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TerminalScreen(
              session: session,
              hostLabel: host.label,
            ),
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

  Future<void> _toggleFavorite(WidgetRef ref, Host host) async {
    final db = ref.read(databaseProvider);
    await db.hostDao.updateHost(HostsCompanion(
      id: Value(host.id),
      isFavorite: Value(!host.isFavorite),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> _deleteHost(
      BuildContext context, WidgetRef ref, Host host) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Host',
      message:
          'Are you sure you want to delete "${host.label}"? This cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (confirmed) {
      final db = ref.read(databaseProvider);
      await db.hostDao.softDeleteHost(host.id);
    }
  }
}

/// Group header showing group name and host count.
class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label, required this.hostCount});

  final String label;
  final int hostCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label ($hostCount ${hostCount == 1 ? 'host' : 'hosts'})'
                  .toUpperCase(),
              style: AppTypography.overline.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual host list item with connection status, favorite toggle, and actions.
class _HostListItem extends StatelessWidget {
  const _HostListItem({
    required this.host,
    required this.isConnected,
    required this.onTap,
    required this.onConnect,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  final Host host;
  final bool isConnected;
  final VoidCallback onTap;
  final VoidCallback onConnect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

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
              // Status dot + server icon
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
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isConnected
                            ? AppColors.statusOnline
                            : AppColors.statusOffline,
                        border: Border.all(
                          color: AppColors.bgDeepest,
                          width: 1.5,
                        ),
                      ),
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
                        'Last: ${Formatters.relativeTime(host.lastConnectedAt!)}',
                        style: AppTypography.caption,
                      ),
                    ] else ...[
                      const SizedBox(height: 2),
                      Text(
                        'Never connected',
                        style: AppTypography.caption,
                      ),
                    ],
                  ],
                ),
              ),

              // Favorite toggle
              IconButton(
                icon: Icon(
                  LucideIcons.star,
                  size: 18,
                  color: host.isFavorite
                      ? AppColors.accentOrange
                      : AppColors.textTertiary,
                ),
                tooltip: host.isFavorite
                    ? 'Remove from favorites'
                    : 'Add to favorites',
                onPressed: onToggleFavorite,
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
                    case 'connect':
                      onConnect();
                    case 'edit':
                      onEdit();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'connect',
                    child: Row(
                      children: [
                        Icon(LucideIcons.play, size: 16),
                        SizedBox(width: 8),
                        Text('Connect'),
                      ],
                    ),
                  ),
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
                        Icon(LucideIcons.trash2,
                            size: 16, color: AppColors.accentRed),
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

/// Group management screen for creating, editing, and deleting groups.
class _GroupManagementScreen extends ConsumerWidget {
  const _GroupManagementScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(allGroupsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text('Manage Groups', style: AppTypography.h1),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.folderPlus),
            tooltip: 'New group',
            onPressed: () => showGroupFormDialog(context),
          ),
        ],
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return EmptyState(
              icon: LucideIcons.folder,
              title: 'No groups yet',
              subtitle: 'Create groups to organize your hosts.',
              actionLabel: 'New Group',
              onAction: () => showGroupFormDialog(context),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: groups.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final group = groups[index];
              return _GroupListItem(
                group: group,
                onEdit: () => showGroupFormDialog(context, group: group),
                onDelete: () => _deleteGroup(context, ref, group),
              );
            },
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading groups...'),
        error: (error, _) => Center(
          child: Text(
            'Failed to load groups',
            style: AppTypography.body.copyWith(color: AppColors.accentRed),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteGroup(
      BuildContext context, WidgetRef ref, HostGroup group) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Group',
      message:
          'Are you sure you want to delete "${group.name}"? Hosts in this group will become ungrouped.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (confirmed) {
      final db = ref.read(databaseProvider);
      await db.groupDao.softDeleteGroup(group.id);
    }
  }
}

/// Individual group list item for the management screen.
class _GroupListItem extends StatelessWidget {
  const _GroupListItem({
    required this.group,
    required this.onEdit,
    required this.onDelete,
  });

  final HostGroup group;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LucideIcons.folder,
                size: 20,
                color: AppColors.accentPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: AppTypography.body
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (group.defaultUsername != null ||
                      group.defaultPort != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (group.defaultUsername != null)
                          'User: ${group.defaultUsername}',
                        if (group.defaultPort != null)
                          'Port: ${group.defaultPort}',
                      ].join(' | '),
                      style: AppTypography.caption,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.pencil, size: 18),
              tooltip: 'Edit',
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(LucideIcons.trash2,
                  size: 18, color: AppColors.accentRed),
              tooltip: 'Delete',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
