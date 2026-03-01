/// Drift database definition for CloudShell.
///
/// Defines the local SQLite database with all tables and DAOs.
/// SQLCipher encryption will be added in a future sprint.
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'daos/group_dao.dart';
import 'daos/host_dao.dart';
import 'daos/key_dao.dart';
import 'daos/known_host_dao.dart';
import 'daos/port_forward_dao.dart';
import 'daos/secrets_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/snippet_dao.dart';
import 'daos/sync_metadata_dao.dart';
import 'daos/sync_queue_dao.dart';
import 'daos/workspace_dao.dart';
import 'tables/groups_table.dart';
import 'tables/hosts_table.dart';
import 'tables/keys_table.dart';
import 'tables/known_hosts_table.dart';
import 'tables/port_forwards_table.dart';
import 'tables/secrets_table.dart';
import 'tables/settings_table.dart';
import 'tables/snippets_table.dart';
import 'tables/sync_metadata_table.dart';
import 'tables/sync_queue_table.dart';
import 'tables/workspaces_table.dart';

part 'app_database.g.dart';

/// The main Drift database for CloudShell.
///
/// Includes all tables for hosts, groups, SSH keys, snippets,
/// port forwarding rules, known hosts, settings, and sync state.
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
    Secrets,
    Settings,
    SyncMetadata,
    SyncQueue,
    Workspaces,
  ],
  daos: [
    GroupDao,
    HostDao,
    KeyDao,
    KnownHostDao,
    PortForwardDao,
    SecretsDao,
    SnippetDao,
    SettingsDao,
    SyncMetadataDao,
    SyncQueueDao,
    WorkspaceDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Database schema version — increment when tables change.
  @override
  int get schemaVersion => 7;

  /// Migration strategy handling schema upgrades across versions.
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // v1 → v2: Add secrets table for encrypted key-value storage.
        if (from < 2) {
          await m.createTable(secrets);
        }
        // v2 → v3: Add sortOrder column to hosts for drag-and-drop reorder.
        if (from < 3) {
          await m.addColumn(hosts, hosts.sortOrder);
        }
        // v3 → v4: Add sync metadata and sync queue tables.
        if (from < 4) {
          await m.createTable(syncMetadata);
          await m.createTable(syncQueue);
        }
        // v4 → v5: Add workspaces table for layout persistence.
        if (from < 5) {
          await m.createTable(workspaces);
        }
        // v5 → v6: Add indexes for snippet category and group hierarchy.
        if (from < 6) {
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_snippets_category '
            'ON snippets (category, is_deleted)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_groups_parent '
            'ON host_groups (parent_group_id, is_deleted)',
          );
        }
        // v6 → v7: Add protocol type and serial port columns to hosts.
        if (from < 7) {
          await customStatement(
            'ALTER TABLE hosts ADD COLUMN protocol INTEGER NOT NULL DEFAULT 0',
          );
          await customStatement(
            'ALTER TABLE hosts ADD COLUMN serial_port TEXT',
          );
          await customStatement(
            'ALTER TABLE hosts ADD COLUMN serial_baud_rate INTEGER',
          );
          await customStatement(
            'ALTER TABLE hosts ADD COLUMN serial_data_bits INTEGER',
          );
          await customStatement(
            'ALTER TABLE hosts ADD COLUMN serial_stop_bits INTEGER',
          );
          await customStatement(
            'ALTER TABLE hosts ADD COLUMN serial_parity TEXT',
          );
          await customStatement(
            'ALTER TABLE hosts ADD COLUMN serial_flow_control TEXT',
          );
        }
      },
    );
  }
}

/// Opens the SQLite database connection.
///
/// The database file is stored in the application support
/// directory. SQLCipher encryption will be enabled in a future
/// sprint when sqlcipher_flutter_libs is added as a dependency.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'cloudshell.db'));

    return NativeDatabase.createInBackground(
      file,
      setup: (db) {
        db.execute('PRAGMA journal_mode = WAL;');
        db.execute('PRAGMA foreign_keys = ON;');
      },
    );
  });
}

/// Riverpod provider for the application database singleton.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(_openConnection());
  ref.onDispose(() => db.close());
  return db;
});
