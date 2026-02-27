/// Data export/import service for CloudShell.
///
/// Exports hosts, groups, snippets, port forwards, and settings
/// to a JSON file. Keys are exported as metadata only (public key)
/// — private keys are NOT exported for security.
///
/// Encrypted export (version 2) includes private keys, passphrases,
/// and host passwords, all wrapped in AES-256-GCM with an
/// Argon2id-derived key from a user-chosen export password.
///
/// Import merges data into the existing database, creating new
/// records for items that don't already exist (matched by ID).
library;

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:logger/logger.dart';

import '../../data/database/app_database.dart';
import '../../data/database/tables/hosts_table.dart';
import '../../data/database/tables/keys_table.dart';
import '../../data/database/tables/port_forwards_table.dart';
import '../crypto/secure_storage.dart';
import '../crypto/vault_crypto_service.dart';

/// Export file format version (plaintext).
const _exportVersion = 1;

/// Export file format version (encrypted).
const _encryptedExportVersion = 2;

/// Service for exporting and importing CloudShell data.
class DataExportService {
  DataExportService(this._db, {this.secureStorage, this.vaultCrypto});

  static final _log = Logger();

  final AppDatabase _db;
  final SecureStorageService? secureStorage;
  final VaultCryptoService? vaultCrypto;

  /// Exports all app data to a JSON file.
  ///
  /// Returns the path to the created export file.
  /// Private keys are NOT included for security.
  Future<String> exportData() async {
    final hosts = await (_db.select(_db.hosts)
          ..where((h) => h.isDeleted.equals(false)))
        .get();
    final groups = await (_db.select(_db.hostGroups)
          ..where((g) => g.isDeleted.equals(false)))
        .get();
    final snippets = await (_db.select(_db.snippets)
          ..where((s) => s.isDeleted.equals(false)))
        .get();
    final portForwards = await (_db.select(_db.portForwards)
          ..where((pf) => pf.isDeleted.equals(false)))
        .get();
    final keys = await (_db.select(_db.sshKeys)
          ..where((k) => k.isDeleted.equals(false)))
        .get();
    final settings = await _db.select(_db.settings).get();

    final export = {
      'version': _exportVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'app': 'CloudShell',
      'hosts': hosts.map(_hostToJson).toList(),
      'groups': groups.map(_groupToJson).toList(),
      'snippets': snippets.map(_snippetToJson).toList(),
      'portForwards': portForwards.map(_portForwardToJson).toList(),
      'keys': keys.map(_keyToJson).toList(),
      'settings': settings
          .where((s) => !s.key.startsWith('vault_'))
          .map((s) => {'key': s.key, 'value': s.value})
          .toList(),
    };

    final json = const JsonEncoder.withIndent('  ').convert(export);

    final dir = await _exportDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final file = File(p.join(dir.path, 'cloudshell_export_$timestamp.json'));
    await file.writeAsString(json);

    return file.path;
  }

  /// Imports data from a JSON export file.
  ///
  /// Merges into existing database — existing records (matched by ID)
  /// are updated, new records are inserted. Returns a summary.
  Future<ImportResult> importData(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return const ImportResult(error: 'File not found');
    }

    final content = await file.readAsString();
    final Map<String, dynamic> data;
    try {
      data = jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      return ImportResult(error: 'Invalid JSON format: $e');
    }

    final version = data['version'] as int?;
    if (version == null || version > _exportVersion) {
      return ImportResult(error: 'Unsupported export version: $version');
    }

    final groupsImported = await _importGroupList(data['groups'] as List<dynamic>? ?? []);
    final hostsImported = await _importHostList(data['hosts'] as List<dynamic>? ?? []);
    final snippetsImported = await _importSnippetList(data['snippets'] as List<dynamic>? ?? []);
    final portForwardsImported = await _importPortForwardList(data['portForwards'] as List<dynamic>? ?? []);
    final keysImported = await _importKeyList(data['keys'] as List<dynamic>? ?? []);
    final settingsImported = await _importSettingList(data['settings'] as List<dynamic>? ?? []);

