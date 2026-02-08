# CloudShell - Complete Feature List & Screen Inventory

---

## Feature Categories

### F1. Connection Management

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F1.1 | SSH2 connection (password auth) | P0 | 1 |
| F1.2 | SSH2 connection (key auth - RSA, Ed25519, ECDSA) | P0 | 1 |
| F1.3 | SSH2 connection (keyboard-interactive auth) | P1 | 1 |
| F1.4 | Host CRUD (create, read, update, delete) | P0 | 1 |
| F1.5 | Host groups with inherited settings | P1 | 2 |
| F1.6 | Host tags and search | P1 | 2 |
| F1.7 | Quick connect (temporary connection without saving) | P0 | 1 |
| F1.8 | Jump host / proxy support | P2 | 3 |
| F1.9 | Mosh (mobile shell) support | P2 | 4 |
| F1.10 | Telnet support | P3 | 4 |
| F1.11 | Serial port support | P3 | 5 |
| F1.12 | Auto-reconnect on disconnect | P1 | 2 |
| F1.13 | Connection timeout configuration | P1 | 2 |
| F1.14 | Keep-alive settings | P1 | 2 |
| F1.15 | SSH agent forwarding | P2 | 3 |
| F1.16 | X11 forwarding | P3 | 5 |

### F2. Terminal

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F2.1 | Full VT100/VT220/xterm emulation | P0 | 1 |
| F2.2 | 256-color and truecolor (24-bit) support | P0 | 1 |
| F2.3 | Unicode and wide character (CJK) rendering | P0 | 1 |
| F2.4 | Scrollback buffer (configurable size) | P0 | 1 |
| F2.5 | Text selection and copy/paste | P0 | 1 |
| F2.6 | Multiple tabs | P0 | 1 |
| F2.7 | Split panes (horizontal/vertical) | P1 | 2 |
| F2.8 | Font customization (family, size) | P1 | 2 |
| F2.9 | Color scheme / theme support | P1 | 2 |
| F2.10 | Clickable URLs | P1 | 2 |
| F2.11 | Search within terminal output | P2 | 3 |
| F2.12 | Bell notification (visual/audible) | P2 | 2 |
| F2.13 | Broadcast input to multiple sessions | P3 | 4 |
| F2.14 | Session logging / export | P2 | 3 |
| F2.15 | Terminal resize handling (SIGWINCH) | P0 | 1 |
| F2.16 | Font ligature support | P3 | 4 |

### F3. Mobile Terminal Enhancements

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F3.1 | Extra keyboard row (Ctrl, Alt, Esc, Tab, arrows) | P0 | 1 |
| F3.2 | Swipe gestures for tab switching | P1 | 2 |
| F3.3 | Pinch-to-zoom font size | P1 | 2 |
| F3.4 | Long-press for text selection | P0 | 1 |
| F3.5 | Two-finger scroll for scrollback | P1 | 2 |
| F3.6 | Hardware keyboard support | P0 | 1 |
| F3.7 | Haptic feedback on key press | P2 | 3 |
| F3.8 | Landscape orientation support | P0 | 1 |
| F3.9 | iPad multitasking (Split View, Slide Over) | P2 | 3 |

### F4. Key Management

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F4.1 | Generate SSH keys (RSA 2048/4096, Ed25519, ECDSA) | P0 | 1 |
| F4.2 | Import keys from file | P0 | 1 |
| F4.3 | Import keys from clipboard | P1 | 1 |
| F4.4 | Export public key | P0 | 1 |
| F4.5 | Copy public key to clipboard | P0 | 1 |
| F4.6 | Passphrase-protected keys | P0 | 1 |
| F4.7 | Key label/naming | P0 | 1 |
| F4.8 | Associate keys with hosts | P0 | 1 |
| F4.9 | Known hosts management | P1 | 2 |
| F4.10 | Host key fingerprint verification | P0 | 1 |
| F4.11 | PEM, OpenSSH, PPK format support | P1 | 2 |

