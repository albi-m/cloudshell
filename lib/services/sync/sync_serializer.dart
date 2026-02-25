/// Serialization/deserialization for sync payloads.
///
/// Converts Drift data objects to/from JSON maps for encryption
/// and sync. The JSON is encrypted by VaultCryptoService before
/// being sent to the backend.
library;

import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../../data/database/tables/hosts_table.dart';
import '../../data/database/tables/keys_table.dart';
import '../../data/database/tables/port_forwards_table.dart';

/// Serializes and deserializes sync payloads for all entity types.
class SyncSerializer {
  // ---------------------------------------------------------------------------
  // Hosts
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> hostToJson(Host host) {
    return {
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
      'syncVersion': host.syncVersion,
      'isDeleted': host.isDeleted,
    };
  }

  static HostsCompanion hostFromJson(Map<String, dynamic> json) {
    return HostsCompanion(
      id: Value(json['id'] as String),
      label: Value(json['label'] as String),
      hostname: Value(json['hostname'] as String),
      port: Value(json['port'] as int? ?? 22),
      username: Value(json['username'] as String),
      authMethod: Value(AuthMethodType.values[json['authMethod'] as int? ?? 0]),
      keyId: Value(json['keyId'] as String?),
      groupId: Value(json['groupId'] as String?),
      tags: Value(json['tags'] as String? ?? ''),
      startupCommand: Value(json['startupCommand'] as String?),
      keepAliveSeconds: Value(json['keepAliveSeconds'] as int? ?? 60),
      jumpHostId: Value(json['jumpHostId'] as String?),
      encoding: Value(json['encoding'] as String?),
      notes: Value(json['notes'] as String?),
      sortOrder: Value(json['sortOrder'] as int? ?? 0),
      isFavorite: Value(json['isFavorite'] as bool? ?? false),
      lastConnectedAt: Value(_parseDateTime(json['lastConnectedAt'])),
      createdAt: Value(_parseDateTime(json['createdAt']) ?? DateTime.now()),
      updatedAt: Value(_parseDateTime(json['updatedAt']) ?? DateTime.now()),
      syncVersion: Value(json['syncVersion'] as int? ?? 0),
      isDeleted: Value(json['isDeleted'] as bool? ?? false),
    );
  }

  // ---------------------------------------------------------------------------
  // SSH Keys
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> keyToJson(SshKey key) {
    return {
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
      'syncVersion': key.syncVersion,
      'isDeleted': key.isDeleted,
    };
  }

  static SshKeysCompanion keyFromJson(Map<String, dynamic> json) {
    return SshKeysCompanion(
      id: Value(json['id'] as String),
      label: Value(json['label'] as String),
      keyType: Value(KeyTypeEnum.values[json['keyType'] as int? ?? 0]),
      keyBits: Value(json['keyBits'] as int?),
      publicKey: Value(json['publicKey'] as String),
      privateKeyRef: Value(json['privateKeyRef'] as String),
      fingerprint: Value(json['fingerprint'] as String),
      hasPassphrase: Value(json['hasPassphrase'] as bool? ?? false),
      createdAt: Value(_parseDateTime(json['createdAt']) ?? DateTime.now()),
      updatedAt: Value(_parseDateTime(json['updatedAt']) ?? DateTime.now()),
      syncVersion: Value(json['syncVersion'] as int? ?? 0),
      isDeleted: Value(json['isDeleted'] as bool? ?? false),
    );
  }

  // ---------------------------------------------------------------------------
  // Groups
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> groupToJson(HostGroup group) {
    return {
      'id': group.id,
      'name': group.name,
      'parentGroupId': group.parentGroupId,
      'defaultUsername': group.defaultUsername,
      'defaultPort': group.defaultPort,
      'defaultKeyId': group.defaultKeyId,
      'sortOrder': group.sortOrder,
      'createdAt': group.createdAt.toIso8601String(),
      'updatedAt': group.updatedAt.toIso8601String(),
      'syncVersion': group.syncVersion,
      'isDeleted': group.isDeleted,
    };
  }

