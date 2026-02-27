import 'package:flutter_test/flutter_test.dart';
import 'package:cloudshell/services/ssh/ppk_parser.dart';

void main() {
  group('PpkParser', () {
    test('isPpkFormat returns true for valid PPK v2 header', () {
      const ppkContent = 'PuTTY-User-Key-File-2: ssh-rsa\n'
          'Encryption: none\n'
          'Comment: test@host\n'
          'Public-Lines: 1\n'
          'AAAA\n'
          'Private-Lines: 1\n'
          'BBBB\n'
          'Private-MAC: abcdef\n';

      expect(PpkParser.isPpkFormat(ppkContent), isTrue);
    });

    test('isPpkFormat returns false for non-PPK content', () {
      const nonPpk = '-----BEGIN RSA PRIVATE KEY-----\nMIIE...\n';

      expect(PpkParser.isPpkFormat(nonPpk), isFalse);
    });

    test('convertToPem throws for empty content', () {
      expect(
        () => PpkParser.convertToPem(''),
        throwsA(isA<PpkException>()),
      );
    });

    test('convertToPem throws for PPK v3 format', () {
      const v3Content = 'PuTTY-User-Key-File-3: ssh-rsa\n';

      expect(
        () => PpkParser.convertToPem(v3Content),
        throwsA(isA<PpkException>().having(
          (e) => e.message,
          'message',
          contains('v3'),
        )),
      );
    });

    test('convertToPem throws for encrypted PPK keys', () {
      const encryptedContent = 'PuTTY-User-Key-File-2: ssh-rsa\n'
          'Encryption: aes256-cbc\n'
          'Comment: test\n'
          'Public-Lines: 1\n'
          'AAAA\n'
          'Private-Lines: 1\n'
          'BBBB\n'
          'Private-MAC: abcdef\n';

      expect(
        () => PpkParser.convertToPem(encryptedContent),
        throwsA(isA<PpkException>().having(
          (e) => e.message,
          'message',
          contains('encrypted'),
        )),
      );
    });
  });
}
