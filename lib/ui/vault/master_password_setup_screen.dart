/// Master password setup screen for vault initialization.
///
/// Shown when the user enables vault encryption for the first time.
/// Collects and validates a master password, then creates the vault.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/vault_provider.dart';

/// Full-screen master password setup flow.
class MasterPasswordSetupScreen extends ConsumerStatefulWidget {
  const MasterPasswordSetupScreen({super.key});

  @override
  ConsumerState<MasterPasswordSetupScreen> createState() =>
      _MasterPasswordSetupScreenState();
}

class _MasterPasswordSetupScreenState
    extends ConsumerState<MasterPasswordSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isCreating = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  double _passwordStrength(String password) {
    if (password.isEmpty) return 0;
    var score = 0.0;
    if (password.length >= 10) score += 0.2;
    if (password.length >= 14) score += 0.1;
    if (password.length >= 18) score += 0.1;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 0.15;
    if (RegExp(r'[a-z]').hasMatch(password)) score += 0.1;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 0.15;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score += 0.2;
    return score.clamp(0.0, 1.0);
  }

  String _strengthLabel(double strength, AppLocalizations l10n) {
    if (strength < 0.3) return l10n.masterPasswordSetupStrengthWeak;
    if (strength < 0.5) return l10n.masterPasswordSetupStrengthFair;
    if (strength < 0.7) return l10n.masterPasswordSetupStrengthGood;
    if (strength < 0.9) return l10n.masterPasswordSetupStrengthStrong;
    return l10n.passwordStrengthExcellent;
  }

  Color _strengthColor(double strength) {
    if (strength < 0.3) return AppColors.accentRed;
    if (strength < 0.5) return AppColors.accentOrange;
    if (strength < 0.7) return AppColors.accentOrange;
    if (strength < 0.9) return AppColors.accentGreen;
    return AppColors.accentPrimary;
  }

  Future<void> _createVault() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
      _error = null;
    });

    try {
      await ref
          .read(vaultProvider.notifier)
          .setupVault(_passwordController.text);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (mounted) {
        setState(() {
          _isCreating = false;
          _error = ErrorHandler.userMessage(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    final strength = _passwordStrength(password);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.masterPasswordSetupTitle),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(LucideIcons.x),
          onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Lock icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientBrandFor(context),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      LucideIcons.shield,
                      color: AppColors.textInverse,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.masterPasswordSetupTitle, style: AppTypography.h1),
                  const SizedBox(height: 8),
                  Text(
                    l10n.masterPasswordSetupSubtitle,
                    style: AppTypography.body.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Warning box
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
                        const Icon(LucideIcons.alertTriangle,
                            size: 18, color: AppColors.accentOrange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.masterPasswordSetupWarning,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.accentOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: l10n.masterPasswordSetupPasswordLabel,
                      hintText: l10n.masterPasswordSetupPasswordHint,
                      prefixIcon: const Icon(LucideIcons.lock, size: 18),
                      suffixIcon: IconButton(
                        tooltip: 'Toggle password visibility',
                        icon: Icon(
                          _obscurePassword
                              ? LucideIcons.eyeOff
                              : LucideIcons.eye,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(
                              () => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.signUpErrorPasswordRequired;
                      }
                      if (value.length < 10) {
                        return l10n.masterPasswordSetupMinLength;
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 8),

                  // Strength indicator
                  if (password.isNotEmpty) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: strength,
                              minHeight: 4,
                              backgroundColor: theme.colorScheme.outlineVariant,
                              valueColor: AlwaysStoppedAnimation(
                                  _strengthColor(strength)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _strengthLabel(strength, l10n),
                          style: AppTypography.caption.copyWith(
                            color: _strengthColor(strength),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 8),

                  // Confirm password
                  TextFormField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      labelText: l10n.masterPasswordSetupConfirmLabel,
                      hintText: l10n.masterPasswordSetupConfirmHint,
                      prefixIcon: const Icon(LucideIcons.lock, size: 18),
                      suffixIcon: IconButton(
                        tooltip: 'Toggle password visibility',
                        icon: Icon(
                          _obscureConfirm
                              ? LucideIcons.eyeOff
                              : LucideIcons.eye,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(
                              () => _obscureConfirm = !_obscureConfirm);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return l10n.masterPasswordSetupMismatch;
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _createVault(),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),

                  // Error message
                  if (_error != null) ...[
                    Text(
                      _error!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.accentRed,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Create button
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _isCreating ? null : _createVault,
                      child: _isCreating
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
                                Text(l10n.masterPasswordSetupCreating),
                              ],
                            )
                          : Text(l10n.masterPasswordSetupButton),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Encryption: Argon2id + AES-256-GCM',
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
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
