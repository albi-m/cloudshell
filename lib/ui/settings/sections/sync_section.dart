/// Sync settings section.
///
/// Cloud sync account, auto-sync toggle, and sync now.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/route_names.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/sync_provider.dart';
import '../../../providers/vault_provider.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/sync/sync_service.dart';
import '../widgets/settings_section.dart';

/// Sync section of the settings screen.
class SyncSection extends StatelessWidget {
  const SyncSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SettingsSection(
      title: l10n.sectionSync,
      children: const [
        SyncAccountTile(),
        SyncToggleTile(),
        SyncNowTile(),
        ForceResyncTile(),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sync Account Tile
// ---------------------------------------------------------------------------

/// Sync account management tile (sign in, sign out, delete account).
class SyncAccountTile extends ConsumerWidget {
  const SyncAccountTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (state) {
        switch (state) {
          case AuthState.authenticated:
            final emailAsync = ref.watch(currentUserEmailProvider);
            final email =
                emailAsync.value ?? l10n.syncSignedInDefault;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingsTile(
                  icon: LucideIcons.cloudCog,
                  title: l10n.syncAccountTitle,
                  subtitle: email,
                  onTap: () =>
                      _showAccountOptions(context, ref, email),
                ),
              ],
            );

          case AuthState.localOnly:
            return SettingsTile(
              icon: LucideIcons.cloudOff,
              title: l10n.syncLocalOnlyTitle,
              subtitle: l10n.syncLocalOnlySubtitle,
              onTap: () async {
                await ref
                    .read(authProvider.notifier)
                    .clearLocalOnly();
                if (context.mounted) {
                  GoRouter.of(context).push(RouteNames.login);
                }
              },
            );

          case AuthState.unauthenticated:
          case AuthState.authenticating:
          case AuthState.passwordRecovery:
            return SettingsTile(
              icon: LucideIcons.cloud,
              title: l10n.syncCloudSyncTitle,
              subtitle: l10n.syncCloudSyncSubtitle,
              onTap: () =>
                  GoRouter.of(context).push(RouteNames.login),
            );
        }
      },
      loading: () => SettingsTile(
        icon: LucideIcons.cloud,
        title: l10n.syncCloudSyncTitle,
        subtitle: l10n.loading,
      ),
      error: (_, _) => SettingsTile(
        icon: LucideIcons.cloud,
        title: l10n.syncCloudSyncTitle,
        subtitle: l10n.syncCloudSyncSubtitle,
        onTap: () => GoRouter.of(context).push(RouteNames.login),
      ),
    );
  }

  void _showAccountOptions(
      BuildContext context, WidgetRef ref, String email) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title:
            Text(l10n.accountDialogTitle, style: AppTypography.h2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.user, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    email,
                    style: AppTypography.body,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading:
                  const Icon(LucideIcons.logOut, size: 20),
              title: Text(l10n.accountSignOut),
              onTap: () async {
                Navigator.of(dialogContext).pop();
                await ref
                    .read(authProvider.notifier)
                    .logOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(l10n.accountSignedOut)),
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.trash2,
                  size: 20, color: AppColors.accentRed),
              title: Text(
                l10n.accountDeleteAccount,
                style: const TextStyle(
                    color: AppColors.accentRed),
              ),
              onTap: () {
                Navigator.of(dialogContext).pop();
                _showDeleteAccountDialog(context, ref);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(
      BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        return StatefulBuilder(
          builder: (ctx, setState) {
            final canDelete = controller.text == 'DELETE';
            return AlertDialog(
              title: Text(l10n.deleteAccountTitle,
                  style: AppTypography.h2),
              content: SingleChildScrollView(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.accentRed
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.alertTriangle,
                            size: 20,
                            color: AppColors.accentRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.deleteAccountWarning,
                            style:
                                AppTypography.body.copyWith(
                              color: AppColors.accentRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.deleteAccountWillDelete,
                    style: AppTypography.body,
                  ),
                  const SizedBox(height: 8),
                  Text(
                      '  \u2022 ${l10n.deleteAccountItemAccount}'),
                  Text(
                      '  \u2022 ${l10n.deleteAccountItemSyncedData}'),
                  Text(
                      '  \u2022 ${l10n.deleteAccountItemVault}'),
                  const SizedBox(height: 8),
                  Text(
                    l10n.deleteAccountLocalDataNote,
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.deleteAccountConfirmPrompt,
                    style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: l10n.deleteAccountHint,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentRed,
                  ),
                  onPressed: canDelete
                      ? () async {
                          Navigator.of(dialogContext).pop();
                          await _performAccountDeletion(
                              context, ref);
                        }
                      : null,
                  child: Text(l10n.deleteAccountSubmit),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _performAccountDeletion(
      BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.deleteAccountDeleting)),
      );

      final authService = ref.read(authServiceProvider);
      final result = await authService.deleteAccount();

      if (!result.success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.error ??
                  l10n.deleteAccountFailedDefault),
              backgroundColor: AppColors.accentRed,
            ),
          );
        }
        return;
      }

      ref.read(vaultProvider.notifier).lock();
      await ref.read(authProvider.notifier).logOut();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deleteAccountSuccess),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(l10n.importFailed(e.toString())),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Sync Toggle Tile
