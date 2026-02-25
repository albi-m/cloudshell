# CloudShell

**Your servers. Everywhere.**

A cross-platform SSH client with end-to-end encrypted sync, built with Flutter.

[![CI](https://github.com/cloudshell-app/cloudshell/actions/workflows/ci.yml/badge.svg)](https://github.com/cloudshell-app/cloudshell/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Features

- **SSH Terminal** — Full xterm emulator with 256-color, truecolor, Unicode/CJK support
- **Multi-Platform** — macOS, Windows, Linux, iOS, Android from a single codebase
- **SSH Key Management** — Import and store Ed25519, RSA, ECDSA, and PPK keys securely
- **SFTP File Browser** — Dual-pane browser with upload, download, drag-and-drop, remote file editing
- **Command Snippets** — Save commands with variable substitution ({{var}}) and quick-insert
- **Port Forwarding** — Local, remote, and dynamic (SOCKS proxy) SSH tunnels
- **E2E Encrypted Sync** — Zero-knowledge vault sync across all your devices
- **Telnet & Serial** — Telnet (RFC 854) and serial port (300–921600 baud) protocols
- **9+ Terminal Themes** — Built-in themes plus custom theme editor with live preview
- **Broadcast Input** — Send keystrokes to multiple terminal sessions simultaneously
- **Workspaces** — Save and restore terminal tab layouts with auto-save
- **Command Palette** — Fuzzy search hosts, snippets, and actions (Cmd+K)
- **Split Panes** — Horizontal and vertical terminal splits with resizable dividers
- **i18n** — 7 languages: English, Spanish, German, French, Japanese, Chinese, Korean
- **Cloud Import** — Import hosts from AWS EC2 and DigitalOcean
- **Adaptive Layout** — Sidebar navigation on desktop, bottom tabs on mobile
- **Biometric Unlock** — Face ID, Touch ID, fingerprint authentication
- **iPad Multitasking** — Split View and Slide Over support

## Screenshots

<!-- Add screenshots here -->

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.38+ (Dart 3.10+) |
| SSH | dartssh2 |
| Terminal | xterm.dart |
| State | Riverpod |
| Database | Drift + SQLite (sqlite3_flutter_libs) |
| Secure Storage | AES-256-GCM encrypted database |
| Crypto | AES-256-GCM, Argon2id, HKDF-SHA256 |
| Navigation | GoRouter |
| UI Font | Plus Jakarta Sans (bundled) |
| Terminal Font | JetBrains Mono (bundled) |
| Icons | Lucide |

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.38 or later
- Xcode 15+ (for macOS/iOS builds)
- Android Studio (for Android builds)
- Visual Studio 2022+ with C++ workload (for Windows builds)

### Setup

```bash
# Clone the repository
git clone https://github.com/cloudshell-app/cloudshell.git
cd cloudshell

# Install dependencies
flutter pub get

# Generate code (Drift database, Freezed models)
dart run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n

# Run on your platform
flutter run -d macos      # macOS
flutter run -d windows    # Windows
flutter run -d linux      # Linux
flutter run -d ios        # iOS Simulator
flutter run -d android    # Android Emulator
```

### Building for Release

```bash
# macOS
flutter build macos --release

# iOS
flutter build ios --release

# Android
flutter build apk --release          # APK
flutter build appbundle --release     # AAB (Play Store)

# Windows
flutter build windows --release

# Linux (requires: clang, cmake, ninja-build, pkg-config, libgtk-3-dev, libserialport-dev)
sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev libserialport-dev
flutter build linux --release
```

### Running Tests

```bash
# Unit and widget tests
flutter test

# Integration tests (macOS)
flutter test integration_test/app_test.dart -d macos

# Static analysis
flutter analyze --no-fatal-infos
```

### Project Structure

```
lib/
  main.dart                  # App entry point
  app.dart                   # MaterialApp + theme + router + i18n
  l10n/                      # Localization ARB files (7 languages)
  core/
    constants/               # App constants, routes, storage keys
    theme/                   # Colors, typography, terminal themes
    extensions/              # BuildContext & String extensions
    utils/                   # Validators, formatters, platform utils
    errors/                  # Typed exception hierarchy
  data/
    database/                # Drift tables, DAOs, migrations
  services/
    ssh/                     # SSH connection, key import, PPK parser
    sftp/                    # SFTP file operations
    telnet/                  # Telnet protocol (RFC 854)
    serial/                  # Serial port communication
    crypto/                  # Vault encryption, KDF
    sync/                    # Cloud sync orchestration
    auth/                    # Authentication, biometrics
    port_forwarding/         # SSH tunnel management
    cloud_import/            # AWS EC2 & DigitalOcean importers
    terminal/                # Session logging
  providers/                 # Riverpod state providers
  ui/
    shared/                  # Adaptive scaffold, command palette, shortcuts
    hosts/                   # Host list, forms, groups, quick connect
    terminal/                # Terminal emulator, tabs, broadcast, search
    keys/                    # SSH key management & import
    sftp/                    # SFTP file browser, remote editor
    snippets/                # Command snippets
    settings/                # App settings, cloud import wizards
    port_forwarding/         # Port forwarding rules
    auth/                    # Login, signup, TOTP setup
    vault/                   # Master password, vault unlock
    tools/                   # Password generator, session logs
    onboarding/              # First-launch onboarding
  router/                    # GoRouter configuration
```

## Security

CloudShell takes security seriously:

- **Zero-knowledge encryption** — Server never sees plaintext data
- **Argon2id KDF** — Memory-hard key derivation (64MB, 3 iterations)
- **AES-256-GCM** — Authenticated encryption for all vault items
- **Per-item encryption keys** — Compromise of one item doesn't expose others
- **Platform secure storage** — Private keys stored in OS keychain
- **Database encryption** — Sensitive data encrypted at rest
- **Host key verification** — TOFU model with fingerprint pinning
- **TOTP 2FA** — Two-factor authentication for cloud accounts

See [SECURITY.md](SECURITY.md) for vulnerability reporting and [docs/05-SECURITY-PLAN.md](docs/05-SECURITY-PLAN.md) for the full threat model.

## Documentation

| Document | Description |
|----------|-------------|
| [Feature List](docs/02-FEATURE-LIST.md) | 95 features across 12 categories |
| [Development Plan](docs/04-DEVELOPMENT-PLAN.md) | 5-phase implementation roadmap |
| [Security Plan](docs/05-SECURITY-PLAN.md) | Threat model, encryption spec |
| [Design System](reference/design-system/DESIGN-SYSTEM.md) | Colors, typography, components |
| [Architecture](reference/architecture/ARCHITECTURE.md) | Data models, system architecture |
| [Wireframes](reference/wireframes/WIREFRAMES.md) | Screen layouts for all views |

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

[MIT](LICENSE)
