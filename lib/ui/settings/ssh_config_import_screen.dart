/// SSH config import screen.
///
/// Reads `~/.ssh/config`, displays parsed host entries with
/// checkboxes, and imports selected entries as CloudShell hosts.
library;

import 'dart:io';

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
import '../../l10n/app_localizations.dart';
import '../../services/ssh/ssh_config_parser.dart';
import '../../services/ssh/ssh_key_service.dart';

/// Screen for importing hosts from `~/.ssh/config`.
class SshConfigImportScreen extends ConsumerStatefulWidget {
  const SshConfigImportScreen({super.key});

  @override
  ConsumerState<SshConfigImportScreen> createState() =>
      _SshConfigImportScreenState();
}

class _SshConfigImportScreenState extends ConsumerState<SshConfigImportScreen> {
  List<SshConfigEntry>? _entries;
  final _selected = <int>{};
  bool _isLoading = true;
  String? _error;
  bool _isImporting = false;
  bool _importKeys = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final entries = await SshConfigParser.parseDefault();
      if (mounted) {
        setState(() {
          _entries = entries;
          _isLoading = false;
          // Select all by default
          _selected.addAll(List.generate(entries.length, (i) => i));
        });
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (mounted) {
        setState(() {
          _error = ErrorHandler.userMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _importSelected() async {
    if (_entries == null || _selected.isEmpty) return;

    setState(() => _isImporting = true);

    try {
      final db = ref.read(databaseProvider);
      final keyService = ref.read(sshKeyServiceProvider);
      final uuid = const Uuid();
      var imported = 0;
      var keysImported = 0;

      // Build a map of existing hosts by hostname+port to avoid duplicates
      final existingHosts = await db.hostDao.searchHosts('');
      final existingKeys = <String, String>{};
      for (final host in existingHosts) {
        existingKeys['${host.hostname}:${host.port}'] = host.id;
      }

      for (final index in _selected) {
        final entry = _entries![index];
        final hostKey = '${entry.effectiveHostname}:${entry.effectivePort}';

        // Skip if host already exists
        if (existingKeys.containsKey(hostKey)) continue;

        String? keyId;

        // Try to import the identity file as an SSH key
        if (_importKeys && entry.identityFile != null) {
          try {
            final keyContent =
                await SshConfigParser.readIdentityFile(entry.identityFile!);
            if (keyContent != null) {
              final result = await keyService.importKey(
                label: '${entry.alias} key',
                privateKeyPem: keyContent,
              );
              keyId = result.id;
              keysImported++;
            }
          } catch (e) {
            debugPrint('SSH config key import failed: $e');
            // Key import failed — proceed without key
          }
        }

        final now = DateTime.now();
        await db.hostDao.insertHost(HostsCompanion(
          id: Value(uuid.v4()),
          label: Value(entry.alias),
          hostname: Value(entry.effectiveHostname),
          port: Value(entry.effectivePort),
          username: Value(entry.effectiveUser),
          authMethod: Value(
            keyId != null ? AuthMethodType.key : AuthMethodType.password,
          ),
          keyId: Value(keyId),
          keepAliveSeconds: Value(entry.keepAliveInterval ?? 60),
          tags: Value('imported,ssh-config'),
          createdAt: Value(now),
          updatedAt: Value(now),
        ));
        imported++;
      }

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.sshConfigImportedResult(imported, keysImported)),
          ),
        );
        Navigator.of(context).pop(imported);
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.sshConfigImportFailed2(ErrorHandler.userMessage(e))),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sshConfigImportTitle),
        actions: [
          if (_entries != null && _entries!.isNotEmpty)
            TextButton.icon(
              onPressed: _isImporting ? null : _importSelected,
              icon: _isImporting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.download, size: 16),
              label: Text(
                l10n.sshConfigImportButtonLabel(_selected.length),
                style: _selected.isEmpty
                    ? TextStyle(color: theme.disabledColor)
                    : null,
              ),
            ),
        ],
      ),
      body: _buildBody(theme, l10n),
    );
  }

  Widget _buildBody(ThemeData theme, AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.fileWarning,
                  size: 48,
                  color: theme.colorScheme.error.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                l10n.sshConfigImportFailed,
                style: AppTypography.h2,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: AppTypography.bodySmall.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_entries == null || _entries!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.fileSearch,
                  size: 48,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                l10n.sshConfigNoHostsFound,
                style: AppTypography.h2,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.sshConfigNoHostsFoundDetail,
                style: AppTypography.bodySmall.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Info bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: theme.colorScheme.primary.withValues(alpha: 0.06),
          child: Row(
            children: [
              Icon(LucideIcons.info, size: 16,
                  color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.sshConfigFoundHosts(_entries!.length),
                  style: AppTypography.bodySmall.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Select all + import keys toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    if (_selected.length == _entries!.length) {
                      _selected.clear();
                    } else {
                      _selected.addAll(
                        List.generate(_entries!.length, (i) => i),
                      );
                    }
                  });
                },
                icon: Icon(
                  _selected.length == _entries!.length
                      ? LucideIcons.checkSquare
                      : LucideIcons.square,
                  size: 16,
                ),
                label: Text(
                  _selected.length == _entries!.length
                      ? l10n.sshConfigDeselectAll
                      : l10n.sshConfigSelectAll,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.sshConfigImportKeys,
                      style: AppTypography.bodySmall),
                  const SizedBox(width: 4),
                  Switch(
                    value: _importKeys,
                    onChanged: (v) => setState(() => _importKeys = v),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Host list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _entries!.length,
            itemBuilder: (context, index) {
              final entry = _entries![index];
              final isSelected = _selected.contains(index);

              return Card(
                margin: const EdgeInsets.only(bottom: 6),
                child: CheckboxListTile(
                  value: isSelected,
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _selected.add(index);
                      } else {
                        _selected.remove(index);
                      }
                    });
                  },
                  title: Text(
                    entry.alias,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        '${entry.effectiveUser}@${entry.effectiveHostname}:${entry.effectivePort}',
                        style: AppTypography.code(fontSize: 12),
                      ),
                      if (entry.identityFile != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(LucideIcons.key, size: 12,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                entry.identityFile!
                                    .replaceFirst(
                                        Platform.environment['HOME'] ?? '',
                                        '~'),
                                style: AppTypography.caption,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (entry.proxyJump != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(LucideIcons.arrowRightLeft, size: 12,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4)),
                            const SizedBox(width: 4),
                            Text(
                              'via ${entry.proxyJump}',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  isThreeLine: entry.identityFile != null ||
                      entry.proxyJump != null,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
