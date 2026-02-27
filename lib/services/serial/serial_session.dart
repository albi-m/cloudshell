/// Serial port connection session implementing [ConnectionSession].
///
/// Wraps flutter_libserialport for reading/writing to serial devices.
/// Terminal resize is a no-op since serial ports have no concept of
/// window dimensions.
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:uuid/uuid.dart';

import '../connection/connection_session.dart';

/// A serial port connection session.
///
/// Opens a local serial port device and provides bidirectional
/// data streaming compatible with the terminal tab provider.
class SerialSession implements ConnectionSession {
  /// Creates a serial session bound to the given [port].
  ///
  /// Serial parameters default to the most common configuration:
  /// 115200 baud, 8 data bits, 1 stop bit, no parity, no flow control.
  SerialSession({
    required this.port,
    required String hostId,
    this.baudRate = 115200,
    this.dataBits = 8,
    this.stopBits = 1,
    this.parity = SerialPortParity.none,
    this.flowControl = SerialPortFlowControl.none,
  })  : _hostId = hostId,
        _sessionId = const Uuid().v4();

  /// The underlying serial port handle from flutter_libserialport.
  final SerialPort port;
  final String _hostId;
  final String _sessionId;

  /// Communication speed in bits per second (e.g. 9600, 115200).
  final int baudRate;

  /// Number of data bits per frame (typically 7 or 8).
  final int dataBits;

  /// Number of stop bits per frame (typically 1 or 2).
  final int stopBits;

  /// Parity checking mode (none, odd, even, mark, or space).
  final int parity;

  /// Flow control mode (none, hardware RTS/CTS, or software XON/XOFF).
  final int flowControl;

  SerialPortReader? _reader;
  final _outputController = StreamController<Uint8List>.broadcast();
  final _doneCompleter = Completer<void>();
  bool _isConnected = false;

  @override
  String get sessionId => _sessionId;

  @override
  String get hostId => _hostId;

  @override
  bool get isConnected => _isConnected;

  /// Stream of raw bytes read from the serial port.
  @override
  Stream<Uint8List> get output => _outputController.stream;

  /// Completes when the serial port connection closes or encounters an error.
  @override
  Future<void> get done => _doneCompleter.future;

  /// Opens the serial port with the configured parameters and begins reading.
  ///
  /// The [termWidth] and [termHeight] parameters are accepted for interface
  /// compatibility but ignored — serial ports have no window size concept.
  @override
  Future<void> startSession({
    int termWidth = 80,
    int termHeight = 24,
  }) async {
    // Configure port parameters.
    final config = port.config;
    config.baudRate = baudRate;
    config.bits = dataBits;
    config.stopBits = stopBits;
    config.parity = parity;
    config.setFlowControl(flowControl);
    port.config = config;

    // Open the port.
    if (!port.openReadWrite()) {
      throw SocketException(
        'Failed to open serial port ${port.name}: ${SerialPort.lastError}',
      );
    }

    _isConnected = true;

    // Start reading from the port.
    _reader = SerialPortReader(port);
    _reader!.stream.listen(
      (data) {
        _outputController.add(Uint8List.fromList(data));
      },
      onError: (Object error) {
        _isConnected = false;
        _outputController.addError(error);
      },
      onDone: () {
        _isConnected = false;
        if (!_outputController.isClosed) _outputController.close();
        if (!_doneCompleter.isCompleted) _doneCompleter.complete();
      },
    );
  }

  /// Writes raw bytes to the serial port.
  @override
  void write(Uint8List data) {
    if (!_isConnected) return;
    port.write(data);
  }

  /// Writes a string to the serial port using its code unit bytes.
  @override
  void writeString(String data) {
    write(Uint8List.fromList(data.codeUnits));
  }

  /// No-op: serial ports have no concept of terminal window dimensions.
  @override
  void resize(int width, int height) {
    // No-op: serial ports don't support terminal window sizing.
  }

  /// Closes the serial port and releases all resources.
  @override
  Future<void> close() async {
    _isConnected = false;
    _reader?.close();
    port.close();
    if (!_outputController.isClosed) await _outputController.close();
    if (!_doneCompleter.isCompleted) _doneCompleter.complete();
  }
}
