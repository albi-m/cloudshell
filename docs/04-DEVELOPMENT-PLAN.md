# CloudShell - Phased Development Plan

---

## Overview

```
Phase 1 ────▸ Phase 2 ────▸ Phase 3 ────▸ Phase 4 ────▸ Phase 5
Core SSH      Advanced      Sync &        Polish &      Ecosystem
Client        Features      Security      Parity

~10 weeks     ~8 weeks      ~8 weeks      ~6 weeks      ~6 weeks
```

---

## Phase 1: Core SSH Client (10 weeks)

**Goal:** A working SSH client that can connect to servers, manage hosts and keys, and browse files via SFTP. Local-only, no sync.

### Sprint 1-2: Project Setup & Basic UI Shell (Weeks 1-2)

```
Tasks:
├── Initialize Flutter project with all platform targets
├── Set up project structure (see ARCHITECTURE.md)
├── Configure dependencies (pubspec.yaml)
├── Implement design system
│   ├── App color palette (dark theme)
│   ├── Typography (Inter + JetBrains Mono)
│   ├── Icon system (Lucide)
│   └── Component library (buttons, inputs, cards)
├── Implement adaptive layout scaffold
│   ├── Desktop: sidebar + main content
│   ├── Tablet: collapsible sidebar
│   └── Mobile: bottom navigation
├── Set up local database (Drift + SQLCipher)
│   ├── Define all tables
│   ├── Generate DAOs
│   └── Implement repositories
├── Set up secure storage service
├── Implement settings screen (basic)
│   ├── Theme toggle (dark/light/system)
│   ├── About page
│   └── App version
└── Set up Riverpod providers structure

Deliverable: App shell with navigation, theming, and local storage working
```

### Sprint 3-4: Host Management (Weeks 3-4)

```
Tasks:
├── Hosts list screen
│   ├── Empty state (first time)
│   ├── Host list with groups
│   ├── Search/filter hosts
│   └── Host list item widget (status, labels)
├── Add/Edit host form
│   ├── Basic fields (label, hostname, port, username)
│   ├── Auth method selection (key/password)
│   ├── Key selector dropdown
│   ├── Advanced settings (collapsible)
│   ├── Form validation
│   └── Save to database
├── Host detail view
│   ├── View all host info
│   ├── Connect button
│   ├── Edit / Delete actions
│   └── Last connected timestamp
├── Quick connect dialog
│   ├── user@host:port input
│   ├── Key/password selection
│   └── Optional save checkbox
├── Recent connections list
└── Host groups (basic - flat list for now)
    ├── Create/rename/delete groups
    └── Assign hosts to groups

Deliverable: Full host CRUD with groups and search
```

### Sprint 5-6: SSH Terminal (Weeks 5-6)

```
Tasks:
├── SSH connection service
│   ├── Connect with password auth
│   ├── Connect with key auth
│   ├── Connection state management
│   ├── Error handling (timeout, auth failure, network)
│   └── Auto-detect terminal size
├── Terminal view integration (xterm.dart)
│   ├── Wire dartssh2 shell → xterm.dart terminal
│   ├── Terminal resize handling
│   ├── Copy/paste support
│   ├── Scrollback buffer
│   └── Default terminal theme (CloudShell Dark)
├── Host key verification
│   ├── First-time fingerprint dialog
│   ├── Store in known_hosts table
│   ├── Warn on key change (MITM detection)
│   └── Trust/reject flow
├── Connection progress UI
│   ├── Connecting spinner
│   ├── Auth method indicator
│   └── Error dialog with retry/edit
├── Multi-tab terminal
│   ├── Tab bar widget
│   ├── Add/close tabs
│   ├── Switch between tabs
│   └── Tab state preservation
├── Mobile terminal enhancements
│   ├── Extra keyboard row (Esc, Tab, Ctrl, Alt, arrows)
│   ├── Hardware keyboard support
│   └── Landscape orientation
└── Terminal status bar
    ├── Connection status indicator
    ├── Session duration timer
    └── Encoding display

Deliverable: Fully working SSH terminal with multi-tab on all platforms
```

