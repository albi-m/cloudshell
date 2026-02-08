/// Wrapper around a dartssh2 SSHClient and its interactive shell.
///
/// Manages the lifecycle of a single SSH connection including
/// authentication, shell session, and terminal I/O binding.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';

/// Wraps an active SSH connection with its shell session.
///
/// Provides a clean interface for the terminal screen to
/// send input and receive output without direct dartssh2 coupling.
class SshSessionWrapper {
  SshSessionWrapper({
    required this.sessionId,
    required this.hostId,
    required this.client,
    this.onClose,
  });

  /// Unique session identifier for tab management.
  final String sessionId;

  /// The host this session is connected to.
  final String hostId;

  /// The underlying dartssh2 SSH client.
  final SSHClient client;

  /// Callback invoked when the session is closed (for connection counting).
  final void Function()? onClose;

  /// The interactive shell session (set after [startShell]).
  SSHSession? _shell;

  /// Stream controller that merges all shell output (stdout + stderr).
  final _outputController = StreamController<Uint8List>.broadcast();

  /// Whether the connection is currently active.
  bool get isConnected => !client.isClosed;

  /// Whether close() has already been called.
  bool _isClosed = false;

  /// Stream of terminal output bytes from the remote server.
  Stream<Uint8List> get output => _outputController.stream;

  /// Starts an interactive shell session on this connection.
  ///
  /// Must be called after the SSH client has authenticated.
  /// Optionally specify terminal dimensions.
  Future<void> startShell({
    int termWidth = 80,
    int termHeight = 24,
  }) async {
    _shell = await client.shell(
      pty: SSHPtyConfig(
        width: termWidth,
        height: termHeight,
      ),
    );

    // Forward shell stdout to the output stream
    _shell!.stdout.listen(
      _outputController.add,
      onError: _outputController.addError,
      onDone: () {
        if (!_outputController.isClosed) {
          _outputController.close();
        }
      },
    );

    // Forward stderr to the same output stream
    _shell!.stderr.listen(_outputController.add);
  }

  /// Sends raw bytes to the shell stdin (keyboard input).
  void write(Uint8List data) {
    _shell?.stdin.add(data);
  }

  /// Sends a string to the shell stdin.
  void writeString(String data) {
    write(Uint8List.fromList(data.codeUnits));
  }

  /// Notifies the remote server of a terminal resize.
  void resize(int width, int height) {
    _shell?.resizeTerminal(width, height);
  }

  /// Closes the shell and SSH connection.
  ///
  /// Safe to call multiple times; only the first call performs cleanup.
  Future<void> close() async {
    if (_isClosed) return;
    _isClosed = true;

    _shell?.close();
    client.close();
    if (!_outputController.isClosed) {
      await _outputController.close();
    }
    onClose?.call();
  }

  /// Waits until the connection is fully closed.
  Future<void> get done => client.done;
}
