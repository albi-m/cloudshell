/// Hosts list screen — the default home screen of CloudShell.
///
/// Displays all saved SSH hosts organized by groups,
/// with search, filtering, and quick connect functionality.
/// Supports nested groups and drag-and-drop reorder on desktop.
library;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_names.dart';
import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/platform_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../data/database/app_database.dart';
import '../../providers/connection_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/host_provider.dart';
import '../../providers/terminal_tab_provider.dart';
import '../../providers/workspace_provider.dart';
import '../../services/connection/protocol_connector.dart';
import '../shared/confirmation_dialog.dart';
import '../shared/empty_state.dart';
import '../shared/error_display.dart';
import '../shared/loading_indicator.dart';
import '../settings/ssh_config_import_screen.dart';
import 'group_form_dialog.dart';
import 'quick_connect_dialog.dart';

/// Main hosts list screen showing all saved SSH connections.
///
/// Features:
/// - Search bar with filter
/// - Group headers with host counts (nested groups)
/// - Status indicators (online/offline dots)
/// - Favorite toggle per host
/// - Drag-and-drop reorder on desktop
/// - Quick connect, detail view, edit, delete actions
class HostsScreen extends ConsumerStatefulWidget {
  const HostsScreen({super.key});

  @override
  ConsumerState<HostsScreen> createState() => _HostsScreenState();
}