    return ImportResult(
      hostsImported: hostsImported,
      groupsImported: groupsImported,
      snippetsImported: snippetsImported,
      portForwardsImported: portForwardsImported,
      keysImported: keysImported,
      settingsImported: settingsImported,
    );
  }

  // ---------------------------------------------------------------------------
  // Encrypted export/import
  // ---------------------------------------------------------------------------

  /// Exports all data including secrets to an encrypted file.
  ///
  /// Private keys, passphrases, and host passwords are included.
  /// The entire payload is encrypted with AES-256-GCM using a key
  /// derived from [password] via Argon2id.
  ///
  /// Returns the path to the created encrypted export file.
  Future<String> exportEncryptedVault(String password) async {
    final crypto = vaultCrypto;
    final storage = secureStorage;
    if (crypto == null || storage == null) {
      throw StateError('Encrypted export requires crypto and storage services');
    }

    // Gather all database data
    final hosts = await (_db.select(_db.hosts)
          ..where((h) => h.isDeleted.equals(false)))
        .get();
    final groups = await (_db.select(_db.hostGroups)
          ..where((g) => g.isDeleted.equals(false)))
        .get();
    final snippets = await (_db.select(_db.snippets)
          ..where((s) => s.isDeleted.equals(false)))
        .get();
    final portForwards = await (_db.select(_db.portForwards)
          ..where((pf) => pf.isDeleted.equals(false)))
        .get();
    final keys = await (_db.select(_db.sshKeys)
          ..where((k) => k.isDeleted.equals(false)))
        .get();
    final settings = await _db.select(_db.settings).get();

    // Gather secrets: private keys, passphrases, host passwords
    final secretsMap = <String, String>{};
    for (final key in keys) {
      final privateKey = await storage.getSshPrivateKey(key.id);
      if (privateKey != null) {
        secretsMap['ssh_key_${key.id}'] = privateKey;
      }
      final passphrase = await storage.getSshPassphrase(key.id);
      if (passphrase != null) {
        secretsMap['ssh_passphrase_${key.id}'] = passphrase;
      }
    }
    for (final host in hosts) {
      final password_ = await storage.getHostPassword(host.id);
      if (password_ != null) {
        secretsMap['host_password_${host.id}'] = password_;
      }
    }

    final plaintext = {
      'version': _encryptedExportVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'app': 'CloudShell',
      'hosts': hosts.map(_hostToJson).toList(),
      'groups': groups.map(_groupToJson).toList(),
      'snippets': snippets.map(_snippetToJson).toList(),
      'portForwards': portForwards.map(_portForwardToJson).toList(),
      'keys': keys.map(_keyToJson).toList(),
      'settings': settings
          .where((s) => !s.key.startsWith('vault_'))
          .map((s) => {'key': s.key, 'value': s.value})
          .toList(),
      'secrets': secretsMap,
    };

    final plaintextJson = jsonEncode(plaintext);

    // Derive encryption key from export password
    final salt = await crypto.generateSalt();
    final vaultKeys = await crypto.deriveKeys(password, salt);

    try {
      // Encrypt the payload
      final encrypted =
          await crypto.encryptItem(plaintextJson, vaultKeys.encKey, vaultKeys.macKey);

      // Wrap in outer container
      final envelope = {
        'version': _encryptedExportVersion,
        'format': 'encrypted',
        'kdfSalt': base64Encode(salt),
        'kdfParams': {
          'memory': VaultCryptoService.argon2Memory,
          'iterations': VaultCryptoService.argon2Iterations,
          'parallelism': VaultCryptoService.argon2Parallelism,
        },
        'encryptedData': encrypted.toMap(),
      };

      final json = const JsonEncoder.withIndent('  ').convert(envelope);

      final dir = await _exportDirectory();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final file =
          File(p.join(dir.path, 'cloudshell_vault_$timestamp.json'));
      await file.writeAsString(json);

      return file.path;
    } finally {
      vaultKeys.destroy();
    }
  }

  /// Imports data from an encrypted vault export file.
  ///
  /// Decrypts the payload using [password], then merges all data
  /// including private keys, passphrases, and host passwords.
  Future<ImportResult> importEncryptedVault(
      String filePath, String password) async {
    final crypto = vaultCrypto;
    final storage = secureStorage;
    if (crypto == null || storage == null) {
      return const ImportResult(
          error: 'Encrypted import requires crypto and storage services');
    }

    final file = File(filePath);
    if (!await file.exists()) {
      return const ImportResult(error: 'File not found');
    }

    final content = await file.readAsString();
    final Map<String, dynamic> envelope;
    try {
      envelope = jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      return ImportResult(error: 'Invalid file format: $e');
    }

    if (envelope['format'] != 'encrypted') {
      return const ImportResult(error: 'File is not an encrypted export');
    }

    final version = envelope['version'] as int?;
    if (version == null || version > _encryptedExportVersion) {
      return ImportResult(error: 'Unsupported export version: $version');
    }

    // Derive decryption key
    final saltBase64 = envelope['kdfSalt'] as String?;
    if (saltBase64 == null) {
      return const ImportResult(error: 'Missing encryption parameters');
    }
    final salt = Uint8List.fromList(base64Decode(saltBase64));

    final vaultKeys = await crypto.deriveKeys(password, salt);

    try {
      // Decrypt
      final encryptedMap =
          envelope['encryptedData'] as Map<String, dynamic>?;
      if (encryptedMap == null) {
        return const ImportResult(error: 'Missing encrypted data');
      }

      final encrypted = EncryptedItem.fromMap(encryptedMap);
      final String plaintextJson;
      try {
        plaintextJson = await crypto.decryptItem(
            encrypted, vaultKeys.encKey, vaultKeys.macKey);
      } catch (e, stackTrace) {
        _log.w('Encrypted vault decryption failed', error: e, stackTrace: stackTrace);
        return const ImportResult(
            error: 'Wrong password or corrupted file');
      }

      final data = jsonDecode(plaintextJson) as Map<String, dynamic>;

      // Import database records using shared helpers
      final groupsImported = await _importGroupList(data['groups'] as List<dynamic>? ?? []);
      final hostsImported = await _importHostList(data['hosts'] as List<dynamic>? ?? []);
      final snippetsImported = await _importSnippetList(data['snippets'] as List<dynamic>? ?? []);
      final portForwardsImported = await _importPortForwardList(data['portForwards'] as List<dynamic>? ?? []);
      final keysImported = await _importKeyList(data['keys'] as List<dynamic>? ?? []);
      final settingsImported = await _importSettingList(data['settings'] as List<dynamic>? ?? []);
      var secretsImported = 0;

      // Import secrets (private keys, passphrases, host passwords)
      final secretsMap =
          data['secrets'] as Map<String, dynamic>? ?? {};
      for (final entry in secretsMap.entries) {
        try {
          final key = entry.key;
          final value = entry.value as String;
          if (key.startsWith('ssh_key_')) {
            final keyId = key.substring('ssh_key_'.length);
            await storage.storeSshPrivateKey(keyId, value);
            secretsImported++;
          } else if (key.startsWith('ssh_passphrase_')) {
            final keyId = key.substring('ssh_passphrase_'.length);
            await storage.storeSshPassphrase(keyId, value);
            secretsImported++;
          } else if (key.startsWith('host_password_')) {
            final hostId = key.substring('host_password_'.length);
            await storage.storeHostPassword(hostId, value);
            secretsImported++;
          }
        } catch (e, stackTrace) {
          _log.d('Import secret skipped', error: e, stackTrace: stackTrace);
        }
      }

      return ImportResult(
        hostsImported: hostsImported,
        groupsImported: groupsImported,
        snippetsImported: snippetsImported,
        portForwardsImported: portForwardsImported,
        keysImported: keysImported,
        settingsImported: settingsImported,
        secretsImported: secretsImported,
      );
    } finally {
      vaultKeys.destroy();
    }
  }

  /// Checks if a file is an encrypted CloudShell export.
  static bool isEncryptedExport(String content) {
    try {
      final data = jsonDecode(content) as Map<String, dynamic>;
      return data['format'] == 'encrypted';
    } catch (e, stackTrace) {
      _log.d('Failed to parse export content for format check', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Returns all export files, sorted newest first.
  static Future<List<File>> listExports() async {
    final dir = await _exportDirectory();
    if (!dir.existsSync()) return [];

    return dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .toList()
      ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
  }

  // ---------------------------------------------------------------------------
  // Shared import helpers
  // ---------------------------------------------------------------------------

  Future<int> _importGroupList(List<dynamic> groups) async {
    var count = 0;
    for (final g in groups) {
      final map = g as Map<String, dynamic>;
      try {
        await _db.into(_db.hostGroups).insertOnConflictUpdate(
              HostGroupsCompanion(
                id: Value(map['id'] as String),
                name: Value(map['name'] as String),
                defaultUsername: Value(map['defaultUsername'] as String?),
                defaultPort: Value(map['defaultPort'] as int?),
                sortOrder: Value(map['sortOrder'] as int? ?? 0),
                createdAt: Value(DateTime.parse(map['createdAt'] as String)),
                updatedAt: Value(DateTime.parse(map['updatedAt'] as String)),
              ),
            );
        count++;
      } catch (e, stackTrace) {
        _log.d('Import group skipped', error: e, stackTrace: stackTrace);
      }
    }
    return count;
  }

  Future<int> _importHostList(List<dynamic> hosts) async {
    var count = 0;
    for (final h in hosts) {
      final map = h as Map<String, dynamic>;
      try {
        await _db.into(_db.hosts).insertOnConflictUpdate(
              HostsCompanion(
                id: Value(map['id'] as String),
                label: Value(map['label'] as String),
                hostname: Value(map['hostname'] as String),
                port: Value(map['port'] as int? ?? 22),
                username: Value(map['username'] as String),
                authMethod: Value(
                    AuthMethodType.values[map['authMethod'] as int? ?? 0]),
                keyId: Value(map['keyId'] as String?),
                groupId: Value(map['groupId'] as String?),
                tags: Value(map['tags'] as String? ?? ''),
                startupCommand: Value(map['startupCommand'] as String?),
                keepAliveSeconds:
                    Value(map['keepAliveSeconds'] as int? ?? 60),
                jumpHostId: Value(map['jumpHostId'] as String?),
                encoding: Value(map['encoding'] as String?),
                notes: Value(map['notes'] as String?),
                sortOrder: Value(map['sortOrder'] as int? ?? 0),
                isFavorite: Value(map['isFavorite'] as bool? ?? false),
                createdAt:
                    Value(DateTime.parse(map['createdAt'] as String)),
                updatedAt:
                    Value(DateTime.parse(map['updatedAt'] as String)),
              ),
            );
        count++;
      } catch (e, stackTrace) {
        _log.d('Import host skipped', error: e, stackTrace: stackTrace);
      }
    }
    return count;
  }

  Future<int> _importSnippetList(List<dynamic> snippets) async {
    var count = 0;
    for (final s in snippets) {
      final map = s as Map<String, dynamic>;
      try {
        await _db.into(_db.snippets).insertOnConflictUpdate(
              SnippetsCompanion(
                id: Value(map['id'] as String),
                name: Value(map['name'] as String),
                command: Value(map['command'] as String),
                category: Value(map['category'] as String?),
                variables: Value(map['variables'] as String? ?? '[]'),
                description: Value(map['description'] as String?),
                createdAt:
                    Value(DateTime.parse(map['createdAt'] as String)),
                updatedAt:
                    Value(DateTime.parse(map['updatedAt'] as String)),
              ),
            );
        count++;
      } catch (e, stackTrace) {
        _log.d('Import snippet skipped', error: e, stackTrace: stackTrace);
      }
    }
    return count;
  }

  Future<int> _importPortForwardList(List<dynamic> portForwards) async {
    var count = 0;
    for (final pf in portForwards) {
      final map = pf as Map<String, dynamic>;
      try {
        await _db.into(_db.portForwards).insertOnConflictUpdate(
              PortForwardsCompanion(
                id: Value(map['id'] as String),
                label: Value(map['label'] as String),
                type: Value(PortForwardTypeEnum
                    .values[map['type'] as int? ?? 0]),
                hostId: Value(map['hostId'] as String),
                sourcePort: Value(map['sourcePort'] as int),
                destinationHost:
                    Value(map['destinationHost'] as String?),
                destinationPort:
                    Value(map['destinationPort'] as int?),
                autoStart:
                    Value(map['autoStart'] as bool? ?? false),
                createdAt:
                    Value(DateTime.parse(map['createdAt'] as String)),
                updatedAt:
                    Value(DateTime.parse(map['updatedAt'] as String)),
              ),
            );
        count++;
      } catch (e, stackTrace) {
        _log.d('Import port forward skipped', error: e, stackTrace: stackTrace);
      }
    }
    return count;
  }

  Future<int> _importKeyList(List<dynamic> keys) async {
    var count = 0;
    for (final k in keys) {
      final map = k as Map<String, dynamic>;
      try {
        final existing = await _db.keyDao.getKeyById(map['id'] as String);
        if (existing == null) {
          await _db.into(_db.sshKeys).insert(
                SshKeysCompanion(
                  id: Value(map['id'] as String),
                  label: Value(map['label'] as String),
                  keyType: Value(
                      KeyTypeEnum.values[map['keyType'] as int? ?? 0]),
                  keyBits: Value(map['keyBits'] as int?),
                  publicKey: Value(map['publicKey'] as String? ?? ''),
                  privateKeyRef:
                      Value(map['privateKeyRef'] as String? ?? ''),
                  fingerprint:
                      Value(map['fingerprint'] as String? ?? ''),
                  hasPassphrase:
                      Value(map['hasPassphrase'] as bool? ?? false),
                  createdAt:
                      Value(DateTime.parse(map['createdAt'] as String)),
                  updatedAt:
                      Value(DateTime.parse(map['updatedAt'] as String)),
                ),
              );
          count++;
        }
      } catch (e, stackTrace) {
        _log.d('Import key skipped', error: e, stackTrace: stackTrace);
      }
    }
    return count;
  }

  Future<int> _importSettingList(List<dynamic> settingsList) async {
    var count = 0;
    for (final s in settingsList) {
      final map = s as Map<String, dynamic>;
      final key = map['key'] as String?;
      final value = map['value'] as String?;
      if (key != null && value != null && !key.startsWith('vault_')) {
        await _db.settingsDao.setValue(key, value);
        count++;
      }
    }
    return count;
  }

  // ---------------------------------------------------------------------------
  // JSON serialization
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _hostToJson(Host host) => {
        'id': host.id,
        'label': host.label,
        'hostname': host.hostname,
        'port': host.port,
        'username': host.username,
        'authMethod': host.authMethod.index,
        'keyId': host.keyId,
        'groupId': host.groupId,
        'tags': host.tags,
        'startupCommand': host.startupCommand,
        'keepAliveSeconds': host.keepAliveSeconds,
        'jumpHostId': host.jumpHostId,
        'encoding': host.encoding,
        'notes': host.notes,
        'sortOrder': host.sortOrder,
        'isFavorite': host.isFavorite,
        'lastConnectedAt': host.lastConnectedAt?.toIso8601String(),
        'createdAt': host.createdAt.toIso8601String(),
        'updatedAt': host.updatedAt.toIso8601String(),
      };

  Map<String, dynamic> _groupToJson(HostGroup group) => {
        'id': group.id,
        'name': group.name,
        'defaultUsername': group.defaultUsername,
        'defaultPort': group.defaultPort,
        'sortOrder': group.sortOrder,
        'createdAt': group.createdAt.toIso8601String(),
        'updatedAt': group.updatedAt.toIso8601String(),
      };

  Map<String, dynamic> _snippetToJson(Snippet snippet) => {
        'id': snippet.id,
        'name': snippet.name,
        'command': snippet.command,
        'category': snippet.category,
        'variables': snippet.variables,
        'description': snippet.description,
        'createdAt': snippet.createdAt.toIso8601String(),
        'updatedAt': snippet.updatedAt.toIso8601String(),
      };

  Map<String, dynamic> _portForwardToJson(PortForward pf) => {
        'id': pf.id,
        'label': pf.label,
        'type': pf.type.index,
        'hostId': pf.hostId,
        'sourcePort': pf.sourcePort,
        'destinationHost': pf.destinationHost,
        'destinationPort': pf.destinationPort,
        'autoStart': pf.autoStart,
        'createdAt': pf.createdAt.toIso8601String(),
        'updatedAt': pf.updatedAt.toIso8601String(),
      };

  Map<String, dynamic> _keyToJson(SshKey key) => {
        'id': key.id,
        'label': key.label,
        'keyType': key.keyType.index,
        'keyBits': key.keyBits,
        'publicKey': key.publicKey,
        'privateKeyRef': key.privateKeyRef,
        'fingerprint': key.fingerprint,
        'hasPassphrase': key.hasPassphrase,
        'createdAt': key.createdAt.toIso8601String(),
        'updatedAt': key.updatedAt.toIso8601String(),
      };

  static Future<Directory> _exportDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docsDir.path, 'CloudShell', 'exports'));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}

