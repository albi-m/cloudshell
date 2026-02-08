# CloudShell - Design System

---

## 1. Color System

### 1.1 App Theme Colors (Dark Mode - Primary)

Our app uses a dark-first design. The app chrome (sidebar, headers, forms) uses a custom dark palette inspired by the best terminal themes.

#### Primary Dark Theme: "CloudShell Dark"

```
┌─────────────────────────────────────────────────────────┐
│  BACKGROUNDS                                            │
├─────────────────────────────────────────────────────────┤
│  bg-deepest     #0D1117   Main app background          │
│  bg-deep        #161B22   Sidebar / panels              │
│  bg-surface     #1C2128   Cards / elevated surfaces     │
│  bg-raised      #252C35   Dialogs / modals / dropdowns  │
│  bg-hover       #2D333B   Hover state on items          │
│  bg-active      #3B434D   Active/pressed state          │
├─────────────────────────────────────────────────────────┤
│  BORDERS                                                │
├─────────────────────────────────────────────────────────┤
│  border-subtle  #21262D   Subtle dividers               │
│  border-default #30363D   Default borders               │
│  border-strong  #484F58   Emphasis borders              │
├─────────────────────────────────────────────────────────┤
│  TEXT                                                   │
├─────────────────────────────────────────────────────────┤
│  text-primary   #E6EDF3   Primary text                  │
│  text-secondary #8B949E   Secondary/muted text          │
│  text-tertiary  #6E7681   Placeholder/disabled text     │
│  text-inverse   #0D1117   Text on light backgrounds     │
├─────────────────────────────────────────────────────────┤
│  ACCENT COLORS                                          │
├─────────────────────────────────────────────────────────┤
│  accent-primary   #58A6FF   Primary blue (links, focus) │
│  accent-hover     #79C0FF   Blue hover state            │
│  accent-green     #3FB950   Success / connected         │
│  accent-red       #F85149   Error / destructive         │
│  accent-orange    #D29922   Warning / pending           │
│  accent-purple    #BC8CFF   Labels / badges             │
│  accent-cyan      #39D2C0   Terminal accent             │
│  accent-pink      #F778BA   Special highlights          │
├─────────────────────────────────────────────────────────┤
│  STATUS COLORS                                          │
├─────────────────────────────────────────────────────────┤
│  status-online    #3FB950   Server online / connected   │
│  status-offline   #F85149   Server offline / error      │
│  status-warning   #D29922   Connection warning          │
│  status-idle      #8B949E   Idle / disconnected         │
└─────────────────────────────────────────────────────────┘
```

#### Light Theme: "CloudShell Light"

```
┌─────────────────────────────────────────────────────────┐
│  BACKGROUNDS                                            │
├─────────────────────────────────────────────────────────┤
│  bg-deepest     #FFFFFF   Main app background          │
│  bg-deep        #F6F8FA   Sidebar / panels              │
│  bg-surface     #FFFFFF   Cards / elevated surfaces     │
│  bg-raised      #F3F4F6   Dialogs / modals / dropdowns  │
│  bg-hover       #EAEEF2   Hover state on items          │
│  bg-active      #D0D7DE   Active/pressed state          │
├─────────────────────────────────────────────────────────┤
│  BORDERS                                                │
├─────────────────────────────────────────────────────────┤
│  border-subtle  #F0F0F0   Subtle dividers               │
│  border-default #D0D7DE   Default borders               │
│  border-strong  #8C959F   Emphasis borders              │
├─────────────────────────────────────────────────────────┤
│  TEXT                                                   │
├─────────────────────────────────────────────────────────┤
│  text-primary   #1F2328   Primary text                  │
│  text-secondary #656D76   Secondary/muted text          │
│  text-tertiary  #8C959F   Placeholder/disabled text     │
├─────────────────────────────────────────────────────────┤
│  ACCENT COLORS                                          │
├─────────────────────────────────────────────────────────┤
│  accent-primary   #0969DA   Primary blue (links, focus) │
│  accent-green     #1A7F37   Success / connected         │
│  accent-red       #CF222E   Error / destructive         │
│  accent-orange    #9A6700   Warning / pending           │
│  accent-purple    #8250DF   Labels / badges             │
│  accent-cyan      #1B7C83   Terminal accent             │
└─────────────────────────────────────────────────────────┘
```

### 1.2 Terminal Color Themes (Built-in)

