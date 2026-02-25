# CloudShell "Aether" Visual Redesign

## Context

The current CloudShell UI uses GitHub's dark palette verbatim (#0D1117 grays, #58A6FF blue accent, Inter font) — making it visually indistinguishable from GitHub Desktop or any generic dev tool. The user wants a full ground-up visual rethink based on the HTML mockup at `design/cloudshell-redesign.html`.

**Goal**: Transform the visual identity from "GitHub clone" to "Aether" — deep blue-black atmosphere, signature teal accent (#00D4AA), Plus Jakarta Sans typography, glow-based depth, and gradient brand identity. No layout/navigation/logic changes — purely visual.

**Key insight**: Because ~374 color references across 32 files all use `AppColors.*` constants, changing the 5 core design system files will auto-cascade to ~90% of the app. Only ~5 UI files need manual structural changes for new visual effects (gradients, glows, blur).

---

## Phase 1: Core Design Tokens (5 files — cascades everywhere)

### Step 1: `lib/core/theme/app_colors.dart`
**The single most impactful change.** Replace all dark theme values:

| Property | Old (GitHub) | New (Aether) |
|----------|-------------|-------------|
| bgDeepest | #0D1117 | #05070C |
| bgDeep | #161B22 | #0A0E17 |
| bgSurface | #1C2128 | #151B29 |
| bgRaised | #252C35 | #1B2233 |
| bgHover | #2D333B | #212A3D |
| bgActive | #3B434D | #283348 |
| borderSubtle | #21262D | #162036 |
| borderDefault | #30363D | #1E2B45 |
| borderStrong | #484F58 | #2D3E5C |
| textPrimary | #E6EDF3 | #E2E8F4 |
| textSecondary | #8B949E | #7E8BA4 |
| textTertiary | #6E7681 | #4F5B73 |
| textInverse | #0D1117 | #05070C |
| **accentPrimary** | **#58A6FF** | **#00D4AA** (teal!) |
| accentHover | #79C0FF | #00F0C0 |
| accentGreen | #3FB950 | #34D058 |
| accentRed | #F85149 | #F85149 (same) |
| accentOrange | #D29922 | #F0B232 |
| accentPurple | #BC8CFF | #B388FF |
| accentCyan | #39D2C0 | #39D2C0 (same) |
| accentPink | #F778BA | #F778BA (same) |
| statusOnline | #3FB950 | #34D058 |
| statusWarning | #D29922 | #F0B232 |
| statusIdle | #8B949E | #7E8BA4 |

**Add new fields** to `AppColors`:
```dart
static const Color accentBright = Color(0xFF00F0C0);  // bright teal
static const Color accentMuted = Color(0xFF00A888);    // muted teal
static const Color accentBlue = Color(0xFF5B9CF6);     // secondary blue
static const Color bgBase = Color(0xFF0F1420);         // intermediate layer

// Glow colors for BoxShadow effects
static const Color accentGlow = Color(0x1F00D4AA);       // 12% teal
static const Color accentGlowStrong = Color(0x4000D4AA); // 25% teal
static const Color blueGlow = Color(0x1F5B9CF6);
static const Color successGlow = Color(0x2634D058);
static const Color errorGlow = Color(0x26F85149);
static const Color warningGlow = Color(0x26F0B232);

// Brand gradient
static const LinearGradient gradientBrand = LinearGradient(
  begin: Alignment.topLeft, end: Alignment.bottomRight,
  colors: [Color(0xFF00D4AA), Color(0xFF5B9CF6)],
);
```

**Update `AppColorsLight`**: Change primary to teal-based light variant:
- accentPrimary: #0969DA → #009977 (teal for light mode, 4.6:1 contrast on white)
- Add `accentBlue: Color(0xFF0969DA)` (old primary becomes secondary)
- Add matching glow colors

### Step 2: `lib/core/theme/app_typography.dart`
Swap font family from Inter to Plus Jakarta Sans (2 changes):
- Line 22: `GoogleFonts.inter(...)` → `GoogleFonts.plusJakartaSans(...)`
- Line 121: `GoogleFonts.inter(...)` → `GoogleFonts.plusJakartaSans(...)`
- Update file doc comment to reference Plus Jakarta Sans

### Step 3: `lib/core/constants/app_constants.dart`
Add border radius constants (new section after UI Constants):
```dart
// --- Border Radii ---
static const double radiusSmall = 4.0;    // buttons, inputs, small elements
static const double radiusMedium = 6.0;   // standard components
static const double radiusLarge = 10.0;   // cards, popups
static const double radiusXLarge = 14.0;  // modals, dialogs
```

Update sidebar width: `sidebarWidth: 260.0` → `256.0` (matches mockup)

### Step 4: `lib/core/theme/app_theme.dart`
Update both dark and light ThemeData:

1. **fontFamily**: `'Inter'` → `'PlusJakartaSans'` (line 31 dark, line 251 light)
2. **ColorScheme secondary**: `accentCyan` → `AppColors.accentBlue` (new secondary accent)
3. **NavigationRail indicatorColor**: `bgActive` → `AppColors.accentGlow` (glow bg for active nav)
4. **Border radii updates** (both dark and light):
   - Cards: `circular(8)` → `circular(10)` (3 occurrences)
   - ElevatedButton: `circular(8)` → `circular(6)`
   - OutlinedButton: `circular(8)` → `circular(6)`
   - Input borders: `circular(8)` → `circular(6)` (4 occurrences × 2 themes = 8)
   - Dialogs: `circular(12)` → `circular(14)`
   - SnackBars: `circular(8)` → `circular(10)`
   - PopupMenus: `circular(8)` → `circular(10)`
   - Tooltips: `circular(6)` → stays `6`
   - Checkbox: `circular(4)` → stays `4`
   - BottomSheets: `circular(16)` → stays `16`

### Step 5: `lib/core/theme/terminal_themes.dart`
Update CloudShell Default theme only (lines 92-114):
- `background`: `0xFF0D1117` → `0xFF05070C` (match bgDeepest)
- `cursor`: `0xFF58A6FF` → `0xFF00D4AA` (match accentPrimary teal)
- `selection`: `0xFF264F78` → `0xFF1E2B45` (match borderDefault)
- `blue`: `0xFF58A6FF` → `0xFF5B9CF6` (match accentBlue)
- All other themes: unchanged

---

## Phase 2: UI Component Visual Enhancements (5 files)

These need manual structural changes for new visual effects that can't cascade from token changes.

### Step 6: `lib/ui/shared/adaptive_scaffold.dart`
4 changes:

**a) Sidebar gradient accent line** — After the sidebar Container's right border, add a `Positioned` widget with a vertical gradient strip (teal at top → transparent → blue at bottom, 30% opacity). Use a `Stack` wrapping the sidebar.

