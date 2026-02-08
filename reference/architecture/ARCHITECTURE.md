# CloudShell - Technical Architecture & Data Models

---

## 1. System Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          CLIENT (Flutter App)                          │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                         UI LAYER                                  │  │
│  │  ┌──────────┐ ┌──────────┐ ┌─────────┐ ┌────────┐ ┌──────────┐  │  │
│  │  │ Screens  │ │ Widgets  │ │ Dialogs │ │ Themes │ │ Adaptive │  │  │
│  │  │ (Pages)  │ │(Reusable)│ │ (Modal) │ │ Engine │ │ Layout   │  │  │
│  │  └──────────┘ └──────────┘ └─────────┘ └────────┘ └──────────┘  │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                              │                                          │
│  ┌───────────────────────────▼───────────────────────────────────────┐  │
│  │                     STATE MANAGEMENT (Riverpod)                   │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌───────────────────────────┐ │  │
│  │  │ Connection   │ │ Vault        │ │ Terminal State            │ │  │
│  │  │ Provider     │ │ Provider     │ │ Provider                  │ │  │
│  │  └──────────────┘ └──────────────┘ └───────────────────────────┘ │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌───────────────────────────┐ │  │
│  │  │ Host         │ │ Key          │ │ Settings                  │ │  │
│  │  │ Provider     │ │ Provider     │ │ Provider                  │ │  │
│  │  └──────────────┘ └──────────────┘ └───────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                              │                                          │
│  ┌───────────────────────────▼───────────────────────────────────────┐  │
│  │                      SERVICE LAYER                                │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌───────────────────────────┐ │  │
│  │  │ SSH Service  │ │ SFTP Service │ │ Port Forwarding Service   │ │  │
│  │  │ (dartssh2)   │ │ (dartssh2)   │ │ (dartssh2)                │ │  │
│  │  └──────────────┘ └──────────────┘ └───────────────────────────┘ │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌───────────────────────────┐ │  │
│  │  │ Crypto       │ │ Sync Service │ │ Notification Service      │ │  │
│  │  │ Service      │ │ (API client) │ │                           │ │  │
│  │  └──────────────┘ └──────────────┘ └───────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                              │                                          │
│  ┌───────────────────────────▼───────────────────────────────────────┐  │
│  │                       DATA LAYER                                  │  │
│  │  ┌──────────────────────┐  ┌──────────────────────────────────┐  │  │
│  │  │ Local Database       │  │ Secure Storage                   │  │  │
│  │  │ (Drift + SQLCipher)  │  │ (flutter_secure_storage)         │  │  │
│  │  │                      │  │                                  │  │  │
│  │  │ • Hosts              │  │ • SSH Private Keys               │  │  │
│  │  │ • Groups             │  │ • Passwords                      │  │  │
│  │  │ • Snippets           │  │ • Master Key (derived)           │  │  │
│  │  │ • Port Fwd Rules     │  │ • Auth Tokens                    │  │  │
│  │  │ • Known Hosts        │  │ • DB Encryption Key              │  │  │
│  │  │ • Settings           │  │                                  │  │  │
│  │  │ • Sync Metadata      │  │  Platform mapping:               │  │  │
│  │  │                      │  │  iOS/macOS → Keychain            │  │  │
│  │  │  Encrypted at rest   │  │  Android  → Keystore             │  │  │
│  │  │  with SQLCipher      │  │  Windows  → DPAPI                │  │  │
│  │  └──────────────────────┘  └──────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                              │                                          │
└──────────────────────────────┼──────────────────────────────────────────┘
                               │
                     HTTPS + E2E Encrypted
                               │
