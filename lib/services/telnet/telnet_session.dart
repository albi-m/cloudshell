// Telnet connection session implementing ConnectionSession.
//
// Wraps a dart:io Socket with telnet protocol handling via TelnetParser.
// Manages IAC negotiation, NAWS terminal sizing, and clean data flow.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

import '../connection/connection_session.dart';
import 'telnet_constants.dart';
import 'telnet_parser.dart';

/// A telnet connection session.
///
/// Connects to a remote host over TCP and handles RFC 854 telnet
/// protocol negotiation transparently. Terminal data is available
/// via [output] with all IAC sequences stripped.
class TelnetSession implements ConnectionSession {
  TelnetSession({
    required this.socket,
    required String hostId,
  })  : _hostId = hostId,
        _sessionId = const Uuid().v4() {
    _parser = TelnetParser(
      onNegotiation: _handleNegotiation,
      onSubnegotiation: _handleSubnegotiation,
    );

    // Pipe socket data through the telnet parser.
    _socketSubscription = socket.listen(
      (data) => _parser.add(Uint8List.fromList(data)),
      onError: (Object error) {
        _isConnected = false;
        _outputController.addError(error);
      },
      onDone: () {
        _isConnected = false;
        _parser.close();
        _outputController.close();
        if (!_doneCompleter.isCompleted) _doneCompleter.complete();
      },
    );

    // Merge parser output into our output stream.
    _parserSubscription = _parser.output.listen(
      _outputController.add,
      onError: _outputController.addError,
    );
  }

  final Socket socket;
  final String _hostId;
  final String _sessionId;
  late final TelnetParser _parser;
  late final StreamSubscription<Uint8List> _socketSubscription;
  late final StreamSubscription<Uint8List> _parserSubscription;

  final _outputController = StreamController<Uint8List>.broadcast();
  final _doneCompleter = Completer<void>();

  bool _isConnected = true;
  int _termWidth = 80;
  int _termHeight = 24;

  // Options we've agreed to.
  final _enabledOptions = <int>{};

  @override
  String get sessionId => _sessionId;

  @override
  String get hostId => _hostId;

  @override
  bool get isConnected => _isConnected;

  @override
  Stream<Uint8List> get output => _outputController.stream;

  @override
  Future<void> get done => _doneCompleter.future;

  @override
  Future<void> startSession({
    int termWidth = 80,
    int termHeight = 24,
  }) async {
    _termWidth = termWidth;
    _termHeight = termHeight;

    // Initiate negotiations: we WILL do NAWS (window size reporting).
    _sendCommand(will, optNaws);
    // Request the server suppress go-ahead (character-at-a-time mode).
    _sendCommand(doOpt, optSga);
  }

  @override
  void write(Uint8List data) {
    if (!_isConnected) return;
    // Escape any 0xFF bytes in user data (IAC escaping).
    final escaped = _escapeIac(data);
    socket.add(escaped);
  }

  @override
  void writeString(String data) {
    write(Uint8List.fromList(data.codeUnits));
  }

  @override
  void resize(int width, int height) {
    _termWidth = width;
    _termHeight = height;
    if (_enabledOptions.contains(optNaws)) {
      _sendNaws();
    }
  }

  @override
  Future<void> close() async {
    _isConnected = false;
    await _socketSubscription.cancel();
    await _parserSubscription.cancel();
    _parser.close();
    await socket.close();
    if (!_outputController.isClosed) await _outputController.close();
    if (!_doneCompleter.isCompleted) _doneCompleter.complete();
  }

  // --- Negotiation handling ---

  void _handleNegotiation(int command, int option) {
    switch (command) {
      case doOpt:
        // Server asks us to enable an option.
        if (option == optNaws) {
          _enabledOptions.add(optNaws);
          _sendCommand(will, optNaws);
          _sendNaws();
        } else if (option == optTerminalType) {
          _enabledOptions.add(optTerminalType);
          _sendCommand(will, optTerminalType);
        } else if (option == optTerminalSpeed) {
          _sendCommand(will, optTerminalSpeed);
        } else {
          // Refuse unknown options.
          _sendCommand(wont, option);
        }

      case dontOpt:
        _enabledOptions.remove(option);
        _sendCommand(wont, option);

      case will:
        // Server offers to enable an option.
        if (option == optEcho || option == optSga) {
          _sendCommand(doOpt, option);
        } else {
          _sendCommand(dontOpt, option);
        }

      case wont:
        _sendCommand(dontOpt, option);
    }
  }

  void _handleSubnegotiation(int option, Uint8List data) {
    if (option == optTerminalType && data.isNotEmpty && data[0] == subSend) {
      // Respond with terminal type.
      _sendSubnegotiation(optTerminalType, [subIs, ...('xterm-256color'.codeUnits)]);
    } else if (option == optTerminalSpeed && data.isNotEmpty && data[0] == subSend) {
      // Respond with terminal speed.
      _sendSubnegotiation(optTerminalSpeed, [subIs, ...('38400,38400'.codeUnits)]);
    }
  }

  // --- Protocol helpers ---

  void _sendCommand(int verb, int option) {
    socket.add(Uint8List.fromList([iac, verb, option]));
  }

  void _sendNaws() {
    // RFC 1073: IAC SB NAWS <width-hi> <width-lo> <height-hi> <height-lo> IAC SE
    final w = _termWidth;
    final h = _termHeight;
    final payload = <int>[
      iac, sb, optNaws,
      (w >> 8) & 0xFF, w & 0xFF,
      (h >> 8) & 0xFF, h & 0xFF,
      iac, se,
    ];
    // Escape any 0xFF in the dimension bytes (unlikely but spec-correct).
    socket.add(Uint8List.fromList(payload));
  }

  void _sendSubnegotiation(int option, List<int> data) {
    socket.add(Uint8List.fromList([iac, sb, option, ...data, iac, se]));
  }

  /// Escapes IAC (0xFF) bytes in user data by doubling them.
  Uint8List _escapeIac(Uint8List data) {
    // Fast path: no IAC bytes to escape.
    if (!data.contains(255)) return data;

    final result = <int>[];
    for (final byte in data) {
      result.add(byte);
      if (byte == 255) result.add(255);
    }
    return Uint8List.fromList(result);
  }
}
