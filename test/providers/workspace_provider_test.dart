// Tests for WorkspaceNotifier tab management.
//
// Verifies:
// - Default state starts with Hosts tab
// - ensureTab creates and switches to singleton tabs
// - openTerminalTab adds instance tabs
// - closeTab removes tabs and activates neighbor
// - closeAllTerminalTabs removes only terminal tabs
// - WorkspaceTab singleton/closable properties
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloudshell/data/database/app_database.dart';
import 'package:cloudshell/providers/workspace_provider.dart';
import 'package:cloudshell/providers/terminal_tab_provider.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = createTestDatabase();
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        // Override terminal tabs to avoid SSH dependencies
        terminalTabsProvider
            .overrideWith(() => _EmptyTerminalTabsNotifier()),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  group('WorkspaceNotifier initial state', () {
    test('starts with Hosts tab', () {
      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(1));
      expect(state.tabs.first.type, WorkspaceTabType.hosts);
      expect(state.activeTabId, 'hosts');
    });

    test('active tab is Hosts', () {
      final state = container.read(workspaceProvider);
      expect(state.activeTab, isNotNull);
      expect(state.activeTab!.label, 'Hosts');
    });

    test('activeIndex is 0', () {
      final state = container.read(workspaceProvider);
      expect(state.activeIndex, 0);
    });
  });

  group('ensureTab', () {
    test('creates singleton tab and activates it', () {
      final notifier = container.read(workspaceProvider.notifier);
      notifier.ensureTab(WorkspaceTabType.keys);

      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(2));
      expect(state.activeTabId, 'keys');
      expect(state.tabs.last.type, WorkspaceTabType.keys);
      expect(state.tabs.last.label, 'Keys');
    });

    test('switches to existing singleton instead of duplicating', () {
      final notifier = container.read(workspaceProvider.notifier);
      notifier.ensureTab(WorkspaceTabType.keys);
      notifier.ensureTab(WorkspaceTabType.settings);
      notifier.ensureTab(WorkspaceTabType.keys); // Switch back

      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(3)); // hosts, keys, settings
      expect(state.activeTabId, 'keys');
    });

    test('opens all singleton types', () {
      final notifier = container.read(workspaceProvider.notifier);
      notifier.ensureTab(WorkspaceTabType.keys);
      notifier.ensureTab(WorkspaceTabType.snippets);
      notifier.ensureTab(WorkspaceTabType.settings);
      notifier.ensureTab(WorkspaceTabType.portForwarding);

      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(5));
    });
  });

  group('openTerminalTab', () {
    test('adds instance tab', () {
      final notifier = container.read(workspaceProvider.notifier);
      notifier.openTerminalTab('t1', 'Server 1');

      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(2)); // hosts + terminal
      expect(state.activeTabId, 'terminal_t1');
      expect(state.tabs.last.label, 'Server 1');
      expect(state.tabs.last.type, WorkspaceTabType.terminal);
    });

    test('switches to existing terminal tab', () {
      final notifier = container.read(workspaceProvider.notifier);
      notifier.openTerminalTab('t1', 'Server 1');
      notifier.ensureTab(WorkspaceTabType.hosts);
      notifier.openTerminalTab('t1', 'Server 1'); // reopen same

      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(2)); // no duplicate
      expect(state.activeTabId, 'terminal_t1');
    });

    test('multiple terminal tabs coexist', () {
      final notifier = container.read(workspaceProvider.notifier);
      notifier.openTerminalTab('t1', 'Server 1');
      notifier.openTerminalTab('t2', 'Server 2');

      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(3)); // hosts + 2 terminals
      expect(state.activeTabId, 'terminal_t2');
    });
  });

  group('closeTab', () {
    test('removes tab and activates neighbor', () {
      final notifier = container.read(workspaceProvider.notifier);
      notifier.ensureTab(WorkspaceTabType.keys);
      notifier.ensureTab(WorkspaceTabType.settings);

      // Close settings (active tab)
      final next = notifier.closeTab('settings');

      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(2)); // hosts, keys
      expect(next, isNotNull);
      expect(next!.id, 'keys');
    });

    test('keeps at least Hosts tab', () {
      final notifier = container.read(workspaceProvider.notifier);

      // Close the only tab (hosts)
      final next = notifier.closeTab('hosts');

      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(1));
      expect(state.tabs.first.type, WorkspaceTabType.hosts);
      expect(next, isNotNull); // Recreated hosts tab
    });

    test('returns null when closing non-active tab', () {
      final notifier = container.read(workspaceProvider.notifier);
      notifier.ensureTab(WorkspaceTabType.keys);
      notifier.ensureTab(WorkspaceTabType.settings); // settings is active

      // Close keys (not active)
      final next = notifier.closeTab('keys');

      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(2)); // hosts, settings
      expect(next, isNull); // Didn't need to switch
      expect(state.activeTabId, 'settings');
    });

    test('closing nonexistent tab returns null', () {
      final notifier = container.read(workspaceProvider.notifier);
      final next = notifier.closeTab('nonexistent');
      expect(next, isNull);
    });
  });

  group('closeAllTerminalTabs', () {
    test('removes only terminal tabs', () {
      final notifier = container.read(workspaceProvider.notifier);
      notifier.ensureTab(WorkspaceTabType.keys);
      notifier.openTerminalTab('t1', 'Server 1');
      notifier.openTerminalTab('t2', 'Server 2');

      notifier.closeAllTerminalTabs();

      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(2)); // hosts, keys
      expect(
        state.tabs.any((t) => t.type == WorkspaceTabType.terminal),
        isFalse,
      );
    });

    test('ensures Hosts tab when all closed', () {
      final notifier = container.read(workspaceProvider.notifier);
      // Close hosts, then add only terminals
      notifier.openTerminalTab('t1', 'Server 1');

      // Remove hosts tab manually (by closing it)
      notifier.closeTab('hosts');

      // Now only terminal_t1 exists
      notifier.closeAllTerminalTabs();

      final state = container.read(workspaceProvider);
      expect(state.tabs, hasLength(1));
      expect(state.tabs.first.type, WorkspaceTabType.hosts);
    });
  });

  group('switchToTab', () {
    test('switches active tab', () {
      final notifier = container.read(workspaceProvider.notifier);
      notifier.ensureTab(WorkspaceTabType.keys);

      notifier.switchToTab('hosts');

      final state = container.read(workspaceProvider);
      expect(state.activeTabId, 'hosts');
    });

    test('ignores nonexistent tab ID', () {
      final notifier = container.read(workspaceProvider.notifier);
      notifier.switchToTab('nonexistent');

      final state = container.read(workspaceProvider);
      expect(state.activeTabId, 'hosts'); // unchanged
    });
  });

  group('WorkspaceTab properties', () {
    test('singleton tabs are correct types', () {
      const hostsTab = WorkspaceTab(
        id: 'h', type: WorkspaceTabType.hosts, label: 'H', icon: Icons.circle,
      );
      const termTab = WorkspaceTab(
        id: 't', type: WorkspaceTabType.terminal, label: 'T', icon: Icons.circle,
      );
      const sftpTab = WorkspaceTab(
        id: 's', type: WorkspaceTabType.sftp, label: 'S', icon: Icons.circle,
      );

      expect(hostsTab.isSingleton, isTrue);
      expect(termTab.isSingleton, isFalse);
      expect(sftpTab.isSingleton, isFalse);
    });

    test('hosts tab is not closable', () {
      const hostsTab = WorkspaceTab(
        id: 'h', type: WorkspaceTabType.hosts, label: 'H', icon: Icons.circle,
      );
      expect(hostsTab.isClosable, isFalse);
    });

    test('keys tab is closable', () {
      const keysTab = WorkspaceTab(
        id: 'k', type: WorkspaceTabType.keys, label: 'K', icon: Icons.circle,
      );
      expect(keysTab.isClosable, isTrue);
    });
  });

  group('WorkspaceState', () {
    test('activeTab returns null when no tabs', () {
      const state = WorkspaceState(tabs: [], activeTabId: null);
      expect(state.activeTab, isNull);
    });

    test('activeIndex returns -1 when no active tab', () {
      const state = WorkspaceState(tabs: [], activeTabId: 'missing');
      expect(state.activeIndex, -1);
    });
  });

  group('WorkspaceTabType', () {
    test('has all expected values', () {
      expect(WorkspaceTabType.values, hasLength(7));
    });
  });
}

/// Minimal terminal tabs notifier for testing workspace without SSH.
class _EmptyTerminalTabsNotifier extends TerminalTabsNotifier {
  @override
  TerminalTabsState build() {
    return const TerminalTabsState(tabs: []);
  }
}
