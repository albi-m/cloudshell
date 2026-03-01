/// Group create/edit dialog for managing host groups.
///
/// Provides a dialog for creating new groups or editing
/// existing ones, with name validation.
library;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/validators.dart';
import '../../l10n/app_localizations.dart';
import '../../data/database/app_database.dart';
import '../../providers/group_provider.dart';

/// Shows a dialog to create or edit a host group.
///
/// Pass an existing [group] to edit it; omit it to create a new group.
/// Returns the group ID if saved successfully, or null if the user cancelled.
Future<String?> showGroupFormDialog(
  BuildContext context, {
  HostGroup? group,
}) async {
  return showDialog<String>(
    context: context,
    builder: (context) => _GroupFormDialog(group: group),
  );
}

class _GroupFormDialog extends ConsumerStatefulWidget {
  const _GroupFormDialog({this.group});

  final HostGroup? group;

  @override
  ConsumerState<_GroupFormDialog> createState() => _GroupFormDialogState();
}

class _GroupFormDialogState extends ConsumerState<_GroupFormDialog> {
  static const _uuid = Uuid();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _defaultUsernameController;
  late final TextEditingController _defaultPortController;
  String? _parentGroupId;
  bool _isSaving = false;

  bool get _isEditing => widget.group != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group?.name ?? '');
    _defaultUsernameController = TextEditingController(
      text: widget.group?.defaultUsername ?? '',
    );
    _defaultPortController = TextEditingController(
      text: widget.group?.defaultPort?.toString() ?? '',
    );
    _parentGroupId = widget.group?.parentGroupId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _defaultUsernameController.dispose();
    _defaultPortController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();
      final name = _nameController.text.trim();
      final defaultUsername = _defaultUsernameController.text.trim();
      final defaultPort = int.tryParse(_defaultPortController.text.trim());

      if (_isEditing) {
        await db.groupDao.updateGroup(HostGroupsCompanion(
          id: Value(widget.group!.id),
          name: Value(name),
          parentGroupId: Value(_parentGroupId),
          defaultUsername:
              Value(defaultUsername.isEmpty ? null : defaultUsername),
          defaultPort: Value(defaultPort),
          updatedAt: Value(now),
        ));
        if (mounted) Navigator.of(context).pop(widget.group!.id);
      } else {
        final id = _uuid.v4();
        await db.groupDao.insertGroup(HostGroupsCompanion(
          id: Value(id),
          name: Value(name),
          parentGroupId: Value(_parentGroupId),
          defaultUsername:
              Value(defaultUsername.isEmpty ? null : defaultUsername),
          defaultPort: Value(defaultPort),
          createdAt: Value(now),
          updatedAt: Value(now),
        ));
        if (mounted) Navigator.of(context).pop(id);
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.userMessage(e))),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final groupsAsync = ref.watch(allGroupsProvider);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(LucideIcons.folderPlus, size: 20),
          const SizedBox(width: 8),
          Text(
            _isEditing ? l10n.groupFormTitleEdit : l10n.groupFormTitleNew,
            style: AppTypography.h2,
          ),
        ],
      ),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.groupFormNameField,
                  hintText: l10n.groupFormNameHint,
                  prefixIcon: const Icon(LucideIcons.folder, size: 18),
                ),
                validator: Validators.label,
                autofocus: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // Parent group selector
              groupsAsync.when(
                data: (groups) {
                  // Exclude self and own descendants to prevent cycles
                  final editingId = widget.group?.id;
                  final available = groups
                      .where((g) => g.id != editingId)
                      .toList();
                  return DropdownButtonFormField<String?>(
                    initialValue: _parentGroupId,
                    decoration: InputDecoration(
                      labelText: l10n.groupFormParentField,
                      prefixIcon: const Icon(LucideIcons.folderTree, size: 18),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l10n.groupFormParentNone),
                      ),
                      ...available.map((g) => DropdownMenuItem<String?>(
                            value: g.id,
                            child: Text(g.name),
                          )),
                    ],
                    onChanged: (value) =>
                        setState(() => _parentGroupId = value),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _defaultUsernameController,
                decoration: InputDecoration(
                  labelText: l10n.hostFormUsernameField,
                  hintText: l10n.hostFormUsernameHint,
                  prefixIcon: const Icon(LucideIcons.user, size: 18),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _defaultPortController,
                decoration: InputDecoration(
                  labelText: l10n.hostFormPortField,
                  hintText: '22',
                  prefixIcon: const Icon(LucideIcons.hash, size: 18),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final n = int.tryParse(value.trim());
                  if (n == null || n < 1 || n > 65535) {
                    return l10n.hostFormHostnameRequired;
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEditing ? l10n.save : l10n.confirm),
        ),
      ],
    );
  }
}
