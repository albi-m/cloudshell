/// Unified terminal header bar combining navigation, tabs, and actions.
///
/// Renders a single compact row: back button, tabs, new-tab button,
/// and action icons (copy/paste). Replaces the separate AppBar + tab bar
/// for a clean Termius/Chrome-style layout.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/terminal_tab_provider.dart';

/// Unified terminal header with tabs and action buttons.
///
/// Layout: [← back] [tabs ...] [+] | [copy] [paste]
class TerminalHeader extends StatelessWidget {
  const TerminalHeader({
    super.key,
    required this.tabs,
    required this.activeTabId,
    required this.onTabSelected,
    required this.onTabClosed,
    required this.onNewTab,
    required this.onBack,
    required this.onCopy,
    required this.onPaste,
    required this.onSnippets,
  });

  final List<TerminalTab> tabs;
  final String? activeTabId;
  final ValueChanged<String> onTabSelected;
  final ValueChanged<String> onTabClosed;
  final VoidCallback onNewTab;
  final VoidCallback onBack;
  final VoidCallback onCopy;
  final VoidCallback onPaste;
  final VoidCallback onSnippets;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.bgDeep,
        border: Border(
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          // Back button
          _HeaderIconButton(
            icon: LucideIcons.arrowLeft,
            tooltip: l10n.terminalHeaderBackTooltip,
            onTap: onBack,
          ),
          const _VerticalDivider(),

          // Tabs area (scrollable)
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

          // New tab button
          _HeaderIconButton(
            icon: LucideIcons.plus,
            tooltip: l10n.terminalHeaderNewConnectionTooltip,
            onTap: onNewTab,
            size: 15,
          ),
          // Snippets button
          _HeaderIconButton(
            icon: LucideIcons.code2,
            tooltip: l10n.terminalHeaderSnippetsTooltip,
            onTap: onSnippets,
            size: 15,
          ),
          const _VerticalDivider(),

          // Action buttons
          _HeaderIconButton(
            icon: LucideIcons.copy,
            tooltip: l10n.terminalHeaderCopyTooltip,
            onTap: onCopy,
            size: 15,
          ),
          _HeaderIconButton(
            icon: LucideIcons.clipboardPaste,
            tooltip: l10n.terminalHeaderPasteTooltip,
            onTap: onPaste,
            size: 15,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

/// Thin vertical separator between header sections.
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

/// Compact icon button for the header bar with hover effect.
class _HeaderIconButton extends StatefulWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size = 16,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton> {
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
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.bgRaised.withValues(alpha: 0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              widget.icon,
              size: widget.size,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Single browser-style tab item with hover effects.
///
/// Shows a terminal icon, host label, and close button.
/// Close button only appears on hover or for the active tab.
/// Active tab has rounded top corners and a highlighted background.
class _TabItem extends StatefulWidget {
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
  State<_TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<_TabItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final showClose = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          constraints: const BoxConstraints(maxWidth: 200, minWidth: 100),
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Terminal icon
              Icon(
                LucideIcons.terminal,
                size: 12,
                color: widget.isActive
                    ? AppColors.accentPrimary
                    : AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              // Tab label
              Flexible(
                child: Text(
                  widget.label,
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
              const SizedBox(width: 6),
              // Close button — visible on hover or active tab
              if (showClose)
                SizedBox(
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
                )
              else
                const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// "+" button for opening a new terminal tab.
class _AddTabButton extends StatefulWidget {
  const _AddTabButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_AddTabButton> createState() => _AddTabButtonState();
}

class _AddTabButtonState extends State<_AddTabButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: l10n.terminalHeaderNewTabTooltip,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.bgRaised.withValues(alpha: 0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              LucideIcons.plus,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}
