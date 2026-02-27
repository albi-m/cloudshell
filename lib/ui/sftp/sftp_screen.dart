/// Split-pane SFTP file transfer screen for CloudShell.
///
/// Left pane: local file browser (dart:io).
/// Right pane: remote file browser (SftpService).
/// Top toolbar: host selector + transfer actions.
/// Bottom panel: transfer queue with progress.
library;

import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as p;

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/host_provider.dart';
import '../../services/sftp/sftp_service.dart';
import '../../services/ssh/ssh_service.dart';
import '../../services/ssh/ssh_session.dart';
import '../shared/empty_state.dart';
import 'remote_text_editor.dart';

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

/// A local file/directory entry from dart:io.
class LocalFileEntry {
  const LocalFileEntry({
    required this.name,
    required this.path,
    required this.isDirectory,
    this.size,
    this.modifiedAt,
  });

  final String name;
  final String path;
  final bool isDirectory;
  final int? size;
  final DateTime? modifiedAt;

  bool get isParentDir => name == '..';
  bool get isHidden => name.startsWith('.') && !isParentDir;
}

/// Transfer progress item (mutable for in-place updates).
class _TransferItem {
  _TransferItem({
    required this.name,
    required this.isUpload,
    required this.localPath,
    required this.remotePath,
  });

  final String name;
  final bool isUpload;
  final String localPath;
  final String remotePath;
  int bytesTransferred = 0;
  int totalBytes = 0;
  bool isDone = false;
  String? error;

  double get progress => totalBytes > 0 ? bytesTransferred / totalBytes : 0;
}

// ---------------------------------------------------------------------------
// Main Screen
// ---------------------------------------------------------------------------

/// Split-pane SFTP file transfer screen.
///
/// No constructor params — reads all saved hosts from [allHostsProvider]
/// and establishes its own independent SSH connection for SFTP.
class SftpScreen extends ConsumerStatefulWidget {
  const SftpScreen({super.key});

  @override
  ConsumerState<SftpScreen> createState() => _SftpScreenState();
}

