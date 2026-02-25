/// Forgot password screen for CloudShell sync accounts.
///
/// Allows users to request a password reset email.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../services/auth/auth_service.dart';

/// Full-screen forgot password screen.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  bool _isLoading = false;
  String? _error;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).forgotPasswordErrorEmailRequired);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final authService = ref.read(authServiceProvider);
    final result = await authService.resetPassword(email);

    if (!mounted) return;

    if (result.success) {
      setState(() {
        _isLoading = false;
        _sent = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _error = result.error;
      });
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
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: _sent ? _buildSuccessView(theme, l10n) : _buildFormView(theme, l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView(ThemeData theme, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
        Text(l10n.appName, style: AppTypography.h2),
        const SizedBox(height: 6),
        Text(
          l10n.forgotPasswordTitle,
          style: AppTypography.body.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.forgotPasswordInstructions,
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 32),

        // Email field
        TextField(
          controller: _emailController,
          focusNode: _emailFocus,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: l10n.forgotPasswordEmailLabel,
            prefixIcon: const Icon(LucideIcons.mail, size: 18),
          ),
          onSubmitted: (_) => _resetPassword(),
        ),

        // Error display
        if (_error != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentRed.withValues(alpha: 0.1),
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

        // Send reset link button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: _isLoading ? null : _resetPassword,
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
                      Text(l10n.forgotPasswordSending),
                    ],
                  )
                : Text(l10n.forgotPasswordSendResetLink),
          ),
        ),
        const SizedBox(height: 16),

        // Back to login
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            l10n.forgotPasswordBackToSignIn,
            style: AppTypography.bodySmall.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView(ThemeData theme, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.accentGreen.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            LucideIcons.mailCheck,
            color: AppColors.accentGreen,
            size: 32,
          ),
        ),
        const SizedBox(height: 20),
        Text(l10n.forgotPasswordCheckEmail, style: AppTypography.h2),
        const SizedBox(height: 12),
        Text(
          l10n.forgotPasswordSuccessMessage(_emailController.text.trim()),
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accentOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.accentOrange.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.shieldAlert,
                  size: 16, color: AppColors.accentOrange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.forgotPasswordVaultWarning,
                  style: AppTypography.caption.copyWith(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.forgotPasswordBackToSignIn),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            setState(() {
              _sent = false;
              _error = null;
            });
          },
          child: Text(l10n.forgotPasswordTryAgain),
        ),
      ],
    );
  }
}
