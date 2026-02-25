/// TOTP verification screen shown during login when 2FA is required.
///
/// The user enters a 6-digit code from their authenticator app
/// to complete the sign-in process.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth/totp_service.dart';
import '../../providers/backend_provider.dart';

/// Full-screen TOTP verification during login.
class TotpVerifyScreen extends ConsumerStatefulWidget {
  const TotpVerifyScreen({
    super.key,
    required this.factorId,
  });

  /// The MFA factor ID to challenge.
  final String factorId;

  @override
  ConsumerState<TotpVerifyScreen> createState() => _TotpVerifyScreenState();
}

class _TotpVerifyScreenState extends ConsumerState<TotpVerifyScreen> {
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isVerifying = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _error = AppLocalizations.of(context).totpVerifyErrorInvalidCode);
      return;
    }

    setState(() {
      _isVerifying = true;
      _error = null;
    });

    try {
      // Create challenge then verify
      final service = ref.read(totpServiceProvider);
      final challenge = await service.createChallenge(widget.factorId);

      final backend = ref.read(authBackendProvider);
      final result = await backend!.verifyMfa(
        widget.factorId,
        challenge.challengeId,
        code,
      );

      if (!mounted) return;

      if (result.success) {
        // Complete the login (vault unlock, settings, etc.)
        await ref.read(authProvider.notifier).completeMfaLogin();

        if (mounted) {
          context.go(RouteNames.hosts);
        }
      } else {
        setState(() {
          _isVerifying = false;
          _error = result.error ?? AppLocalizations.of(context).totpVerifyErrorDefaultFailed;
          _codeController.clear();
          _focusNode.requestFocus();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _error = AppLocalizations.of(context).totpVerifyErrorInvalidCode;
          _codeController.clear();
          _focusNode.requestFocus();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: !_isVerifying,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ref.read(authProvider.notifier).cancelMfaLogin();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, size: 20),
            onPressed: _isVerifying
                ? null
                : () {
                    ref.read(authProvider.notifier).cancelMfaLogin();
                    Navigator.of(context).pop();
                  },
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
                  // Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientBrandFor(context),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      LucideIcons.shieldCheck,
                      color: AppColors.textInverse,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.totpVerifyHeading, style: AppTypography.h2),
                  const SizedBox(height: 6),
                  Text(
                    l10n.totpVerifyInstructions,
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Code input
                  TextField(
                    controller: _codeController,
                    focusNode: _focusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: AppTypography.h2,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: l10n.totpVerifyCodeHint,
                      counterText: '',
                      prefixIcon: const Icon(LucideIcons.keyRound, size: 18),
                      errorText: _error,
                    ),
                    onSubmitted: (_) => _verify(),
                  ),
                  const SizedBox(height: 24),

                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _isVerifying ? null : _verify,
                      child: _isVerifying
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
                                Text(l10n.totpVerifyVerifying),
                              ],
                            )
                          : Text(l10n.totpVerifySubmit),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.totpVerifyHelpText,
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.4),
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
