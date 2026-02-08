/// Adaptive scaffold that switches between sidebar (desktop)
/// and bottom navigation bar (mobile) layouts.
///
/// This is the primary layout wrapper for all main screens,
/// providing consistent navigation across platforms.
/// Matches wireframe Master Layout Structure.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Navigation destination definition.
class _NavDestination {
  const _NavDestination({
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Desktop sidebar navigation destinations (per wireframe).
const _sidebarDestinations = [
  _NavDestination(
    path: RouteNames.hosts,
    label: 'Hosts',
    icon: LucideIcons.server,
    selectedIcon: LucideIcons.server,
  ),
  _NavDestination(
    path: RouteNames.keys,
    label: 'Keys',
    icon: LucideIcons.keyRound,
    selectedIcon: LucideIcons.keyRound,
  ),
  _NavDestination(
    path: RouteNames.snippets,
    label: 'Snippets',
    icon: LucideIcons.code2,
    selectedIcon: LucideIcons.code2,
  ),
  _NavDestination(
    path: RouteNames.settings,
    label: 'Settings',
    icon: LucideIcons.settings,
    selectedIcon: LucideIcons.settings,
  ),
];

/// Mobile bottom nav destinations (5 items per wireframe).
const _mobileDestinations = [
  _NavDestination(
    path: RouteNames.hosts,
    label: 'Hosts',
    icon: LucideIcons.server,
    selectedIcon: LucideIcons.server,
  ),
  _NavDestination(
    path: RouteNames.keys,
    label: 'Keys',
    icon: LucideIcons.keyRound,
    selectedIcon: LucideIcons.keyRound,
  ),
  _NavDestination(
    path: RouteNames.snippets,
    label: 'Snippets',
    icon: LucideIcons.code2,
    selectedIcon: LucideIcons.code2,
  ),
  _NavDestination(
    path: RouteNames.settings,
    label: 'Settings',
    icon: LucideIcons.settings,
    selectedIcon: LucideIcons.settings,
  ),
];

/// Responsive scaffold that adapts between desktop sidebar
/// and mobile bottom navigation bar layouts.
///
/// Uses [AppConstants.desktopBreakpoint] (768px) to determine
/// which layout to render.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({super.key, required this.child});

  /// The current route's page content.
  final Widget child;

  /// Returns the index of the currently active navigation destination
  /// for the given destination list.
  int _currentIndex(BuildContext context, List<_NavDestination> destinations) {
    final location = GoRouterState.of(context).uri.path;
    for (var i = 0; i < destinations.length; i++) {
      if (location.startsWith(destinations[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppConstants.desktopBreakpoint;

    if (isDesktop) {
      return _DesktopLayout(
        selectedIndex: _currentIndex(context, _sidebarDestinations),
        child: child,
      );
    }

    return _MobileLayout(
      selectedIndex: _currentIndex(context, _mobileDestinations),
      child: child,
    );
  }
}

/// Desktop layout with a full sidebar and content area.
///
/// Sidebar includes per wireframe:
/// - App header with logo
/// - Search box
/// - Main nav items (Hosts, Keys, Snippets)
/// - Tools section (SFTP, Port Fwd)
/// - Settings at bottom
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.selectedIndex,
    required this.child,
  });

  final int selectedIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: AppConstants.sidebarWidth,
            child: _Sidebar(selectedIndex: selectedIndex),
          ),

          // Vertical divider
          const VerticalDivider(width: 1, thickness: 1),

          // Main content
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Desktop sidebar navigation panel per wireframe Master Layout.
class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgDeep,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.accentPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    LucideIcons.terminal,
                    color: AppColors.textInverse,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppConstants.appName,
                  style: AppTypography.h3,
                ),
              ],
            ),
          ),

          // Search box (per wireframe)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(LucideIcons.search, size: 16),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                filled: true,
                fillColor: AppColors.bgSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: AppTypography.bodySmall,
            ),
          ),

          const Divider(height: 1),

          // Main navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // --- MAIN ---
                _SidebarSectionLabel(label: 'MAIN'),
                for (var i = 0; i < _sidebarDestinations.length - 1; i++)
                  _SidebarItem(
                    icon: _sidebarDestinations[i].icon,
                    label: _sidebarDestinations[i].label,
                    isSelected: i == selectedIndex,
                    onTap: () => context.go(_sidebarDestinations[i].path),
                  ),

                const SizedBox(height: 8),
                const Divider(height: 1, indent: 12, endIndent: 12),
                const SizedBox(height: 8),

                // --- TOOLS (per wireframe: SFTP, Port Fwd) ---
                _SidebarSectionLabel(label: 'TOOLS'),
                _SidebarItem(
                  icon: LucideIcons.folderOpen,
                  label: 'SFTP',
                  isSelected: false,
                  onTap: () {}, // Sprint 3
                ),
                _SidebarItem(
                  icon: LucideIcons.arrowLeftRight,
                  label: 'Port Forwarding',
                  isSelected: false,
                  onTap: () {}, // Sprint 3
                ),

                const SizedBox(height: 8),
                const Divider(height: 1, indent: 12, endIndent: 12),
                const SizedBox(height: 8),

                // Settings
                _SidebarItem(
                  icon: _sidebarDestinations.last.icon,
                  label: _sidebarDestinations.last.label,
                  isSelected: selectedIndex == _sidebarDestinations.length - 1,
                  onTap: () => context.go(_sidebarDestinations.last.path),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section label in the sidebar (e.g., "MAIN", "TOOLS").
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

/// Individual sidebar navigation item.
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
        color: isSelected ? AppColors.bgActive : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
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

/// Mobile layout with bottom navigation bar.
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.selectedIndex,
    required this.child,
  });

  final int selectedIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.borderSubtle),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => context.go(_mobileDestinations[index].path),
          items: _mobileDestinations
              .map(
                (dest) => BottomNavigationBarItem(
                  icon: Icon(dest.icon),
                  activeIcon: Icon(dest.selectedIcon),
                  label: dest.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
