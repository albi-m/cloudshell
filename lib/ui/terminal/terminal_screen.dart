/// Terminal screen for active SSH sessions.
///
/// Renders terminal emulators using xterm.dart, connected
/// to SSH sessions managed by terminalTabsProvider. Supports
/// multi-tab sessions with copy/paste, mobile extra keyboard row,
/// and status bar. Terminal state (xterm.Terminal, scrollback,
/// connection) lives in the provider and survives navigation.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xterm/xterm.dart' as xterm;

import '../../core/constants/app_constants.dart';
import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/terminal_themes.dart';
import '../../core/theme/xterm_theme_adapter.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/platform_utils.dart';
import '../../data/database/app_database.dart';
import '../../providers/connection_provider.dart';
import '../../providers/host_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/terminal_tab_provider.dart';
import '../../providers/workspace_provider.dart';
import '../../services/ssh/ssh_service.dart';
import '../../l10n/app_localizations.dart';
import '../hosts/quick_connect_dialog.dart';
import 'widgets/broadcast_panel.dart';
import 'widgets/extra_keys_bar.dart';

/// Multi-tab terminal screen that reads from terminalTabsProvider.
///
/// This widget is parameterless — all state lives in the provider.
/// The workspace tab bar (in AdaptiveScaffold) handles tab switching;
/// this screen just renders the active terminal.
class TerminalScreen extends ConsumerStatefulWidget {
  const TerminalScreen({super.key});

