/// Drift table definition for encrypted secrets storage.
///
/// Stores sensitive data (SSH keys, passwords, tokens) as
/// AES-256-GCM encrypted key-value pairs in the local database.
/// Replaces platform keychain (flutter_secure_storage) to avoid
/// macOS keychain password prompts on debug rebuilds.
library;

import 'package:drift/drift.dart';

/// Drift table for encrypted secrets (key-value store).
///
/// Values are encrypted with AES-256-GCM before being stored.
/// The [encryptedValue] column holds the base64-encoded ciphertext,
/// and [nonce] holds the base64-encoded IV/nonce used for encryption.
class Secrets extends Table {
  /// Secret key name (unique identifier, e.g. "cloudshell_ssh_key_{id}").
  TextColumn get key => text()();

  /// AES-256-GCM encrypted value (base64-encoded ciphertext + MAC tag).
  TextColumn get encryptedValue => text()();

  /// AES-256-GCM nonce/IV used for this entry (base64-encoded, 12 bytes).
  TextColumn get nonce => text()();

  /// Record creation/update timestamp.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}
