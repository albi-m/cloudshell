# Terminal/SSH App Design System Research

## 1. Popular Dark Terminal Color Palettes (Exact Hex Codes)

### Dracula
| Role | Color | Hex |
|------|-------|-----|
| Background | Dark | `#282A36` |
| Current Line | Slightly lighter | `#44475A` |
| Foreground | Light | `#F8F8F2` |
| Comment | Gray | `#6272A4` |
| Selection | Muted | `#44475A` |
| Cyan | Accent | `#8BE9FD` |
| Green | Accent | `#50FA7B` |
| Orange | Accent | `#FFB86C` |
| Pink | Accent | `#FF79C6` |
| Purple | Accent | `#BD93F9` |
| Red | Accent | `#FF5555` |
| Yellow | Accent | `#F1FA8C` |

### Nord
**Polar Night (backgrounds)**
| Role | Hex |
|------|-----|
| Darkest bg | `#2E3440` |
| Elevated bg | `#3B4252` |
| Selection/UI | `#434C5E` |
| Comments/subtle | `#4C566A` |

**Snow Storm (foreground)**
| Role | Hex |
|------|-----|
| Primary text | `#D8DEE9` |
| Brighter text | `#E5E9F0` |
| Brightest text | `#ECEFF4` |

**Frost (cool accents)**
| Role | Hex |
|------|-----|
| Frozen water / keywords | `#8FBCBB` |
| Ice / types | `#88C0D0` |
| Arctic wind / functions | `#81A1C1` |
| Deep arctic / statements | `#5E81AC` |

**Aurora (warm accents)**
| Role | Hex |
|------|-----|
| Red / errors | `#BF616A` |
| Orange / warnings | `#D08770` |
| Yellow / strings | `#EBCB8B` |
| Green / success | `#A3BE8C` |
| Purple / numbers | `#B48EAD` |

### Solarized Dark
**Base tones**
| Role | Hex |
|------|-----|
| base03 (bg) | `#002B36` |
| base02 (bg highlights) | `#073642` |
| base01 (comments) | `#586E75` |
| base00 (secondary content) | `#657B83` |
| base0 (body text) | `#839496` |
| base1 (optional emphasis) | `#93A1A1` |
| base2 (light bg) | `#EEE8D5` |
| base3 (lightest bg) | `#FDF6E3` |

**Accent colors (shared dark/light)**
| Color | Hex |
|-------|-----|
| Yellow | `#B58900` |
| Orange | `#CB4B16` |
| Red | `#DC322F` |
| Magenta | `#D33682` |
| Violet | `#6C71C4` |
| Blue | `#268BD2` |
| Cyan | `#2AA198` |
| Green | `#859900` |

### One Dark (Atom)
| Role | Hex |
|------|-----|
| Background | `#282C34` |
| Foreground | `#ABB2BF` |
| Gutter fg | `#636D83` |
| Selection | `#3E4451` |
| Cursor | `#528BFF` |
| Red | `#E06C75` |
| Dark Red | `#BE5046` |
| Green | `#98C379` |
| Yellow | `#E5C07B` |
| Dark Yellow | `#D19A66` |
| Blue | `#61AFEF` |
| Magenta | `#C678DD` |
| Cyan | `#56B6C2` |
| White | `#ABB2BF` |

### Monokai (Classic / Sublime Text)
| Role | Hex |
|------|-----|
| Background | `#272822` |
| Foreground | `#F8F8F2` |
| Comment | `#75715E` |
| Selection | `#49483E` |
| Line highlight | `#3E3D32` |
| Red | `#F92672` |
| Orange | `#FD971F` |
| Yellow | `#E6DB74` |
| Green | `#A6E22E` |
| Blue | `#66D9EF` |
| Purple | `#AE81FF` |

### Catppuccin (Mocha - darkest variant)
| Role | Hex |
|------|-----|
| Base (bg) | `#1E1E2E` |
| Mantle (deeper bg) | `#181825` |
| Crust (deepest) | `#11111B` |
| Surface 0 | `#313244` |
| Surface 1 | `#45475A` |
| Surface 2 | `#585B70` |
| Overlay 0 | `#6C7086` |
| Overlay 1 | `#7F849C` |
| Overlay 2 | `#9399B2` |
| Subtext 0 | `#A6ADC8` |
| Subtext 1 | `#BAC2DE` |
| Text | `#CDD6F4` |
| Rosewater | `#F5E0DC` |
| Flamingo | `#F2CDCD` |
| Pink | `#F5C2E7` |
| Mauve | `#CBA6F7` |
| Red | `#F38BA8` |
| Maroon | `#EBA0AC` |
| Peach | `#FAB387` |
| Yellow | `#F9E2AF` |
| Green | `#A6E3A1` |
| Teal | `#94E2D5` |
| Sky | `#89DCEB` |
| Sapphire | `#74C7EC` |
| Blue | `#89B4FA` |
| Lavender | `#B4BEFE` |

