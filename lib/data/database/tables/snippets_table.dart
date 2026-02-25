/// Drift table definition for command snippets.
///
/// Stores reusable shell commands organized by category
/// with optional variable placeholders.
library;

import 'package:drift/drift.dart';

/// Drift table for command snippets.
///
/// Snippets are reusable commands that can be inserted
/// into terminal sessions with optional {{variable}} placeholders.
@TableIndex(name: 'idx_snippets_category', columns: {#category, #isDeleted})
class Snippets extends Table {
  /// Unique identifier (UUID v4).
  TextColumn get id => text()();

  /// Display name for the snippet.
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// The actual command text.
  TextColumn get command => text()();

  /// Category for grouping (e.g., "System", "Docker", "Network").
  TextColumn get category => text().nullable()();

  /// JSON-encoded list of variable placeholder names.
  TextColumn get variables => text().withDefault(const Constant('[]'))();

  /// Optional description of what the snippet does.
  TextColumn get description => text().nullable()();

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
