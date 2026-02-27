/// Backend-agnostic sync engine for CloudShell.
///
/// Orchestrates the pull → resolve → push cycle for all syncable
/// entity types. Depends on abstract SyncBackend interface, not
/// on any specific backend (Supabase, custom API, etc.).
library;

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../data/database/app_database.dart';
import '../../providers/backend_provider.dart';
import '../backend/sync_backend.dart';
import '../crypto/vault_crypto_service.dart';
import 'sync_serializer.dart';

final _log = Logger(printer: SimplePrinter());

/// Current sync status.
enum SyncStatus {
  /// No sync in progress.
  idle,

  /// Sync is running.
  syncing,

  /// Last sync completed successfully.
  success,

  /// Last sync failed.
  error,

  /// Device is offline.
  offline,

  /// Sync is disabled (user preference or not authenticated).
  disabled,
}

/// Result of a sync operation.
class SyncResult {
  const SyncResult({
    required this.success,
    this.error,
    this.pulled = 0,
    this.pushed = 0,
  });

  final bool success;
  final String? error;
  final int pulled;
  final int pushed;
}

/// Orchestrates sync operations for all entity types.
///
/// Uses SyncBackend (abstract) for remote operations and
/// VaultCryptoService for E2E encryption. The sync engine
/// never sees plaintext data on the wire.
class SyncService {
  SyncService({
    required this.backend,
    required this.db,
    required this.crypto,
  });

  final SyncBackend backend;
  final AppDatabase db;
  final VaultCryptoService crypto;

  /// Runs a full sync cycle for all entity types.
  ///
  /// Order: groups → sshKeys → hosts → snippets → portForwards
  /// (respects foreign key dependencies).
  Future<SyncResult> sync(VaultKeys keys) async {
    var totalPulled = 0;
    var totalPushed = 0;

    try {
      for (final entityType in SyncEntityTypes.ordered) {
        final result = await _syncEntityType(entityType, keys);
        totalPulled += result.pulled;
        totalPushed += result.pushed;
      }

      return SyncResult(
        success: true,
        pulled: totalPulled,
        pushed: totalPushed,
      );
    } catch (e, stackTrace) {
      _log.e('Sync failed: $e', error: e, stackTrace: stackTrace);
      return SyncResult(success: false, error: '$e');
    }
  }

  /// Syncs a single entity type: pull then push.
  Future<SyncResult> _syncEntityType(
    String entityType,
    VaultKeys keys,
  ) async {
    // 1. Get last sync version
    var lastVersion =
        await db.syncMetadataDao.getLastSyncVersion(entityType);

    // Detect stale metadata: if stored version is 0 but local items exist
    // at version 0, reset to -1 so `syncVersion > -1` captures them.
    if (lastVersion == 0) {
      final localItems = await _getLocalChanges(entityType, -1);
      if (localItems.isNotEmpty) {
        lastVersion = -1;
        await db.syncMetadataDao.upsertMetadata(
          entityType,
          -1,
          DateTime.now(),
        );
      }
    }

    // 2. Pull remote changes
    final remoteItems = await backend.pullChanges(entityType, lastVersion);
    var pulled = 0;

    for (final item in remoteItems) {
      await _applyRemoteItem(entityType, item, keys);
      pulled++;
    }

    // 3. Push local changes
    final localChanges = await _getLocalChanges(entityType, lastVersion);
    var pushed = 0;

    for (final item in localChanges) {
      final json = _serializeEntity(entityType, item);
      final plaintext = jsonEncode(json);
      final encrypted = await crypto.encryptItem(
        plaintext,
        keys.encKey,
        keys.macKey,
      );

      final syncVersion = _getSyncVersion(entityType, item);
      await backend.pushItem(RemoteSyncItem(
        entityType: entityType,
        entityId: _getEntityId(entityType, item),
        encryptedData: encrypted.toJson(),
        syncVersion: syncVersion,
        isDeleted: _getIsDeleted(entityType, item),
      ));
      pushed++;
    }

    // 4. Update sync metadata
    // Use the highest version seen from either remote or local.
    // If items were pushed at version 0 (initial sync), save version
    // as max+1 so those items aren't re-queried on the next sync.
    final maxRemoteVersion = remoteItems.isEmpty
        ? lastVersion
        : remoteItems
            .map((e) => e.syncVersion)
            .reduce((a, b) => a > b ? a : b);
    final maxLocalVersion = await _getMaxSyncVersion(entityType);
    var newVersion =
        maxRemoteVersion > maxLocalVersion ? maxRemoteVersion : maxLocalVersion;

    // Ensure metadata advances past pushed items so they aren't re-pushed.
    // Items at version 0 would be missed by `> 0` on the next sync,
    // so we save metadata as at least 1 when items were pushed.
    if (pushed > 0 && newVersion < 1) {
      newVersion = 1;
    }

    if (pulled > 0 || pushed > 0 || lastVersion < 0) {
      await db.syncMetadataDao.upsertMetadata(
        entityType,
        newVersion,
        DateTime.now(),
      );
    }

    return SyncResult(
      success: true,
      pulled: pulled,
      pushed: pushed,
    );
  }