**Other Catppuccin variants:**
- **Latte** (light): Base `#EFF1F5`, Text `#4C4F69`
- **Frappe** (medium dark): Base `#303446`, Text `#C6D0F5`
- **Macchiato** (darker): Base `#24273A`, Text `#CAD3F5`

### Tokyo Night
| Role | Hex |
|------|-----|
| Background | `#1A1B26` |
| Terminal bg | `#1A1B26` |
| Foreground | `#A9B1D6` |
| Selection | `#283457` |
| Comment | `#565F89` |
| Black | `#414868` |
| Red | `#F7768E` |
| Green | `#9ECE6A` |
| Yellow | `#E0AF68` |
| Blue | `#7AA2F7` |
| Magenta | `#BB9AF7` |
| Cyan | `#7DCFFF` |
| White | `#C0CAF5` |
| Bright Blue | `#2AC3DE` |
| Git Added | `#449DAB` |
| Git Modified | `#6183BB` |
| Git Deleted | `#914C54` |

**Tokyo Night Storm variant:**
- Background: `#24283B`

### Gruvbox Dark
| Role | Hex |
|------|-----|
| bg (hard) | `#1D2021` |
| bg (medium) | `#282828` |
| bg (soft) | `#32302F` |
| bg1 | `#3C3836` |
| bg2 | `#504945` |
| bg3 | `#665C54` |
| bg4 | `#7C6F64` |
| fg | `#EBDBB2` |
| fg1 | `#EBDBB2` |
| fg2 | `#D5C4A1` |
| fg3 | `#BDAE93` |
| fg4 | `#A89984` |
| Red | `#FB4934` (bright) / `#CC241D` (dark) |
| Green | `#B8BB26` (bright) / `#98971A` (dark) |
| Yellow | `#FABD2F` (bright) / `#D79921` (dark) |
| Blue | `#83A598` (bright) / `#458588` (dark) |
| Purple | `#D3869B` (bright) / `#B16286` (dark) |
| Aqua | `#8EC07C` (bright) / `#689D6A` (dark) |
| Orange | `#FE8019` (bright) / `#D65D0E` (dark) |
| Gray | `#928374` |

---

## 2. Monospace Fonts for Terminal Display

### JetBrains Mono
- **Creator:** JetBrains
- **License:** SIL Open Font License 1.1 (free, commercial OK)
- **Key features:** Increased height for better readability, 138 code ligatures, distinctive `l/1/I` differentiation, designed specifically for code
- **Weights:** Thin, ExtraLight, Light, Regular, Medium, SemiBold, Bold, ExtraBold (with italics)
- **Ligatures:** Yes (optional, can be disabled)
- **Why it's popular:** Purpose-built for developers, excellent at small sizes, very clear glyph differentiation
- **Best for:** Primary recommendation for terminal text

### Fira Code
- **Creator:** Nikita Prokopov (based on Fira Mono by Mozilla)
- **License:** SIL Open Font License 1.1
- **Key features:** Extensive ligature set (most popular ligature font), arrows, equality operators, many programming symbol combinations
- **Weights:** Light, Regular, Medium, SemiBold, Bold, Retina
- **Ligatures:** Yes (extensive - the main selling point)
- **Best for:** Users who love ligatures

### Cascadia Code
- **Creator:** Microsoft (for Windows Terminal)
- **License:** SIL Open Font License 1.1
- **Key features:** Designed for Windows Terminal and VS Code, has Cascadia Mono (no ligatures) variant, embedded Powerline glyphs available (Cascadia Code PL / Cascadia Mono PL)
- **Weights:** ExtraLight, Light, SemiLight, Regular, SemiBold, Bold
- **Ligatures:** Yes (Cascadia Code) / No (Cascadia Mono)
- **Best for:** Windows-centric users, Powerline support out of the box