#### Theme 1: CloudShell Default (Custom - our signature theme)
```
Background:   #0D1117
Foreground:   #C9D1D9
Cursor:       #58A6FF
Selection:    #264F78

ANSI Colors:
Black:        #484F58    Bright Black:   #6E7681
Red:          #FF7B72    Bright Red:     #FFA198
Green:        #3FB950    Bright Green:   #56D364
Yellow:       #D29922    Bright Yellow:  #E3B341
Blue:         #58A6FF    Bright Blue:    #79C0FF
Magenta:      #BC8CFF    Bright Magenta: #D2A8FF
Cyan:         #39D2C0    Bright Cyan:    #56D4DD
White:        #B1BAC4    Bright White:   #F0F6FC
```

#### Theme 2: Dracula
```
Background:   #282A36
Foreground:   #F8F8F2
Cursor:       #F8F8F2
Selection:    #44475A

ANSI Colors:
Black:        #21222C    Bright Black:   #6272A4
Red:          #FF5555    Bright Red:     #FF6E6E
Green:        #50FA7B    Bright Green:   #69FF94
Yellow:       #F1FA8C    Bright Yellow:  #FFFFA5
Blue:         #BD93F9    Bright Blue:    #D6ACFF
Magenta:      #FF79C6    Bright Magenta: #FF92DF
Cyan:         #8BE9FD    Bright Cyan:    #A4FFFF
White:        #F8F8F2    Bright White:   #FFFFFF
```

#### Theme 3: Nord
```
Background:   #2E3440
Foreground:   #D8DEE9
Cursor:       #D8DEE9
Selection:    #434C5E

ANSI Colors:
Black:        #3B4252    Bright Black:   #4C566A
Red:          #BF616A    Bright Red:     #BF616A
Green:        #A3BE8C    Bright Green:   #A3BE8C
Yellow:       #EBCB8B    Bright Yellow:  #EBCB8B
Blue:         #81A1C1    Bright Blue:    #81A1C1
Magenta:      #B48EAD    Bright Magenta: #B48EAD
Cyan:         #88C0D0    Bright Cyan:    #8FBCBB
White:        #E5E9F0    Bright White:   #ECEFF4
```

#### Theme 4: Solarized Dark
```
Background:   #002B36
Foreground:   #839496
Cursor:       #839496
Selection:    #073642

ANSI Colors:
Black:        #073642    Bright Black:   #586E75
Red:          #DC322F    Bright Red:     #CB4B16
Green:        #859900    Bright Green:   #586E75
Yellow:       #B58900    Bright Yellow:  #657B83
Blue:         #268BD2    Bright Blue:    #839496
Magenta:      #D33682    Bright Magenta: #6C71C4
Cyan:         #2AA198    Bright Cyan:    #93A1A1
White:        #EEE8D5    Bright White:   #FDF6E3
```

#### Theme 5: One Dark
```
Background:   #282C34
Foreground:   #ABB2BF
Cursor:       #528BFF
Selection:    #3E4451

ANSI Colors:
Black:        #545862    Bright Black:   #636B78
Red:          #E06C75    Bright Red:     #E06C75
Green:        #98C379    Bright Green:   #98C379
Yellow:       #E5C07B    Bright Yellow:  #E5C07B
Blue:         #61AFEF    Bright Blue:    #61AFEF
Magenta:      #C678DD    Bright Magenta: #C678DD
Cyan:         #56B6C2    Bright Cyan:    #56B6C2
White:        #ABB2BF    Bright White:   #C8CCD4
```

#### Theme 6: Catppuccin Mocha
```
Background:   #1E1E2E
Foreground:   #CDD6F4
Cursor:       #F5E0DC
Selection:    #45475A

ANSI Colors:
Black:        #45475A    Bright Black:   #585B70
Red:          #F38BA8    Bright Red:     #F38BA8
Green:        #A6E3A1    Bright Green:   #A6E3A1
Yellow:       #F9E2AF    Bright Yellow:  #F9E2AF
Blue:         #89B4FA    Bright Blue:    #89B4FA
Magenta:      #F5C2E7    Bright Magenta: #F5C2E7
Cyan:         #94E2D5    Bright Cyan:    #94E2D5
White:        #BAC2DE    Bright White:   #A6ADC8
```

#### Theme 7: Tokyo Night
```
Background:   #1A1B26
Foreground:   #C0CAF5
Cursor:       #C0CAF5
Selection:    #33467C

ANSI Colors:
Black:        #15161E    Bright Black:   #414868
Red:          #F7768E    Bright Red:     #F7768E
Green:        #9ECE6A    Bright Green:   #9ECE6A
Yellow:       #E0AF68    Bright Yellow:  #E0AF68
Blue:         #7AA2F7    Bright Blue:    #7AA2F7
Magenta:      #BB9AF7    Bright Magenta: #BB9AF7
Cyan:         #7DCFFF    Bright Cyan:    #7DCFFF
White:        #A9B1D6    Bright White:   #C0CAF5
```

