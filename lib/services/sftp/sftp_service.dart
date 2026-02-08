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
  });

  final String name;
  final String path;
  final bool isDirectory;
  final int? size;
  final DateTime? modifiedAt;
  final String? permissions;

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
      throw const SftpException('Failed to open SFTP session');
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

        entries.add(SftpEntry(
          name: item.filename,
          path: p.posix.join(path, item.filename),
          isDirectory: isDir,
          size: item.attr.size,
          modifiedAt: modTime != null
              ? DateTime.fromMillisecondsSinceEpoch(modTime * 1000)
              : null,
          permissions: _formatPermissions(item.attr.mode),
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
      throw SftpException('Failed to list directory: $path');
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
      throw SftpException('Failed to download file: $remotePath');
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
      throw SftpException('Failed to upload file: $localPath');
    }
  }

  /// Creates a directory at the given path.
  Future<void> createDirectory(String path) async {
    _ensureConnected();
    try {
      await _sftp!.mkdir(path);
    } catch (e) {
      throw SftpException('Failed to create directory: $path');
    }
  }

  /// Deletes a file at the given path.
  Future<void> deleteFile(String path) async {
    _ensureConnected();
    try {
      await _sftp!.remove(path);
    } catch (e) {
      throw SftpException('Failed to delete file: $path');
    }
  }

  /// Deletes an empty directory at the given path.
  Future<void> deleteDirectory(String path) async {
    _ensureConnected();
    try {
      await _sftp!.rmdir(path);
    } catch (e) {
      throw SftpException('Failed to delete directory: $path');
    }
  }

  /// Renames/moves a file or directory.
  Future<void> rename(String oldPath, String newPath) async {
    _ensureConnected();
    try {
      await _sftp!.rename(oldPath, newPath);
    } catch (e) {
      throw SftpException('Failed to rename: $oldPath');
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
      throw SftpException('Failed to stat: $path');
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
