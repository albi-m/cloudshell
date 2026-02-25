/// Workspace tabs provider for Chrome-style global tab bar.
///
/// Manages the set of open workspace tabs (page views + terminal sessions)
/// displayed in the top tab bar. Supports singleton tabs for navigation
/// pages and instance tabs for terminal/SFTP sessions.
///
/// Workspace layouts are auto-saved to the database with a 2-second debounce
/// and can be restored on app startup to recreate terminal sessions.
library;

import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/route_names.dart';
import '../data/database/app_database.dart';
import '../services/ssh/ssh_service.dart';
import 'terminal_tab_provider.dart';

/// Types of workspace tabs.
enum WorkspaceTabType {
  hosts,
  keys,
  snippets,
  settings,
  portForwarding,
  terminal,
  sftp,
}

/// A single tab in the workspace tab bar.
class WorkspaceTab {
  const WorkspaceTab({
    required this.id,
    required this.type,
    required this.label,
    required this.icon,
    this.terminalTabId,
    this.routePath,
  });

  /// Unique identifier for this tab.
  final String id;

  /// Type of tab (determines behavior: singleton vs instance).
  final WorkspaceTabType type;

  /// Display label shown on the tab.
  final String label;

  /// Icon shown on the tab.
  final IconData icon;

  /// For terminal tabs: references the TerminalTab id in terminalTabsProvider.
  final String? terminalTabId;

  /// For page tabs: the GoRouter path to navigate to.
  final String? routePath;

  /// Whether this tab type is a singleton (only one can exist).
  bool get isSingleton => switch (type) {
        WorkspaceTabType.hosts ||
        WorkspaceTabType.keys ||
        WorkspaceTabType.snippets ||
        WorkspaceTabType.settings ||
        WorkspaceTabType.portForwarding =>
          true,
        WorkspaceTabType.terminal || WorkspaceTabType.sftp => false,
      };

  /// Whether this tab can be closed.
  bool get isClosable => !isSingleton || type != WorkspaceTabType.hosts;
}

/// State of all workspace tabs.
class WorkspaceState {
  const WorkspaceState({
    this.tabs = const [],
    this.activeTabId,
  });

  final List<WorkspaceTab> tabs;
  final String? activeTabId;

  WorkspaceTab? get activeTab {
    if (activeTabId == null) return null;
    return tabs.where((t) => t.id == activeTabId).firstOrNull;
  }

  int get activeIndex => tabs.indexWhere((t) => t.id == activeTabId);
}

const _uuid = Uuid();

/// Manages the global workspace tab bar state.
class WorkspaceNotifier extends Notifier<WorkspaceState> {
  Timer? _saveDebounce;

  /// ID of the currently active workspace in the database.
  String? _activeWorkspaceId;

  @override
  WorkspaceState build() {
    ref.onDispose(() => _saveDebounce?.cancel());
    // Start with Hosts tab open by default
    return const WorkspaceState(
      tabs: [
        WorkspaceTab(
          id: 'hosts',
          type: WorkspaceTabType.hosts,
          label: 'Hosts',
          icon: LucideIcons.server,
          routePath: RouteNames.hosts,
        ),
      ],
      activeTabId: 'hosts',
    );
  }

  /// Opens or switches to a singleton page tab.
  void ensureTab(WorkspaceTabType type) {
    final existing = state.tabs.where((t) => t.type == type).firstOrNull;
    if (existing != null) {
      state = WorkspaceState(
        tabs: state.tabs,
        activeTabId: existing.id,
      );
      _scheduleAutoSave();
      return;
    }

    final tab = _createPageTab(type);
    if (tab == null) return;

    state = WorkspaceState(
      tabs: [...state.tabs, tab],
      activeTabId: tab.id,
    );
    _scheduleAutoSave();
  }

  /// Opens or switches to the SFTP tab (singleton).
  void openSftpTab() {
    final existing =
        state.tabs.where((t) => t.type == WorkspaceTabType.sftp).firstOrNull;
    if (existing != null) {
      state = WorkspaceState(
        tabs: state.tabs,
        activeTabId: existing.id,
      );
      _scheduleAutoSave();
      return;
    }

    const tab = WorkspaceTab(
      id: 'sftp',
      type: WorkspaceTabType.sftp,
      label: 'SFTP',
      icon: LucideIcons.folderOpen,
    );

    state = WorkspaceState(
      tabs: [...state.tabs, tab],
      activeTabId: tab.id,
    );
    _scheduleAutoSave();
  }