┌──────────────────────────────▼──────────────────────────────────────────┐
│                       BACKEND SERVER                                    │
│                                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                  │
│  │ Auth API     │  │ Vault Sync   │  │ Push         │                  │
│  │              │  │ API          │  │ Notification │                  │
│  │ POST /auth/  │  │              │  │ Service      │                  │
│  │   register   │  │ GET /vault   │  │              │                  │
│  │   login      │  │ PUT /vault   │  │ FCM (Android)│                  │
│  │   refresh    │  │ PATCH /vault │  │ APNs (iOS)   │                  │
│  │   logout     │  │ DELETE /vault│  │              │                  │
│  │   verify-2fa │  │              │  │              │                  │
│  └──────┬───────┘  └──────┬───────┘  └──────────────┘                  │
│         │                 │                                             │
│  ┌──────▼─────────────────▼──────────────────────────────────────────┐  │
│  │                     PostgreSQL                                    │  │
│  │  ┌──────────────┐  ┌──────────────────────────────────────────┐  │  │
│  │  │ users        │  │ vault_entries                             │  │  │
│  │  │              │  │                                          │  │  │
│  │  │ id           │  │ id                                       │  │  │
│  │  │ email        │  │ user_id (FK)                             │  │  │
│  │  │ pw_hash      │  │ encrypted_data (blob)                    │  │  │
│  │  │ totp_secret  │  │ entry_type                               │  │  │
│  │  │ created_at   │  │ version (lamport clock)                  │  │  │
│  │  │ updated_at   │  │ is_deleted (tombstone)                   │  │  │
│  │  │              │  │ created_at                               │  │  │
│  │  │              │  │ updated_at                               │  │  │
│  │  └──────────────┘  └──────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│  Server NEVER sees plaintext vault data. Only encrypted blobs.         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Project Structure (Flutter)

