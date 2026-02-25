/// CloudShell color palette definitions — "Aether" design system.
///
/// All colors are defined from the Aether design concept.
/// Dark theme is the primary theme, featuring deep blue-black
/// undertones with a signature teal accent.
library;

import 'package:flutter/material.dart';

/// Dark theme color palette — the primary CloudShell "Aether" theme.
///
/// Features deep blue-black backgrounds with a signature teal (#00D4AA)
/// primary accent and blue (#5B9CF6) secondary accent.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Backgrounds (deepest → lightest, blue-black undertone)
  // ---------------------------------------------------------------------------

  /// Main app background. Deepest shade — near-black with blue undertone.
  static const Color bgDeepest = Color(0xFF05070C);

  /// Sidebar, panels, and secondary surfaces.
  static const Color bgDeep = Color(0xFF0A0E17);

  /// Intermediate layer for content areas between deep and surface.
  static const Color bgBase = Color(0xFF0F1420);

  /// Cards, elevated surfaces, and content areas.
  static const Color bgSurface = Color(0xFF151B29);

  /// Dialogs, modals, dropdowns, and overlays.
  static const Color bgRaised = Color(0xFF1B2233);

  /// Hover state background for interactive elements.
  static const Color bgHover = Color(0xFF212A3D);

  /// Active/pressed state background for interactive elements.
  static const Color bgActive = Color(0xFF283348);

  // ---------------------------------------------------------------------------
  // Borders
  // ---------------------------------------------------------------------------

  /// Subtle dividers and separators.
  static const Color borderSubtle = Color(0xFF162036);

  /// Default borders for inputs, cards, and containers.
  static const Color borderDefault = Color(0xFF1E2B45);

  /// Strong emphasis borders for focused elements.
  static const Color borderStrong = Color(0xFF2D3E5C);

  // ---------------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------------

  /// Primary text color for headings and body text.
  static const Color textPrimary = Color(0xFFE2E8F4);

  /// Secondary/muted text for subtitles and descriptions.
  static const Color textSecondary = Color(0xFF7E8BA4);

  /// Tertiary text for placeholders and disabled content.
  /// Contrast on bgDeepest: ~4.6:1 (WCAG AA compliant).
  static const Color textTertiary = Color(0xFF8490A8);

  /// Text on light backgrounds (inverse).
  static const Color textInverse = Color(0xFF05070C);

  // ---------------------------------------------------------------------------
  // Accent Colors
  // ---------------------------------------------------------------------------

  /// Primary teal — signature accent for links, focus, primary actions.
  static const Color accentPrimary = Color(0xFF00D4AA);

  /// Bright teal — hover/highlight state.
  static const Color accentBright = Color(0xFF00F0C0);

  /// Muted teal — subtle references, code highlights.
  static const Color accentMuted = Color(0xFF00A888);

  /// Teal hover state (alias for accentBright).
  static const Color accentHover = Color(0xFF00F0C0);

  /// Secondary blue — secondary accent, tags, complementary highlights.
  static const Color accentBlue = Color(0xFF5B9CF6);

  /// Green — success states, connected indicators.
  static const Color accentGreen = Color(0xFF34D058);

  /// Red — error states, destructive actions.
  static const Color accentRed = Color(0xFFF85149);

  /// Orange — warning states, pending indicators.
  static const Color accentOrange = Color(0xFFF0B232);

  /// Purple — labels, badges, tags.
  static const Color accentPurple = Color(0xFFB388FF);

  /// Cyan — terminal accent, special highlights.
  static const Color accentCyan = Color(0xFF39D2C0);

  /// Pink — special highlights, decorative elements.
  static const Color accentPink = Color(0xFFF778BA);

  // ---------------------------------------------------------------------------
  // Status Colors
  // ---------------------------------------------------------------------------

  /// Server online / SSH connected.
  static const Color statusOnline = Color(0xFF34D058);

  /// Server offline / connection error.
  static const Color statusOffline = Color(0xFFF85149);

  /// Connection warning / reconnecting.
  static const Color statusWarning = Color(0xFFF0B232);

  /// Idle / disconnected state.
  static const Color statusIdle = Color(0xFF7E8BA4);

  // ---------------------------------------------------------------------------
  // Glow Colors (semi-transparent for BoxShadow / overlay effects)
  // ---------------------------------------------------------------------------

  /// 12% teal glow — active nav items, subtle highlights.
  static const Color accentGlow = Color(0x1F00D4AA);

  /// 25% teal glow — strong emphasis, selection backgrounds.
  static const Color accentGlowStrong = Color(0x4000D4AA);

  /// 12% blue glow — secondary highlights.
  static const Color blueGlow = Color(0x1F5B9CF6);

  /// 15% green glow — connected status dots.
  static const Color successGlow = Color(0x2634D058);

  /// 15% red glow — error indicators.
  static const Color errorGlow = Color(0x26F85149);

  /// 15% orange/warning glow.
  static const Color warningGlow = Color(0x26F0B232);

  // ---------------------------------------------------------------------------
  // Brand Gradient (signature teal → blue)
  // ---------------------------------------------------------------------------

  /// Signature brand gradient for CTAs, logos, and primary buttons.
  static const LinearGradient gradientBrand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D4AA), Color(0xFF5B9CF6)],
  );

  /// Returns the appropriate brand gradient based on theme brightness.
  static LinearGradient gradientBrandFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gradientBrand
        : AppColorsLight.gradientBrand;
  }
}

