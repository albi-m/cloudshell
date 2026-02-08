# CloudShell - Documentation Plan

---

## 1. Documentation Strategy

### Philosophy

```
"Every screen the user sees should be documented.
 Every API the developer calls should be documented.
 Every decision we made should be recorded with reasoning."
```

### Documentation Layers

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  LAYER 1: USER-FACING DOCUMENTATION                                │
│  Who reads it: End users, customers                                 │
│  ├── In-app help & tooltips                                        │
│  ├── Getting Started guide                                         │
│  ├── Feature documentation (how to use each feature)               │
│  ├── FAQ / Troubleshooting                                         │
│  ├── Keyboard shortcuts reference                                  │
│  └── Video tutorials (Phase 4+)                                    │
│                                                                     │
│  LAYER 2: DEVELOPER DOCUMENTATION                                   │
│  Who reads it: Contributors, maintainers, future devs              │
│  ├── Architecture decision records (ADRs)                          │
│  ├── API reference (backend REST API)                              │
│  ├── Code documentation (dartdoc comments)                         │
│  ├── Data model documentation                                      │
│  ├── Crypto specification                                          │
│  ├── Sync protocol specification                                   │
│  └── Contributing guide                                            │
│                                                                     │
│  LAYER 3: OPERATIONAL DOCUMENTATION                                 │
│  Who reads it: DevOps, sysadmins deploying self-hosted             │
│  ├── Self-hosted deployment guide                                  │
│  ├── Docker Compose reference                                      │
│  ├── Environment variable reference                                │
│  ├── Backup & restore procedures                                   │
│  ├── Monitoring setup                                              │
│  └── Troubleshooting server issues                                 │
│                                                                     │
│  LAYER 4: INTERNAL PROJECT DOCUMENTATION                            │
│  Who reads it: Core team, project management                       │
│  ├── Design documents (this docs/ folder)                          │
│  ├── Sprint planning notes                                         │
│  ├── Security plan & threat model                                  │
│  ├── Release checklists                                            │
│  └── Post-mortem records                                           │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. Documentation File Structure

```
cloudshell/
├── docs/                                    # Internal project docs (design phase)
│   ├── 00-INDEX.md                          # Master index
│   ├── 01-APP-OVERVIEW.md                   # Vision, competitors, business model
│   ├── 02-FEATURE-LIST.md                   # All features + screens
│   ├── 03-NAVIGATION-FLOW.md               # Navigation architecture
│   ├── 04-DEVELOPMENT-PLAN.md              # Phased development plan
│   ├── 05-SECURITY-PLAN.md                 # Security & cybersecurity plan
│   ├── 06-DOCUMENTATION-PLAN.md            # This document
│   └── adr/                                 # Architecture Decision Records
│       ├── 001-flutter-over-react-native.md
│       ├── 002-dartssh2-over-libssh.md
│       ├── 003-argon2id-over-pbkdf2.md
│       ├── 004-riverpod-over-bloc.md
│       ├── 005-drift-sqlcipher-over-hive.md
│       └── ...
│
├── reference/                               # Reference materials
│   ├── design-system/
│   │   ├── DESIGN-SYSTEM.md                # Colors, fonts, icons, components
│   │   ├── MOBILE-UX-GUIDE.md              # Mobile-specific UX patterns
│   │   └── DESIGN-RESEARCH-RAW.md          # Raw research notes
│   ├── wireframes/
│   │   └── WIREFRAMES.md                   # ASCII wireframes all screens
│   └── architecture/
│       └── ARCHITECTURE.md                 # Tech architecture, data models
│
├── documentation/                           # Published documentation (ships to users)
│   ├── user-guide/
│   │   ├── getting-started.md
│   │   ├── connecting-to-server.md
│   │   ├── managing-hosts.md
│   │   ├── managing-keys.md
│   │   ├── sftp-file-transfer.md
│   │   ├── port-forwarding.md
│   │   ├── snippets.md
│   │   ├── terminal-customization.md
│   │   ├── vault-and-encryption.md
│   │   ├── sync-across-devices.md
│   │   ├── keyboard-shortcuts.md
│   │   ├── troubleshooting.md
│   │   └── faq.md
│   │
│   ├── developer-guide/
│   │   ├── contributing.md
│   │   ├── development-setup.md
│   │   ├── architecture-overview.md
│   │   ├── code-style-guide.md
│   │   ├── testing-guide.md
│   │   ├── security-guidelines.md
│   │   └── release-process.md
│   │
│   ├── api-reference/
│   │   ├── authentication.md
│   │   ├── vault-sync.md
│   │   ├── user-management.md
│   │   └── webhooks.md
│   │
│   ├── self-hosting/
│   │   ├── quick-start.md
│   │   ├── docker-compose.md
│   │   ├── environment-variables.md
│   │   ├── reverse-proxy-setup.md
│   │   ├── backup-restore.md
│   │   ├── upgrading.md
│   │   ├── monitoring.md
│   │   └── troubleshooting.md
│   │
│   ├── security/
│   │   ├── security-whitepaper.md
│   │   ├── encryption-specification.md
│   │   ├── responsible-disclosure.md
│   │   └── privacy-policy.md
│   │
│   └── changelog/
│       ├── CHANGELOG.md
│       └── SECURITY-CHANGELOG.md
│
└── website/                                 # Documentation website source
    ├── docusaurus.config.js                 # Docusaurus configuration
    ├── docs/                                # Symlinked from documentation/
    ├── blog/                                # Blog posts, release announcements
    └── src/                                 # Custom components
```

