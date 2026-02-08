/// Terminal screen for active SSH sessions.
///
/// Renders a full terminal emulator using xterm.dart, connected
/// to SSH sessions via SshSessionWrapper. Supports multi-tab sessions
/// with a tab bar, copy/paste, mobile extra keyboard row, and
/// a status bar. Matches wireframe S4.1.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../providers/terminal_tab_provider.dart';
import '../../services/ssh/ssh_session.dart';
import 'widgets/extra_keys_bar.dart';
import 'widgets/terminal_tab_bar.dart';

/// Multi-tab terminal screen managing multiple SSH sessions.
///
/// Opens with at least one tab. New tabs can be added via the "+" button
/// in the tab bar, which navigates back to the host list for connection.
/// Each tab maintains its own xterm.Terminal instance and SSH session.
class TerminalScreen extends ConsumerStatefulWidget {
  const TerminalScreen({
    super.key,
    required this.session,
    this.hostLabel,
    this.themeId = 'cloudshell_default',
  });

  /// The initial SSH session to open.
  final SshSessionWrapper session;

  /// Display name of the connected host.
  final String? hostLabel;

  /// Terminal color theme ID.
  final String themeId;

  @override
  ConsumerState<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends ConsumerState<TerminalScreen> {
  @override
  void initState() {
    super.initState();
    // Add the initial session as the first tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tabs = ref.read(terminalTabsProvider);
      // Only add if not already present (prevents duplicates on rebuild)
      if (!tabs.tabs.any((t) => t.id == widget.session.sessionId)) {
        ref.read(terminalTabsProvider.notifier).addTab(
              widget.session,
              widget.hostLabel ?? 'Terminal',
            );
      }
    });
  }

  void _handleNewTab() {
    // Navigate back to host list so user can pick a new connection
    Navigator.of(context).pop();
  }

  Future<void> _handleCloseTab(String tabId) async {
    final tabsNotifier = ref.read(terminalTabsProvider.notifier);
    await tabsNotifier.closeTab(tabId);

    // Update connection state
    ref.read(activeConnectionsProvider.notifier).updateStatus(
          tabId,
          ConnectionStatus.disconnected,
        );
    ref.read(activeConnectionsProvider.notifier).removeConnection(tabId);

    // If no tabs left, exit terminal screen
    final remaining = ref.read(terminalTabsProvider);
    if (remaining.tabs.isEmpty && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabsState = ref.watch(terminalTabsProvider);
    final activeTab = tabsState.activeTab;
    final hasMultipleTabs = tabsState.tabs.length > 1;

    if (activeTab == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgDeepest,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: _buildAppBar(activeTab, hasMultipleTabs),
      body: SafeArea(
        child: Column(
          children: [
            // Tab bar (only shown when multiple tabs)
            if (hasMultipleTabs)
              TerminalTabBar(
                tabs: tabsState.tabs,
                activeTabId: tabsState.activeTabId,
                onTabSelected: (id) =>
                    ref.read(terminalTabsProvider.notifier).switchToTab(id),
                onTabClosed: _handleCloseTab,
                onNewTab: _handleNewTab,
              ),

            // Terminal content — IndexedStack preserves state across tabs
            Expanded(
              child: IndexedStack(
                index: tabsState.activeIndex.clamp(0, tabsState.tabs.length - 1),
                children: tabsState.tabs.map((tab) {
                  return _SingleTerminalView(
                    key: ValueKey(tab.id),
                    session: tab.session,
                    themeId: widget.themeId,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(TerminalTab activeTab, bool hasMultipleTabs) {
    return AppBar(
      backgroundColor: AppColors.bgDeep,
      title: Text(
        activeTab.hostLabel,
        style: AppTypography.h3,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        // New tab button (always visible)
        if (!hasMultipleTabs)
          IconButton(
            icon: const Icon(LucideIcons.plus, size: 18),
            tooltip: 'New tab',
            onPressed: _handleNewTab,
          ),
        // Copy button
        IconButton(
          icon: const Icon(LucideIcons.copy, size: 18),
          tooltip: 'Copy selection',
          onPressed: _copySelection,
        ),
        // Paste button
        IconButton(
          icon: const Icon(LucideIcons.clipboardPaste, size: 18),
          tooltip: 'Paste',
          onPressed: _pasteClipboard,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  void _copySelection() {
    // Trigger the copy action via Flutter's Actions system
    // The xterm TerminalActions handles this automatically for Cmd+C
    // For the toolbar button, we invoke it explicitly
    final context = this.context;
    Actions.maybeInvoke<CopySelectionTextIntent>(
      context,
      CopySelectionTextIntent.copy,
    );
  }

  Future<void> _pasteClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null) return;

    final tabsState = ref.read(terminalTabsProvider);
    final activeTab = tabsState.activeTab;
    if (activeTab != null && activeTab.session.isConnected) {
      activeTab.session.writeString(data!.text!);
    }
  }
}

/// The actual terminal view for a single SSH session tab.
///
/// Manages the xterm.Terminal instance, I/O binding, status bar,
/// and mobile extra keys for one session.
class _SingleTerminalView extends ConsumerStatefulWidget {
  const _SingleTerminalView({
    super.key,
    required this.session,
    this.themeId = 'cloudshell_default',
  });

  final SshSessionWrapper session;
  final String themeId;

  @override
  ConsumerState<_SingleTerminalView> createState() =>
      _SingleTerminalViewState();
}

class _SingleTerminalViewState extends ConsumerState<_SingleTerminalView> {
  late final xterm.Terminal _terminal;
  late final xterm.TerminalController _controller;
  bool _isConnected = true;

  StreamSubscription<dynamic>? _outputSubscription;
  DateTime? _connectedAt;
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
      _durationTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          if (mounted) setState(() {});
        },
      );

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

  void _onTerminalOutput(String data) {
    if (_isConnected) {
      widget.session.writeString(data);
    }
  }

  void _onTerminalResize(
      int width, int height, int pixelWidth, int pixelHeight) {
    if (_isConnected) {
      widget.session.resize(width, height);
    }
  }

  /// Handles key input from the mobile extra keys bar.
  void _onExtraKeyInput(String data) {
    if (_isConnected) {
      widget.session.writeString(data);
    }
  }

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
    // Don't close session here — the tab provider manages session lifecycle
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = TerminalThemes.byId(widget.themeId);
    final xtermTheme = toXtermTheme(theme);
    final isMobile = PlatformUtils.isMobile;

    return Column(
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

        // Mobile extra keys bar
        if (isMobile) ExtraKeysBar(onKeyInput: _onExtraKeyInput),

        // Status bar
        _StatusBar(
          isConnected: _isConnected,
          durationText: _durationText,
        ),
      ],
    );
  }
}

/// Terminal status bar showing connection status, duration, and encoding.
class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.isConnected,
    required this.durationText,
  });

  final bool isConnected;
  final String durationText;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            isConnected ? LucideIcons.wifi : LucideIcons.wifiOff,
            size: 12,
            color: isConnected
                ? AppColors.statusOnline
                : AppColors.statusOffline,
          ),
          const SizedBox(width: 4),
          Text(
            isConnected ? 'Connected' : 'Disconnected',
            style: AppTypography.caption.copyWith(fontSize: 11),
          ),
          if (isConnected) ...[
            const SizedBox(width: 4),
            Text(
              '\u2022',
              style: AppTypography.caption.copyWith(fontSize: 11),
            ),
            const SizedBox(width: 4),
            Text(
              durationText,
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
    );
  }
}
