/// In-app editor for remote text files over SFTP.
///
/// Downloads file content, presents a monospace editor, and
/// re-uploads on save. Supports unsaved-change detection and
/// back-navigation confirmation.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../services/sftp/sftp_service.dart';

/// Full-screen text editor for a remote file.
class RemoteTextEditor extends StatefulWidget {
  const RemoteTextEditor({
    super.key,
    required this.sftp,
    required this.remotePath,
    required this.fileName,
  });

  final SftpService sftp;
  final String remotePath;
  final String fileName;

  @override
  State<RemoteTextEditor> createState() => _RemoteTextEditorState();
}

class _RemoteTextEditorState extends State<RemoteTextEditor> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  String _originalContent = '';
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  bool get _hasChanges => _controller.text != _originalContent;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadContent() async {
    try {
      final content = await widget.sftp.readFileContent(widget.remotePath);
      if (!mounted) return;
      setState(() {
        _originalContent = content;
        _controller.text = content;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await widget.sftp.writeFileContent(
        widget.remotePath,
        _controller.text,
      );
      if (!mounted) return;
      setState(() {
        _originalContent = _controller.text;
        _isSaving = false;
      });
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.remoteEditorFileSaved)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.remoteEditorFailedToSave(e.toString())),
          backgroundColor: AppColors.accentRed,
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.remoteEditorUnsavedChangesTitle),
        content: Text(l10n.remoteEditorUnsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('cancel'),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('discard'),
            child: Text(l10n.remoteEditorDiscard,
                style: TextStyle(color: AppColors.accentRed)),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop('save'),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (result == 'save') {
      await _save();
      return true;
    }
    return result == 'discard';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, size: 20),
            tooltip: 'Back',
            onPressed: () async {
              if (_hasChanges) {
                final shouldPop = await _onWillPop();
                if (shouldPop && context.mounted) {
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.fileText, size: 16),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.fileName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_hasChanges)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentOrange,
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              IconButton(
                icon: const Icon(LucideIcons.save, size: 20),
                tooltip: l10n.remoteEditorSaveTooltip,
                onPressed: _hasChanges ? _save : null,
              ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.alertTriangle,
                              size: 48, color: AppColors.accentRed),
                          const SizedBox(height: 16),
                          Text(l10n.remoteEditorFailedToLoadFile,
                              style: AppTypography.h3),
                          const SizedBox(height: 8),
                          Text(_error!,
                              style: AppTypography.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6)),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                                _error = null;
                              });
                              _loadContent();
                            },
                            icon: const Icon(LucideIcons.refreshCw, size: 16),
                            label: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ),
                  )
                : _buildEditor(theme),
      ),
    );
  }

  Widget _buildEditor(ThemeData theme) {
    return Scrollbar(
      controller: _scrollController,
      child: TextField(
        controller: _controller,
        scrollController: _scrollController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: AppTypography.code(fontSize: 13).copyWith(
          color: theme.colorScheme.onSurface,
          height: 1.5,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}
