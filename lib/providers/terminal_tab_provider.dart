/// Riverpod providers for terminal tab management.
///
/// Manages multiple terminal sessions as tabs, tracking
/// which tab is active and providing add/remove/switch operations.
/// Owns the xterm.Terminal instances so they survive navigation.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xterm/xterm.dart' as xterm;

import 'package:dartssh2/dartssh2.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../data/database/app_database.dart';
import '../data/database/tables/hosts_table.dart';
import '../services/connection/connection_session.dart';
import '../services/serial/serial_service.dart';
import '../services/ssh/ssh_service.dart';
import '../services/ssh/ssh_session.dart';
import '../services/telnet/telnet_service.dart';
import '../services/terminal/session_logger.dart';
import 'connection_provider.dart';
import 'settings_provider.dart';

const _uuid = Uuid();

/// Direction of a terminal split.
enum SplitDirection { horizontal, vertical }

/// Represents a single pane within a terminal tab.
///
/// Each pane has its own xterm.Terminal, SSH shell (PTY), and I/O wiring.
/// Multiple panes share the same SSH connection (SSHClient) via the tab's session.
class TerminalPane {
  TerminalPane({
    required this.id,
    required this.terminal,
    required this.controller,
    this.shell,
    this.outputSubscription,
    this.isConnected = true,
    this.connectedAt,
  });

  final String id;
  final xterm.Terminal terminal;
  final xterm.TerminalController controller;
  SSHSession? shell;
  StreamSubscription<dynamic>? outputSubscription;
  bool isConnected;
  DateTime? connectedAt;

  /// Writes input to this pane's shell stdin.
  void writeInput(String data) {
    shell?.stdin.add(Uint8List.fromList(data.codeUnits));
  }
}

/// Buffers terminal output to reduce per-frame write count.
///
/// Collects decoded strings in a [StringBuffer] and flushes every 16ms
/// (one frame at 60fps) or when the buffer exceeds 64KB. This prevents
/// high-throughput commands (e.g., `cat large_file`) from causing
/// hundreds of terminal writes per frame.
class TerminalOutputBuffer {
  TerminalOutputBuffer({
    required this.terminal,
    this.onFlush,
  });

  final xterm.Terminal terminal;
  final void Function()? onFlush;

  final _buffer = StringBuffer();
  Timer? _flushTimer;
  static const _flushInterval = Duration(milliseconds: 16);
  static const _maxBufferSize = 65536; // 64KB

  /// Adds decoded text to the buffer and schedules a flush.
  void add(String decoded) {
    _buffer.write(decoded);

    // Flush immediately if buffer is large (prevents memory buildup)
    if (_buffer.length >= _maxBufferSize) {
      flush();
      return;
    }

    // Schedule flush on next frame if not already scheduled
    _flushTimer ??= Timer(_flushInterval, flush);
  }

  /// Writes any buffered text to the terminal.
  void flush() {
    _flushTimer?.cancel();
    _flushTimer = null;
    if (_buffer.isNotEmpty) {
      terminal.write(_buffer.toString());
      _buffer.clear();
      onFlush?.call();
    }
  }

  /// Flushes remaining data and cancels the timer.
  void dispose() {
    flush();
    _flushTimer?.cancel();
  }
}

/// Represents a single terminal tab with its session, xterm state, and metadata.
class TerminalTab {
  TerminalTab({
    required this.id,
    required this.session,
    required this.hostLabel,
    required this.createdAt,
    required this.terminal,
    required this.controller,
  });

  /// Unique tab identifier (matches session ID).
  final String id;

  /// The active connection session for this tab (may change on reconnect).
  ConnectionSession session;

  /// Display name shown on the tab.
  final String hostLabel;

  /// When this tab was created.
  final DateTime createdAt;

  /// The xterm Terminal instance — owns the scrollback buffer.
  /// Lives in the provider so it survives widget disposal.
  final xterm.Terminal terminal;

  /// Terminal controller for selection, etc.
  final xterm.TerminalController controller;

  /// Subscription to the SSH session output stream.
  StreamSubscription<dynamic>? outputSubscription;

  /// Output buffer for micro-batching terminal writes.
  TerminalOutputBuffer? outputBuffer;

  /// Whether the SSH connection is currently active.
  bool isConnected = true;

