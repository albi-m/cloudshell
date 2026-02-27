/// Sign-up screen for CloudShell sync accounts.
///
/// Creates a new account with email and password. The vault must
/// be set up first (master password) since the auth hash is derived
/// from the vault master key.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../settings/legal_screen.dart';

/// Full-screen sign-up screen.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _emailFocus = FocusNode();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  double _passwordStrength(String password) {
    if (password.isEmpty) return 0;
    var score = 0.0;
    if (password.length >= 10) score += 0.2;
    if (password.length >= 14) score += 0.1;
    if (RegExp(r'[a-z]').hasMatch(password)) score += 0.15;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 0.15;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 0.2;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score += 0.2;
    return score.clamp(0.0, 1.0);
  }

  String _strengthLabel(double strength, AppLocalizations l10n) {
    if (strength < 0.2) return l10n.passwordStrengthWeak;
    if (strength < 0.4) return l10n.passwordStrengthFair;
    if (strength < 0.6) return l10n.passwordStrengthGood;
    if (strength < 0.8) return l10n.passwordStrengthStrong;
    return l10n.passwordStrengthExcellent;
  }

  Color _strengthColor(double strength) {
    if (strength < 0.2) return AppColors.accentRed;
    if (strength < 0.4) return AppColors.accentOrange;
    if (strength < 0.6) return AppColors.accentCyan;
    if (strength < 0.8) return AppColors.accentGreen;
    return AppColors.accentBlue;
  }

  Future<void> _signUp() async {
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (email.isEmpty) {
      setState(() => _error = l10n.signUpErrorEmailRequired);
      return;
    }
    if (password.isEmpty) {
      setState(() => _error = l10n.signUpErrorPasswordRequired);
      return;
    }
    if (password.length < 10) {
      setState(() => _error = l10n.signUpErrorPasswordTooShort);
      return;
    }
    if (password != confirm) {
      setState(() => _error = l10n.signUpErrorPasswordMismatch);
      return;
    }
    if (!_acceptedTerms) {
      setState(() => _error = l10n.signUpErrorTermsRequired);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await ref.read(authProvider.notifier).signUp(email, password);

    if (!mounted) return;

    if (result == null) {
      context.go(RouteNames.hosts);
    } else {
      setState(() {
        _isLoading = false;
        _error = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final password = _passwordController.text;
    final strength = _passwordStrength(password);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
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
                    LucideIcons.userPlus,
                    color: AppColors.textInverse,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(l10n.appName, style: AppTypography.h2),
                const SizedBox(height: 6),
                Text(
                  l10n.signUpSubtitle,
                  style: AppTypography.body.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 32),

                // Email
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.signUpEmailLabel,
                    prefixIcon: const Icon(LucideIcons.mail, size: 18),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: l10n.signUpPasswordLabel,
                    prefixIcon: const Icon(LucideIcons.lock, size: 18),
                    suffixIcon: IconButton(
                      tooltip: 'Toggle password visibility',
                      icon: Icon(
                        _obscurePassword
                            ? LucideIcons.eyeOff
                            : LucideIcons.eye,
                        size: 18,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),

                // Password strength meter
                if (password.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: strength,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor:
                          AlwaysStoppedAnimation(_strengthColor(strength)),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _strengthLabel(strength, l10n),
                      style: AppTypography.caption.copyWith(
                        color: _strengthColor(strength),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Confirm password
                TextField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: l10n.signUpConfirmPasswordLabel,
                    prefixIcon: const Icon(LucideIcons.lock, size: 18),
                    suffixIcon: IconButton(
                      tooltip: 'Toggle password visibility',
                      icon: Icon(
                        _obscureConfirm
                            ? LucideIcons.eyeOff
                            : LucideIcons.eye,
                        size: 18,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  onSubmitted: (_) => _signUp(),
                ),
                const SizedBox(height: 16),

                // Warning
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
                          l10n.signUpEncryptionWarning,
                          style: AppTypography.caption.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Terms checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _acceptedTerms,
                        onChanged: (v) =>
                            setState(() => _acceptedTerms = v ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _acceptedTerms = !_acceptedTerms),
                        child: Text.rich(
                          TextSpan(
                            style: AppTypography.bodySmall.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                            children: [
                              TextSpan(text: l10n.signUpTermsPrefix),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const LegalScreen(
                                        title: 'Terms of Service',
                                        assetPath:
                                            'assets/legal/terms_of_service.md',
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.signUpTermsOfService,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: theme.colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(text: ' ${l10n.signUpTermsAnd} '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const LegalScreen(
                                        title: 'Privacy Policy',
                                        assetPath:
                                            'assets/legal/privacy_policy.md',
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.signUpPrivacyPolicy,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: theme.colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Error
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

                // Create account button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _signUp,
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
                              Text(l10n.signUpCreatingAccount),
                            ],
                          )
                        : Text(l10n.signUpCreateAccount),
                  ),
                ),
                const SizedBox(height: 16),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.signUpAlreadyHaveAccount,
                      style: AppTypography.bodySmall.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(l10n.signUpSignIn),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  l10n.signUpEncryptionNote,
                  style: AppTypography.caption.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.3),
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
