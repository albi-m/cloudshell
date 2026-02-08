/// BuildContext convenience extensions for CloudShell.
///
/// Reduces boilerplate when accessing theme, media query,
/// and navigation from widgets.
library;

import 'package:flutter/material.dart';

/// Shorthand accessors for common BuildContext properties.
extension ContextExtensions on BuildContext {
  /// Current [ThemeData] from the widget tree.
  ThemeData get theme => Theme.of(this);

  /// Current [ColorScheme] from the active theme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Current [TextTheme] from the active theme.
  TextTheme get textTheme => theme.textTheme;

  /// Current [MediaQueryData] for screen dimensions and padding.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen width in logical pixels.
  double get screenWidth => mediaQuery.size.width;

  /// Screen height in logical pixels.
  double get screenHeight => mediaQuery.size.height;

  /// Whether the current screen width qualifies as desktop layout.
  bool get isDesktop => screenWidth >= 768;

  /// Whether the current screen width qualifies as wide desktop.
  bool get isWideDesktop => screenWidth >= 1200;

  /// Whether the current screen width qualifies as mobile layout.
  bool get isMobile => screenWidth < 768;

  /// Whether the current screen width qualifies as tablet layout.
  bool get isTablet => screenWidth >= 600 && screenWidth < 768;

  /// Safe area padding (notches, status bars, home indicators).
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  /// Shows a [SnackBar] with the given message.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
