/// Snippet picker overlay for inserting commands into the terminal.
///
/// Shows a searchable list of snippets. If the selected snippet
/// has {{variable}} placeholders, prompts the user to fill them
/// before returning the resolved command.
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/snippet_provider.dart';

/// Shows the snippet picker dialog and returns the resolved command string,
/// or `null` if the user cancelled.
///
/// If the selected snippet contains `{{variable}}` placeholders, a secondary
/// dialog prompts the user to fill in values before returning the final command.
Future<String?> showSnippetPicker(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const _SnippetPickerDialog(),
  );
}

class _SnippetPickerDialog extends ConsumerStatefulWidget {
  const _SnippetPickerDialog();

  @override
  ConsumerState<_SnippetPickerDialog> createState() =>
      _SnippetPickerDialogState();
}

class _SnippetPickerDialogState extends ConsumerState<_SnippetPickerDialog> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final snippetsAsync = ref.watch(allSnippetsProvider);

    return Dialog(
      backgroundColor: AppColors.bgSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.snippetPickerSearchHint,
                  prefixIcon: const Icon(LucideIcons.search, size: 18),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(LucideIcons.x, size: 16),
                          tooltip: l10n.close,
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const Divider(height: 1),

            // Snippet list
            Flexible(
              child: snippetsAsync.when(
                data: (snippets) {
                  if (snippets.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        l10n.snippetPickerEmptyMessage,
                        style: AppTypography.body
                            .copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final filtered = _query.isEmpty
                      ? snippets
                      : snippets.where((s) {
                          final q = _query.toLowerCase();
                          return s.name.toLowerCase().contains(q) ||
                              s.command.toLowerCase().contains(q) ||
                              (s.category?.toLowerCase().contains(q) ?? false);
                        }).toList();

                  if (filtered.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        l10n.snippetPickerNoMatchQuery(_query),
                        style: AppTypography.body
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final snippet = filtered[index];
                      return _PickerItem(
                        snippet: snippet,
                        onTap: () => _selectSnippet(snippet),
                      );
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
                error: (_, _) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    l10n.snippetPickerLoadingError,
                    style: AppTypography.body
                        .copyWith(color: AppColors.accentRed),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectSnippet(Snippet snippet) async {
    final variables = _parseVariables(snippet.variables);

    if (variables.isEmpty) {
      // No variables — return command as-is
      if (mounted) Navigator.of(context).pop(snippet.command);
      return;
    }

    // Show variable input dialog
    final resolved = await _showVariableDialog(snippet.command, variables);
    if (resolved != null && mounted) {
      Navigator.of(context).pop(resolved);
    }
  }

  List<String> _parseVariables(String variablesJson) {
    try {
      final list = jsonDecode(variablesJson) as List;
      return list.cast<String>();
    } catch (e) {
      debugPrint('Snippet variables JSON parse failed: $e');
      return [];
    }
  }

  Future<String?> _showVariableDialog(
      String command, List<String> variables) {
    final l10n = AppLocalizations.of(context);
    final controllers = {
      for (final v in variables) v: TextEditingController(),
    };

    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: Text(l10n.snippetPickerVariableDialogTitle, style: AppTypography.h3),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final v in variables)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextField(
                    controller: controllers[v],
                    decoration: InputDecoration(
                      labelText: v,
                      hintText: l10n.snippetPickerVariableHint(v),
                      prefixIcon:
                          const Icon(LucideIcons.variable, size: 16),
                    ),
                    autofocus: v == variables.first,
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              var resolved = command;
              for (final v in variables) {
                resolved = resolved.replaceAll(
                  '{{$v}}',
                  controllers[v]!.text,
                );
              }
              Navigator.of(ctx).pop(resolved);
            },
            child: Text(l10n.snippetPickerVariableInsert),
          ),
        ],
      ),
    );
  }
}

class _PickerItem extends StatelessWidget {
  const _PickerItem({required this.snippet, required this.onTap});

  final Snippet snippet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(LucideIcons.code2, size: 16, color: AppColors.accentPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snippet.name,
                    style: AppTypography.body
                        .copyWith(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    snippet.command,
                    style: AppTypography.code(fontSize: 11).copyWith(
                      color: AppColors.textTertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            if (snippet.category != null) ...[
              const SizedBox(width: 8),
              Text(
                snippet.category!,
                style: AppTypography.caption
                    .copyWith(color: AppColors.textTertiary),
              ),
            ],
            const SizedBox(width: 8),
            const Icon(LucideIcons.arrowRight,
                size: 14, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
