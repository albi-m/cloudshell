/// CloudShell typography definitions.
///
/// UI uses Inter (via google_fonts), terminal uses JetBrains Mono
/// (bundled). Type scale follows the design system specification.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography scale and text style factory for CloudShell.
///
/// All text styles are derived from Inter (UI) and JetBrains Mono
/// (terminal/code), with consistent sizing across the app.
abstract final class AppTypography {
  // ---------------------------------------------------------------------------
  // UI Font (Inter)
  // ---------------------------------------------------------------------------

  /// Base Inter text style with primary text color.
  static TextStyle get _inter => GoogleFonts.inter(color: AppColors.textPrimary);

  /// Display — 28px Bold. Used for onboarding headers.
  static TextStyle get display => _inter.copyWith(fontSize: 28, fontWeight: FontWeight.w700);

  /// H1 — 24px Bold. Used for page titles.
  static TextStyle get h1 => _inter.copyWith(fontSize: 24, fontWeight: FontWeight.w700);

  /// H2 — 20px SemiBold. Used for section headers.
  static TextStyle get h2 => _inter.copyWith(fontSize: 20, fontWeight: FontWeight.w600);

  /// H3 — 16px SemiBold. Used for card titles, sidebar group headers.
  static TextStyle get h3 => _inter.copyWith(fontSize: 16, fontWeight: FontWeight.w600);

  /// Body Large — 16px Regular. Used for primary content.
  static TextStyle get bodyLarge => _inter.copyWith(fontSize: 16, fontWeight: FontWeight.w400);

  /// Body — 14px Regular. Default body text throughout the app.
  static TextStyle get body => _inter.copyWith(fontSize: 14, fontWeight: FontWeight.w400);

  /// Body Small — 13px Regular. Used for secondary information.
  static TextStyle get bodySmall => _inter.copyWith(fontSize: 13, fontWeight: FontWeight.w400);

  /// Caption — 12px Regular. Used for timestamps, metadata.
  static TextStyle get caption => _inter.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Overline — 11px SemiBold. Used for labels, section overlines.
  static TextStyle get overline => _inter.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  /// Button — 14px SemiBold. Used for button labels.
  static TextStyle get button => _inter.copyWith(fontSize: 14, fontWeight: FontWeight.w600);

  /// Tab — 13px Medium. Used for tab labels.
  static TextStyle get tab => _inter.copyWith(fontSize: 13, fontWeight: FontWeight.w500);

  // ---------------------------------------------------------------------------
  // Terminal Font (JetBrains Mono)
  // ---------------------------------------------------------------------------

  /// Terminal text style — JetBrains Mono Regular at the given size.
  ///
  /// Default size is 14px for desktop, 12px for mobile.
  static TextStyle terminal({double fontSize = 14.0}) {
    return const TextStyle(
      fontFamily: 'JetBrainsMono',
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textPrimary,
    ).copyWith(fontSize: fontSize);
  }

  /// Terminal bold text style.
  static TextStyle terminalBold({double fontSize = 14.0}) {
    return const TextStyle(
      fontFamily: 'JetBrainsMono',
      fontWeight: FontWeight.w700,
      height: 1.5,
      color: AppColors.textPrimary,
    ).copyWith(fontSize: fontSize);
  }

  /// Code/monospace text style for non-terminal use (e.g., snippets display).
  static TextStyle code({double fontSize = 13.0}) {
    return const TextStyle(
      fontFamily: 'JetBrainsMono',
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: AppColors.accentCyan,
    ).copyWith(fontSize: fontSize);
  }

  // ---------------------------------------------------------------------------
  // Flutter TextTheme
  // ---------------------------------------------------------------------------

  /// Constructs the complete [TextTheme] for use in [ThemeData].
  static TextTheme get textTheme => TextTheme(
    displayLarge: display,
    headlineLarge: h1,
    headlineMedium: h2,
    headlineSmall: h3,
    bodyLarge: bodyLarge,
    bodyMedium: body,
    bodySmall: bodySmall,
    labelLarge: button,
    labelMedium: tab,
    labelSmall: overline,
  );
}
