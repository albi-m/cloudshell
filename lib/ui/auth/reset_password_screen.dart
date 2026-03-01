/// Reset password screen shown after clicking the email reset link.
///
/// The user enters a new password, which updates their Supabase auth
/// password and resets+recreates the vault with the new password.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart' show authProvider;
import '../../providers/vault_provider.dart' show vaultProvider;
import '../../services/auth/auth_service.dart';

/// Full-screen reset password screen.
///
/// Shown when Supabase fires a [passwordRecovery] auth event after
/// the user clicks the reset link in their email.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (password.length < 10) {
      setState(() => _error = l10n.resetPasswordTooShort);
      return;
    }
    if (password != confirm) {
      setState(() => _error = l10n.resetPasswordMismatch);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    // 1. Update Supabase auth password
    final authService = ref.read(authServiceProvider);
    final result = await authService.updatePassword(password);

    if (!mounted) return;

    if (!result.success) {
      setState(() {
        _isLoading = false;
        _error = result.error;
      });
      return;
    }

    // 2. Reset vault and recreate with new password
    final vaultNotifier = ref.read(vaultProvider.notifier);
    await vaultNotifier.resetVault();
    await vaultNotifier.setupVault(password);

    if (!mounted) return;

    // 3. Set auth state back to authenticated
    ref.read(authProvider.notifier).completePasswordRecovery();

    // 4. Navigate to hosts
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.resetPasswordSuccess)),
      );
      context.go(RouteNames.hosts);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientBrandFor(context),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    LucideIcons.keyRound,
                    color: AppColors.textInverse,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(l10n.resetPasswordTitle, style: AppTypography.h2),
                const SizedBox(height: 8),
                Text(
                  l10n.resetPasswordInstructions,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 16),

                // Vault warning
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          AppColors.accentOrange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(LucideIcons.shieldAlert,
                          size: 18, color: AppColors.accentOrange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.resetPasswordVaultWarning,
                          style: AppTypography.caption.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // New password field
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  autofocus: true,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.resetPasswordNewLabel,
                    prefixIcon: const Icon(LucideIcons.lock, size: 18),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? LucideIcons.eyeOff
                            : LucideIcons.eye,
                        size: 18,
                      ),
                      onPressed: () =>
                          setState(() => _obscure = !_obscure),
                    ),
                  ),
                  onSubmitted: (_) => _confirmFocus.requestFocus(),
                ),
                const SizedBox(height: 16),

                // Confirm password field
                TextField(
                  controller: _confirmController,
                  focusNode: _confirmFocus,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: l10n.resetPasswordConfirmLabel,
                    prefixIcon: const Icon(LucideIcons.lock, size: 18),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? LucideIcons.eyeOff
                            : LucideIcons.eye,
                        size: 18,
                      ),
                      onPressed: () => setState(
                          () => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  onSubmitted: (_) => _submit(),
                ),

                // Error display
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          AppColors.accentRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.alertCircle,
                            size: 16, color: AppColors.accentRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: AppTypography.bodySmall
                                .copyWith(color: AppColors.accentRed),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
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
                              Text(l10n.resetPasswordUpdating),
                            ],
                          )
                        : Text(l10n.resetPasswordSubmit),
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
