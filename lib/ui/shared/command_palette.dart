/// Global command palette overlay (Cmd+K / Ctrl+K).
///
/// Provides fuzzy search across hosts, snippets, and app actions.
/// Supports keyboard navigation (arrows, Enter, Escape).
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/clipboard_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../data/database/app_database.dart';
import '../../providers/host_provider.dart';
import '../../providers/snippet_provider.dart';
import '../../providers/terminal_tab_provider.dart';
import '../settings/workspace_manager_screen.dart';

/// Shows the command palette overlay.
void showCommandPalette(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black38,
    builder: (_) => const _CommandPaletteDialog(),
  );
}

/// Entry in the command palette.
class _PaletteEntry {
  const _PaletteEntry({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.category,
    required this.onSelect,
    this.shortcut,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final String category;
  final VoidCallback onSelect;
  final String? shortcut;
}

class _CommandPaletteDialog extends ConsumerStatefulWidget {
  const _CommandPaletteDialog();

  @override
  ConsumerState<_CommandPaletteDialog> createState() =>
      _CommandPaletteDialogState();
}

class _CommandPaletteDialogState
    extends ConsumerState<_CommandPaletteDialog> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<_PaletteEntry> _buildEntries(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = <_PaletteEntry>[];
    final hostsAsync = ref.read(allHostsProvider);
    final snippetsAsync = ref.read(allSnippetsProvider);

    // RECENT — recently connected hosts
    final hosts = hostsAsync.value ?? <Host>[];
    final recentHosts = hosts
        .where((h) => h.lastConnectedAt != null)
        .toList()
      ..sort(
          (a, b) => b.lastConnectedAt!.compareTo(a.lastConnectedAt!));

    for (final host in recentHosts.take(5)) {
      entries.add(_PaletteEntry(
        title: host.label,
        subtitle: '${host.username}@${host.hostname}:${host.port}',
        icon: LucideIcons.server,
        category: 'RECENT',
        onSelect: () {
          Navigator.of(context).pop();
          context.push(RouteNames.hostDetail(host.id));
        },
      ));
    }

    // HOSTS — all hosts
    for (final host in hosts) {
      // Skip if already in recents
      if (recentHosts.take(5).any((h) => h.id == host.id)) continue;
      entries.add(_PaletteEntry(
        title: host.label,
        subtitle: '${host.username}@${host.hostname}:${host.port}',
        icon: LucideIcons.server,
        category: l10n.commandPaletteHostsHeader,
        onSelect: () {
          Navigator.of(context).pop();
          context.push(RouteNames.hostDetail(host.id));
        },
      ));
    }

    // SNIPPETS
    final snippets = snippetsAsync.value ?? <Snippet>[];
    for (final snippet in snippets) {
      entries.add(_PaletteEntry(
        title: snippet.name,
        subtitle: snippet.command,
        icon: LucideIcons.code2,
        category: l10n.commandPaletteSnippetsHeader,
        onSelect: () {
          Navigator.of(context).pop();
          copyWithAutoClear(snippet.command);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Command copied (auto-clears in 30s)')),
          );
        },
      ));
    }

    // ACTIONS
    entries.addAll([
      _PaletteEntry(
        title: l10n.commandPaletteActionNewHost,
        icon: LucideIcons.plus,
        category: l10n.commandPaletteActionsHeader,
        shortcut: 'Cmd+N',
        onSelect: () {
          Navigator.of(context).pop();
          context.push(RouteNames.hostForm);
        },
      ),
      _PaletteEntry(
        title: 'New Snippet',
        icon: LucideIcons.plus,
        category: l10n.commandPaletteActionsHeader,
        onSelect: () {
          Navigator.of(context).pop();
          context.push(RouteNames.snippetForm);
        },
      ),
      _PaletteEntry(
        title: l10n.adaptiveScaffoldPortForwarding,
        icon: LucideIcons.arrowLeftRight,
        category: l10n.commandPaletteActionsHeader,
        onSelect: () {
          Navigator.of(context).pop();
          context.go(RouteNames.portForwarding);
        },
      ),
      _PaletteEntry(
        title: l10n.commandPaletteActionSettings,
        icon: LucideIcons.settings,
        category: l10n.commandPaletteActionsHeader,
        shortcut: 'Cmd+,',
        onSelect: () {
          Navigator.of(context).pop();
          context.go(RouteNames.settings);
        },
      ),
      _PaletteEntry(
        title: 'Workspaces',
        subtitle: 'Save and restore tab layouts',
        icon: LucideIcons.layout,
        category: l10n.commandPaletteActionsHeader,
        onSelect: () {
          Navigator.of(context).pop();
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => const WorkspaceManagerScreen()),
          );
        },
      ),
    ]);

    // Split pane actions — only shown when a terminal tab is active
    final tabsState = ref.read(terminalTabsProvider);
    final activeTab = tabsState.activeTab;
    if (activeTab != null && activeTab.isConnected) {
      if (!activeTab.isSplit) {
        entries.addAll([
          _PaletteEntry(
            title: 'Split Horizontal',
            icon: LucideIcons.columns,
            category: 'TERMINAL',
            shortcut: 'Cmd+D',
            onSelect: () {
              Navigator.of(context).pop();
              ref.read(terminalTabsProvider.notifier).splitPane(
                    activeTab.id,
                    SplitDirection.horizontal,
                  );
            },
          ),
          _PaletteEntry(
            title: 'Split Vertical',
            icon: LucideIcons.rows,
            category: 'TERMINAL',
            shortcut: 'Cmd+Shift+D',
            onSelect: () {
              Navigator.of(context).pop();
              ref.read(terminalTabsProvider.notifier).splitPane(
                    activeTab.id,
                    SplitDirection.vertical,
                  );
            },
          ),
        ]);
      } else {
        entries.add(
          _PaletteEntry(
            title: 'Close Split',
            icon: LucideIcons.x,
            category: 'TERMINAL',
            onSelect: () {
              Navigator.of(context).pop();
              ref
                  .read(terminalTabsProvider.notifier)
                  .closeSplitPane(activeTab.id);
            },
          ),
        );
      }
    }

    return entries;
  }

  List<_PaletteEntry> _filteredEntries(List<_PaletteEntry> all) {
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all.where((e) {
      return e.title.toLowerCase().contains(q) ||
          (e.subtitle?.toLowerCase().contains(q) ?? false) ||
          e.category.toLowerCase().contains(q);
    }).toList();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final entries = _filteredEntries(_buildEntries(context));
    if (entries.isEmpty) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1).clamp(0, entries.length - 1);
      });
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _selectedIndex = (_selectedIndex - 1).clamp(0, entries.length - 1);
      });
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (_selectedIndex < entries.length) {
        entries[_selectedIndex].onSelect();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allEntries = _buildEntries(context);
    final filtered = _filteredEntries(allEntries);

    // Clamp selection
    if (_selectedIndex >= filtered.length) {
      _selectedIndex = filtered.isEmpty ? 0 : filtered.length - 1;
    }

    // Group entries by category
    final grouped = <String, List<int>>{};
    for (var i = 0; i < filtered.length; i++) {
      grouped.putIfAbsent(filtered[i].category, () => []).add(i);
    }

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _handleKeyEvent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Dialog(
          backgroundColor: AppColors.bgSurface.withValues(alpha: 0.85),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search input
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: l10n.commandPaletteHint,
                    prefixIcon: const Icon(LucideIcons.search, size: 18),
                    suffixText: 'Cmd+K',
                    suffixStyle: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onChanged: (v) => setState(() {
                    _query = v;
                    _selectedIndex = 0;
                  }),
                ),
              ),
              const Divider(height: 1),

              // Results
              Flexible(
                child: filtered.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          l10n.commandPaletteNoMatchQuery(_query),
                          style: AppTypography.body
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          for (final category in grouped.keys) ...[
                            // Category header
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 8, 16, 4),
                              child: Text(
                                category,
                                style: AppTypography.overline.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            // Items
                            for (final i in grouped[category]!)
                              _PaletteItem(
                                entry: filtered[i],
                                isSelected: i == _selectedIndex,
                                onTap: filtered[i].onSelect,
                              ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

/// Single palette result item.
class _PaletteItem extends StatefulWidget {
  const _PaletteItem({
    required this.entry,
    required this.isSelected,
    required this.onTap,
  });

  final _PaletteEntry entry;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_PaletteItem> createState() => _PaletteItemState();
}

class _PaletteItemState extends State<_PaletteItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = widget.isSelected || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: highlighted
              ? AppColors.accentPrimary.withValues(alpha: 0.1)
              : Colors.transparent,
          child: Row(
            children: [
              Icon(
                widget.entry.icon,
                size: 16,
                color: highlighted
                    ? AppColors.accentPrimary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.entry.title,
                      style: AppTypography.body.copyWith(
                        fontWeight:
                            highlighted ? FontWeight.w600 : FontWeight.w400,
                        color: highlighted
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.entry.subtitle != null)
                      Text(
                        widget.entry.subtitle!,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              if (widget.entry.shortcut != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.bgRaised,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.entry.shortcut!,
                    style: AppTypography.caption.copyWith(
                      fontSize: 10,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
