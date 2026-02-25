/// Terminal session logging service.
///
/// Captures terminal output to a file with timestamps.
/// Each session gets its own log file named with the host label
/// and timestamp. Logs are stored in the app's documents directory.
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Manages log files for terminal sessions.
class SessionLogger {
  SessionLogger._({
    required this.file,
    required this.sink,
    required this.sessionLabel,
    required this.startedAt,
    this.includeTimestamps = true,
  });

  /// The log file being written to.
  final File file;

  /// File sink for writing output.
  final IOSink sink;

  /// Session label (host name).
  final String sessionLabel;

  /// When logging started.
  final DateTime startedAt;

  /// Whether to prefix each line with a timestamp.
  final bool includeTimestamps;

  bool _isClosed = false;

  /// Creates a new session logger.
  ///
  /// Creates a log file in `<documents>/CloudShell/logs/` with
  /// a name derived from the host label and current timestamp.
  static Future<SessionLogger> create({
    required String sessionLabel,
    bool includeTimestamps = true,
  }) async {
    final dir = await _logDirectory();
    final safeName =
        sessionLabel.replaceAll(RegExp(r'[^\w\-.]'), '_').toLowerCase();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final fileName = '${safeName}_$timestamp.log';
    final file = File(p.join(dir.path, fileName));

    final sink = file.openWrite(mode: FileMode.append);

    // Write header
    sink.writeln('=== CloudShell Session Log ===');
    sink.writeln('Host: $sessionLabel');
    sink.writeln('Started: ${DateTime.now().toIso8601String()}');
    sink.writeln('=' * 40);
    sink.writeln();

    return SessionLogger._(
      file: file,
      sink: sink,
      sessionLabel: sessionLabel,
      startedAt: DateTime.now(),
      includeTimestamps: includeTimestamps,
    );
  }

  /// Writes terminal output to the log file.
  ///
  /// Strips ANSI escape sequences for clean log output.
  void write(String data) {
    if (_isClosed) return;

    final cleaned = _stripAnsi(data);
    if (cleaned.isEmpty) return;

    if (includeTimestamps) {
      final now = DateTime.now();
      final ts =
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:'
          '${now.second.toString().padLeft(2, '0')}';
      // Only add timestamps at line boundaries
      final lines = cleaned.split('\n');
      for (final line in lines) {
        if (line.trim().isNotEmpty) {
          sink.write('[$ts] $line\n');
        } else if (line.contains('\n')) {
          sink.write('\n');
        }
      }
    } else {
      sink.write(cleaned);
    }
  }

  /// Closes the log file.
  Future<void> close() async {
    if (_isClosed) return;
    _isClosed = true;

    sink.writeln();
    sink.writeln('=' * 40);
    sink.writeln('Session ended: ${DateTime.now().toIso8601String()}');
    final duration = DateTime.now().difference(startedAt);
    sink.writeln('Duration: ${_formatDuration(duration)}');
    await sink.flush();
    await sink.close();
  }

  /// Returns the path to the log file.
  String get filePath => file.path;

  /// Returns true if the logger is still active.
  bool get isActive => !_isClosed;

  /// Returns all log files, sorted by modification time (newest first).
  static Future<List<File>> listLogs() async {
    final dir = await _logDirectory();
    if (!dir.existsSync()) return [];

    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.log'))
        .toList()
      ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return files;
  }

  /// Deletes a specific log file.
  static Future<void> deleteLog(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Deletes all log files.
  static Future<void> deleteAllLogs() async {
    final dir = await _logDirectory();
    if (dir.existsSync()) {
      for (final entity in dir.listSync()) {
        if (entity is File && entity.path.endsWith('.log')) {
          await entity.delete();
        }
      }
    }
  }

  /// Returns the total size of all log files in bytes.
  static Future<int> totalLogSize() async {
    final files = await listLogs();
    var total = 0;
    for (final file in files) {
      total += await file.length();
    }
    return total;
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  static Future<Directory> _logDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final logDir = Directory(p.join(docsDir.path, 'CloudShell', 'logs'));
    if (!logDir.existsSync()) {
      await logDir.create(recursive: true);
    }
    return logDir;
  }

  /// Strips ANSI escape sequences from terminal output.
  static String _stripAnsi(String text) {
    return text.replaceAll(
      RegExp(r'\x1B\[[0-9;]*[A-Za-z]|\x1B\][^\x07]*\x07|\x1B[()][AB012]'),
      '',
    );
  }

  static String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (hours > 0) return '${hours}h ${minutes}m ${seconds}s';
    if (minutes > 0) return '${minutes}m ${seconds}s';
    return '${seconds}s';
  }
}