---

## 3. Documentation Per Phase

### Phase 1: Core SSH Client

```
MUST HAVE before Phase 1 release:
├── README.md (project overview, screenshots, install instructions)
├── User Guide
│   ├── getting-started.md
│   │   ├── Installation (macOS, Windows, iOS, Android)
│   │   ├── First launch walkthrough
│   │   ├── Adding your first host
│   │   └── Making your first connection
│   ├── connecting-to-server.md
│   │   ├── Password authentication
│   │   ├── Key authentication
│   │   ├── Quick Connect
│   │   ├── Host key verification explained
│   │   └── Connection troubleshooting
│   ├── managing-hosts.md
│   │   ├── Creating hosts
│   │   ├── Editing hosts
│   │   ├── Host groups
│   │   ├── Search and filter
│   │   └── Recent connections
│   ├── managing-keys.md
│   │   ├── Generating SSH keys
│   │   ├── Importing existing keys
│   │   ├── Exporting public keys
│   │   ├── Copying public key to server
│   │   └── Key types explained (Ed25519 vs RSA vs ECDSA)
│   ├── sftp-file-transfer.md
│   │   ├── Opening SFTP browser
│   │   ├── Navigating directories
│   │   ├── Uploading files
│   │   ├── Downloading files
│   │   └── Transfer progress
│   └── troubleshooting.md
│       ├── Connection refused
│       ├── Authentication failed
│       ├── Host key mismatch
│       ├── Timeout errors
│       └── Platform-specific issues
│
├── Developer Guide
│   ├── contributing.md (how to contribute)
│   ├── development-setup.md (Flutter install, build, run)
│   └── code-style-guide.md (linter rules, naming conventions)
│
├── In-App Help
│   ├── Tooltip on every form field
│   ├── Empty state messages with guidance
│   ├── Error messages with actionable suggestions
│   └── First-run hints (coach marks on key features)
│
└── Legal
    ├── privacy-policy.md
    ├── terms-of-service.md
    └── LICENSES (third-party license list)
```

### Phase 2: Advanced Features

```
ADD to documentation:
├── User Guide
│   ├── terminal-customization.md
│   │   ├── Changing terminal themes
│   │   ├── Changing fonts
│   │   ├── Font size and ligatures
│   │   ├── Cursor style
│   │   └── Bell settings
│   ├── snippets.md
│   │   ├── Creating snippets
│   │   ├── Snippet categories
│   │   ├── Variables in snippets
│   │   └── Quick-insert from terminal
│   ├── port-forwarding.md
│   │   ├── Local port forwarding explained
│   │   ├── Remote port forwarding explained
│   │   ├── Creating forwarding rules
│   │   └── Managing active forwards
│   ├── keyboard-shortcuts.md
│   │   ├── Full shortcut reference table
│   │   ├── Command palette usage
│   │   └── Customizing shortcuts
│   └── split-panes.md
│       ├── Creating splits
│       ├── Navigating between panes
│       └── Resizing panes
│
└── Update troubleshooting.md with new scenarios
```

