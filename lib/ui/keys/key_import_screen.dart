/// Termius-style SSH key import screen.
///
/// Full-screen form for importing SSH private keys via:
/// - Pasting key content into a text area
/// - Selecting a file from the filesystem
///
/// Includes label, passphrase (optional), and key content fields.
library;

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../services/ssh/ssh_key_service.dart';

/// Full-screen SSH key import with paste area and file picker.
///
/// Modeled after Termius key import UX — user can either paste
/// key content directly or pick a file, with optional passphrase.
class KeyImportScreen extends ConsumerStatefulWidget {
  const KeyImportScreen({super.key});

  @override
  ConsumerState<KeyImportScreen> createState() => _KeyImportScreenState();
}

class _KeyImportScreenState extends ConsumerState<KeyImportScreen> {
  final _labelController = TextEditingController();
  final _passphraseController = TextEditingController();
  final _keyContentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isImporting = false;
  bool _obscurePassphrase = true;
  String? _selectedFileName;

  @override
  void dispose() {
    _labelController.dispose();
    _passphraseController.dispose();
    _keyContentController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.path == null) return;

      final content = await File(file.path!).readAsString();

      setState(() {
        _keyContentController.text = content;
        _selectedFileName = file.name;
        // Auto-fill label if empty
        if (_labelController.text.trim().isEmpty) {
          // Strip extension from filename for label
          final name = file.name.replaceAll(RegExp(r'\.(pem|key|pub|ppk)$'), '');
          _labelController.text = name;
        }
      });
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.keyImportFailedToReadFile(e.toString())),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();

    if (text == null || text.isEmpty) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.keyImportClipboardEmpty)),
        );
      }
      return;
    }

    setState(() {
      _keyContentController.text = text;
      _selectedFileName = null;
    });
  }

  Future<void> _importKey() async {
    if (!_formKey.currentState!.validate()) return;

    final keyContent = _keyContentController.text.trim();
    if (keyContent.isEmpty) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.keyImportPasteOrSelectKey),
          backgroundColor: AppColors.accentOrange,
        ),
      );
      return;
    }

    setState(() => _isImporting = true);

    try {
      final keyService = ref.read(sshKeyServiceProvider);
      final label = _labelController.text.trim().isEmpty
          ? 'Imported Key'
          : _labelController.text.trim();
      final passphrase = _passphraseController.text.isNotEmpty
          ? _passphraseController.text
          : null;

      final result = await keyService.importKey(
        label: label,
        privateKeyPem: keyContent,
        passphrase: passphrase,
      );

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.keyImportSuccess(result.fingerprint))),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      ErrorHandler.handle(e);
      if (mounted) {
        setState(() => _isImporting = false);
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
    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        backgroundColor: AppColors.bgDeep,
        title: Text(l10n.keyImportTitle, style: AppTypography.h2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Import button in app bar
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.icon(
              onPressed: _isImporting ? null : _importKey,
              icon: _isImporting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textInverse,
                      ),
                    )
                  : const Icon(LucideIcons.download, size: 16),
              label: Text(_isImporting ? l10n.keyImportButtonImporting : l10n.keyImportButton),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Label field
            Text(l10n.keyImportLabelField, style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            )),
            const SizedBox(height: 6),
            TextFormField(
              controller: _labelController,
              decoration: InputDecoration(
                hintText: l10n.keyImportLabelHint,
                prefixIcon: Icon(LucideIcons.tag, size: 18),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),

            // Passphrase field (optional)
            Text(l10n.keyImportPassphraseField, style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            )),
            const SizedBox(height: 6),
            TextFormField(
              controller: _passphraseController,
              decoration: InputDecoration(
                hintText: l10n.keyImportPassphraseHint,
                prefixIcon: Icon(LucideIcons.lock, size: 18),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassphrase ? LucideIcons.eyeOff : LucideIcons.eye,
                    size: 18,
                  ),
                  onPressed: () => setState(
                    () => _obscurePassphrase = !_obscurePassphrase,
                  ),
                ),
              ),
              obscureText: _obscurePassphrase,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),

            // Key content section
            Row(
              children: [
                Text(l10n.keyImportPrivateKeyField, style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                )),
                const Spacer(),
                // File picker button
                TextButton.icon(
                  onPressed: _pickFile,
                  icon: Icon(LucideIcons.fileUp, size: 16),
                  label: Text(l10n.keyImportFromFile),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 8),
                // Paste button
                TextButton.icon(
                  onPressed: _pasteFromClipboard,
                  icon: Icon(LucideIcons.clipboardPaste, size: 16),
                  label: Text(l10n.keyImportPaste),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // File name indicator
            if (_selectedFileName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(LucideIcons.file, size: 14, color: AppColors.accentGreen),
                    const SizedBox(width: 6),
                    Text(
                      _selectedFileName!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ],
                ),
              ),

            // Key content text area
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: TextFormField(
                controller: _keyContentController,
                decoration: InputDecoration(
                  hintText: l10n.keyImportPlaceholder,
                  hintStyle: AppTypography.code(fontSize: 12).copyWith(
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: AppTypography.code(fontSize: 12).copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 14,
                minLines: 8,
                textInputAction: TextInputAction.newline,
              ),
            ),
            const SizedBox(height: 12),

            // Help text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.info, size: 16, color: AppColors.accentPrimary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.keyImportSupportedFormats,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Import button at the bottom too (for mobile scrolling)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isImporting ? null : _importKey,
                icon: _isImporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textInverse,
                        ),
                      )
                    : const Icon(LucideIcons.download, size: 18),
                label: Text(
                  _isImporting ? l10n.keyImportButtonImporting : l10n.keyImportButtonImportKey,
                  style: const TextStyle(fontSize: 16),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
