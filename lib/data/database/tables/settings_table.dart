/// Drift table definition for application settings.
///
/// Stores user preferences as key-value pairs with
/// string values (JSON-encoded for complex types).
library;

import 'package:drift/drift.dart';

/// Drift table for application settings (key-value store).
///
/// Settings are stored as string key-value pairs. Complex
/// values are JSON-encoded. This allows flexible schema
/// evolution without migrations.
class Settings extends Table {
  /// Setting key name (unique identifier).
  TextColumn get key => text()();

  /// Setting value (string-encoded).
  TextColumn get value => text()();

  /// Record last-modified timestamp.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}
