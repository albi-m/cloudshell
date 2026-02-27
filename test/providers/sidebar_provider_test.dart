import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudshell/providers/sidebar_provider.dart';

void main() {
  group('sidebarCollapsedProvider', () {
    test('defaults to false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(sidebarCollapsedProvider), isFalse);
    });

    test('can be toggled to true', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(sidebarCollapsedProvider.notifier).state = true;
      expect(container.read(sidebarCollapsedProvider), isTrue);
    });

    test('can be toggled back to false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(sidebarCollapsedProvider.notifier).state = true;
      expect(container.read(sidebarCollapsedProvider), isTrue);
      container.read(sidebarCollapsedProvider.notifier).state = false;
      expect(container.read(sidebarCollapsedProvider), isFalse);
    });

    test('multiple toggles maintain correct state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Toggle several times
      for (var i = 0; i < 5; i++) {
        container.read(sidebarCollapsedProvider.notifier).state = true;
        expect(container.read(sidebarCollapsedProvider), isTrue);
        container.read(sidebarCollapsedProvider.notifier).state = false;
        expect(container.read(sidebarCollapsedProvider), isFalse);
      }
    });

    test('independent containers have independent state', () {
      final container1 = ProviderContainer();
      final container2 = ProviderContainer();
      addTearDown(container1.dispose);
      addTearDown(container2.dispose);

      container1.read(sidebarCollapsedProvider.notifier).state = true;
      expect(container1.read(sidebarCollapsedProvider), isTrue);
      expect(container2.read(sidebarCollapsedProvider), isFalse);
    });
  });
}
