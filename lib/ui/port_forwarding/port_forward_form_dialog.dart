/// Form dialog for creating or editing a port forwarding rule.
///
/// Provides fields for label, type (local/remote), host selection,
/// source port, destination host/port, and auto-start toggle.
library;

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
import '../../data/database/tables/port_forwards_table.dart';
import '../../providers/host_provider.dart';

/// Dialog form for adding a new port forwarding rule.
class PortForwardFormDialog extends ConsumerStatefulWidget {
  const PortForwardFormDialog({super.key});

  @override
  ConsumerState<PortForwardFormDialog> createState() =>
      _PortForwardFormDialogState();
}

class _PortForwardFormDialogState extends ConsumerState<PortForwardFormDialog> {
  static const _uuid = Uuid();
  final _formKey = GlobalKey<FormState>();

  final _labelController = TextEditingController();
  final _sourcePortController = TextEditingController();
  final _destHostController = TextEditingController(text: 'localhost');
  final _destPortController = TextEditingController();

  PortForwardTypeEnum _type = PortForwardTypeEnum.local;
  String? _selectedHostId;
  bool _autoStart = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _labelController.dispose();
    _sourcePortController.dispose();
    _destHostController.dispose();
    _destPortController.dispose();
    super.dispose();
  }

  String? _validatePort(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final port = int.tryParse(value.trim());
    if (port == null || port < 1 || port > 65535) {
      return 'Port must be 1–65535';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedHostId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).portForwardFormSelectHost)),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();

      final companion = PortForwardsCompanion(
        id: Value(_uuid.v4()),
        label: Value(_labelController.text.trim()),
        type: Value(_type),
        hostId: Value(_selectedHostId!),
        sourcePort: Value(int.parse(_sourcePortController.text.trim())),
        destinationHost: Value(_destHostController.text.trim().isEmpty
            ? null
            : _destHostController.text.trim()),
        destinationPort: Value(_destPortController.text.trim().isEmpty
            ? null
            : int.parse(_destPortController.text.trim())),
        autoStart: Value(_autoStart),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await db.portForwardDao.insertPortForward(companion);

      if (mounted) Navigator.of(context).pop(true);
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.userMessage(e))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hostsAsync = ref.watch(allHostsProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.portForwardFormTitleNew, style: AppTypography.h2),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label
                TextFormField(
                  controller: _labelController,
                  decoration: InputDecoration(
                    labelText: l10n.portForwardFormLabelField,
                    hintText: l10n.portForwardFormLabelHint,
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Type selector
                SegmentedButton<PortForwardTypeEnum>(
                  segments: [
                    ButtonSegment(
                      value: PortForwardTypeEnum.local,
                      label: Text(l10n.portForwardFormTypeLocal),
                      icon: const Icon(LucideIcons.arrowDownToLine, size: 16),
                    ),
                    ButtonSegment(
                      value: PortForwardTypeEnum.remote,
                      label: Text(l10n.portForwardFormTypeRemote),
                      icon: const Icon(LucideIcons.arrowUpFromLine, size: 16),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (selected) =>
                      setState(() => _type = selected.first),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.accentPrimary.withValues(alpha: 0.15);
                      }
                      return null;
                    }),
                  ),
                ),
                const SizedBox(height: 16),

                // Host selector
                hostsAsync.when(
                  data: (hosts) {
                    if (hosts.isEmpty) {
                      return Text(
                        l10n.portForwardFormNoHostsAvailable,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      );
                    }
                    // Reset if the selected host no longer exists
                    final hostIds = hosts.map((h) => h.id).toSet();
                    if (_selectedHostId != null &&
                        !hostIds.contains(_selectedHostId)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() => _selectedHostId = null);
                        }
                      });
                    }
                    final safeHostId = _selectedHostId != null &&
                            hostIds.contains(_selectedHostId)
                        ? _selectedHostId
                        : null;
                    return DropdownButtonFormField<String?>(
                      initialValue: safeHostId,
                      decoration: InputDecoration(
                        labelText: l10n.portForwardFormHostField,
                      ),
                      items: hosts
                          .map((h) => DropdownMenuItem<String?>(
                                value: h.id,
                                child: Text('${h.label} (${h.hostname})'),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedHostId = v),
                      validator: (v) =>
                          v == null || v.isEmpty ? l10n.portForwardFormSelectHost : null,
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => Text(l10n.portForwardFormCouldNotLoadHosts),
                ),
                const SizedBox(height: 16),

                // Source port
                TextFormField(
                  controller: _sourcePortController,
                  decoration: InputDecoration(
                    labelText: _type == PortForwardTypeEnum.local
                        ? l10n.portForwardFormLocalPortField
                        : l10n.portForwardFormRemotePortField,
                    hintText: l10n.portForwardFormPortHint,
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validatePort,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),

                // Destination host + port
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _destHostController,
                        decoration: InputDecoration(
                          labelText: l10n.portForwardFormDestHostField,
                          hintText: l10n.portForwardFormDestHostHint,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _destPortController,
                        decoration: InputDecoration(
                          labelText: l10n.portForwardFormDestPortField,
                          hintText: l10n.portForwardFormDestPortHint,
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validatePort,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Auto-start toggle
                SwitchListTile(
                  title: Text(l10n.portForwardFormAutoStart,
                      style: AppTypography.body.copyWith(
                        color: theme.colorScheme.onSurface,
                      )),
                  subtitle: Text(
                    l10n.portForwardFormAutoStartSubtitle,
                    style: AppTypography.caption,
                  ),
                  value: _autoStart,
                  onChanged: (v) => setState(() => _autoStart = v),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
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
              : Text(l10n.save),
        ),
      ],
    );
  }
}
