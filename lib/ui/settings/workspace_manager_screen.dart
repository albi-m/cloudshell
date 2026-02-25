/// Workspace manager screen for saved workspace layouts.
///
/// Lists all saved workspaces with switch, rename, and delete
/// actions. Includes a "Save Current" button to persist the
/// current tab layout as a new named workspace.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/workspace_provider.dart';

/// Screen for managing saved workspaces.
class WorkspaceManagerScreen extends ConsumerWidget {
  const WorkspaceManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final workspacesAsync = ref.watch(allWorkspacesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.workspacesTitle, style: AppTypography.h2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.icon(
              onPressed: () => _saveCurrentWorkspace(context, ref),
              icon: const Icon(LucideIcons.save, size: 16),
              label: Text(l10n.workspacesSaveCurrent),
            ),
          ),
        ],
      ),
      body: workspacesAsync.when(
        data: (workspaces) {
          if (workspaces.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.layout,
                      size: 48,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(l10n.workspacesEmptyTitle,
                      style: AppTypography.h3.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5))),
                  const SizedBox(height: 8),
                  Text(
                    l10n.workspacesEmptySubtitle,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.4)),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: workspaces.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final ws = workspaces[index];
              return _WorkspaceTile(workspace: ws);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(l10n.workspacesLoadError('$e'),
              style: AppTypography.body),
        ),
      ),
    );
  }

  void _saveCurrentWorkspace(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.workspacesSaveTitle, style: AppTypography.h2),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.workspacesSaveHint,
            prefixIcon: const Icon(LucideIcons.layout, size: 18),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              ref
                  .read(workspaceProvider.notifier)
                  .saveAsNewWorkspace(value.trim());
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.workspaceSaved(value.trim()))),
              );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.of(dialogContext).pop();
            },
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              ref
                  .read(workspaceProvider.notifier)
                  .saveAsNewWorkspace(name);
              controller.dispose();
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.workspaceSaved(name))),
              );
            },
            child: Text(l10n.workspacesSaveSave),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceTile extends ConsumerWidget {
  const _WorkspaceTile({required this.workspace});

  final Workspace workspace;

  String _formatDate(BuildContext context, DateTime dt) {
    final l10n = AppLocalizations.of(context);
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return l10n.workspacesJustNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  int _terminalCount() {
    try {
      final layout = workspace.layoutJson;
      if (layout.contains('"terminalTabs"')) {
        final match = RegExp(r'"terminalTabs"\s*:\s*\[').firstMatch(layout);
        if (match != null) {
          // Count hostId occurrences as a proxy for terminal count
          return RegExp(r'"hostId"').allMatches(layout).length;
        }
      }
    } catch (e) {
      debugPrint('Workspace tab counting failed: $e');
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final terminals = _terminalCount();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: workspace.isActive
              ? AppColors.accentPrimary.withValues(alpha: 0.5)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: workspace.isActive
            ? null
            : () => _switchTo(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                workspace.isActive
                    ? LucideIcons.layoutDashboard
                    : LucideIcons.layout,
                size: 24,
                color: workspace.isActive
                    ? AppColors.accentPrimary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            workspace.name,
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (workspace.isActive) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accentPrimary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.workspacesActiveBadge,
                              style: AppTypography.overline.copyWith(
                                color: AppColors.accentPrimary,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${terminals > 0 ? l10n.workspaceTerminalCount(terminals) : l10n.workspacesNoTerminals} \u2022 ${_formatDate(context, workspace.updatedAt)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(LucideIcons.moreVertical,
                    size: 18,
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.5)),
                onSelected: (action) {
                  switch (action) {
                    case 'switch':
                      _switchTo(context, ref);
                    case 'rename':
                      _rename(context, ref);
                    case 'delete':
                      _delete(context, ref);
                  }
                },
                itemBuilder: (_) => [
                  if (!workspace.isActive)
                    PopupMenuItem(
                      value: 'switch',
                      child: Row(
                        children: [
                          const Icon(LucideIcons.arrowRight, size: 16),
                          const SizedBox(width: 8),
                          Text(l10n.workspacesMenuSwitchTo),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        const Icon(LucideIcons.pencil, size: 16),
                        const SizedBox(width: 8),
                        Text(l10n.workspacesMenuRename),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(LucideIcons.trash2,
                            size: 16, color: AppColors.accentRed),
                        const SizedBox(width: 8),
                        Text(l10n.workspacesMenuDelete,
                            style:
                                const TextStyle(color: AppColors.accentRed)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _switchTo(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(l10n.workspaceSwitching(workspace.name))),
    );

    await ref
        .read(workspaceProvider.notifier)
        .switchToWorkspace(workspace.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.workspaceLoaded(workspace.name)),
        ),
      );
    }
  }

  void _rename(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: workspace.name);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.workspacesRenameTitle, style: AppTypography.h2),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.workspacesRenameHint,
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              ref
                  .read(databaseProvider)
                  .workspaceDao
                  .renameWorkspace(workspace.id, value.trim());
              Navigator.of(dialogContext).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.of(dialogContext).pop();
            },
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              ref
                  .read(databaseProvider)
                  .workspaceDao
                  .renameWorkspace(workspace.id, name);
              controller.dispose();
              Navigator.of(dialogContext).pop();
            },
            child: Text(l10n.workspacesRenameSubmit),
          ),
        ],
      ),
    );
  }

  void _delete(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.workspacesDeleteTitle, style: AppTypography.h2),
        content: Text(l10n.workspaceDeleteConfirm(workspace.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentRed,
            ),
            onPressed: () {
              ref
                  .read(databaseProvider)
                  .workspaceDao
                  .deleteWorkspace(workspace.id);
              Navigator.of(dialogContext).pop();
            },
            child: Text(l10n.workspacesDeleteSubmit),
          ),
        ],
      ),
    );
  }
}