```
cloudshell/
├── android/                          # Android platform
├── ios/                              # iOS platform
├── macos/                            # macOS platform
├── windows/                          # Windows platform
├── linux/                            # Linux platform (bonus)
├── assets/
│   ├── fonts/
│   │   ├── Inter/                    # UI font
│   │   └── JetBrainsMono/           # Terminal font
│   ├── images/
│   │   ├── logo.svg
│   │   ├── onboarding/
│   │   └── empty_states/
│   └── terminal_themes/
│       ├── cloudshell_default.json
│       ├── dracula.json
│       ├── nord.json
│       └── ...
│
├── lib/
│   ├── main.dart                     # App entry point
│   ├── app.dart                      # MaterialApp / theme setup
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart    # App-wide constants
│   │   │   ├── route_names.dart      # Named routes
│   │   │   └── storage_keys.dart     # Secure storage key names
│   │   ├── theme/
│   │   │   ├── app_theme.dart        # ThemeData definitions
│   │   │   ├── app_colors.dart       # Color palette
│   │   │   ├── app_typography.dart   # Text styles
│   │   │   └── terminal_themes.dart  # Terminal color schemes
│   │   ├── extensions/
│   │   │   ├── context_extensions.dart
│   │   │   └── string_extensions.dart
│   │   ├── utils/
│   │   │   ├── validators.dart       # Form validators
│   │   │   ├── formatters.dart       # Date, size formatters
│   │   │   └── platform_utils.dart   # Platform detection
│   │   └── errors/
│   │       ├── app_exception.dart
│   │       └── error_handler.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── host.dart             # Host data model (freezed)
│   │   │   ├── host_group.dart       # Host group model
│   │   │   ├── ssh_key.dart          # SSH key model
│   │   │   ├── snippet.dart          # Snippet model
│   │   │   ├── port_forward.dart     # Port forward rule model
│   │   │   ├── known_host.dart       # Known host fingerprint
│   │   │   ├── vault_entry.dart      # Encrypted vault entry
│   │   │   ├── user.dart             # User account model
│   │   │   └── app_settings.dart     # Settings model
│   │   │
│   │   ├── database/
│   │   │   ├── app_database.dart     # Drift database definition
│   │   │   ├── tables/
│   │   │   │   ├── hosts_table.dart
│   │   │   │   ├── groups_table.dart
│   │   │   │   ├── keys_table.dart
│   │   │   │   ├── snippets_table.dart
│   │   │   │   ├── port_forwards_table.dart
│   │   │   │   ├── known_hosts_table.dart
│   │   │   │   └── settings_table.dart
│   │   │   └── daos/
│   │   │       ├── host_dao.dart
│   │   │       ├── key_dao.dart
│   │   │       ├── snippet_dao.dart
│   │   │       └── settings_dao.dart
│   │   │
│   │   └── repositories/
│   │       ├── host_repository.dart
│   │       ├── key_repository.dart
│   │       ├── snippet_repository.dart
│   │       ├── settings_repository.dart
│   │       └── sync_repository.dart
│   │
│   ├── services/
│   │   ├── ssh/
│   │   │   ├── ssh_service.dart       # SSH connection management
│   │   │   ├── ssh_session.dart       # Individual session wrapper
│   │   │   └── ssh_key_service.dart   # Key generation/import
│   │   ├── sftp/
│   │   │   ├── sftp_service.dart      # SFTP operations
│   │   │   └── transfer_manager.dart  # Upload/download queue
│   │   ├── port_forwarding/
│   │   │   └── port_forward_service.dart
│   │   ├── crypto/
│   │   │   ├── vault_crypto.dart      # E2E encryption logic
│   │   │   ├── kdf_service.dart       # Argon2id key derivation
│   │   │   └── secure_storage.dart    # Platform keychain wrapper
│   │   ├── sync/
│   │   │   ├── sync_service.dart      # Sync orchestration
│   │   │   ├── sync_api_client.dart   # REST API client
│   │   │   └── conflict_resolver.dart # LWW resolution
│   │   └── auth/
│   │       ├── auth_service.dart      # Login/register
│   │       └── biometric_service.dart # Biometric unlock
│   │
│   ├── providers/                     # Riverpod providers
│   │   ├── host_provider.dart
│   │   ├── key_provider.dart
│   │   ├── snippet_provider.dart
│   │   ├── connection_provider.dart
│   │   ├── terminal_provider.dart
│   │   ├── sftp_provider.dart
│   │   ├── vault_provider.dart
│   │   ├── settings_provider.dart
│   │   ├── sync_provider.dart
│   │   └── auth_provider.dart
│   │
│   ├── ui/
│   │   ├── shared/                    # Shared widgets
│   │   │   ├── adaptive_scaffold.dart # Responsive layout
│   │   │   ├── sidebar.dart
│   │   │   ├── bottom_nav.dart
│   │   │   ├── search_bar.dart
│   │   │   ├── status_indicator.dart
│   │   │   ├── empty_state.dart
│   │   │   ├── loading_indicator.dart
│   │   │   └── confirmation_dialog.dart
│   │   │
│   │   ├── onboarding/
│   │   │   ├── welcome_screen.dart
│   │   │   ├── onboarding_slides.dart
│   │   │   ├── auth_choice_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   └── master_password_setup.dart
│   │   │
│   │   ├── hosts/
│   │   │   ├── hosts_screen.dart      # Host list
│   │   │   ├── host_detail_screen.dart
│   │   │   ├── host_form_screen.dart  # Add/edit host
│   │   │   ├── host_group_editor.dart
│   │   │   ├── quick_connect_dialog.dart
│   │   │   └── widgets/
│   │   │       ├── host_list_item.dart
│   │   │       ├── host_group_header.dart
│   │   │       └── host_search_delegate.dart
│   │   │
│   │   ├── terminal/
│   │   │   ├── terminal_screen.dart   # Terminal view
│   │   │   ├── terminal_tabs.dart     # Tab management
│   │   │   ├── split_pane_view.dart   # Split terminal
│   │   │   ├── terminal_search.dart   # Search overlay
│   │   │   └── widgets/
│   │   │       ├── terminal_toolbar.dart
│   │   │       ├── extra_keys_bar.dart  # Mobile extra keys
│   │   │       └── snippet_picker.dart
│   │   │
│   │   ├── keys/
│   │   │   ├── keys_screen.dart
│   │   │   ├── key_detail_screen.dart
│   │   │   ├── generate_key_dialog.dart
│   │   │   ├── import_key_dialog.dart
│   │   │   └── widgets/
│   │   │       └── key_list_item.dart
│   │   │
│   │   ├── sftp/
│   │   │   ├── sftp_browser_screen.dart
│   │   │   ├── transfer_queue_view.dart
│   │   │   └── widgets/
│   │   │       ├── file_list_item.dart
│   │   │       ├── breadcrumb_nav.dart
│   │   │       └── file_action_sheet.dart
│   │   │
│   │   ├── snippets/
│   │   │   ├── snippets_screen.dart
│   │   │   ├── snippet_form_screen.dart
│   │   │   └── widgets/
│   │   │       └── snippet_list_item.dart
│   │   │
│   │   ├── port_forwarding/
│   │   │   ├── port_forward_screen.dart
│   │   │   ├── port_forward_form.dart
│   │   │   └── widgets/
│   │   │       └── forward_list_item.dart
│   │   │
│   │   ├── settings/
│   │   │   ├── settings_screen.dart
│   │   │   ├── appearance_settings.dart
│   │   │   ├── terminal_settings.dart
│   │   │   ├── security_settings.dart
│   │   │   ├── sync_settings.dart
│   │   │   └── about_screen.dart
│   │   │
│   │   └── vault/
│   │       ├── vault_unlock_screen.dart
│   │       └── command_palette.dart
│   │
│   └── router/
│       └── app_router.dart            # GoRouter configuration
│
├── test/                              # Unit & widget tests
│   ├── services/
│   ├── providers/
│   ├── data/
│   └── ui/
│
├── integration_test/                  # Integration tests
│
├── pubspec.yaml                       # Dependencies
├── analysis_options.yaml              # Linter rules
└── README.md
```

