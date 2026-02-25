# Changelog

## 1.1.0

### Internationalization
- 7 supported languages: English, Spanish, German, French, Japanese, Chinese (Simplified), Korean
- Language picker in Settings > Appearance
- 600+ localized strings across all screens

### Additional Protocols
- Telnet protocol support (RFC 854 with IAC negotiation, NAWS, terminal type)
- Serial port support (baud rates 300–921600, desktop only)

### Open Source
- MIT license
- Contributing guidelines, security policy, issue templates
- CI/CD pipeline for all desktop platforms

---

## 1.0.0

Initial release of CloudShell — a cross-platform SSH client.

### Terminal
- Full xterm-compatible terminal emulation with 256-color and truecolor support
- Multiple terminal tabs with persistent scrollback across navigation
- Split panes (horizontal and vertical) with resizable dividers
- 9 built-in terminal themes plus custom theme editor
- Configurable font family, size, ligatures, and cursor style
- Terminal zoom (Cmd+=/-)
- Clickable URLs in terminal output
- Visual bell, broadcast input to multiple sessions
- Search in terminal output (Cmd+Shift+F)
- Extra keyboard row for mobile (Ctrl, Alt, Esc, Tab, arrows)
- Swipe gestures for tab switching, pinch-to-zoom, haptic feedback

### SSH & Connections
- SSH2 protocol with password and key authentication
- RSA, Ed25519, and ECDSA key support
- Proxy jump / bastion host connections
- Auto-reconnect on disconnect
- Host key verification (TOFU model)
- Known hosts management
- Configurable connection defaults (port, timeout, keep-alive)
- PPK format key import

### Host Management
- Full CRUD for hosts with labels, groups, and tags
- Quick connect dialog (user@host:port)
- Favorites, recent connections, search
- Drag-and-drop host reordering
- Nested host groups with inheritable defaults

### SFTP
- File browser with breadcrumb navigation
- Upload and download with progress indicators
- Create, rename, and delete files/directories
- File permissions viewer/editor
- Dual-pane browser (local + remote)
- Drag-and-drop upload on desktop
- Edit remote text files in-app

### Port Forwarding
- Local, remote, and dynamic (SOCKS proxy) forwarding
- Saved forwarding rules
- Active forwarding session management

### Snippets & Commands
- Create, edit, and delete command snippets
- Category organization
- Variable substitution ({{var}}) with input prompts
- Quick-insert from any terminal session
- Command palette (Cmd+K) with fuzzy search

### Security
- Zero-knowledge encrypted vault (Argon2id KDF + AES-256-GCM)
- Biometric app lock (Touch ID / Face ID)
- Secure clipboard with 30-second auto-clear
- Device-bound secret storage (AES-256-GCM)
- TOTP two-factor authentication
- Password generator
- Session timeout with auto-lock

### Sync & Account
- Optional account with E2E encrypted sync
- Sync hosts, keys, snippets, and settings across devices
- Offline mode with local queue
- Conflict resolution (last-write-wins)
- Encrypted vault export/import
- Delete account flow

### Cloud Import
- AWS EC2 instance import
- DigitalOcean droplet import

### Workspaces
- Save and restore terminal tab layouts
- Auto-save with debounce
- Workspace manager screen

### Customization
- Dark and light themes with system follow
- 10 bundled terminal fonts
- Global and terminal keyboard shortcuts
- Shortcut reference overlay (Cmd+/)

### Platform Support
- macOS, iOS, iPadOS, Android, Windows, Linux
- iPad multitasking (Split View / Slide Over)
- Responsive layout (desktop sidebar, mobile bottom nav)