  /// Opens a terminal session tab.
  void openTerminalTab(String terminalTabId, String hostLabel) {
    // Check if already open
    final existing = state.tabs
        .where((t) =>
            t.type == WorkspaceTabType.terminal &&
            t.terminalTabId == terminalTabId)
        .firstOrNull;
    if (existing != null) {
      state = WorkspaceState(
        tabs: state.tabs,
        activeTabId: existing.id,
      );
      _scheduleAutoSave();
      return;
    }

    final tab = WorkspaceTab(
      id: 'terminal_$terminalTabId',
      type: WorkspaceTabType.terminal,
      label: hostLabel,
      icon: LucideIcons.terminal,
      terminalTabId: terminalTabId,
    );

    state = WorkspaceState(
      tabs: [...state.tabs, tab],
      activeTabId: tab.id,
    );
    _scheduleAutoSave();
  }

  /// Switches to the tab with the given ID.
  void switchToTab(String tabId) {
    if (state.tabs.any((t) => t.id == tabId)) {
      state = WorkspaceState(
        tabs: state.tabs,
        activeTabId: tabId,
      );
      _scheduleAutoSave();
    }
  }

  /// Closes a tab by ID. Returns the next tab to activate (or null).
  WorkspaceTab? closeTab(String tabId) {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex < 0) return null;

    final wasActive = state.activeTabId == tabId;
    final newTabs = List<WorkspaceTab>.from(state.tabs)..removeAt(tabIndex);

    // Always keep at least the Hosts tab
    if (newTabs.isEmpty) {
      final hostsTab = _createPageTab(WorkspaceTabType.hosts)!;
      state = WorkspaceState(
        tabs: [hostsTab],
        activeTabId: hostsTab.id,
      );
      return hostsTab;
    }

    String? newActiveId = state.activeTabId;
    WorkspaceTab? nextTab;
    if (wasActive) {
      if (tabIndex < newTabs.length) {
        nextTab = newTabs[tabIndex];
      } else {
        nextTab = newTabs.last;
      }
      newActiveId = nextTab.id;
    }

    state = WorkspaceState(
      tabs: newTabs,
      activeTabId: newActiveId,
    );
    _scheduleAutoSave();

