// Verifies that RadioGroup<T> is available from Flutter SDK (3.38+)
// and functions correctly with RadioListTile children.
//
// BF-005: Confirm RadioGroup is a real Flutter widget, not a custom one.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RadioGroup<T> widget verification', () {
    testWidgets('RadioGroup renders with RadioListTile children',
        (tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RadioGroup<String>(
              groupValue: 'a',
              onChanged: (value) => selectedValue = value,
              child: const Column(
                children: [
                  RadioListTile<String>(
                    title: Text('Option A'),
                    value: 'a',
                  ),
                  RadioListTile<String>(
                    title: Text('Option B'),
                    value: 'b',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify both options render
      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);

      // Tap Option B to change selection
      await tester.tap(find.text('Option B'));
      await tester.pump();

      expect(selectedValue, 'b');
    });

    testWidgets('RadioGroup works with int type', (tester) async {
      int? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RadioGroup<int>(
              groupValue: 0,
              onChanged: (value) => selectedValue = value,
              child: const Column(
                children: [
                  RadioListTile<int>(
                    title: Text('Zero'),
                    value: 0,
                  ),
                  RadioListTile<int>(
                    title: Text('Thirty'),
                    value: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Zero'), findsOneWidget);
      expect(find.text('Thirty'), findsOneWidget);

      await tester.tap(find.text('Thirty'));
      await tester.pump();

      expect(selectedValue, 30);
    });
  });
}
