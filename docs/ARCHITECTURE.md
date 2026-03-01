# CloudShell Architecture

Technical architecture reference for CloudShell, a cross-platform SSH client built with Flutter and Dart.

---

## 1. System Overview

```
+-------------------------------------------------------------------+
|                     CloudShell (Flutter App)                       |
|                                                                   |
|  +-------------------------------------------------------------+ |
|  |                        UI Layer                              | |
|  |  Screens / Widgets / Dialogs / AdaptiveScaffold              | |
|  +---------------------------+----------------------------------+ |
|                              |                                    |
|  +---------------------------v----------------------------------+ |
|  |                   Provider Layer (Riverpod)                  | |
|  |  HostProvider | TerminalTabsNotifier | VaultProvider | ...   | |
|  +---------------------------+----------------------------------+ |
|                              |                                    |
|  +---------------------------v----------------------------------+ |
|  |                     Service Layer                            | |
|  |  SSHService | SFTPService | VaultCryptoService | ...         | |
|  +---------------------------+----------------------------------+ |
|                              |                                    |
|  +---------------------------v----------------------------------+ |
|  |                      Data Layer                              | |
|  |  Drift/SQLite (AppDatabase)  |  flutter_secure_storage       | |
|  +-------------------------------------------------------------+ |
+-------------------------------------------------------------------+
```

Each layer depends only on the layer directly below it. The UI never talks to the database or services directly; all data flows through Riverpod providers.

---

## 2. Layer Architecture

**UI Layer** (`lib/ui/`): Screens, widgets, and dialogs organized by feature (hosts, terminal, keys, sftp, snippets, settings, vault). The `AdaptiveScaffold` provides the primary layout wrapper, switching between sidebar and bottom navigation based on screen width. Uses the Aether design system with a dark-first teal/blue accent palette.

**Provider Layer** (`lib/providers/`): Riverpod providers that own application state and mediate between the UI and services. Seventeen provider files cover hosts, keys, snippets, terminal tabs, vault, auth, settings, workspaces, port forwarding, sync, and more. Providers expose reactive streams from the database and encapsulate all mutation logic.

**Service Layer** (`lib/services/`): Stateless or long-lived services that perform I/O. SSH connections (dartssh2), SFTP file operations, terminal session management (xterm.dart), vault encryption (cryptography package), port forwarding, auth, and sync. Services are instantiated by providers and never hold UI references.

**Data Layer** (`lib/data/`): Drift ORM over SQLite for structured data, plus `flutter_secure_storage` for secrets (SSH private keys, passwords, auth tokens). DAOs provide typed query interfaces per domain. Secure storage maps to Keychain (iOS/macOS), Keystore (Android), and DPAPI (Windows).

---

## 3. State Management

CloudShell uses **flutter_riverpod** exclusively. Key provider patterns:

- **StreamProvider**: Watches Drift database queries for reactive UI updates (hosts, keys, snippets, groups, settings). Changes in the DB automatically propagate to all listening widgets.
- **AsyncNotifierProvider**: Manages async state machines like `VaultProvider` (noVault / locked / unlocked) and `AuthProvider`. These handle initialization, loading, and error states.
- **NotifierProvider**: Synchronous state for `TerminalTabsNotifier` (tab list, active tab, split panes), `AppLockNotifier`, and `SidebarNotifier`.
- **Provider**: Singleton services like `appRouterProvider` (GoRouter), `appDatabaseProvider`, and `sshServiceProvider`.

Data flow: `Drift DB -> StreamProvider -> ConsumerWidget.watch() -> UI rebuild`. Mutations go through notifier methods that call services, which write to the DB, closing the reactive loop.

---

## 4. Data Layer

The `AppDatabase` (Drift) is at schema version 7. Eleven tables with eleven corresponding DAOs:

| Table           | DAO              | Purpose                          |
|-----------------|------------------|----------------------------------|
| `Hosts`         | `HostDao`        | SSH connection configurations    |
| `HostGroups`    | `GroupDao`       | Hierarchical host organization   |
| `SshKeys`       | `KeyDao`         | SSH key metadata and references  |
| `Snippets`      | `SnippetDao`     | Saved commands with variables    |
| `PortForwards`  | `PortForwardDao` | Local/remote/dynamic forwarding  |
| `KnownHosts`    | `KnownHostDao`   | Trusted host fingerprints        |
| `Secrets`       | `SecretsDao`     | Encrypted key-value storage      |
| `Settings`      | `SettingsDao`    | User preferences (key-value)     |
| `SyncMetadata`  | `SyncMetadataDao`| Sync state tracking              |
| `SyncQueue`     | `SyncQueueDao`   | Pending sync operations          |
| `Workspaces`    | `WorkspaceDao`   | Saved workspace layouts          |

