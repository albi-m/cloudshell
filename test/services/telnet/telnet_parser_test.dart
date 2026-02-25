// Unit tests for the Telnet protocol parser.
//
// Verifies IAC sequence parsing, negotiation callbacks,
// subnegotiation handling, and IAC escaping.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:cloudshell/services/telnet/telnet_constants.dart';
import 'package:cloudshell/services/telnet/telnet_parser.dart';

void main() {
  group('TelnetParser', () {
    late TelnetParser parser;
    late List<Uint8List> outputChunks;
    late List<(int, int)> negotiations;
    late List<(int, Uint8List)> subnegotiations;

    setUp(() {
      negotiations = [];
      subnegotiations = [];
      outputChunks = [];

      parser = TelnetParser(
        onNegotiation: (cmd, opt) => negotiations.add((cmd, opt)),
        onSubnegotiation: (opt, data) => subnegotiations.add((opt, data)),
      );

      parser.output.listen((data) => outputChunks.add(data));
    });

    tearDown(() {
      parser.close();
    });

    test('forwards plain text data unchanged', () {
      parser.add(Uint8List.fromList('Hello, World!'.codeUnits));

      expect(outputChunks.length, 1);
      expect(String.fromCharCodes(outputChunks[0]), 'Hello, World!');
    });

    test('parses IAC WILL ECHO negotiation', () {
      parser.add(Uint8List.fromList([iac, will, optEcho]));

      expect(negotiations.length, 1);
      expect(negotiations[0], (will, optEcho));
      expect(outputChunks, isEmpty);
    });

    test('parses IAC WONT ECHO negotiation', () {
      parser.add(Uint8List.fromList([iac, wont, optEcho]));

      expect(negotiations.length, 1);
      expect(negotiations[0], (wont, optEcho));
    });

    test('parses IAC DO SGA negotiation', () {
      parser.add(Uint8List.fromList([iac, doOpt, optSga]));

      expect(negotiations.length, 1);
      expect(negotiations[0], (doOpt, optSga));
    });

    test('parses IAC DONT negotiation', () {
      parser.add(Uint8List.fromList([iac, dontOpt, optNaws]));

      expect(negotiations.length, 1);
      expect(negotiations[0], (dontOpt, optNaws));
    });

    test('strips IAC sequences from data stream', () {
      // "Hello" + IAC WILL ECHO + " World"
      parser.add(Uint8List.fromList([
        ...('Hello'.codeUnits),
        iac, will, optEcho,
        ...(' World'.codeUnits),
      ]));

      expect(negotiations.length, 1);
      // Output should contain both text chunks
      final allOutput = outputChunks.expand((c) => c).toList();
      expect(String.fromCharCodes(allOutput), 'Hello World');
    });

    test('handles escaped IAC (255 255) as literal byte', () {
      parser.add(Uint8List.fromList([iac, iac]));

      expect(negotiations, isEmpty);
      expect(outputChunks.length, 1);
      expect(outputChunks[0], [255]);
    });

    test('handles subnegotiation (TERMINAL-TYPE SEND)', () {
      parser.add(Uint8List.fromList([
        iac, sb, optTerminalType, subSend, iac, se,
      ]));

      expect(subnegotiations.length, 1);
      expect(subnegotiations[0].$1, optTerminalType);
      expect(subnegotiations[0].$2, [subSend]);
    });

    test('handles subnegotiation with data', () {
      final subData = 'xterm'.codeUnits;
      parser.add(Uint8List.fromList([
        iac, sb, optTerminalType, subIs, ...subData, iac, se,
      ]));

      expect(subnegotiations.length, 1);
      expect(subnegotiations[0].$1, optTerminalType);
      expect(subnegotiations[0].$2, [subIs, ...subData]);
    });

    test('handles escaped IAC inside subnegotiation', () {
      // Subnegotiation data containing 0xFF should be escaped as IAC IAC
      parser.add(Uint8List.fromList([
        iac, sb, optTerminalType, subIs, iac, iac, iac, se,
      ]));

      expect(subnegotiations.length, 1);
      expect(subnegotiations[0].$2, [subIs, 255]); // Escaped IAC → literal 255
    });

    test('handles partial IAC sequences across chunks', () {
      // First chunk ends with IAC
      parser.add(Uint8List.fromList([0x41, iac])); // 'A' + IAC
      // Second chunk completes the negotiation
      parser.add(Uint8List.fromList([will, optEcho]));

      expect(negotiations.length, 1);
      expect(negotiations[0], (will, optEcho));

      final allOutput = outputChunks.expand((c) => c).toList();
      expect(allOutput, [0x41]); // Just 'A'
    });

    test('handles multiple negotiations in one chunk', () {
      parser.add(Uint8List.fromList([
        iac, will, optEcho,
        iac, will, optSga,
        iac, doOpt, optNaws,
      ]));

      expect(negotiations.length, 3);
      expect(negotiations[0], (will, optEcho));
      expect(negotiations[1], (will, optSga));
      expect(negotiations[2], (doOpt, optNaws));
    });

    test('ignores unknown IAC commands', () {
      // IAC NOP (241) — should be silently ignored
      parser.add(Uint8List.fromList([iac, 241, 0x42])); // IAC NOP + 'B'

      expect(negotiations, isEmpty);
      final allOutput = outputChunks.expand((c) => c).toList();
      expect(allOutput, [0x42]); // Just 'B'
    });

    test('handles empty data chunk', () {
      parser.add(Uint8List(0));

      expect(outputChunks, isEmpty);
      expect(negotiations, isEmpty);
    });
  });
}