  /// Whether we are currently attempting to reconnect.
  bool isReconnecting = false;

  /// Current reconnect attempt number.
  int reconnectAttempt = 0;

  /// Whether reconnect was cancelled by the user.
  bool reconnectCancelled = false;

  /// When the current connection was established.
  DateTime? connectedAt;

  // --- Session logging ---

  /// Active session logger (null = logging disabled for this tab).
  SessionLogger? sessionLogger;

  /// Whether session logging is enabled for this tab.
  bool get isLogging => sessionLogger != null && sessionLogger!.isActive;

  // --- Command notification timing ---

  /// When continuous output started (for long-command detection).
  DateTime? commandOutputStart;

  /// Timer that fires when output goes idle (command finished).
  Timer? commandDoneTimer;

  // --- Split pane state ---

  /// Split panes within this tab. Empty = single pane (use primary terminal).
  final List<TerminalPane> panes = [];

  /// Which pane has keyboard focus (null = primary terminal).
  String? activePaneId;

  /// Direction of the split (null = no split, single pane).
  SplitDirection? splitDirection;

  /// Split ratio between panes (0.25–0.75).
  double splitRatio = 0.5;

  /// Whether this tab is currently split.
  bool get isSplit => splitDirection != null && panes.length == 2;

  /// The currently active pane, or null if no split.
  TerminalPane? get activePane {
    if (panes.isEmpty || activePaneId == null) return null;
    return panes.where((p) => p.id == activePaneId).firstOrNull;
  }
}

/// State container for all terminal tabs.
class TerminalTabsState {
  const TerminalTabsState({
    this.tabs = const [],
    this.activeTabId,
  });

  /// Ordered list of open tabs.
  final List<TerminalTab> tabs;

  /// The currently visible tab ID.
  final String? activeTabId;

  /// The currently active tab, or null if no tabs.
  TerminalTab? get activeTab {
    if (activeTabId == null) return null;
    return tabs.where((t) => t.id == activeTabId).firstOrNull;
  }

  /// Index of the active tab, or -1 if not found.
  int get activeIndex => tabs.indexWhere((t) => t.id == activeTabId);

  TerminalTabsState copyWith({
    List<TerminalTab>? tabs,
    String? Function()? activeTabId,
  }) {
    return TerminalTabsState(
      tabs: tabs ?? this.tabs,
      activeTabId: activeTabId != null ? activeTabId() : this.activeTabId,
    );
  }
}

/// Manages the set of open terminal tabs.
///
/// Owns the xterm.Terminal instances and SSH I/O wiring so that
/// terminal state (scrollback, connection) survives navigation.
class TerminalTabsNotifier extends Notifier<TerminalTabsState> {
  /// Whether broadcast mode is active (input to active tab goes to all/selected tabs).
  bool _broadcastEnabled = false;

  /// Set of tab IDs included in selective broadcast.
  /// When empty and broadcast is enabled, input goes to ALL connected tabs.
  /// When non-empty, input only goes to tabs in this set.
  final Set<String> _broadcastGroup = {};

  /// Returns whether broadcast mode is currently enabled.
  bool get broadcastEnabled => _broadcastEnabled;

  /// Returns the set of tab IDs in the selective broadcast group.
  Set<String> get broadcastGroup => Set.unmodifiable(_broadcastGroup);

  /// Toggles broadcast mode on/off (all-or-nothing mode).
  void toggleBroadcast() {
    _broadcastEnabled = !_broadcastEnabled;
    if (!_broadcastEnabled) _broadcastGroup.clear();
    state = state.copyWith();
  }

  /// Toggles a specific tab's inclusion in the broadcast group.
  void toggleBroadcastTab(String tabId) {
    if (_broadcastGroup.contains(tabId)) {
      _broadcastGroup.remove(tabId);
    } else {
      _broadcastGroup.add(tabId);
    }
    // Enable broadcast if group is non-empty, disable if empty
    _broadcastEnabled = _broadcastGroup.isNotEmpty;
    _notifyStateChange();
  }

  /// Enables broadcast to all connected tabs (clears selective group).
  void broadcastAll() {
    _broadcastGroup.clear();
    _broadcastEnabled = true;
    _notifyStateChange();
  }

  /// Disables broadcast entirely and clears the group.
  void disableBroadcast() {
    _broadcastEnabled = false;
    _broadcastGroup.clear();
    _notifyStateChange();
  }

