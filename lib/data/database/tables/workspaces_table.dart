/// Drift table definition for saved workspaces.
///
/// Stores workspace layout configurations (open tabs, terminal
/// session references) that can be saved and restored across
/// app restarts.
library;

import 'package:drift/drift.dart';

/// Drift table for saved workspaces.
///
/// Each workspace stores a JSON-encoded layout of open tabs
/// and terminal host references. One workspace is marked active
/// at a time for auto-restore on app startup.
class Workspaces extends Table {
  /// Unique workspace identifier (UUID).
  TextColumn get id => text()();

  /// User-assigned workspace name.
  TextColumn get name => text().withLength(min: 1, max: 64)();

  /// JSON-encoded layout state (page tabs, terminal host refs, active tab).
  TextColumn get layoutJson => text()();

  /// Whether this is the currently active workspace.
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();

  /// When this workspace was first created.
  DateTimeColumn get createdAt => dateTime()();

  /// When this workspace was last modified.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