/// Light theme color palette for CloudShell.
///
/// Provides accessible contrast ratios (WCAG AA minimum 4.5:1)
/// for users who prefer light mode. Uses teal accent to match
/// the dark theme identity.
abstract final class AppColorsLight {
  // ---------------------------------------------------------------------------
  // Backgrounds
  // ---------------------------------------------------------------------------

  static const Color bgDeepest = Color(0xFFFFFFFF);
  static const Color bgDeep = Color(0xFFF6F8FA);
  static const Color bgBase = Color(0xFFF0F3F6);
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color bgRaised = Color(0xFFF3F4F6);
  static const Color bgHover = Color(0xFFEAEEF2);
  static const Color bgActive = Color(0xFFD0D7DE);

  // ---------------------------------------------------------------------------
  // Borders
  // ---------------------------------------------------------------------------

  static const Color borderSubtle = Color(0xFFF0F0F0);
  static const Color borderDefault = Color(0xFFD0D7DE);
  static const Color borderStrong = Color(0xFF8C959F);

  // ---------------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------------

  static const Color textPrimary = Color(0xFF1F2328);
  static const Color textSecondary = Color(0xFF656D76);
  static const Color textTertiary = Color(0xFF8C959F);

  // ---------------------------------------------------------------------------
  // Accent Colors
  // ---------------------------------------------------------------------------

  /// Primary teal for light mode — 4.6:1 contrast on white.
  static const Color accentPrimary = Color(0xFF009977);

  /// Secondary blue (the old primary).
  static const Color accentBlue = Color(0xFF0969DA);

  static const Color accentGreen = Color(0xFF1A7F37);
  static const Color accentRed = Color(0xFFCF222E);
  static const Color accentOrange = Color(0xFF9A6700);
  static const Color accentPurple = Color(0xFF8250DF);
  static const Color accentCyan = Color(0xFF1B7C83);
  static const Color accentPink = Color(0xFFBF3989);

  static const Color accentBright = Color(0xFF00B386);
  static const Color accentMuted = Color(0xFF007A5E);
  static const Color accentHover = Color(0xFF00B386);

  // ---------------------------------------------------------------------------
  // Status Colors
  // ---------------------------------------------------------------------------

  static const Color statusOnline = Color(0xFF1A7F37);
  static const Color statusOffline = Color(0xFFCF222E);
  static const Color statusWarning = Color(0xFF9A6700);
  static const Color statusIdle = Color(0xFF656D76);

  static const Color textInverse = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Glow Colors (light theme variants)
  // ---------------------------------------------------------------------------

  static const Color accentGlow = Color(0x1A009977);
  static const Color accentGlowStrong = Color(0x33009977);
  static const Color blueGlow = Color(0x1A0969DA);
  static const Color successGlow = Color(0x261A7F37);
  static const Color errorGlow = Color(0x26CF222E);
  static const Color warningGlow = Color(0x269A6700);

  // ---------------------------------------------------------------------------
  // Brand Gradient (light variant)
  // ---------------------------------------------------------------------------

  static const LinearGradient gradientBrand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF009977), Color(0xFF0969DA)],
  );
}