### Phase 3: Sync & Security

```
ADD to documentation:
├── User Guide
│   ├── vault-and-encryption.md
│   │   ├── What is the vault?
│   │   ├── Setting a master password
│   │   ├── How your data is encrypted (simple explanation)
│   │   ├── What happens if you forget your master password
│   │   ├── Biometric unlock setup
│   │   ├── Auto-lock settings
│   │   └── Changing your master password
│   ├── sync-across-devices.md
│   │   ├── Creating an account
│   │   ├── Enabling sync
│   │   ├── How sync works (simple explanation)
│   │   ├── What gets synced
│   │   ├── Offline mode
│   │   ├── Conflict resolution
│   │   ├── Exporting your vault
│   │   └── Importing a vault
│   └── two-factor-auth.md
│       ├── Setting up TOTP
│       ├── Using authenticator apps
│       └── Recovery codes
│
├── Security Documentation
│   ├── security-whitepaper.md
│   │   ├── Encryption architecture (technical)
│   │   ├── Key derivation process
│   │   ├── Zero-knowledge proof
│   │   ├── Threat model summary
│   │   └── Algorithm choices and rationale
│   ├── encryption-specification.md
│   │   ├── Full protocol specification
│   │   ├── Reference implementation pointers
│   │   └── Test vectors
│   └── responsible-disclosure.md
│       ├── How to report vulnerabilities
│       ├── Scope of bug bounty
│       ├── Response timeline commitments
│       └── Hall of fame
│
├── API Reference
│   ├── authentication.md
│   │   ├── POST /auth/register
│   │   ├── POST /auth/login
│   │   ├── POST /auth/refresh
│   │   ├── POST /auth/logout
│   │   ├── POST /auth/forgot-password
│   │   ├── POST /auth/reset-password
│   │   ├── POST /auth/verify-2fa
│   │   └── Error codes and handling
│   ├── vault-sync.md
│   │   ├── POST /vault/init
│   │   ├── GET /vault?since_version=N
│   │   ├── PATCH /vault
│   │   ├── DELETE /vault/entry/:id
│   │   ├── Sync protocol explanation
│   │   └── Rate limits
│   └── user-management.md
│       ├── GET /user/profile
│       ├── PUT /user/profile
│       ├── DELETE /user/account
│       ├── GET /user/devices
│       └── DELETE /user/devices/:id
│
└── Update FAQ with sync/security questions
```

### Phase 4: Polish & Self-Hosting

```
ADD to documentation:
├── Self-Hosting Guide
│   ├── quick-start.md
│   │   ├── Requirements (Docker, 1GB RAM, PostgreSQL)
│   │   ├── One-command install
│   │   ├── First-time setup
│   │   └── Connecting your app to self-hosted server
│   ├── docker-compose.md
│   │   ├── Full docker-compose.yml reference
│   │   ├── Service descriptions
│   │   ├── Volume mounts
│   │   └── Network configuration
│   ├── environment-variables.md
│   │   ├── Required variables
│   │   ├── Optional variables
│   │   ├── Security-related variables
│   │   └── Example .env file
│   ├── reverse-proxy-setup.md
│   │   ├── Nginx configuration
│   │   ├── Caddy configuration
│   │   ├── Traefik configuration
│   │   └── SSL/TLS certificate setup
│   ├── backup-restore.md
│   │   ├── Automated backup setup
│   │   ├── Manual backup procedure
│   │   ├── Restore from backup
│   │   └── Backup encryption
│   ├── upgrading.md
│   │   ├── Upgrade procedure
│   │   ├── Database migrations
│   │   ├── Breaking changes reference
│   │   └── Rollback procedure
│   ├── monitoring.md
│   │   ├── Health check endpoint
│   │   ├── Prometheus metrics
│   │   ├── Log aggregation
│   │   └── Alerting setup
│   └── troubleshooting.md
│       ├── Common deployment issues
│       ├── Database connection problems
│       ├── TLS certificate issues
│       ├── Performance tuning
│       └── Log analysis
│
├── User Guide additions
│   ├── cloud-provider-import.md
│   │   ├── AWS EC2 import
│   │   ├── DigitalOcean import
│   │   └── Managing imported hosts
│   └── custom-themes.md
│       ├── Creating custom terminal themes
│       ├── Sharing themes
│       └── Theme file format
│
└── documentation website launch (Docusaurus)
```

