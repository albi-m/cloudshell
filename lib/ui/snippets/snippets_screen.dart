/// Command snippets management screen.
///
/// Displays saved command snippets organized by category,
/// with search, copy, and CRUD actions. Matches wireframe S7.1.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/clipboard_helper.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/snippet_provider.dart';
import '../shared/confirmation_dialog.dart';
import '../shared/empty_state.dart';
import '../shared/error_display.dart';
import '../shared/loading_indicator.dart';
import 'snippet_form_screen.dart';

/// Snippets list screen with search, category grouping, and CRUD.
class SnippetsScreen extends ConsumerStatefulWidget {
  const SnippetsScreen({super.key});

  @override
  ConsumerState<SnippetsScreen> createState() => _SnippetsScreenState();
}

class _SnippetsScreenState extends ConsumerState<SnippetsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final snippetsAsync = ref.watch(allSnippetsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text(l10n.snippetsTitle, style: AppTypography.h1),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            tooltip: l10n.snippetsAddTooltip,
            onPressed: () => _navigateToForm(context),
          ),
        ],
      ),
      body: snippetsAsync.when(
        data: (snippets) {
          if (snippets.isEmpty) {
            return EmptyState(
              icon: LucideIcons.code2,
              title: l10n.snippetsEmptyTitle,
              subtitle: l10n.snippetsEmptySubtitle,
              actionLabel: l10n.snippetsEmptyAction,
              onAction: () => _navigateToForm(context),
            );
          }

          // Filter by search query
          final filtered = _searchQuery.isEmpty
              ? snippets
              : snippets.where((s) {
                  final q = _searchQuery.toLowerCase();
                  return s.name.toLowerCase().contains(q) ||
                      s.command.toLowerCase().contains(q) ||
                      (s.category?.toLowerCase().contains(q) ?? false);
                }).toList();

          // Group by category
          final grouped = <String?, List<Snippet>>{};
          for (final s in filtered) {
            grouped.putIfAbsent(s.category, () => []).add(s);
          }
          // Sort categories: non-null first alphabetically, then uncategorized
          final sortedKeys = grouped.keys.toList()
            ..sort((a, b) {
              if (a == null) return 1;
              if (b == null) return -1;
              return a.compareTo(b);
            });

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.snippetsSearchHint,
                    prefixIcon: const Icon(LucideIcons.search, size: 18),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),

              // Snippets list grouped by category
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          l10n.snippetsNoMatchQuery(_searchQuery),
                          style: AppTypography.body
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _countItems(sortedKeys, grouped),
                        itemBuilder: (context, index) {
                          return _buildItem(
                              context, index, sortedKeys, grouped);
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => LoadingIndicator(message: l10n.snippetsLoadingMessage),
        error: (error, _) => ErrorDisplay(
          error: error,
          onRetry: () => ref.invalidate(allSnippetsProvider),
        ),
      ),
    );
  }

  /// Counts total items (headers + snippets) for the flat list.
  int _countItems(
      List<String?> keys, Map<String?, List<Snippet>> grouped) {
    var count = 0;
    for (final key in keys) {
      count += 1; // header
      count += grouped[key]!.length;
    }
    return count;
  }

  /// Builds either a category header or snippet item for the flat list.
  Widget _buildItem(BuildContext context, int index, List<String?> keys,
      Map<String?, List<Snippet>> grouped) {
    final l10n = AppLocalizations.of(context);
    var offset = 0;
    for (final key in keys) {
      if (index == offset) {
        // Category header
        return _CategoryHeader(label: key ?? l10n.snippetsUncategorized);
      }
      offset++;
      final items = grouped[key]!;
      if (index < offset + items.length) {
        final snippet = items[index - offset];
        return _SnippetListItem(
          snippet: snippet,
          onTap: () => context.push('/snippets/${snippet.id}'),
          onCopy: () => _copySnippet(context, snippet),
          onEdit: () => _navigateToForm(context, snippet: snippet),
          onDelete: () => _deleteSnippet(context, snippet),
        );
      }
      offset += items.length;
    }
    return const SizedBox.shrink();
  }

  void _navigateToForm(BuildContext context, {Snippet? snippet}) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => SnippetFormScreen(snippet: snippet),
      ),
    );
  }

  void _copySnippet(BuildContext context, Snippet snippet) {
    final l10n = AppLocalizations.of(context);
    copyWithAutoClear(snippet.command);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.snippetsCopiedMessage),
        ),
      );
    }
  }

  Future<void> _deleteSnippet(BuildContext context, Snippet snippet) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmationDialog(
      context: context,
      title: l10n.snippetsDeleteDialogTitle,
      message: l10n.snippetsDeleteDialogMessage(snippet.name),
      confirmLabel: l10n.delete,
      isDestructive: true,
    );

    if (confirmed) {
      final db = ref.read(databaseProvider);
      await db.snippetDao.softDeleteSnippet(snippet.id);
    }
  }
}

/// Category section header.
class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.overline.copyWith(
          color: AppColors.textTertiary,
          fontSize: 11,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

/// Individual snippet list item with icon, name, command preview, and actions.
class _SnippetListItem extends StatefulWidget {
  const _SnippetListItem({
    required this.snippet,
    required this.onTap,
    required this.onCopy,
    required this.onEdit,
    required this.onDelete,
  });

  final Snippet snippet;
  final VoidCallback onTap;
  final VoidCallback onCopy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_SnippetListItem> createState() => _SnippetListItemState();
}

class _SnippetListItemState extends State<_SnippetListItem> {
  bool _isHovered = false;

  bool get _hasVariables {
    if (widget.snippet.variables.isEmpty || widget.snippet.variables == '[]') {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 4),
        transform: Matrix4.translationValues(0, _isHovered ? -1 : 0, 0),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.bgRaised : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? AppColors.accentPrimary.withValues(alpha: 0.3)
                : AppColors.borderSubtle,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accentGlow,
                    blurRadius: 12,
                    spreadRadius: -2,
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          AppColors.accentPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.code2,
                      size: 20,
                      color: AppColors.accentPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snippet.name,
                          style: AppTypography.body
                              .copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.snippet.command,
                          style: AppTypography.code(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        if (_hasVariables) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(LucideIcons.variable,
                                  size: 12,
                                  color: AppColors.accentOrange),
                              const SizedBox(width: 4),
                              Text(
                                l10n.snippetsHasVariables,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.accentOrange,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.copy, size: 18),
                    tooltip: l10n.snippetsCopyCommandTooltip,
                    onPressed: widget.onCopy,
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      LucideIcons.moreVertical,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                    onSelected: (value) {
                      if (value == 'edit') widget.onEdit();
                      if (value == 'delete') widget.onDelete();
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(LucideIcons.pencil, size: 16),
                            SizedBox(width: 8),
                            Text(l10n.snippetsMenuEdit),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(LucideIcons.trash2,
                                size: 16, color: AppColors.accentRed),
                            SizedBox(width: 8),
                            Text(l10n.snippetsMenuDelete),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
