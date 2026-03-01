/// Add/edit snippet form screen.
///
/// Provides a form for creating new command snippets or
/// editing existing ones. Auto-detects {{variable}} placeholders
/// in the command text.
library;

import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/snippet_provider.dart';

/// Regex for detecting {{variable}} placeholders in command text.
final _variableRegex = RegExp(r'\{\{(\w+)\}\}');

/// Form screen for adding or editing a command snippet.
///
/// Pass an existing [snippet] to edit, or omit for a new snippet.
class SnippetFormScreen extends ConsumerStatefulWidget {
  const SnippetFormScreen({super.key, this.snippet});

  /// Existing snippet to edit. Null for creating a new snippet.
  final Snippet? snippet;

  bool get isEditing => snippet != null;

  @override
  ConsumerState<SnippetFormScreen> createState() => _SnippetFormScreenState();
}

class _SnippetFormScreenState extends ConsumerState<SnippetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  static const _uuid = Uuid();

  late final TextEditingController _nameController;
  late final TextEditingController _commandController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;

  bool _isSaving = false;
  List<String> _detectedVariables = [];

  @override
  void initState() {
    super.initState();
    final s = widget.snippet;
    _nameController = TextEditingController(text: s?.name ?? '');
    _commandController = TextEditingController(text: s?.command ?? '');
    _categoryController = TextEditingController(text: s?.category ?? '');
    _descriptionController = TextEditingController(text: s?.description ?? '');

    // Detect initial variables
    _detectedVariables = _extractVariables(_commandController.text);

    // Listen for command changes to detect variables
    _commandController.addListener(_onCommandChanged);
  }

  @override
  void dispose() {
    _commandController.removeListener(_onCommandChanged);
    _nameController.dispose();
    _commandController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onCommandChanged() {
    final vars = _extractVariables(_commandController.text);
    if (vars.length != _detectedVariables.length ||
        !vars.every((v) => _detectedVariables.contains(v))) {
      setState(() => _detectedVariables = vars);
    }
  }

  List<String> _extractVariables(String command) {
    return _variableRegex
        .allMatches(command)
        .map((m) => m.group(1)!)
        .toSet()
        .toList();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();
      final name = _nameController.text.trim();
      final command = _commandController.text.trim();
      final category = _categoryController.text.trim();
      final description = _descriptionController.text.trim();
      final variablesJson = jsonEncode(_detectedVariables);

      if (widget.isEditing) {
        await db.snippetDao.updateSnippet(SnippetsCompanion(
          id: Value(widget.snippet!.id),
          name: Value(name),
          command: Value(command),
          category: Value(category.isEmpty ? null : category),
          description: Value(description.isEmpty ? null : description),
          variables: Value(variablesJson),
          updatedAt: Value(now),
        ));
      } else {
        await db.snippetDao.insertSnippet(SnippetsCompanion(
          id: Value(_uuid.v4()),
          name: Value(name),
          command: Value(command),
          category: Value(category.isEmpty ? null : category),
          description: Value(description.isEmpty ? null : description),
          variables: Value(variablesJson),
          createdAt: Value(now),
          updatedAt: Value(now),
        ));
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.snippetFormSaveError(ErrorHandler.userMessage(e)))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(snippetCategoriesProvider);
    final existingCategories = categoriesAsync.value ?? <String>[];

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? l10n.snippetFormTitleEdit : l10n.snippetFormTitleNew,
          style: AppTypography.h2,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.snippetFormNameLabel,
                  hintText: l10n.snippetFormNameHint,
                  prefixIcon: Icon(LucideIcons.tag, size: 18),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.snippetFormNameRequired : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Command
              TextFormField(
                controller: _commandController,
                decoration: InputDecoration(
                  labelText: l10n.snippetFormCommandLabel,
                  hintText: l10n.snippetFormCommandHint,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(LucideIcons.terminal, size: 18),
                  ),
                  alignLabelWithHint: true,
                ),
                style: AppTypography.code(fontSize: 13),
                minLines: 3,
                maxLines: 8,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.snippetFormCommandRequired
                    : null,
              ),
              const SizedBox(height: 8),

              // Detected variables
              if (_detectedVariables.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      const Icon(LucideIcons.variable, size: 14,
                          color: AppColors.accentOrange),
                      const SizedBox(width: 2),
                      Text(
                        l10n.snippetFormVariablesLabel,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.accentOrange,
                        ),
                      ),
                      for (final v in _detectedVariables)
                        Chip(
                          label: Text(
                            '{{$v}}',
                            style: AppTypography.code(fontSize: 11).copyWith(
                              color: AppColors.accentOrange,
                            ),
                          ),
                          backgroundColor:
                              AppColors.accentOrange.withValues(alpha: 0.12),
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                    ],
                  ),
                ),

              // Category
              Autocomplete<String>(
                initialValue: TextEditingValue(text: _categoryController.text),
                optionsBuilder: (value) {
                  if (value.text.isEmpty) return existingCategories;
                  final q = value.text.toLowerCase();
                  return existingCategories
                      .where((c) => c.toLowerCase().contains(q));
                },
                onSelected: (value) => _categoryController.text = value,
                fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                  // Sync autocomplete controller with our controller
                  controller.addListener(() {
                    if (_categoryController.text != controller.text) {
                      _categoryController.text = controller.text;
                    }
                  });
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: l10n.snippetFormCategoryLabel,
                      hintText: l10n.snippetFormCategoryHint,
                      prefixIcon: Icon(LucideIcons.folder, size: 18),
                    ),
                    textInputAction: TextInputAction.next,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.snippetFormDescriptionLabel,
                  hintText: l10n.snippetFormDescriptionHint,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Icon(LucideIcons.fileText, size: 18),
                  ),
                  alignLabelWithHint: true,
                ),
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textInverse,
                          ),
                        )
                      : const Icon(LucideIcons.save, size: 18),
                  label: Text(
                    widget.isEditing ? l10n.snippetFormSaveButtonEdit : l10n.snippetFormSaveButtonNew,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