  @override
  ConsumerState<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends ConsumerState<TerminalScreen> {
  bool _showSearch = false;
  double _pinchBaseSize = 0;

  @override
  Widget build(BuildContext context) {
    final tabsState = ref.watch(terminalTabsProvider);

    if (tabsState.tabs.isEmpty) {
      return const _EmptyTerminal();
    }

    final activeTab = tabsState.activeTab;
    if (activeTab == null) {
      return const _EmptyTerminal();
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.equal, meta: true): () =>
            _adjustZoom(1.0),
        const SingleActivator(LogicalKeyboardKey.equal, control: true): () =>
            _adjustZoom(1.0),
        const SingleActivator(LogicalKeyboardKey.minus, meta: true): () =>
            _adjustZoom(-1.0),
        const SingleActivator(LogicalKeyboardKey.minus, control: true): () =>
            _adjustZoom(-1.0),
        const SingleActivator(LogicalKeyboardKey.digit0, meta: true):
            _resetZoom,
        const SingleActivator(LogicalKeyboardKey.digit0, control: true):
            _resetZoom,
        // Split pane shortcuts
        const SingleActivator(LogicalKeyboardKey.keyD, meta: true):
            _splitHorizontal,
        const SingleActivator(LogicalKeyboardKey.keyD, meta: true,
            shift: true): _splitVertical,
        const SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true):
            _switchPane,
        const SingleActivator(LogicalKeyboardKey.arrowRight, alt: true):
            _switchPane,
        // Search (Cmd+F or Cmd+Shift+F)
        const SingleActivator(LogicalKeyboardKey.keyF, meta: true):
            _toggleSearch,
        const SingleActivator(LogicalKeyboardKey.keyF, control: true):
            _toggleSearch,
        const SingleActivator(LogicalKeyboardKey.keyF, meta: true,
            shift: true): _toggleSearch,
        const SingleActivator(LogicalKeyboardKey.keyF, control: true,
            shift: true): _toggleSearch,
      },
      child: Focus(
        autofocus: true,
        child: _wrapWithMobileGestures(
          tabsState,
          Stack(
            children: [
              IndexedStack(
                index: tabsState.activeIndex
                    .clamp(0, tabsState.tabs.length - 1),
                children: tabsState.tabs.map((tab) {
                  return _SingleTerminalView(
                    key: ValueKey(tab.id),
                    tab: tab,
                  );
                }).toList(),
              ),
              if (_showSearch)
                Positioned(
                  top: 0,
                  right: 0,
                  child: _TerminalSearchBar(
                    terminal: activeTab.terminal,
                    onClose: () => setState(() => _showSearch = false),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _adjustZoom(double delta) {
    ref.read(terminalZoomOffsetProvider.notifier).state += delta;
  }

  void _resetZoom() {
    ref.read(terminalZoomOffsetProvider.notifier).state = 0.0;
  }

  void _splitHorizontal() {
    final activeTab = ref.read(terminalTabsProvider).activeTab;
    if (activeTab != null && activeTab.isConnected && !activeTab.isSplit) {
      ref
          .read(terminalTabsProvider.notifier)
          .splitPane(activeTab.id, SplitDirection.horizontal);
    }
  }

  void _splitVertical() {
    final activeTab = ref.read(terminalTabsProvider).activeTab;
    if (activeTab != null && activeTab.isConnected && !activeTab.isSplit) {
      ref
          .read(terminalTabsProvider.notifier)
          .splitPane(activeTab.id, SplitDirection.vertical);
    }
  }

  void _switchPane() {
    final activeTab = ref.read(terminalTabsProvider).activeTab;
    if (activeTab != null && activeTab.isSplit) {
      ref.read(terminalTabsProvider.notifier).switchActivePane(activeTab.id);
    }
  }

  void _toggleSearch() {
    setState(() => _showSearch = !_showSearch);
  }

  /// Wraps the terminal content with mobile-specific gesture detectors
  /// for swipe tab switching and pinch-to-zoom.
  Widget _wrapWithMobileGestures(TerminalTabsState tabsState, Widget child) {
    if (!PlatformUtils.isMobile) return child;

    return GestureDetector(
      // Swipe left/right to switch tabs
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity;
        if (velocity == null) return;
        final tabs = tabsState.tabs;
        final currentIndex = tabsState.activeIndex;

        if (velocity < -300 && currentIndex < tabs.length - 1) {
          // Swipe left → next tab
          HapticFeedback.lightImpact();
          ref
              .read(terminalTabsProvider.notifier)
              .switchToTab(tabs[currentIndex + 1].id);
        } else if (velocity > 300 && currentIndex > 0) {
          // Swipe right → previous tab
          HapticFeedback.lightImpact();
          ref
              .read(terminalTabsProvider.notifier)
              .switchToTab(tabs[currentIndex - 1].id);
        }
      },
      // Pinch-to-zoom font size
      onScaleStart: (_) {
        _pinchBaseSize = ref.read(terminalFontSizeProvider) +
            ref.read(terminalZoomOffsetProvider);
      },
      onScaleUpdate: (details) {
        if (details.pointerCount < 2) return;
        final newSize = (_pinchBaseSize * details.scale).clamp(8.0, 32.0);
        final base = ref.read(terminalFontSizeProvider);
        ref.read(terminalZoomOffsetProvider.notifier).state = newSize - base;
      },
      child: child,
    );
  }

}

/// Launchpad shown when no terminal sessions are active.
///
/// Shows quick connect, recent hosts, and keyboard shortcut hints
/// instead of a dead-end empty state.
class _EmptyTerminal extends ConsumerWidget {
  const _EmptyTerminal();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hostsAsync = ref.watch(allHostsProvider);

    // Get recent hosts sorted by last connected
    final recentHosts = hostsAsync.whenOrNull(
          data: (hosts) {
            final connected =
                hosts.where((h) => h.lastConnectedAt != null).toList()
                  ..sort((a, b) =>
                      b.lastConnectedAt!.compareTo(a.lastConnectedAt!));
            return connected.take(5).toList();
          },
        ) ??
        <Host>[];

    return Container(
      color: AppColors.bgDeepest,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.terminal,
                size: 48,
                color: AppColors.textTertiary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.terminalNoActiveSessions,
                style:
                    AppTypography.h3.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),

              // Quick Connect button
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.gradientBrandFor(context),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => showQuickConnectDialog(context),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.zap,
                              size: 16, color: AppColors.textInverse),
                          const SizedBox(width: 8),
                          Text(
                            l10n.terminalQuickConnect,
                            style: AppTypography.button.copyWith(
                              color: AppColors.textInverse,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Recent hosts
              if (recentHosts.isNotEmpty) ...[
                Text(
                  l10n.terminalRecentHostsHeader,
                  style: AppTypography.overline.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Column(
                    children: recentHosts
                        .map(
                          (host) => _RecentHostTile(
                            host: host,
                            onConnect: () =>
                                _connectHost(context, ref, host),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Shortcut hints
              Text(
                PlatformUtils.isDesktop
                    ? l10n.terminalDesktopShortcutHints
                    : l10n.terminalMobileShortcutHint,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _connectHost(
      BuildContext context, WidgetRef ref, Host host) async {
    final l10n = AppLocalizations.of(context);
    final sshService = ref.read(sshServiceProvider);
    final connections = ref.read(activeConnectionsProvider.notifier);

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.terminalConnectingToHost(host.label)),
          duration: const Duration(seconds: 2),
        ),
      );

      final session = await sshService.connect(host: host);

      connections.addConnection(session.sessionId, host.id);
      connections.updateStatus(session.sessionId, ConnectionStatus.connected);

      final db = ref.read(databaseProvider);
      await db.hostDao.updateLastConnected(host.id);

      await ref.read(terminalTabsProvider.notifier).addTab(
            session,
            host.label,
            startupCommand: host.startupCommand,
          );
      if (context.mounted) {
        ref.read(workspaceProvider.notifier).openTerminalTab(
              session.sessionId,
              host.label,
            );
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.userMessage(e)),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }
}

/// A clickable recent host row in the terminal launchpad.
class _RecentHostTile extends StatelessWidget {
  const _RecentHostTile({
    required this.host,
    required this.onConnect,
  });

  final Host host;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onConnect,
          borderRadius: BorderRadius.circular(8),
          hoverColor: AppColors.bgHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Icon(LucideIcons.server,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        host.label,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${host.username}@${host.hostname}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.play,
                    size: 14, color: AppColors.accentPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The actual terminal view for a single SSH session tab.
///
/// Handles both single-pane and split-pane rendering modes.
/// In split mode, two _TerminalPaneView widgets are shown side-by-side
/// (horizontal) or stacked (vertical) with a drag handle between them.
class _SingleTerminalView extends ConsumerWidget {
  const _SingleTerminalView({
    super.key,
    required this.tab,
  });

  final TerminalTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeId = ref.watch(terminalThemeIdProvider);
    final fontSize = ref.watch(terminalFontSizeProvider);
    final zoomOffset = ref.watch(terminalZoomOffsetProvider);
    final fontFamily = ref.watch(terminalFontFamilyProvider);
    final cursorStyle = ref.watch(terminalCursorStyleProvider);
    final allThemes = ref.watch(allTerminalThemesProvider);
    final theme = allThemes[themeId] ?? TerminalThemes.byId(themeId);
    final xtermTheme = toXtermTheme(theme);
    final isMobile = PlatformUtils.isMobile;
    final effectiveFontSize = (fontSize + zoomOffset).clamp(8.0, 32.0);
    final cursorType = switch (cursorStyle) {
      'underline' => xterm.TerminalCursorType.underline,
      'bar' => xterm.TerminalCursorType.verticalBar,
      _ => xterm.TerminalCursorType.block,
    };

    return Column(
      children: [
        // Tab-level reconnecting banner
        if (tab.isReconnecting)
          _ReconnectBanner(
            attempt: tab.reconnectAttempt,
            maxAttempts: AppConstants.maxReconnectAttempts,
            onCancel: () => ref
                .read(terminalTabsProvider.notifier)
                .cancelReconnect(tab.id),
            chromeBg: terminalChromeBg(theme.background),
          ),

        // Tab-level retry banner when disconnected and not reconnecting
        if (!tab.isConnected &&
            !tab.isReconnecting &&
            tab.session.hostId.isNotEmpty)
          _RetryBanner(
            onRetry: () => ref
                .read(terminalTabsProvider.notifier)
                .retryReconnect(tab.id),
            chromeBg: terminalChromeBg(theme.background),
          ),

        // Main content area
        Expanded(
          child: tab.isSplit
              ? _SplitPaneLayout(
                  tab: tab,
                  xtermTheme: xtermTheme,
                  fontSize: effectiveFontSize,
                  fontFamily: fontFamily,
                  cursorType: cursorType,
                  themeBg: theme.background,
                  onSwitchPane: (paneId) {
                    if (tab.activePaneId != paneId) {
                      ref
                          .read(terminalTabsProvider.notifier)
                          .switchActivePane(tab.id);
                    }
                  },
                  onCloseSplit: () {
                    ref
                        .read(terminalTabsProvider.notifier)
                        .closeSplitPane(tab.id);
                  },
                )
              : _TerminalPaneView(
                  terminal: tab.terminal,
                  controller: tab.controller,
                  isActive: true,
                  xtermTheme: xtermTheme,
                  fontSize: effectiveFontSize,
                  fontFamily: fontFamily,
                  cursorType: cursorType,
                ),
        ),

        // Mobile extra keys bar
        if (isMobile)
          ExtraKeysBar(
            onKeyInput: (data) {
              if (tab.isSplit && tab.activePane != null) {
                final pane = tab.activePane!;
                if (pane.shell != null) {
                  pane.writeInput(data);
                } else {
                  tab.session.writeString(data);
                }
              } else if (tab.isConnected) {
                tab.session.writeString(data);
              }
            },
            chromeBg: terminalChromeBg(theme.background),
            chromeBorder: terminalChromeBorder(theme.background),
            chromeSurface: terminalChromeSurface(theme.background),
            foreground: theme.foreground,
          ),

        // Status bar
        _StatusBar(
          isConnected: tab.isConnected,
          isReconnecting: tab.isReconnecting,
          connectedAt: tab.connectedAt,
          isLogging: tab.isLogging,
          onToggleLogging: () {
            final notifier = ref.read(terminalTabsProvider.notifier);
            if (tab.isLogging) {
              notifier.stopLogging(tab.id);
            } else {
              notifier.startLogging(tab.id);
            }
          },
          isBroadcasting:
              ref.read(terminalTabsProvider.notifier).broadcastEnabled,
          broadcastGroupSize:
              ref.read(terminalTabsProvider.notifier).broadcastGroup.length,
          onToggleBroadcast: () {
            ref.read(terminalTabsProvider.notifier).toggleBroadcast();
          },
          onLongPressBroadcast: () => showBroadcastPanel(context),
          onShowConnectionInfo: () {
            _showConnectionHealthSheet(context, ref, tab);
          },
          chromeBg: terminalChromeBg(theme.background),
          chromeBorder: terminalChromeBorder(theme.background),
          foreground: theme.foreground,
        ),
      ],
    );
  }
}

/// Layout for split pane terminals.
///
/// Renders two _TerminalPaneView widgets with a drag handle between them.
/// Manages split ratio drag state locally for smooth interaction.
class _SplitPaneLayout extends StatefulWidget {
  const _SplitPaneLayout({
    required this.tab,
    required this.xtermTheme,
    required this.fontSize,
    required this.fontFamily,
    required this.cursorType,
    required this.onSwitchPane,
    required this.onCloseSplit,
    required this.themeBg,
  });

  final TerminalTab tab;
  final xterm.TerminalTheme xtermTheme;
  final double fontSize;
  final String fontFamily;
  final xterm.TerminalCursorType cursorType;
  final ValueChanged<String> onSwitchPane;
  final VoidCallback onCloseSplit;
  final Color themeBg;

  @override
  State<_SplitPaneLayout> createState() => _SplitPaneLayoutState();
}

class _SplitPaneLayoutState extends State<_SplitPaneLayout> {
  late double _splitRatio;

  @override
  void initState() {
    super.initState();
    _splitRatio = widget.tab.splitRatio;
  }

  @override
  void didUpdateWidget(_SplitPaneLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tab.id != widget.tab.id) {
      _splitRatio = widget.tab.splitRatio;
    }
  }

  void _onDrag(double delta, double totalSize) {
    setState(() {
      _splitRatio = (_splitRatio + delta / totalSize).clamp(0.25, 0.75);
      widget.tab.splitRatio = _splitRatio;
    });
  }

  @override
  Widget build(BuildContext context) {
    final panes = widget.tab.panes;
    if (panes.length < 2) return const SizedBox.shrink();

    final isHorizontal =
        widget.tab.splitDirection == SplitDirection.horizontal;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSize =
            isHorizontal ? constraints.maxWidth : constraints.maxHeight;

        final children = <Widget>[
          // Pane 0
          SizedBox(
            width: isHorizontal ? totalSize * _splitRatio : null,
            height: isHorizontal ? null : totalSize * _splitRatio,
            child: RepaintBoundary(
              child: _TerminalPaneView(
                terminal: panes[0].terminal,
                controller: panes[0].controller,
                isActive: panes[0].id == widget.tab.activePaneId,
                xtermTheme: widget.xtermTheme,
                fontSize: widget.fontSize,
                fontFamily: widget.fontFamily,
                cursorType: widget.cursorType,
                onTap: () => widget.onSwitchPane(panes[0].id),
              ),
            ),
          ),

          // Drag handle
          _SplitDragHandle(
            isHorizontal: isHorizontal,
            onDrag: (delta) => _onDrag(delta, totalSize),
            onCloseSplit: widget.onCloseSplit,
            chromeBorder: terminalChromeBorder(widget.themeBg),
            chromeSurface: terminalChromeSurface(widget.themeBg),
          ),

          // Pane 1
          Expanded(
            child: RepaintBoundary(
              child: _TerminalPaneView(
                terminal: panes[1].terminal,
                controller: panes[1].controller,
                isActive: panes[1].id == widget.tab.activePaneId,
                xtermTheme: widget.xtermTheme,
                fontSize: widget.fontSize,
                fontFamily: widget.fontFamily,
                cursorType: widget.cursorType,
                onTap: () => widget.onSwitchPane(panes[1].id),
              ),
            ),
          ),
        ];

        return isHorizontal
            ? Row(children: children)
            : Column(children: children);
      },
    );
  }
}

/// Renders a single terminal pane with xterm.TerminalView and visual effects.
///
/// Used both in single-pane and split-pane modes. The active pane
/// gets a subtle accent border to indicate focus. Supports clickable URLs
/// and visual bell flash on BEL character.
class _TerminalPaneView extends StatefulWidget {
  const _TerminalPaneView({
    required this.terminal,
    required this.controller,
    required this.isActive,
    required this.xtermTheme,
    required this.fontSize,
    required this.fontFamily,
    required this.cursorType,
    this.onTap,
  });

  static final _activeBorderColor = AppColors.accentPrimary.withValues(alpha: 0.3);

  final xterm.Terminal terminal;
  final xterm.TerminalController controller;
  final bool isActive;
  final xterm.TerminalTheme xtermTheme;
  final double fontSize;
  final String fontFamily;
  final xterm.TerminalCursorType cursorType;
  final VoidCallback? onTap;

  @override
  State<_TerminalPaneView> createState() => _TerminalPaneViewState();
}

class _TerminalPaneViewState extends State<_TerminalPaneView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bellController;
  late final Animation<double> _bellOpacity;

  static final _urlPattern = RegExp(
    r'https?://[^\s<>\[\]{}()|\\^`"' "'" r']+',
  );

  @override
  void initState() {
    super.initState();
    _bellController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _bellOpacity = Tween<double>(begin: 0.15, end: 0.0).animate(
      CurvedAnimation(parent: _bellController, curve: Curves.easeOut),
    );
    widget.terminal.onBell = _onBell;
  }

  @override
  void didUpdateWidget(_TerminalPaneView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.terminal != widget.terminal) {
      oldWidget.terminal.onBell = null;
      widget.terminal.onBell = _onBell;
    }
  }

  @override
  void dispose() {
    widget.terminal.onBell = null;
    _bellController.dispose();
    super.dispose();
  }

  void _onBell() {
    _bellController.forward(from: 0);
  }

  /// Extract the URL at the tapped cell position, if any.
  String? _getUrlAtCell(xterm.CellOffset cell) {
    final lines = widget.terminal.buffer.lines;
    if (cell.y < 0 || cell.y >= lines.length) return null;

    final line = lines[cell.y];
    final text = line.toString();
    for (final match in _urlPattern.allMatches(text)) {
      if (cell.x >= match.start && cell.x < match.end) {
        return match.group(0);
      }
    }
    return null;
  }

  void _handleTapUp(TapUpDetails details, xterm.CellOffset cell) {
    widget.onTap?.call();

    final url = _getUrlAtCell(cell);
    if (url != null) {
      final uri = Uri.tryParse(url);
      if (uri != null) {
        launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: widget.isActive && widget.onTap != null
            ? BoxDecoration(
                border: Border.all(
                  color: _TerminalPaneView._activeBorderColor,
                  width: 1.5,
                ),
              )
            : null,
        child: Stack(
          children: [
            xterm.TerminalView(
              widget.terminal,
              controller: widget.controller,
              theme: widget.xtermTheme,
              cursorType: widget.cursorType,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              textStyle: xterm.TerminalStyle(
                fontFamily: widget.fontFamily,
                fontSize: widget.fontSize,
              ),
              autofocus: widget.isActive,
              keyboardAppearance: Brightness.dark,
              onTapUp: _handleTapUp,
            ),
            // Visual bell flash overlay
            AnimatedBuilder(
              animation: _bellOpacity,
              builder: (context, _) => _bellOpacity.value > 0
                  ? Positioned.fill(
                      child: IgnorePointer(
                        child: ColoredBox(
                          color: AppColors.textPrimary
                              .withValues(alpha: _bellOpacity.value),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating search bar for searching terminal buffer output.
///
/// Shows match count and next/previous navigation buttons.
/// Searches across all lines in the terminal's scrollback buffer.
class _TerminalSearchBar extends StatefulWidget {
  const _TerminalSearchBar({
    required this.terminal,
    required this.onClose,
  });

  final xterm.Terminal terminal;
  final VoidCallback onClose;

  @override
  State<_TerminalSearchBar> createState() => _TerminalSearchBarState();
}

class _TerminalSearchBarState extends State<_TerminalSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<(int line, int start, int end)> _matches = [];
  int _currentMatchIndex = -1;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.isEmpty) {
      setState(() {
        _matches = [];
        _currentMatchIndex = -1;
      });
      return;
    }

    final matches = <(int, int, int)>[];
    final lines = widget.terminal.buffer.lines;
    final lowerQuery = query.toLowerCase();

    for (var i = 0; i < lines.length; i++) {
      final text = lines[i].toString().toLowerCase();
      var start = 0;
      while (true) {
        final idx = text.indexOf(lowerQuery, start);
        if (idx < 0) break;
        matches.add((i, idx, idx + lowerQuery.length));
        start = idx + 1;
      }
    }

    setState(() {
      _matches = matches;
      _currentMatchIndex = matches.isNotEmpty ? 0 : -1;
    });
  }

  void _nextMatch() {
    if (_matches.isEmpty) return;
    setState(() {
      _currentMatchIndex = (_currentMatchIndex + 1) % _matches.length;
    });
  }

  void _previousMatch() {
    if (_matches.isEmpty) return;
    setState(() {
      _currentMatchIndex =
          (_currentMatchIndex - 1 + _matches.length) % _matches.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      color: AppColors.bgSurface,
      child: Container(
        width: 320,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: AppTypography.bodySmall,
                decoration: InputDecoration(
                  hintText: l10n.terminalSearchHint,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  border: InputBorder.none,
                  suffixText: _matches.isNotEmpty
                      ? '${_currentMatchIndex + 1}/${_matches.length}'
                      : _controller.text.isNotEmpty
                          ? l10n.terminalSearchNoMatches
                          : null,
                  suffixStyle: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                onChanged: _search,
                onSubmitted: (_) => _nextMatch(),
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.chevronUp, size: 16),
              onPressed: _previousMatch,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            IconButton(
              icon: const Icon(LucideIcons.chevronDown, size: 16),
              onPressed: _nextMatch,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            IconButton(
              icon: const Icon(LucideIcons.x, size: 16),
              onPressed: widget.onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              tooltip: l10n.terminalSearchClose,
            ),
          ],
        ),
      ),
    );
  }
}

/// Draggable divider between split terminal panes.
///
/// Supports both horizontal (left/right) and vertical (top/bottom)
/// split directions with hover animation.
class _SplitDragHandle extends StatefulWidget {
  const _SplitDragHandle({
    required this.isHorizontal,
    required this.onDrag,
    required this.onCloseSplit,
    required this.chromeBorder,
    required this.chromeSurface,
  });

  final bool isHorizontal;
  final ValueChanged<double> onDrag;
  final VoidCallback onCloseSplit;
  final Color chromeBorder;
  final Color chromeSurface;

  @override
  State<_SplitDragHandle> createState() => _SplitDragHandleState();
}

class _SplitDragHandleState extends State<_SplitDragHandle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.isHorizontal
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onHorizontalDragUpdate: widget.isHorizontal
            ? (details) => widget.onDrag(details.primaryDelta ?? 0)
            : null,
        onVerticalDragUpdate: widget.isHorizontal
            ? null
            : (details) => widget.onDrag(details.primaryDelta ?? 0),
        onDoubleTap: widget.onCloseSplit,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.isHorizontal ? 6 : double.infinity,
          height: widget.isHorizontal ? double.infinity : 6,
          color: _isHovered
              ? AppColors.accentPrimary.withValues(alpha: 0.3)
              : widget.chromeBorder,
          child: Center(
            child: Container(
              width: widget.isHorizontal ? 2 : 32,
              height: widget.isHorizontal ? 32 : 2,
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppColors.accentPrimary
                    : widget.chromeSurface,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Banner shown during auto-reconnection attempts.
class _ReconnectBanner extends StatelessWidget {
  const _ReconnectBanner({
    required this.attempt,
    required this.maxAttempts,
    required this.onCancel,
    required this.chromeBg,
  });

  final int attempt;
  final int maxAttempts;
  final VoidCallback onCancel;
  final Color chromeBg;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Color.alphaBlend(
        AppColors.accentOrange.withValues(alpha: 0.15),
        chromeBg,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accentOrange,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.terminalReconnecting(attempt, maxAttempts),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.accentOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              l10n.terminalReconnectCancel,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.accentOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Banner shown after reconnection fails, offering a manual retry.
class _RetryBanner extends StatelessWidget {
  const _RetryBanner({
    required this.onRetry,
    required this.chromeBg,
  });

  final VoidCallback onRetry;
  final Color chromeBg;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Color.alphaBlend(
        AppColors.accentRed.withValues(alpha: 0.12),
        chromeBg,
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.wifiOff, size: 14, color: AppColors.accentRed),
          const SizedBox(width: 8),
          Text(
            l10n.terminalConnectionLost,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.accentRed,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onRetry,
            icon: Icon(LucideIcons.refreshCw,
                size: 14, color: AppColors.accentRed),
            label: Text(
              l10n.retry,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.accentRed,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows a bottom sheet with connection health and session info.
void _showConnectionHealthSheet(
    BuildContext context, WidgetRef ref, TerminalTab tab) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.bgSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => _ConnectionHealthSheet(tab: tab),
  );
}

/// Connection health info bottom sheet.
class _ConnectionHealthSheet extends ConsumerWidget {
  const _ConnectionHealthSheet({required this.tab});

  final TerminalTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hostsAsync = ref.watch(allHostsProvider);
    final host = hostsAsync.whenOrNull(
      data: (hosts) => hosts
          .where((h) => h.id == tab.session.hostId)
          .firstOrNull,
    );

    final connectedDuration = tab.connectedAt != null
        ? DateTime.now().difference(tab.connectedAt!)
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDefault,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.terminalConnectionInfoTitle, style: AppTypography.h2),
          const SizedBox(height: 16),

          // Status indicator
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tab.isReconnecting
                      ? AppColors.accentOrange
                      : tab.isConnected
                          ? AppColors.statusOnline
                          : AppColors.statusOffline,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                tab.isReconnecting
                    ? l10n.terminalStatusReconnecting
                    : tab.isConnected
                        ? l10n.terminalStatusConnected
                        : l10n.terminalStatusDisconnected,
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _InfoRow(
            label: l10n.terminalInfoLabelHost,
            value: tab.hostLabel,
            icon: LucideIcons.server,
          ),
          if (host != null) ...[
            _InfoRow(
              label: l10n.terminalInfoLabelAddress,
              value: '${host.hostname}:${host.port}',
              icon: LucideIcons.globe,
            ),
            _InfoRow(
              label: l10n.terminalInfoLabelUsername,
              value: host.username,
              icon: LucideIcons.user,
            ),
            if (host.jumpHostId != null)
              _InfoRow(
                label: l10n.terminalInfoLabelProxyJump,
                value: l10n.terminalInfoValueProxyJump,
                icon: LucideIcons.network,
              ),
          ],
          if (connectedDuration != null)
            _InfoRow(
              label: l10n.terminalInfoLabelUptime,
              value: Formatters.duration(connectedDuration),
              icon: LucideIcons.clock,
            ),
          if (tab.connectedAt != null)
            _InfoRow(
              label: l10n.terminalInfoLabelConnectedAt,
              value: Formatters.fullDateTime(tab.connectedAt!),
              icon: LucideIcons.calendar,
            ),
          _InfoRow(
            label: l10n.terminalInfoLabelSessionId,
            value: tab.session.sessionId.substring(0, 8),
            icon: LucideIcons.fingerprint,
          ),
          if (tab.isSplit)
            _InfoRow(
              label: l10n.terminalInfoLabelSplit,
              value: tab.splitDirection == SplitDirection.horizontal
                  ? l10n.terminalInfoValueSplitHorizontal
                  : l10n.terminalInfoValueSplitVertical,
              icon: LucideIcons.columns,
            ),
          if (tab.isLogging)
            _InfoRow(
              label: l10n.terminalInfoLabelLogging,
              value: l10n.terminalInfoValueLoggingActive,
              icon: LucideIcons.fileText,
            ),
        ],
      ),
    );
  }
}

/// A single row of connection info.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Terminal status bar showing connection status, duration, logging, and encoding.
class _StatusBar extends StatefulWidget {
  const _StatusBar({
    required this.isConnected,
    required this.chromeBg,
    required this.chromeBorder,
    required this.foreground,
    this.isReconnecting = false,
    this.connectedAt,
    this.isLogging = false,
    this.onToggleLogging,
    this.isBroadcasting = false,
    this.broadcastGroupSize = 0,
    this.onToggleBroadcast,
    this.onLongPressBroadcast,
    this.onShowConnectionInfo,
  });

  final bool isConnected;
  final bool isReconnecting;
  final DateTime? connectedAt;
  final bool isLogging;
  final VoidCallback? onToggleLogging;
  final bool isBroadcasting;
  final int broadcastGroupSize;
  final VoidCallback? onToggleBroadcast;
  final VoidCallback? onLongPressBroadcast;
  final VoidCallback? onShowConnectionInfo;
  final Color chromeBg;
  final Color chromeBorder;
  final Color foreground;

  @override
  State<_StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<_StatusBar> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statusColor = widget.isReconnecting
        ? AppColors.accentOrange
        : widget.isConnected
            ? AppColors.statusOnline
            : AppColors.statusOffline;
    final statusText = widget.isReconnecting
        ? l10n.terminalStatusReconnecting
        : widget.isConnected
            ? l10n.terminalStatusConnected
            : l10n.terminalStatusDisconnected;
    final statusIcon = widget.isReconnecting
        ? LucideIcons.refreshCw
        : widget.isConnected
            ? LucideIcons.wifi
            : LucideIcons.wifiOff;

    // Derive a muted text color from the theme foreground
    final mutedFg = widget.foreground.withValues(alpha: 0.5);

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: widget.chromeBg,
        border: Border(
          top: BorderSide(color: widget.chromeBorder),
        ),
      ),
      child: Row(
        children: [
          // Connection status (tappable)
          InkWell(
            onTap: widget.onShowConnectionInfo,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 12, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    statusText,
                    style: AppTypography.caption.copyWith(
                      fontSize: 11,
                      color: statusColor,
                    ),
                  ),
                  if (widget.isConnected && !widget.isReconnecting) ...[
                    const SizedBox(width: 4),
                    Text(
                      '\u2022',
                      style: AppTypography.caption.copyWith(
                        fontSize: 11,
                        color: mutedFg,
                      ),
                    ),
                    const SizedBox(width: 4),
                    _DurationCounter(
                      connectedAt: widget.connectedAt,
                      foreground: mutedFg,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const Spacer(),

          // Logging toggle
          InkWell(
            onTap: widget.onToggleLogging,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.fileText,
                    size: 11,
                    color: widget.isLogging
                        ? AppColors.accentGreen
                        : mutedFg,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    widget.isLogging ? l10n.terminalStatusBarLogActive : l10n.terminalStatusBarLogInactive,
                    style: AppTypography.caption.copyWith(
                      fontSize: 10,
                      fontWeight:
                          widget.isLogging ? FontWeight.w700 : FontWeight.w400,
                      color: widget.isLogging
                          ? AppColors.accentGreen
                          : mutedFg,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Broadcast toggle
          if (widget.onToggleBroadcast != null)
            Tooltip(
              message: widget.isBroadcasting
                  ? l10n.terminalBroadcastOnTooltip
                  : l10n.terminalBroadcastOffTooltip,
              child: GestureDetector(
                onTap: widget.onToggleBroadcast,
                onLongPress: widget.onLongPressBroadcast,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.radio,
                        size: 11,
                        color: widget.isBroadcasting
                            ? AppColors.accentOrange
                            : mutedFg,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        widget.isBroadcasting
                            ? widget.broadcastGroupSize > 0
                                ? l10n.terminalBroadcastCastActiveWithCount(widget.broadcastGroupSize)
                                : l10n.terminalBroadcastCastActive
                            : l10n.terminalBroadcastCastInactive,
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          fontWeight: widget.isBroadcasting
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: widget.isBroadcasting
                              ? AppColors.accentOrange
                              : mutedFg,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (widget.onToggleBroadcast != null) const SizedBox(width: 8),

          // Encoding
          Text(
            AppConstants.defaultEncoding,
            style: AppTypography.caption.copyWith(
              fontSize: 11,
              color: mutedFg,
            ),
          ),
        ],
      ),
    );
  }
}

/// Lightweight widget that only rebuilds once per second to show elapsed duration.
///
/// Extracted from _StatusBarState so the timer-driven rebuild is isolated
/// to just the duration text, not the entire status bar.
class _DurationCounter extends StatefulWidget {
  const _DurationCounter({
    required this.connectedAt,
    required this.foreground,
  });
  final DateTime? connectedAt;
  final Color foreground;

  @override
  State<_DurationCounter> createState() => _DurationCounterState();
}

class _DurationCounterState extends State<_DurationCounter> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.connectedAt == null) {
      return Text(
        '0:00',
        style: AppTypography.code(fontSize: 11).copyWith(
          color: widget.foreground,
        ),
      );
    }
    final elapsed = DateTime.now().difference(widget.connectedAt!);
    return Text(
      Formatters.duration(elapsed),
      style: AppTypography.code(fontSize: 11).copyWith(
        color: widget.foreground,
      ),
    );
  }
}
