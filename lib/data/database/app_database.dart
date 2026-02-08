/// Drift database definition for CloudShell.
///
/// Defines the local SQLite database with all tables and DAOs.
/// The database is encrypted at rest using SQLCipher via a key
/// stored in the platform keychain.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../../core/constants/storage_keys.dart';
import 'daos/group_dao.dart';
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
/// for each domain. The database is encrypted at rest using
/// SQLCipher with a 256-bit key stored in the platform keychain.
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
    GroupDao,
    HostDao,
    KeyDao,
    SnippetDao,
    SettingsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

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

/// Generates or retrieves the database encryption key from
/// the platform keychain.
///
/// On first launch a cryptographically random 32-byte key is
/// generated and stored. Subsequent launches retrieve the same key.
Future<String> _getOrCreateDbEncryptionKey() async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  var key = await storage.read(key: StorageKeys.dbEncryptionKey);
  if (key == null) {
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    key = base64Url.encode(bytes);
    await storage.write(key: StorageKeys.dbEncryptionKey, value: key);
  }
  return key;
}

/// Opens an encrypted SQLite database connection.
///
/// The database file is stored in the application support
/// directory and encrypted with SQLCipher using a key from
/// the platform keychain.
LazyDatabase _openEncryptedConnection() {
  return LazyDatabase(() async {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'cloudshell.db'));

    final encryptionKey = await _getOrCreateDbEncryptionKey();

    return NativeDatabase.createInBackground(
      file,
      setup: (db) {
        // Enable SQLCipher encryption with the keychain-stored key.
        final keyHex = encryptionKey.codeUnits
            .map((c) => c.toRadixString(16).padLeft(2, '0'))
            .join();
        db.execute("PRAGMA key = \"x'$keyHex'\";");
        db.execute('PRAGMA kdf_iter = 256000;');
        db.execute('PRAGMA journal_mode = WAL;');
        db.execute('PRAGMA foreign_keys = ON;');
      },
    );
  });
}

/// Riverpod provider for the application database singleton.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(_openEncryptedConnection());
  ref.onDispose(() => db.close());
  return db;
});
