/// Data settings section.
///
/// SSH config import, data export/import (plaintext and encrypted).
library;

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/crypto/secure_storage.dart';
import '../../../services/crypto/vault_crypto_service.dart';
import '../../../services/data/data_export_service.dart';
import '../ssh_config_import_screen.dart';
import '../widgets/settings_section.dart';

/// Data section of the settings screen.
class DataSection extends ConsumerWidget {
  const DataSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return SettingsSection(
      title: l10n.sectionData,
      children: [
        SettingsTile(
          icon: LucideIcons.fileCode,
          title: l10n.settingImportSshConfigTitle,
          subtitle: l10n.settingImportSshConfigSubtitle,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => const SshConfigImportScreen()),
          ),
        ),
        SettingsTile(
          icon: LucideIcons.download,
          title: l10n.settingExportDataTitle,
          subtitle: l10n.settingExportDataSubtitle,
          onTap: () => _exportData(context, ref),
        ),
        SettingsTile(
          icon: LucideIcons.upload,
          title: l10n.settingImportDataTitle,
          subtitle: l10n.settingImportDataSubtitle,
          onTap: () => _importData(context, ref),
        ),
      ],
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final choice = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.exportDataTitle, style: AppTypography.h2),
        content: Text(l10n.exportDataMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(null),
            child: Text(l10n.cancel),
          ),
          OutlinedButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop('plaintext'),
            child: Text(l10n.exportDataPlaintext),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop('encrypted'),
            child: Text(l10n.exportDataEncryptedVault),
          ),
        ],
      ),
    );

    if (choice == null || !context.mounted) return;

    if (choice == 'plaintext') {
      await _doPlaintextExport(context, ref);
    } else {
      await _doEncryptedExport(context, ref);
    }
  }

  Future<void> _doPlaintextExport(
      BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      final db = ref.read(databaseProvider);
      final service = DataExportService(db);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportDataExporting)),
      );

      final path = await service.exportData();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(l10n.exportedToFile(path.split('/').last)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportFailed(e.toString())),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Future<void> _doEncryptedExport(
      BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final password = await _showPasswordDialog(
      context,
      title: l10n.encryptedExportTitle,
      message: l10n.encryptedExportMessage,
      confirmLabel: l10n.encryptedExportConfirmLabel,
      requireConfirmation: true,
      minLength: 10,
    );

    if (password == null || !context.mounted) return;

    try {
      final db = ref.read(databaseProvider);
      final storage = ref.read(secureStorageProvider);
      final crypto = ref.read(vaultCryptoServiceProvider);
      final service = DataExportService(
        db,
        secureStorage: storage,
        vaultCrypto: crypto,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportDataEncrypting)),
      );

      final path = await service.exportEncryptedVault(password);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                l10n.vaultExportedToFile(path.split('/').last)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportFailed(e.toString())),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: l10n.importDataFileDialogTitle,
    );

    if (result == null || result.files.isEmpty || !context.mounted) {
      return;
    }

    final filePath = result.files.single.path;
    if (filePath == null || !context.mounted) return;

    final content = await File(filePath).readAsString();
    final isEncrypted =
        DataExportService.isEncryptedExport(content);

    if (!context.mounted) return;

    if (isEncrypted) {
      await _doEncryptedImport(context, ref, filePath);
    } else {
      await _doPlaintextImport(context, ref, filePath);
    }
  }

  Future<void> _doPlaintextImport(
      BuildContext context, WidgetRef ref, String filePath) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.importDataPlaintextTitle,
            style: AppTypography.h2),
        content: Text(l10n.importDataPlaintextMessage),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(true),
            child: Text(l10n.importDataPlaintextImport),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final db = ref.read(databaseProvider);
      final service = DataExportService(db);
      final importResult = await service.importData(filePath);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(importResult.summary),
            duration: const Duration(seconds: 4),
            backgroundColor:
                importResult.hasError ? AppColors.accentRed : null,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.importFailed(e.toString())),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Future<void> _doEncryptedImport(BuildContext context, WidgetRef ref,
      String filePath) async {
    final l10n = AppLocalizations.of(context);
    final password = await _showPasswordDialog(
      context,
      title: l10n.importDataDecryptTitle,
      message: l10n.importDataDecryptMessage,
      confirmLabel: l10n.importDataDecryptConfirmLabel,
    );

    if (password == null || !context.mounted) return;

    try {
      final db = ref.read(databaseProvider);
      final storage = ref.read(secureStorageProvider);
      final crypto = ref.read(vaultCryptoServiceProvider);
      final service = DataExportService(
        db,
        secureStorage: storage,
        vaultCrypto: crypto,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.importDataDecrypting)),
      );

      final importResult =
          await service.importEncryptedVault(filePath, password);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(importResult.summary),
            duration: const Duration(seconds: 4),
            backgroundColor:
                importResult.hasError ? AppColors.accentRed : null,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.importFailed(e.toString())),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Future<String?> _showPasswordDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    bool requireConfirmation = false,
    int minLength = 1,
  }) async {
    final l10n = AppLocalizations.of(context);
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    try {
      return await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (ctx, setState) {
              final pwd = passwordController.text;
              final confirm = confirmController.text;
              final tooShort = pwd.length < minLength;
              final mismatch = requireConfirmation &&
                  pwd.isNotEmpty &&
                  pwd != confirm;
              final canSubmit = pwd.isNotEmpty &&
                  !tooShort &&
                  (!requireConfirmation || pwd == confirm);

              return AlertDialog(
                title: Text(title, style: AppTypography.h2),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message, style: AppTypography.body),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText:
                            l10n.passwordDialogLabelPassword,
                        errorText: tooShort && pwd.isNotEmpty
                            ? l10n.passwordMinLength(
                                minLength.toString())
                            : null,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    if (requireConfirmation) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: confirmController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: l10n
                              .passwordDialogLabelConfirmPassword,
                          errorText: mismatch
                              ? l10n
                                  .passwordDialogErrorPasswordsDoNotMatch
                              : null,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(dialogContext).pop(null),
                    child: Text(l10n.cancel),
                  ),
                  FilledButton(
                    onPressed: canSubmit
                        ? () =>
                            Navigator.of(dialogContext).pop(pwd)
                        : null,
                    child: Text(confirmLabel ?? l10n.confirm),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      passwordController.dispose();
      confirmController.dispose();
    }
  }
}
