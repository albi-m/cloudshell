/// Riverpod providers for terminal tab management.
///
/// Manages multiple terminal sessions as tabs, tracking
/// which tab is active and providing add/remove/switch operations.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/ssh/ssh_session.dart';

/// Represents a single terminal tab with its session and metadata.
class TerminalTab {
  const TerminalTab({
    required this.id,
    required this.session,
    required this.hostLabel,
    required this.createdAt,
  });

  /// Unique tab identifier (matches session ID).
  final String id;

  /// The active SSH session for this tab.
  final SshSessionWrapper session;

  /// Display name shown on the tab.
  final String hostLabel;

  /// When this tab was created.
  final DateTime createdAt;
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
class TerminalTabsNotifier extends Notifier<TerminalTabsState> {
  @override
  TerminalTabsState build() => const TerminalTabsState();

  /// Opens a new terminal tab and makes it active.
  void addTab(SshSessionWrapper session, String hostLabel) {
    final tab = TerminalTab(
      id: session.sessionId,
      session: session,
      hostLabel: hostLabel,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      tabs: [...state.tabs, tab],
      activeTabId: () => tab.id,
    );
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

    // Remove the tab
    final newTabs = List<TerminalTab>.from(state.tabs)..removeAt(tabIndex);

    // Determine new active tab if this was the active one
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

    // Close the SSH session
    await tab.session.close();
  }

  /// Closes all tabs and their sessions.
  Future<void> closeAllTabs() async {
    for (final tab in state.tabs) {
      await tab.session.close();
    }
    state = const TerminalTabsState();
  }
}

/// Provider for terminal tab state.
final terminalTabsProvider =
    NotifierProvider<TerminalTabsNotifier, TerminalTabsState>(
  TerminalTabsNotifier.new,
);
