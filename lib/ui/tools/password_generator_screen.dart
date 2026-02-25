/// Password generator screen.
///
/// Generates cryptographically secure passwords with configurable
/// length, character sets, and one-tap copy to clipboard.
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/clipboard_helper.dart';
import '../../l10n/app_localizations.dart';

/// Full-screen password generator.
class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen>
    with SingleTickerProviderStateMixin {
  static const _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _digits = '0123456789';
  static const _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  final _random = Random.secure();
  late AnimationController _copyAnimController;
  late Animation<double> _copyAnim;

  String _password = '';
  double _length = 20;
  bool _useLowercase = true;
  bool _useUppercase = true;
  bool _useDigits = true;
  bool _useSymbols = true;
  bool _avoidAmbiguous = false;
  final List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _copyAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _copyAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _copyAnimController, curve: Curves.easeOut),
    );
    _generate();
  }

  @override
  void dispose() {
    _copyAnimController.dispose();
    super.dispose();
  }

  String _buildCharset() {
    var charset = '';
    if (_useLowercase) charset += _lowercase;
    if (_useUppercase) charset += _uppercase;
    if (_useDigits) charset += _digits;
    if (_useSymbols) charset += _symbols;

    if (_avoidAmbiguous) {
      charset = charset.replaceAll(RegExp(r'[0OoIl1|]'), '');
    }

    return charset.isEmpty ? _lowercase : charset;
  }

  void _generate() {
    final charset = _buildCharset();
    final len = _length.round();
    final buffer = StringBuffer();

    for (var i = 0; i < len; i++) {
      buffer.write(charset[_random.nextInt(charset.length)]);
    }

    setState(() {
      if (_password.isNotEmpty) {
        _history.insert(0, _password);
        if (_history.length > 10) _history.removeLast();
      }
      _password = buffer.toString();
    });
  }

  void _copy() {
    copyWithAutoClear(_password, timeoutSeconds: 30);
    _copyAnimController.forward(from: 0);
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).passwordGeneratorCopied),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  double _estimateEntropy() {
    final charset = _buildCharset();
    if (charset.isEmpty) return 0;
    return _length * (log(charset.length) / log(2));
  }

  Color _strengthColor(double entropy) {
    if (entropy < 40) return AppColors.accentRed;
    if (entropy < 60) return AppColors.accentOrange;
    if (entropy < 80) return AppColors.accentOrange;
    if (entropy < 100) return AppColors.accentGreen;
    return AppColors.accentPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final entropy = _estimateEntropy();
    final strengthNormalized = (entropy / 128).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.passwordGeneratorTitle),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(LucideIcons.history, size: 20),
              tooltip: 'History',
              onPressed: () => _showHistory(context),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Generated password display
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.bgDeepest
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      SelectableText(
                        _password,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: _password.length > 32 ? 14 : 18,
                          letterSpacing: 1.5,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Copy button
                          AnimatedBuilder(
                            animation: _copyAnim,
                            builder: (context, _) {
                              final isCopied = _copyAnim.value > 0 &&
                                  _copyAnim.value < 1;
                              return FilledButton.icon(
                                onPressed: _copy,
                                icon: Icon(
                                  isCopied
                                      ? LucideIcons.check
                                      : LucideIcons.copy,
                                  size: 16,
                                ),
                                label:
                                    Text(isCopied ? l10n.passwordGeneratorCopied : l10n.passwordGeneratorCopy),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          // Regenerate button
                          OutlinedButton.icon(
                            onPressed: _generate,
                            icon: const Icon(LucideIcons.refreshCw, size: 16),
                            label: Text(l10n.passwordGeneratorGenerate),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Strength indicator
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: strengthNormalized,
                          minHeight: 4,
                          backgroundColor: theme.colorScheme.outlineVariant,
                          valueColor: AlwaysStoppedAnimation(
                              _strengthColor(entropy)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.passwordGeneratorStrengthBits('${entropy.round()}'),
                      style: AppTypography.caption.copyWith(
                        color: _strengthColor(entropy),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Length slider
                Row(
                  children: [
                    Text(l10n.passwordGeneratorLengthLabel(_length.round()), style: AppTypography.body),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${_length.round()}',
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _length,
                  min: 8,
                  max: 64,
                  divisions: 56,
                  onChanged: (v) {
                    setState(() => _length = v);
                    _generate();
                  },
                ),
                const SizedBox(height: 8),

                // Character set toggles
                Text('CHARACTER SETS',
                    style: AppTypography.overline.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    )),
                const SizedBox(height: 8),
                _CharsetToggle(
                  label: l10n.passwordGeneratorLowercase,
                  value: _useLowercase,
                  onChanged: (v) {
                    setState(() => _useLowercase = v);
                    _generate();
                  },
                ),
                _CharsetToggle(
                  label: l10n.passwordGeneratorUppercase,
                  value: _useUppercase,
                  onChanged: (v) {
                    setState(() => _useUppercase = v);
                    _generate();
                  },
                ),
                _CharsetToggle(
                  label: l10n.passwordGeneratorNumbers,
                  value: _useDigits,
                  onChanged: (v) {
                    setState(() => _useDigits = v);
                    _generate();
                  },
                ),
                _CharsetToggle(
                  label: l10n.passwordGeneratorSymbols,
                  value: _useSymbols,
                  onChanged: (v) {
                    setState(() => _useSymbols = v);
                    _generate();
                  },
                ),
                const SizedBox(height: 4),
                _CharsetToggle(
                  label: 'Avoid ambiguous (0O, Il1|)',
                  value: _avoidAmbiguous,
                  onChanged: (v) {
                    setState(() => _avoidAmbiguous = v);
                    _generate();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHistory(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Recent Passwords', style: AppTypography.h2),
        content: SizedBox(
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _history.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  _history[index],
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                dense: true,
                trailing: IconButton(
                  icon: const Icon(LucideIcons.copy, size: 16),
                  onPressed: () {
                    copyWithAutoClear(_history[index], timeoutSeconds: 30);
                    if (dialogContext.mounted) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(
                          content:
                              Text(l10n.passwordGeneratorCopied),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}

/// Toggle row for a character set option.
class _CharsetToggle extends StatelessWidget {
  const _CharsetToggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            height: 32,
            width: 32,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: AppTypography.body),
        ],
      ),
    );
  }
}
