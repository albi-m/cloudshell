/// Data formatting utilities for CloudShell.
///
/// Provides consistent formatting for dates, file sizes,
/// durations, and other display values across the UI.
library;

import 'package:intl/intl.dart';

/// Formatting utilities for display values throughout the app.
abstract final class Formatters {
  /// Formats a file size in bytes to a human-readable string.
  ///
  /// Examples: "1.2 KB", "3.4 MB", "5.6 GB"
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Formats a [DateTime] as a relative time string.
  ///
  /// Examples: "just now", "5 min ago", "2 hours ago", "yesterday", "Mar 15"
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (dateTime.year == now.year) {
      return DateFormat('MMM d').format(dateTime);
    }
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  /// Formats a [DateTime] as a full date-time string.
  ///
  /// Example: "Mar 15, 2025 at 2:30 PM"
  static String fullDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy \'at\' h:mm a').format(dateTime);
  }

  /// Formats a [Duration] as a connection uptime string.
  ///
  /// Examples: "0:05", "1:23:45", "2d 5:30:00"
  static String duration(Duration duration) {
    if (duration.inDays > 0) {
      final hours = duration.inHours.remainder(24);
      final minutes = duration.inMinutes.remainder(60);
      final seconds = duration.inSeconds.remainder(60);
      return '${duration.inDays}d $hours:${_pad(minutes)}:${_pad(seconds)}';
    }
    if (duration.inHours > 0) {
      final minutes = duration.inMinutes.remainder(60);
      final seconds = duration.inSeconds.remainder(60);
      return '${duration.inHours}:${_pad(minutes)}:${_pad(seconds)}';
    }
    final seconds = duration.inSeconds.remainder(60);
    return '${duration.inMinutes}:${_pad(seconds)}';
  }

  /// Formats an SSH key fingerprint for display.
  ///
  /// Example: "SHA256:abc...xyz"
  static String fingerprint(String hash) {
    if (hash.length <= 20) return hash;
    return '${hash.substring(0, 10)}...${hash.substring(hash.length - 6)}';
  }

  /// Formats a port number with its forwarding type.
  static String portForward({
    required String type,
    required int sourcePort,
    String? destHost,
    int? destPort,
  }) {
    switch (type) {
      case 'local':
        return 'L:$sourcePort → ${destHost ?? '127.0.0.1'}:${destPort ?? sourcePort}';
      case 'remote':
        return 'R:$sourcePort → ${destHost ?? '127.0.0.1'}:${destPort ?? sourcePort}';
      case 'dynamic':
        return 'D:$sourcePort (SOCKS)';
      default:
        return '$sourcePort';
    }
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}
