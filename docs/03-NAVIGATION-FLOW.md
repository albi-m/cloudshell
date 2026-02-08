# CloudShell - Navigation Flow & Information Architecture

---

## 1. Navigation Architecture

### Desktop (> 1024px): Persistent Sidebar + Tab Bar

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  Sidebar (260px)          Main Content Area          │
│  ┌─────────────┐         ┌──────────────────────┐   │
│  │ Search      │         │ Tab Bar (sessions)   │   │
│  │ ─────────── │         ├──────────────────────┤   │
│  │ Hosts ◀────│─────────│▸ Content View        │   │
│  │ Keys       │         │                      │   │
│  │ Snippets   │         │                      │   │
│  │ Port Fwd   │         │                      │   │
│  │ SFTP       │         │                      │   │
│  │ ─────────── │         │                      │   │
│  │ Settings   │         └──────────────────────┘   │
│  │ Sync Status│                                     │
│  └─────────────┘                                    │
│                                                     │
└─────────────────────────────────────────────────────┘

Sidebar can collapse to 60px (icon-only mode) to maximize terminal space.
```

### Tablet (600-1024px): Collapsible Sidebar

```
Same as desktop but sidebar starts collapsed (60px).
Tap hamburger or swipe right to expand to 260px overlay.
```

### Mobile (< 600px): Bottom Tab Bar + Stack Navigation

```
┌───────────────────────┐
│ Top Bar (context)     │
├───────────────────────┤
│                       │
│   Content Area        │
│   (full width)        │
│                       │
├───────────────────────┤
│ Bottom Nav (5 items)  │
│ Hosts│Term│Keys│Snip│More│
└───────────────────────┘

"More" tab leads to: SFTP, Port Forwarding, Settings, About
```

---

## 2. Screen Flow Diagram

```
                    ┌──────────────┐
                    │  App Launch   │
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │ Vault Locked?│
                    └──────┬───────┘
                    Yes    │    No (first time / local-only)
              ┌────────────┼────────────────┐
              ▼            │                ▼
    ┌──────────────┐       │      ┌──────────────────┐
    │ Vault Unlock │       │      │ Onboarding Flow  │
    │ (Master Pwd  │       │      │ Welcome → Slides │
    │  or Biometric)│      │      │ → Auth Choice    │
    └──────┬───────┘       │      └────────┬─────────┘
           │               │               │
           │               │    ┌──────────┼────────────┐
           │               │    ▼          ▼            ▼
           │               │  Sign Up    Log In     Skip (Local)
           │               │    │          │            │
           │               │    └──────────┼────────────┘
           │               │               │
           │               │    ┌──────────▼─────────┐
           │               │    │ Set Master Password │
           │               │    └──────────┬─────────┘
           │               │               │
           └───────────────┼───────────────┘
                           │
                    ┌──────▼───────┐
                    │  HOSTS LIST  │ ◀──── PRIMARY HOME SCREEN
                    │  (Dashboard) │
                    └──────┬───────┘
                           │
           ┌───────────┬───┼───────┬────────────┐
           ▼           ▼   ▼       ▼            ▼
    ┌────────────┐ ┌──────┐ ┌────┐ ┌─────────┐ ┌──────┐
    │ Host Detail│ │ Keys │ │Snip│ │ Settings│ │ SFTP │
    └─────┬──────┘ └──┬───┘ └──┬─┘ └─────────┘ └──────┘
          │           │        │
    ┌─────▼──────┐    │        │
    │  Connect   │    │        │
    └─────┬──────┘    │        │
          │           │        │
    ┌─────▼──────┐    │        │
    │Host Key OK?│    │        │
    └─────┬──────┘    │        │
     Yes  │  No→Reject│        │
          │           │        │
    ┌─────▼──────────────────────────┐
    │        TERMINAL VIEW           │
    │  (Multi-tab, split panes)      │
    │                                │
    │  From terminal, access:        │
    │  ├─ Snippet Picker (overlay)   │
    │  ├─ SFTP Browser (side panel)  │
    │  ├─ Port Forwarding (panel)    │
    │  ├─ Search in terminal         │
    │  └─ Command Palette (Cmd+K)    │
    └────────────────────────────────┘
```

---

## 3. Detailed Navigation Flows

### 3.1 Connection Flow

```
Host List → Tap Host → Host Detail (optional) → Connect Button
                 │
                 └──→ Direct connect (double-click on desktop / long-press on mobile)
                          │
                          ▼
                 ┌────────────────┐
                 │  Connecting... │  (shows spinner + hostname)
                 └───────┬────────┘
                         │
              ┌──────────┼──────────┐
              ▼          ▼          ▼
        ┌──────────┐ ┌────────┐ ┌────────────────┐
        │ Success  │ │ Failed │ │ Unknown Host   │
        │ → Terminal│ │ → Error│ │ → Fingerprint  │
        │          │ │  Dialog│ │   Verification │
        └──────────┘ └────────┘ └────────────────┘
                         │              │
                    [Retry] or     [Accept] → Terminal
                    [Edit Host]    [Reject] → Back
```

### 3.2 SFTP Flow

```
From Hosts List:
  Host → ⋮ Menu → "Open SFTP" → SFTP Browser (new tab)

From Active Terminal:
  Bottom bar → [SFTP] button → SFTP Browser (side panel or new tab)

SFTP Browser:
  Navigate directories → Tap file → Action Sheet
  ├─ Download
  ├─ Rename
  ├─ Delete
  ├─ View Permissions
  └─ Edit (text files)

  [Upload] button → File Picker → Upload Progress