### Source Code Pro
- **Creator:** Adobe
- **License:** SIL Open Font License 1.1
- **Key features:** Part of the Source font superfamily, very clean and neutral design, excellent hinting, good at small sizes
- **Weights:** ExtraLight, Light, Regular, Medium, SemiBold, Bold, Black (with italics)
- **Ligatures:** No
- **Best for:** Users who prefer a clean, non-ligature font

### IBM Plex Mono
- **Creator:** IBM (Mike Abbink, Bold Monday)
- **License:** SIL Open Font License 1.1
- **Key features:** Part of IBM Plex superfamily, geometric yet humanist design, excellent character set, good internationalization
- **Weights:** Thin, ExtraLight, Light, Regular, Medium, SemiBold, Bold (with italics)
- **Ligatures:** No
- **Best for:** Professional/enterprise feel, pairs well with IBM Plex Sans for UI

### Hack
- **Creator:** Chris Simpkins (based on Bitstream Vera/DejaVu)
- **License:** MIT License
- **Key features:** Extremely readable at small sizes, powerline-compatible, excellent `0/O` and `1/l/I` distinction, bitmap-like clarity
- **Weights:** Regular, Bold, Italic, Bold Italic
- **Ligatures:** No
- **Best for:** Maximum readability, SSH over slow connections

### Iosevka
- **Creator:** Belleve Invis
- **License:** SIL Open Font License 1.1
- **Key features:** Extremely customizable (build your own variant), narrow characters (fits more on screen), many stylistic sets, huge Unicode coverage
- **Weights:** Thin through Heavy (9 weights with italics)
- **Ligatures:** Yes (optional, extensive)
- **Variants:** Default (sans), Slab, Curly, SS01-SS20 (style presets matching other fonts)
- **Best for:** Users who want narrow/compact terminal, customization enthusiasts

### Berkeley Mono (Honorable mention)
- **Creator:** Neil Panchal
- **License:** Commercial ($75 personal)
- **Key features:** Premium feel, beautiful design, excellent legibility
- **Best for:** Premium/commercial app default font (if licensing allows)

### Monaspace (Honorable mention)
- **Creator:** GitHub
- **License:** SIL Open Font License 1.1
- **Key features:** 5 variable fonts (Neon, Argon, Xenon, Radon, Krypton), texture healing feature, code ligatures
- **Best for:** Modern apps wanting cutting-edge font tech

### Recommendation for your app:
**Ship with:** JetBrains Mono as default (best all-around), offer Fira Code and Cascadia Code as built-in alternatives. Allow users to select system fonts.

---

## 3. UI Fonts for App Chrome (Non-Terminal UI)

### Inter
- **Creator:** Rasmus Andersson
- **License:** SIL Open Font License 1.1
- **Key features:** Purpose-built for UI/screens, variable font, excellent at small sizes (11-14px), tabular figures, contextual alternates, 2,500+ glyphs
- **Weights:** Variable (100-900)
- **Why:** The gold standard for developer tool UIs. Used by GitHub, Figma, Linear, Vercel. Pairs extremely well with monospace fonts.
- **Best for:** Primary UI font recommendation

### SF Pro / SF Pro Display / SF Pro Text
- **Creator:** Apple
- **License:** Free for Apple platforms only (cannot use on Android/Windows)
- **Key features:** Native system font on macOS/iOS, optical sizes, variable font, built-in to Apple platforms (use via `-apple-system` or `system-ui` CSS)
- **Best for:** macOS/iOS native apps (system font stack)

### Segoe UI
- **Creator:** Microsoft
- **License:** Ships with Windows (system font)
- **Key features:** Native Windows UI font, humanist design
- **Best for:** Windows platform native feel

### Geist / Geist Sans
- **Creator:** Vercel
- **License:** SIL Open Font License 1.1
- **Key features:** Modern, clean design, pairs with Geist Mono, designed for developer tooling
- **Weights:** Variable (100-900)
- **Best for:** Modern developer tools, pairs with Geist Mono for terminal

### Roboto / Roboto Flex
- **Creator:** Google (Christian Robertson)
- **License:** Apache 2.0
- **Key features:** Native Android system font, very wide language support, variable font version available
- **Best for:** Android platform native feel, cross-platform apps