---

## 3. Data Models (Freezed)

### 3.1 Host

```dart
@freezed
class Host with _$Host {
  const factory Host({
    required String id,                    // UUID v4
    required String label,                 // Display name
    required String hostname,              // IP or domain
    @Default(22) int port,                 // SSH port
    required String username,              // SSH username
    required AuthMethod authMethod,        // key, password, both
    String? keyId,                         // FK to SSH key
    String? password,                      // Encrypted password
    String? groupId,                       // FK to group
    @Default([]) List<String> tags,        // Tags for search
    String? startupCommand,                // Run on connect
    @Default(60) int keepAliveSeconds,     // Keep-alive interval
    String? jumpHostId,                    // FK to another host (proxy)
    String? encoding,                      // Character encoding
    String? notes,                         // User notes
    bool? isFavorite,                      // Starred
    DateTime? lastConnectedAt,             // Last connection time
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int syncVersion,           // Lamport clock
    @Default(false) bool isDeleted,        // Tombstone
  }) = _Host;
}

enum AuthMethod { key, password, keyAndPassword, interactive }
```

### 3.2 Host Group

```dart
@freezed
class HostGroup with _$HostGroup {
  const factory HostGroup({
    required String id,
    required String name,
    String? parentGroupId,                 // Nested groups
    String? defaultUsername,               // Inherited by hosts
    int? defaultPort,                     // Inherited by hosts
    String? defaultKeyId,                 // Inherited by hosts
    @Default(0) int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int syncVersion,
    @Default(false) bool isDeleted,
  }) = _HostGroup;
}
```

### 3.3 SSH Key

```dart
@freezed
class SshKey with _$SshKey {
  const factory SshKey({
    required String id,
    required String label,                 // Display name
    required KeyType keyType,              // ed25519, rsa, ecdsa
    int? keyBits,                          // 2048, 4096, 256, 384, 521
    required String publicKey,             // Public key (plaintext)
    required String privateKeyRef,         // Reference to secure storage
    required String fingerprint,           // SHA256 fingerprint
    @Default(false) bool hasPassphrase,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int syncVersion,
    @Default(false) bool isDeleted,
  }) = _SshKey;
}

enum KeyType { ed25519, rsa, ecdsa }
```

### 3.4 Snippet

```dart
@freezed
class Snippet with _$Snippet {
  const factory Snippet({
    required String id,
    required String name,
    required String command,               // The command text
    String? category,                      // Grouping category
    @Default([]) List<String> variables,   // {{var}} placeholders
    String? description,                   // Optional description
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int syncVersion,
    @Default(false) bool isDeleted,
  }) = _Snippet;
}
```

