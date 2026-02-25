// Abstract interface for all connection types (SSH, Telnet, Serial).
//
// Provides a unified API for the terminal tab provider to interact
// with any connection protocol without coupling to implementation details.
import 'dart:typed_data';

/// Abstract base class for connection sessions.
///
/// Each protocol (SSH, Telnet, Serial) implements this interface
/// so the terminal tab provider can manage sessions generically.
abstract class ConnectionSession {
  /// Unique session identifier for tab management.
  String get sessionId;

  /// The host this session is connected to.
  String get hostId;

  /// Whether the connection is currently active.
  bool get isConnected;

  /// Stream of output bytes from the remote end.
  Stream<Uint8List> get output;

  /// Sends raw bytes to the remote end (keyboard input).
  void write(Uint8List data);

  /// Sends a string to the remote end.
  void writeString(String data);

  /// Notifies the remote end of a terminal resize.
  ///
  /// For protocols that don't support terminal sizing (e.g., Serial),
  /// this is a no-op.
  void resize(int width, int height);

  /// Starts the interactive session (shell, negotiation, port open).
  ///
  /// For SSH: starts an interactive shell with PTY.
  /// For Telnet: performs initial option negotiation.
  /// For Serial: opens the port with configured parameters.
  Future<void> startSession({
    int termWidth = 80,
    int termHeight = 24,
  });

  /// Closes the connection and releases resources.
  Future<void> close();

  /// Completes when the connection is fully closed.
  Future<void> get done;
}
