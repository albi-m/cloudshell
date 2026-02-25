/// Vault unlock screen.
///
/// Shown when the vault is locked. Allows the user to enter their
/// master password or use biometric authentication to unlock.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/platform_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/vault_provider.dart';

/// Full-screen vault unlock screen.
class VaultUnlockScreen extends ConsumerStatefulWidget {
  const VaultUnlockScreen({super.key});

  @override
  ConsumerState<VaultUnlockScreen> createState() => _VaultUnlockScreenState();
}

class _VaultUnlockScreenState extends ConsumerState<VaultUnlockScreen> {
  final _passwordController = TextEditingController();
  final _focusNode = FocusNode();
  bool _obscure = true;
  bool _isUnlocking = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).vaultUnlockPasswordHint);
      return;
    }

    setState(() {
      _isUnlocking = true;
      _error = null;
    });

    final result = await ref.read(vaultProvider.notifier).unlock(password);

    if (mounted) {
      if (result != null) {
        // Unlock failed
        setState(() {
          _isUnlocking = false;
          _error = result;
        });
        _passwordController.clear();
        _focusNode.requestFocus();
      } else {
        // Success — navigate to hosts
        GoRouter.of(context).go(RouteNames.hosts);
      }
    }
  }

  Future<void> _unlockWithBiometric() async {
    setState(() {
      _isUnlocking = true;
      _error = null;
    });

    final result = await ref.read(vaultProvider.notifier).unlockWithBiometric();

    if (mounted) {
      if (result != null) {
        setState(() {
          _isUnlocking = false;
          _error = result;
        });
      } else {
        // Success — navigate to hosts
        GoRouter.of(context).go(RouteNames.hosts);
      }
    }
  }

  Future<void> _forgotPassword() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(LucideIcons.alertTriangle,
                color: AppColors.accentRed, size: 20),
            const SizedBox(width: 8),
            Text(l10n.vaultUnlockResetTitle, style: AppTypography.h2),
          ],
        ),
        content: Text(l10n.vaultUnlockResetMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentRed,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.vaultUnlockResetConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(vaultProvider.notifier).resetVault();
      if (mounted) {
        GoRouter.of(context).go(RouteNames.hosts);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientBrandFor(context),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    LucideIcons.lock,
                    color: AppColors.textInverse,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(l10n.vaultUnlockTitle, style: AppTypography.h2),
                const SizedBox(height: 6),
                Text(
                  l10n.vaultUnlockSubtitle,
                  style: AppTypography.body.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 32),

                // Password field
                TextField(
                  controller: _passwordController,
                  focusNode: _focusNode,
                  obscureText: _obscure,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.vaultUnlockPasswordLabel,
                    prefixIcon: const Icon(LucideIcons.lock, size: 18),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() => _obscure = !_obscure);
                      },
                    ),
                    errorText: _error,
                  ),
                  onSubmitted: (_) => _unlock(),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),

                // Unlock button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _isUnlocking ? null : _unlock,
                    child: _isUnlocking
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(l10n.vaultUnlockUnlocking),
                            ],
                          )
                        : Text(l10n.vaultUnlockButton),
                  ),
                ),
                const SizedBox(height: 12),

                // Biometric unlock button
                if (PlatformUtils.supportsBiometrics)
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: _isUnlocking ? null : _unlockWithBiometric,
                      icon: const Icon(LucideIcons.fingerprint, size: 18),
                      label: Text(l10n.vaultUnlockBiometricButton),
                    ),
                  ),

                const SizedBox(height: 24),

                // Forgot password link
                TextButton(
                  onPressed: _isUnlocking ? null : _forgotPassword,
                  child: Text(
                    l10n.vaultUnlockForgotPassword,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.accentRed.withValues(alpha: 0.8),
                    ),
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
