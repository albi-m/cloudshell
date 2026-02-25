/// SSH connection management service for CloudShell.
///
/// Orchestrates SSH connections using dartssh2: resolves
/// authentication credentials, establishes connections,
/// manages host key verification, and creates session wrappers.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:pointycastle/digests/sha256.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';
import '../../data/database/app_database.dart';
import '../crypto/secure_storage.dart';
import 'ssh_key_service.dart';
import 'ssh_session.dart';

/// Maximum concurrent SSH connections to prevent resource exhaustion.
const _maxConcurrentConnections = 10;

/// Result of host key verification check.
enum HostKeyStatus {
  /// First time seeing this host — needs user confirmation.
  unknown,

  /// Fingerprint matches the stored known host.
  trusted,

  /// Fingerprint does NOT match — possible MITM attack.
  changed,
}

/// Information about a host key for verification UI.
class HostKeyInfo {
  const HostKeyInfo({
    required this.hostname,
    required this.port,
    required this.keyType,
    required this.fingerprint,
    required this.status,
  });

  final String hostname;
  final int port;
  final String keyType;
  final String fingerprint;
  final HostKeyStatus status;
}

/// Callback type for host key verification.
///
/// The UI should display the host key info and return true
/// if the user chooses to trust it, false to abort.
typedef HostKeyVerifyCallback = Future<bool> Function(HostKeyInfo info);

/// Service for establishing and managing SSH connections.
///
/// Coordinates dartssh2 client setup, authentication credential
/// resolution (keys from keychain, passwords from secure storage),
/// and host key verification against the known_hosts database.
class SshService {
  SshService({
    required this.db,
    required this.secureStorage,
    required this.keyService,
  });

  final AppDatabase db;
  final SecureStorageService secureStorage;
  final SshKeyService keyService;

  static const _uuid = Uuid();

  /// Tracks active connection count for resource limiting.
  int _activeConnections = 0;

  /// Connects to an SSH host and returns a session wrapper.
  ///
  /// [host] — the host record from the database.
  /// [onVerifyHostKey] — callback for host key verification UI.
  /// [onPasswordRequest] — callback when server requests a password.
  ///
  /// If the host has a [jumpHostId], the connection is routed
  /// through the jump host using SSH port forwarding (proxy jump).
  Future<SshSessionWrapper> connect({
    required Host host,
    HostKeyVerifyCallback? onVerifyHostKey,
    Future<String?> Function()? onPasswordRequest,
  }) async {
    if (_activeConnections >= _maxConcurrentConnections) {
      throw const SshException(
        'Too many active connections. Close an existing session first.',
      );
    }

    final sessionId = _uuid.v4();

    try {
      _activeConnections++;

      // Resolve the socket (direct or through jump host chain)
      final socketResult = await _resolveSocket(
        host: host,
        onVerifyHostKey: onVerifyHostKey,
        visitedIds: {},
      );

      // Resolve authentication identities (SSH key pairs)
      List<SSHKeyPair>? identities;
      if (host.keyId != null) {
        identities = await keyService.getKeyPairsForAuth(host.keyId!);
      }

      // Resolve password from secure storage
      final storedPassword = await secureStorage.getHostPassword(host.id);

      // Captured host key info during handshake for TOFU verification
      String? capturedKeyType;
      Uint8List? capturedFingerprint;

      // Create SSH client with auth configuration
      final client = SSHClient(
        socketResult.socket,
        username: host.username,
        identities: identities,
        keepAliveInterval: Duration(seconds: host.keepAliveSeconds),
        onPasswordRequest: () {
          if (storedPassword != null) return storedPassword;
          return '';
        },
        onVerifyHostKey: (type, fingerprint) {
          // Capture key material for post-auth TOFU verification
          capturedKeyType = type;
          capturedFingerprint = Uint8List.fromList(fingerprint);
          return true;
        },
      );

      // Wait for authentication to complete
      await client.authenticated;

      // TOFU host key verification against known_hosts database
      if (capturedKeyType != null && capturedFingerprint != null) {
        final accepted = await verifyHostKey(
          hostname: host.hostname,
          port: host.port,
          keyType: capturedKeyType!,
          fingerprintBytes: capturedFingerprint!,
          onVerify: onVerifyHostKey,
        );
        if (!accepted) {
          client.close();
          await socketResult.jumpSession?.close();
          _activeConnections--;
          throw SshHostKeyException(
            'Host key verification rejected by user',
            fingerprint: computeFingerprint(capturedFingerprint!),
          );
        }
      }

      // Update last connected timestamp (fire-and-forget)
      unawaited(db.hostDao.updateLastConnected(host.id));

      return SshSessionWrapper(
        sessionId: sessionId,
        hostId: host.id,
        client: client,
        jumpSession: socketResult.jumpSession,
        onClose: () => _activeConnections--,
      );
    } on SocketException {
      _activeConnections--;
      throw const SshTimeoutException(
        'Connection timed out. Verify the server address and port.',
      );
    } on SSHAuthFailError {
      _activeConnections--;
      throw const SshAuthException(
        'Authentication failed. Check your credentials.',
      );
    } catch (e) {
      _activeConnections--;
      if (e is AppException) rethrow;
      throw const SshException('SSH connection failed. Please try again.');
    }
  }

