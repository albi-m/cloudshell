/// Terminal screen for active SSH sessions.
///
/// Renders a full terminal emulator using xterm.dart, connected
/// to an SSH session via SshSessionWrapper. Handles I/O binding,
/// resize events, session lifecycle, and status bar display.
/// Matches wireframe S4.1.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:xterm/xterm.dart' as xterm;

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/terminal_themes.dart';
import '../../core/theme/xterm_theme_adapter.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/platform_utils.dart';
import '../../providers/connection_provider.dart';
import '../../services/ssh/ssh_session.dart';

/// Full-screen terminal emulator view for an active SSH session.
///
/// Binds an xterm.dart [Terminal] to an [SshSessionWrapper]:
/// - Remote output -> Terminal display
/// - Keyboard input -> SSH stdin
/// - Terminal resize -> SSH PTY resize
/// - Status bar: connection status, session duration, encoding
class TerminalScreen extends ConsumerStatefulWidget {
  const TerminalScreen({
    super.key,
    required this.session,
    this.hostLabel,
    this.themeId = 'cloudshell_default',
  });

  /// The active SSH session to bind to.
  final SshSessionWrapper session;

  /// Display name of the connected host (shown in title bar).
  final String? hostLabel;

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

  /// Tracks session start time for the duration timer.
  DateTime? _connectedAt;

  /// Timer for updating the status bar duration display.
  Timer? _durationTimer;

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

      _connectedAt = DateTime.now();
      // Update duration display every second
      _durationTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          if (mounted) setState(() {});
        },
      );

      // Forward SSH output to xterm terminal.
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

  /// Returns the session duration as a formatted string.
  String get _durationText {
    if (_connectedAt == null) return '0:00';
    final elapsed = DateTime.now().difference(_connectedAt!);
    return Formatters.duration(elapsed);
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _outputSubscription?.cancel();
    _controller.dispose();
    widget.session.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = TerminalThemes.byId(widget.themeId);
    final xtermTheme = toXtermTheme(theme);
    final titleText = widget.hostLabel ?? 'Terminal';

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: AppColors.bgDeep,
        title: Text(
          _isConnected ? titleText : '$titleText (Disconnected)',
          style: AppTypography.h3,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Connection status dot
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
        child: Column(
          children: [
            // Terminal view
            Expanded(
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

            // Status bar (per wireframe S4.1)
            Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                color: AppColors.bgDeep,
                border: Border(
                  top: BorderSide(color: AppColors.borderSubtle),
                ),
              ),
              child: Row(
                children: [
                  // Connection status
                  Icon(
                    _isConnected
                        ? LucideIcons.wifi
                        : LucideIcons.wifiOff,
                    size: 12,
                    color: _isConnected
                        ? AppColors.statusOnline
                        : AppColors.statusOffline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isConnected ? 'Connected' : 'Disconnected',
                    style: AppTypography.caption.copyWith(fontSize: 11),
                  ),
                  const SizedBox(width: 4),
                  if (_isConnected) ...[
                    Text(
                      '\u2022',
                      style: AppTypography.caption.copyWith(fontSize: 11),
                    ),
                    const SizedBox(width: 4),
                    // Session duration
                    Text(
                      _durationText,
                      style: AppTypography.code(fontSize: 11),
                    ),
                  ],

                  const Spacer(),

                  // Encoding
                  Text(
                    AppConstants.defaultEncoding,
                    style: AppTypography.caption.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