### Nunito Sans
- **Creator:** Vernon Adams (Google Fonts)
- **License:** SIL Open Font License 1.1
- **Key features:** Friendly, rounded terminals, good readability, light to black weights
- **Best for:** Softer, more approachable developer tool UI

### Recommended system font stack for cross-platform:
```css
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
```

### For a mobile SSH app specifically:
- **iOS:** Use SF Pro (system font) for app chrome, it's native and free on Apple platforms
- **Android:** Use Roboto or Inter
- **Cross-platform (React Native / Flutter):** Ship Inter as the primary UI font

---

## 4. Icon Sets for SSH/Terminal Apps

### Lucide Icons
- **Origin:** Fork of Feather Icons (community maintained)
- **License:** ISC License (very permissive)
- **Count:** 1,400+ icons
- **Style:** 24x24, 2px stroke, rounded caps/joins
- **Relevant icons:** `terminal`, `server`, `key`, `lock`, `unlock`, `wifi`, `wifi-off`, `folder`, `file`, `settings`, `plus`, `x`, `copy`, `clipboard`, `download`, `upload`, `search`, `monitor`, `shield`, `globe`, `network`, `hard-drive`, `database`, `cloud`
- **React Native:** `lucide-react-native` package available
- **Pros:** Most actively maintained, great community, consistent design, tree-shakable
- **Cons:** Slightly thinner than some alternatives
- **VERDICT: BEST CHOICE for this project**

### Phosphor Icons
- **Creator:** Tobias Fried & Helena Zhang
- **License:** MIT
- **Count:** 1,200+ icons in 6 weights
- **Style:** Available in Thin, Light, Regular, Bold, Fill, Duotone
- **Relevant icons:** `Terminal`, `Key`, `Lock`, `WifiHigh`, `Gear`, `Plus`, `Copy`, `Cloud`, `Lightning`, `ArrowRight`, `CaretDown`, `Fingerprint`
- **React Native:** `phosphor-react-native` available
- **Pros:** 6 weight variants (very flexible), duotone option adds visual interest, excellent design quality
- **Cons:** Slightly larger bundle if not tree-shaking
- **VERDICT: Strong second choice, excellent if you want weight variants**

### Heroicons
- **Creator:** Tailwind Labs (Steve Schoger)
- **License:** MIT
- **Count:** 300+ icons
- **Style:** Available in Outline (24x24, 1.5px stroke), Solid (24x24), Mini (20x20), Micro (16x16)
- **Relevant icons:** `CommandLine`, `Server`, `Key`, `LockClosed`, `Wifi`, `Cog6Tooth`, `Plus`, `ClipboardDocument`
- **React Native:** `react-native-heroicons` available
- **Pros:** Beautiful design, 4 size variants, integrates well with Tailwind
- **Cons:** Smaller icon count, may lack some SSH-specific icons
- **VERDICT: Good if already using Tailwind/NativeWind**

### Material Symbols
- **Creator:** Google
- **License:** Apache 2.0
- **Count:** 3,000+ icons
- **Style:** Variable font-based, adjustable weight/fill/grade/optical-size
- **Pros:** Largest icon set, variable font customization, Google's design system
- **Cons:** Can feel too "Google Material", larger download, variable font complexity on mobile
- **VERDICT: Too heavy/complex for this use case**