class _HostsScreenState extends ConsumerState<HostsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedTags = {};
  bool _selectionMode = false;
  final Set<String> _selectedHostIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _enterSelectionMode(Host host) {
    setState(() {
      _selectionMode = true;
      _selectedHostIds.add(host.id);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedHostIds.clear();
    });
  }

  void _toggleHostSelection(Host host) {
    setState(() {
      if (_selectedHostIds.contains(host.id)) {
        _selectedHostIds.remove(host.id);
        if (_selectedHostIds.isEmpty) _selectionMode = false;
      } else {
        _selectedHostIds.add(host.id);
      }
    });
  }

  void _selectAll(List<Host> hosts) {
    setState(() {
      _selectedHostIds.addAll(hosts.map((h) => h.id));
    });
  }

  Future<void> _bulkDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final count = _selectedHostIds.length;
    final confirmed = await showConfirmationDialog(
      context: context,
      title: l10n.hostsDeleteDialogTitle,
      message: l10n.hostsDeleteDialogMessage('$count host${count > 1 ? 's' : ''}'),
      confirmLabel: l10n.delete,
      isDestructive: true,
    );

    if (confirmed) {
      final db = ref.read(databaseProvider);
      for (final id in _selectedHostIds) {
        await db.hostDao.softDeleteHost(id);
      }
      _exitSelectionMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hostsAsync = ref.watch(allHostsProvider);
    final groupsAsync = ref.watch(allGroupsProvider);
    final connections = ref.watch(activeConnectionsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: _selectionMode
          ? AppBar(
              leading: IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: _exitSelectionMode,
              ),
              title: Text(
                '${_selectedHostIds.length} selected',
                style: AppTypography.h1,
              ),
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.checkSquare),
                  tooltip: l10n.hostsAllHostsHeader,
                  onPressed: () {
                    final hosts = ref.read(allHostsProvider).value ?? [];
                    _selectAll(hosts);
                  },
                ),
                IconButton(
                  icon: const Icon(LucideIcons.trash2,
                      color: AppColors.accentRed),
                  tooltip: l10n.delete,
                  onPressed: _selectedHostIds.isEmpty
                      ? null
                      : () => _bulkDelete(context, ref),
                ),
              ],
            )
          : AppBar(
              title: Text(l10n.hostsTitle, style: AppTypography.h1),
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.zap),
                  tooltip: l10n.quickConnectTitle,
                  onPressed: () => showQuickConnectDialog(context),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.plus),
                  tooltip: l10n.hostsAddTooltip,
                  onPressed: () => _openHostForm(context),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(LucideIcons.moreVertical),
                  onSelected: (value) {
                    switch (value) {
                      case 'manage_groups':
                        _openGroupManagement(context);
                      case 'import_ssh_config':
                        _importSshConfig(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'manage_groups',
                      child: Row(
                        children: [
                          const Icon(LucideIcons.folderPlus, size: 16),
                          const SizedBox(width: 8),
                          Text(l10n.hostsGroupsHeader),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'import_ssh_config',
                      child: Row(
                        children: [
                          Icon(LucideIcons.fileCode, size: 16),
                          SizedBox(width: 8),
                          Text('Import SSH Config'),
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
              title: l10n.hostsEmptyTitle,
              subtitle: l10n.hostsEmptySubtitle,
              actionLabel: l10n.hostsEmptyAction,
              onAction: () => _openHostForm(context),
            );
          }

          // Build group lookup maps
          final allGroups = <String, HostGroup>{};
          final groupNames = <String, String>{};
          groupsAsync.whenData((groups) {
            for (final g in groups) {
              allGroups[g.id] = g;
              groupNames[g.id] = g.name;
            }
          });

          // Collect all unique tags from hosts
          final allTags = <String>{};
          for (final h in hosts) {
            if (h.tags.isNotEmpty) {
              for (final tag in h.tags.split(',').map((t) => t.trim())) {
                if (tag.isNotEmpty) allTags.add(tag);
              }
            }
          }
          final sortedTags = allTags.toList()..sort();

          // Filter hosts by search query and selected tags
          var filteredHosts = hosts;
          if (_searchQuery.isNotEmpty) {
            final q = _searchQuery.toLowerCase();
            filteredHosts = filteredHosts.where((h) {
              return h.label.toLowerCase().contains(q) ||
                  h.hostname.toLowerCase().contains(q) ||
                  h.username.toLowerCase().contains(q) ||
                  h.tags.toLowerCase().contains(q);
            }).toList();
          }
          if (_selectedTags.isNotEmpty) {
            filteredHosts = filteredHosts.where((h) {
              final hostTags = h.tags
                  .split(',')
                  .map((t) => t.trim())
                  .where((t) => t.isNotEmpty)
                  .toSet();
              return _selectedTags.every(hostTags.contains);
            }).toList();
          }

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.hostsSearchHint,
                    prefixIcon: const Icon(LucideIcons.search, size: 18),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 16),
                            tooltip: l10n.clearSearch,
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

              // Tag filter chips
              if (sortedTags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                  child: SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: sortedTags.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final tag = sortedTags[index];
                        final isSelected = _selectedTags.contains(tag);
                        return FilterChip(
                          label: Text(
                            tag,
                            style: AppTypography.caption.copyWith(
                              fontSize: 11,
                              color: isSelected
                                  ? AppColors.textInverse
                                  : AppColors.accentPrimary,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                          selectedColor: AppColors.accentPrimary,
                          backgroundColor: AppColors.accentPrimary
                              .withValues(alpha: 0.1),
                          side: BorderSide(
                            color: AppColors.accentPrimary
                                .withValues(alpha: 0.2),
                          ),
                          showCheckmark: false,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        );
                      },
                    ),
                  ),
                ),

              // Host list grouped by group
              Expanded(
                child: filteredHosts.isEmpty
                    ? Center(
                        child: Text(
                          l10n.hostsNoMatchQuery(_searchQuery),
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildGroupedList(
                            filteredHosts,
                            allGroups,
                            groupNames,
                            connections,
                            l10n: l10n,
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
        loading: () => LoadingIndicator(message: l10n.hostsLoadingMessage),
        error: (error, _) => ErrorDisplay(
          error: error,
          onRetry: () => ref.invalidate(allHostsProvider),
        ),
      ),
    );
  }

  /// Builds the hierarchical list with favorites, nested groups, and ungrouped.
  List<Widget> _buildGroupedList(
    List<Host> hosts,
    Map<String, HostGroup> allGroups,
    Map<String, String> groupNames,
    Map<String, SshConnectionState> connections, {
    required AppLocalizations l10n,
  }) {
    final items = <Widget>[];

    // Group hosts by groupId
    final hostsByGroup = <String?, List<Host>>{};
    for (final host in hosts) {
      hostsByGroup.putIfAbsent(host.groupId, () => []).add(host);
    }

    // Favorites section
    final favorites = hosts.where((h) => h.isFavorite).toList();
    final favoriteIds = favorites.map((h) => h.id).toSet();

    if (favorites.isNotEmpty) {
      items.add(
        _GroupHeader(label: l10n.hostsFavoritesHeader, hostCount: favorites.length),
      );
      items.add(_ReorderableHostSection(
        hosts: favorites,
        connections: connections,
        selectionMode: _selectionMode,
        selectedHostIds: _selectedHostIds,
        onToggleSelection: _toggleHostSelection,
        onLongPress: _enterSelectionMode,
        onReorder: (oldIndex, newIndex) =>
            _onReorderHosts(favorites, oldIndex, newIndex),
        onTapHost: (host) => _openHostDetail(context, host),
        onConnectHost: (host) => _connectToHost(context, ref, host),
        onEditHost: (host) => _openHostForm(context, host: host),
        onDeleteHost: (host) => _deleteHost(context, ref, host),
        onToggleFavorite: (host) => _toggleFavorite(ref, host),
      ));
      items.add(const SizedBox(height: 8));
    }

    // Build group tree: find top-level groups
    final topLevelGroups = allGroups.values
        .where((g) => g.parentGroupId == null)
        .toList()
      ..sort((a, b) {
        final c = a.sortOrder.compareTo(b.sortOrder);
        return c != 0 ? c : a.name.compareTo(b.name);
      });

    // Render each top-level group and its children
    for (final group in topLevelGroups) {
      _buildGroupSection(
        items: items,
        group: group,
        allGroups: allGroups,
        hostsByGroup: hostsByGroup,
        favoriteIds: favoriteIds,
        connections: connections,
        depth: 0,
      );
    }

    // Ungrouped hosts
    final ungrouped = (hostsByGroup[null] ?? [])
        .where((h) => !favoriteIds.contains(h.id))
        .toList();
    if (ungrouped.isNotEmpty) {
      items.add(_GroupHeader(label: l10n.hostsUngroupedHeader, hostCount: ungrouped.length));
      items.add(_ReorderableHostSection(
        hosts: ungrouped,
        connections: connections,
        selectionMode: _selectionMode,
        selectedHostIds: _selectedHostIds,
        onToggleSelection: _toggleHostSelection,
        onLongPress: _enterSelectionMode,
        onReorder: (oldIndex, newIndex) =>
            _onReorderHosts(ungrouped, oldIndex, newIndex),
        onTapHost: (host) => _openHostDetail(context, host),
        onConnectHost: (host) => _connectToHost(context, ref, host),
        onEditHost: (host) => _openHostForm(context, host: host),
        onDeleteHost: (host) => _deleteHost(context, ref, host),
        onToggleFavorite: (host) => _toggleFavorite(ref, host),
      ));
      items.add(const SizedBox(height: 8));
    }

    // Groups with hosts where the groupId doesn't match any known group
    // (orphaned group references)
    for (final entry in hostsByGroup.entries) {
      if (entry.key == null) continue;
      if (allGroups.containsKey(entry.key)) continue;
      final orphaned = entry.value
          .where((h) => !favoriteIds.contains(h.id))
          .toList();
      if (orphaned.isEmpty) continue;
      items.add(_GroupHeader(
        label: groupNames[entry.key] ?? entry.key!,
        hostCount: orphaned.length,
      ));
      items.add(_ReorderableHostSection(
        hosts: orphaned,
        connections: connections,
        selectionMode: _selectionMode,
        selectedHostIds: _selectedHostIds,
        onToggleSelection: _toggleHostSelection,
        onLongPress: _enterSelectionMode,
        onReorder: (oldIndex, newIndex) =>
            _onReorderHosts(orphaned, oldIndex, newIndex),
        onTapHost: (host) => _openHostDetail(context, host),
        onConnectHost: (host) => _connectToHost(context, ref, host),
        onEditHost: (host) => _openHostForm(context, host: host),
        onDeleteHost: (host) => _deleteHost(context, ref, host),
        onToggleFavorite: (host) => _toggleFavorite(ref, host),
      ));
      items.add(const SizedBox(height: 8));
    }

    return items;
  }

  /// Recursively builds group sections with children.
  void _buildGroupSection({
    required List<Widget> items,
    required HostGroup group,
    required Map<String, HostGroup> allGroups,
    required Map<String?, List<Host>> hostsByGroup,
    required Set<String> favoriteIds,
    required Map<String, SshConnectionState> connections,
    required int depth,
  }) {
    final groupHosts = (hostsByGroup[group.id] ?? [])
        .where((h) => !favoriteIds.contains(h.id))
        .toList();

    // Find child groups
    final childGroups = allGroups.values
        .where((g) => g.parentGroupId == group.id)
        .toList()
      ..sort((a, b) {
        final c = a.sortOrder.compareTo(b.sortOrder);
        return c != 0 ? c : a.name.compareTo(b.name);
      });

    // Count all hosts including children
    int totalHosts = groupHosts.length;
    for (final child in childGroups) {
      totalHosts += (hostsByGroup[child.id] ?? [])
          .where((h) => !favoriteIds.contains(h.id))
          .length;
    }

    // Skip empty groups (no hosts and no children with hosts)
    if (totalHosts == 0 && childGroups.isEmpty) return;

    items.add(_GroupHeader(
      label: group.name,
      hostCount: totalHosts,
      depth: depth,
    ));

    if (groupHosts.isNotEmpty) {
      items.add(Padding(
        padding: EdgeInsets.only(left: depth * 16.0),
        child: _ReorderableHostSection(
          hosts: groupHosts,
          connections: connections,
          selectionMode: _selectionMode,
          selectedHostIds: _selectedHostIds,
          onToggleSelection: _toggleHostSelection,
          onLongPress: _enterSelectionMode,
          onReorder: (oldIndex, newIndex) =>
              _onReorderHosts(groupHosts, oldIndex, newIndex),
          onTapHost: (host) => _openHostDetail(context, host),
          onConnectHost: (host) => _connectToHost(context, ref, host),
          onEditHost: (host) => _openHostForm(context, host: host),
          onDeleteHost: (host) => _deleteHost(context, ref, host),
          onToggleFavorite: (host) => _toggleFavorite(ref, host),
        ),
      ));
    }

    // Render child groups recursively
    for (final child in childGroups) {
      _buildGroupSection(
        items: items,
        group: child,
        allGroups: allGroups,
        hostsByGroup: hostsByGroup,
        favoriteIds: favoriteIds,
        connections: connections,
        depth: depth + 1,
      );
    }

    if (depth == 0) {
      items.add(const SizedBox(height: 8));
    }
  }

  Future<void> _onReorderHosts(
      List<Host> hosts, int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex -= 1;
    if (oldIndex == newIndex) return;

    final reordered = List<Host>.from(hosts);
    final item = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, item);

    // Update sort orders in database
    final db = ref.read(databaseProvider);
    final updates = <(String, int)>[];
    for (var i = 0; i < reordered.length; i++) {
      updates.add((reordered[i].id, i));
    }
    await db.hostDao.updateSortOrders(updates);
  }

  void _openHostDetail(BuildContext context, Host host) {
    context.push('/hosts/${host.id}');
  }

  void _openHostForm(BuildContext context, {Host? host}) {
    context.push(RouteNames.hostForm, extra: host);
  }

  void _importSshConfig(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => const SshConfigImportScreen(),
      ),
    );
  }

  void _openGroupManagement(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => const _GroupManagementScreen(),
      ),
    );
  }

  Future<void> _connectToHost(
      BuildContext context, WidgetRef ref, Host host) async {
    final l10n = AppLocalizations.of(context);
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

      final db = ref.read(databaseProvider);
      await db.hostDao.updateLastConnected(host.id);

      await ref.read(terminalTabsProvider.notifier).addTab(
            session,
            host.label,
            startupCommand: host.startupCommand,
          );
      if (context.mounted) {
        ref.read(workspaceProvider.notifier).openTerminalTab(
              session.sessionId,
              host.label,
              replaceActiveTab: true,
            );
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
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
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmationDialog(
      context: context,
      title: l10n.hostsDeleteDialogTitle,
      message: l10n.hostsDeleteDialogMessage(host.label),
      confirmLabel: l10n.delete,
      isDestructive: true,
    );

    if (confirmed) {
      final db = ref.read(databaseProvider);
      await db.hostDao.softDeleteHost(host.id);
    }
  }
}

