/// SFTP file operations service for CloudShell.
///
/// Wraps dartssh2's SftpClient to provide directory listing,
/// file upload/download with progress tracking, and basic
/// file management operations. Reuses existing SSH sessions.
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

import '../../core/errors/app_exception.dart';
import '../ssh/ssh_session.dart';

/// Represents a file or directory entry from the SFTP server.
class SftpEntry {
  const SftpEntry({
    required this.name,
    required this.path,
    required this.isDirectory,
    this.size,
    this.modifiedAt,
    this.permissions,
    this.userCanWrite = true,
    this.userCanRead = true,
  });

  final String name;
  final String path;
  final bool isDirectory;
  final int? size;
  final DateTime? modifiedAt;
  final String? permissions;

  /// Whether the current user has write permission on this entry.
  final bool userCanWrite;

  /// Whether the current user has read permission on this entry.
  final bool userCanRead;

  bool get isParentDir => name == '..';
  bool get isCurrentDir => name == '.';
  bool get isHidden => name.startsWith('.') && !isParentDir && !isCurrentDir;
}

/// Progress callback for file transfers.
typedef TransferProgress = void Function(int bytesTransferred, int totalBytes);

/// SFTP file operations service.
///
/// Opens an SFTP subsession from an existing SSH connection
/// and provides high-level file management operations.
class SftpService {
  SftpService(this._session);

  static final _log = Logger();

  final SshSessionWrapper _session;
  SftpClient? _sftp;

  /// Whether an SFTP session is currently active.
  bool get isConnected => _sftp != null && _session.isConnected;

  /// Opens the SFTP subsession. Must be called before any operations.
  Future<void> connect() async {
    if (_sftp != null) return;
    try {
      _sftp = await _session.client.sftp();
    } catch (e) {
      if (e is AppException) rethrow;
      throw SftpException('Failed to open SFTP session: $e', e);
    }
  }

  /// Returns the absolute path of the given path.
  Future<String> absolutePath(String path) async {
    _ensureConnected();
    return _sftp!.absolute(path);
  }

