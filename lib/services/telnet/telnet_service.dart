// Telnet connection service.
//
// Creates TelnetSession instances by establishing TCP socket
// connections to remote hosts.

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import 'telnet_session.dart';

/// Service for establishing telnet connections.
class TelnetService {
  /// Connect to a host via telnet (raw TCP socket).
  ///
  /// Uses the host's configured port (defaults to 23 for telnet).
  /// Returns a [TelnetSession] implementing [ConnectionSession].
  Future<TelnetSession> connect({
    required Host host,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final port = host.port == 22 ? 23 : host.port; // Default telnet port
    final socket = await Socket.connect(
      host.hostname,
      port,
      timeout: timeout,
    );

    return TelnetSession(
      socket: socket,
      hostId: host.id,
    );
  }
}

/// Riverpod provider for the telnet service.
final telnetServiceProvider = Provider<TelnetService>((ref) {
  return TelnetService();
});