```

### 3.3 Key Management Flow

```
Keys List → [+ Generate]  → Generate Key Form → Save → Keys List (updated)
         → [↑ Import]    → File Picker / Paste → Validate → Save
         → Tap Key       → Key Detail View
                              ├─ Copy Public Key
                              ├─ View Fingerprint
                              ├─ See Associated Hosts
                              ├─ Edit Label
                              └─ Delete Key
```

### 3.4 Snippet Flow

```
Snippets List → [+ New] → Snippet Form → Save
             → Tap Snippet → Edit / Copy / Delete

From Terminal:
  [Snippets ▾] button → Snippet Picker Overlay
  → Tap snippet → Inserted into terminal
  → If has variables → Variable input dialog → Then insert
```

### 3.5 Settings Flow

```
Settings → Appearance   → Theme/Font/Size selections
        → Terminal     → Scrollback/Cursor/Bell settings
        → Security     → Master Password / Biometric / Auto-lock
        → Sync         → Account / Server / Export-Import
        → About        → Version / Licenses / Feedback
```

---

## 4. Keyboard Shortcuts (Desktop)

```
┌──────────────────────────────────────────────────────────────────┐
│ GLOBAL                                                          │
├──────────────────────────────────────────────────────────────────┤
│ Cmd/Ctrl + K          Command Palette                           │
│ Cmd/Ctrl + N          New Host                                  │
│ Cmd/Ctrl + Shift + N  Quick Connect                             │
│ Cmd/Ctrl + ,          Settings                                  │
│ Cmd/Ctrl + L          Lock Vault                                │
│ Cmd/Ctrl + 1-5        Switch sidebar sections                   │
├──────────────────────────────────────────────────────────────────┤
│ TERMINAL                                                        │
├──────────────────────────────────────────────────────────────────┤
│ Cmd/Ctrl + T          New terminal tab                          │
│ Cmd/Ctrl + W          Close current tab                         │
│ Cmd/Ctrl + Tab        Next tab                                  │
│ Cmd/Ctrl + Shift+Tab  Previous tab                              │
│ Cmd/Ctrl + D          Split pane horizontal                     │
│ Cmd/Ctrl + Shift + D  Split pane vertical                       │
│ Cmd/Ctrl + Shift + F  Search in terminal                        │
│ Cmd/Ctrl + +/-        Zoom in/out                               │
│ Cmd/Ctrl + 0          Reset zoom                                │
│ Alt + ←/→             Switch between split panes                │
│ Cmd/Ctrl + Shift + C  Copy selection                            │
│ Cmd/Ctrl + Shift + V  Paste to terminal                         │
├──────────────────────────────────────────────────────────────────┤
│ HOST LIST                                                       │
├──────────────────────────────────────────────────────────────────┤
│ Enter                 Connect to selected host                  │
│ Delete / Backspace    Delete selected host (with confirmation)  │
│ E                     Edit selected host                        │
│ ↑/↓                   Navigate host list                        │
│ /                     Focus search                              │
└──────────────────────────────────────────────────────────────────┘
```

---

## 5. Mobile Gestures

```
┌──────────────────────────────────────────────────────────────────┐
│ TERMINAL                                                        │
├──────────────────────────────────────────────────────────────────┤
│ Swipe left/right       Switch terminal tabs                     │
│ Pinch in/out           Decrease/increase font size              │
│ Two-finger scroll      Scroll through terminal history          │
│ Long press             Enter text selection mode                │
│ Double tap             Select word                              │
│ Triple tap             Select line                              │
│ Swipe down (2 finger)  Show/hide extra keyboard row             │
├──────────────────────────────────────────────────────────────────┤
│ HOSTS LIST                                                      │
├──────────────────────────────────────────────────────────────────┤
│ Tap                    Open host detail                         │
│ Long press             Show context menu (edit, delete, etc.)   │
│ Swipe left             Quick actions (connect, delete)          │
│ Swipe right            Favorite/unfavorite                      │
│ Pull down              Refresh / sync                           │
├──────────────────────────────────────────────────────────────────┤
│ SFTP                                                            │
├──────────────────────────────────────────────────────────────────┤
│ Tap file               Show action sheet                       │
│ Long press             Multi-select mode                        │
│ Swipe left             Quick delete                             │
│ Pull down              Refresh directory listing                │
└──────────────────────────────────────────────────────────────────┘
```

---

## 6. State Machine: App Lifecycle

```
┌─────────┐     ┌──────────┐     ┌────────────┐
│ COLD    │────▸│ LOADING  │────▸│ VAULT      │
│ START   │     │ (splash) │     │ CHECK      │
└─────────┘     └──────────┘     └─────┬──────┘
                                       │
                    ┌──────────────────┬┘
                    ▼                  ▼
             ┌────────────┐    ┌──────────────┐
             │ ONBOARDING │    │ VAULT LOCKED │
             │ (first run)│    │ (returning)  │
             └─────┬──────┘    └──────┬───────┘
                   │                  │
                   │           Unlock (pwd/bio)
                   │                  │
                   ▼                  ▼
             ┌─────────────────────────────┐
             │        UNLOCKED            │
             │  (Main app, all features)  │
             │                            │
             │  Hosts ↔ Terminal ↔ Keys   │
             │  Snippets ↔ SFTP ↔ Settings│
             └──────────────┬─────────────┘
                            │
              App background │ (auto-lock timeout)
                            ▼
                     ┌──────────────┐
                     │ VAULT LOCKED │ ──▸ (cycle back to unlock)
                     └──────────────┘
```
