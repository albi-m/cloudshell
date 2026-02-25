/// Adaptive scaffold that switches between sidebar (desktop)
/// and bottom navigation bar (mobile) layouts.
///
/// This is the primary layout wrapper for all main screens,
/// providing consistent navigation across platforms.
/// Matches wireframe Master Layout Structure.
///
/// Desktop sidebar can be collapsed to icon-only mode (60px)
/// via the collapse/expand toggle at the bottom.
///
/// Includes a Chrome-style workspace tab bar showing all open
/// pages and terminal sessions.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../data/database/app_database.dart';
import '../../providers/connection_provider.dart';
import '../../providers/host_provider.dart';
import '../../providers/sidebar_provider.dart';
import '../../providers/terminal_tab_provider.dart';
import '../../providers/workspace_provider.dart';
import '../hosts/quick_connect_dialog.dart';
import '../sftp/sftp_screen.dart';
import '../terminal/terminal_screen.dart';
import 'command_palette.dart';
import 'shortcut_reference.dart';
import 'workspace_tab_bar.dart';

/// Navigation destination definition.
class _NavDestination {
  const _NavDestination({
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.workspaceType,
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final WorkspaceTabType workspaceType;
}

/// Returns the localized label for a navigation destination.
String _localizedLabel(String label, AppLocalizations l10n) {
  return switch (label) {
    'Hosts' => l10n.adaptiveScaffoldHosts,
    'Keys' => l10n.adaptiveScaffoldKeys,
    'Snippets' => l10n.adaptiveScaffoldSnippets,
    'Settings' => l10n.adaptiveScaffoldSettings,
    'SFTP' => l10n.adaptiveScaffoldSftp,
    'Port Forwarding' => l10n.adaptiveScaffoldPortForwarding,
    'Terminal' => l10n.adaptiveScaffoldTerminal,
    _ => label,
  };
}

/// Desktop sidebar navigation destinations (per wireframe).
const _sidebarDestinations = [
  _NavDestination(
    path: RouteNames.hosts,
    label: 'Hosts',
    icon: LucideIcons.server,
    selectedIcon: LucideIcons.server,
    workspaceType: WorkspaceTabType.hosts,
  ),
  _NavDestination(
    path: RouteNames.keys,
    label: 'Keys',
    icon: LucideIcons.keyRound,
    selectedIcon: LucideIcons.keyRound,
    workspaceType: WorkspaceTabType.keys,
  ),
  _NavDestination(
    path: RouteNames.snippets,
    label: 'Snippets',
    icon: LucideIcons.code2,
    selectedIcon: LucideIcons.code2,
    workspaceType: WorkspaceTabType.snippets,
  ),
  _NavDestination(
    path: RouteNames.settings,
    label: 'Settings',
    icon: LucideIcons.settings,
    selectedIcon: LucideIcons.settings,
    workspaceType: WorkspaceTabType.settings,
  ),
];

/// Mobile bottom nav destinations.
const _mobileDestinations = [
  _NavDestination(
    path: RouteNames.hosts,
    label: 'Hosts',
    icon: LucideIcons.server,
    selectedIcon: LucideIcons.server,
    workspaceType: WorkspaceTabType.hosts,
  ),
  _NavDestination(
    path: RouteNames.keys,
    label: 'Keys',
    icon: LucideIcons.keyRound,
    selectedIcon: LucideIcons.keyRound,
    workspaceType: WorkspaceTabType.keys,
  ),
  _NavDestination(
    path: RouteNames.snippets,
    label: 'Snippets',
    icon: LucideIcons.code2,
    selectedIcon: LucideIcons.code2,
    workspaceType: WorkspaceTabType.snippets,
  ),
  _NavDestination(
    path: RouteNames.settings,
    label: 'Settings',
    icon: LucideIcons.settings,
    selectedIcon: LucideIcons.settings,
    workspaceType: WorkspaceTabType.settings,
  ),
];

/// Responsive scaffold that adapts between desktop sidebar
/// and mobile bottom navigation bar layouts.
class AdaptiveScaffold extends ConsumerWidget {
  const AdaptiveScaffold({super.key, required this.child});

  /// The current route's page content (from GoRouter ShellRoute).
  final Widget child;

  /// Returns the index of the currently active navigation destination.
  int _currentIndex(BuildContext context, List<_NavDestination> destinations) {
    final location = GoRouterState.of(context).uri.path;
    for (var i = 0; i < destinations.length; i++) {
      if (location.startsWith(destinations[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;

    Widget layout;
    if (width >= AppConstants.compactSidebarBreakpoint) {
      // Full desktop: sidebar expanded/collapsed per user preference
      layout = _DesktopLayout(
        selectedIndex: _currentIndex(context, _sidebarDestinations),
        routerChild: child,
      );
    } else if (width >= AppConstants.phoneBreakpoint) {
      // Compact desktop (iPad Split View, narrow window):
      // sidebar forced to icon-only collapsed mode
      layout = _DesktopLayout(
        selectedIndex: _currentIndex(context, _sidebarDestinations),
        routerChild: child,
        forceCollapsed: true,
      );
    } else {
      // Phone / iPad Slide Over narrow mode: bottom navigation bar
      layout = _MobileLayout(
        selectedIndex: _currentIndex(context, _mobileDestinations),
        routerChild: child,
      );
    }

    // Global keyboard shortcuts
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true):
            () => showCommandPalette(context),
        const SingleActivator(LogicalKeyboardKey.keyK, control: true):
            () => showCommandPalette(context),
        const SingleActivator(LogicalKeyboardKey.keyN, meta: true):
            () => context.push(RouteNames.hostForm),
        const SingleActivator(LogicalKeyboardKey.keyN, control: true):
            () => context.push(RouteNames.hostForm),
        const SingleActivator(LogicalKeyboardKey.keyN, meta: true,
                shift: true):
            () => _quickConnect(context, ref),
        const SingleActivator(LogicalKeyboardKey.keyN, control: true,
                shift: true):
            () => _quickConnect(context, ref),
        const SingleActivator(LogicalKeyboardKey.comma, meta: true): () {
          ref.read(workspaceProvider.notifier).ensureTab(WorkspaceTabType.settings);
          context.go(RouteNames.settings);
        },
        const SingleActivator(LogicalKeyboardKey.comma, control: true): () {
          ref.read(workspaceProvider.notifier).ensureTab(WorkspaceTabType.settings);
          context.go(RouteNames.settings);
        },
        const SingleActivator(LogicalKeyboardKey.slash, meta: true):
            () => showShortcutReference(context),
        const SingleActivator(LogicalKeyboardKey.slash, control: true):
            () => showShortcutReference(context),
      },
      child: Focus(
        autofocus: true,
        child: layout,
      ),
    );
  }

  Future<void> _quickConnect(BuildContext context, WidgetRef ref) async {
    final connected = await showQuickConnectDialog(context);
    if (connected && context.mounted) {
      final tabs = ref.read(terminalTabsProvider);
      if (tabs.activeTab != null) {
        ref.read(workspaceProvider.notifier).openTerminalTab(
              tabs.activeTab!.id,
              tabs.activeTab!.hostLabel,
            );
      }
    }
  }
}

/// Desktop layout with collapsible sidebar, workspace tab bar, and content.
class _DesktopLayout extends ConsumerStatefulWidget {
  const _DesktopLayout({
    required this.selectedIndex,
    required this.routerChild,
    this.forceCollapsed = false,
  });

  final int selectedIndex;
  final Widget routerChild;

  /// When true, the sidebar is forced to icon-only mode regardless of user
  /// preference. Used for compact desktop / iPad Split View layouts.
  final bool forceCollapsed;

  @override
  ConsumerState<_DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends ConsumerState<_DesktopLayout> {
  @override
  Widget build(BuildContext context) {
    // Sync GoRouter when workspace active tab changes to a page tab
    ref.listen(workspaceProvider, (prev, next) {
      final activeTab = next.activeTab;
      if (activeTab != null &&
          activeTab.type != WorkspaceTabType.terminal &&
          activeTab.routePath != null) {
        final currentPath = GoRouterState.of(context).uri.path;
        if (currentPath != activeTab.routePath) {
          context.go(activeTab.routePath!);
        }
      }
    });

    final userCollapsed = ref.watch(sidebarCollapsedProvider);
    final isCollapsed = widget.forceCollapsed || userCollapsed;
    final sidebarWidth = isCollapsed
        ? AppConstants.sidebarCollapsedWidth
        : AppConstants.sidebarWidth;
    final workspace = ref.watch(workspaceProvider);
    final activeTab = workspace.activeTab;
    final isTerminalActive = activeTab?.type == WorkspaceTabType.terminal;
    final isSftpActive = activeTab?.type == WorkspaceTabType.sftp;

    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: AppConstants.animationDuration,
            width: sidebarWidth,
            curve: Curves.easeInOut,
            child: ClipRect(
              child: _Sidebar(
                selectedIndex: widget.selectedIndex,
                isCollapsed: isCollapsed,
              ),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Column(
              children: [
                WorkspaceTabBar(
                  onTabSelected: (tab) =>
                      _handleTabSelected(context, ref, tab),
                  onTabClosed: (tab) =>
                      _handleTabClosed(context, ref, tab),
                  onNewConnection: () => _handleNewConnection(context, ref),
                ),
                Expanded(
                  child: isTerminalActive
                      ? const TerminalScreen()
                      : isSftpActive
                          ? const SftpScreen()
                          : widget.routerChild,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile layout with workspace tab bar, content, and bottom navigation.
class _MobileLayout extends ConsumerStatefulWidget {
  const _MobileLayout({
    required this.selectedIndex,
    required this.routerChild,
  });

  final int selectedIndex;
  final Widget routerChild;

  @override
  ConsumerState<_MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<_MobileLayout> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Sync GoRouter when workspace active tab changes to a page tab
    ref.listen(workspaceProvider, (prev, next) {
      final activeTab = next.activeTab;
      if (activeTab != null &&
          activeTab.type != WorkspaceTabType.terminal &&
          activeTab.routePath != null) {
        final currentPath = GoRouterState.of(context).uri.path;
        if (currentPath != activeTab.routePath) {
          context.go(activeTab.routePath!);
        }
      }
    });

    final workspace = ref.watch(workspaceProvider);
    final activeTab = workspace.activeTab;
    final isTerminalActive = activeTab?.type == WorkspaceTabType.terminal;
    final isSftpActive = activeTab?.type == WorkspaceTabType.sftp;

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: WorkspaceTabBar(
              onTabSelected: (tab) =>
                  _handleTabSelected(context, ref, tab),
              onTabClosed: (tab) =>
                  _handleTabClosed(context, ref, tab),
              onNewConnection: () => _handleNewConnection(context, ref),
            ),
          ),
          Expanded(
            child: isTerminalActive
                ? const TerminalScreen()
                : isSftpActive
                    ? const SftpScreen()
                    : widget.routerChild,
          ),
        ],
      ),
      bottomNavigationBar: (isTerminalActive || isSftpActive)
          ? null
          : Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.borderSubtle),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: widget.selectedIndex,
                onTap: (index) {
                  final dest = _mobileDestinations[index];
                  ref.read(workspaceProvider.notifier).ensureTab(dest.workspaceType);
                  context.go(dest.path);
                },
                items: _mobileDestinations
                    .map(
                      (dest) => BottomNavigationBarItem(
                        icon: Icon(dest.icon),
                        activeIcon: Icon(dest.selectedIcon),
                        label: _localizedLabel(dest.label, l10n),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}

void _handleTabSelected(
    BuildContext context, WidgetRef ref, WorkspaceTab tab) {
  ref.read(workspaceProvider.notifier).switchToTab(tab.id);
  if (tab.type == WorkspaceTabType.terminal) {
    if (tab.terminalTabId != null) {
      ref.read(terminalTabsProvider.notifier).switchToTab(tab.terminalTabId!);
    }
  } else if (tab.routePath != null) {
    context.go(tab.routePath!);
  }
}

void _handleTabClosed(
    BuildContext context, WidgetRef ref, WorkspaceTab tab) {
  if (tab.type == WorkspaceTabType.terminal && tab.terminalTabId != null) {
    ref.read(terminalTabsProvider.notifier).closeTab(tab.terminalTabId!);
    ref.read(activeConnectionsProvider.notifier).removeConnection(
          tab.terminalTabId!,
        );
  }

  final nextTab = ref.read(workspaceProvider.notifier).closeTab(tab.id);
  if (nextTab != null) {
    if (nextTab.type == WorkspaceTabType.terminal) {
      if (nextTab.terminalTabId != null) {
        ref.read(terminalTabsProvider.notifier).switchToTab(nextTab.terminalTabId!);
      }
    } else if (nextTab.routePath != null) {
      context.go(nextTab.routePath!);
    }
  }
}

void _handleNewConnection(BuildContext context, WidgetRef ref) {
  ref.read(workspaceProvider.notifier).ensureTab(WorkspaceTabType.hosts);
  context.go(RouteNames.hosts);
}

/// Opens the SFTP file transfer screen as a workspace tab.
void _openSftp(BuildContext context, WidgetRef ref) {
  ref.read(workspaceProvider.notifier).openSftpTab();
}

/// Desktop sidebar navigation panel.
class _Sidebar extends ConsumerWidget {
  const _Sidebar({
    required this.selectedIndex,
    required this.isCollapsed,
  });

  final int selectedIndex;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hostsAsync = ref.watch(allHostsProvider);
    final recentHosts = hostsAsync.whenOrNull(
          data: (hosts) {
            final withConnection = hosts
                .where((h) => h.lastConnectedAt != null)
                .toList()
              ..sort((a, b) =>
                  b.lastConnectedAt!.compareTo(a.lastConnectedAt!));
            return withConnection.take(5).toList();
          },
        ) ??
        <Host>[];

    if (isCollapsed) {
      return _buildCollapsedSidebar(context, ref, l10n);
    }
    return _buildExpandedSidebar(context, ref, recentHosts, l10n);
  }

  Widget _buildCollapsedSidebar(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final workspace = ref.watch(workspaceProvider);

    return Stack(
      children: [
        Container(
      color: AppColors.bgDeep,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientBrandFor(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.terminal,
                  color: AppColors.textInverse,
                  size: 18,
                ),
              ),
            ),
          ),
          Tooltip(
            message: l10n.commandPaletteActionQuickConnect,
            child: _SidebarIconItem(
              icon: LucideIcons.zap,
              tooltip: l10n.commandPaletteActionQuickConnect,
              isSelected: false,
              onTap: () async {
                final connected = await showQuickConnectDialog(context);
                if (connected && context.mounted) {
                  final tabs = ref.read(terminalTabsProvider);
                  if (tabs.activeTab != null) {
                    ref.read(workspaceProvider.notifier).openTerminalTab(
                          tabs.activeTab!.id,
                          tabs.activeTab!.hostLabel,
                        );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, indent: 8, endIndent: 8),
          const SizedBox(height: 4),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                for (var i = 0; i < _sidebarDestinations.length - 1; i++)
                  _SidebarIconItem(
                    icon: _sidebarDestinations[i].icon,
                    tooltip: _localizedLabel(_sidebarDestinations[i].label, l10n),
                    isSelected: i == selectedIndex &&
                        workspace.activeTab?.type != WorkspaceTabType.terminal,
                    onTap: () {
                      ref.read(workspaceProvider.notifier).ensureTab(
                            _sidebarDestinations[i].workspaceType);
                      context.go(_sidebarDestinations[i].path);
                    },
                  ),
                const SizedBox(height: 4),
                const Divider(height: 1, indent: 8, endIndent: 8),
                const SizedBox(height: 4),
                _SidebarIconItem(
                  icon: LucideIcons.folderOpen,
                  tooltip: l10n.adaptiveScaffoldSftp,
                  isSelected:
                      workspace.activeTab?.type == WorkspaceTabType.sftp,
                  onTap: () => _openSftp(context, ref),
                ),
                _SidebarIconItem(
                  icon: LucideIcons.arrowLeftRight,
                  tooltip: l10n.adaptiveScaffoldPortForwarding,
                  isSelected: GoRouterState.of(context).uri.path ==
                      RouteNames.portForwarding,
                  onTap: () {
                    ref.read(workspaceProvider.notifier).ensureTab(
                          WorkspaceTabType.portForwarding);
                    context.go(RouteNames.portForwarding);
                  },
                ),
              ],
            ),
          ),
          // Settings pinned above Collapse (always visible)
          const Divider(height: 1, indent: 8, endIndent: 8),
          _SidebarIconItem(
            icon: _sidebarDestinations.last.icon,
            tooltip: _localizedLabel(_sidebarDestinations.last.label, l10n),
            isSelected:
                selectedIndex == _sidebarDestinations.length - 1 &&
                    workspace.activeTab?.type != WorkspaceTabType.terminal,
            onTap: () {
              ref.read(workspaceProvider.notifier).ensureTab(
                    WorkspaceTabType.settings);
              context.go(_sidebarDestinations.last.path);
            },
          ),
          _CollapseToggle(
            isCollapsed: true,
            onTap: () =>
                ref.read(sidebarCollapsedProvider.notifier).state = false,
          ),
        ],
      ),
    ),
        // Gradient accent line on right edge
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.accentPrimary.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.transparent,
                  AppColors.accentBlue.withValues(alpha: 0.3),
                ],
                stops: const [0.0, 0.4, 0.6, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedSidebar(
      BuildContext context, WidgetRef ref, List<Host> recentHosts, AppLocalizations l10n) {
    final workspace = ref.watch(workspaceProvider);

    return Stack(
      children: [
        Container(
      color: AppColors.bgDeep,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientBrandFor(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    LucideIcons.terminal,
                    color: AppColors.textInverse,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(l10n.appName, style: AppTypography.h3),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.gradientBrandFor(context),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  onTap: () async {
                    final connected = await showQuickConnectDialog(context);
                    if (connected && context.mounted) {
                      final tabs = ref.read(terminalTabsProvider);
                      if (tabs.activeTab != null) {
                        ref.read(workspaceProvider.notifier).openTerminalTab(
                              tabs.activeTab!.id,
                              tabs.activeTab!.hostLabel,
                            );
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.zap,
                          size: 14, color: AppColors.textInverse),
                      const SizedBox(width: 8),
                      Text(
                        l10n.commandPaletteActionQuickConnect,
                        style: AppTypography.button.copyWith(
                          color: AppColors.textInverse,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Material(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => showCommandPalette(context),
                borderRadius: BorderRadius.circular(8),
                hoverColor: AppColors.bgHover,
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.search,
                          size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${l10n.search}...',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.bgActive,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '\u2318K',
                          style: AppTypography.caption.copyWith(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _SidebarSectionLabel(label: 'MAIN'),
                for (var i = 0; i < _sidebarDestinations.length - 1; i++)
                  _SidebarItem(
                    icon: _sidebarDestinations[i].icon,
                    label: _localizedLabel(_sidebarDestinations[i].label, l10n),
                    isSelected: i == selectedIndex &&
                        workspace.activeTab?.type != WorkspaceTabType.terminal,
                    onTap: () {
                      ref.read(workspaceProvider.notifier).ensureTab(
                            _sidebarDestinations[i].workspaceType);
                      context.go(_sidebarDestinations[i].path);
                    },
                  ),
                const SizedBox(height: 8),
                const Divider(height: 1, indent: 12, endIndent: 12),
                const SizedBox(height: 8),
                _SidebarSectionLabel(label: 'TOOLS'),
                _SidebarItem(
                  icon: LucideIcons.folderOpen,
                  label: l10n.adaptiveScaffoldSftp,
                  isSelected:
                      workspace.activeTab?.type == WorkspaceTabType.sftp,
                  onTap: () => _openSftp(context, ref),
                ),
                _SidebarItem(
                  icon: LucideIcons.arrowLeftRight,
                  label: l10n.adaptiveScaffoldPortForwarding,
                  isSelected: GoRouterState.of(context).uri.path ==
                      RouteNames.portForwarding,
                  onTap: () {
                    ref.read(workspaceProvider.notifier).ensureTab(
                          WorkspaceTabType.portForwarding);
                    context.go(RouteNames.portForwarding);
                  },
                ),
                if (recentHosts.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 1, indent: 12, endIndent: 12),
                  const SizedBox(height: 8),
                  _SidebarSectionLabel(label: 'RECENT'),
                  for (final host in recentHosts)
                    _SidebarRecentItem(
                      host: host,
                      onTap: () => context.push('/hosts/${host.id}'),
                    ),
                ],
              ],
            ),
          ),
          // Settings pinned above Collapse (always visible)
          const Divider(height: 1, indent: 12, endIndent: 12),
          _SidebarItem(
            icon: _sidebarDestinations.last.icon,
            label: _localizedLabel(_sidebarDestinations.last.label, l10n),
            isSelected: selectedIndex == _sidebarDestinations.length - 1 &&
                workspace.activeTab?.type != WorkspaceTabType.terminal,
            onTap: () {
              ref.read(workspaceProvider.notifier).ensureTab(
                    WorkspaceTabType.settings);
              context.go(_sidebarDestinations.last.path);
            },
          ),
          _CollapseToggle(
            isCollapsed: false,
            onTap: () =>
                ref.read(sidebarCollapsedProvider.notifier).state = true,
          ),
        ],
      ),
    ),
        // Gradient accent line on right edge
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.accentPrimary.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.transparent,
                  AppColors.accentBlue.withValues(alpha: 0.3),
                ],
                stops: const [0.0, 0.4, 0.6, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SidebarSectionLabel extends StatelessWidget {
  const _SidebarSectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Text(
        label,
        style: AppTypography.overline.copyWith(
          color: AppColors.textTertiary,
          fontSize: 10,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isSelected ? AppColors.accentGlow : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          hoverColor: AppColors.bgHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.accentPrimary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: AppTypography.body.copyWith(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
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

class _SidebarIconItem extends StatelessWidget {
  const _SidebarIconItem({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Tooltip(
        message: tooltip,
        preferBelow: false,
        waitDuration: const Duration(milliseconds: 400),
        child: Material(
          color: isSelected ? AppColors.bgActive : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            hoverColor: AppColors.bgHover,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.accentPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CollapseToggle extends StatelessWidget {
  const _CollapseToggle({
    required this.isCollapsed,
    required this.onTap,
  });
  final bool isCollapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: AppColors.bgHover,
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: isCollapsed
                ? const Icon(
                    LucideIcons.panelLeftOpen,
                    size: 18,
                    color: AppColors.textTertiary,
                  )
                : Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(
                        LucideIcons.panelLeftClose,
                        size: 18,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Collapse',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textTertiary,
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

class _SidebarRecentItem extends StatelessWidget {
  const _SidebarRecentItem({
    required this.host,
    required this.onTap,
  });
  final Host host;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          hoverColor: AppColors.bgHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        host.label,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        host.lastConnectedAt != null
                            ? Formatters.relativeTime(host.lastConnectedAt!)
                            : '',
                        style: AppTypography.caption.copyWith(fontSize: 10),
                      ),
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
