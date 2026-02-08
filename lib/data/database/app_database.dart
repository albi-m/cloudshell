/// Drift database definition for CloudShell.
///
/// Defines the local SQLite database with all tables and DAOs.
/// The database is encrypted at rest using SQLCipher.
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'daos/host_dao.dart';
import 'daos/key_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/snippet_dao.dart';
import 'tables/groups_table.dart';
import 'tables/hosts_table.dart';
import 'tables/keys_table.dart';
import 'tables/known_hosts_table.dart';
import 'tables/port_forwards_table.dart';
import 'tables/settings_table.dart';
import 'tables/snippets_table.dart';

part 'app_database.g.dart';

/// The main Drift database for CloudShell.
///
/// Includes all tables for hosts, groups, SSH keys, snippets,
/// port forwarding rules, known hosts, and settings.
///
/// Data Access Objects (DAOs) provide typed query interfaces
/// for each domain.
@DriftDatabase(
  tables: [
    Hosts,
    HostGroups,
    SshKeys,
    Snippets,
    PortForwards,
    KnownHosts,
    Settings,
  ],
  daos: [
    HostDao,
    KeyDao,
    SnippetDao,
    SettingsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Database schema version — increment when tables change.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle schema migrations here as the app evolves.
      },
    );
  }
}

/// Opens a native SQLite database connection.
///
/// The database file is stored in the application support
/// directory and will be encrypted with SQLCipher once the
/// vault encryption is configured.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Ensure sqlite3 native library is available on Android
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'cloudshell.db'));

    return NativeDatabase.createInBackground(file);
  });
}

/// Riverpod provider for the application database singleton.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