### Sprint 7-8: Key Management & SFTP (Weeks 7-8)

```
Tasks:
├── SSH Key Management
│   ├── Key list screen
│   ├── Generate key dialog
│   │   ├── Ed25519 (default)
│   │   ├── RSA (2048/4096)
│   │   ├── ECDSA (256/384/521)
│   │   └── Optional passphrase
│   ├── Import key (file picker)
│   ├── Import key (paste from clipboard)
│   ├── Key detail view
│   │   ├── View public key
│   │   ├── Copy public key
│   │   ├── View fingerprint
│   │   └── See associated hosts
│   ├── Export public key
│   ├── Delete key (with confirmation)
│   └── Store private keys in secure storage
│
├── SFTP File Browser
│   ├── SFTP connection (reuse SSH session)
│   ├── Directory listing view
│   │   ├── File/folder icons
│   │   ├── File size, date, permissions
│   │   └── Breadcrumb navigation
│   ├── Navigate directories (tap to enter)
│   ├── Upload file (file picker → upload)
│   ├── Download file (to device)
│   ├── Transfer progress indicator
│   └── Basic file actions (view details)
│
└── Testing & Bug fixes
    ├── Unit tests for SSH service
    ├── Unit tests for database layer
    ├── Widget tests for key screens
    └── Manual testing on all platforms

Deliverable: Complete key management + basic SFTP browser
```

### Sprint 9-10: Phase 1 Polish & Release (Weeks 9-10)

```
Tasks:
├── Light theme implementation
├── App icon and splash screen (all platforms)
├── Onboarding screens (welcome, feature slides)
├── "Use without account" flow
├── Error handling audit
│   ├── Network errors
│   ├── Auth failures
│   ├── Timeout handling
│   └── Graceful disconnection
├── Performance optimization
│   ├── Terminal rendering performance
│   ├── List virtualization for large host lists
│   └── Memory usage profiling
├── Platform-specific testing
│   ├── macOS: menu bar, window management
│   ├── Windows: title bar, window controls
│   ├── iOS: safe area, gesture navigation
│   └── Android: back button, permissions
├── Accessibility basics
│   ├── Screen reader labels
│   ├── Focus management
│   └── Color contrast verification
└── Beta build distribution

Deliverable: Phase 1 MVP ready for beta testing
```

---

## Phase 2: Advanced Features (8 weeks)

**Goal:** Port forwarding, split panes, snippets, command palette, and customization.

### Sprint 11-12: Port Forwarding & Split Panes (Weeks 11-12)

```
Tasks:
├── Local port forwarding
│   ├── Create forwarding rule form
│   ├── Start/stop forwarding
│   ├── Active forwards list
│   └── Persist saved rules
├── Remote port forwarding
├── Port forwarding management screen
│   ├── Active forwards with stop button
│   ├── Saved rules with start button
│   └── Status indicators
├── Split pane terminal
│   ├── Horizontal split (Cmd+D)
│   ├── Vertical split (Cmd+Shift+D)
│   ├── Resize panes (drag handle)
│   ├── Focus switching (Alt+arrows)
│   └── Close pane
└── Auto-reconnect on disconnect
```

### Sprint 13-14: Snippets & Command Palette (Weeks 13-14)

```
Tasks:
├── Snippets
│   ├── Snippet list screen
│   ├── Add/edit snippet form
│   │   ├── Name, command, category
│   │   ├── Variable detection ({{var}})
│   │   └── Description
│   ├── Snippet categories/folders
│   ├── Snippet picker (overlay from terminal)
│   │   ├── Search/filter snippets
│   │   ├── Tap to insert into terminal
│   │   └── Variable input dialog
│   └── Copy snippet to clipboard
├── Command palette (Cmd+K)
│   ├── Fuzzy search across all entities
│   ├── Recent commands
│   ├── Quick host connect
│   ├── Quick snippet insert
│   ├── Action shortcuts (settings, new tab, etc.)
│   └── Keyboard navigation
└── Global search improvements
    ├── Search across hosts, keys, snippets
    └── Highlight matching terms
```