// ---------------------------------------------------------------------------

/// Toggle for enabling/disabling automatic sync.
class SyncToggleTile extends ConsumerWidget {
  const SyncToggleTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isAuthenticated =
        authState.value == AuthState.authenticated;
    final syncEnabled = ref.watch(syncEnabledProvider);
    final isVaultUnlocked = ref.watch(isVaultUnlockedProvider);

    if (!isAuthenticated) {
      return const SizedBox.shrink();
    }

    final canSync = isAuthenticated && isVaultUnlocked;

    return SettingsTile(
      icon: LucideIcons.refreshCw,
      title: l10n.syncAutoSyncTitle,
      subtitle: !isVaultUnlocked
          ? l10n.syncUnlockVault
          : syncEnabled
              ? l10n.syncEvery5Minutes
              : l10n.syncDisabled,
      trailing: Switch(
        value: syncEnabled,
        onChanged: canSync
            ? (value) {
                if (value) {
                  ref
                      .read(syncProvider.notifier)
                      .enableSync();
                } else {
                  ref
                      .read(syncProvider.notifier)
                      .disableSync();
                }
              }
            : null,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sync Now Tile
// ---------------------------------------------------------------------------

/// Manual sync trigger with status display.
class SyncNowTile extends ConsumerWidget {
  const SyncNowTile({super.key});

  String _formatLastSync(
      DateTime? time, AppLocalizations l10n) {
    if (time == null) return l10n.syncNeverSynced;
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return l10n.syncJustNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final syncReady = ref.watch(syncReadyProvider);
    if (!syncReady) return const SizedBox.shrink();

    final syncStatus = ref.watch(syncProvider);
    final status =
        syncStatus.value ?? SyncStatus.disabled;
    final lastSync = ref.watch(lastSyncTimeProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider);
    final pending = pendingCount.value ?? 0;

    final isSyncing = status == SyncStatus.syncing;

    final lastSyncStr = lastSync.when(
      data: (time) => _formatLastSync(time, l10n),
      loading: () => l10n.loading,
      error: (_, _) => l10n.unknown,
    );

    final subtitle = isSyncing
        ? l10n.syncSyncing
        : pending > 0
            ? '$lastSyncStr \u2022 $pending pending'
            : lastSyncStr;

    return SettingsTile(
      icon: isSyncing
          ? LucideIcons.loader
          : LucideIcons.cloud,
      title: l10n.syncNowTitle,
      subtitle: subtitle,
      onTap: isSyncing
          ? null
          : () async {
              final result = await ref
                  .read(syncProvider.notifier)
                  .sync();
              if (result != null && context.mounted) {
                final msg = result.success
                    ? l10n.syncResult(
                        result.pulled, result.pushed)
                    : l10n.syncFailed(
                        result.error ?? l10n.unknown);
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(content: Text(msg)),
                );
              }
            },
    );
  }
}

// ---------------------------------------------------------------------------
// Force Re-sync Tile
// ---------------------------------------------------------------------------

/// Purges server data and re-pushes all local items.
class ForceResyncTile extends ConsumerWidget {
  const ForceResyncTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncReady = ref.watch(syncReadyProvider);
    if (!syncReady) return const SizedBox.shrink();

    final syncStatus = ref.watch(syncProvider);
    final isSyncing =
        syncStatus.value == SyncStatus.syncing;

    return SettingsTile(
      icon: LucideIcons.refreshCcw,
      title: 'Force Full Re-sync',
      subtitle:
          'Purge server data and re-push from this device',
      onTap: isSyncing
          ? null
          : () => _confirmForceResync(context, ref),
    );
  }

  void _confirmForceResync(
      BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Force Full Re-sync',
            style: AppTypography.h2),
        content: const Text(
          'This will delete all server sync data and '
          're-push everything from this device. Use this '
          'to fix duplicate or stale entries.\n\n'
          'Other devices will pull fresh data on their '
          'next sync.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final result = await ref
                  .read(syncProvider.notifier)
                  .forceFullResync();
              if (result != null && context.mounted) {
                final msg = result.success
                    ? 'Re-synced: pushed ${result.pushed} items'
                    : 'Re-sync failed: ${result.error}';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg)),
                );
              }
            },
            child: const Text('Re-sync'),
          ),
        ],
      ),
    );
  }
}
