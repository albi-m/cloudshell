/// SSH keys management screen.
///
/// Lists all stored SSH keys with options to import,
/// export, and delete keys. Includes search bar and
/// passphrase indicator per wireframe S5.1.
library;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_names.dart';
import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/clipboard_helper.dart';
import '../../core/utils/formatters.dart';
import '../../data/database/app_database.dart';
import '../../data/database/tables/keys_table.dart';
import '../../providers/key_provider.dart';
import '../../services/ssh/ssh_key_service.dart';
import '../shared/confirmation_dialog.dart';
import '../shared/empty_state.dart';
import '../shared/loading_indicator.dart';

/// SSH keys list screen for managing authentication keys.
///
/// Matches wireframe S5.1 with search, key type, fingerprint,
/// passphrase indicator, and copy/delete actions.
class KeysScreen extends ConsumerStatefulWidget {
  const KeysScreen({super.key});

  @override
  ConsumerState<KeysScreen> createState() => _KeysScreenState();
}

class _KeysScreenState extends ConsumerState<KeysScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keysAsync = ref.watch(allKeysProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text('SSH Keys', style: AppTypography.h1),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.upload),
            tooltip: 'Import key',
            onSelected: (value) {
              if (value == 'file') _showImportFromFile(context, ref);
              if (value == 'clipboard') _importFromClipboard(context, ref);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'file',
                child: Row(
                  children: [
                    Icon(LucideIcons.file, size: 16),
                    SizedBox(width: 8),
                    Text('Import from file'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clipboard',
                child: Row(
                  children: [
                    Icon(LucideIcons.clipboard, size: 16),
                    SizedBox(width: 8),
                    Text('Import from clipboard'),
                  ],
                ),
              ),
            ],
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
              onAction: () => _showImportFromFile(context, ref),
            );
          }

          // Filter keys by search query
          final filteredKeys = _searchQuery.isEmpty
              ? keys
              : keys.where((k) {
                  final q = _searchQuery.toLowerCase();
                  return k.label.toLowerCase().contains(q) ||
                      k.fingerprint.toLowerCase().contains(q);
                }).toList();

          return Column(
            children: [
              // Search bar (per wireframe S5.1)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search keys...',
                    prefixIcon: const Icon(LucideIcons.search, size: 18),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),

              // Keys list
              Expanded(
                child: filteredKeys.isEmpty
                    ? Center(
                        child: Text(
                          'No keys match "$_searchQuery"',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredKeys.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final key = filteredKeys[index];
                          return _KeyListItem(
                            sshKey: key,
                            onTap: () => context
                                .push(RouteNames.keyDetail(key.id)),
                            onCopyPublicKey: () =>
                                _copyPublicKey(context, key),
                            onViewDetails: () => context
                                .push(RouteNames.keyDetail(key.id)),
                            onDelete: () =>
                                _deleteKey(context, ref, key),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading keys...'),
        error: (error, _) => Center(
          child: Text(
            'Failed to load keys',
            style: AppTypography.body.copyWith(color: AppColors.accentRed),
          ),
        ),
      ),
    );
  }

  Future<void> _showImportFromFile(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    final bytes = await file.readStream?.fold<List<int>>(
      [],
      (prev, data) => prev..addAll(data),
    );
    if (bytes == null) return;

    final pemContent = String.fromCharCodes(bytes);

    if (!context.mounted) return;

    final label = await _showLabelDialog(context, file.name);
    if (label == null) return;

    try {
      final keyService = ref.read(sshKeyServiceProvider);
      final importResult = await keyService.importKey(
        label: label,
        privateKeyPem: pemContent,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Key imported: ${importResult.fingerprint}')),
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

  Future<String?> _showLabelDialog(
      BuildContext context, String defaultName) async {
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

  Future<void> _importFromClipboard(
      BuildContext context, WidgetRef ref) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final pemContent = data?.text?.trim();

    if (pemContent == null || pemContent.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clipboard is empty')),
        );
      }
      return;
    }

    if (!pemContent.contains('PRIVATE KEY')) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Clipboard does not contain a private key'),
            backgroundColor: AppColors.accentOrange,
          ),
        );
      }
      return;
    }

    if (!context.mounted) return;

    final label = await _showLabelDialog(context, 'Imported Key');
    if (label == null) return;

    try {
      final keyService = ref.read(sshKeyServiceProvider);
      final importResult = await keyService.importKey(
        label: label,
        privateKeyPem: pemContent,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Key imported: ${importResult.fingerprint}')),
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

  void _copyPublicKey(BuildContext context, SshKey key) {
    copyWithAutoClear(key.publicKey);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Public key copied (auto-clears in 30s)')),
      );
    }
  }

  Future<void> _deleteKey(
      BuildContext context, WidgetRef ref, SshKey key) async {
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

/// Individual SSH key list item per wireframe S5.1.
class _KeyListItem extends StatelessWidget {
  const _KeyListItem({
    required this.sshKey,
    required this.onTap,
    required this.onCopyPublicKey,
    required this.onViewDetails,
    required this.onDelete,
  });

  final SshKey sshKey;
  final VoidCallback onTap;
  final VoidCallback onCopyPublicKey;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  String get _keyTypeLabel => switch (sshKey.keyType) {
        KeyTypeEnum.ed25519 => 'Ed25519',
        KeyTypeEnum.rsa => 'RSA',
        KeyTypeEnum.ecdsa => 'ECDSA',
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
                    style: AppTypography.body
                        .copyWith(fontWeight: FontWeight.w600),
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
                  if (sshKey.hasPassphrase) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.lock,
                          size: 12,
                          color: AppColors.accentOrange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Passphrase protected',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.accentOrange,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.copy, size: 18),
              tooltip: 'Copy public key',
              onPressed: onCopyPublicKey,
            ),
            PopupMenuButton<String>(
              icon: const Icon(
                LucideIcons.moreVertical,
                size: 18,
                color: AppColors.textTertiary,
              ),
              onSelected: (value) {
                if (value == 'details') onViewDetails();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'details',
                  child: Row(
                    children: [
                      Icon(LucideIcons.eye, size: 16),
                      SizedBox(width: 8),
                      Text('View details'),
                    ],
                  ),
                ),
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
      ),
    );
  }
}
