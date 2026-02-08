/// Confirmation dialog for destructive or important actions.
///
/// Provides a consistent dialog pattern across the app
/// with cancel/confirm buttons and customizable messaging.
library;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Shows a confirmation dialog and returns true if the user confirms.
///
/// Usage:
/// ```dart
/// final confirmed = await showConfirmationDialog(
///   context: context,
///   title: 'Delete Host',
///   message: 'Are you sure you want to delete "web-server-1"?',
///   confirmLabel: 'Delete',
///   isDestructive: true,
/// );
/// if (confirmed) { ... }
/// ```
Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => _ConfirmationDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      isDestructive: isDestructive,
    ),
  );
  return result ?? false;
}

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isDestructive,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: AppTypography.h2),
      content: Text(
        message,
        style: AppTypography.body.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: isDestructive
              ? ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentRed,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
