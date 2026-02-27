/// Chrome-style workspace tab bar for CloudShell.
///
/// Displays all open workspace tabs (pages + terminal sessions)
/// in a horizontal tab strip above the content area. Terminal tabs
/// show connection status indicators.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/terminal_tab_provider.dart';
import '../../providers/workspace_provider.dart';

/// Chrome-style tab bar showing all open workspace tabs.
class WorkspaceTabBar extends ConsumerWidget {
  const WorkspaceTabBar({
    super.key,
    required this.onTabSelected,
    required this.onTabClosed,
    required this.onNewConnection,
  });

  final ValueChanged<WorkspaceTab> onTabSelected;
  final ValueChanged<WorkspaceTab> onTabClosed;
  final VoidCallback onNewConnection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(workspaceProvider);
    final terminalTabs = ref.watch(terminalTabsProvider);

    return Container(
      height: 38,
      decoration: const BoxDecoration(
        color: AppColors.bgDeep,
        border: Border(
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          // Scrollable tabs area
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 4),
              itemCount: workspace.tabs.length,
              itemBuilder: (context, index) {
                final tab = workspace.tabs[index];
                final isActive = tab.id == workspace.activeTabId;

                // For terminal tabs, get connection status + broadcast membership
                bool? isConnected;
                bool isBroadcastMember = false;
                if (tab.type == WorkspaceTabType.terminal &&
                    tab.terminalTabId != null) {
                  final termTab = terminalTabs.tabs
                      .where((t) => t.id == tab.terminalTabId)
                      .firstOrNull;
                  isConnected = termTab?.isConnected ?? false;
                  final notifier = ref.read(terminalTabsProvider.notifier);
                  final group = notifier.broadcastGroup;
                  // In broadcast-all mode (group empty), all connected are members
                  isBroadcastMember = notifier.broadcastEnabled &&
                      (group.isEmpty || group.contains(tab.terminalTabId));
                }

                return _WorkspaceTabItem(
                  tab: tab,
                  isActive: isActive,
                  isConnected: isConnected,
                  isBroadcastMember: isBroadcastMember,
                  onTap: () => onTabSelected(tab),
                  onClose: tab.isClosable
                      ? () => onTabClosed(tab)
                      : null,
                );
              },
            ),
          ),

          // New connection button
          const _VerticalDivider(),
          _TabBarIconButton(
            icon: LucideIcons.plus,
            tooltip: 'New connection',
            onTap: onNewConnection,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

/// Individual tab item in the workspace tab bar.
class _WorkspaceTabItem extends StatefulWidget {
  const _WorkspaceTabItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
    this.isConnected,
    this.isBroadcastMember = false,
    this.onClose,
  });

  final WorkspaceTab tab;
  final bool isActive;
  final bool? isConnected; // null for page tabs, true/false for terminal tabs
  final bool isBroadcastMember;
  final VoidCallback onTap;
  final VoidCallback? onClose;

  @override
  State<_WorkspaceTabItem> createState() => _WorkspaceTabItemState();
}

class _WorkspaceTabItemState extends State<_WorkspaceTabItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant _WorkspaceTabItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isConnected != widget.isConnected) {
      _syncPulse();
    }
  }

  void _syncPulse() {
    if (widget.isConnected == true) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      _pulseController.stop();
      _pulseController.value = 0.0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showClose =
        widget.onClose != null && (widget.isActive || _isHovered);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          constraints: const BoxConstraints(maxWidth: 200, minWidth: 80),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.bgSurface
                : _isHovered
                    ? AppColors.bgRaised.withValues(alpha: 0.5)
                    : Colors.transparent,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            border: Border(
              bottom: BorderSide(
                color: widget.isActive
                    ? AppColors.accentPrimary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: AppColors.accentGlow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status dot for terminal tabs (pulses when connected)
              if (widget.isConnected != null) ...[
                widget.isConnected!
                    ? AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (_, _) => Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.statusOnline,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.successGlow,
                                blurRadius: 6 * _pulseAnimation.value,
                                spreadRadius: 1 * _pulseAnimation.value,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.statusOffline,
                        ),
                      ),
                const SizedBox(width: 6),
              ],

              // Broadcast indicator
              if (widget.isBroadcastMember) ...[
                Icon(
                  LucideIcons.radio,
                  size: 10,
                  color: AppColors.accentOrange,
                ),
                const SizedBox(width: 4),
              ],

              // Tab icon
              Icon(
                widget.tab.icon,
                size: 13,
                color: widget.isActive
                    ? AppColors.accentPrimary
                    : AppColors.textTertiary,
              ),
              const SizedBox(width: 6),

              // Tab label — Flexible allows text to shrink with
              // ellipsis so it never overlaps the close button.
              Flexible(
                child: Text(
                  widget.tab.label,
                  style: AppTypography.caption.copyWith(
                    fontSize: 12,
                    color: widget.isActive
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight:
                        widget.isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

              // Close button
              if (showClose)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: widget.onClose,
                      child: Icon(
                        LucideIcons.x,
                        size: 12,
                        color: widget.isActive
                            ? AppColors.textSecondary
                            : AppColors.textTertiary,
                      ),
                    ),
                  ),
                )
              else if (widget.onClose != null)
                const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thin vertical separator in the tab bar.
class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: AppColors.borderSubtle,
    );
  }
}

/// Compact icon button for the tab bar.
class _TabBarIconButton extends StatefulWidget {
  const _TabBarIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_TabBarIconButton> createState() => _TabBarIconButtonState();
}

class _TabBarIconButtonState extends State<_TabBarIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.bgRaised.withValues(alpha: 0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              widget.icon,
              size: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
