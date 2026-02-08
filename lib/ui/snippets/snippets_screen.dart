/// Command snippets management screen.
///
/// Displays saved command snippets organized by category,
/// with options to create, edit, and quick-insert into terminals.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../shared/empty_state.dart';

/// Snippets list screen for managing reusable commands.
class SnippetsScreen extends StatelessWidget {
  const SnippetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text('Snippets', style: AppTypography.h1),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            tooltip: 'Add snippet',
            onPressed: () {
              // TODO: Navigate to snippet form
            },
          ),
        ],
      ),
      body: const EmptyState(
        icon: LucideIcons.code2,
        title: 'No snippets',
        subtitle: 'Save frequently used commands for quick access.',
        actionLabel: 'Add Snippet',
      ),
    );
  }
}
