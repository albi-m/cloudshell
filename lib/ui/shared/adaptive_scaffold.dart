/// Adaptive scaffold that switches between sidebar (desktop)
/// and bottom navigation bar (mobile) layouts.
///
/// This is the primary layout wrapper for all main screens,
/// providing consistent navigation across platforms.
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

/// The four primary navigation destinations.
const _destinations = [
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

  /// Returns the index of the currently active navigation destination.
  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (var i = 0; i < _destinations.length; i++) {
      if (location.startsWith(_destinations[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppConstants.desktopBreakpoint;
    final selectedIndex = _currentIndex(context);

    if (isDesktop) {
      return _DesktopLayout(
        selectedIndex: selectedIndex,
        child: child,
      );
    }

    return _MobileLayout(
      selectedIndex: selectedIndex,
      child: child,
    );
  }
}

/// Desktop layout with a fixed sidebar and content area.
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

/// Desktop sidebar navigation panel.
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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

          const Divider(height: 1),

          // Navigation items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _destinations.length,
              itemBuilder: (context, index) {
                final dest = _destinations[index];
                final isSelected = index == selectedIndex;

                return _SidebarItem(
                  icon: isSelected ? dest.selectedIcon : dest.icon,
                  label: dest.label,
                  isSelected: isSelected,
                  onTap: () => context.go(dest.path),
                );
              },
            ),
          ),
        ],
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
          onTap: (index) => context.go(_destinations[index].path),
          items: _destinations
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