  static HostGroupsCompanion groupFromJson(Map<String, dynamic> json) {
    return HostGroupsCompanion(
      id: Value(json['id'] as String),
      name: Value(json['name'] as String),
      parentGroupId: Value(json['parentGroupId'] as String?),
      defaultUsername: Value(json['defaultUsername'] as String?),
      defaultPort: Value(json['defaultPort'] as int?),
      defaultKeyId: Value(json['defaultKeyId'] as String?),
      sortOrder: Value(json['sortOrder'] as int? ?? 0),
      createdAt: Value(_parseDateTime(json['createdAt']) ?? DateTime.now()),
      updatedAt: Value(_parseDateTime(json['updatedAt']) ?? DateTime.now()),
      syncVersion: Value(json['syncVersion'] as int? ?? 0),
      isDeleted: Value(json['isDeleted'] as bool? ?? false),
    );
  }

  // ---------------------------------------------------------------------------
  // Snippets
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> snippetToJson(Snippet snippet) {
    return {
      'id': snippet.id,
      'name': snippet.name,
      'command': snippet.command,
      'category': snippet.category,
      'variables': snippet.variables,
      'description': snippet.description,
      'createdAt': snippet.createdAt.toIso8601String(),
      'updatedAt': snippet.updatedAt.toIso8601String(),
      'syncVersion': snippet.syncVersion,
      'isDeleted': snippet.isDeleted,
    };
  }

  static SnippetsCompanion snippetFromJson(Map<String, dynamic> json) {
    return SnippetsCompanion(
      id: Value(json['id'] as String),
      name: Value(json['name'] as String),
      command: Value(json['command'] as String),
      category: Value(json['category'] as String?),
      variables: Value(json['variables'] as String? ?? '[]'),
      description: Value(json['description'] as String?),
      createdAt: Value(_parseDateTime(json['createdAt']) ?? DateTime.now()),
      updatedAt: Value(_parseDateTime(json['updatedAt']) ?? DateTime.now()),
      syncVersion: Value(json['syncVersion'] as int? ?? 0),
      isDeleted: Value(json['isDeleted'] as bool? ?? false),
    );
  }

  // ---------------------------------------------------------------------------
  // Port Forwards
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> portForwardToJson(PortForward pf) {
    return {
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
      'syncVersion': pf.syncVersion,
      'isDeleted': pf.isDeleted,
    };
  }

  static PortForwardsCompanion portForwardFromJson(Map<String, dynamic> json) {
    return PortForwardsCompanion(
      id: Value(json['id'] as String),
      label: Value(json['label'] as String),
      type: Value(PortForwardTypeEnum.values[json['type'] as int? ?? 0]),
      hostId: Value(json['hostId'] as String),
      sourcePort: Value(json['sourcePort'] as int),
      destinationHost: Value(json['destinationHost'] as String?),
      destinationPort: Value(json['destinationPort'] as int?),
      autoStart: Value(json['autoStart'] as bool? ?? false),
      createdAt: Value(_parseDateTime(json['createdAt']) ?? DateTime.now()),
      updatedAt: Value(_parseDateTime(json['updatedAt']) ?? DateTime.now()),
      syncVersion: Value(json['syncVersion'] as int? ?? 0),
      isDeleted: Value(json['isDeleted'] as bool? ?? false),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Encodes a JSON map to a base64 string (for encryption input).
  static String encodePayload(Map<String, dynamic> json) {
    return base64Encode(utf8.encode(jsonEncode(json)));
  }

  /// Decodes a base64 string back to a JSON map.
  static Map<String, dynamic> decodePayload(String encoded) {
    return jsonDecode(utf8.decode(base64Decode(encoded)))
        as Map<String, dynamic>;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value as String);
  }
}