### Phase 5: Ecosystem

```
ADD to documentation:
├── User Guide
│   ├── team-vaults.md
│   ├── mosh-support.md
│   └── plugins-extensions.md
│
├── Developer Guide
│   ├── plugin-development.md
│   │   ├── Extension API reference
│   │   ├── Extension manifest format
│   │   ├── Creating your first extension
│   │   ├── Publishing to marketplace
│   │   └── Security requirements for extensions
│   └── building-from-source.md
│       ├── Full build instructions per platform
│       ├── Signing certificates
│       └── Reproducible build verification
│
└── Community
    ├── CODE_OF_CONDUCT.md
    ├── CONTRIBUTING.md (expanded)
    ├── SECURITY.md (vulnerability reporting)
    └── Translation guide (i18n contribution)
```

---

## 4. In-App Documentation Standards

### 4.1 Tooltips

```
RULES:
• Every form field has a tooltip explaining expected format
• Tooltips appear on hover (desktop) or info icon tap (mobile)
• Maximum 2 sentences, under 120 characters
• Include an example where possible

EXAMPLES:
┌─────────────────────────────────────────────────────────────┐
│ Hostname                                                    │
│ ┌─────────────────────────────────────────────────────┐     │
│ │ 192.168.1.10                                 ⓘ     │     │
│ └─────────────────────────────────────────────────────┘     │
│ ⓘ IP address or domain name. Example: 192.168.1.10         │
│   or server.example.com                                     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Port                                                        │
│ ┌──────────────────┐                                        │
│ │ 22          ⓘ   │                                        │
│ └──────────────────┘                                        │
│ ⓘ SSH port number. Default is 22. Range: 1-65535            │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 Empty States

```
Every list/view with no data shows a helpful empty state:

┌─────────────────────────────────────────────────────────────┐
│                                                             │
│                       🖥                                    │
│                                                             │
│              No hosts added yet                             │
│                                                             │
│   Add your first server to start connecting.                │
│   You'll need the hostname, port, and login                 │
│   credentials.                                              │
│                                                             │
│            [+ Add Your First Host]                          │
│                                                             │
│   Need help? View the Getting Started guide ▸              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 4.3 Error Messages

```
FORMAT: [What happened] + [Why] + [What to do]

GOOD:
  "Connection refused. The server at 192.168.1.10:22 isn't
   accepting connections. Check that SSH is running and the
   port is correct. [Edit Host] [Retry]"

BAD:
  "Error: ECONNREFUSED"

GOOD:
  "Authentication failed. The server rejected your password.
   Double-check your username and password, or try a
   different authentication method. [Edit Host] [Use Key Auth]"

BAD:
  "Auth failed"

GOOD:
  "Host key mismatch! The server's identity has changed since
   you last connected. This could indicate a security issue
   (man-in-the-middle attack) or a legitimate server change.
   [View Details] [Accept New Key] [Disconnect]"

BAD:
  "Host key verification failed"
```

### 4.4 First-Run Coach Marks

```
Show on first launch after onboarding (dismissable, don't repeat):

Step 1: Hosts List
  "This is your host list. Tap '+' to add your first server."
  [Highlight: + button]

Step 2: After first host added
  "Tap a host to see its details, or double-tap to connect."
  [Highlight: host item]

Step 3: First terminal session
  "You're connected! This extra keyboard row has keys you'll
   need: Ctrl, Alt, Esc, Tab, and arrow keys."
  [Highlight: extra keys bar]

Step 4: After first session
  "Find your SSH keys, snippets, and SFTP browser in the
   sidebar (desktop) or bottom navigation (mobile)."
  [Highlight: navigation]
```

---

## 5. Code Documentation Standards

### 5.1 Dart Documentation Comments (dartdoc)

```dart
/// Rules for code documentation:
///
/// 1. Every public class MUST have a doc comment
/// 2. Every public method MUST have a doc comment
/// 3. Private methods: doc comment if logic is non-obvious
/// 4. Use /// (not /** */) for Dart doc comments
/// 5. First sentence = summary (shown in autocomplete)
/// 6. Include @param, @returns, @throws where applicable
/// 7. Include code examples for complex APIs
```

