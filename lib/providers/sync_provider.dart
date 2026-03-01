/// Riverpod providers for sync state management.
///
/// Manages the sync lifecycle: enable/disable, manual sync, auto-sync,
/// status tracking, and pending change counts.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../data/database/app_database.dart';
import '../services/sync/sync_service.dart';
import 'auth_provider.dart';
import 'backend_provider.dart';
import 'settings_provider.dart';
import 'vault_provider.dart';

final _log = Logger(printer: SimplePrinter());

/// Whether sync is enabled by the user in settings.
final syncEnabledProvider = Provider<bool>((ref) {
  final setting = ref.watch(settingProvider(SettingsKeys.syncEnabled));
  return setting.when(
    data: (value) => value == 'true',
    loading: () => false,
    error: (_, _) => false,
  );
});

/// Whether sync is ready to operate (backend + auth + vault + enabled).
final syncReadyProvider = Provider<bool>((ref) {
  final backendAvailable = ref.watch(backendAvailableProvider);
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  final isVaultUnlocked = ref.watch(isVaultUnlockedProvider);
  final syncEnabled = ref.watch(syncEnabledProvider);
  return backendAvailable && isAuthenticated && isVaultUnlocked && syncEnabled;
});

/// Watches the number of pending items in the sync queue.
final pendingSyncCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.syncQueueDao.watchPendingCount();
});

/// Last successful sync timestamp.
final lastSyncTimeProvider = FutureProvider<DateTime?>((ref) async {
  final db = ref.read(databaseProvider);
  final metadata = await db.syncMetadataDao.watchAll().first;
  if (metadata.isEmpty) return null;

  DateTime? latest;
  for (final m in metadata) {
    final syncAt = m.lastSyncAt;
    if (syncAt == null) continue;
    if (latest == null || syncAt.isAfter(latest)) {
      latest = syncAt;
    }
  }
  return latest;
});

/// Manages sync operations and status.
class SyncNotifier extends AsyncNotifier<SyncStatus> {
  Timer? _autoSyncTimer;
  static const _autoSyncInterval = Duration(minutes: 5);

  @override
  Future<SyncStatus> build() {
    ref.onDispose(() {
      _autoSyncTimer?.cancel();
    });

    final syncReady = ref.watch(syncReadyProvider);
    if (!syncReady) {
      _autoSyncTimer?.cancel();
      return Future.value(SyncStatus.disabled);
    }

    // Start auto-sync timer
    _startAutoSync();
    return Future.value(SyncStatus.idle);
  }

  /// Runs a full sync cycle.
  ///
  /// If sync fails with a vault key mismatch on a fresh device (no
  /// local data), automatically re-derives vault keys from the server's
  /// authoritative vault config and retries once.
  Future<SyncResult?> sync() async {
    final syncService = ref.read(syncServiceProvider);
    if (syncService == null) {
      state = const AsyncValue.data(SyncStatus.disabled);
      return null;
    }

    final vaultNotifier = ref.read(vaultProvider.notifier);
    var keys = vaultNotifier.keys;
    if (keys == null) {
      state = const AsyncValue.data(SyncStatus.disabled);
      return null;
    }

    state = const AsyncValue.data(SyncStatus.syncing);

    try {
      var result = await syncService.sync(keys);

      if (result.success) {
        _log.i(
            'Sync complete: pulled ${result.pulled}, pushed ${result.pushed}');

        // Ensure vault config is uploaded (may have been skipped during
        // signup if the session wasn't ready yet).
        await vaultNotifier.reuploadVaultConfig();

        state = const AsyncValue.data(SyncStatus.success);

        // Reset to idle after a short delay
        Future.delayed(const Duration(seconds: 3), () {
          if (state.value == SyncStatus.success) {
            state = const AsyncValue.data(SyncStatus.idle);
          }
        });
      } else {
        _log.e('Sync failed: ${result.error}');
        state = const AsyncValue.data(SyncStatus.error);
      }

      // Invalidate last sync time so it refreshes
      ref.invalidate(lastSyncTimeProvider);

      return result;
    } catch (e, stackTrace) {
      _log.e('Sync error: $e', error: e, stackTrace: stackTrace);
      state = const AsyncValue.data(SyncStatus.error);
      return SyncResult(success: false, error: '$e');
    }
  }

  /// Enables sync and runs an initial sync.
  Future<void> enableSync() async {
    final settings = ref.read(settingsNotifierProvider.notifier);
    await settings.set(SettingsKeys.syncEnabled, 'true');

    // Reset sync metadata for a clean first sync — ensures all
    // existing items (syncVersion 0) get pushed on initial sync.
    final db = ref.read(databaseProvider);
    await db.syncMetadataDao.resetAll();
  }

  /// Disables sync and stops auto-sync.
  Future<void> disableSync() async {
    _autoSyncTimer?.cancel();
    final settings = ref.read(settingsNotifierProvider.notifier);
    await settings.set(SettingsKeys.syncEnabled, 'false');
    state = const AsyncValue.data(SyncStatus.disabled);
  }

  /// Forces a full re-sync by purging server data and re-pushing
  /// all local items. Fixes stale server data from previous sync bugs.
  Future<SyncResult?> forceFullResync() async {
    final syncService = ref.read(syncServiceProvider);
    if (syncService == null) return null;

    final vaultNotifier = ref.read(vaultProvider.notifier);
    final keys = vaultNotifier.keys;
    if (keys == null) return null;

    state = const AsyncValue.data(SyncStatus.syncing);

    try {
      // Purge server + reset metadata + re-push all local data
      final result = await syncService.forceFullResync(keys);

      if (result.success) {
        _log.i('Force re-sync complete: pushed ${result.pushed}');
        state = const AsyncValue.data(SyncStatus.success);
        Future.delayed(const Duration(seconds: 3), () {
          if (state.value == SyncStatus.success) {
            state = const AsyncValue.data(SyncStatus.idle);
          }
        });
      } else {
        _log.e('Force re-sync failed: ${result.error}');
        state = const AsyncValue.data(SyncStatus.error);
      }

      ref.invalidate(lastSyncTimeProvider);
      return result;
    } catch (e, stackTrace) {
      _log.e('Force re-sync error: $e', error: e, stackTrace: stackTrace);
      state = const AsyncValue.data(SyncStatus.error);
      return SyncResult(success: false, error: '$e');
    }
  }

  /// Resets all sync state (used on logout).
  Future<void> resetSync() async {
    _autoSyncTimer?.cancel();
    final db = ref.read(databaseProvider);
    await db.syncMetadataDao.resetAll();
    await db.syncQueueDao.clearAll();
    state = const AsyncValue.data(SyncStatus.disabled);
  }

  void _startAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = Timer.periodic(_autoSyncInterval, (_) {
      if (state.value == SyncStatus.idle ||
          state.value == SyncStatus.error) {
        sync();
      }
    });
  }
}

/// Provider for the sync notifier.
final syncProvider = AsyncNotifierProvider<SyncNotifier, SyncStatus>(
  SyncNotifier.new,
);
