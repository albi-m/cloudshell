/// Host add/edit form screen for CloudShell.
///
/// Provides a form for creating new SSH host connections or
/// editing existing ones, with full validation.
library;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/validators.dart';
import '../../data/database/app_database.dart';
import '../../data/database/tables/hosts_table.dart';
import '../../providers/key_provider.dart';

/// Form screen for adding or editing an SSH host.
///
/// Pass an existing [host] to edit, or omit for a new host.
class HostFormScreen extends ConsumerStatefulWidget {
  const HostFormScreen({super.key, this.host});

  /// Existing host to edit. Null for creating a new host.
  final Host? host;

  bool get isEditing => host != null;

  @override
  ConsumerState<HostFormScreen> createState() => _HostFormScreenState();
}

class _HostFormScreenState extends ConsumerState<HostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  static const _uuid = Uuid();

  // Form controllers
  late final TextEditingController _labelController;
  late final TextEditingController _hostnameController;
  late final TextEditingController _portController;
  late final TextEditingController _usernameController;
  late final TextEditingController _notesController;

  AuthMethodType _authMethod = AuthMethodType.key;
  String? _selectedKeyId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final host = widget.host;
    _labelController = TextEditingController(text: host?.label ?? '');
    _hostnameController = TextEditingController(text: host?.hostname ?? '');
    _portController = TextEditingController(text: '${host?.port ?? 22}');
    _usernameController = TextEditingController(text: host?.username ?? '');
    _notesController = TextEditingController(text: host?.notes ?? '');
    _authMethod = host?.authMethod ?? AuthMethodType.key;
    _selectedKeyId = host?.keyId;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _hostnameController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();

      if (widget.isEditing) {
        await db.hostDao.updateHost(HostsCompanion(
          id: Value(widget.host!.id),
          label: Value(_labelController.text.trim()),
          hostname: Value(_hostnameController.text.trim()),
          port: Value(int.parse(_portController.text.trim())),
          username: Value(_usernameController.text.trim()),
          authMethod: Value(_authMethod),
          keyId: Value(_selectedKeyId),
          notes: Value(_notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim()),
          updatedAt: Value(now),
        ));
      } else {
        await db.hostDao.insertHost(HostsCompanion(
          id: Value(_uuid.v4()),
          label: Value(_labelController.text.trim()),
          hostname: Value(_hostnameController.text.trim()),
          port: Value(int.parse(_portController.text.trim())),
          username: Value(_usernameController.text.trim()),
          authMethod: Value(_authMethod),
          keyId: Value(_selectedKeyId),
          notes: Value(_notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim()),
          createdAt: Value(now),
          updatedAt: Value(now),
        ));
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save host: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keysAsync = ref.watch(allKeysProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Host' : 'Add Host',
          style: AppTypography.h1,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- Connection Section ---
            _SectionHeader(title: 'CONNECTION'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _labelController,
              decoration: const InputDecoration(
                labelText: 'Label',
                hintText: 'e.g., Production Web Server',
                prefixIcon: Icon(LucideIcons.tag, size: 18),
              ),
              validator: Validators.label,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _hostnameController,
              decoration: const InputDecoration(
                labelText: 'Hostname / IP',
                hintText: 'e.g., 192.168.1.1 or server.example.com',
                prefixIcon: Icon(LucideIcons.globe, size: 18),
              ),
              validator: Validators.hostname,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              autocorrect: false,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'e.g., root',
                      prefixIcon: Icon(LucideIcons.user, size: 18),
                    ),
                    validator: Validators.username,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _portController,
                    decoration: const InputDecoration(
                      labelText: 'Port',
                      hintText: '22',
                    ),
                    validator: Validators.port,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- Authentication Section ---
            _SectionHeader(title: 'AUTHENTICATION'),
            const SizedBox(height: 8),
            _AuthMethodSelector(
              value: _authMethod,
              onChanged: (method) => setState(() => _authMethod = method),
            ),

            // SSH Key selector (shown for key-based auth)
            if (_authMethod == AuthMethodType.key ||
                _authMethod == AuthMethodType.keyAndPassword) ...[
              const SizedBox(height: 12),
              keysAsync.when(
                data: (keys) {
                  if (keys.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Text(
                        'No SSH keys available. Import one in the Keys tab.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedKeyId,
                    decoration: const InputDecoration(
                      labelText: 'SSH Key',
                      prefixIcon: Icon(LucideIcons.keyRound, size: 18),
                    ),
                    items: keys.map((key) {
                      return DropdownMenuItem(
                        value: key.id,
                        child: Text(key.label),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedKeyId = value),
                    validator: (value) {
                      if (value == null) return 'Please select an SSH key';
                      return null;
                    },
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => Text(
                  'Failed to load SSH keys',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.accentRed,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // --- Notes Section ---
            _SectionHeader(title: 'NOTES'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Any notes about this server...',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Section header label for form groups.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.overline.copyWith(color: AppColors.textTertiary),
    );
  }
}

/// Authentication method selector (segmented control).
class _AuthMethodSelector extends StatelessWidget {
  const _AuthMethodSelector({
    required this.value,
    required this.onChanged,
  });

  final AuthMethodType value;
  final ValueChanged<AuthMethodType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AuthMethodType>(
      segments: const [
        ButtonSegment(
          value: AuthMethodType.key,
          label: Text('Key'),
          icon: Icon(LucideIcons.keyRound, size: 16),
        ),
        ButtonSegment(
          value: AuthMethodType.password,
          label: Text('Password'),
          icon: Icon(LucideIcons.lock, size: 16),
        ),
        ButtonSegment(
          value: AuthMethodType.keyAndPassword,
          label: Text('Both'),
          icon: Icon(LucideIcons.shieldCheck, size: 16),
        ),
      ],
      selected: {value},
      onSelectionChanged: (selected) => onChanged(selected.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentPrimary.withValues(alpha: 0.15);
          }
          return AppColors.bgSurface;
        }),
      ),
    );
  }
}
