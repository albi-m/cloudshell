# CloudShell - Project Documentation Index

*"Your servers. Everywhere."*

A cross-platform SSH/SFTP client with E2E encrypted sync across macOS, Windows, iOS, and Android.

---

## Documentation

| # | Document | Path | Description |
|---|----------|------|-------------|
| 1 | **App Overview** | `docs/01-APP-OVERVIEW.md` | Vision, competitive analysis, business model, how we're better than Termius |
| 2 | **Feature List** | `docs/02-FEATURE-LIST.md` | Complete feature inventory (95 features) and screen inventory (40 screens) with priorities and phases |
| 3 | **Navigation Flow** | `docs/03-NAVIGATION-FLOW.md` | Information architecture, screen flow diagrams, keyboard shortcuts, mobile gestures, app lifecycle state machine |
| 4 | **Development Plan** | `docs/04-DEVELOPMENT-PLAN.md` | 5-phase development plan with sprint-level task breakdowns, release milestones, testing strategy, risk mitigation |
| 5 | **Security Plan** | `docs/05-SECURITY-PLAN.md` | Full threat model, encryption spec (Argon2id + AES-256-GCM + HKDF), OWASP Mobile Top 10 mitigations, incident response plan, backend hardening, compliance (GDPR/CCPA), security audit schedule, SDL |
| 6 | **Documentation Plan** | `docs/06-DOCUMENTATION-PLAN.md` | 4-layer doc strategy (user/developer/ops/internal), per-phase doc deliverables, in-app help standards, code documentation rules (dartdoc), writing style guide, doc tooling (Docusaurus), quality gates, documentation website plan |

---

## Reference Materials

| # | Document | Path | Description |
|---|----------|------|-------------|
| 1 | **Design System** | `reference/design-system/DESIGN-SYSTEM.md` | Complete design system: colors (dark+light), 9 terminal themes with ANSI hex codes, typography (Inter + JetBrains Mono), Lucide icon system, spacing scale, component patterns, animation specs |
| 2 | **Wireframes** | `reference/wireframes/WIREFRAMES.md` | ASCII wireframes for ALL screens: desktop layout, host list, add host, terminal, split panes, keys, SFTP, port forwarding, snippets, settings, command palette, dialogs. Plus all mobile layouts |
| 3 | **Architecture** | `reference/architecture/ARCHITECTURE.md` | System architecture diagram, Flutter project structure, all data models (Freezed), E2E encryption architecture (Argon2id + AES-256-GCM), sync protocol, full dependency list (pubspec.yaml) |
| 4 | **Mobile UX Guide** | `reference/design-system/MOBILE-UX-GUIDE.md` | Extra keyboard row design, touch gesture map, portrait/landscape layouts, haptic feedback specs, mobile accessibility requirements |

---

## Quick Reference

### Tech Stack
- **Framework:** Flutter (Dart) — single codebase for iOS, Android, macOS, Windows
- **SSH:** dartssh2 — pure Dart SSH2 + SFTP
- **Terminal:** xterm.dart — 60fps terminal emulator
- **Database:** Drift + SQLCipher — encrypted local storage
- **Secure Storage:** flutter_secure_storage — Keychain/Keystore/DPAPI
- **State:** Riverpod — reactive state management
- **Crypto:** pointycastle + cryptography — AES-256-GCM, Argon2id
- **Backend:** Rust (Axum) or Go (Gin) + PostgreSQL
- **Icons:** Lucide — 1400+ clean icons
- **UI Font:** Inter — designed for screens
- **Terminal Font:** JetBrains Mono — ligatures, optimized for code

### Security Posture
- **Zero-knowledge** — server only stores encrypted blobs
- **Argon2id KDF** — 64MB memory, 3 iterations (brute-force resistant)
- **Per-item AES-256-GCM** — with unique IVs and AAD
- **Platform keychains** — iOS Keychain, Android Keystore, Windows DPAPI
- **SQLCipher** — database encrypted at rest
- **TLS 1.3 + cert pinning** — on sync API
- **Incident response plan** — SEV 1-4 with defined procedures
- **OWASP Mobile Top 10** — mitigated across all categories

### Design Decisions
- **Dark-first** design with light theme support
- **Sidebar navigation** on desktop/tablet, **bottom tab bar** on mobile
- **9 built-in terminal themes** (CloudShell Default, Dracula, Nord, Solarized, One Dark, Catppuccin, Tokyo Night, Gruvbox, Monokai)
- **Zero-knowledge sync** — server never sees plaintext data
- **Bitwarden-style encryption** — Argon2id KDF + per-item AES-256-GCM
- **Self-hostable** backend via Docker

### Development Phases
1. **Phase 1 (10 weeks):** Core SSH client — terminal, hosts, keys, SFTP
2. **Phase 2 (8 weeks):** Advanced — split panes, snippets, command palette, theming
3. **Phase 3 (8 weeks):** Sync — vault encryption, E2E sync, auth, biometrics
4. **Phase 4 (6 weeks):** Polish — cloud import, self-hosting, performance
5. **Phase 5 (6 weeks):** Ecosystem — Mosh, teams, plugins, i18n
