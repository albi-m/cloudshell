/// Drift table definition for known SSH host fingerprints.
///
/// Implements SSH host key verification (similar to ~/.ssh/known_hosts)
/// to detect MITM attacks and server changes.
library;

import 'package:drift/drift.dart';

/// Drift table for known SSH host key fingerprints.
///
/// When connecting to a server for the first time, the host's
/// public key fingerprint is recorded. On subsequent connections,
/// the fingerprint is compared to detect MITM attacks.
class KnownHosts extends Table {
  /// Unique identifier (UUID v4).
  TextColumn get id => text()();

  /// Hostname or IP address of the server.
  TextColumn get hostname => text()();

  /// SSH port number.
  IntColumn get port => integer()();

  /// Key algorithm type string (e.g., "ssh-ed25519", "ssh-rsa").
  TextColumn get keyType => text()();

  /// SHA256 fingerprint of the host's public key.
  TextColumn get fingerprint => text()();

  /// Full host public key string.
  TextColumn get publicKey => text()();

  /// Whether the user has explicitly trusted this fingerprint.
  BoolColumn get isTrusted => boolean().withDefault(const Constant(true))();

  /// Timestamp when this fingerprint was first seen.
  DateTimeColumn get firstSeen => dateTime()();

  /// Timestamp of the most recent connection to this host.
  DateTimeColumn get lastSeen => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
