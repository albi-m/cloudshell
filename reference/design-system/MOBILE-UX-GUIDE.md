# CloudShell - Mobile Terminal UX Guide

---

## 1. The Mobile Terminal Challenge

A terminal on a phone screen needs to solve several problems:
- Standard mobile keyboards lack keys essential for terminal use (Ctrl, Alt, Esc, Tab, arrows, pipe, tilde)
- Screen real estate is extremely limited
- Touch input is imprecise compared to keyboard/mouse
- Users need to switch between text input and terminal interaction

---

## 2. Extra Keyboard Row Design

```
┌─────────────────────────────────────────────────────────────┐
│                    EXTRA KEYS BAR                           │
│                                                             │
│  Primary row (always visible when keyboard is up):          │
│  ┌─────┬─────┬─────┬─────┬──────┬──────┬──────┬──────┐    │
│  │ ESC │ TAB │ CTL │ ALT │  ←   │  ↑   │  ↓   │  →   │    │
│  └─────┴─────┴─────┴─────┴──────┴──────┴──────┴──────┘    │
│                                                             │
│  CTL and ALT are toggle keys (tap to activate,              │
│  tap again to deactivate). They highlight when active.      │
│                                                             │
│  Secondary row (swipe up on extra keys bar to reveal):      │
│  ┌─────┬─────┬─────┬─────┬──────┬──────┬──────┬──────┐    │
│  │  ~  │  |  │  `  │  \  │  F1  │  F5  │  F9  │ F12  │    │
│  └─────┴─────┴─────┴─────┴──────┴──────┴──────┴──────┘    │
│                                                             │
│  Long-press on F1/F5/F9/F12 shows picker for F1-F12        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Key Behavior Specifications

| Key | Tap | Long Press | Visual State |
|-----|-----|------------|--------------|
| ESC | Send ESC | - | Flash highlight |
| TAB | Send TAB | Show tab completion (future) | Flash highlight |
| CTL | Toggle Ctrl modifier | Show Ctrl shortcuts cheat sheet | Stays highlighted when active |
| ALT | Toggle Alt modifier | Show Alt shortcuts cheat sheet | Stays highlighted when active |
| ← ↑ ↓ → | Send arrow key | Repeat at 10Hz | Flash highlight |
| ~ | Send ~ | - | Flash highlight |
| \| | Send \| | - | Flash highlight |

---

## 3. Touch Gesture Map

```
┌─────────────────────────────────────────────────────────────┐
│                    GESTURE MAP                              │
│                                                             │
│  SINGLE FINGER:                                             │
│  ┌─────────────────────────────────────────────┐            │
│  │ Tap          → Place cursor / dismiss menu   │            │
│  │ Double tap   → Select word under finger      │            │
│  │ Triple tap   → Select entire line            │            │
│  │ Long press   → Enter selection mode          │            │
│  │              → Shows magnifier loupe         │            │
│  │ Swipe left   → Switch to next tab            │            │
│  │ Swipe right  → Switch to previous tab        │            │
│  │ Swipe down   → (from top) Show connection info│           │
│  └─────────────────────────────────────────────┘            │
│                                                             │
│  TWO FINGERS:                                               │
│  ┌─────────────────────────────────────────────┐            │
│  │ Pinch in     → Decrease font size            │            │
│  │ Pinch out    → Increase font size            │            │
│  │ Two-finger   → Scroll through scrollback     │            │
│  │   scroll       buffer (up/down)              │            │
│  │ Two-finger   → Toggle extra keyboard bar     │            │
│  │   swipe down   visibility                    │            │
│  └─────────────────────────────────────────────┘            │
│                                                             │
│  THREE FINGERS:                                             │
│  ┌─────────────────────────────────────────────┐            │
│  │ Three-finger → Paste from clipboard          │            │
│  │   tap                                        │            │
│  └─────────────────────────────────────────────┘            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Mobile Layout Modes

### Portrait Mode
```
┌──────────────────────────┐
│ ◀ Host Name     ●  ⋮    │  44px - Connection bar
├──────────────────────────┤
│                          │
│                          │
│  Terminal Content        │  Fills remaining space
│  (auto-adjusts rows/    │
│   cols based on font    │
│   size and screen width)│
│                          │
│                          │
│                          │
│                          │
│                          │
├──────────────────────────┤
│ ESC TAB CTL ALT ← ↑ ↓ → │  36px - Extra keys
├──────────────────────────┤
│                          │
│  System Keyboard         │  ~216px (varies by device)
│                          │
│                          │
└──────────────────────────┘