#### Theme 8: Gruvbox Dark
```
Background:   #282828
Foreground:   #EBDBB2
Cursor:       #EBDBB2
Selection:    #3C3836

ANSI Colors:
Black:        #282828    Bright Black:   #928374
Red:          #CC241D    Bright Red:     #FB4934
Green:        #98971A    Bright Green:   #B8BB26
Yellow:       #D79921    Bright Yellow:  #FABD2F
Blue:         #458588    Bright Blue:    #83A598
Magenta:      #B16286    Bright Magenta: #D3869B
Cyan:         #689D6A    Bright Cyan:    #8EC07C
White:        #A89984    Bright White:   #EBDBB2
```

#### Theme 9: Monokai Pro
```
Background:   #2D2A2E
Foreground:   #FCFCFA
Cursor:       #FCFCFA
Selection:    #403E41

ANSI Colors:
Black:        #403E41    Bright Black:   #727072
Red:          #FF6188    Bright Red:     #FF6188
Green:        #A9DC76    Bright Green:   #A9DC76
Yellow:       #FFD866    Bright Yellow:  #FFD866
Blue:         #FC9867    Bright Blue:    #FC9867
Magenta:      #AB9DF2    Bright Magenta: #AB9DF2
Cyan:         #78DCE8    Bright Cyan:    #78DCE8
White:        #FCFCFA    Bright White:   #FCFCFA
```

---

## 2. Typography

### 2.1 App Chrome Font (UI)

**Primary: Inter**
- Reason: Designed for screens, excellent legibility at small sizes, variable font support, open source (OFL)
- Weight range: 300 (Light) to 700 (Bold)
- Used for: Navigation, labels, buttons, forms, settings

**Fallback stack:**
```
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
```

**Type Scale:**
```
┌──────────────┬──────┬────────┬───────────────────────────┐
│ Name         │ Size │ Weight │ Usage                     │
├──────────────┼──────┼────────┼───────────────────────────┤
│ Display      │ 28px │ 700    │ Onboarding headers        │
│ H1           │ 24px │ 700    │ Page titles               │
│ H2           │ 20px │ 600    │ Section headers           │
│ H3           │ 16px │ 600    │ Card titles, sidebar group│
│ Body Large   │ 16px │ 400    │ Primary content           │
│ Body         │ 14px │ 400    │ Default body text         │
│ Body Small   │ 13px │ 400    │ Secondary info            │
│ Caption      │ 12px │ 400    │ Timestamps, metadata      │
│ Overline     │ 11px │ 600    │ Labels, section overlines │
│ Button       │ 14px │ 600    │ Button text               │
│ Tab          │ 13px │ 500    │ Tab labels                │
└──────────────┴──────┴────────┴───────────────────────────┘
```

### 2.2 Terminal Font (Monospace)

**Primary: JetBrains Mono**
- Reason: Excellent readability, 139 code ligatures, designed for code, open source (OFL)
- Default size: 14px (desktop), 12px (mobile)
- Line height: 1.5 (terminal standard)

**Alternative options users can select:**
```
┌────────────────────┬──────────────┬────────────────────────────────┐
│ Font               │ License      │ Notes                          │
├────────────────────┼──────────────┼────────────────────────────────┤
│ JetBrains Mono     │ OFL 1.1      │ Default. Ligatures, excellent  │
│ Fira Code          │ OFL 1.1      │ Popular, ligatures, wider      │
│ Cascadia Code      │ OFL 1.1      │ Microsoft's. Ligatures, cursive│
│ Source Code Pro     │ OFL 1.1      │ Adobe. Clean, no ligatures     │
│ IBM Plex Mono      │ OFL 1.1      │ IBM. Distinctive, professional │
│ Hack               │ MIT          │ Optimized for source code      │
│ Iosevka            │ OFL 1.1      │ Narrow, highly customizable    │
│ Victor Mono        │ OFL 1.1      │ Cursive italics, ligatures     │
│ Roboto Mono        │ Apache 2.0   │ Google. Clean, versatile       │
│ Ubuntu Mono        │ UFL          │ Canonical. Wide, readable      │
│ System Default     │ N/A          │ SF Mono / Consolas / monospace │
└────────────────────┴──────────────┴────────────────────────────────┘
```

---

## 3. Icon System