// ---------------------------------------------------------------------------
// Reorderable Host Section
// ---------------------------------------------------------------------------

/// A section of hosts that supports drag-and-drop reorder on desktop.
///
/// On mobile, renders as a simple column. On desktop, uses
/// ReorderableListView with drag handles.
class _ReorderableHostSection extends StatelessWidget {
  const _ReorderableHostSection({
    required this.hosts,
    required this.connections,
    required this.onReorder,
    required this.onTapHost,
    required this.onConnectHost,
    required this.onEditHost,
    required this.onDeleteHost,
    required this.onToggleFavorite,
    this.selectionMode = false,
    this.selectedHostIds = const {},
    this.onToggleSelection,
    this.onLongPress,
  });

  final List<Host> hosts;
  final Map<String, SshConnectionState> connections;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(Host host) onTapHost;
  final void Function(Host host) onConnectHost;
  final void Function(Host host) onEditHost;
  final void Function(Host host) onDeleteHost;
  final void Function(Host host) onToggleFavorite;
  final bool selectionMode;
  final Set<String> selectedHostIds;
  final void Function(Host host)? onToggleSelection;
  final void Function(Host host)? onLongPress;

  bool _isHostConnected(Host host) {
    return connections.values.any(
      (c) => c.hostId == host.id && c.status == ConnectionStatus.connected,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!PlatformUtils.isDesktop) {
      // Mobile: simple column, no drag-and-drop
      return Column(
        children: hosts.map((host) {
          return _HostListItem(
            key: ValueKey(host.id),
            host: host,
            isConnected: _isHostConnected(host),
            selectionMode: selectionMode,
            isSelected: selectedHostIds.contains(host.id),
            onTap: selectionMode
                ? () => onToggleSelection?.call(host)
                : () => onTapHost(host),
            onConnect: () => onConnectHost(host),
            onEdit: () => onEditHost(host),
            onDelete: () => onDeleteHost(host),
            onToggleFavorite: () => onToggleFavorite(host),
            onLongPress: () => onLongPress?.call(host),
          );
        }).toList(),
      );
    }

    // Desktop: ReorderableListView with drag handles
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: hosts.length,
      onReorder: onReorder,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: child,
          ),
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final host = hosts[index];
        return _HostListItem(
          key: ValueKey(host.id),
          host: host,
          isConnected: _isHostConnected(host),
          selectionMode: selectionMode,
          isSelected: selectedHostIds.contains(host.id),
          dragHandle: selectionMode
              ? null
              : ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      LucideIcons.gripVertical,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
          onTap: selectionMode
              ? () => onToggleSelection?.call(host)
              : () => onTapHost(host),
          onConnect: () => onConnectHost(host),
          onEdit: () => onEditHost(host),
          onDelete: () => onDeleteHost(host),
          onToggleFavorite: () => onToggleFavorite(host),
          onLongPress: () => onLongPress?.call(host),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Group Header
// ---------------------------------------------------------------------------

/// Group header showing group name, host count, and nesting depth.
class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.label,
    required this.hostCount,
    this.depth = 0,
  });

  final String label;
  final int hostCount;
  final int depth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4 + depth * 16.0, 12, 4, 6),
      child: Row(
        children: [
          if (depth > 0)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: const Icon(
                LucideIcons.cornerDownRight,
                size: 14,
                color: AppColors.textTertiary,
              ),
            ),
          Expanded(
            child: Text(
              '$label ($hostCount ${hostCount == 1 ? 'host' : 'hosts'})'
                  .toUpperCase(),
              style: AppTypography.overline.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1.2,
                fontSize: depth > 0 ? 10 : 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Host List Item
// ---------------------------------------------------------------------------

/// Individual host list item with connection status, favorite toggle,
/// optional drag handle, and actions.
class _HostListItem extends StatefulWidget {
  const _HostListItem({
    super.key,
    required this.host,
    required this.isConnected,
    required this.onTap,
    required this.onConnect,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFavorite,
    this.dragHandle,
    this.selectionMode = false,
    this.isSelected = false,
    this.onLongPress,
  });

  final Host host;
  final bool isConnected;
  final VoidCallback onTap;
  final VoidCallback onConnect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;
  final Widget? dragHandle;
  final bool selectionMode;
  final bool isSelected;
  final VoidCallback? onLongPress;

  @override
  State<_HostListItem> createState() => _HostListItemState();
}

class _HostListItemState extends State<_HostListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isHovered ? -1 : 0, 0),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? AppColors.accentPrimary.withValues(alpha: 0.08)
              : _isHovered
                  ? AppColors.bgRaised
                  : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.isSelected
                ? AppColors.accentPrimary.withValues(alpha: 0.5)
                : _isHovered
                    ? AppColors.accentPrimary.withValues(alpha: 0.3)
                    : AppColors.borderSubtle,
          ),
          boxShadow: _isHovered
              ? const [
                  BoxShadow(
                    color: AppColors.accentGlow,
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: InkWell(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Selection checkbox
                if (widget.selectionMode) ...[
                  Checkbox(
                    value: widget.isSelected,
                    onChanged: (_) => widget.onTap(),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(width: 4),
                ],

                // Drag handle (desktop only, hidden in selection mode)
                if (widget.dragHandle != null && !widget.selectionMode) ...[
                  widget.dragHandle!,
                  const SizedBox(width: 4),
                ],

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
                          color: widget.isConnected
                              ? AppColors.statusOnline
                              : AppColors.statusIdle,
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

                // Host info — compact 2-line layout
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.host.label,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        [
                          '${widget.host.username}@${widget.host.hostname}:${widget.host.port}',
                          if (widget.host.lastConnectedAt != null)
                            Formatters.relativeTime(
                                widget.host.lastConnectedAt!),
                        ].join(' \u00B7 '),
                        style: AppTypography.code(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.host.tags.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: widget.host.tags
                              .split(',')
                              .map((t) => t.trim())
                              .where((t) => t.isNotEmpty)
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentPrimary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppColors.accentPrimary
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: AppTypography.caption.copyWith(
                                      fontSize: 10,
                                      color: AppColors.accentPrimary,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),

                // Direct connect button
                IconButton(
                  icon: Icon(
                    widget.isConnected
                        ? LucideIcons.terminal
                        : LucideIcons.play,
                    size: 18,
                    color: widget.isConnected
                        ? AppColors.statusOnline
                        : AppColors.accentPrimary,
                  ),
                  tooltip: widget.isConnected ? l10n.hostsMenuConnect : l10n.hostDetailConnect,
                  onPressed: widget.onConnect,
                ),

                // Favorite toggle
                IconButton(
                  icon: Icon(
                    LucideIcons.star,
                    size: 18,
                    color: widget.host.isFavorite
                        ? AppColors.accentOrange
                        : AppColors.textTertiary,
                  ),
                  tooltip: l10n.hostDetailFavoriteTooltip,
                  onPressed: widget.onToggleFavorite,
                ),

                // Edit/Delete menu
                PopupMenuButton<String>(
                  icon: const Icon(
                    LucideIcons.moreVertical,
                    size: 18,
                    color: AppColors.textTertiary,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        widget.onEdit();
                      case 'delete':
                        widget.onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(LucideIcons.pencil, size: 16),
                          const SizedBox(width: 8),
                          Text(l10n.hostsMenuEdit),
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
                          Text(l10n.hostsMenuDelete),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Group Management Screen
// ---------------------------------------------------------------------------

/// Group management screen showing group hierarchy with nesting.
class _GroupManagementScreen extends ConsumerWidget {
  const _GroupManagementScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final groupsAsync = ref.watch(allGroupsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text(l10n.hostsGroupsHeader, style: AppTypography.h1),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.folderPlus),
            tooltip: l10n.groupFormTitleNew,
            onPressed: () => showGroupFormDialog(context),
          ),
        ],
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return EmptyState(
              icon: LucideIcons.folder,
              title: l10n.groupFormTitleNew,
              subtitle: l10n.hostsEmptySubtitle,
              actionLabel: l10n.groupFormTitleNew,
              onAction: () => showGroupFormDialog(context),
            );
          }

          // Build group hierarchy
          final groupMap = {for (final g in groups) g.id: g};
          final topLevel =
              groups.where((g) => g.parentGroupId == null).toList()
                ..sort((a, b) {
                  final c = a.sortOrder.compareTo(b.sortOrder);
                  return c != 0 ? c : a.name.compareTo(b.name);
                });

          final items = <(HostGroup, int)>[];
          void addGroupAndChildren(HostGroup group, int depth) {
            items.add((group, depth));
            final children = groups
                .where((g) => g.parentGroupId == group.id)
                .toList()
              ..sort((a, b) {
                final c = a.sortOrder.compareTo(b.sortOrder);
                return c != 0 ? c : a.name.compareTo(b.name);
              });
            for (final child in children) {
              addGroupAndChildren(child, depth + 1);
            }
          }

          for (final g in topLevel) {
            addGroupAndChildren(g, 0);
          }

          // Add orphaned groups (parent deleted)
          final rendered = items.map((e) => e.$1.id).toSet();
          for (final g in groups) {
            if (!rendered.contains(g.id)) {
              items.add((g, 0));
            }
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final (group, depth) = items[index];
              return _GroupListItem(
                group: group,
                depth: depth,
                parentName: group.parentGroupId != null
                    ? groupMap[group.parentGroupId]?.name
                    : null,
                onEdit: () => showGroupFormDialog(context, group: group),
                onDelete: () => _deleteGroup(context, ref, group),
              );
            },
          );
        },
        loading: () => LoadingIndicator(message: l10n.loading),
        error: (error, _) => ErrorDisplay(
          error: error,
          onRetry: () => ref.invalidate(allGroupsProvider),
        ),
      ),
    );
  }

  Future<void> _deleteGroup(
      BuildContext context, WidgetRef ref, HostGroup group) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmationDialog(
      context: context,
      title: l10n.groupFormDeleteDialogTitle,
      message: l10n.groupFormDeleteDialogMessage(group.name),
      confirmLabel: l10n.delete,
      isDestructive: true,
    );

    if (confirmed) {
      final db = ref.read(databaseProvider);
      await db.groupDao.softDeleteGroup(group.id);
    }
  }
}

/// Individual group list item for the management screen with hierarchy support.
class _GroupListItem extends StatelessWidget {
  const _GroupListItem({
    required this.group,
    required this.onEdit,
    required this.onDelete,
    this.depth = 0,
    this.parentName,
  });

  final HostGroup group;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int depth;
  final String? parentName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(left: depth * 16.0),
      child: Card(
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
                child: Icon(
                  depth > 0 ? LucideIcons.folderOpen : LucideIcons.folder,
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
                    if (parentName != null || group.defaultUsername != null ||
                        group.defaultPort != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        [
                          if (parentName != null) '${l10n.groupFormParentField}: $parentName',
                          if (group.defaultUsername != null)
                            '${l10n.hostDetailLabelUsername}: ${group.defaultUsername}',
                          if (group.defaultPort != null)
                            '${l10n.hostDetailLabelPort}: ${group.defaultPort}',
                        ].join(' | '),
                        style: AppTypography.caption,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.pencil, size: 18),
                tooltip: l10n.edit,
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2,
                    size: 18, color: AppColors.accentRed),
                tooltip: l10n.delete,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
