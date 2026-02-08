/// Drift table definition for port forwarding rules.
///
/// Stores SSH tunnel configurations (local, remote, dynamic)
/// associated with specific hosts.
library;

import 'package:drift/drift.dart';

/// Port forwarding tunnel types.
enum PortForwardTypeEnum { local, remote, dynamic }

/// Drift table for SSH port forwarding rule definitions.
///
/// Each rule defines a tunnel type, source/destination ports,
/// and whether it should auto-start when the host connects.
class PortForwards extends Table {
  /// Unique identifier (UUID v4).
  TextColumn get id => text()();

  /// User-facing display name.
  TextColumn get label => text().withLength(min: 1, max: 64)();

  /// Tunnel type (local, remote, or dynamic SOCKS proxy).
  IntColumn get type => intEnum<PortForwardTypeEnum>()();

  /// Foreign key to the host this rule applies to.
  TextColumn get hostId => text()();

  /// Source port on the local or remote side.
  IntColumn get sourcePort => integer()();

  /// Destination host for local/remote forwarding.
  TextColumn get destinationHost => text().nullable()();

  /// Destination port for local/remote forwarding.
  IntColumn get destinationPort => integer().nullable()();

  /// Whether to start this tunnel automatically on connect.
  BoolColumn get autoStart => boolean().withDefault(const Constant(false))();

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
