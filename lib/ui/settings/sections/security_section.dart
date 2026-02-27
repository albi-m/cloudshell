/// Security settings section.
///
/// Vault encryption, biometric lock, grace period, auto-lock,
/// TOTP 2FA, and known hosts management.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/errors/error_handler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_lock_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/totp_provider.dart';
import '../../../providers/vault_provider.dart';
import '../../../services/auth/totp_service.dart';
import '../../auth/totp_setup_screen.dart';
import '../../vault/master_password_setup_screen.dart';
import '../known_hosts_screen.dart';
import '../widgets/settings_section.dart';

/// Security section of the settings screen.
class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SettingsSection(
      title: l10n.sectionSecurity,
      children: [
        const VaultTile(),
        if (PlatformUtils.supportsBiometrics) const BiometricLockTile(),
        if (PlatformUtils.supportsBiometrics)
          const AppLockGracePeriodTile(),
        const AutoLockTile(),
        const TotpTile(),
        SettingsTile(
          icon: LucideIcons.shieldCheck,
          title: l10n.settingKnownHostsTitle,
          subtitle: l10n.settingKnownHostsSubtitle,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => const KnownHostsScreen()),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Vault Encryption Tile
// ---------------------------------------------------------------------------

/// Vault encryption setup/lock/change password tile.
class VaultTile extends ConsumerWidget {
  const VaultTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final vaultState = ref.watch(vaultProvider);

    return vaultState.when(
      data: (state) {
        switch (state) {
          case VaultState.noVault:
            return SettingsTile(
              icon: LucideIcons.shield,
              title: l10n.vaultEncryptionTitle,
              subtitle: l10n.vaultNotConfiguredSubtitle,
              onTap: () async {
                final result = await Navigator.of(context,
                        rootNavigator: true)
                    .push<bool>(MaterialPageRoute(
                  builder: (_) => const MasterPasswordSetupScreen(),
                ));
                if (result == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(l10n.vaultEncryptionEnabled)),
                  );
                }
              },
            );
          case VaultState.unlocked:
            return SettingsTile(
              icon: LucideIcons.shieldCheck,
              title: l10n.vaultEncryptionTitle,
              subtitle: l10n.vaultEncryptedUnlockedSubtitle,
              onTap: () => _showVaultOptions(context, ref),
            );
          case VaultState.locked:
          case VaultState.unlocking:
            return SettingsTile(
              icon: LucideIcons.lock,
              title: l10n.vaultEncryptionTitle,
              subtitle: l10n.vaultLockedSubtitle,
            );
        }
      },
      loading: () => SettingsTile(
        icon: LucideIcons.shield,
        title: l10n.vaultMasterPasswordTitle,
        subtitle: l10n.vaultLoadingSubtitle,
      ),
      error: (_, _) => SettingsTile(
        icon: LucideIcons.shield,
        title: l10n.vaultMasterPasswordTitle,
        subtitle: l10n.vaultErrorSubtitle,
      ),
    );
  }

  void _showVaultOptions(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.vaultDialogTitle, style: AppTypography.h2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.lock, size: 20),
              title: Text(l10n.vaultLockNow),
              onTap: () {
                Navigator.of(dialogContext).pop();
                ref.read(vaultProvider.notifier).lock();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.vaultLocked)),
                );
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.keyRound, size: 20),
              title: Text(l10n.vaultChangePassword),
              onTap: () {
                Navigator.of(dialogContext).pop();
                _showChangePasswordDialog(context, ref);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.changePasswordTitle, style: AppTypography.h2),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.changePasswordCurrentLabel,
                  prefixIcon: const Icon(LucideIcons.lock, size: 18),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.changePasswordNewLabel,
                  prefixIcon:
                      const Icon(LucideIcons.keyRound, size: 18),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.changePasswordConfirmLabel,
                  prefixIcon: const Icon(LucideIcons.lock, size: 18),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (newController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(l10n.changePasswordMismatch)),
                );
                return;
              }
              if (newController.text.length < 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(l10n.changePasswordMinLength)),
                );
                return;
              }
              final error = await ref
                  .read(vaultProvider.notifier)
                  .changePassword(
                      currentController.text, newController.text);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(error ?? l10n.changePasswordSuccess),
                  ),
                );
              }
            },
            child: Text(l10n.changePasswordSubmit),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Biometric Lock Toggle Tile
// ---------------------------------------------------------------------------

/// Toggle for enabling/disabling biometric app lock.
class BiometricLockTile extends ConsumerWidget {
  const BiometricLockTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isEnabled = ref.watch(biometricLockEnabledProvider);
    final biometricLabel = PlatformUtils.isMacOS
        ? l10n.biometricLabelTouchId
        : PlatformUtils.isIOS
            ? l10n.biometricLabelFaceId
            : l10n.biometricLabelBiometrics;

    return SettingsTile(
      icon: LucideIcons.fingerprint,
      title: l10n.biometricUnlockTitle,
      subtitle: biometricLabel,
      trailing: Switch(
        value: isEnabled,
        onChanged: (value) async {
          if (value) {
            final available = await ref
                .read(appLockProvider.notifier)
                .isBiometricAvailable();
            if (!available) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.biometricNotAvailable),
                  ),
                );
              }
              return;
            }
          }
          await setBiometricLockEnabled(ref, value);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// App Lock Grace Period Tile
// ---------------------------------------------------------------------------

/// Picker for the app lock grace period duration.
class AppLockGracePeriodTile extends ConsumerWidget {
  const AppLockGracePeriodTile({super.key});

