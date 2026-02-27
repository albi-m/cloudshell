import 'package:flutter_test/flutter_test.dart';
import 'package:cloudshell/services/data/data_export_service.dart';

void main() {
  group('DataExportService', () {
    test('ImportResult summary with no imports', () {
      const result = ImportResult();
      expect(result.summary, 'No new data to import');
    });

    test('ImportResult summary with data', () {
      const result = ImportResult(hostsImported: 2, groupsImported: 1);
      expect(result.summary, contains('2 hosts'));
      expect(result.summary, contains('1 groups'));
    });

    test('ImportResult hasError returns true when error is set', () {
      const result = ImportResult(error: 'File not found');
      expect(result.hasError, isTrue);
    });

    test('ImportResult totalImported sums all fields', () {
      const result = ImportResult(
        hostsImported: 3,
        groupsImported: 2,
        snippetsImported: 5,
        portForwardsImported: 1,
        keysImported: 4,
        settingsImported: 6,
        secretsImported: 7,
      );
      expect(result.totalImported, 28);
    });

    test('isEncryptedExport returns true for encrypted format', () {
      expect(
        DataExportService.isEncryptedExport('{"format":"encrypted"}'),
        isTrue,
      );
    });

    test('isEncryptedExport returns false for plain format', () {
      expect(
        DataExportService.isEncryptedExport('{"version":1}'),
        isFalse,
      );
    });

    test('isEncryptedExport returns false for invalid JSON', () {
      expect(
        DataExportService.isEncryptedExport('not json'),
        isFalse,
      );
    });
  });
}
