/// SSH keys management screen.
///
/// Lists all stored SSH keys with options to import,
/// export, and delete keys. Includes search bar and
/// passphrase indicator per wireframe S5.1.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/clipboard_helper.dart';
import '../../core/utils/formatters.dart';
import '../../data/database/app_database.dart';
import '../../data/database/tables/keys_table.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/key_provider.dart';
import '../../services/ssh/ssh_key_service.dart';
import '../shared/confirmation_dialog.dart';
import '../shared/empty_state.dart';
import '../shared/error_display.dart';
import '../shared/loading_indicator.dart';
import 'key_import_screen.dart';

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
    final l10n = AppLocalizations.of(context);
    final keysAsync = ref.watch(allKeysProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text(l10n.keysTitle, style: AppTypography.h1),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            tooltip: l10n.keysImportTooltip,
            onPressed: () => _navigateToImport(context),
          ),
        ],
      ),
      body: keysAsync.when(
        data: (keys) {
          if (keys.isEmpty) {
            return EmptyState(
              icon: LucideIcons.keyRound,
              title: l10n.keysEmptyTitle,
              subtitle: l10n.keysEmptySubtitle,
              actionLabel: l10n.keysEmptyAction,
              onAction: () => _navigateToImport(context),
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
                    hintText: l10n.keysSearchHint,
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
                          l10n.keysNoMatchQuery(_searchQuery),
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
        loading: () => LoadingIndicator(message: l10n.keysLoadingMessage),
        error: (error, _) => ErrorDisplay(
          error: error,
          onRetry: () => ref.invalidate(allKeysProvider),
        ),
      ),
    );
  }

  void _navigateToImport(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const KeyImportScreen()),
    );
  }

  void _copyPublicKey(BuildContext context, SshKey key) {
    final l10n = AppLocalizations.of(context);
    copyWithAutoClear(key.publicKey);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.keyDetailPublicKeyCopied)),
      );
    }
  }

  Future<void> _deleteKey(
      BuildContext context, WidgetRef ref, SshKey key) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmationDialog(
      context: context,
      title: l10n.keysDeleteDialogTitle,
      message: l10n.keysDeleteDialogMessage(key.label),
      confirmLabel: l10n.delete,
      isDestructive: true,
    );

    if (confirmed) {
      final keyService = ref.read(sshKeyServiceProvider);
      await keyService.deleteKey(key.id);
    }
  }
}

/// Individual SSH key list item per wireframe S5.1.
class _KeyListItem extends StatefulWidget {
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

  @override
  State<_KeyListItem> createState() => _KeyListItemState();
}

class _KeyListItemState extends State<_KeyListItem> {
  bool _isHovered = false;

  String get _keyTypeLabel => switch (widget.sshKey.keyType) {
        KeyTypeEnum.ed25519 => 'Ed25519',
        KeyTypeEnum.rsa => 'RSA',
        KeyTypeEnum.ecdsa => 'ECDSA',
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovered ? -1 : 0, 0),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.bgRaised : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? AppColors.accentPrimary.withValues(alpha: 0.3)
                : AppColors.borderSubtle,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accentGlow,
                    blurRadius: 12,
                    spreadRadius: -2,
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          AppColors.accentPurple.withValues(alpha: 0.15),
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
                          widget.sshKey.label,
                          style: AppTypography.body
                              .copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_keyTypeLabel${widget.sshKey.keyBits != null ? ' ${widget.sshKey.keyBits}-bit' : ''}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Formatters.fingerprint(widget.sshKey.fingerprint),
                          style: AppTypography.code(fontSize: 11),
                        ),
                        if (widget.sshKey.hasPassphrase) ...[
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
                    tooltip: l10n.keyDetailCopyPublicKey,
                    onPressed: widget.onCopyPublicKey,
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      LucideIcons.moreVertical,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                    onSelected: (value) {
                      if (value == 'details') widget.onViewDetails();
                      if (value == 'delete') widget.onDelete();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'details',
                        child: Row(
                          children: [
                            Icon(LucideIcons.eye, size: 16),
                            SizedBox(width: 8),
                            Text(l10n.keyDetailTitle),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(LucideIcons.trash2,
                                size: 16, color: AppColors.accentRed),
                            SizedBox(width: 8),
                            Text(l10n.keysMenuDelete),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