### Sprint 15-16: Customization & Polish (Weeks 15-16)

```
Tasks:
├── Terminal theming
│   ├── Theme selector (9 built-in themes)
│   ├── Live preview
│   ├── Theme persistence per host (optional)
│   └── Theme definition format (JSON)
├── Terminal font selection
│   ├── 10 bundled fonts
│   ├── Font size slider
│   ├── Ligature toggle
│   └── Preview in settings
├── Keyboard shortcuts (desktop)
│   ├── Implement all shortcuts from NAV-FLOW doc
│   ├── Shortcut reference overlay (Cmd+/)
│   └── Display shortcuts in command palette
├── Host features
│   ├── Tags system (add/remove/filter by tag)
│   ├── Favorites (star/unstar)
│   ├── Nested groups
│   └── Drag-and-drop reorder (desktop)
├── Terminal features
│   ├── Search in terminal output (Cmd+Shift+F)
│   ├── Clickable URLs
│   ├── Visual bell
│   └── Cursor style selection
├── Mobile enhancements
│   ├── Swipe gestures (tab switch, favorite)
│   ├── Pinch-to-zoom font size
│   ├── Two-finger scroll
│   └── Haptic feedback
├── Connection defaults in settings
│   ├── Default port, timeout, keep-alive
│   └── Default encoding
└── Known hosts management screen
```

---

## Phase 3: Sync & Security (8 weeks)

**Goal:** User accounts, master password vault, E2E encrypted sync, biometric unlock.

### Sprint 17-18: Crypto & Vault (Weeks 17-18)

```
Tasks:
├── Crypto service implementation
│   ├── Argon2id KDF (master password → master key)
│   ├── HKDF key expansion (master key → enc key + mac key)
│   ├── AES-256-GCM encryption/decryption
│   ├── HMAC-SHA256 authentication
│   ├── Per-item key generation and encryption
│   └── Unit tests for all crypto operations
├── Vault service
│   ├── Master password setup flow
│   ├── Master password change flow
│   ├── Vault lock/unlock state machine
│   ├── Encrypt all sensitive data on vault lock
│   ├── Decrypt on vault unlock
│   └── Auto-lock timer
├── Vault unlock screen
│   ├── Master password input
│   ├── Biometric unlock option
│   └── Forgot password flow (reset = lose data)
├── Biometric service
│   ├── iOS: Face ID / Touch ID
│   ├── Android: Fingerprint / Face
│   ├── macOS: Touch ID
│   └── Windows: Windows Hello
├── Secure clipboard
│   ├── Auto-clear after 30 seconds
│   └── Clear on app background
└── Migrate existing data to encrypted vault
```

### Sprint 19-20: Backend & Auth (Weeks 19-20)

```
Tasks:
├── Backend server (Rust/Axum or Go/Gin)
│   ├── Project setup with PostgreSQL
│   ├── User registration endpoint
│   │   ├── Email validation
│   │   ├── Store bcrypt(auth_hash)
│   │   └── Return JWT tokens
│   ├── User login endpoint
│   ├── Token refresh endpoint
│   ├── Password reset flow
│   ├── TOTP 2FA setup/verify
│   ├── Rate limiting (Redis)
│   └── Docker Compose setup
├── Client auth service
│   ├── Sign up screen
│   ├── Log in screen
│   ├── Forgot password flow
│   ├── JWT token management
│   ├── Auto-refresh tokens
│   └── Logout (clear tokens)
├── Auth state management
│   ├── Unauthenticated state
│   ├── Authenticated state
│   └── Local-only mode
└── API client (Dio)
    ├── Base URL configuration
    ├── Auth interceptor (JWT)
    ├── Error handling
    └── Retry logic
```

