/// Hosts list screen — the default home screen of CloudShell.
///
/// Displays all saved SSH hosts organized by groups,
/// with search, filtering, and quick connect functionality.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../shared/empty_state.dart';

/// Main hosts list screen showing all saved SSH connections.
class HostsScreen extends StatelessWidget {
  const HostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text('Hosts', style: AppTypography.h1),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            tooltip: 'Search hosts',
            onPressed: () {
              // TODO: Implement host search
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.plus),
            tooltip: 'Add host',
            onPressed: () {
              // TODO: Navigate to add host form
            },
          ),
        ],
      ),
      body: const EmptyState(
        icon: LucideIcons.server,
        title: 'No hosts yet',
        subtitle: 'Add your first SSH server to get started.',
        actionLabel: 'Add Host',
      ),
    );
  }
}
