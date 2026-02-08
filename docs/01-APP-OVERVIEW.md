# CloudShell - Cross-Platform SSH Client
## App Overview & Vision

### App Name: **CloudShell**
*Tagline: "Your servers. Everywhere."*

---

## 1. What We're Building

A cross-platform SSH/SFTP client that syncs securely across macOS, Windows, iOS, and Android. Think Termius, but better — faster, more customizable, privacy-first with self-hosting option, and no forced subscriptions for basic sync.

### Core Value Propositions
1. **One app, all devices** — Single Flutter codebase for iOS, Android, macOS, Windows
2. **Zero-knowledge sync** — E2E encrypted vault synced across all devices
3. **Self-hostable backend** — Users can run their own sync server
4. **Free core features** — Sync, keys, SFTP included free (not paywalled like Termius)
5. **Beautiful terminal** — 60fps rendering, custom themes, split panes
6. **Developer-first UX** — Command palette, snippets, keyboard-driven workflow

---

## 2. Target Users

| Persona | Description | Key Needs |
|---------|-------------|-----------|
| **DevOps Engineer** | Manages 50+ servers daily | Fast host switching, groups, snippets, port forwarding |
| **Freelance Developer** | Works across personal laptop, work desktop, phone | Cross-device sync, simple key management |
| **Sysadmin** | Maintains enterprise infrastructure | Jump hosts, SFTP, multi-session, team sharing |
| **Mobile-first User** | Quick SSH from iPad/phone on the go | Touch-optimized terminal, extra keyboard row |
| **Self-hoster** | Privacy-conscious, runs own infra | Self-hosted sync, open-source, no cloud dependency |

---

## 3. Competitive Analysis

### Termius (Primary Competitor)
- **Strengths**: Cross-platform, beautiful UI, cloud sync, team features
- **Weaknesses**: Expensive ($10/mo for basic features), Electron-heavy on desktop, SFTP/port forwarding paywalled, no self-hosting, vendor lock-in
- **User complaints**: Price for basic features, laggy on older hardware, no local-only mode, can't export data easily

### Blink Shell (iOS only)
- **Strengths**: Native iOS performance, Mosh support, Files.app integration, themeable
- **Weaknesses**: iOS/iPadOS only, no cross-platform sync, steep learning curve
- **Key takeaway**: Excellent mobile terminal UX with gesture controls

### Prompt by Panic (iOS/macOS)
- **Strengths**: Native Apple design, iCloud sync, Clips (snippets), beautiful
- **Weaknesses**: Apple ecosystem only, no Windows/Android, limited features
- **Key takeaway**: Shows how good native-feeling SSH can be on Apple platforms

### ServerCat (iOS)
- **Strengths**: Server monitoring dashboard, clean iOS design, system stats
- **Weaknesses**: iOS only, limited terminal features, basic SSH
- **Key takeaway**: The server monitoring/dashboard concept is popular

### Royal TSX (macOS)
- **Strengths**: Multi-protocol (SSH, RDP, VNC), credential management, plugins
- **Weaknesses**: macOS only, complex UI, enterprise-focused pricing
- **Key takeaway**: Multi-protocol support and plugin architecture

### Tabby Terminal (Desktop)
- **Strengths**: Open source, plugin ecosystem, beautiful UI, split panes, serial support
- **Weaknesses**: Electron-based (heavy), no mobile, community-maintained
- **Key takeaway**: Excellent plugin/extension architecture, theme system

### mRemoteNG (Windows)
- **Strengths**: Free, open source, multi-protocol, tabbed connections
- **Weaknesses**: Windows only, dated UI, no encryption for stored passwords by default
- **Key takeaway**: Feature richness is possible in FOSS

---

## 4. How CloudShell Will Be Better

| Feature | Termius | CloudShell (Ours) |
|---------|---------|-------------------|
| Basic sync | Paid ($10/mo) | Free |
| SFTP | Paid | Free |
| Port forwarding | Paid | Free |
| Self-hosted sync | No | Yes |
| Open source client | No | Yes |
| Desktop framework | Electron (heavy) | Flutter (native-compiled) |
| Team sharing | Paid ($20/user/mo) | Self-hosted option |
| Export data | Limited | Full JSON/encrypted export |
| Terminal themes | Limited preset | Community themes + custom |
| Plugin/Extension | No | Planned (Phase 5) |
| Local-only mode | No | Yes (no account required) |
| Server monitoring | No | Basic dashboard (Phase 4) |

---

## 5. Business Model

### Free Tier
- Unlimited local connections
- Sync across all devices (personal vault)
- SSH, SFTP, port forwarding
- Key management
- 5 snippets
- 3 terminal themes

### Pro Tier ($5/month or $48/year)
- Unlimited snippets
- Unlimited themes
- Team vault sharing
- Cloud provider import (AWS, DO, GCP)
- Priority support
- Advanced features (Mosh, serial, etc.)

### Self-Hosted (Free)
- Run your own sync server
- All Pro features unlocked
- Docker Compose deployment
- Community support only
