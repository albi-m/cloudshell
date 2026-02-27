/// Session logs screen.
///
/// Lists all terminal session log files with file size, date,
/// and actions for viewing, sharing, and deleting.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../services/terminal/session_logger.dart';

/// Screen for browsing and managing session log files.
class SessionLogsScreen extends StatefulWidget {
  const SessionLogsScreen({super.key});

  @override
  State<SessionLogsScreen> createState() => _SessionLogsScreenState();
}

class _SessionLogsScreenState extends State<SessionLogsScreen> {
  List<File>? _logs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    final logs = await SessionLogger.listLogs();
    if (mounted) {
      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sessionLogsTitle),
        actions: [
          if (_logs != null && _logs!.isNotEmpty)
            IconButton(
              icon: const Icon(LucideIcons.trash2, size: 20),
              tooltip: l10n.sessionLogsDeleteAllTooltip,
              onPressed: () => _confirmDeleteAll(context),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs == null || _logs!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.fileText,
                          size: 48,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.3)),
                      const SizedBox(height: 12),
                      Text(
                        l10n.sessionLogsEmpty,
                        style: AppTypography.body.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.sessionLogsEnableHint,
                        style: AppTypography.caption.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _logs!.length,
                  itemBuilder: (context, index) {
                    final file = _logs![index];
                    final name = p.basenameWithoutExtension(file.path);
                    final stat = file.statSync();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(LucideIcons.fileText, size: 20),
                        title: Text(
                          name,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${_formatDate(stat.modified)} \u00B7 ${_formatFileSize(stat.size)}',
                          style: AppTypography.caption,
                        ),
                        trailing: PopupMenuButton<String>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'view',
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.eye, size: 16),
                                  const SizedBox(width: 8),
                                  Text(l10n.sessionLogsView),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'share',
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.share2, size: 16),
                                  const SizedBox(width: 8),
                                  Text(l10n.sessionLogsShare),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.trash2,
                                      size: 16, color: AppColors.accentRed),
                                  const SizedBox(width: 8),
                                  Text(l10n.sessionLogsDelete,
                                      style:
                                          const TextStyle(color: AppColors.accentRed)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (action) {
                            switch (action) {
                              case 'view':
                                _viewLog(context, file);
                              case 'share':
                                _shareLog(file);
                              case 'delete':
                                _deleteLog(file);
                            }
                          },
                        ),
                        onTap: () => _viewLog(context, file),
                      ),
                    );
                  },
                ),
    );
  }

  void _viewLog(BuildContext context, File file) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _LogViewerScreen(file: file),
      ),
    );
  }

  Future<void> _shareLog(File file) async {
    final l10n = AppLocalizations.of(context);
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: l10n.sessionLogsShareSubject,
    );
  }

  Future<void> _deleteLog(File file) async {
    await SessionLogger.deleteLog(file.path);
    _loadLogs();
  }

  void _confirmDeleteAll(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.sessionLogsDeleteAllTitle),
        content: Text(l10n.sessionLogsDeleteAllMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.accentRed),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await SessionLogger.deleteAllLogs();
              _loadLogs();
            },
            child: Text(l10n.sessionLogsDeleteAllConfirm),
          ),
        ],
      ),
    );
  }
}

/// Full-screen log file viewer.
class _LogViewerScreen extends StatelessWidget {
  const _LogViewerScreen({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(p.basenameWithoutExtension(file.path)),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2, size: 20),
            tooltip: l10n.sessionLogsShareTooltip,
            onPressed: () {
              Share.shareXFiles(
                [XFile(file.path)],
                subject: l10n.sessionLogsShareSubject,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: file.readAsString(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.sessionLogsReadError('${snapshot.error}')));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              snapshot.data ?? '',
              style: AppTypography.terminal(fontSize: 12).copyWith(
                height: 1.6,
              ),
            ),
          );
        },
      ),
    );
  }
}
