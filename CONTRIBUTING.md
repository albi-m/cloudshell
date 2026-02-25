# Contributing to CloudShell

Thank you for considering contributing to CloudShell! This document outlines the process for contributing to the project.

## Development Setup

### Prerequisites

- Flutter 3.38+ (stable channel)
- Dart SDK 3.10+
- macOS, Windows, or Linux for desktop builds
- Xcode (for macOS/iOS builds)
- Android Studio (for Android builds)

### Getting Started

```bash
# Clone the repository
git clone https://github.com/cloudshell-app/cloudshell.git
cd cloudshell

# Install dependencies
flutter pub get

# Run code generation (Drift database, Riverpod, Freezed)
dart run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n

# Run the app
flutter run -d macos    # macOS
flutter run -d windows  # Windows
flutter run -d linux    # Linux
```

### Running Tests

```bash
# Unit and widget tests
flutter test

# Integration tests (macOS)
flutter test integration_test/app_test.dart -d macos

# Analysis
flutter analyze
```

## Branch Strategy

- `main` — stable release branch
- `develop` — integration branch for upcoming releases
- `feature/*` — feature branches (branch from `develop`)
- `fix/*` — bug fix branches (branch from `develop`)

## Pull Request Process

1. Fork the repository and create your branch from `develop`.
2. Write or update tests for your changes.
3. Ensure `flutter analyze` reports no new issues.
4. Ensure `flutter test` passes all tests.
5. Update documentation if your change affects public APIs or user-facing behavior.
6. Submit a pull request with a clear description of changes.

## Code Style

- Follow the [Dart style guide](https://dart.dev/effective-dart/style).
- Use `flutter_lints` rules (already configured in `analysis_options.yaml`).
- Keep files focused — one class/widget per file when practical.
- Use Riverpod for state management (providers, notifiers).
- Use Drift for database access (DAOs, companions).

## Architecture Overview

```
lib/
  core/          # Constants, theme, utilities, error handling
  data/          # Database tables, DAOs, models
  providers/     # Riverpod state providers
  router/        # GoRouter navigation
  services/      # Business logic (SSH, Telnet, Serial, SFTP, crypto)
  ui/            # Screens and widgets organized by feature
```

## Commit Messages

- Use imperative mood: "Add feature" not "Added feature"
- Keep the first line under 72 characters
- Reference issue numbers when applicable: "Fix #123: Handle null host"

## Reporting Issues

- Use GitHub Issues for bug reports and feature requests
- Include steps to reproduce for bugs
- Include Flutter/Dart version (`flutter doctor -v`)
- Include platform and OS version

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
