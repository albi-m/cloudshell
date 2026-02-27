/// Serial port connection service.
///
/// Creates [SerialSession] instances and provides port enumeration.
/// Only available on desktop platforms (macOS, Windows, Linux).
library;

import 'dart:io';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import 'serial_session.dart';

/// Service for managing serial port connections.
class SerialService {
  /// Lists available serial ports on the system.
  ///
  /// Returns device paths like `/dev/ttyUSB0` (Linux),
  /// `/dev/cu.usbserial-*` (macOS), or `COM3` (Windows).
  static List<String> availablePorts() {
    return SerialPort.availablePorts;
  }

  /// Whether serial port support is available on this platform.
  ///
  /// Serial ports are only supported on desktop platforms.
  /// iOS does not support direct serial port access.
  static bool get isSupported =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  /// Connect to a serial port configured in the host model.
  ///
  /// Reads serial configuration (baud rate, data bits, etc.) from
  /// the host's serial columns. Returns a [SerialSession] implementing
  /// [ConnectionSession].
  Future<SerialSession> connect({required Host host}) async {
    final portName = host.serialPort;
    if (portName == null || portName.isEmpty) {
      throw ArgumentError('No serial port specified for host ${host.label}');
    }

    final port = SerialPort(portName);

    final parity = _parseParity(host.serialParity);
    final flowControl = _parseFlowControl(host.serialFlowControl);

    return SerialSession(
      port: port,
      hostId: host.id,
      baudRate: host.serialBaudRate ?? 115200,
      dataBits: host.serialDataBits ?? 8,
      stopBits: host.serialStopBits ?? 1,
      parity: parity,
      flowControl: flowControl,
    );
  }

  int _parseParity(String? value) => switch (value) {
        'odd' => SerialPortParity.odd,
        'even' => SerialPortParity.even,
        'mark' => SerialPortParity.mark,
        'space' => SerialPortParity.space,
        _ => SerialPortParity.none,
      };

  int _parseFlowControl(String? value) => switch (value) {
        'hardware' => SerialPortFlowControl.rtsCts,
        'software' => SerialPortFlowControl.xonXoff,
        _ => SerialPortFlowControl.none,
      };
}

/// Standard baud rates for serial connections, from 300 to 921600.
///
/// Used to populate the baud rate picker in the host form.
const serialBaudRates = [
  300, 1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600,
];

/// Riverpod provider for the serial service.
final serialServiceProvider = Provider<SerialService>((ref) {
  return SerialService();
});
