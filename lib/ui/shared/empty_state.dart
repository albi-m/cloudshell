/// Empty state placeholder widget for CloudShell.
///
/// Shown when a list or screen has no content, providing
/// a helpful message and an optional call-to-action button.
library;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Displays an empty state with icon, title, subtitle, and
/// optional action button.
///
/// Usage:
/// ```dart
/// EmptyState(
///   icon: LucideIcons.server,
///   title: 'No hosts yet',
///   subtitle: 'Add your first SSH server to get started.',
///   actionLabel: 'Add Host',
///   onAction: () => context.push(RouteNames.hostForm),
/// )
/// ```
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  /// Large icon displayed above the title.
  final IconData icon;

  /// Primary message text.
  final String title;

  /// Secondary descriptive text.
  final String subtitle;

  /// Optional action button label. If null, no button is shown.
  final String? actionLabel;

  /// Callback when the action button is pressed.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
