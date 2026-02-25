/// Quick connect dialog for ad-hoc SSH connections.
///
/// Allows users to quickly connect to a server by typing
/// user@hostname:port without creating a saved host entry.
/// Optionally saves the connection for future use.
library;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../data/database/app_database.dart';
import '../../data/database/tables/hosts_table.dart';
import '../../providers/connection_provider.dart';
import '../../providers/key_provider.dart';
import '../../providers/terminal_tab_provider.dart';
import '../../services/ssh/ssh_service.dart';
import '../../services/telnet/telnet_service.dart';

/// Shows the quick connect dialog and returns true if a connection
/// was established.
Future<bool> showQuickConnectDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => const _QuickConnectDialog(),
  );
  return result ?? false;
}

/// Parsed result from a user@hostname:port string.
class _ParsedConnection {
  const _ParsedConnection({
    required this.username,
    required this.hostname,
    required this.port,
  });

  final String username;
  final String hostname;
  final int port;

  /// Parses a connection string in the format [user@]hostname[:port].
  ///
  /// Returns null if the format is invalid.
  static _ParsedConnection? tryParse(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    String username = 'root';
    String hostPart = trimmed;

    // Extract username if present
    final atIndex = trimmed.indexOf('@');
    if (atIndex > 0) {
      username = trimmed.substring(0, atIndex);
      hostPart = trimmed.substring(atIndex + 1);
    }

    // Extract port if present
    int port = 22;
    final colonIndex = hostPart.lastIndexOf(':');
    String hostname = hostPart;

    if (colonIndex > 0) {
      final portStr = hostPart.substring(colonIndex + 1);
      final parsedPort = int.tryParse(portStr);
      if (parsedPort != null && parsedPort > 0 && parsedPort <= 65535) {
        port = parsedPort;
        hostname = hostPart.substring(0, colonIndex);
      }
    }

    if (hostname.isEmpty) return null;

    return _ParsedConnection(
      username: username,
      hostname: hostname,
      port: port,
    );
  }
}

class _QuickConnectDialog extends ConsumerStatefulWidget {
  const _QuickConnectDialog();

  @override
  ConsumerState<_QuickConnectDialog> createState() =>
      _QuickConnectDialogState();
}

class _QuickConnectDialogState extends ConsumerState<_QuickConnectDialog> {
  static const _uuid = Uuid();

  final _connectionController = TextEditingController();
  ProtocolType _protocol = ProtocolType.ssh;
  AuthMethodType _authMethod = AuthMethodType.key;
  String? _selectedKeyId;
  bool _saveConnection = false;
  bool _isConnecting = false;
  String? _parseError;

  @override
  void dispose() {
    _connectionController.dispose();
    super.dispose();
  }

  _ParsedConnection? _validate() {
    final l10n = AppLocalizations.of(context);
    final parsed = _ParsedConnection.tryParse(_connectionController.text);
    if (parsed == null) {
      setState(() => _parseError = l10n.quickConnectInvalidFormat);
      return null;
    }
    setState(() => _parseError = null);
    return parsed;
  }

