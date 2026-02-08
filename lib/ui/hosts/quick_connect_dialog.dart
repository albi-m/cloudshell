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
import '../../data/database/app_database.dart';
import '../../data/database/tables/hosts_table.dart';
import '../../providers/connection_provider.dart';
import '../../providers/key_provider.dart';
import '../../services/ssh/ssh_service.dart';
import '../terminal/terminal_screen.dart';

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
    final parsed = _ParsedConnection.tryParse(_connectionController.text);
    if (parsed == null) {
      setState(() => _parseError = 'Enter a valid connection string');
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
      final sshService = ref.read(sshServiceProvider);
      final connections = ref.read(activeConnectionsProvider.notifier);

      // Build a temporary or saved host
      final hostId = _uuid.v4();
      final now = DateTime.now();
      final label = '${parsed.username}@${parsed.hostname}';

      final companion = HostsCompanion(
        id: Value(hostId),
        label: Value(label),
        hostname: Value(parsed.hostname),
        port: Value(parsed.port),
        username: Value(parsed.username),
        authMethod: Value(_authMethod),
        keyId: Value(_selectedKeyId),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      if (_saveConnection) {
        await db.hostDao.insertHost(companion);
      }

      // Build a Host object for the SSH service
      final host = Host(
        id: hostId,
        label: label,
        hostname: parsed.hostname,
        port: parsed.port,
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
        isFavorite: false,
        lastConnectedAt: null,
        createdAt: now,
        updatedAt: now,
        syncVersion: 0,
        isDeleted: false,
      );

      final session = await sshService.connect(host: host);

      connections.addConnection(session.sessionId, hostId);
      connections.updateStatus(session.sessionId, ConnectionStatus.connected);

      if (_saveConnection) {
        await db.hostDao.updateLastConnected(hostId);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TerminalScreen(
              session: session,
              hostLabel: label,
            ),
          ),
        );
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
    final keysAsync = ref.watch(allKeysProvider);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(LucideIcons.zap, size: 20),
          const SizedBox(width: 8),
          Text('Quick Connect', style: AppTypography.h2),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection string input
            TextField(
              controller: _connectionController,
              decoration: InputDecoration(
                labelText: 'Connection',
                hintText: 'user@hostname:port',
                prefixIcon: const Icon(LucideIcons.globe, size: 18),
                errorText: _parseError,
                helperText: 'e.g., root@192.168.1.1:22',
              ),
              autofocus: true,
              autocorrect: false,
              onChanged: (_) {
                if (_parseError != null) setState(() => _parseError = null);
              },
              onSubmitted: (_) => _connect(),
            ),
            const SizedBox(height: 16),

            // Auth method selector
            Text('Authentication', style: AppTypography.overline.copyWith(
              color: AppColors.textTertiary,
            )),
            const SizedBox(height: 8),
            SegmentedButton<AuthMethodType>(
              segments: const [
                ButtonSegment(
                  value: AuthMethodType.key,
                  label: Text('Key'),
                  icon: Icon(LucideIcons.keyRound, size: 14),
                ),
                ButtonSegment(
                  value: AuthMethodType.password,
                  label: Text('Password'),
                  icon: Icon(LucideIcons.lock, size: 14),
                ),
              ],
              selected: {_authMethod},
              onSelectionChanged: (selected) =>
                  setState(() => _authMethod = selected.first),
            ),

            // Key selector (when key auth selected)
            if (_authMethod == AuthMethodType.key) ...[
              const SizedBox(height: 12),
              keysAsync.when(
                data: (keys) {
                  if (keys.isEmpty) {
                    return Text(
                      'No SSH keys available. Import one first.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedKeyId,
                    decoration: const InputDecoration(
                      labelText: 'SSH Key',
                      prefixIcon: Icon(LucideIcons.keyRound, size: 16),
                      isDense: true,
                    ),
                    items: keys.map((key) {
                      return DropdownMenuItem(
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
                  'Failed to load keys',
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
                    'Save this connection',
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
          child: const Text('Cancel'),
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
          label: Text(_isConnecting ? 'Connecting...' : 'Connect'),
        ),
      ],
    );
  }
}
