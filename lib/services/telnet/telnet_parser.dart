/// Telnet protocol parser (RFC 854).
///
/// Strips IAC command sequences from raw socket data and forwards
/// clean terminal output. Handles WILL/WONT/DO/DONT negotiations
/// and subnegotiations.
library;

import 'dart:async';
import 'dart:typed_data';

import 'telnet_constants.dart';

/// Callback for handling telnet negotiation commands.
typedef NegotiationCallback = void Function(int command, int option);

/// Callback for handling telnet subnegotiation data.
typedef SubnegotiationCallback = void Function(int option, Uint8List data);

// Why a state machine: telnet mixes terminal data and protocol commands in a
// single byte stream. IAC (0xFF) is the escape byte — everything after it is a
// protocol command, not printable data. A state machine is the only reliable way
// to separate the two without buffering the entire stream, because commands can
// span multiple TCP packets and arrive at arbitrary chunk boundaries.
enum _State {
  /// Normal data flow — bytes are terminal output.
  data,

  /// Received IAC byte, waiting for command byte.
  iac,

  /// Received IAC + negotiation verb, waiting for option byte.
  negotiation,

  /// Inside a subnegotiation, collecting option byte.
  subOption,

  /// Inside subnegotiation, collecting data bytes.
  subData,

  /// Inside subnegotiation, received IAC — may be SE or escaped 255.
  subIac,
}

/// Processes raw telnet socket bytes, stripping protocol sequences.
///
/// Uses a 6-state machine to separate terminal data from protocol commands:
///
/// - **data**: Default state. Bytes pass through as terminal output until
///   an IAC (0xFF) byte is encountered.
/// - **iac**: After IAC. The next byte determines the command type:
///   double-IAC means literal 0xFF; WILL/WONT/DO/DONT enters negotiation;
///   SB enters subnegotiation; other commands (NOP, BRK) are discarded.
/// - **negotiation**: After IAC + verb. The next byte is the option code,
///   which is delivered via [onNegotiation].
/// - **subOption**: After IAC SB. The next byte is the subnegotiation
///   option code.
/// - **subData**: Collecting subnegotiation payload bytes until IAC.
/// - **subIac**: IAC inside subnegotiation. SE ends it and delivers
///   the payload via [onSubnegotiation]; double-IAC is a literal 0xFF.
///
/// Forwards clean terminal data to [output] and invokes callbacks
/// for negotiation and subnegotiation events.
class TelnetParser {
  /// Creates a parser with optional negotiation callbacks.
  TelnetParser({
    this.onNegotiation,
    this.onSubnegotiation,
  });

  // Why negotiation callback: WILL/WONT/DO/DONT commands let client and server
  // agree on optional features (echo, terminal type, window size). Without
  // responding correctly, many servers refuse to send a login prompt or display
  // garbled output because they assume a dumb terminal.
  final NegotiationCallback? onNegotiation;

  // Why subnegotiation callback: after agreeing on an option (e.g., NAWS for
  // window size), the actual parameter data is exchanged inside IAC SB...SE
  // subnegotiation blocks. The parser collects the payload and delivers it to
  // the handler, which can then send the terminal dimensions to the server.
  final SubnegotiationCallback? onSubnegotiation;

  // Why sync: true: a synchronous controller delivers data immediately in the
  // current microtask, avoiding event-loop latency. For a terminal, even a
  // single-frame delay between receiving bytes and rendering them is visible
  // as input lag, so synchronous delivery is essential for responsiveness.
  final _outputController = StreamController<Uint8List>(sync: true);

  /// Stream of clean terminal output bytes (IAC sequences stripped).
  Stream<Uint8List> get output => _outputController.stream;

  _State _state = _State.data;
  int _negotiationVerb = 0;
  int _subOption = 0;
  final _subData = <int>[];

  /// Processes a chunk of raw bytes from the TCP socket.
  ///
  /// Feeds each byte through the state machine. Terminal data bytes are
  /// buffered and flushed to [output] when a protocol sequence interrupts
  /// the data flow or when the chunk ends.
  void add(Uint8List chunk) {
    final dataBuffer = <int>[];

    void flushData() {
      if (dataBuffer.isNotEmpty) {
        _outputController.add(Uint8List.fromList(dataBuffer));
        dataBuffer.clear();
      }
    }

    for (final byte in chunk) {
      switch (_state) {
        case _State.data:
          if (byte == iac) {
            _state = _State.iac;
          } else {
            dataBuffer.add(byte);
          }

        case _State.iac:
          switch (byte) {
            case iac:
              // Why escaped IAC: since 0xFF is reserved as IAC, the protocol
              // requires sending IAC IAC (two 0xFF bytes) to represent a literal
              // 255 in the data stream. Without this, binary data containing
              // 0xFF would be misinterpreted as protocol commands.
              dataBuffer.add(255);
              _state = _State.data;
            case will || wont || doOpt || dontOpt:
              _negotiationVerb = byte;
              _state = _State.negotiation;
            case sb:
              _state = _State.subOption;
            case se:
              // Unexpected SE without SB — ignore and reset.
              _state = _State.data;
            default:
              // Other IAC commands (NOP, BRK, etc.) — ignore.
              _state = _State.data;
          }

        case _State.negotiation:
          // Why flush before callback: pending terminal data must be delivered
          // before the negotiation response, preserving byte ordering so the
          // terminal renderer sees data in the same sequence the server sent it.
          flushData();
          onNegotiation?.call(_negotiationVerb, byte);
          _state = _State.data;

        case _State.subOption:
          _subOption = byte;
          _subData.clear();
          _state = _State.subData;

        case _State.subData:
          if (byte == iac) {
            _state = _State.subIac;
          } else {
            _subData.add(byte);
          }

        case _State.subIac:
          if (byte == se) {
            // End of subnegotiation.
            flushData();
            onSubnegotiation?.call(
              _subOption,
              Uint8List.fromList(_subData),
            );
            _subData.clear();
            _state = _State.data;
          } else if (byte == iac) {
            // Escaped IAC inside subnegotiation data.
            _subData.add(255);
            _state = _State.subData;
          } else {
            // Why tolerate malformed sequences: real-world telnet servers
            // sometimes emit non-conforming byte patterns. Treating unexpected
            // bytes as subnegotiation data (rather than throwing) keeps the
            // connection alive and lets the session recover gracefully.
            _subData.add(byte);
            _state = _State.subData;
          }
      }
    }

    flushData();
  }

  /// Closes the parser and its output stream.
  ///
  /// After calling this, no further data should be passed to [add].
  void close() {
    _outputController.close();
  }
}
