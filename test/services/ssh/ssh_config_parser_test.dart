import 'package:flutter_test/flutter_test.dart';
import 'package:cloudshell/services/ssh/ssh_config_parser.dart';

void main() {
  group('SshConfigParser', () {
    test('parse returns empty list for empty content', () {
      final result = SshConfigParser.parse('');
      expect(result, isEmpty);
    });

    test('parse extracts basic host entry', () {
      const config = '''
Host myserver
  HostName 192.168.1.100
  User admin
  Port 2222
''';
      final result = SshConfigParser.parse(config);
      expect(result, hasLength(1));

      final entry = result.first;
      expect(entry.alias, 'myserver');
      expect(entry.hostname, '192.168.1.100');
      expect(entry.effectiveHostname, '192.168.1.100');
      expect(entry.user, 'admin');
      expect(entry.effectiveUser, 'admin');
      expect(entry.port, 2222);
      expect(entry.effectivePort, 2222);
    });

    test('parse handles multiple hosts', () {
      const config = '''
Host server1
  HostName 10.0.0.1
  User alice

Host server2
  HostName 10.0.0.2
  Port 3333
''';
      final result = SshConfigParser.parse(config);
      expect(result, hasLength(2));

      expect(result[0].alias, 'server1');
      expect(result[0].hostname, '10.0.0.1');
      expect(result[0].user, 'alice');
      expect(result[0].effectivePort, 22);

      expect(result[1].alias, 'server2');
      expect(result[1].hostname, '10.0.0.2');
      expect(result[1].port, 3333);
      expect(result[1].effectiveUser, 'root');
    });

    test('parse strips comments', () {
      const config = '''
# This is a comment
Host commented
  HostName 1.2.3.4
  # User olduser
  User realuser
''';
      final result = SshConfigParser.parse(config);
      expect(result, hasLength(1));

      final entry = result.first;
      expect(entry.alias, 'commented');
      expect(entry.hostname, '1.2.3.4');
      expect(entry.user, 'realuser');
    });

    test('parse skips wildcard entries', () {
      const config = '''
Host *
  ServerAliveInterval 60
  User default

Host actual
  HostName 5.6.7.8
''';
      final result = SshConfigParser.parse(config);
      expect(result, hasLength(1));

      final entry = result.first;
      expect(entry.alias, 'actual');
      expect(entry.hostname, '5.6.7.8');
    });
  });
}