### F5. SFTP / File Transfer

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F5.1 | SFTP file browser (list, navigate) | P0 | 1 |
| F5.2 | Upload files | P0 | 1 |
| F5.3 | Download files | P0 | 1 |
| F5.4 | Create directory | P1 | 2 |
| F5.5 | Delete files/directories | P1 | 2 |
| F5.6 | Rename files | P1 | 2 |
| F5.7 | File permissions view/edit | P2 | 3 |
| F5.8 | Drag and drop upload (desktop) | P2 | 3 |
| F5.9 | Transfer progress indicator | P0 | 1 |
| F5.10 | Resume interrupted transfers | P3 | 4 |
| F5.11 | Edit remote files in-app | P2 | 3 |
| F5.12 | Dual-pane file browser (local + remote) | P2 | 3 |

### F6. Port Forwarding

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F6.1 | Local port forwarding | P1 | 2 |
| F6.2 | Remote port forwarding | P1 | 2 |
| F6.3 | Dynamic port forwarding (SOCKS proxy) | P2 | 3 |
| F6.4 | Saved port forwarding rules | P1 | 2 |
| F6.5 | Active forwarding indicator/management | P1 | 2 |

### F7. Snippets

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F7.1 | Create/edit/delete snippets | P1 | 2 |
| F7.2 | Snippet categories/folders | P2 | 3 |
| F7.3 | Variable substitution in snippets | P2 | 3 |
| F7.4 | Quick-insert snippet from terminal | P1 | 2 |
| F7.5 | Share snippets across devices (sync) | P1 | 3 |

### F8. Vault & Security

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F8.1 | Master password vault encryption | P0 | 3 |
| F8.2 | Biometric unlock (Face ID, Touch ID, Fingerprint) | P1 | 3 |
| F8.3 | Auto-lock on app background/timeout | P1 | 3 |
| F8.4 | Secure clipboard (auto-clear after timeout) | P2 | 3 |
| F8.5 | Two-factor authentication (TOTP) | P2 | 3 |
| F8.6 | Password generator (for server passwords) | P2 | 3 |

### F9. Sync

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F9.1 | User registration & login | P0 | 3 |
| F9.2 | E2E encrypted vault sync | P0 | 3 |
| F9.3 | Sync hosts, keys, snippets, settings | P0 | 3 |
| F9.4 | Offline mode with local cache | P0 | 3 |
| F9.5 | Conflict resolution (LWW) | P1 | 3 |
| F9.6 | Selective sync (choose what syncs) | P2 | 4 |
| F9.7 | Self-hosted sync server option | P1 | 4 |
| F9.8 | Export/import vault (encrypted JSON) | P1 | 3 |

### F10. Productivity

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F10.1 | Command palette (Cmd+K / Ctrl+K) | P1 | 2 |
| F10.2 | Global search (hosts, snippets, settings) | P1 | 2 |
| F10.3 | Keyboard shortcuts (customizable) | P1 | 2 |
| F10.4 | Quick connect bar | P1 | 2 |
| F10.5 | Recent connections | P0 | 1 |
| F10.6 | Favorites / starred hosts | P1 | 2 |
| F10.7 | Workspaces (grouped sessions) | P3 | 4 |

### F11. Cloud Provider Integration

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F11.1 | AWS EC2 instance import | P3 | 4 |
| F11.2 | DigitalOcean droplet import | P3 | 4 |
| F11.3 | Google Cloud VM import | P3 | 5 |
| F11.4 | Azure VM import | P3 | 5 |
| F11.5 | Hetzner server import | P3 | 5 |

### F12. Settings & Customization

| ID | Feature | Priority | Phase |
|----|---------|----------|-------|
| F12.1 | App theme (dark/light/system) | P0 | 1 |
| F12.2 | Terminal theme selection | P1 | 2 |
| F12.3 | Custom terminal theme editor | P2 | 4 |
| F12.4 | Default SSH settings (port, timeout, keepalive) | P1 | 2 |
| F12.5 | Default terminal settings (font, size, scrollback) | P1 | 2 |
| F12.6 | Notification preferences | P2 | 3 |
| F12.7 | Data management (clear cache, export, delete account) | P1 | 3 |
| F12.8 | About / version info | P0 | 1 |

---

## Screen Inventory

### S1. Onboarding Screens
| ID | Screen | Description |
|----|--------|-------------|
| S1.1 | Welcome / Splash | App logo, tagline, Get Started button |
| S1.2 | Onboarding Slide 1 | "Connect to any server" - SSH illustration |
| S1.3 | Onboarding Slide 2 | "Sync everywhere" - Multi-device illustration |
| S1.4 | Onboarding Slide 3 | "Secure by design" - Lock/vault illustration |
| S1.5 | Auth Choice | Sign Up / Log In / Use Locally (skip sync) |
| S1.6 | Sign Up | Email, password, confirm password |
| S1.7 | Log In | Email, password, forgot password link |
| S1.8 | Master Password Setup | Set master password for vault encryption |

