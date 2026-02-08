/// SSH keys management screen.
///
/// Lists all stored SSH keys with options to import,
/// export, and delete keys.
library;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/clipboard_helper.dart';
import '../../data/database/tables/keys_table.dart';
import '../../core/utils/formatters.dart';
import '../../data/database/app_database.dart';
import '../../providers/key_provider.dart';
import '../../services/ssh/ssh_key_service.dart';
import '../shared/confirmation_dialog.dart';
import '../shared/empty_state.dart';
import '../shared/loading_indicator.dart';

/// SSH keys list screen for managing authentication keys.
class KeysScreen extends ConsumerWidget {
  const KeysScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keysAsync = ref.watch(allKeysProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text('SSH Keys', style: AppTypography.h1),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            tooltip: 'Import key',
            onPressed: () => _showImportDialog(context, ref),
          ),
        ],
      ),
      body: keysAsync.when(
        data: (keys) {
          if (keys.isEmpty) {
            return EmptyState(
              icon: LucideIcons.keyRound,
              title: 'No SSH keys',
              subtitle: 'Import an SSH key for authentication.',
              actionLabel: 'Import Key',
              onAction: () => _showImportDialog(context, ref),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: keys.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              return _KeyListItem(
                sshKey: keys[index],
                onCopyPublicKey: () => _copyPublicKey(context, ref, keys[index]),
                onDelete: () => _deleteKey(context, ref, keys[index]),
              );
            },
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading keys...'),
        error: (error, _) => Center(
          child: Text(
            'Failed to load keys: $error',
            style: AppTypography.body.copyWith(color: AppColors.accentRed),
          ),
        ),
      ),
    );
  }

  Future<void> _showImportDialog(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    // Read file content
    final bytes = await file.readStream?.fold<List<int>>(
      [],
      (prev, data) => prev..addAll(data),
    );
    if (bytes == null) return;

    final pemContent = String.fromCharCodes(bytes);

    if (!context.mounted) return;

    // Show label input dialog
    final label = await _showLabelDialog(context, file.name);
    if (label == null) return;

    try {
      final keyService = ref.read(sshKeyServiceProvider);
      final result = await keyService.importKey(
        label: label,
        privateKeyPem: pemContent,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Key imported: ${result.fingerprint}')),
        );
      }
    } catch (e) {
      ErrorHandler.handle(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.userMessage(e)),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Future<String?> _showLabelDialog(BuildContext context, String defaultName) async {
    final controller = TextEditingController(text: defaultName);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Key Label', style: AppTypography.h2),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Label',
            hintText: 'e.g., My Ed25519 Key',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              Navigator.of(context).pop(text.isEmpty ? defaultName : text);
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _copyPublicKey(BuildContext context, WidgetRef ref, SshKey key) {
    copyWithAutoClear(key.publicKey);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Public key copied (auto-clears in 30s)')),
      );
    }
  }

  Future<void> _deleteKey(BuildContext context, WidgetRef ref, SshKey key) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Key',
      message: 'Are you sure you want to delete "${key.label}"? '
          'This will remove the private key from your keychain.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (confirmed) {
      final keyService = ref.read(sshKeyServiceProvider);
      await keyService.deleteKey(key.id);
    }
  }
}

/// Individual SSH key list item.
class _KeyListItem extends StatelessWidget {
  const _KeyListItem({
    required this.sshKey,
    required this.onCopyPublicKey,
    required this.onDelete,
  });

  final SshKey sshKey;
  final VoidCallback onCopyPublicKey;
  final VoidCallback onDelete;

  String get _keyTypeLabel => switch (sshKey.keyType) {
    KeyTypeEnum.ed25519 => 'Ed25519',
    KeyTypeEnum.rsa => 'RSA',
    KeyTypeEnum.ecdsa => 'ECDSA',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentPurple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LucideIcons.keyRound,
                size: 20,
                color: AppColors.accentPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sshKey.label,
                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$_keyTypeLabel${sshKey.keyBits != null ? ' ${sshKey.keyBits}-bit' : ''}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Formatters.fingerprint(sshKey.fingerprint),
                    style: AppTypography.code(fontSize: 11),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.copy, size: 18),
              tooltip: 'Copy public key',
              onPressed: onCopyPublicKey,
            ),
            IconButton(
              icon: const Icon(LucideIcons.trash2, size: 18, color: AppColors.accentRed),
              tooltip: 'Delete key',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
