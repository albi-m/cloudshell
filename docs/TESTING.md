# Testing

CloudShell uses Flutter's built-in test framework with Riverpod provider overrides and in-memory Drift databases. Tests are organized by layer: data, services, providers, and UI.

## Test Strategy

**Unit tests** cover providers, services, and DAOs. Each test creates an isolated `ProviderContainer` with overrides and an in-memory database, verifying behavior without touching the filesystem or network.

**Widget tests** cover screen-level rendering and interaction. They use a shared `buildTestApp` helper that wraps widgets in `ProviderScope` + `MaterialApp` with localization delegates, allowing provider injection via overrides.

**Integration tests** live in `integration_test/` and run on real devices or emulators for end-to-end verification of SSH connections and terminal rendering.

## Running Tests

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/providers/group_provider_test.dart

# Run with coverage report
flutter test --coverage

# Run tests matching a name pattern
flutter test --name "emits inserted groups"
```

Coverage output lands in `coverage/lcov.info`. Use `genhtml` or a VS Code extension to view the HTML report.

Before running tests, ensure generated code is up to date:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Test Structure

```
test/
  core/
    error_handler_test.dart        # AppException and ErrorHandler
  data/
    host_dao_test.dart             # Host CRUD via Drift DAO
    settings_dao_test.dart         # Settings key-value storage
    snippet_dao_test.dart          # Snippet CRUD via Drift DAO
  helpers/
    test_database.dart             # In-memory AppDatabase factory
    widget_test_helpers.dart       # buildTestApp wrapper
  providers/
    app_lock_provider_test.dart    # Biometric lock state machine
    biometric_rate_limit_test.dart # Rate limiting logic
    group_provider_test.dart       # Group CRUD + ordering
    known_host_provider_test.dart  # Host key verification state
    port_forward_provider_test.dart
    settings_provider_test.dart    # Settings read/write
    sidebar_provider_test.dart     # Sidebar collapse state
    workspace_provider_test.dart   # Workspace save/restore
  services/
    crypto/
      vault_crypto_test.dart       # Argon2id + AES-256-GCM
    data/
      data_export_import_test.dart # JSON export/import round-trip
    ssh/
      ppk_parser_test.dart         # PPK v2 format parsing
      ssh_config_parser_test.dart  # ~/.ssh/config parsing
      ssh_service_test.dart        # SSH connection mocks
    secure_storage_test.dart
    ssh_host_key_verification_test.dart
    serial/serial_config_test.dart
    telnet/telnet_parser_test.dart
  ui/
    hosts/hosts_screen_test.dart
    keys/keys_screen_test.dart
    onboarding/onboarding_screen_test.dart
    settings/settings_screen_test.dart
    snippets/snippets_screen_test.dart
  widgets/
    radio_group_test.dart          # RadioGroup widget behavior
  widget_test.dart                 # Smoke test (app launches)
```

## Testing Patterns

**In-memory database** -- `test/helpers/test_database.dart` exposes `createTestDatabase()`, which returns an `AppDatabase` backed by `NativeDatabase.memory()`. Each test gets a fresh instance; `tearDown` closes it.

**Provider overrides** -- Tests create a `ProviderContainer` and override `databaseProvider` with the in-memory database. Other providers that depend on it resolve automatically:

```dart
final container = ProviderContainer(overrides: [
  databaseProvider.overrideWithValue(db),
]);
addTearDown(container.dispose);

container.listen(allGroupsProvider, (_, _) {});
final groups = await container.read(allGroupsProvider.future);
expect(groups, isEmpty);
```

**Widget test helper** -- `test/helpers/widget_test_helpers.dart` provides `buildTestApp()`, which wraps any widget in `ProviderScope` and `MaterialApp` with localization support:

```dart
await tester.pumpWidget(buildTestApp(
  child: const HostsScreen(),
  overrides: [databaseProvider.overrideWithValue(db)],
));
```

**Async providers** -- For `StreamProvider` or `FutureProvider`, call `container.listen()` before `container.read()` to ensure the provider is active and emitting values.

## CI

GitHub Actions runs on every push to `main`/`develop` and on all pull requests (`.github/workflows/ci.yml`). The pipeline has two gating jobs:

1. **Analyze** -- `flutter analyze --no-fatal-infos --no-fatal-warnings`
2. **Test** -- `flutter test --coverage` (coverage artifact uploaded, retained 14 days)

Both jobs run code generation (`build_runner build` + `flutter gen-l10n`) before analysis or tests. Platform builds (macOS, Linux, Windows, Android, iOS) run only after Analyze and Test pass.