### Primary Icon Set: **Lucide**

**Why Lucide:**
- Open source (ISC license)
- 1400+ icons with consistent 24x24 grid
- Clean, minimal stroke style (1.5px-2px)
- Actively maintained (weekly updates)
- Available as Flutter package (`lucide_icons`)
- Perfect balance between detail and clarity
- Well-suited for developer tools

**Icon Usage Map:**

```
┌────────────────────────┬──────────────────────────────────┐
│ Context                │ Icons                            │
├────────────────────────┼──────────────────────────────────┤
│ Navigation             │                                  │
│  Hosts                 │ server                           │
│  Terminal              │ terminal-square                  │
│  Keys                  │ key-round                        │
│  Snippets              │ code-2                           │
│  SFTP                  │ folder-tree                      │
│  Settings              │ settings                         │
│  Search                │ search                           │
├────────────────────────┼──────────────────────────────────┤
│ Actions                │                                  │
│  Add new               │ plus                             │
│  Edit                  │ pencil                           │
│  Delete                │ trash-2                          │
│  Copy                  │ copy                             │
│  Paste                 │ clipboard-paste                  │
│  Connect               │ plug                             │
│  Disconnect            │ plug-zap                         │
│  Upload                │ upload                           │
│  Download              │ download                         │
│  Refresh               │ refresh-cw                       │
├────────────────────────┼──────────────────────────────────┤
│ Status                 │                                  │
│  Online/Connected      │ circle (filled green)            │
│  Offline               │ circle (filled red)              │
│  Warning               │ alert-triangle                   │
│  Info                  │ info                             │
│  Success               │ check-circle                     │
│  Error                 │ x-circle                         │
│  Loading               │ loader-2 (animated spin)         │
├────────────────────────┼──────────────────────────────────┤
│ Host Types             │                                  │
│  Linux server          │ server                           │
│  Group/Folder          │ folder                           │
│  Cloud                 │ cloud                            │
│  Docker                │ container                        │
│  Database              │ database                         │
├────────────────────────┼──────────────────────────────────┤
│ Terminal               │                                  │
│  New tab               │ plus                             │
│  Close tab             │ x                                │
│  Split horizontal      │ columns                          │
│  Split vertical        │ rows                             │
│  Full screen           │ maximize-2                       │
│  Exit full screen      │ minimize-2                       │
│  Search in terminal    │ search                           │
├────────────────────────┼──────────────────────────────────┤
│ Security               │                                  │
│  Locked vault          │ lock                             │
│  Unlocked vault        │ unlock                           │
│  Key                   │ key-round                        │
│  Shield                │ shield-check                     │
│  Fingerprint           │ fingerprint                      │
│  Eye (show password)   │ eye                              │
│  Eye off (hide)        │ eye-off                          │
├────────────────────────┼──────────────────────────────────┤
│ Sync                   │                                  │
│  Synced                │ cloud-check (custom)             │
│  Syncing               │ refresh-cw (animated)            │
│  Sync error            │ cloud-off                        │
│  Local only            │ hard-drive                       │
└────────────────────────┴──────────────────────────────────┘
```

### Icon Sizing

```
┌──────────────┬──────┬───────────────────────────────────┐
│ Context      │ Size │ Usage                             │
├──────────────┼──────┼───────────────────────────────────┤
│ Navigation   │ 24px │ Sidebar icons, bottom nav         │
│ Inline       │ 20px │ List items, buttons with icons    │
│ Small        │ 16px │ Status indicators, metadata       │
│ Badge        │ 12px │ Notification dots, tiny status    │
│ Hero         │ 48px │ Empty states, onboarding          │
│ Illustration │ 64px │ Settings sections, about page     │
└──────────────┴──────┴───────────────────────────────────┘
```

---

## 4. Spacing & Layout

### Spacing Scale (8px base)

```
┌───────┬───────┬────────────────────────────┐
│ Token │ Value │ Usage                      │
├───────┼───────┼────────────────────────────┤
│ xs    │ 4px   │ Tight inner padding        │
│ sm    │ 8px   │ Inner padding, small gaps  │
│ md    │ 12px  │ Between related elements   │
│ lg    │ 16px  │ Section padding            │
│ xl    │ 24px  │ Between sections           │
│ 2xl   │ 32px  │ Page padding               │
│ 3xl   │ 48px  │ Major section spacing      │
│ 4xl   │ 64px  │ Page margins on desktop    │
└───────┴───────┴────────────────────────────┘
```

### Border Radius