**b) Quick Connect button gradient** — Replace the current `OutlinedButton` / button with a `Container` decorated with `AppColors.gradientBrand`, containing a `Material(color: transparent)` + `InkWell` for the tap effect, with white icon and text.

**c) Nav item glow background** — In the selected state for sidebar nav items, change from solid `AppColors.bgActive` to `AppColors.accentGlow` background with optional subtle `BoxShadow`.

**d) App logo gradient** — Change the logo container from `color: AppColors.accentPrimary` to `decoration: BoxDecoration(gradient: AppColors.gradientBrand)`.

### Step 7: `lib/ui/shared/workspace_tab_bar.dart`
2 changes:

**a) Active tab underglow** — Add a `BoxShadow` with `AppColors.accentGlow`, `blurRadius: 8`, `offset: Offset(0, 2)` to the active tab's `BoxDecoration`.

**b) Connected status dot pulse** — Add a breathing animation to the green connection dot. Use `flutter_animate` (already in deps) or an `AnimationController` with `repeat(reverse: true)` to pulse opacity between 0.5 and 1.0 over 2 seconds. Add a `BoxShadow` with `AppColors.successGlow` that also animates.

### Step 8: `lib/ui/hosts/hosts_screen.dart`
1 change:

**Host card hover effect** — Convert host list items to track hover state via `MouseRegion`. On hover: change border color to `AppColors.accentPrimary.withOpacity(0.3)`, add `BoxShadow` with `AppColors.accentGlow`, translate Y by -1px, transition to `AppColors.bgRaised` background. Use `AnimatedContainer` for smooth 200ms transitions.

