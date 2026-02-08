/// Drift table definition for host groups.
///
/// Groups organize hosts into folders/categories with
/// optional nesting and inheritable default settings.
library;

import 'package:drift/drift.dart';

/// Drift table for host group organization.
///
/// Groups support nesting (parent-child) and inheritable
/// defaults for username, port, and SSH key.
class HostGroups extends Table {
  /// Unique identifier (UUID v4).
  TextColumn get id => text()();

  /// Display name for the group.
  TextColumn get name => text().withLength(min: 1, max: 64)();

  /// Parent group ID for nested groups.
  TextColumn get parentGroupId => text().nullable()();

  /// Default username inherited by hosts in this group.
  TextColumn get defaultUsername => text().nullable()();

  /// Default SSH port inherited by hosts in this group.
  IntColumn get defaultPort => integer().nullable()();

  /// Default SSH key inherited by hosts in this group.
  TextColumn get defaultKeyId => text().nullable()();

  /// Sort order for manual ordering.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

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