```
┌──────────┬───────┬──────────────────────────┐
│ Token    │ Value │ Usage                    │
├──────────┼───────┼──────────────────────────┤
│ none     │ 0px   │ Terminal views           │
│ sm       │ 4px   │ Buttons, inputs, badges  │
│ md       │ 8px   │ Cards, dialogs           │
│ lg       │ 12px  │ Modals, panels           │
│ xl       │ 16px  │ Bottom sheets (mobile)   │
│ full     │ 9999  │ Pills, avatars, dots     │
└──────────┴───────┴──────────────────────────┘
```

### Layout Breakpoints

```
┌──────────┬────────────┬──────────────────────────────────┐
│ Name     │ Width      │ Layout                           │
├──────────┼────────────┼──────────────────────────────────┤
│ Mobile   │ < 600px    │ Bottom nav, single column        │
│ Tablet   │ 600-1024px │ Sidebar (collapsible), 2 columns │
│ Desktop  │ > 1024px   │ Sidebar (persistent), multi-pane │
│ Wide     │ > 1440px   │ Sidebar + dual pane terminal     │
└──────────┴────────────┴──────────────────────────────────┘
```

---

## 5. Component Patterns

### 5.1 Buttons

```
Primary:     bg: accent-primary  text: white    radius: sm
Secondary:   bg: bg-raised       text: primary  radius: sm  border: border-default
Ghost:       bg: transparent     text: primary  radius: sm
Danger:      bg: accent-red      text: white    radius: sm
Icon-only:   bg: transparent     text: secondary  radius: sm (hover: bg-hover)

Sizes:
  Small:     height: 28px  padding: 0 12px  font: 12px
  Default:   height: 36px  padding: 0 16px  font: 14px
  Large:     height: 44px  padding: 0 20px  font: 16px
```

### 5.2 Input Fields

```
Default:     bg: bg-deep       border: border-default  radius: sm  height: 36px
Focused:     bg: bg-deep       border: accent-primary  radius: sm
Error:       bg: bg-deep       border: accent-red      radius: sm
Disabled:    bg: bg-surface    border: border-subtle    opacity: 0.5
```

### 5.3 Cards (Host Items, Key Items)

```
Default:     bg: bg-surface    border: border-subtle   radius: md  padding: lg
Hover:       bg: bg-hover      border: border-default  radius: md
Selected:    bg: bg-hover      border: accent-primary  radius: md
```

### 5.4 Sidebar (Desktop/Tablet)

```
Width:       260px (expanded)  60px (collapsed)
Background:  bg-deep
Dividers:    border-subtle
Item height: 40px
Item padding: 0 16px
Active item: bg-active + accent-primary left border (3px)
```

### 5.5 Bottom Navigation (Mobile)

```
Height:      56px (+ safe area inset)
Background:  bg-deep
Items:       5 max (Hosts, Terminal, Keys, Snippets, Settings)
Active:      accent-primary icon + label
Inactive:    text-tertiary icon + label
```

---

## 6. Motion & Animation

```
┌────────────────────┬──────────────────────────────────────┐
│ Type               │ Specification                        │
├────────────────────┼──────────────────────────────────────┤
│ Micro interactions │ 150ms ease-out                       │
│ Page transitions   │ 250ms ease-in-out                    │
│ Modal/Dialog       │ 200ms ease-out (enter)               │
│                    │ 150ms ease-in (exit)                 │
│ Bottom sheet       │ 300ms cubic-bezier(0.4, 0, 0.2, 1)  │
│ Loading spinner    │ 1000ms linear infinite               │
│ Pulse (status)     │ 2000ms ease-in-out infinite          │
│ Tab switch         │ 200ms ease-in-out                    │
└────────────────────┴──────────────────────────────────────┘

Principles:
- No animation > 400ms (feels sluggish)
- Terminal operations: ZERO animation delay (instant)
- Use reduced-motion media query to disable for accessibility
- Haptic feedback on mobile for: tab switch, connect, disconnect
```

---

## 7. Elevation / Shadows (Dark Mode)

```
Level 0: No shadow (flat elements)
Level 1: 0 1px 3px rgba(0,0,0,0.3)     — Cards, list items
Level 2: 0 4px 8px rgba(0,0,0,0.35)    — Dropdowns, tooltips
Level 3: 0 8px 16px rgba(0,0,0,0.4)    — Modals, dialogs
Level 4: 0 16px 32px rgba(0,0,0,0.5)   — Command palette overlay
```

Note: In dark mode, elevation is primarily conveyed through background lightness progression (darker = lower, lighter = higher) rather than shadows.
