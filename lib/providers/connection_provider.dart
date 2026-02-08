/// Riverpod providers for SSH connection state management.
///
/// Tracks active SSH sessions and their connection states
/// across the application.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the state of an active SSH connection.
class SshConnectionState {
  const SshConnectionState({
    required this.hostId,
    required this.sessionId,
    required this.status,
    this.connectedAt,
    this.errorMessage,
  });

  /// The ID of the host being connected to.
  final String hostId;

  /// Unique session identifier.
  final String sessionId;

  /// Current connection status.
  final ConnectionStatus status;

  /// When the connection was established.
  final DateTime? connectedAt;

  /// Error message if connection failed.
  final String? errorMessage;
}

/// SSH connection lifecycle states.
enum ConnectionStatus {
  /// Connection is being established.
  connecting,

  /// Successfully connected and authenticated.
  connected,

  /// Connection was lost, attempting reconnect.
  reconnecting,

  /// Intentionally disconnected.
  disconnected,

  /// Connection attempt failed.
  error,
}

/// Manages the set of active SSH connections.
///
/// Provides state for the connection status indicators
/// and terminal tab management.
class ActiveConnectionsNotifier extends Notifier<Map<String, SshConnectionState>> {
  @override
  Map<String, SshConnectionState> build() => {};

  /// Registers a new connection attempt.
  void addConnection(String sessionId, String hostId) {
    state = {
      ...state,
      sessionId: SshConnectionState(
        hostId: hostId,
        sessionId: sessionId,
        status: ConnectionStatus.connecting,
      ),
    };
  }

  /// Updates the status of an existing connection.
  void updateStatus(String sessionId, ConnectionStatus status, {String? error}) {
    final existing = state[sessionId];
    if (existing == null) return;

    state = {
      ...state,
      sessionId: SshConnectionState(
        hostId: existing.hostId,
        sessionId: sessionId,
        status: status,
        connectedAt: status == ConnectionStatus.connected ? DateTime.now() : existing.connectedAt,
        errorMessage: error,
      ),
    };
  }

  /// Removes a connection from the active set.
  void removeConnection(String sessionId) {
    state = Map.from(state)..remove(sessionId);
  }
}

/// Provider for the active SSH connections state.
final activeConnectionsProvider =
    NotifierProvider<ActiveConnectionsNotifier, Map<String, SshConnectionState>>(
  ActiveConnectionsNotifier.new,
);

/// Provides the connection state for a specific session ID.
final connectionStateProvider = Provider.family<SshConnectionState?, String>((ref, sessionId) {
  final connections = ref.watch(activeConnectionsProvider);
  return connections[sessionId];
});
