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
import '../crypto/secure_storage.dart';
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
    required this.secureStorage,
  });

  final SyncBackend backend;
  final AppDatabase db;
  final VaultCryptoService crypto;
  final SecureStorageService secureStorage;

  /// Runs a full sync cycle for all entity types.
  ///
  /// Order: groups → sshKeys → hosts → snippets → portForwards
  /// (respects foreign key dependencies).
  ///
  /// If any decryption error occurs during pull (HMAC verification,
  /// format mismatch, etc.), purges all server items and retries
  /// as a push-only sync. This handles stale data encrypted with
  /// old keys (e.g., after Argon2id param change across devices).
  Future<SyncResult> sync(VaultKeys keys) async {
    // Pre-flight: verify we can decrypt server data before full sync.
    // If ANY remote item fails decryption, purge and push-only.
    final canDecrypt = await _verifyServerDecryptability(keys);
    if (!canDecrypt) {
      _log.w('Server data decryption check failed, purging and re-syncing');
      return _purgeAndResync(keys);
    }

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
      // Any decryption error during sync → purge and retry
      if (_isDecryptionError(e)) {
        _log.w('Decryption error during sync, purging: $e');
        return _purgeAndResync(keys);
      }
      _log.e('Sync failed: $e', error: e, stackTrace: stackTrace);
      return SyncResult(success: false, error: '$e');
    }
  }

  /// Checks if the error is a decryption/crypto failure.
  bool _isDecryptionError(Object e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('hmac') ||
        msg.contains('tampered') ||
        msg.contains('decrypt') ||
        msg.contains('verification failed') ||
        msg.contains('aes') ||
        msg.contains('cipher') ||
        (e is FormatException);
  }

  /// Tries to decrypt one remote item to verify key compatibility.
  ///
  /// Returns true if server has no data or data decrypts successfully.
  /// Returns false if any item fails to decrypt (stale keys).
  Future<bool> _verifyServerDecryptability(VaultKeys keys) async {
    try {
      // Check the first entity type that has remote data
      for (final entityType in SyncEntityTypes.ordered) {
        final remoteItems = await backend.pullChanges(entityType, -1);
        for (final item in remoteItems) {
          if (item.isDeleted) continue;
          // Try to decrypt just this one item
          try {
            final encrypted = EncryptedItem.fromJson(item.encryptedData);
            await crypto.decryptItem(encrypted, keys.encKey, keys.macKey);
            return true; // At least one item decrypts — keys are compatible
          } catch (e) {
            _log.w('Pre-flight decryption check failed for '
                '$entityType/${item.entityId}: $e');
            return false; // Can't decrypt — keys are stale
          }
        }
      }
      return true; // No remote data at all — nothing to verify
    } catch (e) {
      _log.w('Pre-flight check error: $e');
      return true; // Network error etc. — proceed with normal sync
    }
  }

  /// Purges all server-side sync items and performs a push-only sync.
  ///
  /// Called when HMAC verification fails, indicating server data was
  /// encrypted with different keys (e.g., after Argon2id param change).
  Future<SyncResult> _purgeAndResync(VaultKeys keys) async {
    try {
      // 1. Delete all server items
      await backend.purgeAllItems();
      _log.i('Purged all server sync items');

      // 2. Reset local sync metadata
      await db.syncMetadataDao.resetAll();
      _log.i('Reset local sync metadata');

      // 3. Push-only sync: re-encrypt and push all local data
      // All items get version starting at 1 so other devices can pull them.
      var totalPushed = 0;
      for (final entityType in SyncEntityTypes.ordered) {
        final localChanges = await _getLocalChanges(entityType, -1);
        var nextVersion = 1;
        for (final item in localChanges) {
          final json = await _serializeEntity(entityType, item);
          final plaintext = jsonEncode(json);
          final encrypted = await crypto.encryptItem(
            plaintext,
            keys.encKey,
            keys.macKey,
          );

          var syncVersion = _getSyncVersion(entityType, item);
          final entityId = _getEntityId(entityType, item);
          if (syncVersion < 1) {
            syncVersion = nextVersion;
            await _updateLocalSyncVersion(entityType, entityId, syncVersion);
          }
          if (syncVersion >= nextVersion) {
            nextVersion = syncVersion + 1;
          }

          await backend.pushItem(RemoteSyncItem(
            entityType: entityType,
            entityId: entityId,
            encryptedData: encrypted.toJson(),
            syncVersion: syncVersion,
            isDeleted: _getIsDeleted(entityType, item),
          ));
          totalPushed++;
        }

        // Update sync metadata
        if (localChanges.isNotEmpty) {
          final maxVersion = await _getMaxSyncVersion(entityType);
          await db.syncMetadataDao.upsertMetadata(
            entityType,
            maxVersion,
            DateTime.now(),
          );
        }
      }

      _log.i('Re-synced $totalPushed items after purge');
      return SyncResult(
        success: true,
        pulled: 0,
        pushed: totalPushed,
      );
    } catch (e, stackTrace) {
      _log.e('Purge and re-sync failed: $e', error: e, stackTrace: stackTrace);
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
    // Get items changed since last sync version
    var localChanges = await _getLocalChanges(entityType, lastVersion);
    // Also include newly created items (syncVersion 0) that were added
    // after the initial sync — getChangedSince(1+) would miss them.
    if (lastVersion > 0) {
      final newItems = (await _getLocalChanges(entityType, -1))
          .where((item) => _getSyncVersion(entityType, item) == 0)
          .toList();
      if (newItems.isNotEmpty) {
        final existingIds =
            localChanges.map((e) => _getEntityId(entityType, e)).toSet();
        final uniqueNew = newItems
            .where((item) =>
                !existingIds.contains(_getEntityId(entityType, item)))
            .toList();
        localChanges = [...localChanges, ...uniqueNew];
      }
    }
    var pushed = 0;

    // Compute the push version for new items (syncVersion 0).
    // Other devices pull with `sync_version > lastVersion`, so items
    // pushed at version 0 are invisible if lastVersion >= 0. We must
    // assign a version higher than what any device has already seen.
    final maxRemoteVersion = remoteItems.isEmpty
        ? lastVersion
        : remoteItems
            .map((e) => e.syncVersion)
            .reduce((a, b) => a > b ? a : b);
    final maxLocalVersion = await _getMaxSyncVersion(entityType);
    var nextVersion =
        (maxRemoteVersion > maxLocalVersion ? maxRemoteVersion : maxLocalVersion) + 1;

    for (final item in localChanges) {
      final json = await _serializeEntity(entityType, item);
      final plaintext = jsonEncode(json);
      final encrypted = await crypto.encryptItem(
        plaintext,
        keys.encKey,
        keys.macKey,
      );

      var syncVersion = _getSyncVersion(entityType, item);
      final entityId = _getEntityId(entityType, item);

      // Bump version 0 items so other devices can see them
      if (syncVersion == 0) {
        syncVersion = nextVersion++;
        await _updateLocalSyncVersion(entityType, entityId, syncVersion);
      }

      await backend.pushItem(RemoteSyncItem(
        entityType: entityType,
        entityId: entityId,
        encryptedData: encrypted.toJson(),
        syncVersion: syncVersion,
        isDeleted: _getIsDeleted(entityType, item),
      ));
      pushed++;
    }

    // 4. Update sync metadata
    final newMaxLocalVersion = await _getMaxSyncVersion(entityType);
    var newVersion =
        maxRemoteVersion > newMaxLocalVersion ? maxRemoteVersion : newMaxLocalVersion;

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
        // Store private key material in secure storage (from sync payload)
        await _storePrivateKeyFromSync(json);
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

  Future<Map<String, dynamic>> _serializeEntity(
      String entityType, dynamic entity) async {
    final json = switch (entityType) {
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

    // Include private key material for SSH keys (E2E encrypted in sync payload)
    if (entityType == SyncEntityTypes.sshKey) {
      final keyId = (entity as SshKey).privateKeyRef;
      final privateKey = await secureStorage.getSshPrivateKey(keyId);
      if (privateKey != null) {
        json['_privateKeyPem'] = privateKey;
      }
      final passphrase = await secureStorage.getSshPassphrase(keyId);
      if (passphrase != null) {
        json['_passphrase'] = passphrase;
      }
    }

    return json;
  }

  /// Stores private key material from a synced SSH key payload.
  Future<void> _storePrivateKeyFromSync(Map<String, dynamic> json) async {
    final keyId = json['id'] as String?;
    if (keyId == null) return;

    final privateKeyPem = json['_privateKeyPem'] as String?;
    if (privateKeyPem != null) {
      await secureStorage.storeSshPrivateKey(keyId, privateKeyPem);
    }

    final passphrase = json['_passphrase'] as String?;
    if (passphrase != null) {
      await secureStorage.storeSshPassphrase(keyId, passphrase);
    }
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

  /// Updates a local entity's syncVersion after pushing to the backend.
  ///
  /// Ensures the local record's version matches what was pushed, so
  /// it won't be re-pushed on the next sync cycle.
  Future<void> _updateLocalSyncVersion(
    String entityType,
    String entityId,
    int version,
  ) async {
    final table = switch (entityType) {
      SyncEntityTypes.host => 'hosts',
      SyncEntityTypes.sshKey => 'ssh_keys',
      SyncEntityTypes.group => 'host_groups',
      SyncEntityTypes.snippet => 'snippets',
      SyncEntityTypes.portForward => 'port_forwards',
      _ => null,
    };
    if (table == null) return;
    await db.customStatement(
      'UPDATE $table SET sync_version = ? WHERE id = ?',
      [version, entityId],
    );
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
    secureStorage: ref.watch(secureStorageProvider),
  );
});
