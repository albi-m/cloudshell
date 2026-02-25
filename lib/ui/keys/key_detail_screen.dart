/// Key detail screen showing full information for a single SSH key.
///
/// Displays key type, fingerprint, public key, creation date,
/// associated hosts, and provides actions to copy, export, and delete.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
import '../shared/error_display.dart';
import '../shared/loading_indicator.dart';

/// Detail view for a single SSH key.
///
/// Shows all key metadata and provides copy, export, and delete actions.
class KeyDetailScreen extends ConsumerWidget {
  const KeyDetailScreen({super.key, required this.keyId});

  final String keyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final keyAsync = ref.watch(keyByIdProvider(keyId));

    return keyAsync.when(
      data: (key) {
        if (key == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.keyDetailNotFound)),
          );
        }
        return _KeyDetailView(sshKey: key);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: LoadingIndicator(message: l10n.keyDetailLoading),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorDisplay(
          error: error,
          onRetry: () => ref.invalidate(keyByIdProvider(keyId)),
        ),
      ),
    );
  }
}

class _KeyDetailView extends ConsumerWidget {
  const _KeyDetailView({required this.sshKey});

  final SshKey sshKey;

  String get _keyTypeLabel => switch (sshKey.keyType) {
        KeyTypeEnum.ed25519 => 'Ed25519',
        KeyTypeEnum.rsa => 'RSA',
        KeyTypeEnum.ecdsa => 'ECDSA',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hostsAsync = ref.watch(hostsByKeyIdProvider(sshKey.id));

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text(sshKey.label, style: AppTypography.h2),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical),
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  _delete(context, ref);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2,
                        size: 16, color: AppColors.accentRed),
                    SizedBox(width: 8),
                    Text(l10n.delete),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Key icon header
          _KeyIconHeader(keyType: _keyTypeLabel, sshKey: sshKey),
          const SizedBox(height: 24),

          // Actions row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _copyPublicKey(context),
                  icon: const Icon(LucideIcons.copy, size: 16),
                  label: Text(l10n.keyDetailCopyPublicKey),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Key info section
          _SectionCard(
            title: l10n.keyDetailSectionDetails,
            children: [
              _DetailRow(
                icon: LucideIcons.keyRound,
                label: l10n.keyDetailLabelType,
                value: '$_keyTypeLabel${sshKey.keyBits != null ? ' ${sshKey.keyBits}-bit' : ''}',
              ),
              _DetailRow(
                icon: LucideIcons.fingerprint,
                label: l10n.keyDetailSectionFingerprint,
                value: sshKey.fingerprint,
              ),
              if (sshKey.hasPassphrase)
                _DetailRow(
                  icon: LucideIcons.lock,
                  label: 'Passphrase',
                  value: 'Protected',
                ),
              _DetailRow(
                icon: LucideIcons.calendar,
                label: l10n.keyDetailLabelCreated,
                value: Formatters.relativeTime(sshKey.createdAt),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Public key section
          _SectionCard(
            title: l10n.keyDetailSectionPublicKey,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgDeepest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: SelectableText(
                  sshKey.publicKey,
                  style: AppTypography.code(fontSize: 11),
                  maxLines: 6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Associated hosts section
          _SectionCard(
            title: l10n.keyDetailSectionAssociatedHosts,
            children: [
              hostsAsync.when(
                data: (hosts) {
                  if (hosts.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        l10n.keyDetailNoAssociatedHosts,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: hosts.map((host) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.server, size: 14,
                                color: AppColors.textTertiary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                host.label,
                                style: AppTypography.body,
                              ),
                            ),
                            Text(
                              '${host.hostname}:${host.port}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: LinearProgressIndicator(),
                ),
                error: (_, _) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    l10n.error,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.accentRed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyPublicKey(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    copyWithAutoClear(sshKey.publicKey);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.keyDetailPublicKeyCopied)),
      );
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmationDialog(
      context: context,
      title: l10n.keysDeleteDialogTitle,
      message: l10n.keysDeleteDialogMessage(sshKey.label),
      confirmLabel: l10n.delete,
      isDestructive: true,
    );

    if (!confirmed) return;

    final keyService = ref.read(sshKeyServiceProvider);
    await keyService.deleteKey(sshKey.id);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

/// Key icon header showing key type badge.
class _KeyIconHeader extends StatelessWidget {
  const _KeyIconHeader({required this.keyType, required this.sshKey});

  final String keyType;
  final SshKey sshKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.accentPurple.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            LucideIcons.keyRound,
            size: 28,
            color: AppColors.accentPurple,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sshKey.label,
              style: AppTypography.h2,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.bgHover,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$keyType${sshKey.keyBits != null ? ' ${sshKey.keyBits}' : ''}',
                style: AppTypography.caption.copyWith(fontSize: 11),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Section card with a title label and list of children.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.overline
                  .copyWith(color: AppColors.textTertiary),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Single detail row with icon, label, and value.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTypography.body),
          ),
        ],
      ),
    );
  }
}
