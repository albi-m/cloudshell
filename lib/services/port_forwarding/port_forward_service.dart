/// Runtime port forward tunnel management service.
///
/// Manages active SSH tunnels (local and remote port forwarding)
/// for connected hosts. Handles starting, stopping, and tracking
/// of forwarded connections.
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../data/database/app_database.dart';
import '../../data/database/tables/port_forwards_table.dart';

/// Tracks a single active port forwarding tunnel.
class ActiveForward {
  const ActiveForward({
    required this.ruleId,
    required this.hostId,
    required this.type,
    required this.sourcePort,
    this.destinationHost,
    this.destinationPort,
    this.serverSocket,
    this.remoteForward,
  });

  /// ID of the port forward rule from the database.
  final String ruleId;

  /// ID of the host this tunnel belongs to.
  final String hostId;

  /// Tunnel type (local or remote).
  final PortForwardTypeEnum type;

  /// Source port (local port for local forwarding, remote port for remote).
  final int sourcePort;

  /// Destination host for forwarding.
  final String? destinationHost;

  /// Destination port for forwarding.
  final int? destinationPort;

  /// The listening server socket (for local forwarding).
  final ServerSocket? serverSocket;

  /// The remote forward handle (for remote forwarding).
  final SSHRemoteForward? remoteForward;
}

/// Service for managing runtime SSH port forwarding tunnels.
///
/// Binds local server sockets or requests remote forwards from
/// the SSH server, and tracks all active tunnels for cleanup
/// on disconnect.
class PortForwardService {
  PortForwardService({required this.db});

  static final _log = Logger();

  final AppDatabase db;

  /// Map of ruleId → ActiveForward for currently running tunnels.
  final Map<String, ActiveForward> _activeForwards = {};

  /// Stream controller for notifying the UI of active forward changes.
  final _activeForwardsController =
      StreamController<List<ActiveForward>>.broadcast();

  /// Stream of currently active port forwards.
  Stream<List<ActiveForward>> get activeForwards =>
      _activeForwardsController.stream;

  /// Current list of active forwards.
  List<ActiveForward> get currentActiveForwards =>
      _activeForwards.values.toList();

  /// Starts a local port forward tunnel.
  ///
  /// Binds a local [ServerSocket] on [rule.sourcePort], and for each
  /// incoming connection, opens an SSH forwarded channel to the
  /// destination host/port through the given [client].
  Future<void> startLocalForward(
    SSHClient client,
    PortForward rule,
  ) async {
    if (_activeForwards.containsKey(rule.id)) return;

    final bindAddress = InternetAddress.loopbackIPv4;
    final server = await ServerSocket.bind(bindAddress, rule.sourcePort);

    final active = ActiveForward(
      ruleId: rule.id,
      hostId: rule.hostId,
      type: PortForwardTypeEnum.local,
      sourcePort: rule.sourcePort,
      destinationHost: rule.destinationHost,
      destinationPort: rule.destinationPort,
      serverSocket: server,
    );

    _activeForwards[rule.id] = active;
    _notifyListeners();

    server.listen(
      (socket) async {
        try {
          final channel = await client.forwardLocal(
            rule.destinationHost ?? 'localhost',
            rule.destinationPort ?? rule.sourcePort,
          );

          // Pipe data bidirectionally between the local socket and SSH channel
          socket.listen(
            channel.sink.add,
            onDone: () => channel.close(),
            onError: (_) => channel.close(),
          );
          channel.stream.listen(
            socket.add,
            onDone: () => socket.destroy(),
            onError: (_) => socket.destroy(),
          );
        } catch (e, stackTrace) {
          _log.d('Local forward SSH channel open failed', error: e, stackTrace: stackTrace);
          socket.destroy();
        }
      },
      onError: (_) => stopForward(rule.id),
    );
  }