  @override
  TerminalTabsState build() => const TerminalTabsState();

  /// Opens a new terminal tab, starts the shell, and makes it active.
  ///
  /// Creates the xterm.Terminal, wires I/O, and starts the shell.
  /// If [startupCommand] is provided, it will be sent to the shell
  /// after a short delay to allow the remote shell to initialize.
  Future<void> addTab(
    ConnectionSession session,
    String hostLabel, {
    String? startupCommand,
  }) async {
    // Don't add duplicate tabs for the same session
    if (state.tabs.any((t) => t.id == session.sessionId)) {
      switchToTab(session.sessionId);
      return;
    }

    final terminal = xterm.Terminal(
      maxLines: AppConstants.defaultScrollbackLines,
    );

    final controller = xterm.TerminalController();

    final tab = TerminalTab(
      id: session.sessionId,
      session: session,
      hostLabel: hostLabel,
      createdAt: DateTime.now(),
      terminal: terminal,
      controller: controller,
    );

    // Wire terminal output → SSH session input (+ broadcast)
    terminal.onOutput = (data) {
      if (tab.isConnected) {
        session.writeString(data);
      }
      // If broadcast mode is enabled, send to other connected tabs
      if (_broadcastEnabled && tab.id == state.activeTabId) {
        for (final other in state.tabs) {
          if (other.id == tab.id || !other.isConnected) continue;
          // Selective: only send to group members when group is set
          if (_broadcastGroup.isNotEmpty &&
              !_broadcastGroup.contains(other.id)) continue;
          other.session.writeString(data);
        }
      }
    };

    // Wire terminal resize → SSH session resize
    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      if (tab.isConnected) {
        session.resize(width, height);
      }
    };

    // Start the shell
    try {
      await session.startSession(termWidth: 80, termHeight: 24);
      tab.connectedAt = DateTime.now();

      // Subscribe to SSH output → buffered terminal writes + logger
      final outputBuffer = TerminalOutputBuffer(
        terminal: terminal,
        onFlush: () => _trackCommandOutput(tab),
      );
      tab.outputBuffer = outputBuffer;

      tab.outputSubscription = session.output.listen(
        (data) {
          final decoded = utf8.decode(data, allowMalformed: true);
          outputBuffer.add(decoded);
          tab.sessionLogger?.write(decoded);
        },
        onDone: () {
          outputBuffer.flush();
          if (!tab.isReconnecting) {
            _onDisconnected(tab);
          }
        },
        onError: (_) {
          outputBuffer.flush();
          if (!tab.isReconnecting) {
            _onDisconnected(tab);
          }
        },
      );

      // Monitor connection close
      session.done.then((_) {
        if (!tab.isReconnecting) {
          _onDisconnected(tab);
        }
      });

      // Execute startup command after shell initializes
      if (startupCommand != null && startupCommand.trim().isNotEmpty) {
        // Brief delay to let remote shell prompt render
        Future.delayed(const Duration(milliseconds: 500), () {
          if (tab.isConnected) {
            session.writeString('${startupCommand.trim()}\n');
          }
        });
      }
    } catch (e) {
      terminal.write('\r\n[Failed to start shell]\r\n');
      tab.isConnected = false;
    }