    return wasActive ? nextTab : null;
  }

  /// Removes all terminal tabs (used when closing all sessions).
  void closeAllTerminalTabs() {
    final newTabs =
        state.tabs.where((t) => t.type != WorkspaceTabType.terminal).toList();
    final activeStillExists =
        newTabs.any((t) => t.id == state.activeTabId);

    if (newTabs.isEmpty) {
      final hostsTab = _createPageTab(WorkspaceTabType.hosts)!;
      state = WorkspaceState(tabs: [hostsTab], activeTabId: hostsTab.id);
      return;
    }

    state = WorkspaceState(
      tabs: newTabs,
      activeTabId: activeStillExists ? state.activeTabId : newTabs.first.id,
    );
    _scheduleAutoSave();
  }

  // ---------------------------------------------------------------------------
  // Workspace persistence
  // ---------------------------------------------------------------------------

  /// Schedules an auto-save with a 2-second debounce.
  void _scheduleAutoSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(seconds: 2), () {
      _saveCurrentWorkspace();
    });
  }

  /// Serializes the current workspace state to JSON and saves to DB.
  Future<void> _saveCurrentWorkspace() async {
    try {
      final db = ref.read(databaseProvider);
      final terminalTabs = ref.read(terminalTabsProvider);

      // Build layout JSON
      final pageTabs = state.tabs
          .where((t) => t.isSingleton)
          .map((t) => t.type.name)
          .toList();

      final terminalEntries = <Map<String, String>>[];
      for (final wTab in state.tabs) {
        if (wTab.type != WorkspaceTabType.terminal) continue;
        // Find matching terminal tab to get hostId
        final tTab = terminalTabs.tabs
            .where((t) => t.id == wTab.terminalTabId)
            .firstOrNull;
        if (tTab != null && tTab.session.hostId.isNotEmpty) {
          terminalEntries.add({
            'hostId': tTab.session.hostId,
            'label': wTab.label,
          });
        }
      }

      final layoutJson = jsonEncode({
        'pageTabs': pageTabs,
        'terminalTabs': terminalEntries,
        'activeTabType': state.activeTab?.type.name,
        'activeTabId': state.activeTabId,
        'sftpOpen': state.tabs.any((t) => t.type == WorkspaceTabType.sftp),
      });

      // Create or update the active workspace
      _activeWorkspaceId ??= _uuid.v4();
      final now = DateTime.now();

      await db.workspaceDao.saveWorkspace(WorkspacesCompanion(
        id: Value(_activeWorkspaceId!),
        name: const Value('Default'),
        layoutJson: Value(layoutJson),
        isActive: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));
    } catch (e) {
      debugPrint('Workspace auto-save failed: $e');
      // Silently fail — auto-save shouldn't crash the app
    }
  }

  /// Saves the current workspace with a custom name.
  Future<void> saveAsNewWorkspace(String name) async {
    final db = ref.read(databaseProvider);
    final terminalTabs = ref.read(terminalTabsProvider);

    final pageTabs = state.tabs
        .where((t) => t.isSingleton)
        .map((t) => t.type.name)
        .toList();

    final terminalEntries = <Map<String, String>>[];
    for (final wTab in state.tabs) {
      if (wTab.type != WorkspaceTabType.terminal) continue;
      final tTab = terminalTabs.tabs
          .where((t) => t.id == wTab.terminalTabId)
          .firstOrNull;
      if (tTab != null && tTab.session.hostId.isNotEmpty) {
        terminalEntries.add({
          'hostId': tTab.session.hostId,
          'label': wTab.label,
        });
      }
    }

    final layoutJson = jsonEncode({
      'pageTabs': pageTabs,
      'terminalTabs': terminalEntries,
      'activeTabType': state.activeTab?.type.name,
      'activeTabId': state.activeTabId,
      'sftpOpen': state.tabs.any((t) => t.type == WorkspaceTabType.sftp),
    });

    final id = _uuid.v4();
    final now = DateTime.now();

    await db.workspaceDao.saveWorkspace(WorkspacesCompanion(
      id: Value(id),
      name: Value(name),
      layoutJson: Value(layoutJson),
      isActive: const Value(false),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
  }

  /// Restores the active workspace from the database.
  ///
  /// Reconstructs page tabs directly and queues terminal tabs
  /// for reconnection. Returns the number of terminals queued
  /// for reconnection (0 if no workspace found).
  Future<int> restoreWorkspace() async {
    try {
      final db = ref.read(databaseProvider);
      final workspace = await db.workspaceDao.getActiveWorkspace();
      if (workspace == null) return 0;

      _activeWorkspaceId = workspace.id;

      final layout =
          jsonDecode(workspace.layoutJson) as Map<String, dynamic>;

      // Reconstruct page tabs
      final pageTabs = <WorkspaceTab>[];
      final pageTabNames = (layout['pageTabs'] as List?)?.cast<String>() ?? [];
      for (final name in pageTabNames) {
        final type = WorkspaceTabType.values
            .where((t) => t.name == name)
            .firstOrNull;
        if (type != null) {
          final tab = _createPageTab(type);
          if (tab != null) pageTabs.add(tab);
        }
      }

      // Add SFTP tab if it was open
      if (layout['sftpOpen'] == true) {
        pageTabs.add(const WorkspaceTab(
          id: 'sftp',
          type: WorkspaceTabType.sftp,
          label: 'SFTP',
          icon: LucideIcons.folderOpen,
        ));
      }

      // Ensure at least Hosts tab exists
      if (!pageTabs.any((t) => t.type == WorkspaceTabType.hosts)) {
        pageTabs.insert(0, _createPageTab(WorkspaceTabType.hosts)!);
      }

      // Determine terminal tabs to reconnect
      final terminalEntries =
          (layout['terminalTabs'] as List?)?.cast<Map<String, dynamic>>() ??
              [];

      // Set initial state with page tabs only
      state = WorkspaceState(
        tabs: pageTabs,
        activeTabId: pageTabs.isNotEmpty ? pageTabs.first.id : 'hosts',
      );

      // Queue terminal reconnections
      if (terminalEntries.isNotEmpty) {
        _reconnectTerminals(terminalEntries, db);
      }

      return terminalEntries.length;
    } catch (e) {
      debugPrint('Workspace restore tab counting failed: $e');
      return 0;
    }
  }

  /// Reconnects terminal sessions from saved workspace data.
  ///
  /// Processes up to 3 terminals in parallel to speed up startup
  /// while avoiding overwhelming the network.
  Future<void> _reconnectTerminals(
    List<Map<String, dynamic>> entries,
    AppDatabase db,
  ) async {
    const maxConcurrent = 3;
    final futures = <Future<void>>[];

    for (final entry in entries) {
      futures.add(_reconnectSingleTerminal(entry, db));
      if (futures.length >= maxConcurrent) {
        await Future.wait(futures);
        futures.clear();
      }
    }
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  /// Reconnects a single terminal session from saved workspace data.
  Future<void> _reconnectSingleTerminal(
    Map<String, dynamic> entry,
    AppDatabase db,
  ) async {
    final hostId = entry['hostId'] as String?;
    final label = entry['label'] as String? ?? 'Terminal';
    if (hostId == null || hostId.isEmpty) return;

    try {
      final host = await db.hostDao.getHostById(hostId);
      if (host == null) return;

      final sshService = ref.read(sshServiceProvider);
      final session = await sshService.connect(host: host);

      await ref
          .read(terminalTabsProvider.notifier)
          .addTab(session, label);

      openTerminalTab(session.sessionId, label);
    } catch (e) {
      debugPrint('Terminal restore failed: $e');
      // Terminal restore is best-effort — failed connections
      // are silently skipped. User can reconnect manually.
    }
  }

  /// Switches to a saved workspace by loading it from the database.
  Future<int> switchToWorkspace(String workspaceId) async {
    final db = ref.read(databaseProvider);

    // Set as active
    await db.workspaceDao.setActiveWorkspace(workspaceId);

    // Close all current terminal tabs
    await ref.read(terminalTabsProvider.notifier).closeAllTabs();

    _activeWorkspaceId = workspaceId;

    // Restore from DB
    return restoreWorkspace();
  }

  WorkspaceTab? _createPageTab(WorkspaceTabType type) {
    return switch (type) {
      WorkspaceTabType.hosts => const WorkspaceTab(
          id: 'hosts',
          type: WorkspaceTabType.hosts,
          label: 'Hosts',
          icon: LucideIcons.server,
          routePath: RouteNames.hosts,
        ),
      WorkspaceTabType.keys => const WorkspaceTab(
          id: 'keys',
          type: WorkspaceTabType.keys,
          label: 'Keys',
          icon: LucideIcons.keyRound,
          routePath: RouteNames.keys,
        ),
      WorkspaceTabType.snippets => const WorkspaceTab(
          id: 'snippets',
          type: WorkspaceTabType.snippets,
          label: 'Snippets',
          icon: LucideIcons.code2,
          routePath: RouteNames.snippets,
        ),
      WorkspaceTabType.settings => const WorkspaceTab(
          id: 'settings',
          type: WorkspaceTabType.settings,
          label: 'Settings',
          icon: LucideIcons.settings,
          routePath: RouteNames.settings,
        ),
      WorkspaceTabType.portForwarding => const WorkspaceTab(
          id: 'port_forwarding',
          type: WorkspaceTabType.portForwarding,
          label: 'Port Forwarding',
          icon: LucideIcons.arrowLeftRight,
          routePath: RouteNames.portForwarding,
        ),
      _ => null,
    };
  }
}

/// Provider for workspace tab bar state.
final workspaceProvider =
    NotifierProvider<WorkspaceNotifier, WorkspaceState>(
  WorkspaceNotifier.new,
);

/// Stream provider for all saved workspaces (for manager screen).
final allWorkspacesProvider = StreamProvider<List<Workspace>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.workspaceDao.watchAllWorkspaces();
});
