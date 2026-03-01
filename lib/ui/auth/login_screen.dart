/// Login screen for CloudShell sync accounts.
///
/// Allows users to sign in with email and password, navigate to
/// sign-up, or continue in local-only mode.
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
import 'totp_verify_screen.dart';

/// Full-screen login screen.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscure = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() => _error = l10n.loginErrorEmailRequired);
      return;
    }
    if (password.isEmpty) {
      setState(() => _error = l10n.loginErrorPasswordRequired);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await ref.read(authProvider.notifier).logIn(email, password);

    if (!mounted) return;

    if (result.isSuccess) {
      context.go(RouteNames.hosts);
    } else if (result.needs2fa) {
      // Navigate to TOTP verification screen
      setState(() => _isLoading = false);
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TotpVerifyScreen(factorId: result.factorId!),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
        _error = result.error;
      });
    }
  }

  void _useLocally() {
    ref.read(authProvider.notifier).setLocalOnly();
    context.go(RouteNames.hosts);
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
        leading: Navigator.of(context).canPop()
            ? IconButton(
                tooltip: 'Back',
                icon: const Icon(LucideIcons.arrowLeft, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
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
                    LucideIcons.cloud,
                    color: AppColors.textInverse,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(l10n.appName, style: AppTypography.h2),
                const SizedBox(height: 6),
                Text(
                  l10n.loginSubtitle,
                  style: AppTypography.body.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 32),

                // Email field
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.loginEmailLabel,
                    prefixIcon: const Icon(LucideIcons.mail, size: 18),
                  ),
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: l10n.loginPasswordLabel,
                    prefixIcon: const Icon(LucideIcons.lock, size: 18),
                    suffixIcon: IconButton(
                      tooltip: 'Toggle password visibility',
                      icon: Icon(
                        _obscure ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 18,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  onSubmitted: (_) => _logIn(),
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

                // Sign in button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _logIn,
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
                              Text(l10n.loginSigningIn),
                            ],
                          )
                        : Text(l10n.loginSignIn),
                  ),
                ),
                const SizedBox(height: 12),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => context.push(RouteNames.forgotPassword),
                    child: Text(
                      l10n.loginForgotPassword,
                      style: AppTypography.bodySmall.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // Create account link
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed:
                        _isLoading ? null : () => context.push(RouteNames.signUp),
                    child: Text(l10n.loginCreateAccount),
                  ),
                ),
                const SizedBox(height: 12),

                // Use locally
                TextButton(
                  onPressed: _isLoading ? null : _useLocally,
                  child: Text(
                    l10n.loginUseLocally,
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