  /// Starts a remote port forward tunnel.
  ///
  /// Requests the SSH server to listen on [rule.sourcePort] and
  /// forwards incoming connections to the local destination.
  Future<void> startRemoteForward(
    SSHClient client,
    PortForward rule,
  ) async {
    if (_activeForwards.containsKey(rule.id)) return;

    final remoteForward = await client.forwardRemote(
      host: rule.destinationHost ?? 'localhost',
      port: rule.sourcePort,
    );

    if (remoteForward == null) {
      throw StateError(
        'Remote port forward request denied by server for port ${rule.sourcePort}.',
      );
    }

    final active = ActiveForward(
      ruleId: rule.id,
      hostId: rule.hostId,
      type: PortForwardTypeEnum.remote,
      sourcePort: rule.sourcePort,
      destinationHost: rule.destinationHost,
      destinationPort: rule.destinationPort,
      remoteForward: remoteForward,
    );

    _activeForwards[rule.id] = active;
    _notifyListeners();

    // Listen for incoming connections from the remote side
    remoteForward.connections.listen(
      (channel) async {
        try {
          final localHost = rule.destinationHost ?? 'localhost';
          final localPort = rule.destinationPort ?? rule.sourcePort;
          final socket = await Socket.connect(localHost, localPort);

          // Pipe data bidirectionally
          channel.stream.listen(
            socket.add,
            onDone: () => socket.destroy(),
            onError: (_) => socket.destroy(),
          );
          socket.listen(
            channel.sink.add,
            onDone: () => channel.close(),
            onError: (_) => channel.close(),
          );
        } catch (e, stackTrace) {
          _log.d('Remote forward local socket connect failed', error: e, stackTrace: stackTrace);
          channel.close();
        }
      },
      onError: (_) => stopForward(rule.id),
    );
  }

  /// Starts a dynamic (SOCKS5) port forward tunnel.
  ///
  /// Binds a local SOCKS5 proxy server on [rule.sourcePort].
  /// Each incoming SOCKS5 connection is forwarded through the
  /// SSH client to the requested destination.
  Future<void> startDynamicForward(
    SSHClient client,
    PortForward rule,
  ) async {
    if (_activeForwards.containsKey(rule.id)) return;

    final bindAddress = InternetAddress.loopbackIPv4;
    final server = await ServerSocket.bind(bindAddress, rule.sourcePort);

    final active = ActiveForward(
      ruleId: rule.id,
      hostId: rule.hostId,
      type: PortForwardTypeEnum.dynamic,
      sourcePort: rule.sourcePort,
      serverSocket: server,
    );

    _activeForwards[rule.id] = active;
    _notifyListeners();

    server.listen(
      (socket) => _handleSocksConnection(client, socket),
      onError: (_) => stopForward(rule.id),
    );
  }

  /// Handles a single SOCKS5 client connection using a buffered reader.
  ///
  /// Uses [_SocksBufferedReader] to properly buffer incoming socket
  /// data during the SOCKS5 handshake, then switches to direct piping.
  Future<void> _handleSocksConnection(
    SSHClient client,
    Socket socket,
  ) async {
    final reader = _SocksBufferedReader(socket);

    try {
      // SOCKS5 greeting: version + number of auth methods
      final greeting = await reader.read(2);
      if (greeting[0] != 0x05) {
        socket.destroy();
        return;
      }

      // Read auth methods (skip them — we only support no-auth)
      await reader.read(greeting[1]);

      // Respond: SOCKS5, no auth required
      socket.add([0x05, 0x00]);

      // Read connection request header (ver, cmd, rsv, atyp)
      final request = await reader.read(4);
      if (request[0] != 0x05 || request[1] != 0x01) {
        // Only CONNECT (0x01) is supported
        socket.add([0x05, 0x07, 0x00, 0x01, 0, 0, 0, 0, 0, 0]);
        socket.destroy();
        return;
      }

      final addressType = request[3];
      String host;

      switch (addressType) {
        case 0x01: // IPv4
          final addr = await reader.read(4);
          host = addr.join('.');
        case 0x03: // Domain name
          final lenBytes = await reader.read(1);
          final domainBytes = await reader.read(lenBytes[0]);
          host = String.fromCharCodes(domainBytes);
        case 0x04: // IPv6
          final addr = await reader.read(16);
          host = InternetAddress.fromRawAddress(
            Uint8List.fromList(addr),
            type: InternetAddressType.IPv6,
          ).address;
        default:
          socket.add([0x05, 0x08, 0x00, 0x01, 0, 0, 0, 0, 0, 0]);
          socket.destroy();
          return;
      }

      final portBytes = await reader.read(2);
      final port = (portBytes[0] << 8) | portBytes[1];

      // Cancel the buffered reader subscription before piping
      reader.cancel();

      // Forward through SSH
      try {
        final channel = await client.forwardLocal(host, port);

        // Send success response
        socket.add([0x05, 0x00, 0x00, 0x01, 0, 0, 0, 0, 0, 0]);

        // Pipe data bidirectionally
        socket.listen(
          channel.sink.add,
          onDone: () => channel.close(),
          onError: (_) => channel.close(),
        );
        channel.stream.listen(
          socket.add,
          onDone: () => socket.destroy(),
          onError: (_) => socket.destroy(),
        );
      } catch (e, stackTrace) {
        // Connection refused or failed
        _log.d('SOCKS5 forward channel open failed', error: e, stackTrace: stackTrace);
        socket.add([0x05, 0x05, 0x00, 0x01, 0, 0, 0, 0, 0, 0]);
        socket.destroy();
      }
    } catch (e, stackTrace) {
      _log.d('SOCKS5 handshake failed', error: e, stackTrace: stackTrace);
      reader.cancel();
      socket.destroy();
    }
  }

