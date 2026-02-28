/// Snippet detail screen showing full information for a command snippet.
///
/// Displays name, category, full command, description, variables,
/// and provides copy, edit, and delete actions.
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/clipboard_helper.dart';
import '../../core/utils/formatters.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../shared/confirmation_dialog.dart';
import '../shared/error_display.dart';
import '../shared/loading_indicator.dart';

/// Provider to fetch a single snippet by ID.
final _snippetByIdProvider =
    FutureProvider.family<Snippet?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.snippetDao.getSnippetById(id);
});

/// Detail view for a single command snippet.
class SnippetDetailScreen extends ConsumerWidget {
  const SnippetDetailScreen({super.key, required this.snippetId});

  final String snippetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final snippetAsync = ref.watch(_snippetByIdProvider(snippetId));

    return snippetAsync.when(
      data: (snippet) {
        if (snippet == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.snippetDetailNotFound)),
          );
        }
        return _SnippetDetailView(snippet: snippet);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: LoadingIndicator(message: l10n.snippetDetailLoading),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorDisplay(
          error: error,
          onRetry: () => ref.invalidate(_snippetByIdProvider(snippetId)),
        ),
      ),
    );
  }
}

class _SnippetDetailView extends ConsumerWidget {
  const _SnippetDetailView({required this.snippet});

  final Snippet snippet;

  List<String> get _variables {
    try {
      final list = jsonDecode(snippet.variables) as List;
      return list.cast<String>();
    } catch (e) {
      debugPrint('Snippet variables JSON parse failed: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final vars = _variables;

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text(snippet.name, style: AppTypography.h2),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.pencil, size: 18),
            tooltip: l10n.snippetDetailEditTooltip,
            onPressed: () => _edit(context),
          ),
          IconButton(
            icon: const Icon(LucideIcons.trash2, size: 18),
            tooltip: l10n.snippetDetailDeleteTooltip,
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category badge
            if (snippet.category != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            AppColors.accentPrimary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        snippet.category!,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.accentPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Command card
            _SectionCard(
              title: l10n.snippetDetailSectionCommand,
              trailing: IconButton(
                icon: const Icon(LucideIcons.copy, size: 16),
                tooltip: l10n.snippetDetailCopyCommandTooltip,
                onPressed: () => _copyCommand(context),
              ),
              child: SelectableText(
                snippet.command,
                style: AppTypography.code(fontSize: 13),
              ),
            ),
            const SizedBox(height: 12),

            // Variables
            if (vars.isNotEmpty) ...[
              _SectionCard(
                title: l10n.snippetDetailSectionVariables,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: vars
                      .map((v) => Chip(
                            avatar: const Icon(LucideIcons.variable,
                                size: 14, color: AppColors.accentOrange),
                            label: Text(
                              '{{$v}}',
                              style:
                                  AppTypography.code(fontSize: 12).copyWith(
                                color: AppColors.accentOrange,
                              ),
                            ),
                            backgroundColor: AppColors.accentOrange
                                .withValues(alpha: 0.1),
                            side: BorderSide.none,
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Description
            if (snippet.description != null &&
                snippet.description!.isNotEmpty) ...[
              _SectionCard(
                title: l10n.snippetDetailSectionDescription,
                child: Text(
                  snippet.description!,
                  style: AppTypography.body
                      .copyWith(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Metadata
            _SectionCard(
              title: l10n.snippetDetailSectionDetails,
              child: Column(
                children: [
                  _DetailRow(
                      label: l10n.snippetDetailLabelCreated,
                      value: Formatters.relativeTime(snippet.createdAt)),
                  _DetailRow(
                      label: l10n.snippetDetailLabelUpdated,
                      value: Formatters.relativeTime(snippet.updatedAt)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyCommand(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    copyWithAutoClear(snippet.command);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.snippetDetailCopiedMessage),
        ),
      );
    }
  }

  void _edit(BuildContext context) {
    context.push(RouteNames.snippetForm, extra: snippet);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmationDialog(
      context: context,
      title: l10n.snippetsDeleteDialogTitle,
      message: l10n.snippetsDeleteDialogMessage(snippet.name),
      confirmLabel: l10n.delete,
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      final db = ref.read(databaseProvider);
      await db.snippetDao.softDeleteSnippet(snippet.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}

/// Reusable section card with title header.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppTypography.overline.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                ?trailing,
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

/// Key-value detail row.
class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textTertiary),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
