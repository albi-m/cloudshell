/// SSH keys management screen.
///
/// Lists all stored SSH keys with options to generate,
/// import, export, and delete keys.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../shared/empty_state.dart';

/// SSH keys list screen for managing authentication keys.
class KeysScreen extends StatelessWidget {
  const KeysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text('SSH Keys', style: AppTypography.h1),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            tooltip: 'Add key',
            onPressed: () {
              // TODO: Show generate/import key dialog
            },
          ),
        ],
      ),
      body: const EmptyState(
        icon: LucideIcons.keyRound,
        title: 'No SSH keys',
        subtitle: 'Generate or import an SSH key for authentication.',
        actionLabel: 'Add Key',
      ),
    );
  }
}
