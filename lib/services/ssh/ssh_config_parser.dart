/// SSH config file parser for CloudShell.
///
/// Parses `~/.ssh/config` files to extract host definitions
/// and their connection parameters. Supports the most common
/// SSH config directives used in practice.
library;

import 'dart:io';

import 'package:logger/logger.dart';

/// A parsed SSH config host entry.
class SshConfigEntry {
  SshConfigEntry({
    required this.alias,
    this.hostname,
    this.user,
    this.port,
    this.identityFile,
    this.proxyJump,
    this.keepAliveInterval,
    this.localForwards = const [],
    this.remoteForwards = const [],
  });

  /// The Host alias (pattern name from config).
  final String alias;

  /// HostName (actual hostname or IP).
  String? hostname;

  /// User for authentication.
  String? user;

  /// Port number.
  int? port;

  /// Path to the identity file (private key).
  String? identityFile;

  /// ProxyJump host alias or hostname.
  String? proxyJump;

  /// ServerAliveInterval in seconds.
  int? keepAliveInterval;

  /// Local port forwards (e.g., "8080:localhost:80").
  List<String> localForwards;

  /// Remote port forwards.
  List<String> remoteForwards;

  /// Returns the effective hostname (alias if HostName not set).
  String get effectiveHostname => hostname ?? alias;

  /// Returns the effective port (22 if not set).
  int get effectivePort => port ?? 22;

  /// Returns the effective user ("root" if not set).
  String get effectiveUser => user ?? 'root';
}

/// Parses SSH config files into structured host entries.
class SshConfigParser {
  static final _log = Logger();

  /// Parses the default SSH config file at `~/.ssh/config`.
  static Future<List<SshConfigEntry>> parseDefault() async {
    final home = Platform.environment['HOME'] ?? '/root';
    final configFile = File('$home/.ssh/config');

    if (!await configFile.exists()) {
      return [];
    }

    final content = await configFile.readAsString();
    return parse(content);
  }

  /// Parses SSH config content string into host entries.
  static List<SshConfigEntry> parse(String content) {
    final entries = <SshConfigEntry>[];
    SshConfigEntry? current;

    for (var line in content.split('\n')) {
      // Strip comments
      final commentIndex = line.indexOf('#');
      if (commentIndex >= 0) {
        line = line.substring(0, commentIndex);
      }

      line = line.trim();
      if (line.isEmpty) continue;

      // Split on first whitespace or '='
      final match = RegExp(r'^(\S+)\s*[=\s]\s*(.+)$').firstMatch(line);
      if (match == null) continue;

      final keyword = match.group(1)!.toLowerCase();
      final value = match.group(2)!.trim();

      if (keyword == 'host') {
        // Skip wildcard-only entries
        if (value == '*' || value.contains('*') || value.contains('?')) {
          current = null;
          continue;
        }

        // Multiple hosts on one line — create entry for first one
        final aliases = value.split(RegExp(r'\s+'));
        current = SshConfigEntry(alias: aliases.first);
        entries.add(current);
        continue;
      }

      if (current == null) continue;

      switch (keyword) {
        case 'hostname':
          current.hostname = value;
        case 'user':
          current.user = value;
        case 'port':
          current.port = int.tryParse(value);
        case 'identityfile':
          // Expand ~ to home directory
          current.identityFile = _expandPath(value);
        case 'proxyjump':
          current.proxyJump = value;
        case 'serveraliveinterval':
          current.keepAliveInterval = int.tryParse(value);
        case 'localforward':
          current.localForwards = [...current.localForwards, value];
        case 'remoteforward':
          current.remoteForwards = [...current.remoteForwards, value];
      }
    }

    return entries;
  }

  /// Expands ~ to the user's home directory.
  static String _expandPath(String path) {
    if (path.startsWith('~/')) {
      final home = Platform.environment['HOME'] ?? '/root';
      return '$home${path.substring(1)}';
    }
    return path;
  }

  /// Checks if the default SSH config file exists.
  static Future<bool> configExists() async {
    final home = Platform.environment['HOME'] ?? '/root';
    final configFile = File('$home/.ssh/config');
    return configFile.exists();
  }

  /// Tries to read the identity file and return its content.
  /// Returns null if the file doesn't exist or can't be read.
  static Future<String?> readIdentityFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e, stackTrace) {
      _log.d('Failed to read identity file: $path', error: e, stackTrace: stackTrace);
    }
    return null;
  }
}
