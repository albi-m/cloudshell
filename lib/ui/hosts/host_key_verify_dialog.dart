/// Host key verification dialog for CloudShell.
///
/// Shown when connecting to a new or changed SSH server to
/// verify the host's public key fingerprint (TOFU model).
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/clipboard_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../services/ssh/ssh_service.dart';

/// Shows a host key verification dialog and returns the user's decision.
///
/// Displays the server's fingerprint from [keyInfo] so the user can verify
/// trust on first use (TOFU) or detect a changed host key.
/// Returns `true` if the user accepts the key, `false` to abort the connection.
Future<bool> showHostKeyVerifyDialog({
  required BuildContext context,
  required HostKeyInfo keyInfo,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _HostKeyVerifyDialog(keyInfo: keyInfo),
  );
  return result ?? false;
}

class _HostKeyVerifyDialog extends StatelessWidget {
  const _HostKeyVerifyDialog({required this.keyInfo});

  final HostKeyInfo keyInfo;

  bool get _isChanged => keyInfo.status == HostKeyStatus.changed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _isChanged ? LucideIcons.shieldAlert : LucideIcons.shieldQuestion,
            color: _isChanged ? AppColors.accentRed : AppColors.accentOrange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isChanged ? l10n.hostKeyVerifyChangedTitle : l10n.hostKeyVerifyUnknownTitle,
              style: AppTypography.h2,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isChanged) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.accentRed.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                l10n.hostKeyVerifyChangedWarning,
                style: AppTypography.body.copyWith(color: AppColors.accentRed),
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            Text(
              l10n.hostKeyVerifyUnknownMessage,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Host info
          _InfoRow(label: l10n.hostKeyVerifyLabelHost, value: '${keyInfo.hostname}:${keyInfo.port}'),
          const SizedBox(height: 8),
          _InfoRow(label: l10n.hostKeyVerifyLabelKeyType, value: keyInfo.keyType),
          const SizedBox(height: 8),

          // Fingerprint (tappable to copy)
          Text(
            l10n.hostKeyVerifyLabelFingerprint,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () {
              copyWithAutoClear(keyInfo.fingerprint);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.hostKeyVerifyFingerprintCopied),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.bgDeepest,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      keyInfo.fingerprint,
                      style: AppTypography.code(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(LucideIcons.copy, size: 14, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: _isChanged
              ? ElevatedButton.styleFrom(backgroundColor: AppColors.accentRed)
              : null,
          child: Text(_isChanged ? l10n.hostKeyVerifyTrustAnyway : l10n.hostKeyVerifyTrustAndConnect),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.body,
          ),
        ),
      ],
    );
  }
}