    state = state.copyWith(
      tabs: [...state.tabs, tab],
      activeTabId: () => tab.id,
    );
  }

  /// Called when a session disconnects.
  ///
  /// Guarded against double-invocation — both output.onDone and
  /// session.done can race to call this.
  void _onDisconnected(TerminalTab tab) {
    if (!tab.isConnected || tab.isReconnecting) return;
    tab.isConnected = false;
    tab.terminal.write('\r\n[Connection closed]\r\n');

    // Update connection provider
    ref.read(activeConnectionsProvider.notifier).updateStatus(
          tab.session.sessionId,
          ConnectionStatus.disconnected,
        );

    // Trigger state rebuild
    _notifyStateChange();

    // Auto-reconnect for saved hosts
    if (tab.session.hostId.isNotEmpty) {
      _attemptReconnect(tab);
    }
  }

  /// Attempts automatic reconnection with exponential backoff.
  Future<void> _attemptReconnect(TerminalTab tab) async {
    tab.isReconnecting = true;
    tab.reconnectAttempt = 0;
    tab.reconnectCancelled = false;
    _notifyStateChange();

    final backoffs = AppConstants.reconnectBackoffSeconds;
    final maxAttempts = AppConstants.maxReconnectAttempts;

    for (var i = 0; i < maxAttempts; i++) {
      if (tab.reconnectCancelled) return;

      tab.reconnectAttempt = i + 1;
      final delay = i < backoffs.length ? backoffs[i] : backoffs.last;

      tab.terminal.write('\r\n[Reconnecting in ${delay}s... '
          'attempt ${tab.reconnectAttempt}/$maxAttempts]\r\n');
      _notifyStateChange();

      await Future.delayed(Duration(seconds: delay));
      if (tab.reconnectCancelled) return;

      try {
        tab.terminal.write('[Connecting...]\r\n');

        final db = ref.read(databaseProvider);
        final host = await db.hostDao.getHostById(tab.session.hostId);
        if (host == null) {
          tab.terminal.write('[Host not found. Cannot reconnect.]\r\n');
          break;
        }

        // Create session based on protocol type.
        final newSession = switch (host.protocol) {
          ProtocolType.ssh => await ref.read(sshServiceProvider).connect(host: host),
          ProtocolType.telnet => await ref.read(telnetServiceProvider).connect(host: host),
          ProtocolType.serial => await ref.read(serialServiceProvider).connect(host: host),
        };

        await newSession.startSession(
          termWidth: tab.terminal.viewWidth,
          termHeight: tab.terminal.viewHeight,
        );

        // Cancel old subscription and dispose old buffer
        tab.outputSubscription?.cancel();
        tab.outputBuffer?.dispose();

        // Update session reference
        tab.session = newSession;

        // Re-wire output with fresh buffer (+ logger + command notify)
        final reconnectBuffer = TerminalOutputBuffer(
          terminal: tab.terminal,
          onFlush: () => _trackCommandOutput(tab),
        );
        tab.outputBuffer = reconnectBuffer;

        tab.outputSubscription = newSession.output.listen(
          (data) {
            final decoded = utf8.decode(data, allowMalformed: true);
            reconnectBuffer.add(decoded);
            tab.sessionLogger?.write(decoded);
          },
          onDone: () {
            reconnectBuffer.flush();
            if (!tab.isReconnecting) _onDisconnected(tab);
          },
          onError: (_) {
            reconnectBuffer.flush();
            if (!tab.isReconnecting) _onDisconnected(tab);
          },
        );

        // Re-wire terminal callbacks (with broadcast support)
        tab.terminal.onOutput = (data) {
          if (tab.isConnected) {
            newSession.writeString(data);
          }
          if (_broadcastEnabled && tab.id == state.activeTabId) {
            for (final other in state.tabs) {
              if (other.id == tab.id || !other.isConnected) continue;
              if (_broadcastGroup.isNotEmpty &&
                  !_broadcastGroup.contains(other.id)) continue;
              other.session.writeString(data);
            }
          }
        };

        tab.terminal.onResize = (w, h, pw, ph) {
          if (tab.isConnected) {
            newSession.resize(w, h);
          }
        };

        newSession.done.then((_) {
          if (!tab.isReconnecting) _onDisconnected(tab);
        });

        // Update connection tracking
        ref.read(activeConnectionsProvider.notifier).addConnection(
              newSession.sessionId,
              host.id,
            );
        ref.read(activeConnectionsProvider.notifier).updateStatus(
              newSession.sessionId,
              ConnectionStatus.connected,
            );

        tab.isConnected = true;
        tab.isReconnecting = false;
        tab.connectedAt = DateTime.now();
        tab.terminal.write('[Reconnected]\r\n');
        _notifyStateChange();
        return;
      } catch (e) {
        debugPrint('Terminal reconnect failed: $e');
        tab.terminal.write('[Reconnect failed]\r\n');
      }
    }

    // All attempts exhausted
    tab.isReconnecting = false;
    tab.terminal
        .write('\r\n[Reconnection failed after $maxAttempts attempts]\r\n');
    _notifyStateChange();
  }

  /// Cancels an ongoing reconnect attempt for a tab.
  void cancelReconnect(String tabId) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null) return;
    tab.reconnectCancelled = true;
    tab.isReconnecting = false;
    tab.terminal.write('[Reconnection cancelled]\r\n');
    _notifyStateChange();
  }

  /// Manually retries reconnection for a disconnected tab.
  ///
  /// Called from the UI "Reconnect" button when auto-reconnect
  /// has failed or the user wants to try again.
  void retryReconnect(String tabId) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null || tab.isReconnecting || tab.isConnected) return;
    if (tab.session.hostId.isEmpty) return; // Quick-connect sessions
    _attemptReconnect(tab);
  }

  /// Switches to the tab with the given ID.
  void switchToTab(String tabId) {
    if (state.tabs.any((t) => t.id == tabId)) {
      state = state.copyWith(activeTabId: () => tabId);
    }
  }

  /// Closes a tab and its session. Switches to an adjacent tab
  /// if the closed tab was active.
  Future<void> closeTab(String tabId) async {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex < 0) return;

    final tab = state.tabs[tabIndex];
    final wasActive = state.activeTabId == tabId;

    // Clean up split panes
    for (final pane in tab.panes) {
      pane.outputSubscription?.cancel();
      pane.shell?.close();
      if (pane.controller != tab.controller) {
        pane.controller.dispose();
      }
    }
    tab.panes.clear();

    // Cleanup primary
    tab.reconnectCancelled = true;
    tab.commandDoneTimer?.cancel();
    tab.outputSubscription?.cancel();
    tab.outputBuffer?.dispose();
    await tab.sessionLogger?.close();
    tab.controller.dispose();
    await tab.session.close();

    final newTabs = List<TerminalTab>.from(state.tabs)..removeAt(tabIndex);

    String? newActiveId = state.activeTabId;
    if (wasActive) {
      if (newTabs.isEmpty) {
        newActiveId = null;
      } else if (tabIndex < newTabs.length) {
        newActiveId = newTabs[tabIndex].id;
      } else {
        newActiveId = newTabs.last.id;
      }
    }

    state = TerminalTabsState(
      tabs: newTabs,
      activeTabId: newActiveId,
    );
  }

  /// Closes all tabs and their sessions.
  Future<void> closeAllTabs() async {
    for (final tab in state.tabs) {
      // Clean up split panes
      for (final pane in tab.panes) {
        pane.outputSubscription?.cancel();
        pane.shell?.close();
        if (pane.controller != tab.controller) {
          pane.controller.dispose();
        }
      }
      tab.panes.clear();
      tab.reconnectCancelled = true;
      tab.commandDoneTimer?.cancel();
      tab.outputSubscription?.cancel();
      tab.outputBuffer?.dispose();
      await tab.sessionLogger?.close();
      tab.controller.dispose();
      await tab.session.close();
    }
    state = const TerminalTabsState();
  }

  // -----------------------------------------------------------------------
  // Split pane operations
  // -----------------------------------------------------------------------

  /// Splits the active tab into two panes.
  ///
  /// Opens a second SSH shell on the same connection and creates
  /// a new xterm.Terminal for the new pane. The first call converts
  /// the tab's primary terminal into pane[0] and creates pane[1].
  Future<void> splitPane(String tabId, SplitDirection direction) async {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null || !tab.isConnected || tab.isSplit) return;

    // Split panes require SSH (multiple PTYs on one connection)
    if (tab.session is! SshSessionWrapper) {
      tab.terminal.write('\r\n[Split panes are only supported for SSH connections]\r\n');
      return;
    }

    try {
      // Create second shell on the same SSH connection
      final sshSession = tab.session as SshSessionWrapper;
      final (shell, outputStream) = await sshSession.createShell(
        termWidth: tab.terminal.viewWidth ~/ 2,
        termHeight: tab.terminal.viewHeight,
      );

      final newTerminal = xterm.Terminal(
        maxLines: AppConstants.defaultScrollbackLines,
      );
      final newController = xterm.TerminalController();
      final newPaneId = _uuid.v4();

      // Wire new terminal I/O
      newTerminal.onOutput = (data) {
        shell.stdin.add(Uint8List.fromList(data.codeUnits));
      };
      newTerminal.onResize = (w, h, pw, ph) {
        shell.resizeTerminal(w, h);
      };

      final subscription = outputStream.listen(
        (data) {
          newTerminal.write(utf8.decode(data, allowMalformed: true));
        },
        onDone: () {
          final pane =
              tab.panes.where((p) => p.id == newPaneId).firstOrNull;
          if (pane != null) {
            pane.isConnected = false;
            _notifyStateChange();
          }
        },
      );

      // Initialize pane[0] from the tab's existing primary terminal
      final primaryPaneId = _uuid.v4();
      final primaryPane = TerminalPane(
        id: primaryPaneId,
        terminal: tab.terminal,
        controller: tab.controller,
        isConnected: tab.isConnected,
        connectedAt: tab.connectedAt,
      );

      // Create pane[1] with the new shell
      final newPane = TerminalPane(
        id: newPaneId,
        terminal: newTerminal,
        controller: newController,
        shell: shell,
        outputSubscription: subscription,
        isConnected: true,
        connectedAt: DateTime.now(),
      );

      tab.panes
        ..clear()
        ..addAll([primaryPane, newPane]);
      tab.activePaneId = newPaneId;
      tab.splitDirection = direction;
      tab.splitRatio = 0.5;

      _notifyStateChange();
    } catch (e) {
      tab.terminal.write('\r\n[Failed to split pane]\r\n');
      _notifyStateChange();
    }
  }

  /// Closes the split and reverts to single-pane mode.
  ///
  /// Closes the secondary pane's shell and returns to the
  /// primary terminal view.
  void closeSplitPane(String tabId) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null || !tab.isSplit) return;

    // Close secondary pane(s) — the ones with their own shell
    for (final pane in tab.panes) {
      if (pane.shell != null) {
        pane.outputSubscription?.cancel();
        pane.shell?.close();
        pane.controller.dispose();
      }
    }

    tab.panes.clear();
    tab.activePaneId = null;
    tab.splitDirection = null;

    _notifyStateChange();
  }

  // -----------------------------------------------------------------------
  // Session logging
  // -----------------------------------------------------------------------

  /// Starts session logging for a tab.
  Future<void> startLogging(String tabId) async {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null || tab.isLogging) return;

    try {
      tab.sessionLogger = await SessionLogger.create(
        sessionLabel: tab.hostLabel,
      );
      tab.terminal.write('\r\n[Session logging started: ${tab.sessionLogger!.filePath}]\r\n');
      _notifyStateChange();
    } catch (e) {
      tab.terminal.write('\r\n[Failed to start logging: $e]\r\n');
    }
  }

  /// Stops session logging for a tab.
  Future<void> stopLogging(String tabId) async {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null || !tab.isLogging) return;

    await tab.sessionLogger?.close();
    tab.terminal.write('\r\n[Session logging stopped]\r\n');
    tab.sessionLogger = null;
    _notifyStateChange();
  }

  /// Switches keyboard focus to the other pane.
  void switchActivePane(String tabId) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null || !tab.isSplit) return;

    final currentIndex =
        tab.panes.indexWhere((p) => p.id == tab.activePaneId);
    final nextIndex = (currentIndex + 1) % tab.panes.length;
    tab.activePaneId = tab.panes[nextIndex].id;

    _notifyStateChange();
  }

  /// Tracks output timing for long-running command notification.
  ///
  /// When output arrives, starts tracking. When output stops for 2 seconds,
  /// checks if the command ran longer than the configured threshold and
  /// plays a system alert sound if so.
  void _trackCommandOutput(TerminalTab tab) {
    tab.commandOutputStart ??= DateTime.now();
    tab.commandDoneTimer?.cancel();
    tab.commandDoneTimer = Timer(const Duration(seconds: 2), () {
      final start = tab.commandOutputStart;
      if (start != null && tab.isConnected) {
        final elapsed = DateTime.now().difference(start);
        final enabled = ref.read(commandNotifyEnabledProvider);
        final threshold = ref.read(commandNotifyThresholdProvider);
        if (enabled && elapsed.inSeconds >= threshold) {
          SystemSound.play(SystemSoundType.alert);
        }
      }
      tab.commandOutputStart = null;
    });
  }

  /// Triggers a state rebuild to reflect mutable changes in TerminalTab.
  void _notifyStateChange() {
    state = TerminalTabsState(
      tabs: state.tabs,
      activeTabId: state.activeTabId,
    );
  }
}

/// Provider for terminal tab state.
final terminalTabsProvider =
    NotifierProvider<TerminalTabsNotifier, TerminalTabsState>(
  TerminalTabsNotifier.new,
);