  /// Decrypts and applies a single remote item to the local database.
  Future<void> _applyRemoteItem(
    String entityType,
    RemoteSyncItem item,
    VaultKeys keys,
  ) async {
    if (item.isDeleted) {
      // Apply remote deletion locally
      await _applyRemoteDeletion(entityType, item);
      return;
    }

    // Decrypt the payload
    final encrypted = EncryptedItem.fromJson(item.encryptedData);
    final plaintext = await crypto.decryptItem(
      encrypted,
      keys.encKey,
      keys.macKey,
    );
    final json = jsonDecode(plaintext) as Map<String, dynamic>;

    // Check for conflict: compare with local version
    final localVersion = await _getLocalSyncVersion(entityType, item.entityId);
    if (localVersion > item.syncVersion) {
      // Local wins (LWW: higher version wins)
      return;
    }

    // Remote wins or no conflict — apply
    await _upsertFromJson(entityType, json);
  }

  Future<void> _applyRemoteDeletion(
    String entityType,
    RemoteSyncItem item,
  ) async {
    switch (entityType) {
      case SyncEntityTypes.host:
        await db.hostDao.softDeleteHost(item.entityId);
      case SyncEntityTypes.sshKey:
        await db.keyDao.softDeleteKey(item.entityId);
      case SyncEntityTypes.group:
        await db.groupDao.softDeleteGroup(item.entityId);
      case SyncEntityTypes.snippet:
        await db.snippetDao.softDeleteSnippet(item.entityId);
      case SyncEntityTypes.portForward:
        await db.portForwardDao.softDeletePortForward(item.entityId);
    }
  }

  Future<void> _upsertFromJson(
    String entityType,
    Map<String, dynamic> json,
  ) async {
    switch (entityType) {
      case SyncEntityTypes.host:
        await db.hostDao.upsertFromRemote(SyncSerializer.hostFromJson(json));
      case SyncEntityTypes.sshKey:
        await db.keyDao.upsertFromRemote(SyncSerializer.keyFromJson(json));
      case SyncEntityTypes.group:
        await db.groupDao.upsertFromRemote(SyncSerializer.groupFromJson(json));
      case SyncEntityTypes.snippet:
        await db.snippetDao
            .upsertFromRemote(SyncSerializer.snippetFromJson(json));
      case SyncEntityTypes.portForward:
        await db.portForwardDao
            .upsertFromRemote(SyncSerializer.portForwardFromJson(json));
    }
  }

  Future<List<dynamic>> _getLocalChanges(
    String entityType,
    int sinceVersion,
  ) async {
    return switch (entityType) {
      SyncEntityTypes.host => db.hostDao.getChangedSince(sinceVersion),
      SyncEntityTypes.sshKey => db.keyDao.getChangedSince(sinceVersion),
      SyncEntityTypes.group => db.groupDao.getChangedSince(sinceVersion),
      SyncEntityTypes.snippet => db.snippetDao.getChangedSince(sinceVersion),
      SyncEntityTypes.portForward =>
        db.portForwardDao.getChangedSince(sinceVersion),
      _ => <dynamic>[],
    };
  }