Migration strategy handles incremental schema changes (v1 through v7) with `Migrator.addColumn` and `Migrator.createTable` calls. Sensitive credentials (private keys, passwords) are stored in `flutter_secure_storage`, not in SQLite.

---

## 5. Service Layer

**SSH** (`SSHService`): Built on dartssh2. Manages up to 10 concurrent connections. Resolves authentication (password, key, or both), verifies host keys against the known hosts store, and creates `SSHSession` wrappers. Supports proxy jump (chained connections) and auto-reconnect.

**SFTP** (`SFTPService`): File browsing, upload, download, rename, delete, and permission editing over the SSH connection's SFTP subsystem. Includes a remote text editor for in-place file editing.

**Terminal** (`TerminalTabsNotifier` + xterm.dart): Owns `xterm.Terminal` instances so they survive navigation. Supports multi-tab sessions, split panes (horizontal/vertical), session logging, broadcast input to multiple tabs, and workspace save/restore with debounced auto-save.

**Crypto** (`VaultCryptoService`): Zero-knowledge encryption with a three-key hierarchy derived from the master password. See Section 6 for details.

**Port Forwarding**: Local, remote, and dynamic (SOCKS proxy) forwarding through SSH tunnels. Rules are persisted and can auto-start on connection.

---

## 6. Security Model

CloudShell implements a Bitwarden-style zero-knowledge vault:

```
Master Password (never stored)
        |
        v
  Argon2id (salt, 64MB memory, 3 iterations, 4 parallelism)
        |
        v
  Master Key (256-bit, in-memory only)
        |
   +----+----+
   v         v
 HKDF      HKDF
 "enc"     "mac"
   v         v
 EncKey    MACKey
(256-bit) (256-bit)
```

**Per-item encryption**: Each vault entry gets a random AES-256 item key. Data is encrypted with AES-256-GCM using the item key, then the item key itself is encrypted with EncKey. An HMAC-SHA256 tag (using MACKey) authenticates the entire ciphertext.

**Key rules**: VaultKeys (masterKey, encKey, macKey) exist only in memory and are never written to disk. The vault auto-locks after a configurable timeout or when the app backgrounds. Progressive lockout delays protect against brute-force attempts.

**Biometric lock**: Optional app-level biometric authentication (Face ID / fingerprint) via `local_auth`, with a grace period on app backgrounding.

---

## 7. Responsive Design

The `AdaptiveScaffold` implements a three-tier responsive layout:

```
Width < 600px    : Mobile    - Bottom navigation bar, full-width content
Width 600-900px  : Tablet    - Collapsible compact sidebar (icon-only 60px)
Width > 900px    : Desktop   - Full sidebar with labels + workspace tab bar
```

The scaffold wraps all main screens via GoRouter's `ShellRoute`. On desktop, the sidebar supports collapse/expand toggling. A Chrome-style workspace tab bar spans the top on wider layouts, showing open pages and terminal sessions. Terminal screens and SFTP browsers render directly inside the scaffold rather than as separate routes.

Mobile-specific adaptations include swipe-to-switch tabs, pinch-to-zoom in the terminal, haptic feedback, and an extra keys bar (Ctrl, Alt, Tab, Esc, arrows) above the keyboard.

---

## 8. Navigation

CloudShell uses **GoRouter** with a `ShellRoute` for the adaptive scaffold and root-level routes for full-screen flows.

**Route structure**:
- `/onboarding` -- First-launch onboarding (root, outside shell)
- `/unlock` -- Vault unlock screen (root, outside shell)
- `/master-password-setup` -- Vault setup (root, outside shell)
- `/login`, `/sign-up`, `/forgot-password` -- Auth flows (root)
- `/hosts` -- Home screen (shell, default initial location)
- `/hosts/:id`, `/hosts/form`, `/hosts/:id/edit` -- Host CRUD
- `/keys`, `/keys/:id` -- SSH key management
- `/snippets`, `/snippets/form`, `/snippets/:id/edit` -- Snippets
- `/port-forwarding` -- Port forwarding rules
- `/settings` -- Application settings

**Redirects**: The router evaluates three redirect conditions on every navigation:
1. **Onboarding guard**: Forces `/onboarding` until first-run completes.
2. **Vault lock guard**: Redirects authenticated users to `/unlock` when the vault is locked. A `_RouterRefreshNotifier` listens to `vaultProvider` changes so the redirect re-evaluates automatically when the vault state transitions.
3. **Stale route cleanup**: Redirects away from vault/onboarding routes when they are no longer needed.

Terminal and SFTP screens are not GoRouter routes. They are rendered directly by the `AdaptiveScaffold` based on `TerminalTabsNotifier` state, allowing terminal sessions to persist across navigation without being destroyed by route changes.
