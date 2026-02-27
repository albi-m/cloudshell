/// Keyboard shortcut reference overlay.
///
/// Displays all available keyboard shortcuts grouped by context
/// (Global, Terminal, Host List). Triggered by Cmd+/ or Ctrl+/.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/platform_utils.dart';
import '../../l10n/app_localizations.dart';

/// Shows the keyboard shortcut reference overlay as a modal dialog.
///
/// Displays all available shortcuts grouped by context (General, Terminal,
/// Navigation), adapting modifier key labels for macOS vs other platforms.
void showShortcutReference(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: AppColors.barrierMedium,
    builder: (_) => const _ShortcutReferenceDialog(),
  );
}

class _ShortcutReferenceDialog extends StatelessWidget {
  const _ShortcutReferenceDialog();

  String get _mod => PlatformUtils.isMacOS ? 'Cmd' : 'Ctrl';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      backgroundColor: AppColors.bgSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  const Icon(LucideIcons.keyboard, size: 18),
                  const SizedBox(width: 8),
                  Text(l10n.shortcutReferenceTitle, style: AppTypography.h2),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 16),
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Shortcuts list
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _ShortcutSection(
                    title: l10n.shortcutCategoryGeneral,
                    shortcuts: [
                      _Shortcut('Command Palette', '$_mod+K'),
                      _Shortcut('New Host', '$_mod+N'),
                      _Shortcut('Quick Connect', '$_mod+Shift+N'),
                      _Shortcut('Settings', '$_mod+,'),
                      _Shortcut('Shortcut Reference', '$_mod+/'),
                    ],
                  ),
                  _ShortcutSection(
                    title: l10n.shortcutCategoryTerminal,
                    shortcuts: [
                      _Shortcut('New Tab', '$_mod+T'),
                      _Shortcut('Close Tab', '$_mod+W'),
                      _Shortcut('Copy Selection', '$_mod+C'),
                      _Shortcut('Paste', '$_mod+V'),
                      _Shortcut('Zoom In', '$_mod+='),
                      _Shortcut('Zoom Out', '$_mod+-'),
                      _Shortcut('Reset Zoom', '$_mod+0'),
                      _Shortcut('Split Horizontal', '$_mod+D'),
                      _Shortcut('Split Vertical', '$_mod+Shift+D'),
                      _Shortcut('Switch Pane', 'Alt+← / Alt+→'),
                      _Shortcut('Search Output', '$_mod+Shift+F'),
                    ],
                  ),
                  _ShortcutSection(
                    title: l10n.shortcutCategoryNavigation,
                    shortcuts: [
                      _Shortcut('Connect', 'Enter'),
                      _Shortcut('Edit', 'E'),
                      _Shortcut('Delete', 'Del'),
                      _Shortcut('Navigate', '↑ / ↓'),
                      _Shortcut('Focus Search', '/'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Shortcut {
  const _Shortcut(this.action, this.keys);
  final String action;
  final String keys;
}

class _ShortcutSection extends StatelessWidget {
  const _ShortcutSection({
    required this.title,
    required this.shortcuts,
  });

  final String title;
  final List<_Shortcut> shortcuts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
          child: Text(
            title,
            style: AppTypography.overline.copyWith(
              color: AppColors.textTertiary,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
        ),
        for (final shortcut in shortcuts)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    shortcut.action,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                _KeyBadge(keys: shortcut.keys),
              ],
            ),
          ),
      ],
    );
  }
}

/// Styled keyboard shortcut badge.
class _KeyBadge extends StatelessWidget {
  const _KeyBadge({required this.keys});

  final String keys;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.bgRaised,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.borderSubtle,
          width: 0.5,
        ),
      ),
      child: Text(
        keys,
        style: AppTypography.caption.copyWith(
          fontSize: 11,
          color: AppColors.textTertiary,
          fontFamily: 'JetBrainsMono',
        ),
      ),
    );
  }
}