```dart
/// Manages SSH connections to remote servers.
///
/// Handles connection lifecycle: connect, authenticate, maintain,
/// and disconnect. Supports password, key, and interactive auth.
///
/// Usage:
/// ```dart
/// final service = SshService();
/// final session = await service.connect(
///   host: myHost,
///   key: myKey,
/// );
/// ```
///
/// See also:
/// - [SshSession] for individual session management
/// - [SftpService] for file transfer operations
class SshService {

  /// Establishes an SSH connection to the specified host.
  ///
  /// [host] contains connection details (hostname, port, username).
  /// [key] is optional; if null, falls back to password auth.
  /// [onPasswordRequest] callback for interactive password prompt.
  ///
  /// Returns an [SshSession] on success.
  ///
  /// Throws [SshAuthException] if authentication fails.
  /// Throws [SshConnectionException] if connection cannot be established.
  /// Throws [SshHostKeyException] if host key verification fails.
  Future<SshSession> connect({
    required Host host,
    SshKey? key,
    String Function()? onPasswordRequest,
  }) async { ... }
}
```

### 5.2 Architecture Decision Records (ADR)

```markdown
# ADR-001: Flutter over React Native

## Status
Accepted

## Context
We need a cross-platform framework for iOS, Android, macOS, and Windows.

## Decision
We chose Flutter (Dart) over React Native + Electron.

## Rationale
1. dartssh2 + xterm.dart are pure Dart — no platform bridging
2. Single codebase for ALL platforms (RN needs Electron for desktop)
3. Flutter desktop is production-stable (Ubuntu installer reference)
4. 60fps terminal rendering via Skia/Impeller
5. flutter_secure_storage provides unified keychain access

## Consequences
- Team needs Dart proficiency (not JavaScript)
- UI won't use native platform widgets (custom-rendered)
- Smaller plugin ecosystem than React Native

## Date
2026-02-08
```

---

## 6. Documentation Tooling

### 6.1 Tools

```
┌─────────────────────┬────────────────────────────────────────────────────┐
│ Tool                │ Purpose                                            │
├─────────────────────┼────────────────────────────────────────────────────┤
│ Docusaurus          │ Documentation website (docs.cloudshell.app)       │
│                     │ Versioned docs, search, dark mode, i18n           │
├─────────────────────┼────────────────────────────────────────────────────┤
│ dart doc            │ Auto-generate API reference from dartdoc comments │
│                     │ Hosted alongside main docs                        │
├─────────────────────┼────────────────────────────────────────────────────┤
│ Mermaid             │ Diagrams in markdown (flow charts, sequence diags)│
│                     │ Embedded in Docusaurus pages                      │
├─────────────────────┼────────────────────────────────────────────────────┤
│ OpenAPI / Swagger   │ Backend API specification (auto-gen from code)    │
│                     │ Interactive API explorer                          │
├─────────────────────┼────────────────────────────────────────────────────┤
│ Markdown lint       │ Consistent markdown formatting (markdownlint-cli) │
│                     │ Run in CI on all .md files                        │
├─────────────────────┼────────────────────────────────────────────────────┤
│ Screenshots CI      │ Automated screenshots for docs (flutter_test)     │
│                     │ Update on each release                            │
├─────────────────────┼────────────────────────────────────────────────────┤
│ Vale                │ Prose linter for consistent writing style         │
│                     │ Enforce terminology, voice, and clarity           │
└─────────────────────┴────────────────────────────────────────────────────┘
```

### 6.2 Writing Style Guide

```
VOICE:
• Active voice, present tense ("Tap the button" not "The button should be tapped")
• Second person ("You can..." not "Users can...")
• Direct and concise (no filler words)
• Friendly but professional (not overly casual)

TERMINOLOGY (consistent across all docs):
• "host" not "server" or "connection" (when referring to saved entry)
• "connect" not "SSH into" or "log in to"
• "vault" not "database" or "storage" (when referring to encrypted store)
• "master password" not "main password" or "vault password"
• "key" or "SSH key" not "certificate" or "credential"
• "snippet" not "command" or "macro"
• "tap" (mobile) / "click" (desktop) — use platform-appropriate

