/// CloudShell ThemeData configuration.
///
/// Builds complete Flutter ThemeData instances from the
/// design system color palette and typography definitions.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Constructs [ThemeData] for CloudShell's dark and light modes.
///
/// The dark theme is the primary and default theme. Light theme
/// is provided as an alternative for accessibility.
abstract final class AppTheme {
  // ---------------------------------------------------------------------------
  // Dark Theme (Primary)
  // ---------------------------------------------------------------------------

  /// The primary dark theme for CloudShell.
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDeepest,
    canvasColor: AppColors.bgDeep,
    cardColor: AppColors.bgSurface,
    // Dialog background color set via dialogTheme below
    dividerColor: AppColors.borderSubtle,
    textTheme: AppTypography.textTheme,
    fontFamily: 'Inter',

    // Color scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentPrimary,
      onPrimary: AppColors.textInverse,
      secondary: AppColors.accentCyan,
      onSecondary: AppColors.textInverse,
      error: AppColors.accentRed,
      onError: AppColors.textPrimary,
      surface: AppColors.bgSurface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.borderDefault,
      outlineVariant: AppColors.borderSubtle,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgDeep,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // Bottom Navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgDeep,
      selectedItemColor: AppColors.accentPrimary,
      unselectedItemColor: AppColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // Navigation Rail (desktop sidebar items)
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: AppColors.bgDeep,
      selectedIconTheme: IconThemeData(color: AppColors.accentPrimary),
      unselectedIconTheme: IconThemeData(color: AppColors.textTertiary),
      indicatorColor: AppColors.bgActive,
    ),

    // Cards
    cardTheme: const CardThemeData(
      color: AppColors.bgSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: AppColors.borderSubtle),
      ),
    ),

    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: AppColors.textInverse,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: AppTypography.button,
        elevation: 0,
      ),
    ),

    // Outlined Buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: AppColors.borderDefault),
        textStyle: AppTypography.button,
      ),
    ),

    // Text Buttons
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentPrimary,
        textStyle: AppTypography.button,
      ),
    ),

    // Icon Buttons
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColors.textSecondary),
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgRaised,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.accentPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.accentRed),
      ),
      hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
      labelStyle: AppTypography.body.copyWith(color: AppColors.textSecondary),
    ),

    // Dialogs
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.bgRaised,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: AppTypography.h2,
    ),

    // Bottom Sheets
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.bgRaised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),

    // Snack Bars
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.bgRaised,
      contentTextStyle: AppTypography.body,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),

    // Dividers
    dividerTheme: const DividerThemeData(
      color: AppColors.borderSubtle,
      thickness: 1,
      space: 1,
    ),

    // List Tiles
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.textSecondary,
      textColor: AppColors.textPrimary,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    // Tooltips
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.bgRaised,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderDefault),
      ),
      textStyle: AppTypography.bodySmall,
    ),

    // Popup Menus
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.bgRaised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.borderDefault),
      ),
    ),

    // Switches and Toggles
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.accentPrimary;
        return AppColors.textTertiary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentPrimary.withValues(alpha: 0.3);
        }
        return AppColors.bgActive;
      }),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.accentPrimary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.textInverse),
      side: const BorderSide(color: AppColors.borderStrong),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Progress Indicators
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.accentPrimary,
      linearTrackColor: AppColors.bgActive,
    ),

    // Tab Bar
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.accentPrimary,
      unselectedLabelColor: AppColors.textTertiary,
      indicatorColor: AppColors.accentPrimary,
    ),
  );

  // ---------------------------------------------------------------------------
  // Light Theme
  // ---------------------------------------------------------------------------

  /// The light theme alternative for accessibility.
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorsLight.bgDeepest,
    canvasColor: AppColorsLight.bgDeep,
    cardColor: AppColorsLight.bgSurface,
    dividerColor: AppColorsLight.borderSubtle,
    fontFamily: 'Inter',

    colorScheme: const ColorScheme.light(
      primary: AppColorsLight.accentPrimary,
      onPrimary: Colors.white,
      secondary: AppColorsLight.accentCyan,
      onSecondary: Colors.white,
      error: AppColorsLight.accentRed,
      onError: Colors.white,
      surface: AppColorsLight.bgSurface,
      onSurface: AppColorsLight.textPrimary,
      outline: AppColorsLight.borderDefault,
      outlineVariant: AppColorsLight.borderSubtle,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsLight.bgDeep,
      foregroundColor: AppColorsLight.textPrimary,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    cardTheme: const CardThemeData(
      color: AppColorsLight.bgSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: AppColorsLight.borderSubtle),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsLight.bgRaised,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColorsLight.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColorsLight.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColorsLight.accentPrimary, width: 2),
      ),
    ),
  );
}