Typical terminal size in portrait:
  iPhone 15: ~38 cols × 18 rows (at 12px font)
  iPad:      ~60 cols × 28 rows (at 14px font)
```

### Landscape Mode
```
┌────────────────────────────────────────────────────────────┐
│ ◀ Host     ●                              ESC TAB CTL ALT │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Terminal Content                                          │
│  (much wider, more useful for terminal work)              │
│                                                            │
│                                                            │
│                                                            │
├──────────────────────────────┬─────────────────────────────┤
│  System Keyboard             │  ← ↑ ↓ →  (overlay on      │
│                              │   right side of keyboard)   │
└──────────────────────────────┴─────────────────────────────┘

Typical terminal size in landscape:
  iPhone 15: ~70 cols × 12 rows (at 12px font)
  iPad:      ~100 cols × 22 rows (at 14px font)
```

---

## 5. Mobile-Specific UI Patterns

### Connection Bar (Top)
```
┌──────────────────────────────────────┐
│ ◀  web-server-1           ●  ⋮     │
│    ubuntu@192.168.1.10               │
└──────────────────────────────────────┘

◀  = Back (disconnect and go to hosts list)
●  = Connection status (green=connected, yellow=reconnecting, red=error)
⋮  = More menu: SFTP, Snippets, Port Forward, Disconnect, Info
```

### Quick Actions Menu (⋮)
```
┌────────────────────────┐
│  📁 Open SFTP          │
│  </> Insert Snippet    │
│  ⇄  Port Forwarding   │
│  ─────────────────     │
│  🔍 Search in Terminal │
│  📋 Copy All Output    │
│  ─────────────────     │
│  ℹ  Connection Info    │
│  ✕  Disconnect         │
└────────────────────────┘
```

### Snippet Quick-Insert (Mobile)
```
┌────────────────────────────────────────┐
│ Insert Snippet                    ✕   │
├────────────────────────────────────────┤
│ 🔍 Search...                          │
├────────────────────────────────────────┤
│                                        │
│  SYSTEM                                │
│  ├── Check disk space  (df -h)        │
│  ├── Check memory  (free -m)          │
│  └── Top processes  (ps aux...)       │
│                                        │
│  DOCKER                                │
│  ├── List containers  (docker ps)     │
│  └── Docker logs  (docker logs...)    │
│                                        │
└────────────────────────────────────────┘
This slides up as a bottom sheet (half screen).
Tap a snippet → inserts directly into terminal.
```

---

## 6. Haptic Feedback Map

| Action | Haptic Type | Intensity |
|--------|------------|-----------|
| Extra key press | Light impact | Subtle |
| Ctrl/Alt toggle on | Medium impact | Noticeable |
| Ctrl/Alt toggle off | Light impact | Subtle |
| Tab switch (swipe) | Light impact | Subtle |
| Connect success | Success notification | Strong |
| Connect failure | Error notification | Strong |
| Disconnect | Warning notification | Medium |
| Long-press selection start | Selection feedback | Medium |
| Font size change (pinch) | Light impact (each step) | Subtle |

---

## 7. Keyboard Shortcuts (Hardware Keyboard - iPad/Android tablet)

When a hardware keyboard is connected, the app should support full desktop shortcuts:

```
Cmd/Ctrl + T         New terminal tab
Cmd/Ctrl + W         Close current tab
Cmd/Ctrl + Tab       Next tab
Cmd/Ctrl + Shift+Tab Previous tab
Cmd/Ctrl + K         Command palette
Cmd/Ctrl + ,         Settings
Cmd/Ctrl + +/-       Zoom in/out
Cmd/Ctrl + Shift+F   Search in terminal
```

---

## 8. Accessibility on Mobile

- Extra keyboard row keys must have accessibility labels
- Terminal content should be accessible via VoiceOver/TalkBack
  (read current line, last N lines of output)
- Color contrast minimum 4.5:1 for all text
- Touch targets minimum 44x44 points (Apple HIG)
- Support Dynamic Type (iOS) / Font scaling (Android)
- Reduce motion: disable all animations when enabled