/// Result of an import operation.
class ImportResult {
  const ImportResult({
    this.hostsImported = 0,
    this.groupsImported = 0,
    this.snippetsImported = 0,
    this.portForwardsImported = 0,
    this.keysImported = 0,
    this.settingsImported = 0,
    this.secretsImported = 0,
    this.error,
  });

  final int hostsImported;
  final int groupsImported;
  final int snippetsImported;
  final int portForwardsImported;
  final int keysImported;
  final int settingsImported;
  final int secretsImported;
  final String? error;

  bool get hasError => error != null;

  int get totalImported =>
      hostsImported +
      groupsImported +
      snippetsImported +
      portForwardsImported +
      keysImported +
      settingsImported +
      secretsImported;

  String get summary {
    if (hasError) return 'Import failed: $error';
    final parts = <String>[];
    if (hostsImported > 0) parts.add('$hostsImported hosts');
    if (groupsImported > 0) parts.add('$groupsImported groups');
    if (snippetsImported > 0) parts.add('$snippetsImported snippets');
    if (portForwardsImported > 0) parts.add('$portForwardsImported forwards');
    if (keysImported > 0) parts.add('$keysImported keys');
    if (settingsImported > 0) parts.add('$settingsImported settings');
    if (secretsImported > 0) parts.add('$secretsImported secrets');
    if (parts.isEmpty) return 'No new data to import';
    return 'Imported: ${parts.join(', ')}';
  }
}