### 3.5 Port Forward Rule

```dart
@freezed
class PortForwardRule with _$PortForwardRule {
  const factory PortForwardRule({
    required String id,
    required String label,
    required PortForwardType type,         // local, remote, dynamic
    required String hostId,                // Which host to forward through
    required int sourcePort,
    String? destinationHost,               // For local/remote
    int? destinationPort,                  // For local/remote
    @Default(false) bool autoStart,        // Start on connect
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int syncVersion,
    @Default(false) bool isDeleted,
  }) = _PortForwardRule;
}

enum PortForwardType { local, remote, dynamic }
```

### 3.6 Known Host

```dart
@freezed
class KnownHost with _$KnownHost {
  const factory KnownHost({
    required String id,
    required String hostname,
    required int port,
    required String keyType,               // ssh-ed25519, ssh-rsa, etc.
    required String fingerprint,           // SHA256 fingerprint
    required String publicKey,             // Host public key
    @Default(true) bool isTrusted,
    required DateTime firstSeen,
    required DateTime lastSeen,
  }) = _KnownHost;
}
```

### 3.7 App Settings

```dart
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    // Appearance
    @Default(ThemeMode.dark) ThemeMode themeMode,
    @Default('cloudshell_default') String terminalTheme,
    @Default('JetBrains Mono') String terminalFont,
    @Default(14.0) double terminalFontSize,
    @Default(true) bool fontLigatures,

    // Terminal
    @Default(10000) int scrollbackLines,
    @Default(CursorStyle.block) CursorStyle cursorStyle,
    @Default(true) bool cursorBlink,
    @Default(BellMode.visual) BellMode bellMode,
    @Default(true) bool copyOnSelect,

    // Connection defaults
    @Default(22) int defaultPort,
    @Default(30) int connectionTimeout,
    @Default(60) int keepAliveInterval,
    @Default('UTF-8') String defaultEncoding,

    // Security
    @Default(true) bool biometricUnlock,
    @Default(300) int autoLockSeconds,     // 5 minutes
    @Default(30) int clipboardTimeout,

    // Sync
    String? syncServerUrl,
    @Default(true) bool syncEnabled,
  }) = _AppSettings;
}

enum CursorStyle { block, underline, bar }
enum BellMode { off, visual, audible }
```

---

## 4. E2E Encryption Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   KEY DERIVATION                            │
│                                                             │
│  Master Password (user input, never stored)                 │
│         │                                                   │
│         ▼                                                   │
│  ┌─────────────────────────────────────────┐                │
│  │ Argon2id(password, salt, mem=64MB,      │                │
│  │          iter=3, parallelism=4)         │                │
│  │ Output: 256-bit Master Key              │                │
│  └──────────────────┬──────────────────────┘                │
│                     │                                       │
│         ┌───────────┼───────────┐                           │
│         ▼           ▼           ▼                           │
│  ┌────────────┐ ┌────────┐ ┌────────────┐                   │
│  │ HKDF       │ │ HKDF   │ │ PBKDF2     │                   │
│  │ Expand     │ │ Expand │ │ (1 round)  │                   │
│  │ → EncKey   │ │ → MAC  │ │ → AuthHash │                   │
│  │  (256-bit) │ │  Key   │ │  (for login)│                  │
│  └────────────┘ └────────┘ └────────────┘                   │
│                                                             │
│  EncKey: Encrypts vault items locally                       │
│  MAC Key: Authenticates encrypted data (HMAC-SHA256)        │
│  AuthHash: Sent to server for login (server stores bcrypt)  │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   PER-ITEM ENCRYPTION                       │
│                                                             │
│  For each vault item (host, key, snippet):                  │
│                                                             │
│  1. Generate random ItemKey (AES-256)                       │
│  2. Encrypt item data:                                      │
│     CipherText = AES-256-GCM(ItemKey, plaintext_json)      │
│  3. Encrypt the ItemKey:                                    │
│     EncryptedItemKey = AES-256-GCM(EncKey, ItemKey)         │
│  4. Store: { EncryptedItemKey, CipherText, IV, AuthTag }    │
│                                                             │
│  Decryption reverses the process:                           │
│  EncKey → decrypt ItemKey → decrypt item data               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. Sync Protocol

