/// Host add/edit form screen for CloudShell.
///
/// Provides a form for creating new SSH host connections or
/// editing existing ones, with full validation and advanced
/// settings section. Matches wireframe S3.1.
library;

import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/validators.dart';
import '../../l10n/app_localizations.dart';
import '../../data/database/app_database.dart';
import '../../data/database/tables/hosts_table.dart';
import '../../providers/connection_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/host_provider.dart';
import '../../providers/key_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/terminal_tab_provider.dart';
import '../../providers/workspace_provider.dart';
import '../../services/connection/connection_session.dart';
import '../../services/crypto/secure_storage.dart';
import '../../services/port_forwarding/port_forward_service.dart';
import '../../services/serial/serial_service.dart';
import '../../services/ssh/ssh_service.dart';
import '../../services/telnet/telnet_service.dart';

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
  late final TextEditingController _passwordController;
  late final TextEditingController _tagsController;

  ProtocolType _protocol = ProtocolType.ssh;
  AuthMethodType _authMethod = AuthMethodType.key;
  String? _selectedKeyId;
  String? _selectedGroupId;
  String? _selectedJumpHostId;
  bool _isSaving = false;
  bool _advancedExpanded = false;
  bool _obscurePassword = true;

  // Serial-specific state
  String? _selectedSerialPort;
  int _serialBaudRate = 115200;
  int _serialDataBits = 8;
  int _serialStopBits = 1;
  String _serialParity = 'none';
  String _serialFlowControl = 'none';
  List<String> _availableSerialPorts = [];

  @override
  void initState() {
    super.initState();
    final host = widget.host;
    final defaultPort = host?.port ?? ref.read(defaultSshPortProvider);
    final defaultKeepAlive =
        host?.keepAliveSeconds ?? ref.read(defaultKeepAliveProvider);
    _labelController = TextEditingController(text: host?.label ?? '');
    _hostnameController = TextEditingController(text: host?.hostname ?? '');
    _portController = TextEditingController(text: '$defaultPort');
    _usernameController = TextEditingController(text: host?.username ?? '');
    _notesController = TextEditingController(text: host?.notes ?? '');
    _startupCommandController = TextEditingController(
      text: host?.startupCommand ?? '',
    );
    _keepAliveController = TextEditingController(
      text: '$defaultKeepAlive',
    );
    _passwordController = TextEditingController();
    _tagsController = TextEditingController(text: host?.tags ?? '');
    _authMethod = host?.authMethod ?? AuthMethodType.key;
    _selectedKeyId = host?.keyId;
    _selectedGroupId = host?.groupId;
    _selectedJumpHostId = host?.jumpHostId;
    _protocol = host?.protocol ?? ProtocolType.ssh;

    // Load serial config if editing a serial host
    if (host != null && host.protocol == ProtocolType.serial) {
      _selectedSerialPort = host.serialPort;
      _serialBaudRate = host.serialBaudRate ?? 115200;
      _serialDataBits = host.serialDataBits ?? 8;
      _serialStopBits = host.serialStopBits ?? 1;
      _serialParity = host.serialParity ?? 'none';
      _serialFlowControl = host.serialFlowControl ?? 'none';
    }

    // Enumerate available serial ports on desktop.
    if (SerialService.isSupported) {
      _availableSerialPorts = SerialService.availablePorts();
    }

    // Load existing password from secure storage if editing
    if (host != null &&
        (host.authMethod == AuthMethodType.password ||
            host.authMethod == AuthMethodType.keyAndPassword)) {
      _loadExistingPassword(host.id);
    }

    // Auto-expand advanced section if any advanced field is filled
    if (host != null &&
        (host.startupCommand != null ||
            host.groupId != null ||
            host.jumpHostId != null ||
            host.keepAliveSeconds != 60 ||
            host.tags.isNotEmpty)) {
      _advancedExpanded = true;
    }
  }

  Future<void> _loadExistingPassword(String hostId) async {
    final secureStorage = ref.read(secureStorageProvider);
    final password = await secureStorage.getHostPassword(hostId);
    if (password != null && mounted) {
      _passwordController.text = password;
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
    _passwordController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  HostsCompanion _buildHostCompanion() {
    final now = DateTime.now();
    final startupCmd = _startupCommandController.text.trim();
    final keepAlive = int.tryParse(_keepAliveController.text.trim()) ?? 60;
    final tags = _tagsController.text.trim();

    // Serial-specific columns.
    final serialPort = _protocol == ProtocolType.serial
        ? Value<String?>(_selectedSerialPort)
        : const Value<String?>.absent();
    final serialBaudRate = _protocol == ProtocolType.serial
        ? Value<int?>(_serialBaudRate)
        : const Value<int?>.absent();
    final serialDataBits = _protocol == ProtocolType.serial
        ? Value<int?>(_serialDataBits)
        : const Value<int?>.absent();
    final serialStopBits = _protocol == ProtocolType.serial
        ? Value<int?>(_serialStopBits)
        : const Value<int?>.absent();
    final serialParity = _protocol == ProtocolType.serial
        ? Value<String?>(_serialParity)
        : const Value<String?>.absent();
    final serialFlowControl = _protocol == ProtocolType.serial
        ? Value<String?>(_serialFlowControl)
        : const Value<String?>.absent();

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
        jumpHostId: Value(_selectedJumpHostId),
        startupCommand: Value(startupCmd.isEmpty ? null : startupCmd),
        keepAliveSeconds: Value(keepAlive),
        tags: Value(tags),
        notes: Value(_notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim()),
        updatedAt: Value(now),
        protocol: Value(_protocol),
        serialPort: serialPort,
        serialBaudRate: serialBaudRate,
        serialDataBits: serialDataBits,
        serialStopBits: serialStopBits,
        serialParity: serialParity,
        serialFlowControl: serialFlowControl,
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
        jumpHostId: Value(_selectedJumpHostId),
        startupCommand: Value(startupCmd.isEmpty ? null : startupCmd),
        keepAliveSeconds: Value(keepAlive),
        tags: Value(tags),
        notes: Value(_notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim()),
        createdAt: Value(now),
        updatedAt: Value(now),
        protocol: Value(_protocol),
        serialPort: serialPort,
        serialBaudRate: serialBaudRate,
        serialDataBits: serialDataBits,
        serialStopBits: serialStopBits,
        serialParity: serialParity,
        serialFlowControl: serialFlowControl,
      );
    }
  }

  Future<Host?> _saveHost() async {
    if (!_formKey.currentState!.validate()) return null;
    final l10n = AppLocalizations.of(context);

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      final secureStorage = ref.read(secureStorageProvider);
      final companion = _buildHostCompanion();
      final hostId = companion.id.value;

      if (widget.isEditing) {
        await db.hostDao.updateHost(companion);
      } else {
        await db.hostDao.insertHost(companion);
      }

      // Store or delete password in secure storage
      final password = _passwordController.text;
      if ((_authMethod == AuthMethodType.password ||
              _authMethod == AuthMethodType.keyAndPassword) &&
          password.isNotEmpty) {
        await secureStorage.storeHostPassword(hostId, password);
      } else {
        // Clean up password if auth method changed away from password
        await secureStorage.deleteHostPassword(hostId);
      }

      return await db.hostDao.getHostById(hostId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.hostFormTestConnectionFailed('$e'))),
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
    final l10n = AppLocalizations.of(context);

    try {
      final connections = ref.read(activeConnectionsProvider.notifier);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.hostsMenuConnect}: ${host.label}...'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Create session based on protocol type.
      final ConnectionSession session;
      switch (host.protocol) {
        case ProtocolType.ssh:
          final sshService = ref.read(sshServiceProvider);
          final sshSession = await sshService.connect(host: host);
          // Auto-start port forwards for SSH only (fire-and-forget).
          final pfService = ref.read(portForwardServiceProvider);
          unawaited(pfService.autoStartForwards(sshSession.client, host.id));
          session = sshSession;
        case ProtocolType.telnet:
          final telnetService = ref.read(telnetServiceProvider);
          session = await telnetService.connect(host: host);
        case ProtocolType.serial:
          final serialService = ref.read(serialServiceProvider);
          session = await serialService.connect(host: host);
      }

      connections.addConnection(session.sessionId, host.id);
      connections.updateStatus(session.sessionId, ConnectionStatus.connected);

      // Add terminal tab + workspace tab (provider owns xterm state)
      await ref.read(terminalTabsProvider.notifier).addTab(
            session,
            host.label,
          );
      ref.read(workspaceProvider.notifier).openTerminalTab(
            session.sessionId,
            host.label,
          );

      if (mounted) {
        Navigator.of(context).pop(true);
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
    final l10n = AppLocalizations.of(context);
    final keysAsync = ref.watch(allKeysProvider);
    final groupsAsync = ref.watch(allGroupsProvider);
    final hostsAsync = ref.watch(allHostsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? l10n.hostFormTitleEdit : l10n.hostFormTitleNew,
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
                  : Text(l10n.save),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- Protocol Selector ---
            _SectionHeader(title: l10n.hostDetailLabelProtocol),
            const SizedBox(height: 8),
            _ProtocolSelector(
              value: _protocol,
              onChanged: (protocol) {
                setState(() {
                  _protocol = protocol;
                  // Adjust default port when switching protocols.
                  if (protocol == ProtocolType.telnet) {
                    _portController.text = '23';
                  } else if (protocol == ProtocolType.ssh) {
                    _portController.text = '${ref.read(defaultSshPortProvider)}';
                  }
                });
              },
            ),

            // Telnet warning banner
            if (_protocol == ProtocolType.telnet) ...[
              const SizedBox(height: 12),
              const _TelnetWarningBanner(),
            ],

            const SizedBox(height: 24),

            // --- Serial Port Configuration (only for serial protocol) ---
            if (_protocol == ProtocolType.serial) ...[
              _SectionHeader(title: l10n.hostFormSerialPortField),
              const SizedBox(height: 8),
              TextFormField(
                controller: _labelController,
                decoration: InputDecoration(
                  labelText: l10n.hostFormLabelField,
                  hintText: l10n.hostFormLabelHint,
                  prefixIcon: const Icon(LucideIcons.tag, size: 18),
                ),
                validator: Validators.label,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedSerialPort,
                      decoration: InputDecoration(
                        labelText: l10n.hostFormSerialPortField,
                        prefixIcon: const Icon(LucideIcons.usb, size: 18),
                      ),
                      items: _availableSerialPorts
                          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedSerialPort = v),
                      validator: (v) =>
                          v == null ? l10n.hostFormSerialPortNone : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(LucideIcons.refreshCw, size: 18),
                    tooltip: l10n.retry,
                    onPressed: () {
                      setState(() {
                        _availableSerialPorts = SerialService.availablePorts();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _serialBaudRate,
                decoration: InputDecoration(
                  labelText: l10n.hostFormSerialBaudRateField,
                  prefixIcon: const Icon(LucideIcons.gauge, size: 18),
                ),
                items: serialBaudRates
                    .map((r) => DropdownMenuItem(value: r, child: Text('$r')))
                    .toList(),
                onChanged: (v) => setState(() => _serialBaudRate = v ?? 115200),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _serialDataBits,
                      decoration: InputDecoration(labelText: l10n.hostFormSerialDataBitsField),
                      items: [5, 6, 7, 8]
                          .map((b) => DropdownMenuItem(value: b, child: Text('$b')))
                          .toList(),
                      onChanged: (v) => setState(() => _serialDataBits = v ?? 8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _serialStopBits,
                      decoration: InputDecoration(labelText: l10n.hostFormSerialStopBitsField),
                      items: [1, 2]
                          .map((b) => DropdownMenuItem(value: b, child: Text('$b')))
                          .toList(),
                      onChanged: (v) => setState(() => _serialStopBits = v ?? 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _serialParity,
                      decoration: InputDecoration(labelText: l10n.hostFormSerialParityField),
                      items: ['none', 'odd', 'even', 'mark', 'space']
                          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _serialParity = v ?? 'none'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _serialFlowControl,
                      decoration: InputDecoration(labelText: l10n.hostFormSerialFlowControlField),
                      items: ['none', 'hardware', 'software']
                          .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _serialFlowControl = v ?? 'none'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // --- Connection Section (SSH + Telnet only) ---
            if (_protocol != ProtocolType.serial) ...[
              _SectionHeader(title: l10n.hostDetailSectionConnection),
              const SizedBox(height: 8),
              TextFormField(
                controller: _labelController,
                decoration: InputDecoration(
                  labelText: l10n.hostFormLabelField,
                  hintText: l10n.hostFormLabelHint,
                  prefixIcon: const Icon(LucideIcons.tag, size: 18),
                ),
                validator: Validators.label,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hostnameController,
                decoration: InputDecoration(
                  labelText: l10n.hostFormHostnameField,
                  hintText: l10n.hostFormHostnameHint,
                  prefixIcon: const Icon(LucideIcons.globe, size: 18),
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
                      decoration: InputDecoration(
                        labelText: l10n.hostFormUsernameField,
                        hintText: l10n.hostFormUsernameHint,
                        prefixIcon: const Icon(LucideIcons.user, size: 18),
                      ),
                      validator: _protocol == ProtocolType.ssh
                          ? Validators.username
                          : null,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _portController,
                      decoration: InputDecoration(
                        labelText: l10n.hostFormPortField,
                        hintText: _protocol == ProtocolType.telnet ? '23' : '22',
                      ),
                      validator: Validators.port,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // --- Authentication Section (SSH only) ---
            if (_protocol == ProtocolType.ssh) ...[
              _SectionHeader(title: l10n.hostDetailSectionAuthentication),
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
                          l10n.hostFormKeyNone,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }
                    // Reset to null if the selected key was deleted
                    final keyIds = keys.map((k) => k.id).toSet();
                    if (_selectedKeyId != null &&
                        !keyIds.contains(_selectedKeyId)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() => _selectedKeyId = null);
                        }
                      });
                    }
                    final safeKeyId = _selectedKeyId != null &&
                            keyIds.contains(_selectedKeyId)
                        ? _selectedKeyId
                        : null;
                    return DropdownButtonFormField<String?>(
                      initialValue: safeKeyId,
                      decoration: InputDecoration(
                        labelText: l10n.hostFormKeyField,
                        prefixIcon: const Icon(LucideIcons.keyRound, size: 18),
                      ),
                      items: keys.map((key) {
                        return DropdownMenuItem<String?>(
                          value: key.id,
                          child: Text(key.label),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedKeyId = value),
                      validator: (value) {
                        if (value == null) return l10n.hostFormKeyNone;
                        return null;
                      },
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => Text(
                    l10n.error,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.accentRed,
                    ),
                  ),
                ),
              ],

              // Password field (shown for password-based auth)
              if (_authMethod == AuthMethodType.password ||
                  _authMethod == AuthMethodType.keyAndPassword) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: l10n.hostFormPasswordField,
                    prefixIcon: const Icon(LucideIcons.lock, size: 18),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? LucideIcons.eyeOff
                            : LucideIcons.eye,
                        size: 18,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) {
                    if (_authMethod == AuthMethodType.password &&
                        (value == null || value.isEmpty)) {
                      return l10n.hostFormPasswordHint;
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 24),
            ],

            // --- Advanced Section (collapsible per wireframe) ---
            _AdvancedSection(
              expanded: _advancedExpanded,
              onToggle: () =>
                  setState(() => _advancedExpanded = !_advancedExpanded),
              children: [
                // Group selector
                groupsAsync.when(
                  data: (groups) {
                    // Reset to null if the selected group was deleted
                    final groupIds = groups.map((g) => g.id).toSet();
                    if (_selectedGroupId != null &&
                        !groupIds.contains(_selectedGroupId)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() => _selectedGroupId = null);
                        }
                      });
                    }
                    final safeGroupId = _selectedGroupId != null &&
                            groupIds.contains(_selectedGroupId)
                        ? _selectedGroupId
                        : null;
                    return DropdownButtonFormField<String?>(
                      initialValue: safeGroupId,
                      decoration: InputDecoration(
                        labelText: l10n.hostFormGroupField,
                        prefixIcon: const Icon(LucideIcons.folder, size: 18),
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.hostFormGroupNone),
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
                // Jump host / proxy jump selector
                hostsAsync.when(
                  data: (hosts) {
                    // Exclude the current host from the list to prevent self-reference
                    final currentId = widget.host?.id;
                    final availableHosts = hosts
                        .where((h) => h.id != currentId)
                        .toList();
                    // Reset to null if the selected jump host was deleted
                    final hostIds = availableHosts.map((h) => h.id).toSet();
                    if (_selectedJumpHostId != null &&
                        !hostIds.contains(_selectedJumpHostId)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() => _selectedJumpHostId = null);
                        }
                      });
                    }
                    final safeJumpHostId = _selectedJumpHostId != null &&
                            hostIds.contains(_selectedJumpHostId)
                        ? _selectedJumpHostId
                        : null;
                    return DropdownButtonFormField<String?>(
                      initialValue: safeJumpHostId,
                      decoration: InputDecoration(
                        labelText: l10n.hostFormJumpHostField,
                        prefixIcon: const Icon(LucideIcons.gitBranch, size: 18),
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.hostFormJumpHostNone),
                        ),
                        ...availableHosts.map((h) => DropdownMenuItem<String?>(
                              value: h.id,
                              child: Text('${h.label} (${h.hostname})'),
                            )),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedJumpHostId = value),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _startupCommandController,
                  decoration: InputDecoration(
                    labelText: l10n.hostFormStartupCommandField,
                    hintText: l10n.hostFormStartupCommandHint,
                    prefixIcon: const Icon(LucideIcons.terminal, size: 18),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _keepAliveController,
                  decoration: InputDecoration(
                    labelText: l10n.hostFormKeepAliveField,
                    hintText: '60',
                    prefixIcon: const Icon(LucideIcons.heartPulse, size: 18),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    labelText: l10n.hostFormTagsField,
                    hintText: l10n.hostFormTagsHint,
                    prefixIcon: const Icon(LucideIcons.tags, size: 18),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: l10n.hostFormNotesField,
                    hintText: l10n.hostFormNotesHint,
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(LucideIcons.stickyNote, size: 18),
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
                    child: Text(l10n.save),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveAndConnect,
                    icon: const Icon(LucideIcons.play, size: 16),
                    label: Text('${l10n.save} & ${l10n.hostsMenuConnect}'),
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
    final l10n = AppLocalizations.of(context);
    return SegmentedButton<AuthMethodType>(
      segments: [
        ButtonSegment(
          value: AuthMethodType.key,
          label: Text(l10n.hostFormAuthMethodKey),
          icon: const Icon(LucideIcons.keyRound, size: 16),
        ),
        ButtonSegment(
          value: AuthMethodType.password,
          label: Text(l10n.hostFormAuthMethodPassword),
          icon: const Icon(LucideIcons.lock, size: 16),
        ),
        ButtonSegment(
          value: AuthMethodType.keyAndPassword,
          label: Text(l10n.hostFormAuthMethodKeyAndPassword),
          icon: const Icon(LucideIcons.shieldCheck, size: 16),
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

/// Protocol type selector (segmented control).
class _ProtocolSelector extends StatelessWidget {
  const _ProtocolSelector({
    required this.value,
    required this.onChanged,
  });

  final ProtocolType value;
  final ValueChanged<ProtocolType> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Hide serial option on iOS (not supported).
    final showSerial = SerialService.isSupported;
    return SegmentedButton<ProtocolType>(
      segments: [
        ButtonSegment(
          value: ProtocolType.ssh,
          label: Text(l10n.hostFormProtocolSsh),
          icon: const Icon(LucideIcons.terminal, size: 16),
        ),
        ButtonSegment(
          value: ProtocolType.telnet,
          label: Text(l10n.hostFormProtocolTelnet),
          icon: const Icon(LucideIcons.globe, size: 16),
        ),
        if (showSerial)
          ButtonSegment(
            value: ProtocolType.serial,
            label: Text(l10n.hostFormProtocolSerial),
            icon: const Icon(LucideIcons.usb, size: 16),
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

/// Warning banner shown when Telnet protocol is selected.
class _TelnetWarningBanner extends StatelessWidget {
  const _TelnetWarningBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accentOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accentOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.alertTriangle,
              size: 16, color: AppColors.accentOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Telnet sends all data in plaintext. Only use on trusted networks.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.accentOrange,
              ),
            ),
          ),
        ],
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
    final l10n = AppLocalizations.of(context);
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
                  l10n.hostFormAdvancedSection,
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
