/// Drift table definition for SSH hosts.
///
/// Maps to the Host data model and stores all connection
/// configuration for saved SSH servers.
library;

import 'package:drift/drift.dart';

/// Supported SSH authentication methods.
enum AuthMethodType { key, password, keyAndPassword, interactive }

/// Connection protocol types.
enum ProtocolType { ssh, telnet, serial }

/// Drift table for SSH host connection configurations.
///
/// Each row represents a saved SSH server with all its
/// connection parameters and metadata.
@TableIndex(name: 'idx_hosts_is_deleted', columns: {#isDeleted})
@TableIndex(name: 'idx_hosts_group', columns: {#isDeleted, #groupId})
@TableIndex(name: 'idx_hosts_last_connected', columns: {#lastConnectedAt})
@TableIndex(name: 'idx_hosts_favorite', columns: {#isFavorite})
class Hosts extends Table {
  /// Unique identifier (UUID v4).
  TextColumn get id => text()();

  /// User-facing display name.
  TextColumn get label => text().withLength(min: 1, max: 64)();

  /// Hostname or IP address.
  TextColumn get hostname => text()();

  /// SSH port number (default 22).
  IntColumn get port => integer().withDefault(const Constant(22))();

  /// SSH username for authentication.
  TextColumn get username => text()();

  /// Authentication method selection.
  IntColumn get authMethod => intEnum<AuthMethodType>()();

  /// Foreign key reference to the SSH key used for auth.
  TextColumn get keyId => text().nullable()();

  /// Foreign key reference to the host group.
  TextColumn get groupId => text().nullable()();

  /// Comma-separated tags for search and filtering.
  TextColumn get tags => text().withDefault(const Constant(''))();

  /// Command to execute automatically on connect.
  TextColumn get startupCommand => text().nullable()();

  /// Keep-alive interval in seconds.
  IntColumn get keepAliveSeconds => integer().withDefault(const Constant(60))();

  /// Foreign key reference to another host used as a jump host.
  TextColumn get jumpHostId => text().nullable()();

  /// Character encoding override (default UTF-8).
  TextColumn get encoding => text().nullable()();

  /// User notes about this host.
  TextColumn get notes => text().nullable()();

  /// Manual sort order for drag-and-drop reordering.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Whether this host is marked as favorite.
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  /// Timestamp of the last successful connection.
  DateTimeColumn get lastConnectedAt => dateTime().nullable()();

  /// Record creation timestamp.
  DateTimeColumn get createdAt => dateTime()();

  /// Record last-modified timestamp.
  DateTimeColumn get updatedAt => dateTime()();

  /// Lamport clock for sync conflict resolution.
  IntColumn get syncVersion => integer().withDefault(const Constant(0))();

  /// Soft-delete tombstone flag.
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  /// Connection protocol (SSH, Telnet, Serial). Defaults to SSH.
  IntColumn get protocol =>
      intEnum<ProtocolType>().withDefault(const Constant(0))();

  // --- Serial port configuration (nullable, only used when protocol == serial) ---

  /// Serial port device path (e.g. /dev/ttyUSB0, COM3).
  TextColumn get serialPort => text().nullable()();

  /// Serial baud rate (e.g. 9600, 115200).
  IntColumn get serialBaudRate => integer().nullable()();

  /// Serial data bits (5, 6, 7, or 8).
  IntColumn get serialDataBits => integer().nullable()();

  /// Serial stop bits (1 or 2).
  IntColumn get serialStopBits => integer().nullable()();

  /// Serial parity mode (none, odd, even, mark, space).
  TextColumn get serialParity => text().nullable()();

  /// Serial flow control (none, hardware, software).
  TextColumn get serialFlowControl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
