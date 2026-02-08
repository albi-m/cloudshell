# CloudShell

**Your servers. Everywhere.**

A cross-platform SSH client with end-to-end encrypted sync, built with Flutter.

## Features

- **SSH Terminal** — Full terminal emulator with xterm.dart (60fps rendering)
- **Multi-Platform** — macOS, Windows, iOS, Android, Linux from a single codebase
- **SSH Key Management** — Generate, import, and store Ed25519/RSA/ECDSA keys
- **SFTP File Browser** — Browse, upload, download files on remote servers
- **Command Snippets** — Save and reuse frequently used commands
- **Port Forwarding** — Local, remote, and dynamic (SOCKS) SSH tunnels
- **E2E Encrypted Sync** — Zero-knowledge sync across all your devices
- **9 Terminal Themes** — CloudShell Default, Dracula, Nord, Solarized Dark, One Dark, Catppuccin Mocha, Tokyo Night, Gruvbox Dark, Monokai Pro
- **Adaptive Layout** — Sidebar navigation on desktop, bottom tabs on mobile
- **Biometric Unlock** — Face ID, Touch ID, fingerprint authentication
- **Self-Hostable** — Optional self-hosted sync server

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart) |
| SSH | dartssh2 |
| Terminal | xterm.dart |
| State | Riverpod |
| Database | Drift + SQLCipher |
| Secure Storage | flutter_secure_storage (Keychain/Keystore/DPAPI) |
| Crypto | AES-256-GCM, Argon2id, HKDF-SHA256 |
| Navigation | GoRouter |
| UI Font | Inter |
| Terminal Font | JetBrains Mono |
| Icons | Lucide |

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.x or later
- Xcode (for macOS/iOS)
- Android Studio (for Android)
- Visual Studio (for Windows)

### Setup

```bash
# Clone the repository
git clone <repo-url>
cd cloudshell

# Install dependencies
flutter pub get

# Generate code (Drift database, Freezed models)
dart run build_runner build --delete-conflicting-outputs

# Run on macOS
flutter run -d macos

# Run on iOS Simulator
flutter run -d ios

# Run on Android Emulator
flutter run -d android
```

### Project Structure

```
lib/
  main.dart                  # App entry point
  app.dart                   # MaterialApp + theme + router
  core/
    constants/               # App constants, routes, storage keys
    theme/                   # Colors, typography, themes
    extensions/              # BuildContext & String extensions
    utils/                   # Validators, formatters, platform utils
    errors/                  # Typed exception hierarchy
  data/
    database/                # Drift tables, DAOs, migrations
    models/                  # Freezed data models
    repositories/            # Data access abstraction
  services/
    ssh/                     # SSH connection management
    sftp/                    # SFTP file operations
    crypto/                  # Vault encryption, KDF
    sync/                    # Cloud sync orchestration
    auth/                    # Authentication, biometrics
  providers/                 # Riverpod state providers
  ui/
    shared/                  # Reusable widgets
    hosts/                   # Host list & forms
    terminal/                # Terminal emulator screen
    keys/                    # SSH key management
    sftp/                    # SFTP file browser
    snippets/                # Command snippets
    settings/                # App settings
  router/                    # GoRouter configuration
```

## Security

CloudShell takes security seriously:

- **Zero-knowledge encryption** — Server never sees plaintext data
- **Argon2id KDF** — Memory-hard key derivation (64MB, 3 iterations)
- **AES-256-GCM** — Authenticated encryption for all vault items
- **Per-item encryption keys** — Compromise of one item doesn't expose others
- **Platform secure storage** — Private keys stored in OS keychain
- **SQLCipher** — Database encrypted at rest
- **Host key verification** — TOFU model with fingerprint pinning

See [docs/05-SECURITY-PLAN.md](docs/05-SECURITY-PLAN.md) for the full threat model and security architecture.

## Documentation

| Document | Description |
|----------|-------------|
| [App Overview](docs/01-APP-OVERVIEW.md) | Vision, competitive analysis, business model |
| [Feature List](docs/02-FEATURE-LIST.md) | 95 features across 12 categories |
| [Navigation Flow](docs/03-NAVIGATION-FLOW.md) | Screen flow, shortcuts, gestures |
| [Development Plan](docs/04-DEVELOPMENT-PLAN.md) | 5-phase implementation roadmap |
| [Security Plan](docs/05-SECURITY-PLAN.md) | Threat model, encryption spec, compliance |
| [Documentation Plan](docs/06-DOCUMENTATION-PLAN.md) | Documentation strategy and standards |
| [Design System](reference/design-system/DESIGN-SYSTEM.md) | Colors, typography, components |
| [Wireframes](reference/wireframes/WIREFRAMES.md) | ASCII wireframes for all screens |
| [Architecture](reference/architecture/ARCHITECTURE.md) | Data models, system architecture |
| [Mobile UX Guide](reference/design-system/MOBILE-UX-GUIDE.md) | Touch gestures, extra keyboard row |

## License

Proprietary. All rights reserved.
