/// Terminal screen for active SSH sessions.
///
/// Renders a full terminal emulator using xterm.dart, connected
/// to an SSH session via SshSessionWrapper. Handles I/O binding,
/// resize events, and session lifecycle.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xterm/xterm.dart' as xterm;

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/terminal_themes.dart';
import '../../core/theme/xterm_theme_adapter.dart';
import '../../core/utils/platform_utils.dart';
import '../../providers/connection_provider.dart';
import '../../services/ssh/ssh_session.dart';

/// Full-screen terminal emulator view for an active SSH session.
///
/// Binds an xterm.dart [Terminal] to an [SshSessionWrapper]:
/// - Remote output → Terminal display
/// - Keyboard input → SSH stdin
/// - Terminal resize → SSH PTY resize
class TerminalScreen extends ConsumerStatefulWidget {
  const TerminalScreen({
    super.key,
    required this.session,
    this.themeId = 'cloudshell_default',
  });

  /// The active SSH session to bind to.
  final SshSessionWrapper session;

  /// Terminal color theme ID.
  final String themeId;

  @override
  ConsumerState<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends ConsumerState<TerminalScreen> {
  late final xterm.Terminal _terminal;
  late final xterm.TerminalController _controller;
  bool _isConnected = true;

  /// Stored subscription to cancel on dispose (prevents memory leak).
  StreamSubscription<dynamic>? _outputSubscription;

  @override
  void initState() {
    super.initState();

    _terminal = xterm.Terminal(
      maxLines: AppConstants.defaultScrollbackLines,
      onOutput: _onTerminalOutput,
      onResize: _onTerminalResize,
    );

    _controller = xterm.TerminalController();

    _initSession();
  }

  Future<void> _initSession() async {
    try {
      await widget.session.startShell(
        termWidth: 80,
        termHeight: 24,
      );

      // Forward SSH output to xterm terminal.
      // Store subscription so we can cancel it in dispose().
      _outputSubscription = widget.session.output.listen(
        (data) {
          _terminal.write(utf8.decode(data, allowMalformed: true));
        },
        onDone: () {
          if (mounted) {
            setState(() => _isConnected = false);
            _terminal.write('\r\n[Connection closed]\r\n');
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() => _isConnected = false);
            _terminal.write('\r\n[Connection error]\r\n');
          }
        },
      );

      // Listen for connection close
      widget.session.done.then((_) {
        if (mounted) {
          setState(() => _isConnected = false);
          ref.read(activeConnectionsProvider.notifier).updateStatus(
            widget.session.sessionId,
            ConnectionStatus.disconnected,
          );
        }
      });
    } catch (e) {
      _terminal.write('\r\n[Failed to start shell]\r\n');
      setState(() => _isConnected = false);
    }
  }

  /// Called when the user types in the terminal.
  void _onTerminalOutput(String data) {
    if (_isConnected) {
      widget.session.writeString(data);
    }
  }

  /// Called when the terminal view resizes.
  void _onTerminalResize(int width, int height, int pixelWidth, int pixelHeight) {
    if (_isConnected) {
      widget.session.resize(width, height);
    }
  }

  @override
  void dispose() {
    _outputSubscription?.cancel();
    _controller.dispose();
    widget.session.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = TerminalThemes.byId(widget.themeId);
    final xtermTheme = toXtermTheme(theme);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: AppColors.bgDeep,
        title: Text(
          _isConnected ? 'Terminal' : 'Disconnected',
          style: AppTypography.h3,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isConnected
                      ? AppColors.statusOnline
                      : AppColors.statusOffline,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: xterm.TerminalView(
          _terminal,
          controller: _controller,
          theme: xtermTheme,
          textStyle: xterm.TerminalStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: PlatformUtils.isDesktop
                ? AppConstants.defaultTerminalFontSizeDesktop
                : AppConstants.defaultTerminalFontSizeMobile,
          ),
          autofocus: true,
          keyboardAppearance: Brightness.dark,
        ),
      ),
    );
  }
}