### Feather Icons
- **Creator:** Cole Bemis
- **License:** MIT
- **Count:** 280+ icons
- **Style:** 24x24, 2px stroke
- **Pros:** Beautiful, consistent design
- **Cons:** No longer actively maintained (Lucide is the active fork), limited count
- **VERDICT: Use Lucide instead (it's the maintained successor)**

### Tabler Icons (Honorable mention)
- **License:** MIT
- **Count:** 4,900+ icons
- **Style:** 24x24, configurable stroke width
- **Pros:** Massive collection, consistent, active development
- **VERDICT: Good backup if Lucide is missing specific icons**

### RECOMMENDATION:
**Primary:** Lucide Icons - best balance of quality, quantity, maintenance, and developer experience.
**Supplement with:** Phosphor for any missing icons or if you want duotone/weight variants.

### SSH-Specific Icon Needs Checklist:
| Concept | Lucide Icon Name | Available? |
|---------|-----------------|------------|
| Terminal/Shell | `terminal`, `terminal-square` | Yes |
| SSH Connection | `key`, `lock`, `shield` | Yes |
| Server | `server`, `hard-drive` | Yes |
| Connect/Disconnect | `plug`, `unplug` | Yes |
| Network | `network`, `globe`, `wifi` | Yes |
| SFTP/Files | `folder`, `file`, `file-text` | Yes |
| Copy/Paste | `copy`, `clipboard` | Yes |
| Settings | `settings`, `sliders` | Yes |
| Search | `search` | Yes |
| Authentication | `fingerprint`, `key-round` | Yes |
| Port Forwarding | `arrow-right-left`, `shuffle` | Yes |
| Close/Disconnect | `x`, `log-out` | Yes |
| Add Connection | `plus`, `plus-circle` | Yes |
| Snippets | `code`, `braces` | Yes |
| Groups/Folders | `folder`, `folder-tree` | Yes |

---

## 5. ANSI 16-Color Palette Mappings for Popular Themes

The ANSI standard defines 16 named colors (8 normal + 8 bright). Here are the mappings for popular themes:

### Dracula ANSI Colors
| ANSI Name | Normal | Bright |
|-----------|--------|--------|
| Black | `#21222C` | `#6272A4` |
| Red | `#FF5555` | `#FF6E6E` |
| Green | `#50FA7B` | `#69FF94` |
| Yellow | `#F1FA8C` | `#FFFFA5` |
| Blue | `#BD93F9` | `#D6ACFF` |
| Magenta | `#FF79C6` | `#FF92DF` |
| Cyan | `#8BE9FD` | `#A4FFFF` |
| White | `#F8F8F2` | `#FFFFFF` |

### Nord ANSI Colors
| ANSI Name | Normal | Bright |
|-----------|--------|--------|
| Black | `#3B4252` | `#4C566A` |
| Red | `#BF616A` | `#BF616A` |
| Green | `#A3BE8C` | `#A3BE8C` |
| Yellow | `#EBCB8B` | `#EBCB8B` |
| Blue | `#81A1C1` | `#81A1C1` |
| Magenta | `#B48EAD` | `#B48EAD` |
| Cyan | `#88C0D0` | `#8FBCBB` |
| White | `#E5E9F0` | `#ECEFF4` |

### Solarized Dark ANSI Colors
| ANSI Name | Normal | Bright |
|-----------|--------|--------|
| Black | `#073642` | `#002B36` |
| Red | `#DC322F` | `#CB4B16` |
| Green | `#859900` | `#586E75` |
| Yellow | `#B58900` | `#657B83` |
| Blue | `#268BD2` | `#839496` |
| Magenta | `#D33682` | `#6C71C4` |
| Cyan | `#2AA198` | `#93A1A1` |
| White | `#EEE8D5` | `#FDF6E3` |

### One Dark ANSI Colors
| ANSI Name | Normal | Bright |
|-----------|--------|--------|
| Black | `#282C34` | `#5C6370` |
| Red | `#E06C75` | `#E06C75` |
| Green | `#98C379` | `#98C379` |
| Yellow | `#E5C07B` | `#D19A66` |
| Blue | `#61AFEF` | `#61AFEF` |
| Magenta | `#C678DD` | `#C678DD` |
| Cyan | `#56B6C2` | `#56B6C2` |
| White | `#ABB2BF` | `#FFFFFF` |

### Monokai ANSI Colors
| ANSI Name | Normal | Bright |
|-----------|--------|--------|
| Black | `#272822` | `#75715E` |
| Red | `#F92672` | `#F92672` |
| Green | `#A6E22E` | `#A6E22E` |
| Yellow | `#F4BF75` | `#F4BF75` |
| Blue | `#66D9EF` | `#66D9EF` |
| Magenta | `#AE81FF` | `#AE81FF` |
| Cyan | `#A1EFE4` | `#A1EFE4` |
| White | `#F8F8F2` | `#F9F8F5` |

### Catppuccin Mocha ANSI Colors
| ANSI Name | Normal | Bright |
|-----------|--------|--------|
| Black | `#45475A` | `#585B70` |
| Red | `#F38BA8` | `#F38BA8` |
| Green | `#A6E3A1` | `#A6E3A1` |
| Yellow | `#F9E2AF` | `#F9E2AF` |
| Blue | `#89B4FA` | `#89B4FA` |
| Magenta | `#F5C2E7` | `#F5C2E7` |
| Cyan | `#94E2D5` | `#94E2D5` |
| White | `#BAC2DE` | `#A6ADC8` |

### Tokyo Night ANSI Colors
| ANSI Name | Normal | Bright |
|-----------|--------|--------|
| Black | `#414868` | `#414868` |
| Red | `#F7768E` | `#F7768E` |
| Green | `#9ECE6A` | `#9ECE6A` |
| Yellow | `#E0AF68` | `#E0AF68` |
| Blue | `#7AA2F7` | `#7AA2F7` |
| Magenta | `#BB9AF7` | `#BB9AF7` |
| Cyan | `#7DCFFF` | `#7DCFFF` |
| White | `#C0CAF5` | `#C0CAF5` |

### Gruvbox Dark ANSI Colors
| ANSI Name | Normal | Bright |
|-----------|--------|--------|
| Black | `#282828` | `#928374` |
| Red | `#CC241D` | `#FB4934` |
| Green | `#98971A` | `#B8BB26` |
| Yellow | `#D79921` | `#FABD2F` |
| Blue | `#458588` | `#83A598` |
| Magenta | `#B16286` | `#D3869B` |
| Cyan | `#689D6A` | `#8EC07C` |
| White | `#A89984` | `#EBDBB2` |

---

## 6. Mobile SSH App UX Best Practices

### 6.1 Extended Keyboard / Extra Key Rows

This is the SINGLE MOST IMPORTANT UX feature for a mobile SSH app. The default iOS/Android keyboard lacks critical terminal keys.

**Essential extra keys (must have):**
```
Row 1: ESC | TAB | CTRL | ALT | ~ | / | - | UP | Keyboard-down
Row 2: (context-dependent or customizable)
```

**Recommended extra key layout (based on Termius, Blink Shell, Prompt):**
```
Primary row: ESC  TAB  CTRL  ALT  |  /  -  ~  Arrow-Keys
```

**Arrow key patterns:**
- **Option A (Termius style):** Dedicated arrow cluster in a 4-key diamond or 4-key row
- **Option B (Blink Shell style):** Swipe gestures on terminal area (swipe left/right/up/down = arrow keys)
- **Option C (Hybrid):** Arrow buttons + swipe support
- **RECOMMENDATION:** Option C (hybrid) - buttons for discoverability, gestures for power users

**Key behaviors:**
- **CTRL** should work as a toggle/sticky key (tap once to activate for next keypress, double-tap to lock)
- **ALT/Meta** same toggle behavior
- **ESC** direct send on tap
- **TAB** direct send on tap (critical for autocomplete)

**Best practice examples from top apps:**
- **Termius:** Configurable extra key row, dedicated arrow keys, swipe for page up/down
- **Blink Shell:** Extra key row + trackpad mode (two-finger pan = mouse movement)
- **Prompt (Panic):** Extra key row with haptic feedback, customizable keys
- **a]Shell:** Full extra row with Fn keys accessible via long-press

