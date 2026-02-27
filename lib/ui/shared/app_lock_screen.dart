/// Lock screen overlay for biometric authentication.
///
/// Shown when the app is locked. Displays the app logo and an
/// unlock button. Biometric authentication only triggers when
/// the user explicitly taps the button — no auto-prompts.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_lock_provider.dart';

/// Full-screen lock overlay that requires biometric authentication.
class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  bool _authFailed = false;
  Timer? _countdownTimer;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _authenticate() async {
    final notifier = ref.read(appLockProvider.notifier);

    // Check rate limiting
    if (notifier.isLockedOut) {
      _startCountdown();
      setState(() => _authFailed = true);
      return;
    }

    setState(() => _authFailed = false);
    final success = await notifier.authenticate();
    if (!success && mounted) {
      setState(() => _authFailed = true);
      if (notifier.isLockedOut) {
        _startCountdown();
      }
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        _countdownTimer?.cancel();
        return;
      }
      final notifier = ref.read(appLockProvider.notifier);
      if (!notifier.isLockedOut) {
        _countdownTimer?.cancel();
        _countdownTimer = null;
      }
      setState(() {}); // Refresh remaining time display
    });
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    if (minutes > 0) return '${minutes}m ${seconds}s';
    return '${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lockState = ref.watch(appLockProvider);
    final isAuthenticating = lockState == AppLockState.authenticating;
    final notifier = ref.read(appLockProvider.notifier);
    final lockedOut = notifier.isLockedOut;

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      body: Center(
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
                LucideIcons.terminal,
                color: AppColors.textInverse,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.appName,
              style: AppTypography.h2,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.appLockTitle,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Unlock button — only way to trigger biometric
            ElevatedButton.icon(
              onPressed: (lockedOut || isAuthenticating) ? null : _authenticate,
              icon: isAuthenticating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.fingerprint, size: 20),
              label: Text(isAuthenticating
                  ? l10n.appLockTitle
                  : l10n.appLockUnlockButton),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),

            if (!isAuthenticating) ...[
              if (_authFailed && !lockedOut) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.appLockFailed,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.accentRed,
                  ),
                ),
              ],

              if (lockedOut) ...[
                const SizedBox(height: 16),
                Text(
                  'Too many failed attempts. Try again in ${_formatDuration(notifier.lockoutRemaining)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.accentOrange,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