  /// Resolves the socket for connecting to [host].
  ///
  /// If the host has a [jumpHostId], recursively connects through
  /// the jump host chain and returns a forwarded channel as the socket.
  /// Detects circular jump chains via [visitedIds].
  Future<_SocketResult> _resolveSocket({
    required Host host,
    HostKeyVerifyCallback? onVerifyHostKey,
    required Set<String> visitedIds,
  }) async {
    if (host.jumpHostId == null) {
      // Direct connection — no proxy jump
      final socket = await SSHSocket.connect(
        host.hostname,
        host.port,
        timeout: Duration(seconds: AppConstants.defaultConnectionTimeout),
      );
      return _SocketResult(socket: socket);
    }

    // Circular chain detection
    if (visitedIds.contains(host.id)) {
      throw const SshException(
        'Circular jump host chain detected. Check your proxy jump configuration.',
      );
    }
    visitedIds.add(host.id);

    // Resolve the jump host from the database
    final jumpHost = await db.hostDao.getHostById(host.jumpHostId!);
    if (jumpHost == null) {
      throw const SshException(
        'Jump host not found. It may have been deleted.',
      );
    }

    // Recursively connect to the jump host
    final jumpSession = await connect(
      host: jumpHost,
      onVerifyHostKey: onVerifyHostKey,
    );

    // Forward through the jump host to the target
    final channel = await jumpSession.client.forwardLocal(
      host.hostname,
      host.port,
    );

    return _SocketResult(socket: channel, jumpSession: jumpSession);
  }

  /// Performs a quick connect to a host by hostname/IP without
  /// saving it to the database.
  Future<SshSessionWrapper> quickConnect({
    required String hostname,
    required String username,
    int port = 22,
    String? password,
    List<SSHKeyPair>? identities,
    HostKeyVerifyCallback? onVerifyHostKey,
  }) async {
    if (_activeConnections >= _maxConcurrentConnections) {
      throw const SshException(
        'Too many active connections. Close an existing session first.',
      );
    }

    final sessionId = _uuid.v4();

    try {
      _activeConnections++;

      final socket = await SSHSocket.connect(
        hostname,
        port,
        timeout: const Duration(seconds: AppConstants.defaultConnectionTimeout),
      );

      // Capture host key material during handshake for TOFU verification
      String? capturedKeyType;
      Uint8List? capturedFingerprint;

      final client = SSHClient(
        socket,
        username: username,
        identities: identities,
        onPasswordRequest: () => password ?? '',
        onVerifyHostKey: (type, fingerprint) {
          capturedKeyType = type;
          capturedFingerprint = Uint8List.fromList(fingerprint);
          return true;
        },
      );

      await client.authenticated;

      // TOFU host key verification against known_hosts database
      if (capturedKeyType != null && capturedFingerprint != null) {
        final accepted = await verifyHostKey(
          hostname: hostname,
          port: port,
          keyType: capturedKeyType!,
          fingerprintBytes: capturedFingerprint!,
          onVerify: onVerifyHostKey,
        );
        if (!accepted) {
          client.close();
          _activeConnections--;
          throw SshHostKeyException(
            'Host key verification rejected by user',
            fingerprint: computeFingerprint(capturedFingerprint!),
          );
        }
      }

      return SshSessionWrapper(
        sessionId: sessionId,
        hostId: '',
        client: client,
        onClose: () => _activeConnections--,
      );
    } on SocketException {
      _activeConnections--;
      throw const SshTimeoutException(
        'Connection timed out. Verify the server address and port.',
      );
    } on SSHAuthFailError {
      _activeConnections--;
      throw const SshAuthException(
        'Authentication failed. Check your credentials.',
      );
    } catch (e) {
      _activeConnections--;
      if (e is AppException) rethrow;
      throw const SshException('SSH connection failed. Please try again.');
    }
  }