  /// Stops a specific port forward by rule ID.
  Future<void> stopForward(String ruleId) async {
    final active = _activeForwards.remove(ruleId);
    if (active == null) return;

    await active.serverSocket?.close();
    active.remoteForward?.close();
    _notifyListeners();
  }

  /// Stops all active port forwards for a specific host.
  ///
  /// Called when a host session disconnects to clean up all tunnels.
  Future<void> stopAllForHost(String hostId) async {
    final toRemove = _activeForwards.entries
        .where((e) => e.value.hostId == hostId)
        .map((e) => e.key)
        .toList();

    for (final ruleId in toRemove) {
      await stopForward(ruleId);
    }
  }

  /// Starts all auto-start port forwards for a host.
  ///
  /// Called after a successful SSH connection to automatically
  /// establish configured tunnels.
  Future<void> autoStartForwards(SSHClient client, String hostId) async {
    final rules = await db.portForwardDao.getAutoStartForwards(hostId);

    for (final rule in rules) {
      try {
        switch (rule.type) {
          case PortForwardTypeEnum.local:
            await startLocalForward(client, rule);
          case PortForwardTypeEnum.remote:
            await startRemoteForward(client, rule);
          case PortForwardTypeEnum.dynamic:
            await startDynamicForward(client, rule);
        }
      } catch (e, stackTrace) {
        // Log but continue with remaining forwards
        _log.d('Auto-start forward failed for rule ${rule.id}', error: e, stackTrace: stackTrace);
      }
    }
  }

  /// Whether a specific rule is currently active.
  bool isActive(String ruleId) => _activeForwards.containsKey(ruleId);

  void _notifyListeners() {
    _activeForwardsController.add(_activeForwards.values.toList());
  }

  /// Disposes the service and cleans up all active tunnels.
  Future<void> dispose() async {
    for (final ruleId in _activeForwards.keys.toList()) {
      await stopForward(ruleId);
    }
    await _activeForwardsController.close();
  }
}

/// Buffered reader for SOCKS5 handshake protocol bytes.
///
/// Listens on a socket once and buffers incoming data, allowing
/// exact-count reads via [read()]. The subscription can be cancelled
/// after the handshake to allow re-listening for the piping phase.
class _SocksBufferedReader {
  _SocksBufferedReader(Socket socket) {
    _subscription = socket.listen(
      (data) {
        _buffer.addAll(data);
        _tryComplete();
      },
      onError: (e) {
        _pendingCompleter?.completeError(e);
        _pendingCompleter = null;
      },
      onDone: () {
        _pendingCompleter?.completeError(
          StateError('Socket closed during SOCKS handshake'),
        );
        _pendingCompleter = null;
      },
    );
  }

  late final StreamSubscription<Uint8List> _subscription;
  final _buffer = <int>[];
  Completer<List<int>>? _pendingCompleter;
  int _pendingCount = 0;

  /// Reads exactly [count] bytes from the buffered stream.
  Future<List<int>> read(int count) {
    if (_buffer.length >= count) {
      final result = _buffer.sublist(0, count);
      _buffer.removeRange(0, count);
      return Future.value(result);
    }

    _pendingCount = count;
    _pendingCompleter = Completer<List<int>>();
    return _pendingCompleter!.future;
  }

  void _tryComplete() {
    if (_pendingCompleter != null && _buffer.length >= _pendingCount) {
      final result = _buffer.sublist(0, _pendingCount);
      _buffer.removeRange(0, _pendingCount);
      final completer = _pendingCompleter!;
      _pendingCompleter = null;
      completer.complete(result);
    }
  }

  /// Cancels the underlying socket subscription.
  void cancel() {
    _subscription.cancel();
  }
}

/// Riverpod provider for the port forward service singleton.
final portForwardServiceProvider = Provider<PortForwardService>((ref) {
  final service = PortForwardService(db: ref.watch(databaseProvider));
  ref.onDispose(() => service.dispose());
  return service;
});

/// Stream provider for currently active port forwards.
final activeForwardsProvider = StreamProvider<List<ActiveForward>>((ref) {
  final service = ref.watch(portForwardServiceProvider);
  return service.activeForwards;
});