### S2. Main Navigation Screens
| ID | Screen | Description |
|----|--------|-------------|
| S2.1 | Hosts List | Primary screen - list of saved hosts with groups |
| S2.2 | Active Sessions | Currently open terminal sessions/tabs |
| S2.3 | Keys List | SSH key management screen |
| S2.4 | Snippets List | Saved command snippets |
| S2.5 | SFTP Browser | File browser for active SFTP connection |
| S2.6 | Settings | App settings and preferences |

### S3. Host Management Screens
| ID | Screen | Description |
|----|--------|-------------|
| S3.1 | Add/Edit Host | Form: label, hostname, port, username, auth method, key selection |
| S3.2 | Host Detail | View host info, connect button, edit, delete |
| S3.3 | Host Group Editor | Create/edit groups, drag hosts into groups |
| S3.4 | Quick Connect | Minimal dialog: user@host:port, connect |
| S3.5 | Host Search | Search/filter hosts by name, tag, group |

### S4. Terminal Screens
| ID | Screen | Description |
|----|--------|-------------|
| S4.1 | Terminal View | Full-screen terminal with session |
| S4.2 | Terminal with Tabs | Tab bar at top showing multiple sessions |
| S4.3 | Split Pane View | 2+ terminal panes side by side |
| S4.4 | Terminal Search | Search overlay within terminal output |
| S4.5 | Mobile Terminal | Terminal with extra keyboard row at bottom |

### S5. Key Management Screens
| ID | Screen | Description |
|----|--------|-------------|
| S5.1 | Key List | All SSH keys with labels and types |
| S5.2 | Generate Key | Form: key type, bits, label, passphrase |
| S5.3 | Import Key | File picker / paste from clipboard |
| S5.4 | Key Detail | View public key, fingerprint, associated hosts |

### S6. SFTP Screens
| ID | Screen | Description |
|----|--------|-------------|
| S6.1 | SFTP File Browser | Directory listing with breadcrumb navigation |
| S6.2 | File Actions | Context menu: download, delete, rename, permissions |
| S6.3 | Upload Dialog | File picker with progress indicator |
| S6.4 | Transfer Queue | Active/completed transfers with progress |
| S6.5 | Dual Pane Browser | Local files on left, remote on right |

### S7. Snippet Screens
| ID | Screen | Description |
|----|--------|-------------|
| S7.1 | Snippet List | All snippets grouped by category |
| S7.2 | Add/Edit Snippet | Form: name, command, category, variables |
| S7.3 | Snippet Picker | Quick-select overlay from within terminal |

### S8. Port Forwarding Screens
| ID | Screen | Description |
|----|--------|-------------|
| S8.1 | Port Forward List | All saved port forwarding rules |
| S8.2 | Add/Edit Port Forward | Form: type, source port, dest host, dest port |
| S8.3 | Active Forwards | Currently active forwards with stop button |

### S9. Settings Screens
| ID | Screen | Description |
|----|--------|-------------|
| S9.1 | Settings Main | Categories: General, Terminal, Security, Sync, About |
| S9.2 | General Settings | Theme, language, default SSH settings |
| S9.3 | Terminal Settings | Font, size, scrollback, cursor style, bell |
| S9.4 | Security Settings | Master password, biometric, auto-lock, clipboard |
| S9.5 | Sync Settings | Account, sync status, server URL, export/import |
| S9.6 | About | Version, licenses, feedback link |

### S10. Miscellaneous Screens
| ID | Screen | Description |
|----|--------|-------------|
| S10.1 | Command Palette | Overlay with fuzzy search for all actions |
| S10.2 | Connection Progress | Connecting... dialog with fingerprint verification |
| S10.3 | Error Dialog | Connection failed with retry/edit options |
| S10.4 | Host Key Verification | First-time host key fingerprint approval |
| S10.5 | Vault Unlock | Master password / biometric prompt |

---

## Total Screen Count: ~40 unique screens
## Total Feature Count: ~95 features across 12 categories