  /// Lists the contents of a directory.
  ///
  /// Returns entries sorted: directories first, then files,
  /// both alphabetically. Excludes "." but includes "..".
  Future<List<SftpEntry>> listDirectory(String path) async {
    _ensureConnected();
    try {
      final items = await _sftp!.listdir(path);
      final entries = <SftpEntry>[];

      for (final item in items) {
        if (item.filename == '.') continue;

        final isDir = item.attr.isDirectory;
        final modTime = item.attr.modifyTime;
        final mode = item.attr.mode;

        // Determine read/write access from permission bits.
        // We check user OR group OR other since we don't know
        // which applies to the current SSH user.
        final canRead = mode == null ||
            mode.userRead || mode.groupRead || mode.otherRead;
        final canWrite = mode == null ||
            mode.userWrite || mode.groupWrite || mode.otherWrite;

        entries.add(SftpEntry(
          name: item.filename,
          path: normalizePath(p.posix.join(path, item.filename)),
          isDirectory: isDir,
          size: item.attr.size,
          modifiedAt: modTime != null
              ? DateTime.fromMillisecondsSinceEpoch(modTime * 1000)
              : null,
          permissions: _formatPermissions(mode),
          userCanRead: canRead,
          userCanWrite: canWrite,
        ));
      }

      // Sort: directories first, then alphabetically
      entries.sort((a, b) {
        if (a.isParentDir) return -1;
        if (b.isParentDir) return 1;
        if (a.isDirectory != b.isDirectory) {
          return a.isDirectory ? -1 : 1;
        }
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      return entries;
    } catch (e) {
      if (e is AppException) rethrow;
      throw SftpException('Failed to list directory: $path — $e', e);
    }
  }

  /// Downloads a remote file to a local path.
  ///
  /// Reports progress via [onProgress] if provided.
  Future<void> downloadFile(
    String remotePath,
    String localPath, {
    TransferProgress? onProgress,
  }) async {
    _ensureConnected();
    try {
      final file = await _sftp!.open(remotePath);
      final stat = await _sftp!.stat(remotePath);
      final totalSize = stat.size ?? 0;

      final localFile = File(localPath);
      final sink = localFile.openWrite();
      var bytesRead = 0;

      await for (final chunk in file.read()) {
        sink.add(chunk);
        bytesRead += chunk.length;
        onProgress?.call(bytesRead, totalSize);
      }

      await sink.close();
      await file.close();
    } catch (e) {
      if (e is AppException) rethrow;
      throw SftpException('Failed to download file: $remotePath — $e', e);
    }
  }

  /// Uploads a local file to a remote path.
  ///
  /// Reports progress via [onProgress] if provided.
  Future<void> uploadFile(
    String localPath,
    String remotePath, {
    TransferProgress? onProgress,
  }) async {
    _ensureConnected();
    try {
      final localFile = File(localPath);
      final totalSize = await localFile.length();

      final remoteFile = await _sftp!.open(
        remotePath,
        mode: SftpFileOpenMode.write |
            SftpFileOpenMode.create |
            SftpFileOpenMode.truncate,
      );

      var bytesWritten = 0;
      final stream = localFile.openRead().map((chunk) {
        bytesWritten += chunk.length;
        onProgress?.call(bytesWritten, totalSize);
        return Uint8List.fromList(chunk);
      });

      await remoteFile.write(stream).done;
      await remoteFile.close();
    } catch (e) {
      if (e is AppException) rethrow;
      throw SftpException('Failed to upload file: $localPath — $e', e);
    }
  }

  /// Creates a directory at the given path.
  Future<void> createDirectory(String path) async {
    _ensureConnected();
    try {
      await _sftp!.mkdir(path);
    } catch (e) {
      throw SftpException('Failed to create directory: $path — $e', e);
    }
  }

  /// Deletes a file at the given path.
  Future<void> deleteFile(String path) async {
    _ensureConnected();
    try {
      await _sftp!.remove(path);
    } catch (e) {
      throw SftpException('Failed to delete file: $path — $e', e);
    }
  }

  /// Deletes an empty directory at the given path.
  Future<void> deleteDirectory(String path) async {
    _ensureConnected();
    try {
      await _sftp!.rmdir(path);
    } catch (e) {
      throw SftpException('Failed to delete directory: $path — $e', e);
    }
  }

  /// Renames/moves a file or directory.
  Future<void> rename(String oldPath, String newPath) async {
    _ensureConnected();
    try {
      await _sftp!.rename(oldPath, newPath);
    } catch (e) {
      throw SftpException('Failed to rename: $oldPath — $e', e);
    }
  }

  /// Gets file attributes (stat).
  Future<SftpEntry> stat(String path) async {
    _ensureConnected();
    try {
      final attrs = await _sftp!.stat(path);
      final name = p.posix.basename(path);
      return SftpEntry(
        name: name,
        path: path,
        isDirectory: attrs.isDirectory,
        size: attrs.size,
        modifiedAt: attrs.modifyTime != null
            ? DateTime.fromMillisecondsSinceEpoch(attrs.modifyTime! * 1000)
            : null,
        permissions: _formatPermissions(attrs.mode),
      );
    } catch (e) {
      throw SftpException('Failed to stat: $path — $e', e);
    }
  }

  /// Sets the permission mode on a remote file or directory.
  ///
  /// [octalMode] is the integer value of the octal permission string.
  /// For example, "755" should be passed as `int.parse('755', radix: 8)`.
  Future<void> setPermissions(String path, int octalMode) async {
    _ensureConnected();
    try {
      final user = (octalMode >> 6) & 7;
      final group = (octalMode >> 3) & 7;
      final other = octalMode & 7;

      final mode = SftpFileMode(
        userRead: (user & 4) != 0,
        userWrite: (user & 2) != 0,
        userExecute: (user & 1) != 0,
        groupRead: (group & 4) != 0,
        groupWrite: (group & 2) != 0,
        groupExecute: (group & 1) != 0,
        otherRead: (other & 4) != 0,
        otherWrite: (other & 2) != 0,
        otherExecute: (other & 1) != 0,
      );

      await _sftp!.setStat(path, SftpFileAttrs(mode: mode));
    } catch (e) {
      if (e is AppException) rethrow;
      throw SftpException('Failed to set permissions on: $path — $e', e);
    }
  }

  /// Reads the entire content of a remote text file as a String.
  ///
  /// Limits to [maxBytes] (default 5 MB) to prevent loading huge binaries.
  Future<String> readFileContent(String path,
      {int maxBytes = 5 * 1024 * 1024}) async {
    _ensureConnected();
    try {
      final attrs = await _sftp!.stat(path);
      final size = attrs.size ?? 0;
      if (size > maxBytes) {
        throw SftpException(
            'File too large for editing '
            '(${(size / 1024 / 1024).toStringAsFixed(1)} MB, '
            'max ${(maxBytes / 1024 / 1024).toStringAsFixed(0)} MB)');
      }
      final file = await _sftp!.open(path);
      final bytes = await file.readBytes();
      await file.close();
      return String.fromCharCodes(bytes);
    } catch (e) {
      if (e is AppException) rethrow;
      throw SftpException('Failed to read file: $path — $e', e);
    }
  }

  /// Writes string content to a remote file, replacing its contents.
  Future<void> writeFileContent(String path, String content) async {
    _ensureConnected();
    try {
      final file = await _sftp!.open(
        path,
        mode: SftpFileOpenMode.write |
            SftpFileOpenMode.create |
            SftpFileOpenMode.truncate,
      );
      final bytes = Uint8List.fromList(content.codeUnits);
      final stream = Stream.value(bytes);
      await file.write(stream).done;
      await file.close();
    } catch (e) {
      if (e is AppException) rethrow;
      throw SftpException('Failed to write file: $path — $e', e);
    }
  }

  /// Checks if a directory is writable by the current user.
  ///
  /// Returns true if the directory likely has write permission,
  /// false otherwise. Conservative: assumes readable if no mode info.
  Future<bool> isDirectoryWritable(String path) async {
    _ensureConnected();
    try {
      final attrs = await _sftp!.stat(path);
      final mode = attrs.mode;
      if (mode == null) return true; // No mode info, assume writable
      return mode.userWrite || mode.groupWrite || mode.otherWrite;
    } catch (e, stackTrace) {
      _log.d('Directory writable check failed for: $path', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Closes the SFTP subsession.
  void close() {
    _sftp?.close();
    _sftp = null;
  }

  void _ensureConnected() {
    if (_sftp == null) {
      throw const SftpException('SFTP session not connected');
    }
  }

  /// Normalizes a remote path to prevent path traversal via "..".
  ///
  /// Returns the POSIX-normalized path. Throws if the resulting path
  /// would escape above the root directory.
  static String normalizePath(String inputPath) {
    final normalized = p.posix.normalize(inputPath);
    // Reject paths that resolve to parent traversal above root
    if (normalized.startsWith('../') || normalized == '..') {
      throw SftpException(
          'Path traversal detected: $inputPath resolves to $normalized');
    }
    return normalized;
  }

  /// Formats permission bits as a unix-style string (e.g., "755").
  String? _formatPermissions(SftpFileMode? mode) {
    if (mode == null) return null;
    final user = (mode.userRead ? 4 : 0) +
        (mode.userWrite ? 2 : 0) +
        (mode.userExecute ? 1 : 0);
    final group = (mode.groupRead ? 4 : 0) +
        (mode.groupWrite ? 2 : 0) +
        (mode.groupExecute ? 1 : 0);
    final other = (mode.otherRead ? 4 : 0) +
        (mode.otherWrite ? 2 : 0) +
        (mode.otherExecute ? 1 : 0);
    return '$user$group$other';
  }
}

/// Riverpod provider for SftpService, scoped per SSH session.
final sftpServiceProvider = Provider.family<SftpService, SshSessionWrapper>(
  (ref, session) => SftpService(session),
);
