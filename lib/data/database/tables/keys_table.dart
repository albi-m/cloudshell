/// Drift table definition for SSH keys.
///
/// Stores SSH key metadata. Private keys are stored
/// separately in flutter_secure_storage for security.
library;

import 'package:drift/drift.dart';

/// Supported SSH key types.
enum KeyTypeEnum { ed25519, rsa, ecdsa }

/// Drift table for SSH key metadata.
///
/// Private key material is NOT stored here — only metadata.
/// The actual private key bytes are in flutter_secure_storage
/// referenced by [privateKeyRef].
class SshKeys extends Table {
  /// Unique identifier (UUID v4).
  TextColumn get id => text()();

  /// User-facing display name.
  TextColumn get label => text().withLength(min: 1, max: 64)();

  /// Key algorithm type.
  IntColumn get keyType => intEnum<KeyTypeEnum>()();

  /// Key size in bits (e.g., 2048, 4096 for RSA; 256 for Ed25519).
  IntColumn get keyBits => integer().nullable()();

  /// The public key string.
  TextColumn get publicKey => text()();

  /// Reference key for retrieving private key from secure storage.
  TextColumn get privateKeyRef => text()();

  /// SHA256 fingerprint of the public key.
  TextColumn get fingerprint => text()();

  /// Whether the private key is protected by a passphrase.
  BoolColumn get hasPassphrase => boolean().withDefault(const Constant(false))();

  /// Record creation timestamp.
  DateTimeColumn get createdAt => dateTime()();

  /// Record last-modified timestamp.
  DateTimeColumn get updatedAt => dateTime()();

  /// Lamport clock for sync conflict resolution.
  IntColumn get syncVersion => integer().withDefault(const Constant(0))();

  /// Soft-delete tombstone flag.
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