  Future<void> _connect() async {
    final parsed = _validate();
    if (parsed == null) return;

    setState(() => _isConnecting = true);

    try {
      final db = ref.read(databaseProvider);
      final connections = ref.read(activeConnectionsProvider.notifier);

      // Use correct default port for protocol.
      final port = parsed.port == 22 && _protocol == ProtocolType.telnet
          ? 23
          : parsed.port;

      // Build a temporary or saved host
      final hostId = _uuid.v4();
      final now = DateTime.now();
      final label = '${parsed.username}@${parsed.hostname}';

      final companion = HostsCompanion(
        id: Value(hostId),
        label: Value(label),
        hostname: Value(parsed.hostname),
        port: Value(port),
        username: Value(parsed.username),
        authMethod: Value(_authMethod),
        keyId: Value(_selectedKeyId),
        protocol: Value(_protocol),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      if (_saveConnection) {
        await db.hostDao.insertHost(companion);
      }

      final host = Host(
        id: hostId,
        label: label,
        hostname: parsed.hostname,
        port: port,
        username: parsed.username,
        authMethod: _authMethod,
        keyId: _selectedKeyId,
        groupId: null,
        tags: '',
        startupCommand: null,
        keepAliveSeconds: 60,
        jumpHostId: null,
        encoding: null,
        notes: null,
        sortOrder: 0,
        isFavorite: false,
        lastConnectedAt: null,
        createdAt: now,
        updatedAt: now,
        syncVersion: 0,
        isDeleted: false,
        protocol: _protocol,
        serialPort: null,
        serialBaudRate: null,
        serialDataBits: null,
        serialStopBits: null,
        serialParity: null,
        serialFlowControl: null,
      );

      // Connect based on selected protocol.
      final session = switch (_protocol) {
        ProtocolType.ssh => await ref.read(sshServiceProvider).connect(host: host),
        ProtocolType.telnet => await ref.read(telnetServiceProvider).connect(host: host),
        ProtocolType.serial => throw UnsupportedError('Use host form for serial'),
      };

      connections.addConnection(session.sessionId, hostId);
      connections.updateStatus(session.sessionId, ConnectionStatus.connected);

      if (_saveConnection) {
        await db.hostDao.updateLastConnected(hostId);
      }

      // Add terminal tab (provider owns xterm state)
      await ref.read(terminalTabsProvider.notifier).addTab(session, label);

      // Pop dialog with true — caller handles workspace tab opening
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      ErrorHandler.handle(e);
      if (mounted) {
        setState(() => _isConnecting = false);
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

    return AlertDialog(
      title: Row(
        children: [
          const Icon(LucideIcons.zap, size: 20),
          const SizedBox(width: 8),
          Text(l10n.quickConnectTitle, style: AppTypography.h2),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Protocol toggle (SSH / Telnet)
            SegmentedButton<ProtocolType>(
              segments: [
                ButtonSegment(
                  value: ProtocolType.ssh,
                  label: Text(l10n.hostFormProtocolSsh),
                  icon: const Icon(LucideIcons.terminal, size: 14),
                ),
                ButtonSegment(
                  value: ProtocolType.telnet,
                  label: Text(l10n.hostFormProtocolTelnet),
                  icon: const Icon(LucideIcons.globe, size: 14),
                ),
              ],
              selected: {_protocol},
              onSelectionChanged: (selected) =>
                  setState(() => _protocol = selected.first),
            ),

            // Telnet warning
            if (_protocol == ProtocolType.telnet) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.alertTriangle,
                        size: 14, color: AppColors.accentOrange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Telnet sends data in plaintext.',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.accentOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Connection string input
            TextField(
              controller: _connectionController,
              decoration: InputDecoration(
                labelText: l10n.quickConnectTitle,
                hintText: l10n.quickConnectHint,
                prefixIcon: const Icon(LucideIcons.globe, size: 18),
                errorText: _parseError,
                helperText: l10n.quickConnectHelperText,
              ),
              autofocus: true,
              autocorrect: false,
              onChanged: (_) {
                if (_parseError != null) setState(() => _parseError = null);
              },
              onSubmitted: (_) => _connect(),
            ),
            const SizedBox(height: 16),

            // Auth method selector (SSH only)
            if (_protocol == ProtocolType.ssh) ...[
              Text(l10n.hostDetailSectionAuthentication, style: AppTypography.overline.copyWith(
                color: AppColors.textTertiary,
              )),
              const SizedBox(height: 8),
            ],
            if (_protocol == ProtocolType.ssh)
            SegmentedButton<AuthMethodType>(
              segments: [
                ButtonSegment(
                  value: AuthMethodType.key,
                  label: Text(l10n.hostFormAuthMethodKey),
                  icon: const Icon(LucideIcons.keyRound, size: 14),
                ),
                ButtonSegment(
                  value: AuthMethodType.password,
                  label: Text(l10n.hostFormAuthMethodPassword),
                  icon: const Icon(LucideIcons.lock, size: 14),
                ),
              ],
              selected: {_authMethod},
              onSelectionChanged: (selected) =>
                  setState(() => _authMethod = selected.first),
            ),

            // Key selector (when SSH + key auth selected)
            if (_protocol == ProtocolType.ssh && _authMethod == AuthMethodType.key) ...[
              const SizedBox(height: 12),
              keysAsync.when(
                data: (keys) {
                  if (keys.isEmpty) {
                    return Text(
                      l10n.hostFormKeyNone,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    );
                  }
                  // Reset if the selected key no longer exists
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
                      prefixIcon: const Icon(LucideIcons.keyRound, size: 16),
                      isDense: true,
                    ),
                    items: keys.map((key) {
                      return DropdownMenuItem<String?>(
                        value: key.id,
                        child: Text(key.label),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedKeyId = value),
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

            const SizedBox(height: 16),

            // Save checkbox
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _saveConnection,
                    onChanged: (v) =>
                        setState(() => _saveConnection = v ?? false),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () =>
                      setState(() => _saveConnection = !_saveConnection),
                  child: Text(
                    l10n.quickConnectSaveHost,
                    style: AppTypography.body,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isConnecting ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton.icon(
          onPressed: _isConnecting ? null : _connect,
          icon: _isConnecting
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(LucideIcons.play, size: 16),
          label: Text(_isConnecting ? '${l10n.quickConnectConnect}...' : l10n.quickConnectConnect),
        ),
      ],
    );
  }
}
