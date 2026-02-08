/// SFTP file browser screen for CloudShell.
///
/// Provides a file browser UI connected to a remote server via SFTP.
/// Supports directory navigation, breadcrumbs, file upload/download,
/// and basic file management. Matches wireframe S6.1.
library;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../services/sftp/sftp_service.dart';
import '../../services/ssh/ssh_session.dart';

/// SFTP file browser connected to an active SSH session.
class SftpScreen extends ConsumerStatefulWidget {
  const SftpScreen({
    super.key,
    required this.session,
    required this.hostLabel,
  });

  final SshSessionWrapper session;
  final String hostLabel;

  @override
  ConsumerState<SftpScreen> createState() => _SftpScreenState();
}

class _SftpScreenState extends ConsumerState<SftpScreen> {
  late final SftpService _sftp;
  String _currentPath = '/';
  List<SftpEntry> _entries = [];
  bool _isLoading = true;
  String? _error;
  bool _showHidden = false;

  // Transfer queue
  final List<_TransferItem> _transfers = [];

  @override
  void initState() {
    super.initState();
    _sftp = SftpService(widget.session);
    _init();
  }

  Future<void> _init() async {
    try {
      await _sftp.connect();
      final homePath = await _sftp.absolutePath('.');
      _currentPath = homePath;
      await _loadDirectory();
    } catch (e) {
      ErrorHandler.handle(e);
      if (mounted) {
        setState(() {
          _error = ErrorHandler.userMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadDirectory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final entries = await _sftp.listDirectory(_currentPath);
      if (mounted) {
        setState(() {
          _entries = entries;
          _isLoading = false;
        });
      }
    } catch (e) {
      ErrorHandler.handle(e);
      if (mounted) {
        setState(() {
          _error = ErrorHandler.userMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  void _navigateTo(String path) {
    _currentPath = path;
    _loadDirectory();
  }

  void _navigateUp() {
    final parent = p.posix.dirname(_currentPath);
    _navigateTo(parent);
  }

  void _onEntryTap(SftpEntry entry) {
    if (entry.isDirectory) {
      if (entry.isParentDir) {
        _navigateUp();
      } else {
        _navigateTo(entry.path);
      }
    }
  }

  Future<void> _uploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    final remotePath = p.posix.join(_currentPath, file.name);
    final transfer = _TransferItem(
      name: file.name,
      isUpload: true,
    );

    setState(() => _transfers.add(transfer));

    try {
      await _sftp.uploadFile(
        file.path!,
        remotePath,
        onProgress: (bytes, total) {
          if (mounted) {
            setState(() {
              transfer.bytesTransferred = bytes;
              transfer.totalBytes = total;
            });
          }
        },
      );
      transfer.isDone = true;
      if (mounted) {
        setState(() {});
        _loadDirectory();
      }
    } catch (e) {
      ErrorHandler.handle(e);
      transfer.error = ErrorHandler.userMessage(e);
      if (mounted) setState(() {});
    }
  }

  Future<void> _downloadFile(SftpEntry entry) async {
    final downloadsDir = await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
    final localPath = p.join(downloadsDir.path, entry.name);

    final transfer = _TransferItem(
      name: entry.name,
      isUpload: false,
    );

    setState(() => _transfers.add(transfer));

    try {
      await _sftp.downloadFile(
        entry.path,
        localPath,
        onProgress: (bytes, total) {
          if (mounted) {
            setState(() {
              transfer.bytesTransferred = bytes;
              transfer.totalBytes = total;
            });
          }
        },
      );
      transfer.isDone = true;
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded to: $localPath')),
        );
      }
    } catch (e) {
      ErrorHandler.handle(e);
      transfer.error = ErrorHandler.userMessage(e);
      if (mounted) setState(() {});
    }
  }

  Future<void> _createFolder() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Folder', style: AppTypography.h2),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Folder name',
            hintText: 'e.g., new-folder',
          ),
          autofocus: true,
          onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;

    try {
      await _sftp.createDirectory(p.posix.join(_currentPath, name));
      _loadDirectory();
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

  Future<void> _deleteEntry(SftpEntry entry) async {
    try {
      if (entry.isDirectory) {
        await _sftp.deleteDirectory(entry.path);
      } else {
        await _sftp.deleteFile(entry.path);
      }
      _loadDirectory();
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

  List<String> get _breadcrumbs {
    final parts = _currentPath.split('/').where((p) => p.isNotEmpty).toList();
    return ['/', ...parts];
  }

  @override
  void dispose() {
    _sftp.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleEntries = _showHidden
        ? _entries
        : _entries.where((e) => !e.isHidden).toList();

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        backgroundColor: AppColors.bgDeep,
        title: Text('SFTP: ${widget.hostLabel}', style: AppTypography.h3),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.upload, size: 18),
            tooltip: 'Upload file',
            onPressed: _uploadFile,
          ),
          IconButton(
            icon: const Icon(LucideIcons.folderPlus, size: 18),
            tooltip: 'New folder',
            onPressed: _createFolder,
          ),
          IconButton(
            icon: Icon(
              _showHidden ? LucideIcons.eye : LucideIcons.eyeOff,
              size: 18,
            ),
            tooltip: _showHidden ? 'Hide hidden files' : 'Show hidden files',
            onPressed: () => setState(() => _showHidden = !_showHidden),
          ),
        ],
      ),
      body: Column(
        children: [
          // Breadcrumb navigation
          _BreadcrumbBar(
            parts: _breadcrumbs,
            onNavigate: (index) {
              if (index == 0) {
                _navigateTo('/');
              } else {
                final path = '/${_breadcrumbs.skip(1).take(index).join('/')}';
                _navigateTo(path);
              }
            },
          ),

          // File list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.alertTriangle,
                                size: 48, color: AppColors.accentRed),
                            const SizedBox(height: 12),
                            Text(_error!,
                                style: AppTypography.body
                                    .copyWith(color: AppColors.accentRed)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadDirectory,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : visibleEntries.isEmpty
                        ? Center(
                            child: Text(
                              'Empty directory',
                              style: AppTypography.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: visibleEntries.length,
                            itemBuilder: (context, index) {
                              final entry = visibleEntries[index];
                              return _FileListItem(
                                entry: entry,
                                onTap: () => _onEntryTap(entry),
                                onDownload: entry.isDirectory
                                    ? null
                                    : () => _downloadFile(entry),
                                onDelete: entry.isParentDir
                                    ? null
                                    : () => _deleteEntry(entry),
                              );
                            },
                          ),
          ),

          // Transfer queue
          if (_transfers.isNotEmpty)
            _TransferQueue(
              transfers: _transfers,
              onClear: () => setState(() {
                _transfers.removeWhere((t) => t.isDone || t.error != null);
              }),
            ),
        ],
      ),
    );
  }
}

/// Breadcrumb navigation bar showing the current path.
class _BreadcrumbBar extends StatelessWidget {
  const _BreadcrumbBar({
    required this.parts,
    required this.onNavigate,
  });

  final List<String> parts;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: parts.length,
        separatorBuilder: (_, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(LucideIcons.chevronRight,
              size: 14, color: AppColors.textTertiary),
        ),
        itemBuilder: (context, index) {
          final isLast = index == parts.length - 1;
          return GestureDetector(
            onTap: isLast ? null : () => onNavigate(index),
            child: Center(
              child: Text(
                parts[index],
                style: AppTypography.bodySmall.copyWith(
                  color: isLast
                      ? AppColors.textPrimary
                      : AppColors.accentPrimary,
                  fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Single file/directory list item.
class _FileListItem extends StatelessWidget {
  const _FileListItem({
    required this.entry,
    required this.onTap,
    this.onDownload,
    this.onDelete,
  });

  final SftpEntry entry;
  final VoidCallback onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.borderSubtle, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // File/folder icon
            Icon(
              entry.isDirectory ? LucideIcons.folder : _fileIcon(entry.name),
              size: 18,
              color: entry.isDirectory
                  ? AppColors.accentOrange
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),

            // Name + size/date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.isDirectory ? '${entry.name}/' : entry.name,
                    style: AppTypography.body.copyWith(
                      fontWeight:
                          entry.isDirectory ? FontWeight.w600 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!entry.isParentDir)
                    Row(
                      children: [
                        if (entry.size != null && !entry.isDirectory)
                          Text(
                            Formatters.fileSize(entry.size!),
                            style: AppTypography.caption.copyWith(fontSize: 11),
                          ),
                        if (entry.size != null &&
                            !entry.isDirectory &&
                            entry.modifiedAt != null)
                          Text(
                            '  \u2022  ',
                            style: AppTypography.caption.copyWith(fontSize: 11),
                          ),
                        if (entry.modifiedAt != null)
                          Text(
                            Formatters.relativeTime(entry.modifiedAt!),
                            style: AppTypography.caption.copyWith(fontSize: 11),
                          ),
                        if (entry.permissions != null) ...[
                          Text(
                            '  \u2022  ',
                            style: AppTypography.caption.copyWith(fontSize: 11),
                          ),
                          Text(
                            entry.permissions!,
                            style: AppTypography.code(fontSize: 10),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),

            // Actions
            if (onDownload != null || onDelete != null)
              PopupMenuButton<String>(
                icon: const Icon(LucideIcons.moreVertical,
                    size: 16, color: AppColors.textTertiary),
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  switch (value) {
                    case 'download':
                      onDownload?.call();
                    case 'delete':
                      onDelete?.call();
                  }
                },
                itemBuilder: (context) => [
                  if (onDownload != null)
                    const PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          Icon(LucideIcons.download, size: 16),
                          SizedBox(width: 8),
                          Text('Download'),
                        ],
                      ),
                    ),
                  if (onDelete != null)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(LucideIcons.trash2,
                              size: 16, color: AppColors.accentRed),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  IconData _fileIcon(String filename) {
    final ext = p.extension(filename).toLowerCase();
    return switch (ext) {
      '.txt' || '.md' || '.log' => LucideIcons.fileText,
      '.json' || '.yaml' || '.yml' || '.xml' || '.toml' => LucideIcons.fileCode,
      '.js' || '.ts' || '.dart' || '.py' || '.rb' || '.go' ||
      '.rs' || '.java' || '.c' || '.cpp' || '.h' =>
        LucideIcons.fileCode,
      '.html' || '.css' || '.scss' => LucideIcons.fileCode,
      '.jpg' || '.jpeg' || '.png' || '.gif' || '.svg' || '.webp' =>
        LucideIcons.fileImage,
      '.zip' || '.tar' || '.gz' || '.bz2' || '.xz' => LucideIcons.fileArchive,
      '.sh' || '.bash' || '.zsh' => LucideIcons.terminal,
      '.conf' || '.cfg' || '.ini' => LucideIcons.settings,
      _ => LucideIcons.file,
    };
  }
}

/// Transfer progress item (mutable for in-place updates).
class _TransferItem {
  _TransferItem({
    required this.name,
    required this.isUpload,
  });

  final String name;
  final bool isUpload;
  int bytesTransferred = 0;
  int totalBytes = 0;
  bool isDone = false;
  String? error;

  double get progress =>
      totalBytes > 0 ? bytesTransferred / totalBytes : 0;
}

/// Transfer queue panel shown at the bottom.
class _TransferQueue extends StatelessWidget {
  const _TransferQueue({
    required this.transfers,
    required this.onClear,
  });

  final List<_TransferItem> transfers;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 120),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          top: BorderSide(color: AppColors.borderDefault),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Text(
                  'Transfers',
                  style: AppTypography.overline
                      .copyWith(color: AppColors.textTertiary),
                ),
                const Spacer(),
                InkWell(
                  onTap: onClear,
                  child: Text(
                    'Clear done',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.accentPrimary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Transfer list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: transfers.length,
              itemBuilder: (context, index) {
                final t = transfers[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        t.isUpload ? LucideIcons.uploadCloud : LucideIcons.downloadCloud,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.name,
                              style: AppTypography.caption.copyWith(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (t.error != null)
                              Text(
                                t.error!,
                                style: AppTypography.caption.copyWith(
                                  fontSize: 10,
                                  color: AppColors.accentRed,
                                ),
                              )
                            else if (!t.isDone)
                              LinearProgressIndicator(
                                value: t.progress,
                                minHeight: 3,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t.isDone
                            ? 'Done'
                            : t.error != null
                                ? 'Failed'
                                : '${(t.progress * 100).toInt()}%',
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          color: t.isDone
                              ? AppColors.accentGreen
                              : t.error != null
                                  ? AppColors.accentRed
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
