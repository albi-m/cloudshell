/// CloudShell color palette definitions.
///
/// All colors are defined from the design system specification
/// (reference/design-system/DESIGN-SYSTEM.md). Dark theme is
/// the primary theme, inspired by GitHub's dark palette.
library;

import 'package:flutter/material.dart';

/// Dark theme color palette — the primary CloudShell theme.
///
/// Based on the GitHub Dark color palette, optimized for
/// terminal applications with high contrast and readability.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Backgrounds (darkest → lightest)
  // ---------------------------------------------------------------------------

  /// Main app background. Deepest shade for maximum contrast.
  static const Color bgDeepest = Color(0xFF0D1117);

  /// Sidebar, panels, and secondary surfaces.
  static const Color bgDeep = Color(0xFF161B22);

  /// Cards, elevated surfaces, and content areas.
  static const Color bgSurface = Color(0xFF1C2128);

  /// Dialogs, modals, dropdowns, and overlays.
  static const Color bgRaised = Color(0xFF252C35);

  /// Hover state background for interactive elements.
  static const Color bgHover = Color(0xFF2D333B);

  /// Active/pressed state background for interactive elements.
  static const Color bgActive = Color(0xFF3B434D);

  // ---------------------------------------------------------------------------
  // Borders
  // ---------------------------------------------------------------------------

  /// Subtle dividers and separators.
  static const Color borderSubtle = Color(0xFF21262D);

  /// Default borders for inputs, cards, and containers.
  static const Color borderDefault = Color(0xFF30363D);

  /// Strong emphasis borders for focused elements.
  static const Color borderStrong = Color(0xFF484F58);

  // ---------------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------------

  /// Primary text color for headings and body text.
  static const Color textPrimary = Color(0xFFE6EDF3);

  /// Secondary/muted text for subtitles and descriptions.
  static const Color textSecondary = Color(0xFF8B949E);

  /// Tertiary text for placeholders and disabled content.
  static const Color textTertiary = Color(0xFF6E7681);

  /// Text on light backgrounds (inverse).
  static const Color textInverse = Color(0xFF0D1117);

  // ---------------------------------------------------------------------------
  // Accent Colors
  // ---------------------------------------------------------------------------

  /// Primary blue — links, focused elements, primary actions.
  static const Color accentPrimary = Color(0xFF58A6FF);

  /// Blue hover state.
  static const Color accentHover = Color(0xFF79C0FF);

  /// Green — success states, connected indicators.
  static const Color accentGreen = Color(0xFF3FB950);

  /// Red — error states, destructive actions.
  static const Color accentRed = Color(0xFFF85149);

  /// Orange — warning states, pending indicators.
  static const Color accentOrange = Color(0xFFD29922);

  /// Purple — labels, badges, tags.
  static const Color accentPurple = Color(0xFFBC8CFF);

  /// Cyan — terminal accent, special highlights.
  static const Color accentCyan = Color(0xFF39D2C0);

  /// Pink — special highlights, decorative elements.
  static const Color accentPink = Color(0xFFF778BA);

  // ---------------------------------------------------------------------------
  // Status Colors
  // ---------------------------------------------------------------------------

  /// Server online / SSH connected.
  static const Color statusOnline = Color(0xFF3FB950);

  /// Server offline / connection error.
  static const Color statusOffline = Color(0xFFF85149);

  /// Connection warning / reconnecting.
  static const Color statusWarning = Color(0xFFD29922);

  /// Idle / disconnected state.
  static const Color statusIdle = Color(0xFF8B949E);
}

/// Light theme color palette for CloudShell.
///
/// Provides accessible contrast ratios (WCAG AA minimum 4.5:1)
/// for users who prefer light mode.
abstract final class AppColorsLight {
  // ---------------------------------------------------------------------------
  // Backgrounds
  // ---------------------------------------------------------------------------

  static const Color bgDeepest = Color(0xFFFFFFFF);
  static const Color bgDeep = Color(0xFFF6F8FA);
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

  static const Color accentPrimary = Color(0xFF0969DA);
  static const Color accentGreen = Color(0xFF1A7F37);
  static const Color accentRed = Color(0xFFCF222E);
  static const Color accentOrange = Color(0xFF9A6700);
  static const Color accentPurple = Color(0xFF8250DF);
  static const Color accentCyan = Color(0xFF1B7C83);
}