### Step 9: `lib/ui/shared/command_palette.dart`
1 change:

**Frosted glass backdrop** — Wrap the `Dialog` content with `BackdropFilter(filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8))`. Make the dialog background slightly translucent: `AppColors.bgSurface.withOpacity(0.85)`. Change barrier from `Colors.black54` to `Colors.black38` for the blur to be visible. Add `import 'dart:ui';`.

### Step 10: `lib/ui/terminal/terminal_screen.dart`
1 change:

**Terminal glow overlay** — In the terminal view, add a `Stack` with a `Positioned.fill` → `IgnorePointer` → `Container` decorated with a top-down `LinearGradient` from `AppColors.accentPrimary.withOpacity(0.03)` to `Colors.transparent`, stopping at 30%. This creates a faint teal wash at the top of the terminal.

---

## Phase 3: Minor Cascading Updates (3 files)

### Step 11: `lib/ui/shared/app_lock_screen.dart`
Change the logo container from `color: AppColors.accentPrimary` to `decoration: BoxDecoration(gradient: AppColors.gradientBrand, borderRadius: ...)`.

### Step 12: `lib/ui/onboarding/onboarding_screen.dart`
Update the "Get Started" button to use gradient (same Container + Material + InkWell pattern as quick connect).

### Step 13: `lib/app.dart`
Update `fontFamily: 'Inter'` → `'PlusJakartaSans'` if present (may already cascade from ThemeData).

---

## Phase 4: Verification

1. **`flutter analyze`** — Catch any compile errors from new fields/renamed references
2. **Run on macOS** — Visual verification of dark theme changes
3. **Toggle light theme** — Verify it still works with new teal accent
4. **Terminal check** — Open a terminal, verify CloudShell Default cursor is teal, other 8 themes unchanged
5. **Interactive elements** — Hover host cards (glow border), click sidebar (glow bg), open command palette (backdrop blur), check workspace tabs (underglow + pulse)

---

## Files Summary (execution order)

| # | File | Change Type |
|---|------|-------------|
| 1 | `lib/core/theme/app_colors.dart` | Full palette replacement + new fields |
| 2 | `lib/core/theme/app_typography.dart` | Font family swap (2 lines) |
| 3 | `lib/core/constants/app_constants.dart` | Add radius constants, update sidebar width |
| 4 | `lib/core/theme/app_theme.dart` | Border radii, ColorScheme, fontFamily |
| 5 | `lib/core/theme/terminal_themes.dart` | CloudShell Default theme updates |
| 6 | `lib/ui/shared/adaptive_scaffold.dart` | Sidebar gradient, logo gradient, nav glow, quick connect gradient |
| 7 | `lib/ui/shared/workspace_tab_bar.dart` | Tab underglow, status dot pulse |
| 8 | `lib/ui/hosts/hosts_screen.dart` | Host card hover effects |
| 9 | `lib/ui/shared/command_palette.dart` | Backdrop blur |
| 10 | `lib/ui/terminal/terminal_screen.dart` | Terminal glow overlay |
| 11 | `lib/ui/shared/app_lock_screen.dart` | Logo gradient |
| 12 | `lib/ui/onboarding/onboarding_screen.dart` | Button gradient |
| 13 | `lib/app.dart` | fontFamily update |

**What auto-cascades from Steps 1-5**: All 20+ other UI screens (keys, snippets, SFTP, settings, port forwarding, host detail, host form, quick connect, etc.) — they reference `AppColors.*` and `AppTypography.*` directly, so the new palette and font propagate automatically.
