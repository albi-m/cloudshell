/// Extra keyboard row for mobile terminal sessions.
///
/// Provides quick access to keys commonly needed in terminal
/// sessions but awkward to type on mobile keyboards:
/// Esc, Tab, Ctrl, Alt, and arrow keys.
/// Matches wireframe for Mobile Terminal.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

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
  });

  /// Called when a key or key combination should be sent to the terminal.
  final ExtraKeyCallback onKeyInput;

  @override
  State<ExtraKeysBar> createState() => _ExtraKeysBarState();
}

class _ExtraKeysBarState extends State<ExtraKeysBar> {
  bool _ctrlActive = false;
  bool _altActive = false;

  void _sendKey(String sequence) {
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
      setState(() => _ctrlActive = false);
      return;
    }

    if (_altActive) {
      // Alt+key: send ESC prefix followed by the key
      widget.onKeyInput('\x1B$sequence');
      setState(() => _altActive = false);
      return;
    }

    widget.onKeyInput(sequence);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: AppColors.bgDeep,
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle),
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          // ESC
          _ExtraKey(
            label: 'ESC',
            onTap: () => _sendKey('\x1B'),
          ),
          // TAB
          _ExtraKey(
            label: 'TAB',
            onTap: () => _sendKey('\t'),
          ),
          // CTL (toggle)
          _ExtraKey(
            label: 'CTL',
            isActive: _ctrlActive,
            onTap: () => setState(() {
              _ctrlActive = !_ctrlActive;
              if (_ctrlActive) _altActive = false;
            }),
          ),
          // ALT (toggle)
          _ExtraKey(
            label: 'ALT',
            isActive: _altActive,
            onTap: () => setState(() {
              _altActive = !_altActive;
              if (_altActive) _ctrlActive = false;
            }),
          ),

          const SizedBox(width: 4),

          // Arrow keys
          _ExtraKey(
            label: '←',
            onTap: () => _sendKey('\x1B[D'),
          ),
          _ExtraKey(
            label: '↑',
            onTap: () => _sendKey('\x1B[A'),
          ),
          _ExtraKey(
            label: '↓',
            onTap: () => _sendKey('\x1B[B'),
          ),
          _ExtraKey(
            label: '→',
            onTap: () => _sendKey('\x1B[C'),
          ),
        ],
      ),
    );
  }
}

/// A single extra key button.
class _ExtraKey extends StatelessWidget {
  const _ExtraKey({
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Material(
          color: isActive ? AppColors.accentPrimary : AppColors.bgSurface,
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
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
