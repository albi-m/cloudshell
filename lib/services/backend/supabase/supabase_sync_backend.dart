/// Supabase implementation of the SyncBackend interface.
///
/// Uses Supabase PostgREST (via the Dart client) for CRUD
/// operations on vault_config and sync_items tables.
/// Row Level Security ensures users can only access their own data.
library;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../sync_backend.dart';

/// Supabase-backed sync operations.
///
/// All queries go through PostgREST. RLS policies on the database
/// ensure that each user can only read/write their own rows.
class SupabaseSyncBackend implements SyncBackend {
  SupabaseSyncBackend(this._client);

  final SupabaseClient _client;

  String get _userId {
    final user = _client.auth.currentUser;
    if (user == null) throw StateError('Not authenticated');
    return user.id;
  }

  /// Exposes user ID for debug logging only.
  String get debugUserId => _userId;

  // ---------------------------------------------------------------------------
  // Vault Config
  // ---------------------------------------------------------------------------

  @override
  Future<VaultConfigData?> getVaultConfig() async {
    final data = await _client
        .from('vault_config')
        .select()
        .eq('user_id', _userId)
        .maybeSingle();

    if (data == null) return null;

    final params = data['kdf_params'] as Map<String, dynamic>? ?? {};
    return VaultConfigData(
      kdfSalt: data['kdf_salt'] as String,
      kdfMemory: (params['memory'] as num?)?.toInt() ?? 65536,
      kdfIterations: (params['iterations'] as num?)?.toInt() ?? 3,
      kdfParallelism: (params['parallelism'] as num?)?.toInt() ?? 4,
      verificationToken: data['verification_token'] as String?,
    );
  }

  @override
  Future<void> saveVaultConfig(VaultConfigData config) async {
    await _client.from('vault_config').upsert({
      'user_id': _userId,
      'kdf_salt': config.kdfSalt,
      'kdf_params': {
        'memory': config.kdfMemory,
        'iterations': config.kdfIterations,
        'parallelism': config.kdfParallelism,
      },
      'verification_token': config.verificationToken,
    });
  }

  // ---------------------------------------------------------------------------
  // Sync Items
  // ---------------------------------------------------------------------------

  @override
  Future<List<RemoteSyncItem>> pullChanges(
    String entityType,
    int sinceVersion,
  ) async {
    final data = await _client
        .from('sync_items')
        .select()
        .eq('user_id', _userId)
        .eq('entity_type', entityType)
        .gt('sync_version', sinceVersion)
        .order('sync_version', ascending: true);

    return data.map<RemoteSyncItem>((row) {
      return RemoteSyncItem(
        entityType: row['entity_type'] as String,
        entityId: row['entity_id'] as String,
        encryptedData: row['encrypted_data'] as String,
        syncVersion: (row['sync_version'] as num).toInt(),
        isDeleted: row['is_deleted'] as bool,
        updatedAt: row['updated_at'] != null
            ? DateTime.parse(row['updated_at'] as String)
            : null,
      );
    }).toList();
  }

  @override
  Future<void> pushItem(RemoteSyncItem item) async {
    await _client.from('sync_items').upsert(
      {
        'user_id': _userId,
        'entity_type': item.entityType,
        'entity_id': item.entityId,
        'encrypted_data': item.encryptedData,
        'sync_version': item.syncVersion,
        'is_deleted': item.isDeleted,
      },
      onConflict: 'user_id,entity_type,entity_id',
    );
  }

  @override
  Future<void> softDeleteItem(
    String entityType,
    String entityId,
    int syncVersion,
  ) async {
    await _client
        .from('sync_items')
        .update({
          'is_deleted': true,
          'sync_version': syncVersion,
          'encrypted_data': '', // Clear payload on delete
        })
        .eq('user_id', _userId)
        .eq('entity_type', entityType)
        .eq('entity_id', entityId);
  }

  @override
  Future<void> purgeAllItems() async {
    await _client
        .from('sync_items')
        .delete()
        .eq('user_id', _userId);
  }
}
