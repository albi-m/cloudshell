/// Extra keyboard row for mobile terminal sessions.
///
/// Provides quick access to keys commonly needed in terminal
/// sessions but awkward to type on mobile keyboards:
/// Esc, Tab, Ctrl, Alt, and arrow keys.
/// Matches wireframe for Mobile Terminal.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// Callback type for extra key presses.
///
/// Receives the escape sequence string that should be
/// sent to the terminal's input.
typedef ExtraKeyCallback = void Function(String data);

/// Mobile extra keyboard row with terminal modifier and navigation keys.
///
/// Renders a horizontal row of buttons above the system keyboard:
/// [ESC] [TAB] [CTL] [ALT] [←] [↑] [↓] [→]
///
/// Ctrl and Alt are toggle keys that affect the next character typed.
/// Other keys send their escape sequences immediately.
class ExtraKeysBar extends StatefulWidget {
  const ExtraKeysBar({
    super.key,
    required this.onKeyInput,
    required this.chromeBg,
    required this.chromeBorder,
    required this.chromeSurface,
    required this.foreground,
    this.onCtrlChanged,
    this.onAltChanged,
  });

  /// Called when a key or key combination should be sent to the terminal.
  final ExtraKeyCallback onKeyInput;

  /// Called when the Ctrl modifier toggle changes.
  /// Used to apply Ctrl to the next system keyboard keypress.
  final ValueChanged<bool>? onCtrlChanged;

  /// Called when the Alt modifier toggle changes.
  /// Used to apply Alt to the next system keyboard keypress.
  final ValueChanged<bool>? onAltChanged;

  /// Background color derived from the terminal theme.
  final Color chromeBg;

  /// Border color derived from the terminal theme.
  final Color chromeBorder;

  /// Surface color for key buttons derived from the terminal theme.
  final Color chromeSurface;

  /// Foreground (text) color from the terminal theme.
  final Color foreground;

  @override
  State<ExtraKeysBar> createState() => _ExtraKeysBarState();
}

class _ExtraKeysBarState extends State<ExtraKeysBar> {
  bool _ctrlActive = false;
  bool _altActive = false;

  void _sendKey(String sequence) {
    HapticFeedback.selectionClick();
    if (_ctrlActive) {
      // Ctrl+key: for ASCII letters, send the control character
      // Control characters are char code 1-26 for a-z
      if (sequence.length == 1) {
        final code = sequence.codeUnitAt(0);
        if (code >= 97 && code <= 122) {
          // lowercase a-z → Ctrl+A-Z (1-26)
          widget.onKeyInput(String.fromCharCode(code - 96));
        } else if (code >= 65 && code <= 90) {
          // uppercase A-Z → Ctrl+A-Z (1-26)
          widget.onKeyInput(String.fromCharCode(code - 64));
        } else {
          widget.onKeyInput(sequence);
        }
      } else {
        widget.onKeyInput(sequence);
      }
      setState(() {
        _ctrlActive = false;
        widget.onCtrlChanged?.call(false);
      });
      return;
    }

    if (_altActive) {
      // Alt+key: send ESC prefix followed by the key
      widget.onKeyInput('\x1B$sequence');
      setState(() {
        _altActive = false;
        widget.onAltChanged?.call(false);
      });
      return;
    }

    widget.onKeyInput(sequence);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: widget.chromeBg,
        border: Border(
          top: BorderSide(color: widget.chromeBorder),
          bottom: BorderSide(color: widget.chromeBorder),
        ),
      ),
      child: Row(
        children: [
          // ESC
          _ExtraKey(
            label: l10n.extraKeyEsc,
            onTap: () => _sendKey('\x1B'),
            surfaceColor: widget.chromeSurface,
            foreground: widget.foreground,
          ),
          // TAB
          _ExtraKey(
            label: l10n.extraKeyTab,
            onTap: () => _sendKey('\t'),
            surfaceColor: widget.chromeSurface,
            foreground: widget.foreground,
          ),
          // CTL (toggle)
          _ExtraKey(
            label: l10n.extraKeyCtl,
            isActive: _ctrlActive,
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                _ctrlActive = !_ctrlActive;
                if (_ctrlActive) _altActive = false;
              });
              widget.onCtrlChanged?.call(_ctrlActive);
              if (_ctrlActive) widget.onAltChanged?.call(false);
            },
            surfaceColor: widget.chromeSurface,
            foreground: widget.foreground,
          ),
          // ALT (toggle)
          _ExtraKey(
            label: l10n.extraKeyAlt,
            isActive: _altActive,
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                _altActive = !_altActive;
                if (_altActive) _ctrlActive = false;
              });
              widget.onAltChanged?.call(_altActive);
              if (_altActive) widget.onCtrlChanged?.call(false);
            },
            surfaceColor: widget.chromeSurface,
            foreground: widget.foreground,
          ),

          const SizedBox(width: 4),

          // Arrow keys
          _ExtraKey(
            label: '\u2190',
            onTap: () => _sendKey('\x1B[D'),
            surfaceColor: widget.chromeSurface,
            foreground: widget.foreground,
          ),
          _ExtraKey(
            label: '\u2191',
            onTap: () => _sendKey('\x1B[A'),
            surfaceColor: widget.chromeSurface,
            foreground: widget.foreground,
          ),
          _ExtraKey(
            label: '\u2193',
            onTap: () => _sendKey('\x1B[B'),
            surfaceColor: widget.chromeSurface,
            foreground: widget.foreground,
          ),
          _ExtraKey(
            label: '\u2192',
            onTap: () => _sendKey('\x1B[C'),
            surfaceColor: widget.chromeSurface,
            foreground: widget.foreground,
          ),

          const SizedBox(width: 4),

          // Backspace
          _ExtraKey(
            label: l10n.extraKeyBksp,
            onTap: () => _sendKey('\x7F'),
            surfaceColor: widget.chromeSurface,
            foreground: widget.foreground,
          ),

          // Keyboard dismiss
          _ExtraIconKey(
            icon: LucideIcons.chevronDown,
            onTap: () {
              HapticFeedback.selectionClick();
              FocusScope.of(context).unfocus();
            },
            surfaceColor: widget.chromeSurface,
            foreground: widget.foreground,
          ),
        ],
      ),
    );
  }
}

/// A single extra key button with a text label.
class _ExtraKey extends StatelessWidget {
  const _ExtraKey({
    required this.label,
    required this.onTap,
    required this.surfaceColor,
    required this.foreground,
    this.isActive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final Color surfaceColor;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Material(
          color: isActive ? AppColors.accentPrimary : surfaceColor,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? AppColors.textInverse
                      : foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single extra key button with an icon instead of text.
class _ExtraIconKey extends StatelessWidget {
  const _ExtraIconKey({
    required this.icon,
    required this.onTap,
    required this.surfaceColor,
    required this.foreground,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color surfaceColor;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Material(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Icon(icon, size: 16, color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}