### Sprint 21-22: Sync Engine (Weeks 21-22)

```
Tasks:
├── Vault sync API (backend)
│   ├── POST /vault/init (first sync)
│   ├── GET /vault?since_version=N (pull)
│   ├── PATCH /vault (push changes)
│   ├── DELETE /vault/entry/:id (tombstone)
│   └── Push notification trigger on change
├── Sync service (client)
│   ├── Initial vault upload
│   ├── Pull changes from server
│   ├── Push local changes to server
│   ├── Conflict resolution (LWW with Lamport clock)
│   ├── Tombstone handling (30-day retention)
│   ├── Offline queue (changes made while offline)
│   └── Sync status indicator
├── Sync settings UI
│   ├── Account info display
│   ├── Sync status (last sync time)
│   ├── Manual sync trigger
│   ├── Sync server URL configuration
│   └── Export/import vault (encrypted JSON)
├── Push notifications
│   ├── FCM setup (Android)
│   ├── APNs setup (iOS)
│   ├── Handle push → trigger sync
│   └── Fallback: periodic pull (every 5 min)
└── Testing
    ├── Multi-device sync testing
    ├── Offline → online sync testing
    ├── Conflict resolution testing
    └── Encryption/decryption round-trip tests
```

### Sprint 23-24: Security Hardening (Weeks 23-24)

```
Tasks:
├── Security audit
│   ├── Review all crypto implementations
│   ├── Check for key material leaks
│   ├── Verify secure storage usage
│   ├── Review API security (HTTPS, pinning)
│   └── Check for data leaks in logs
├── Additional security features
│   ├── TOTP 2FA setup screen
│   ├── Password generator
│   ├── Session timeout settings
│   └── Login notifications
├── Data management
│   ├── Export vault (encrypted)
│   ├── Import vault (decrypt + merge)
│   ├── Delete account flow
│   └── Clear local data
├── Privacy
│   ├── No analytics without consent
│   ├── Privacy policy screen
│   └── Data deletion guarantee
└── Backend security
    ├── Input validation
    ├── SQL injection prevention
    ├── Rate limiting
    ├── CORS configuration
    └── TLS certificate setup
```

---

## Phase 4: Polish & Feature Parity (6 weeks)

**Goal:** Bring quality to production level. Server monitoring, cloud imports, custom themes.

### Sprint 25-26 (Weeks 25-26)

```
Tasks:
├── SFTP enhancements
│   ├── Create directory
│   ├── Delete files/directories
│   ├── Rename files
│   ├── File permissions view/edit
│   ├── Drag-and-drop upload (desktop)
│   ├── Dual-pane browser (local + remote)
│   └── Edit remote text files in-app
├── Cloud provider import
│   ├── AWS EC2 instance import (via API key)
│   ├── DigitalOcean droplet import
│   └── Import UI (select instances → create hosts)
├── Custom terminal theme editor
│   ├── Color picker for each ANSI color
│   ├── Background/foreground/cursor
│   ├── Live preview
│   ├── Save custom theme
│   └── Share/export themes
└── Dynamic port forwarding (SOCKS proxy)
```

### Sprint 27-28 (Weeks 27-28)

```
Tasks:
├── Terminal session logging
│   ├── Log to file (configurable)
│   ├── Export session log
│   └── Timestamp option
├── Broadcast input to multiple sessions
├── Workspaces
│   ├── Group sessions into workspaces
│   ├── Save/restore workspace layout
│   └── Quick-switch between workspaces
├── Advanced SSH features
│   ├── SSH agent forwarding
│   ├── Jump host / proxy support
│   ├── PPK format import
│   └── Keyboard-interactive auth improvements
└── iPad multitasking
    ├── Split View support
    ├── Slide Over support
    └── Stage Manager compatibility
```