  List<(int, String)> _gracePeriods(AppLocalizations l10n) => [
        (0, l10n.appLockGracePeriodImmediate),
        (30, l10n.appLockGracePeriod30Seconds),
        (60, l10n.appLockGracePeriod1Minute),
        (300, l10n.appLockGracePeriod5Minutes),
        (900, l10n.appLockGracePeriod15Minutes),
      ];

  String _gracePeriodLabel(int seconds, AppLocalizations l10n) {
    for (final (value, label) in _gracePeriods(l10n)) {
      if (value == seconds) return label;
    }
    return '$seconds seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isEnabled = ref.watch(biometricLockEnabledProvider);
    final gracePeriod = ref.watch(appLockGracePeriodProvider);

    if (!isEnabled) {
      return SettingsTile(
        icon: LucideIcons.timer,
        title: l10n.appLockGracePeriodTitle,
        subtitle: l10n.appLockGracePeriodEnableBiometricFirst,
      );
    }

    return SettingsTile(
      icon: LucideIcons.timer,
      title: l10n.appLockGracePeriodTitle,
      subtitle: _gracePeriodLabel(gracePeriod, l10n),
      onTap: () => _showGracePeriodPicker(context, ref, gracePeriod),
    );
  }

  void _showGracePeriodPicker(
      BuildContext context, WidgetRef ref, int current) {
    final l10n = AppLocalizations.of(context);
    final periods = _gracePeriods(l10n);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.appLockGracePeriodDialogTitle,
            style: AppTypography.h2),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        content: RadioGroup<int>(
          groupValue: current,
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .set(SettingsKeys.appLockGracePeriod,
                      value.toString());
              Navigator.of(dialogContext).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (value, label) in periods)
                RadioListTile<int>(
                  title: Text(label),
                  value: value,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Auto-Lock Tile
// ---------------------------------------------------------------------------

/// Picker for the vault auto-lock timeout.
class AutoLockTile extends ConsumerWidget {
  const AutoLockTile({super.key});

  List<(int, String)> _timeouts(AppLocalizations l10n) => [
        (0, l10n.autoLockTimeoutNever),
        (60, l10n.autoLockTimeout1Min),
        (300, l10n.autoLockTimeout5Min),
        (900, l10n.autoLockTimeout15Min),
        (1800, l10n.autoLockTimeout30Min),
        (3600, l10n.autoLockTimeout1Hour),
      ];

  String _timeoutLabel(int seconds, AppLocalizations l10n) {
    for (final (value, label) in _timeouts(l10n)) {
      if (value == seconds) return label;
    }
    return '$seconds seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final timeout = ref.watch(vaultAutoLockTimeoutProvider);
    final vaultState = ref.watch(vaultProvider);
    final hasVault =
        vaultState.value != VaultState.noVault;

    if (!hasVault) {
      return SettingsTile(
        icon: LucideIcons.clock,
        title: l10n.autoLockTitle,
        subtitle: l10n.autoLockSetUpVaultFirst,
      );
    }

    return SettingsTile(
      icon: LucideIcons.clock,
      title: l10n.autoLockTitle,
      subtitle: _timeoutLabel(timeout, l10n),
      onTap: () => _showAutoLockPicker(context, ref, timeout),
    );
  }

  void _showAutoLockPicker(
      BuildContext context, WidgetRef ref, int current) {
    final l10n = AppLocalizations.of(context);
    final timeouts = _timeouts(l10n);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title:
            Text(l10n.autoLockDialogTitle, style: AppTypography.h2),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        content: RadioGroup<int>(
          groupValue: current,
          onChanged: (value) {
            if (value != null) {
              ref.read(settingsNotifierProvider.notifier).set(
                  VaultSettingsKeys.autoLockTimeout,
                  value.toString());
              Navigator.of(dialogContext).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (value, label) in timeouts)
                RadioListTile<int>(
                  title: Text(label),
                  value: value,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TOTP 2FA Tile
// ---------------------------------------------------------------------------

/// Two-factor authentication settings tile.
class TotpTile extends ConsumerWidget {
  const TotpTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isAuth = ref.watch(isAuthenticatedProvider);
    final totpAsync = ref.watch(totpEnabledProvider);

    if (!isAuth) {
      return SettingsTile(
        icon: LucideIcons.shieldAlert,
        title: l10n.totp2faTitle,
        subtitle: l10n.totpSignInToEnable,
      );
    }

    final isEnabled = totpAsync.value ?? false;

    return SettingsTile(
      icon: isEnabled
          ? LucideIcons.shieldCheck
          : LucideIcons.shieldAlert,
      title: l10n.totp2faTitle,
      subtitle: isEnabled ? l10n.totpEnabled : l10n.totpNotConfigured,
      onTap: () {
        if (isEnabled) {
          _showDisable2faDialog(context, ref);
        } else {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => const TotpSetupScreen()),
          );
        }
      },
    );
  }

  void _showDisable2faDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.totpDisable2faTitle,
            style: AppTypography.h2),
        content: Text(l10n.totpDisable2faMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentRed,
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                final service = ref.read(totpServiceProvider);
                final factor =
                    await service.getVerifiedTotpFactor();
                if (factor != null) {
                  await service.unenroll(factor.id);
                  ref.invalidate(totpEnabledProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.totpDisabled),
                      ),
                    );
                  }
                }
              } catch (e, stackTrace) {
                ErrorHandler.handle(e, stackTrace);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${l10n.totpDisable2faTitle}: $e'),
                      backgroundColor: AppColors.accentRed,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.totpDisable2faSubmit),
          ),
        ],
      ),
    );
  }
}