class _SftpScreenState extends ConsumerState<SftpScreen>
    with SingleTickerProviderStateMixin {
  // Host / SFTP state
  String? _selectedHostId;
  SshSessionWrapper? _sshSession;
  SftpService? _sftp;
  String _selectedHostLabel = '';
  bool _isConnecting = false;

  // Transfer queue
  final List<_TransferItem> _transfers = [];

  // Split ratio (desktop)
  double _splitRatio = 0.5;

  // Selection state — lifted here so toolbar can read it
  final Set<String> _localSelected = {};
  final Set<String> _remoteSelected = {};

  // Pane keys to trigger refresh
  final _localPaneKey = GlobalKey<_LocalFilePaneState>();
  final _remotePaneKey = GlobalKey<_RemoteFilePaneState>();

  // Drag-and-drop state
  bool _isDragging = false;

  // Mobile tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _sftp?.close();
    _sshSession?.close();
    _tabController.dispose();
    super.dispose();
  }

  // --- Host selection ---

  void _onHostSelected(Host host) async {
    // Close previous SFTP + SSH session
    _sftp?.close();
    _sshSession?.close();

    setState(() {
      _selectedHostId = host.id;
      _selectedHostLabel = host.label;
      _sftp = null;
      _sshSession = null;
      _isConnecting = true;
      _remoteSelected.clear();
    });

    try {
      final sshService = ref.read(sshServiceProvider);
      final session = await sshService.connect(host: host);
      if (!mounted) {
        session.close();
        return;
      }

      _sshSession = session;
      final sftp = SftpService(session);
      await sftp.connect();

      if (mounted) {
        setState(() {
          _sftp = sftp;
          _isConnecting = false;
        });
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (mounted) {
        setState(() => _isConnecting = false);
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.sftpFailedToConnect(ErrorHandler.userMessage(e))),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  // --- Transfer actions ---

  Future<void> _uploadSelected() async {
    if (_sftp == null || _localSelected.isEmpty) return;
    final remotePath = _remotePaneKey.currentState?.currentPath ?? '/';
    final paths = List<String>.from(_localSelected);

    for (final localPath in paths) {
      final fileName = p.basename(localPath);
      final remote = p.posix.join(remotePath, fileName);

      final transfer = _TransferItem(
        name: fileName,
        isUpload: true,
        localPath: localPath,
        remotePath: remote,
      );
      setState(() => _transfers.add(transfer));

      try {
        await _sftp!.uploadFile(
          localPath,
          remote,
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
          _remotePaneKey.currentState?.refresh();
        }
      } catch (e, stackTrace) {
        ErrorHandler.handle(e, stackTrace);
        transfer.error = ErrorHandler.userMessage(e);
        if (mounted) setState(() {});
      }
    }
    setState(() => _localSelected.clear());
  }

  Future<void> _downloadSelected() async {
    if (_sftp == null || _remoteSelected.isEmpty) return;
    final localDir = _localPaneKey.currentState?.currentPath ??
        Platform.environment['HOME'] ??
        Directory.current.path;
    final paths = List<String>.from(_remoteSelected);

    for (final remotePath in paths) {
      final fileName = p.posix.basename(remotePath);
      final localPath = p.join(localDir, fileName);

      final transfer = _TransferItem(
        name: fileName,
        isUpload: false,
        localPath: localPath,
        remotePath: remotePath,
      );
      setState(() => _transfers.add(transfer));

      try {
        await _sftp!.downloadFile(
          remotePath,
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
          _localPaneKey.currentState?.refresh();
        }
      } catch (e, stackTrace) {
        ErrorHandler.handle(e, stackTrace);
        transfer.error = ErrorHandler.userMessage(e);
        if (mounted) setState(() {});
      }
    }
    setState(() => _remoteSelected.clear());
  }

  Future<void> _handleDroppedFiles(DropDoneDetails details) async {
    if (_sftp == null) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.sftpConnectToHostFirst)),
      );
      return;
    }

    final remotePath = _remotePaneKey.currentState?.currentPath ?? '/';

    for (final file in details.files) {
      final localPath = file.path;
      final fileName = p.basename(localPath);
      final remote = p.posix.join(remotePath, fileName);

      final transfer = _TransferItem(
        name: fileName,
        isUpload: true,
        localPath: localPath,
        remotePath: remote,
      );
      setState(() => _transfers.add(transfer));

      try {
        await _sftp!.uploadFile(
          localPath,
          remote,
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
          _remotePaneKey.currentState?.refresh();
        }
      } catch (e, stackTrace) {
        ErrorHandler.handle(e, stackTrace);
        transfer.error = ErrorHandler.userMessage(e);
        if (mounted) setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hostsAsync = ref.watch(allHostsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      body: hostsAsync.when(
        data: (hosts) => Column(
          children: [
            // Toolbar: host selector + transfer buttons
            _SftpToolbar(
              hosts: hosts,
              selectedHostId: _selectedHostId,
              isConnecting: _isConnecting,
              onHostSelected: _onHostSelected,
              localSelectionCount: _localSelected.length,
              remoteSelectionCount: _remoteSelected.length,
              onUpload: _localSelected.isNotEmpty && _sftp != null
                  ? _uploadSelected
                  : null,
              onDownload: _remoteSelected.isNotEmpty && _sftp != null
                  ? _downloadSelected
                  : null,
            ),

            // Split panes
            Expanded(
              child: hosts.isEmpty
                  ? EmptyState(
                      icon: LucideIcons.folderOpen,
                      title: l10n.sftpNoSavedHostsTitle,
                      subtitle: l10n.sftpNoSavedHostsSubtitle,
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth >= 700) {
                          return _buildSplitView();
                        }
                        return _buildTabView();
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
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (error, _) => Center(
          child: Text(
            l10n.sftpFailedToLoadHosts,
            style: AppTypography.body.copyWith(color: AppColors.accentRed),
          ),
        ),
      ),
    );
  }

  Widget _buildSplitView() {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          flex: (_splitRatio * 100).toInt(),
          child: _LocalFilePane(
            key: _localPaneKey,
            selectedPaths: _localSelected,
            onSelectionChanged: () => setState(() {}),
          ),
        ),
        _DragHandle(
          onDrag: (dx) {
            setState(() {
              final totalWidth = context.size?.width ?? 800;
              _splitRatio = (_splitRatio + dx / totalWidth).clamp(0.25, 0.75);
            });
          },
        ),
        Expanded(
          flex: ((1 - _splitRatio) * 100).toInt(),
          child: DropTarget(
            onDragEntered: (_) => setState(() => _isDragging = true),
            onDragExited: (_) => setState(() => _isDragging = false),
            onDragDone: (details) {
              setState(() => _isDragging = false);
              _handleDroppedFiles(details);
            },
            child: Stack(
              children: [
                _RemoteFilePane(
                  key: _remotePaneKey,
                  sftp: _sftp,
                  hostLabel: _selectedHostLabel,
                  selectedPaths: _remoteSelected,
                  onSelectionChanged: () => setState(() {}),
                ),
                if (_isDragging)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.accentPrimary.withValues(alpha: 0.08),
                        border: Border.all(
                          color: AppColors.accentPrimary.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.upload,
                                size: 36, color: AppColors.accentPrimary),
                            const SizedBox(height: 8),
                            Text(
                              l10n.sftpDropFilesToUpload,
                              style: AppTypography.body.copyWith(
                                color: AppColors.accentPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabView() {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Material(
          color: AppColors.bgDeep,
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: l10n.sftpTabLocal),
              Tab(text: l10n.sftpTabRemote),
            ],
            indicatorColor: AppColors.accentPrimary,
            labelColor: AppColors.accentPrimary,
            unselectedLabelColor: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _LocalFilePane(
                key: _localPaneKey,
                selectedPaths: _localSelected,
                onSelectionChanged: () => setState(() {}),
              ),
              _RemoteFilePane(
                key: _remotePaneKey,
                sftp: _sftp,
                hostLabel: _selectedHostLabel,
                selectedPaths: _remoteSelected,
                onSelectionChanged: () => setState(() {}),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Toolbar
// ---------------------------------------------------------------------------

class _SftpToolbar extends StatelessWidget {
  const _SftpToolbar({
    required this.hosts,
    required this.selectedHostId,
    required this.isConnecting,
    required this.onHostSelected,
    required this.localSelectionCount,
    required this.remoteSelectionCount,
    required this.onUpload,
    required this.onDownload,
  });

  final List<Host> hosts;
  final String? selectedHostId;
  final bool isConnecting;
  final ValueChanged<Host> onHostSelected;
  final int localSelectionCount;
  final int remoteSelectionCount;
  final VoidCallback? onUpload;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.bgDeep,
        border: Border(
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          // Host selector
          const Icon(LucideIcons.server, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          if (hosts.isEmpty)
            Text(l10n.sftpNoSavedHostsTitle,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textTertiary))
          else
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedHostId,
                hint: Text(l10n.sftpSelectHostHint,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
                isDense: true,
                dropdownColor: AppColors.bgRaised,
                items: hosts.map((host) {
                  return DropdownMenuItem(
                    value: host.id,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.server,
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 8),
                        Text(host.label, style: AppTypography.bodySmall),
                        const SizedBox(width: 6),
                        Text(
                          '${host.username}@${host.hostname}',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (id) {
                  if (id == null) return;
                  final host = hosts.where((h) => h.id == id).firstOrNull;
                  if (host != null) onHostSelected(host);
                },
              ),
            ),

          if (isConnecting) ...[
            const SizedBox(width: 12),
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 6),
            Text(l10n.sftpConnecting,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                )),
          ],

          const Spacer(),

          // Transfer buttons
          _TransferButton(
            icon: LucideIcons.arrowRight,
            label: l10n.sftpUploadLabel,
            count: localSelectionCount,
            onPressed: onUpload,
            color: AppColors.accentPrimary,
          ),
          const SizedBox(width: 4),
          _TransferButton(
            icon: LucideIcons.arrowLeft,
            label: l10n.sftpDownloadLabel,
            count: remoteSelectionCount,
            onPressed: onDownload,
            color: AppColors.accentCyan,
          ),
        ],
      ),
    );
  }
}

class _TransferButton extends StatelessWidget {
  const _TransferButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.onPressed,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int count;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    return Tooltip(
      message: count > 0 ? '$label $count file${count == 1 ? '' : 's'}' : label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isEnabled
                  ? color.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isEnabled
                    ? color.withValues(alpha: 0.3)
                    : AppColors.borderSubtle,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    size: 14,
                    color: isEnabled ? color : AppColors.textTertiary),
                const SizedBox(width: 6),
                Text(
                  count > 0 ? '$label ($count)' : label,
                  style: AppTypography.caption.copyWith(
                    color: isEnabled ? color : AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Local File Pane
// ---------------------------------------------------------------------------

class _LocalFilePane extends StatefulWidget {
  const _LocalFilePane({
    super.key,
    required this.selectedPaths,
    required this.onSelectionChanged,
  });

  final Set<String> selectedPaths;
  final VoidCallback onSelectionChanged;

  @override
  State<_LocalFilePane> createState() => _LocalFilePaneState();
}

class _LocalFilePaneState extends State<_LocalFilePane> {
  String _currentPath = '';
  List<LocalFileEntry> _entries = [];
  bool _isLoading = true;
  String? _error;
  bool _showHidden = false;

  String get currentPath => _currentPath;

  @override
  void initState() {
    super.initState();
    _currentPath =
        Platform.environment['HOME'] ?? Directory.current.path;
    _loadDirectory();
  }

  void refresh() => _loadDirectory();

  Future<void> _loadDirectory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dir = Directory(_currentPath);
      final entities = await dir.list().toList();
      final entries = <LocalFileEntry>[];

      for (final entity in entities) {
        try {
          final stat = await entity.stat();
          entries.add(LocalFileEntry(
            name: p.basename(entity.path),
            path: entity.path,
            isDirectory: stat.type == FileSystemEntityType.directory,
            size: stat.type == FileSystemEntityType.file ? stat.size : null,
            modifiedAt: stat.modified,
          ));
        } catch (e, stackTrace) {
          ErrorHandler.handle(e, stackTrace);
          // Skip entries we can't stat (permission denied)
        }
      }

      // Sort: dirs first, then alphabetical
      entries.sort((a, b) {
        if (a.isDirectory != b.isDirectory) {
          return a.isDirectory ? -1 : 1;
        }
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      if (mounted) {
        setState(() {
          _entries = entries;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _navigateTo(String path) {
    final previous = _currentPath;
    _currentPath = path;
    widget.selectedPaths.clear();
    widget.onSelectionChanged();
    _loadDirectory().then((_) {
      if (_error != null && mounted) {
        setState(() {
          _currentPath = previous;
          _error = null;
        });
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.sftpLocalCannotOpenFolder)),
        );
        _loadDirectory();
      }
    });
  }

  void _navigateUp() {
    final parent = p.dirname(_currentPath);
    if (parent != _currentPath) {
      _navigateTo(parent);
    }
  }

  List<String> get _breadcrumbs {
    final parts =
        _currentPath.split(Platform.pathSeparator).where((s) => s.isNotEmpty).toList();
    return ['/', ...parts];
  }

  void _toggleSelection(String path) {
    if (widget.selectedPaths.contains(path)) {
      widget.selectedPaths.remove(path);
    } else {
      widget.selectedPaths.add(path);
    }
    widget.onSelectionChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final visible = _showHidden
        ? _entries
        : _entries.where((e) => !e.isHidden).toList();

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.borderSubtle, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          // Pane header
          _PaneHeader(
            label: l10n.sftpPaneHeaderLocal,
            icon: LucideIcons.hardDrive,
            showHidden: _showHidden,
            onToggleHidden: () => setState(() => _showHidden = !_showHidden),
            onNavigateUp: _currentPath != '/' ? _navigateUp : null,
          ),

          // Breadcrumbs
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
                ? const Center(
                    child: CircularProgressIndicator(strokeWidth: 2))
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(LucideIcons.shieldOff,
                                  size: 32, color: AppColors.accentOrange),
                              const SizedBox(height: 8),
                              Text(l10n.sftpLocalPermissionDenied,
                                  style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      )
                    : visible.isEmpty
                        ? Center(
                            child: Text(l10n.sftpLocalEmptyFolder,
                                style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textTertiary)))
                        : ListView.builder(
                            itemCount: visible.length,
                            itemBuilder: (context, index) {
                              final entry = visible[index];
                              return _FileListItem(
                                name: entry.name,
                                path: entry.path,
                                isDirectory: entry.isDirectory,
                                size: entry.size,
                                modifiedAt: entry.modifiedAt,
                                isSelected: widget.selectedPaths
                                    .contains(entry.path),
                                onTap: () {
                                  if (entry.isDirectory) {
                                    _navigateTo(entry.path);
                                  }
                                },
                                onSelect: entry.isDirectory
                                    ? null
                                    : () => _toggleSelection(entry.path),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Remote File Pane
// ---------------------------------------------------------------------------

class _RemoteFilePane extends StatefulWidget {
  const _RemoteFilePane({
    super.key,
    required this.sftp,
    required this.hostLabel,
    required this.selectedPaths,
    required this.onSelectionChanged,
  });

  final SftpService? sftp;
  final String hostLabel;
  final Set<String> selectedPaths;
  final VoidCallback onSelectionChanged;

  @override
  State<_RemoteFilePane> createState() => _RemoteFilePaneState();
}

class _RemoteFilePaneState extends State<_RemoteFilePane> {
  String _currentPath = '/';
  List<SftpEntry> _entries = [];
  bool _isLoading = false;
  String? _error;
  bool _showHidden = true;
  bool _dirWritable = true;

  String get currentPath => _currentPath;

  @override
  void didUpdateWidget(covariant _RemoteFilePane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sftp != oldWidget.sftp && widget.sftp != null) {
      _init();
    }
  }

  void refresh() => _loadDirectory();

  Future<void> _init() async {
    try {
      final homePath = await widget.sftp!.absolutePath('.');
      _currentPath = homePath;
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      _currentPath = '/';
    }
    _loadDirectory();
  }

  Future<void> _loadDirectory() async {
    if (widget.sftp == null) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final entries = await widget.sftp!.listDirectory(_currentPath);
      final writable =
          await widget.sftp!.isDirectoryWritable(_currentPath);
      if (mounted) {
        setState(() {
          _entries = entries;
          _dirWritable = writable;
          _isLoading = false;
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

  void _navigateTo(String path) {
    final previous = _currentPath;
    final prevEntries = List<SftpEntry>.from(_entries);
    _currentPath = path;
    widget.selectedPaths.clear();
    widget.onSelectionChanged();
    _loadDirectory().then((_) {
      if (_error != null && mounted) {
        final msg = _error!;
        setState(() {
          _currentPath = previous;
          _entries = prevEntries;
          _error = null;
          _isLoading = false;
        });
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.sftpRemoteCannotOpenFolder(msg))),
        );
      }
    });
  }

  void _navigateUp() {
    final parent = p.posix.dirname(_currentPath);
    _navigateTo(parent);
  }

  List<String> get _breadcrumbs {
    final parts =
        _currentPath.split('/').where((s) => s.isNotEmpty).toList();
    return ['/', ...parts];
  }

  void _toggleSelection(String path) {
    if (widget.selectedPaths.contains(path)) {
      widget.selectedPaths.remove(path);
    } else {
      widget.selectedPaths.add(path);
    }
    widget.onSelectionChanged();
  }

  Future<void> _createFolder() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sftpNewFolderDialogTitle, style: AppTypography.h2),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.sftpNewFolderDialogLabel,
            hintText: l10n.sftpNewFolderDialogHint,
          ),
          autofocus: true,
          onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pop(controller.text.trim()),
            child: Text(l10n.sftpNewFolderDialogCreate),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;
    try {
      await widget.sftp!.createDirectory(p.posix.join(_currentPath, name));
      _loadDirectory();
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
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
        await widget.sftp!.deleteDirectory(entry.path);
      } else {
        await widget.sftp!.deleteFile(entry.path);
      }
      _loadDirectory();
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
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

  Future<void> _editPermissions(SftpEntry entry) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => _PermissionsDialog(
        fileName: entry.name,
        currentPermissions: entry.permissions ?? '644',
      ),
    );
    if (result == null || result.isEmpty) return;
    try {
      final octalInt = int.parse(result, radix: 8);
      await widget.sftp!.setPermissions(entry.path, octalInt);
      _loadDirectory();
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
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

  static const _editableExtensions = {
    '.txt', '.md', '.log', '.json', '.yaml', '.yml', '.xml', '.toml',
    '.conf', '.cfg', '.ini', '.sh', '.bash', '.zsh', '.py', '.js',
    '.ts', '.html', '.css', '.scss', '.dart', '.rb', '.go', '.rs',
    '.java', '.c', '.cpp', '.h', '.hpp', '.sql', '.env',
    '.gitignore', '.properties',
  };

  bool _isTextFile(String filename) {
    final ext = p.posix.extension(filename).toLowerCase();
    if (_editableExtensions.contains(ext)) return true;
    // Files with no extension might be text (e.g. Makefile, Dockerfile)
    final base = p.posix.basenameWithoutExtension(filename).toLowerCase();
    return {'makefile', 'dockerfile', 'vagrantfile', 'gemfile', 'rakefile'}
        .contains(base);
  }

  void _editFile(SftpEntry entry) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => RemoteTextEditor(
          sftp: widget.sftp!,
          remotePath: entry.path,
          fileName: entry.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (widget.sftp == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.server,
                size: 40, color: AppColors.textTertiary),
            const SizedBox(height: 12),
            Text(l10n.sftpRemoteSelectHost,
                style: AppTypography.body
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(l10n.sftpRemoteSelectHostSubtitle,
                style: AppTypography.caption
                    .copyWith(color: AppColors.textTertiary)),
          ],
        ),
      );
    }

    final visible = _showHidden
        ? _entries
        : _entries.where((e) => !e.isHidden).toList();

    return Column(
      children: [
        // Pane header
        _PaneHeader(
          label: l10n.sftpPaneHeaderRemote,
          subtitle: widget.hostLabel,
          icon: LucideIcons.globe,
          showHidden: _showHidden,
          onToggleHidden: () => setState(() => _showHidden = !_showHidden),
          onNavigateUp: _currentPath != '/' ? _navigateUp : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_dirWritable)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(l10n.sftpRemoteReadOnly,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.accentOrange,
                        fontSize: 10,
                      )),
                ),
              if (_dirWritable)
                IconButton(
                  icon: const Icon(LucideIcons.folderPlus, size: 16),
                  tooltip: l10n.sftpRemoteNewFolderTooltip,
                  onPressed: _createFolder,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ),

        // Breadcrumbs
        _BreadcrumbBar(
          parts: _breadcrumbs,
          onNavigate: (index) {
            if (index == 0) {
              _navigateTo('/');
            } else {
              final path =
                  '/${_breadcrumbs.skip(1).take(index).join('/')}';
              _navigateTo(path);
            }
          },
        ),

        // File list
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(strokeWidth: 2))
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.alertTriangle,
                              size: 32, color: AppColors.accentRed),
                          const SizedBox(height: 8),
                          Text(_error!,
                              style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.accentRed)),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _loadDirectory,
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    )
                  : visible.isEmpty
                      ? Center(
                          child: Text(l10n.sftpRemoteEmptyDirectory,
                              style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textTertiary)))
                      : ListView.builder(
                          itemCount: visible.length,
                          itemBuilder: (context, index) {
                            final entry = visible[index];
                            return _FileListItem(
                              name: entry.isDirectory
                                  ? '${entry.name}/'
                                  : entry.name,
                              path: entry.path,
                              isDirectory: entry.isDirectory,
                              size: entry.size,
                              modifiedAt: entry.modifiedAt,
                              permissions: entry.permissions,
                              isSelected: widget.selectedPaths
                                  .contains(entry.path),
                              onTap: () {
                                if (entry.isDirectory) {
                                  if (entry.isParentDir) {
                                    _navigateUp();
                                  } else {
                                    _navigateTo(entry.path);
                                  }
                                }
                              },
                              onSelect: (entry.isDirectory ||
                                      entry.isParentDir)
                                  ? null
                                  : () => _toggleSelection(entry.path),
                              onDelete: (entry.isParentDir || !_dirWritable)
                                  ? null
                                  : () => _deleteEntry(entry),
                              onEditPermissions:
                                  (entry.isParentDir || !_dirWritable)
                                      ? null
                                      : () => _editPermissions(entry),
                              onEdit: (!entry.isDirectory &&
                                      !entry.isParentDir &&
                                      _isTextFile(entry.name))
                                  ? () => _editFile(entry)
                                  : null,
                            );
                          },
                        ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared Widgets
// ---------------------------------------------------------------------------

/// Pane header with label, toggle hidden, and navigate-up button.
class _PaneHeader extends StatelessWidget {
  const _PaneHeader({
    required this.label,
    this.subtitle,
    required this.icon,
    required this.showHidden,
    required this.onToggleHidden,
    this.onNavigateUp,
    this.trailing,
  });

  final String label;
  final String? subtitle;
  final IconData icon;
  final bool showHidden;
  final VoidCallback onToggleHidden;
  final VoidCallback? onNavigateUp;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textTertiary),
          const SizedBox(width: 6),
          Text(label,
              style: AppTypography.overline.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
                letterSpacing: 1.5,
              )),
          if (subtitle != null) ...[
            const SizedBox(width: 6),
            Flexible(
              child: Text(subtitle!,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
          const Spacer(),
          ?trailing,
          IconButton(
            icon: Icon(
              showHidden ? LucideIcons.eye : LucideIcons.eyeOff,
              size: 14,
            ),
            tooltip: showHidden ? l10n.sftpHideHiddenFiles : l10n.sftpShowHiddenFiles,
            onPressed: onToggleHidden,
            visualDensity: VisualDensity.compact,
          ),
          if (onNavigateUp != null)
            IconButton(
              icon: const Icon(LucideIcons.arrowUp, size: 14),
              tooltip: l10n.sftpGoUp,
              onPressed: onNavigateUp,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

/// Breadcrumb navigation bar.
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
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.bgDeep.withValues(alpha: 0.5),
        border: const Border(
          bottom: BorderSide(color: AppColors.borderSubtle, width: 0.5),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: parts.length,
        separatorBuilder: (_, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(LucideIcons.chevronRight,
              size: 12, color: AppColors.textTertiary),
        ),
        itemBuilder: (context, index) {
          final isLast = index == parts.length - 1;
          return GestureDetector(
            onTap: isLast ? null : () => onNavigate(index),
            child: Center(
              child: Text(
                parts[index],
                style: AppTypography.caption.copyWith(
                  fontSize: 11,
                  color:
                      isLast ? AppColors.textPrimary : AppColors.accentPrimary,
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

/// Single file/directory row shared by both panes.
class _FileListItem extends StatelessWidget {
  const _FileListItem({
    required this.name,
    required this.path,
    required this.isDirectory,
    this.size,
    this.modifiedAt,
    this.permissions,
    this.isSelected = false,
    required this.onTap,
    this.onSelect,
    this.onDelete,
    this.onEditPermissions,
    this.onEdit,
  });

  final String name;
  final String path;
  final bool isDirectory;
  final int? size;
  final DateTime? modifiedAt;
  final String? permissions;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onSelect;
  final VoidCallback? onDelete;
  final VoidCallback? onEditPermissions;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect ?? onTap,
      onDoubleTap: isDirectory ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentPrimary.withValues(alpha: 0.08)
              : null,
          border: const Border(
            bottom: BorderSide(color: AppColors.borderSubtle, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Selection checkbox (files only)
            if (onSelect != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => onSelect?.call(),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              )
            else
              const SizedBox(width: 26),

            // Icon
            Icon(
              isDirectory ? LucideIcons.folder : _fileIcon(name),
              size: 16,
              color: isDirectory
                  ? AppColors.accentOrange
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),

            // Name + metadata
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight:
                          isDirectory ? FontWeight.w600 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (size != null || modifiedAt != null)
                    Row(
                      children: [
                        if (size != null && !isDirectory)
                          Text(Formatters.fileSize(size!),
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                        if (size != null && modifiedAt != null)
                          Text('  \u00B7  ',
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                        if (modifiedAt != null)
                          Text(Formatters.relativeTime(modifiedAt!),
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                        if (permissions != null) ...[
                          Text('  \u00B7  ',
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                          Text(permissions!,
                              style: AppTypography.code(fontSize: 9)),
                        ],
                      ],
                    ),
                ],
              ),
            ),

            // Actions menu (remote pane only)
            if (onDelete != null ||
                onEditPermissions != null ||
                onEdit != null)
              PopupMenuButton<String>(
                icon: const Icon(LucideIcons.moreVertical,
                    size: 14, color: AppColors.textTertiary),
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit?.call();
                    case 'permissions':
                      onEditPermissions?.call();
                    case 'delete':
                      onDelete?.call();
                  }
                },
                itemBuilder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return [
                    if (onEdit != null)
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(LucideIcons.pencil, size: 14),
                            const SizedBox(width: 8),
                            Text(l10n.sftpFileMenuEdit),
                          ],
                        ),
                      ),
                    if (onEditPermissions != null)
                      PopupMenuItem(
                        value: 'permissions',
                        child: Row(
                          children: [
                            const Icon(LucideIcons.shield, size: 14),
                            const SizedBox(width: 8),
                            Text(l10n.sftpFileMenuPermissions),
                          ],
                        ),
                      ),
                    if (onDelete != null)
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(LucideIcons.trash2,
                                size: 14, color: AppColors.accentRed),
                            const SizedBox(width: 8),
                            Text(l10n.sftpFileMenuDelete,
                                style: const TextStyle(color: AppColors.accentRed)),
                          ],
                        ),
                      ),
                  ];
                },
              ),
          ],
        ),
      ),
    );
  }

  static IconData _fileIcon(String filename) {
    final ext = p.extension(filename).toLowerCase();
    return switch (ext) {
      '.txt' || '.md' || '.log' => LucideIcons.fileText,
      '.json' || '.yaml' || '.yml' || '.xml' || '.toml' =>
        LucideIcons.fileCode,
      '.js' || '.ts' || '.dart' || '.py' || '.rb' || '.go' ||
      '.rs' || '.java' || '.c' || '.cpp' || '.h' =>
        LucideIcons.fileCode,
      '.html' || '.css' || '.scss' => LucideIcons.fileCode,
      '.jpg' || '.jpeg' || '.png' || '.gif' || '.svg' || '.webp' =>
        LucideIcons.fileImage,
      '.zip' || '.tar' || '.gz' || '.bz2' || '.xz' =>
        LucideIcons.fileArchive,
      '.sh' || '.bash' || '.zsh' => LucideIcons.terminal,
      '.conf' || '.cfg' || '.ini' => LucideIcons.settings,
      _ => LucideIcons.file,
    };
  }
}

// ---------------------------------------------------------------------------
// Permissions Dialog
// ---------------------------------------------------------------------------

/// Dialog for editing unix file permissions (chmod).
///
/// Shows a 3x3 grid of checkboxes (user/group/other × read/write/execute)
/// and an octal text field that syncs bidirectionally.
class _PermissionsDialog extends StatefulWidget {
  const _PermissionsDialog({
    required this.fileName,
    required this.currentPermissions,
  });

  final String fileName;
  final String currentPermissions;

  @override
  State<_PermissionsDialog> createState() => _PermissionsDialogState();
}

class _PermissionsDialogState extends State<_PermissionsDialog> {
  late final TextEditingController _octalController;

  // 9 permission booleans: [uR, uW, uX, gR, gW, gX, oR, oW, oX]
  late List<bool> _perms;

  @override
  void initState() {
    super.initState();
    _octalController = TextEditingController(text: widget.currentPermissions);
    _perms = _parseOctal(widget.currentPermissions);
  }

  @override
  void dispose() {
    _octalController.dispose();
    super.dispose();
  }

  List<bool> _parseOctal(String octal) {
    final result = List.filled(9, false);
    if (octal.length != 3) return result;
    for (var i = 0; i < 3; i++) {
      final digit = int.tryParse(octal[i]) ?? 0;
      result[i * 3] = (digit & 4) != 0;     // read
      result[i * 3 + 1] = (digit & 2) != 0; // write
      result[i * 3 + 2] = (digit & 1) != 0; // execute
    }
    return result;
  }

  String _toOctal() {
    final buf = StringBuffer();
    for (var i = 0; i < 3; i++) {
      final digit = (_perms[i * 3] ? 4 : 0) +
          (_perms[i * 3 + 1] ? 2 : 0) +
          (_perms[i * 3 + 2] ? 1 : 0);
      buf.write(digit);
    }
    return buf.toString();
  }

  void _onCheckboxChanged(int index, bool value) {
    setState(() {
      _perms[index] = value;
      _octalController.text = _toOctal();
    });
  }

  void _onOctalChanged(String value) {
    if (value.length == 3 &&
        RegExp(r'^[0-7]{3}$').hasMatch(value)) {
      setState(() => _perms = _parseOctal(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final labels = [l10n.sftpPermissionsLabelUser, l10n.sftpPermissionsLabelGroup, l10n.sftpPermissionsLabelOther];
    final bits = [l10n.sftpPermissionsBitRead, l10n.sftpPermissionsBitWrite, l10n.sftpPermissionsBitExec];

    return AlertDialog(
      title: Text(l10n.sftpPermissionsDialogTitle(widget.fileName)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Octal input
          Row(
            children: [
              Text('${l10n.sftpPermissionsOctalLabel}: ', style: AppTypography.body),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _octalController,
                  onChanged: _onOctalChanged,
                  style: AppTypography.code(fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    counterText: '',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Checkbox grid
          Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              // Header row
              TableRow(
                children: [
                  const SizedBox(width: 60),
                  ...bits.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Center(
                          child: Text(b,
                              style: AppTypography.caption.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6))),
                        ),
                      )),
                ],
              ),
              // Data rows
              for (var row = 0; row < 3; row++)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(labels[row], style: AppTypography.body),
                    ),
                    for (var col = 0; col < 3; col++)
                      Center(
                        child: Checkbox(
                          value: _perms[row * 3 + col],
                          onChanged: (v) =>
                              _onCheckboxChanged(row * 3 + col, v ?? false),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final octal = _octalController.text;
            if (RegExp(r'^[0-7]{3}$').hasMatch(octal)) {
              Navigator.of(context).pop(octal);
            }
          },
          child: Text(l10n.sftpPermissionsApply),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drag Handle (resizable divider)
// ---------------------------------------------------------------------------

class _DragHandle extends StatefulWidget {
  const _DragHandle({required this.onDrag});

  final ValueChanged<double> onDrag;

  @override
  State<_DragHandle> createState() => _DragHandleState();
}

class _DragHandleState extends State<_DragHandle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          widget.onDrag(details.primaryDelta ?? 0);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 6,
          color: _isHovered ? AppColors.accentPrimary.withValues(alpha: 0.3) : AppColors.borderSubtle,
          child: Center(
            child: Container(
              width: 2,
              height: 32,
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppColors.accentPrimary
                    : AppColors.borderDefault,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Transfer Queue
// ---------------------------------------------------------------------------

class _TransferQueue extends StatelessWidget {
  const _TransferQueue({
    required this.transfers,
    required this.onClear,
  });

  final List<_TransferItem> transfers;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                Text(l10n.sftpTransfersHeader,
                    style: AppTypography.overline
                        .copyWith(color: AppColors.textTertiary)),
                const Spacer(),
                InkWell(
                  onTap: onClear,
                  child: Text(l10n.sftpTransfersClearDone,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.accentPrimary,
                        fontSize: 11,
                      )),
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
                        t.isUpload
                            ? LucideIcons.arrowRight
                            : LucideIcons.arrowLeft,
                        size: 12,
                        color: t.isUpload
                            ? AppColors.accentPrimary
                            : AppColors.accentCyan,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.name,
                                style: AppTypography.caption
                                    .copyWith(fontSize: 11),
                                overflow: TextOverflow.ellipsis),
                            if (t.error != null)
                              Text(t.error!,
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 10,
                                    color: AppColors.accentRed,
                                  ))
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
                            ? l10n.sftpTransferStatusDone
                            : t.error != null
                                ? l10n.sftpTransferStatusFailed
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