### 6.2 Touch Gestures

| Gesture | Action | Priority |
|---------|--------|----------|
| Tap | Position cursor / Click | Essential |
| Long press | Context menu (copy/paste/select) | Essential |
| Two-finger tap | Right-click / Secondary action | High |
| Pinch to zoom | Increase/decrease font size | High |
| Swipe left/right on terminal | Arrow keys left/right | High |
| Swipe up/down on terminal | Arrow keys up/down OR scroll history | High |
| Two-finger swipe up/down | Page Up / Page Down | Medium |
| Three-finger tap | Paste | Medium |
| Swipe from left edge | Switch between sessions/tabs | Medium |
| Two-finger pan | Trackpad/mouse mode | Medium |
| Double-tap | Select word | Medium |
| Triple-tap | Select line | Low |

### 6.3 Terminal Display Optimization

**Font sizing:**
- Default: 12-14pt on phone, 14-16pt on tablet
- Allow pinch-to-zoom resize (range: 8pt to 24pt)
- Remember per-session font size preference

**Screen utilization:**
- Full-screen mode (hide status bar and navigation bar)
- Keyboard should push terminal content up (not cover it)
- When keyboard is shown, only visible terminal rows should be active (don't render offscreen)

**Orientation:**
- Support both portrait and landscape
- Landscape is much more usable for terminal (more columns)
- Consider auto-rotate or orientation lock toggle

**Columns/rows:**
- Portrait phone: typically 40-50 columns, 20-30 rows
- Landscape phone: typically 80-100 columns, 15-20 rows
- Inform SSH server of terminal resize (SIGWINCH)
- Target 80 columns minimum in landscape

### 6.4 Session Management

**Tab/session UX patterns:**
- Tab bar at bottom (iOS) or top (Android)
- Swipe between sessions
- Visual indicator of session status (connected = green dot, disconnected = red, connecting = yellow)
- Quick-reconnect on tap for disconnected sessions
- Session persistence through app backgrounding

**Connection management:**
- Recent connections list with quick-connect
- Favorites/bookmarks with visual grouping
- Connection status indicators
- Auto-reconnect on network change

### 6.5 Clipboard & Text Selection

- Long-press to start selection (with magnifying glass on iOS)
- Selection handles that work with terminal grid
- Copy should copy plain text (strip ANSI codes)
- Paste confirmation dialog (security: prevent pasting malicious commands)
- Clipboard history (last 5-10 items)
- Share sheet integration (share terminal output)

### 6.6 Authentication UX

- Biometric unlock for key storage (Face ID / Touch ID / Fingerprint)
- SSH key management with clear UI
- Password manager integration (iOS/Android autofill API)
- Import keys from files, clipboard, or QR code
- Key generation wizard with clear explanations

### 6.7 Haptic Feedback

- Light haptic on key press in extra keyboard row
- Medium haptic on CTRL/ALT toggle
- Success haptic on connection established
- Error haptic on connection failed/dropped

### 6.8 Snippet / Command Shortcuts

- Quick-access command snippets (customizable)
- Floating action button or toolbar for common commands
- Swipe-up panel for command palette
- Parameterized snippets (e.g., `ssh {user}@{host}`)

### 6.9 Split View / Multi-Session (Tablet)

- Side-by-side terminal sessions on iPad/Android tablet
- Drag-and-drop between sessions
- iPadOS Stage Manager support
- Slide Over support for quick session access

### 6.10 Accessibility

- VoiceOver / TalkBack support (announce terminal output changes)
- Dynamic Type support for UI elements
- Minimum touch target size: 44x44pt (Apple HIG) / 48x48dp (Material)
- High contrast mode
- Reduce motion option

---

## 7. Design System Recommendations for This Project

### Recommended Default Theme Stack:
1. **Default theme:** Catppuccin Mocha (modern, soft, popular) or Dracula (high recognition)
2. **Ship with:** Dracula, Nord, Solarized Dark, One Dark, Catppuccin (all variants), Tokyo Night, Gruvbox Dark
3. **Allow custom themes** via JSON import (iTerm2/Windows Terminal format)

### Recommended Typography Stack:
- **Terminal font:** JetBrains Mono (default), with Fira Code and Cascadia Code as alternatives
- **UI font:** Inter (bundle it), fall back to system fonts
- **Font stack:** `'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`

### Recommended Icon Set:
- **Primary:** Lucide React Native (`lucide-react-native`)
- **Size:** 20px for toolbar icons, 24px for navigation, 16px for inline

### Recommended Color System for App Chrome:
Use a semantic color system that maps to the active terminal theme:

```
// Semantic colors (adapt to theme)
colors: {
  // Backgrounds
  bg.primary:     // Deepest background (from terminal theme)
  bg.secondary:   // Slightly lighter (Surface 0 / elevated)
  bg.tertiary:    // Card/panel background
  bg.hover:       // Hover state

  // Text
  text.primary:   // Main text (from theme fg)
  text.secondary: // Subdued text (from theme comment)
  text.tertiary:  // Very subtle text

  // Accents
  accent.primary: // Main accent (theme blue)
  accent.success: // Green
  accent.warning: // Yellow/Orange
  accent.error:   // Red
  accent.info:    // Cyan

  // Borders
  border.default: // Subtle border
  border.strong:  // Emphasized border
}
```

### Key Design Principles:
1. **Terminal content is king** - UI chrome should be minimal and get out of the way
2. **Dark first** - Default to dark theme, offer light as option
3. **Consistent with terminal theme** - App chrome colors should derive from the active terminal theme
4. **Mobile-native interactions** - Gestures, haptics, and touch targets should feel native to each platform
5. **Fast connection** - Minimize taps to connect (1-2 taps for frequent connections)
6. **Offline-ready UI** - Show connection state clearly, allow browsing saved connections offline