### Sprint 29-30 (Weeks 29-30)

```
Tasks:
├── Self-hosted sync server
│   ├── Docker image for backend
│   ├── Docker Compose with PostgreSQL
│   ├── Environment variable configuration
│   ├── Setup documentation
│   └── Client: custom server URL setting
├── Performance optimization pass
│   ├── App startup time
│   ├── Terminal rendering benchmarks
│   ├── Memory usage optimization
│   ├── Database query optimization
│   └── Network request optimization
├── Comprehensive testing
│   ├── Full integration test suite
│   ├── Cross-platform testing matrix
│   ├── Accessibility audit
│   └── Security penetration testing
└── App store preparation
    ├── App Store screenshots (all devices)
    ├── App descriptions
    ├── Privacy policy finalization
    └── Review guidelines compliance
```

---

## Phase 5: Ecosystem (6 weeks)

**Goal:** Extension system, additional protocols, team features, community.

### Sprint 31-34 (Weeks 31-34)

```
Tasks:
├── Mosh (mobile shell) support
├── Telnet protocol support
├── Serial port support
├── Team vault sharing
│   ├── Shared team vault concept
│   ├── Invite team members
│   ├── Role-based access (admin, member, read-only)
│   └── Audit log
├── Plugin/extension architecture
│   ├── Extension API design
│   ├── Extension manifest format
│   ├── Extension marketplace (community themes, snippets)
│   └── Example extensions
├── Internationalization (i18n)
│   ├── Language selection
│   ├── Translation files (en, es, de, fr, ja, zh, ko)
│   └── RTL support
└── Community
    ├── Open source client release
    ├── Contribution guidelines
    ├── Community theme repository
    └── Documentation site
```

---

## Release Milestones

```
┌───────────┬──────────────┬──────────────────────────────────────────┐
│ Version   │ Phase        │ Key Features                             │
├───────────┼──────────────┼──────────────────────────────────────────┤
│ 0.1.0     │ Phase 1 End  │ SSH, hosts, keys, SFTP, multi-tab       │
│ 0.5.0     │ Phase 2 End  │ + Split panes, snippets, cmd palette    │
│ 1.0.0     │ Phase 3 End  │ + Sync, vault, auth, E2E encryption     │
│ 1.5.0     │ Phase 4 End  │ + Cloud import, self-host, polish       │
│ 2.0.0     │ Phase 5 End  │ + Mosh, teams, plugins, i18n            │
└───────────┴──────────────┴──────────────────────────────────────────┘
```

---

## Testing Strategy

```
┌──────────────────────┬──────────────────────────────────────────────┐
│ Test Type            │ Coverage Target                              │
├──────────────────────┼──────────────────────────────────────────────┤
│ Unit Tests           │ 80%+ for services, crypto, data layer       │
│ Widget Tests         │ Key screens and component interactions      │
│ Integration Tests    │ Critical flows (connect, sync, key mgmt)    │
│ Platform Tests       │ Manual testing on all 4 platforms each sprint│
│ Security Tests       │ Crypto verification, penetration testing     │
│ Performance Tests    │ Terminal FPS, memory, startup time           │
│ Accessibility Tests  │ Screen reader, color contrast, keyboard nav │
└──────────────────────┴──────────────────────────────────────────────┘
```

---

## Risk Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| dartssh2 missing protocol features | High | Fallback to libssh FFI bindings for specific platforms |
| Terminal performance on mobile | Medium | Profile early, optimize xterm.dart config, test on low-end devices |
| SQLCipher compatibility issues | Medium | Test on all platforms in Sprint 1, have fallback to standard SQLite + app-level encryption |
| App Store rejection (iOS) | High | Follow Apple guidelines strictly, no private APIs, proper entitlements |
| Sync conflicts data loss | High | Extensive conflict resolution testing, always keep local backup before merge |
| Key management security | Critical | Regular crypto audits, never log key material, memory-safe handling |
