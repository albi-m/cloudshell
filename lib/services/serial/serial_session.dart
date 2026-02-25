// Serial port connection session implementing ConnectionSession.
//
// Wraps flutter_libserialport for reading/writing to serial devices.
// Terminal resize is a no-op since serial ports have no concept of
// window dimensions.

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

  final SerialPort port;
  final String _hostId;
  final String _sessionId;
  final int baudRate;
  final int dataBits;
  final int stopBits;
  final int parity;
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

  @override
  Stream<Uint8List> get output => _outputController.stream;

  @override
  Future<void> get done => _doneCompleter.future;

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

  @override
  void write(Uint8List data) {
    if (!_isConnected) return;
    port.write(data);
  }

  @override
  void writeString(String data) {
    write(Uint8List.fromList(data.codeUnits));
  }

  @override
  void resize(int width, int height) {
    // No-op: serial ports don't support terminal window sizing.
  }

  @override
  Future<void> close() async {
    _isConnected = false;
    _reader?.close();
    port.close();
    if (!_outputController.isClosed) await _outputController.close();
    if (!_doneCompleter.isCompleted) _doneCompleter.complete();
  }
}