  /// Verifies the remote host key against the known_hosts database.
  ///
  /// Returns true if the host key is trusted (either already known
  /// or user approved), false if rejected.
  @visibleForTesting
  Future<bool> verifyHostKey({
    required String hostname,
    required int port,
    required String keyType,
    required Uint8List fingerprintBytes,
    HostKeyVerifyCallback? onVerify,
  }) async {
    final fingerprint = computeFingerprint(fingerprintBytes);

    // Look up known hosts for this hostname:port
    final knownEntries = await (db.select(db.knownHosts)
          ..where((kh) =>
              kh.hostname.equals(hostname) &
              kh.port.equals(port) &
              kh.isTrusted.equals(true)))
        .get();

    if (knownEntries.isEmpty) {
      // First connection — unknown host
      if (onVerify == null) return true; // No callback = auto-accept

      final accepted = await onVerify(HostKeyInfo(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprint: fingerprint,
        status: HostKeyStatus.unknown,
      ));

      if (accepted) {
        await trustHostKey(
          hostname: hostname,
          port: port,
          keyType: keyType,
          fingerprint: fingerprint,
          publicKey: base64Encode(fingerprintBytes),
        );
      }
      return accepted;
    }

    // Check if any known entry matches the current fingerprint
    final matchingEntry = knownEntries
        .where((kh) => kh.fingerprint == fingerprint)
        .firstOrNull;

    if (matchingEntry != null) {
      // Trusted — update lastSeen timestamp (fire-and-forget)
      unawaited(
        (db.update(db.knownHosts)
              ..where((kh) => kh.id.equals(matchingEntry.id)))
            .write(KnownHostsCompanion(lastSeen: Value(DateTime.now()))),
      );
      return true;
    }

    // Fingerprint changed — possible MITM
    if (onVerify == null) return false;

    final accepted = await onVerify(HostKeyInfo(
      hostname: hostname,
      port: port,
      keyType: keyType,
      fingerprint: fingerprint,
      status: HostKeyStatus.changed,
    ));

    if (accepted) {
      // Remove old entry and store the new one
      await (db.delete(db.knownHosts)
            ..where((kh) =>
                kh.hostname.equals(hostname) & kh.port.equals(port)))
          .go();
      await trustHostKey(
        hostname: hostname,
        port: port,
        keyType: keyType,
        fingerprint: fingerprint,
        publicKey: base64Encode(fingerprintBytes),
      );
    }
    return accepted;
  }

  /// Records a trusted host key fingerprint in the database.
  Future<void> trustHostKey({
    required String hostname,
    required int port,
    required String keyType,
    required String fingerprint,
    required String publicKey,
  }) async {
    final now = DateTime.now();
    await db.into(db.knownHosts).insertOnConflictUpdate(
      KnownHostsCompanion(
        id: Value(_uuid.v4()),
        hostname: Value(hostname),
        port: Value(port),
        keyType: Value(keyType),
        fingerprint: Value(fingerprint),
        publicKey: Value(publicKey),
        isTrusted: const Value(true),
        firstSeen: Value(now),
        lastSeen: Value(now),
      ),
    );
  }

  /// Computes SHA256 fingerprint from raw host key bytes.
  static String computeFingerprint(Uint8List hostKeyBytes) {
    final digest = SHA256Digest().process(hostKeyBytes);
    return 'SHA256:${base64Encode(digest).replaceAll('=', '')}';
  }
}

/// Result of socket resolution, containing the socket and optional
/// jump session for proxy jump connections.
class _SocketResult {
  const _SocketResult({required this.socket, this.jumpSession});

  /// The socket to use for the SSH client connection.
  /// Either a direct [SSHSocket] or an [SSHForwardChannel] from a jump host.
  final SSHSocket socket;

  /// The jump host session, if this is a proxied connection.
  final SshSessionWrapper? jumpSession;
}

/// Riverpod provider for the SSH service.
final sshServiceProvider = Provider<SshService>((ref) {
  return SshService(
    db: ref.watch(databaseProvider),
    secureStorage: ref.watch(secureStorageProvider),
    keyService: ref.watch(sshKeyServiceProvider),
  );
});
