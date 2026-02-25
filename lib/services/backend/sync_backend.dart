/// Abstract sync backend interface.
///
/// Defines the contract for sync operations: vault config storage
/// and encrypted item CRUD. Supabase is the initial implementation;
/// swap to a custom REST API by implementing this interface.
library;

/// Vault configuration data for multi-device key derivation.
class VaultConfigData {
  const VaultConfigData({
    required this.kdfSalt,
    required this.kdfMemory,
    required this.kdfIterations,
    required this.kdfParallelism,
    this.verificationToken,
  });

  /// Base64-encoded Argon2id salt.
  final String kdfSalt;

  /// Argon2id memory parameter (KB).
  final int kdfMemory;

  /// Argon2id iterations parameter.
  final int kdfIterations;

  /// Argon2id parallelism parameter.
  final int kdfParallelism;

  /// Encrypted verification token to validate master password.
  final String? verificationToken;
}

/// A single encrypted sync item as stored on the backend.
class RemoteSyncItem {
  const RemoteSyncItem({
    required this.entityType,
    required this.entityId,
    required this.encryptedData,
    required this.syncVersion,
    required this.isDeleted,
    this.updatedAt,
  });

  /// Entity type: 'host', 'ssh_key', 'group', 'snippet', 'port_forward'.
  final String entityType;

  /// Local UUID of the entity.
  final String entityId;

  /// E2E encrypted JSON payload (base64).
  final String encryptedData;

  /// Lamport clock version for conflict resolution.
  final int syncVersion;

  /// Whether this item has been soft-deleted.
  final bool isDeleted;

  /// Server-side timestamp of last update.
  final DateTime? updatedAt;
}

/// Supported entity types for sync.
abstract final class SyncEntityTypes {
  static const String host = 'host';
  static const String sshKey = 'ssh_key';
  static const String group = 'group';
  static const String snippet = 'snippet';
  static const String portForward = 'port_forward';

  /// All entity types in sync order (respects FK dependencies).
  static const List<String> ordered = [
    group,
    sshKey,
    host,
    snippet,
    portForward,
  ];
}

/// Abstract sync backend — Supabase today, custom API tomorrow.
///
/// All sync operations go through this interface. The SyncService
/// never talks to Supabase directly; it talks to this abstraction.
abstract class SyncBackend {
  // --- Vault Config ---

  /// Fetches the vault configuration for the current user.
  /// Returns null if no vault has been initialized on the server.
  Future<VaultConfigData?> getVaultConfig();

  /// Saves (upserts) the vault configuration for the current user.
  Future<void> saveVaultConfig(VaultConfigData config);

  // --- Sync Items ---

  /// Pulls all items of [entityType] with syncVersion > [sinceVersion].
  Future<List<RemoteSyncItem>> pullChanges(
    String entityType,
    int sinceVersion,
  );

  /// Pushes (upserts) a single encrypted item to the backend.
  Future<void> pushItem(RemoteSyncItem item);

  /// Marks an item as soft-deleted on the backend.
  Future<void> softDeleteItem(
    String entityType,
    String entityId,
    int syncVersion,
  );
}
