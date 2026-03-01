/// TOTP 2FA enrollment screen.
///
/// Allows the user to set up two-factor authentication by scanning
/// a QR code with their authenticator app and verifying with a code.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/clipboard_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../services/auth/totp_service.dart';

/// Full-screen TOTP enrollment flow.
class TotpSetupScreen extends ConsumerStatefulWidget {
  const TotpSetupScreen({super.key});

  @override
  ConsumerState<TotpSetupScreen> createState() => _TotpSetupScreenState();
}

class _TotpSetupScreenState extends ConsumerState<TotpSetupScreen> {
  final _codeController = TextEditingController();
  TotpEnrollmentResult? _enrollment;
  bool _isEnrolling = true;
  bool _isVerifying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startEnrollment();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _startEnrollment() async {
    try {
      final service = ref.read(totpServiceProvider);
      final result = await service.enroll();
      if (mounted) {
        setState(() {
          _enrollment = result;
          _isEnrolling = false;
        });
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (mounted) {
        setState(() {
          _isEnrolling = false;
          _error = ErrorHandler.userMessage(e);
        });
      }
    }
  }

  Future<void> _verifyAndEnable() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _error = AppLocalizations.of(context).totpSetupErrorCodeLength);
      return;
    }

    setState(() {
      _isVerifying = true;
      _error = null;
    });

    try {
      final service = ref.read(totpServiceProvider);
      await service.verifyEnrollment(_enrollment!.factorId, code);

      // Invalidate the status provider so settings refreshes
      ref.invalidate(totpEnabledProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).totpSetupEnabled),
            backgroundColor: AppColors.accentGreen,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _error = AppLocalizations.of(context).totpSetupErrorInvalidCode;
          _codeController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.totpSetupTitle),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: _isVerifying ? null : () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _isEnrolling
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(48),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _enrollment == null
                    ? _buildError()
                    : _buildSetupForm(theme, l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        const Icon(LucideIcons.alertTriangle,
            size: 48, color: AppColors.accentRed),
        const SizedBox(height: 16),
        Text(_error ?? l10n.totpSetupFailed, style: AppTypography.body),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            setState(() {
              _isEnrolling = true;
              _error = null;
            });
            _startEnrollment();
          },
          child: Text(l10n.retry),
        ),
      ],
    );
  }

  Widget _buildSetupForm(ThemeData theme, AppLocalizations l10n) {
    final enrollment = _enrollment!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        Text(l10n.totpSetupHeading, style: AppTypography.h1),
        const SizedBox(height: 8),
        Text(
          l10n.totpSetupInstructions,
          style: AppTypography.body.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),

        // QR Code
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: enrollment.totpUri,
              version: QrVersions.auto,
              size: 200,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Manual entry secret
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.totpSetupManualEntryKey,
                      style: AppTypography.caption.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      enrollment.secret,
                      style: AppTypography.code(),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Copy secret key',
                icon: const Icon(LucideIcons.copy, size: 18),
                onPressed: () {
                  copyWithAutoClear(enrollment.secret);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.totpSetupSecretCopied)),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Verification code input
        Text(l10n.totpSetupEnterCode,
            style: AppTypography.body),
        const SizedBox(height: 8),
        TextField(
          controller: _codeController,
          autofocus: false,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: AppTypography.h2,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: l10n.totpSetupCodeHint,
            counterText: '',
            errorText: _error,
            prefixIcon: const Icon(LucideIcons.keyRound, size: 18),
          ),
          onSubmitted: (_) => _verifyAndEnable(),
        ),
        const SizedBox(height: 24),

        // Verify button
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: _isVerifying ? null : _verifyAndEnable,
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
                      Text(l10n.totpSetupVerifying),
                    ],
                  )
                : Text(l10n.totpSetupVerifyAndEnable),
          ),
        ),
      ],
    );
  }
}
