/// Host add/edit form screen for CloudShell.
///
/// Provides a form for creating new SSH host connections or
/// editing existing ones, with full validation and advanced
/// settings section. Matches wireframe S3.1.
library;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/validators.dart';
import '../../data/database/app_database.dart';
import '../../data/database/tables/hosts_table.dart';
import '../../providers/connection_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/key_provider.dart';
import '../../services/ssh/ssh_service.dart';
import '../terminal/terminal_screen.dart';

/// Form screen for adding or editing an SSH host.
///
/// Pass an existing [host] to edit, or omit for a new host.
/// Includes advanced section with group, keep-alive, startup
/// command, encoding, and jump host (per wireframe S3.1).
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
  late final TextEditingController _startupCommandController;
  late final TextEditingController _keepAliveController;

  AuthMethodType _authMethod = AuthMethodType.key;
  String? _selectedKeyId;
  String? _selectedGroupId;
  bool _isSaving = false;
  bool _advancedExpanded = false;

  @override
  void initState() {
    super.initState();
    final host = widget.host;
    _labelController = TextEditingController(text: host?.label ?? '');
    _hostnameController = TextEditingController(text: host?.hostname ?? '');
    _portController = TextEditingController(text: '${host?.port ?? 22}');
    _usernameController = TextEditingController(text: host?.username ?? '');
    _notesController = TextEditingController(text: host?.notes ?? '');
    _startupCommandController = TextEditingController(
      text: host?.startupCommand ?? '',
    );
    _keepAliveController = TextEditingController(
      text: '${host?.keepAliveSeconds ?? 60}',
    );
    _authMethod = host?.authMethod ?? AuthMethodType.key;
    _selectedKeyId = host?.keyId;
    _selectedGroupId = host?.groupId;

    // Auto-expand advanced section if any advanced field is filled
    if (host != null &&
        (host.startupCommand != null ||
            host.groupId != null ||
            host.keepAliveSeconds != 60)) {
      _advancedExpanded = true;
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _hostnameController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _notesController.dispose();
    _startupCommandController.dispose();
    _keepAliveController.dispose();
    super.dispose();
  }

  HostsCompanion _buildHostCompanion() {
    final now = DateTime.now();
    final startupCmd = _startupCommandController.text.trim();
    final keepAlive = int.tryParse(_keepAliveController.text.trim()) ?? 60;

    if (widget.isEditing) {
      return HostsCompanion(
        id: Value(widget.host!.id),
        label: Value(_labelController.text.trim()),
        hostname: Value(_hostnameController.text.trim()),
        port: Value(int.parse(_portController.text.trim())),
        username: Value(_usernameController.text.trim()),
        authMethod: Value(_authMethod),
        keyId: Value(_selectedKeyId),
        groupId: Value(_selectedGroupId),
        startupCommand: Value(startupCmd.isEmpty ? null : startupCmd),
        keepAliveSeconds: Value(keepAlive),
        notes: Value(_notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim()),
        updatedAt: Value(now),
      );
    } else {
      return HostsCompanion(
        id: Value(_uuid.v4()),
        label: Value(_labelController.text.trim()),
        hostname: Value(_hostnameController.text.trim()),
        port: Value(int.parse(_portController.text.trim())),
        username: Value(_usernameController.text.trim()),
        authMethod: Value(_authMethod),
        keyId: Value(_selectedKeyId),
        groupId: Value(_selectedGroupId),
        startupCommand: Value(startupCmd.isEmpty ? null : startupCmd),
        keepAliveSeconds: Value(keepAlive),
        notes: Value(_notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim()),
        createdAt: Value(now),
        updatedAt: Value(now),
      );
    }
  }

  Future<Host?> _saveHost() async {
    if (!_formKey.currentState!.validate()) return null;

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      final companion = _buildHostCompanion();

      if (widget.isEditing) {
        await db.hostDao.updateHost(companion);
        return await db.hostDao.getHostById(widget.host!.id);
      } else {
        await db.hostDao.insertHost(companion);
        return await db.hostDao.getHostById(companion.id.value);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save host: $e')),
        );
      }
      return null;
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _save() async {
    final host = await _saveHost();
    if (host != null && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _saveAndConnect() async {
    final host = await _saveHost();
    if (host == null || !mounted) return;

    try {
      final sshService = ref.read(sshServiceProvider);
      final connections = ref.read(activeConnectionsProvider.notifier);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connecting to ${host.label}...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final session = await sshService.connect(host: host);

      connections.addConnection(session.sessionId, host.id);
      connections.updateStatus(session.sessionId, ConnectionStatus.connected);

      if (mounted) {
        // Pop the form, then push the terminal
        Navigator.of(context).pop(true);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TerminalScreen(
              session: session,
              hostLabel: host.label,
            ),
          ),
        );
      }
    } catch (e) {
      ErrorHandler.handle(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.userMessage(e)),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keysAsync = ref.watch(allKeysProvider);
    final groupsAsync = ref.watch(allGroupsProvider);

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
                    onChanged: (value) =>
                        setState(() => _selectedKeyId = value),
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

            // --- Advanced Section (collapsible per wireframe) ---
            _AdvancedSection(
              expanded: _advancedExpanded,
              onToggle: () =>
                  setState(() => _advancedExpanded = !_advancedExpanded),
              children: [
                // Group selector
                groupsAsync.when(
                  data: (groups) {
                    return DropdownButtonFormField<String?>(
                      initialValue: _selectedGroupId,
                      decoration: const InputDecoration(
                        labelText: 'Group',
                        prefixIcon: Icon(LucideIcons.folder, size: 18),
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('No group'),
                        ),
                        ...groups.map((g) => DropdownMenuItem<String?>(
                              value: g.id,
                              child: Text(g.name),
                            )),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedGroupId = value),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _startupCommandController,
                  decoration: const InputDecoration(
                    labelText: 'Startup Command',
                    hintText: 'e.g., cd /var/www && ls -la',
                    prefixIcon: Icon(LucideIcons.terminal, size: 18),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _keepAliveController,
                  decoration: const InputDecoration(
                    labelText: 'Keep Alive (seconds)',
                    hintText: '60',
                    prefixIcon: Icon(LucideIcons.heartPulse, size: 18),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    hintText: 'Any notes about this server...',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(LucideIcons.stickyNote, size: 18),
                  ),
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // --- Action Buttons (per wireframe: Save & Connect + Save) ---
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : _save,
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveAndConnect,
                    icon: const Icon(LucideIcons.play, size: 16),
                    label: const Text('Save & Connect'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
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

/// Collapsible advanced settings section per wireframe S3.1.
class _AdvancedSection extends StatelessWidget {
  const _AdvancedSection({
    required this.expanded,
    required this.onToggle,
    required this.children,
  });

  final bool expanded;
  final VoidCallback onToggle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  expanded
                      ? LucideIcons.chevronDown
                      : LucideIcons.chevronRight,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 8),
                Text(
                  'ADVANCED',
                  style: AppTypography.overline
                      .copyWith(color: AppColors.textTertiary),
                ),
                const Spacer(),
                Text(
                  expanded ? 'collapse' : 'expand',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ),
        if (expanded) ...[
          const SizedBox(height: 8),
          ...children,
        ],
      ],
    );
  }
}