  Map<String, dynamic> _serializeEntity(String entityType, dynamic entity) {
    return switch (entityType) {
      SyncEntityTypes.host => SyncSerializer.hostToJson(entity as Host),
      SyncEntityTypes.sshKey => SyncSerializer.keyToJson(entity as SshKey),
      SyncEntityTypes.group =>
        SyncSerializer.groupToJson(entity as HostGroup),
      SyncEntityTypes.snippet =>
        SyncSerializer.snippetToJson(entity as Snippet),
      SyncEntityTypes.portForward =>
        SyncSerializer.portForwardToJson(entity as PortForward),
      _ => <String, dynamic>{},
    };
  }

  String _getEntityId(String entityType, dynamic entity) {
    return switch (entityType) {
      SyncEntityTypes.host => (entity as Host).id,
      SyncEntityTypes.sshKey => (entity as SshKey).id,
      SyncEntityTypes.group => (entity as HostGroup).id,
      SyncEntityTypes.snippet => (entity as Snippet).id,
      SyncEntityTypes.portForward => (entity as PortForward).id,
      _ => '',
    };
  }

  int _getSyncVersion(String entityType, dynamic entity) {
    return switch (entityType) {
      SyncEntityTypes.host => (entity as Host).syncVersion,
      SyncEntityTypes.sshKey => (entity as SshKey).syncVersion,
      SyncEntityTypes.group => (entity as HostGroup).syncVersion,
      SyncEntityTypes.snippet => (entity as Snippet).syncVersion,
      SyncEntityTypes.portForward => (entity as PortForward).syncVersion,
      _ => 0,
    };
  }

  bool _getIsDeleted(String entityType, dynamic entity) {
    return switch (entityType) {
      SyncEntityTypes.host => (entity as Host).isDeleted,
      SyncEntityTypes.sshKey => (entity as SshKey).isDeleted,
      SyncEntityTypes.group => (entity as HostGroup).isDeleted,
      SyncEntityTypes.snippet => (entity as Snippet).isDeleted,
      SyncEntityTypes.portForward => (entity as PortForward).isDeleted,
      _ => false,
    };
  }

  Future<int> _getLocalSyncVersion(String entityType, String entityId) async {
    return switch (entityType) {
      SyncEntityTypes.host => (await db.hostDao.getHostById(entityId))
              ?.syncVersion ??
          0,
      SyncEntityTypes.sshKey =>
        (await db.keyDao.getKeyById(entityId))?.syncVersion ?? 0,
      SyncEntityTypes.group =>
        (await db.groupDao.getGroupById(entityId))?.syncVersion ?? 0,
      SyncEntityTypes.snippet =>
        (await db.snippetDao.getSnippetById(entityId))?.syncVersion ?? 0,
      SyncEntityTypes.portForward =>
        (await db.portForwardDao.getPortForwardById(entityId))?.syncVersion ??
            0,
      _ => 0,
    };
  }

  Future<int> _getMaxSyncVersion(String entityType) async {
    return switch (entityType) {
      SyncEntityTypes.host => db.hostDao.getMaxSyncVersion(),
      SyncEntityTypes.sshKey => db.keyDao.getMaxSyncVersion(),
      SyncEntityTypes.group => db.groupDao.getMaxSyncVersion(),
      SyncEntityTypes.snippet => db.snippetDao.getMaxSyncVersion(),
      SyncEntityTypes.portForward => db.portForwardDao.getMaxSyncVersion(),
      _ => 0,
    };
  }
}

/// Riverpod provider for the sync service.
///
/// Returns null when sync backend is not configured or user is not authenticated.
final syncServiceProvider = Provider<SyncService?>((ref) {
  final authBackend = ref.watch(authBackendProvider);
  if (authBackend == null || !authBackend.isSignedIn) return null;

  final backend = ref.watch(syncBackendProvider);
  if (backend == null) return null;
  return SyncService(
    backend: backend,
    db: ref.watch(databaseProvider),
    crypto: ref.watch(vaultCryptoServiceProvider),
  );
});
