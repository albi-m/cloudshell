// Telnet protocol parser (RFC 854).
//
// Strips IAC command sequences from raw socket data and forwards
// clean terminal output. Handles WILL/WONT/DO/DONT negotiations
// and subnegotiations.

import 'dart:async';
import 'dart:typed_data';

import 'telnet_constants.dart';

/// Callback for handling telnet negotiation commands.
typedef NegotiationCallback = void Function(int command, int option);

/// Callback for handling telnet subnegotiation data.
typedef SubnegotiationCallback = void Function(int option, Uint8List data);

/// Parser states for the telnet protocol state machine.
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
/// Forwards clean terminal data to [output] and invokes callbacks
/// for negotiation and subnegotiation events.
class TelnetParser {
  TelnetParser({
    this.onNegotiation,
    this.onSubnegotiation,
  });

  /// Called when a WILL/WONT/DO/DONT command is received.
  final NegotiationCallback? onNegotiation;

  /// Called when a complete subnegotiation is received.
  final SubnegotiationCallback? onSubnegotiation;

  final _outputController = StreamController<Uint8List>(sync: true);

  /// Stream of clean terminal output bytes (IAC sequences stripped).
  Stream<Uint8List> get output => _outputController.stream;

  _State _state = _State.data;
  int _negotiationVerb = 0;
  int _subOption = 0;
  final _subData = <int>[];

  /// Process a chunk of raw bytes from the socket.
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
              // Escaped IAC → literal 255 in data stream.
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
            // Malformed — treat as data and reset.
            _subData.add(byte);
            _state = _State.subData;
          }
      }
    }

    flushData();
  }

  /// Close the parser and its output stream.
  void close() {
    _outputController.close();
  }
}