```
┌─────────────────────────────────────────────────────────────┐
│                    SYNC FLOW                                │
│                                                             │
│  1. INITIAL SYNC (first device)                             │
│     Client → POST /vault/init                               │
│     Body: { encrypted_vault_blob, salt, kdf_params }        │
│     Server stores blob, returns vault_id                    │
│                                                             │
│  2. PULL (device startup / periodic)                        │
│     Client → GET /vault?since_version=N                     │
│     Server returns entries with version > N                  │
│     Client decrypts + merges locally                        │
│                                                             │
│  3. PUSH (after local change)                               │
│     Client encrypts changed item                            │
│     Client → PATCH /vault                                   │
│     Body: { entry_id, encrypted_data, version }             │
│     Server stores, increments version, notifies others      │
│                                                             │
│  4. CONFLICT RESOLUTION                                     │
│     Uses Lamport timestamps (logical clock)                 │
│     Each device increments counter on every change          │
│     On conflict: highest version wins (LWW)                 │
│     Tombstones for deletes (retained 30 days)               │
│                                                             │
│  5. REAL-TIME NOTIFICATIONS                                 │
│     Server → Push notification to other devices             │
│     Device receives push → triggers pull                    │
│     Fallback: periodic pull every 5 minutes                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # SSH & Terminal
  dartssh2: ^2.9.0              # SSH2 + SFTP client
  xterm: ^4.0.0                 # Terminal emulator widget

  # State Management
  flutter_riverpod: ^2.5.0      # State management
  riverpod_annotation: ^2.3.0   # Code generation for providers

  # Database
  drift: ^2.15.0                # SQLite ORM
  sqlite3_flutter_libs: ^0.5.0  # SQLite binaries
  sqlcipher_flutter_libs: ^0.6.0 # Encrypted SQLite

  # Secure Storage
  flutter_secure_storage: ^9.2.0 # Platform keychain

  # Crypto
  pointycastle: ^3.9.0          # AES-GCM, HMAC, HKDF
  cryptography: ^2.7.0          # Argon2id, X25519
  uuid: ^4.3.0                  # UUID generation

  # Data Models
  freezed_annotation: ^2.4.0    # Immutable models
  json_annotation: ^4.8.0       # JSON serialization

  # Networking
  dio: ^5.4.0                   # HTTP client for sync API
  web_socket_channel: ^2.4.0    # WebSocket for real-time sync

  # Navigation
  go_router: ^13.2.0            # Declarative routing

  # UI
  lucide_icons: ^0.2.0          # Icon set
  google_fonts: ^6.1.0          # Font loading (Inter)
  flutter_animate: ^4.5.0       # Animations
  responsive_framework: ^1.4.0  # Responsive breakpoints

  # Biometrics
  local_auth: ^2.2.0            # Fingerprint / Face ID

  # File Handling
  file_picker: ^8.0.0           # File picker for import/upload
  share_plus: ^7.2.0            # Share files/text
  path_provider: ^2.1.0         # App directories
  permission_handler: ^11.3.0   # File permissions

  # Notifications
  firebase_messaging: ^14.7.0   # Push notifications (Android)
  flutter_local_notifications: ^17.0.0 # Local notifications

  # Utilities
  intl: ^0.19.0                 # Internationalization
  logger: ^2.0.0                # Logging
  connectivity_plus: ^6.0.0     # Network state

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0          # Code generation
  freezed: ^2.4.0               # Model code gen
  json_serializable: ^6.7.0     # JSON code gen
  riverpod_generator: ^2.4.0    # Provider code gen
  drift_dev: ^2.15.0            # Database code gen
  mockito: ^5.4.0               # Mocking for tests
  flutter_lints: ^3.0.0         # Linter rules
```