FORMATTING:
• Headers: Title Case for H1/H2, Sentence case for H3+
• Code: backticks for inline code, fenced blocks for multi-line
• UI elements: **bold** for button names, menu items
• Keyboard shortcuts: `Cmd+K` format
• File paths: `monospace` format
• Maximum line length: 100 characters (for readability in editors)
• Lists: use bullets for unordered, numbers only for sequential steps
```

---

## 7. Documentation Quality Gates

### CI/CD Integration

```
On every PR that modifies docs:
├── markdownlint (formatting validation)
├── vale (prose quality check)
├── Link checker (dead link detection)
├── Spell check (cspell with custom dictionary)
└── Build test (Docusaurus builds without errors)

On every release:
├── Screenshot generation (automated from widget tests)
├── API reference regeneration (dart doc)
├── Changelog entry required
├── Version number update in docs
└── Documentation deployment to docs.cloudshell.app
```

### Review Checklist for Documentation PRs

```
□ Accurate — information matches current behavior
□ Complete — covers all necessary steps, no gaps
□ Clear — understandable by target audience
□ Consistent — follows style guide and terminology
□ Up to date — screenshots and examples match current UI
□ Accessible — alt text for images, semantic structure
□ Cross-referenced — links to related docs where helpful
□ Tested — all code examples actually work
```

---

## 8. Documentation Ownership

```
┌────────────────────────────────┬──────────────────────────────────────┐
│ Documentation Area             │ Owner / Responsibility              │
├────────────────────────────────┼──────────────────────────────────────┤
│ User guide                     │ Feature developer + tech writer     │
│ API reference                  │ Backend developer (auto-generated)  │
│ Security documentation         │ Security lead                       │
│ Self-hosting guide             │ DevOps / infrastructure engineer    │
│ Architecture docs (docs/)      │ Tech lead                           │
│ Code documentation (dartdoc)   │ Every developer (own code)          │
│ Changelog                      │ Release manager                     │
│ In-app help text               │ UX designer + developer             │
│ Error messages                 │ UX designer + developer             │
│ Design system docs             │ UI/UX lead                          │
│ ADRs                           │ Decision maker (author) + tech lead │
└────────────────────────────────┴──────────────────────────────────────┘

RULE: Every feature PR must include documentation updates.
      No feature merges without corresponding docs.
      "Documentation is not optional — it's a deliverable."
```

---

## 9. Documentation Metrics

```
Track monthly:
├── Documentation coverage (% of features with user docs)
├── dartdoc coverage (% of public APIs with doc comments)
├── Documentation freshness (% of docs updated in last 90 days)
├── Search queries with no results (gaps to fill)
├── Support tickets that could be prevented by better docs
├── Time-to-first-success for new users (from install to first SSH)
└── Documentation site traffic and most-viewed pages

Targets:
├── User guide coverage: 100% of shipped features
├── dartdoc coverage: > 90% of public APIs
├── All docs updated within 30 days of related feature change
├── Zero broken links
└── < 5% of support tickets attributable to documentation gaps
```

---

## 10. Documentation Website Plan

### Site Structure (docs.cloudshell.app)

```
Home
├── Getting Started
│   ├── Installation
│   ├── Quick Start
│   └── First Connection
├── User Guide
│   ├── Hosts & Connections
│   ├── SSH Keys
│   ├── Terminal
│   ├── SFTP
│   ├── Port Forwarding
│   ├── Snippets
│   ├── Vault & Security
│   ├── Sync
│   └── Customization
├── Self-Hosting
│   ├── Quick Start
│   ├── Configuration
│   ├── Deployment
│   └── Maintenance
├── Developer Guide
│   ├── Contributing
│   ├── Architecture
│   ├── API Reference
│   └── Plugin Development
├── Security
│   ├── Whitepaper
│   ├── Encryption Spec
│   └── Responsible Disclosure
├── FAQ
├── Changelog
└── Blog
    ├── Release announcements
    ├── Security advisories
    └── Technical deep-dives
```

### Timeline

```
Phase 1 release: README + basic docs in repo (Markdown)
Phase 2 release: Docusaurus site scaffolded, user guide live
Phase 3 release: Security docs, API reference, full site
Phase 4 release: Self-hosting guide, search, versioned docs
Phase 5 release: Plugin dev docs, translations, community forum
```
