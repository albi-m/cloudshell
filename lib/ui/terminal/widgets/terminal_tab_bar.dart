/// Tab bar widget for multi-tab terminal sessions.
///
/// Renders a horizontal strip of tabs, each representing an
/// active SSH session. Supports switching, closing, and adding tabs.
/// Matches wireframe S4.1.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/terminal_tab_provider.dart';

/// Tab bar showing all open terminal sessions.
///
/// Displays each tab with its host label and a close button.
/// The active tab is visually highlighted. A "+" button
/// is shown at the end for adding new connections.
class TerminalTabBar extends StatelessWidget {
  const TerminalTabBar({
    super.key,
    required this.tabs,
    required this.activeTabId,
    required this.onTabSelected,
    required this.onTabClosed,
    required this.onNewTab,
  });

  final List<TerminalTab> tabs;
  final String? activeTabId;
  final ValueChanged<String> onTabSelected;
  final ValueChanged<String> onTabClosed;
  final VoidCallback onNewTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.bgDeep,
        border: Border(
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isActive = tab.id == activeTabId;
                return _TabItem(
                  label: tab.hostLabel,
                  isActive: isActive,
                  onTap: () => onTabSelected(tab.id),
                  onClose: () => onTabClosed(tab.id),
                );
              },
            ),
          ),
          // Add tab button
          _AddTabButton(onTap: onNewTab),
        ],
      ),
    );
  }
}

/// Single tab item in the tab bar.
class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.onClose,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 180, minWidth: 80),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.bgSurface : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.accentPrimary : Colors.transparent,
              width: 2,
            ),
            right: const BorderSide(color: AppColors.borderSubtle),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  color: isActive
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: onClose,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  LucideIcons.x,
                  size: 12,
                  color: isActive
                      ? AppColors.textSecondary
                      : AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "+" button for opening a new terminal tab.
class _AddTabButton extends StatelessWidget {
  const _AddTabButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: const Icon(
          LucideIcons.plus,
          size: 16,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
