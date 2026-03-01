/// Terminal color theme definitions for CloudShell.
///
/// Each theme provides a complete set of ANSI 16 colors plus
/// background, foreground, cursor, and selection colors.
/// These are used by xterm.dart for terminal rendering.
library;

import 'package:flutter/material.dart';

/// A complete terminal color theme with ANSI 16-color palette.
///
/// Used to configure the xterm.dart terminal emulator's color scheme.
class TerminalTheme {
  const TerminalTheme({
    required this.name,
    required this.background,
    required this.foreground,
    required this.cursor,
    required this.selection,
    required this.black,
    required this.red,
    required this.green,
    required this.yellow,
    required this.blue,
    required this.magenta,
    required this.cyan,
    required this.white,
    required this.brightBlack,
    required this.brightRed,
    required this.brightGreen,
    required this.brightYellow,
    required this.brightBlue,
    required this.brightMagenta,
    required this.brightCyan,
    required this.brightWhite,
  });

  /// Display name for the theme picker UI.
  final String name;

  // Terminal chrome colors.
  final Color background;
  final Color foreground;
  final Color cursor;
  final Color selection;

  // Standard ANSI colors (0-7).
  final Color black;
  final Color red;
  final Color green;
  final Color yellow;
  final Color blue;
  final Color magenta;
  final Color cyan;
  final Color white;

  // Bright ANSI colors (8-15).
  final Color brightBlack;
  final Color brightRed;
  final Color brightGreen;
  final Color brightYellow;
  final Color brightBlue;
  final Color brightMagenta;
  final Color brightCyan;
  final Color brightWhite;
}

/// Derives a slightly lighter/darker background for terminal chrome elements
/// (status bar, extra keys bar) so they complement the terminal theme.
Color terminalChromeBg(Color themeBg) {
  final hsl = HSLColor.fromColor(themeBg);
  return hsl.lightness < 0.5
      ? hsl.withLightness((hsl.lightness + 0.05).clamp(0.0, 1.0)).toColor()
      : hsl.withLightness((hsl.lightness - 0.05).clamp(0.0, 1.0)).toColor();
}

/// Derives a border color from the terminal theme background.
Color terminalChromeBorder(Color themeBg) {
  final hsl = HSLColor.fromColor(themeBg);
  return hsl.lightness < 0.5
      ? hsl.withLightness((hsl.lightness + 0.08).clamp(0.0, 1.0)).toColor()
      : hsl.withLightness((hsl.lightness - 0.08).clamp(0.0, 1.0)).toColor();
}

/// Derives a surface color for buttons/keys from the terminal theme background.
Color terminalChromeSurface(Color themeBg) {
  final hsl = HSLColor.fromColor(themeBg);
  return hsl.lightness < 0.5
      ? hsl.withLightness((hsl.lightness + 0.10).clamp(0.0, 1.0)).toColor()
      : hsl.withLightness((hsl.lightness - 0.10).clamp(0.0, 1.0)).toColor();
}

/// All built-in terminal color themes.
///
/// The default theme ('cloudshell_default') matches the app's
/// dark theme palette for visual consistency.
abstract final class TerminalThemes {
  /// Map of theme ID → theme definition.
  static final Map<String, TerminalTheme> all = {
    'cloudshell_default': cloudshellDefault,
    'dracula': dracula,
    'nord': nord,
    'solarized_dark': solarizedDark,
    'one_dark': oneDark,
    'catppuccin_mocha': catppuccinMocha,
    'tokyo_night': tokyoNight,
    'gruvbox_dark': gruvboxDark,
    'monokai_pro': monokaiPro,
    'rose_pine': rosePine,
    'everforest_dark': everforestDark,
    'ayu_dark': ayuDark,
    'kanagawa': kanagawa,
    'solarized_light': solarizedLight,
    'github_light': githubLight,
  };

  /// Returns the theme for the given ID, falling back to default.
  static TerminalTheme byId(String id) => all[id] ?? cloudshellDefault;

  // ---------------------------------------------------------------------------
  // Theme 1: CloudShell Default (signature theme)
  // ---------------------------------------------------------------------------
  static const cloudshellDefault = TerminalTheme(
    name: 'CloudShell Default',
    background: Color(0xFF05070C),
    foreground: Color(0xFFC9D1D9),
    cursor: Color(0xFF00D4AA),
    selection: Color(0xFF1E2B45),
    black: Color(0xFF484F58),
    red: Color(0xFFFF7B72),
    green: Color(0xFF34D058),
    yellow: Color(0xFFF0B232),
    blue: Color(0xFF5B9CF6),
    magenta: Color(0xFFB388FF),
    cyan: Color(0xFF39D2C0),
    white: Color(0xFFB1BAC4),
    brightBlack: Color(0xFF6E7681),
    brightRed: Color(0xFFFFA198),
    brightGreen: Color(0xFF56D364),
    brightYellow: Color(0xFFE3B341),
    brightBlue: Color(0xFF79C0FF),
    brightMagenta: Color(0xFFD2A8FF),
    brightCyan: Color(0xFF56D4DD),
    brightWhite: Color(0xFFF0F6FC),
  );

  // ---------------------------------------------------------------------------
  // Theme 2: Dracula
  // ---------------------------------------------------------------------------
  static const dracula = TerminalTheme(
    name: 'Dracula',
    background: Color(0xFF282A36),
    foreground: Color(0xFFF8F8F2),
    cursor: Color(0xFFF8F8F2),
    selection: Color(0xFF44475A),
    black: Color(0xFF21222C),
    red: Color(0xFFFF5555),
    green: Color(0xFF50FA7B),
    yellow: Color(0xFFF1FA8C),
    blue: Color(0xFFBD93F9),
    magenta: Color(0xFFFF79C6),
    cyan: Color(0xFF8BE9FD),
    white: Color(0xFFF8F8F2),
    brightBlack: Color(0xFF6272A4),
    brightRed: Color(0xFFFF6E6E),
    brightGreen: Color(0xFF69FF94),
    brightYellow: Color(0xFFFFFFA5),
    brightBlue: Color(0xFFD6ACFF),
    brightMagenta: Color(0xFFFF92DF),
    brightCyan: Color(0xFFA4FFFF),
    brightWhite: Color(0xFFFFFFFF),
  );

  // ---------------------------------------------------------------------------
  // Theme 3: Nord
  // ---------------------------------------------------------------------------
  static const nord = TerminalTheme(
    name: 'Nord',
    background: Color(0xFF2E3440),
    foreground: Color(0xFFD8DEE9),
    cursor: Color(0xFFD8DEE9),
    selection: Color(0xFF434C5E),
    black: Color(0xFF3B4252),
    red: Color(0xFFBF616A),
    green: Color(0xFFA3BE8C),
    yellow: Color(0xFFEBCB8B),
    blue: Color(0xFF81A1C1),
    magenta: Color(0xFFB48EAD),
    cyan: Color(0xFF88C0D0),
    white: Color(0xFFE5E9F0),
    brightBlack: Color(0xFF4C566A),
    brightRed: Color(0xFFBF616A),
    brightGreen: Color(0xFFA3BE8C),
    brightYellow: Color(0xFFEBCB8B),
    brightBlue: Color(0xFF81A1C1),
    brightMagenta: Color(0xFFB48EAD),
    brightCyan: Color(0xFF8FBCBB),
    brightWhite: Color(0xFFECEFF4),
  );

  // ---------------------------------------------------------------------------
  // Theme 4: Solarized Dark
  // ---------------------------------------------------------------------------
  static const solarizedDark = TerminalTheme(
    name: 'Solarized Dark',
    background: Color(0xFF002B36),
    foreground: Color(0xFF839496),
    cursor: Color(0xFF839496),
    selection: Color(0xFF073642),
    black: Color(0xFF073642),
    red: Color(0xFFDC322F),
    green: Color(0xFF859900),
    yellow: Color(0xFFB58900),
    blue: Color(0xFF268BD2),
    magenta: Color(0xFFD33682),
    cyan: Color(0xFF2AA198),
    white: Color(0xFFEEE8D5),
    brightBlack: Color(0xFF586E75),
    brightRed: Color(0xFFCB4B16),
    brightGreen: Color(0xFF586E75),
    brightYellow: Color(0xFF657B83),
    brightBlue: Color(0xFF839496),
    brightMagenta: Color(0xFF6C71C4),
    brightCyan: Color(0xFF93A1A1),
    brightWhite: Color(0xFFFDF6E3),
  );

  // ---------------------------------------------------------------------------
  // Theme 5: One Dark
  // ---------------------------------------------------------------------------
  static const oneDark = TerminalTheme(
    name: 'One Dark',
    background: Color(0xFF282C34),
    foreground: Color(0xFFABB2BF),
    cursor: Color(0xFF528BFF),
    selection: Color(0xFF3E4451),
    black: Color(0xFF545862),
    red: Color(0xFFE06C75),
    green: Color(0xFF98C379),
    yellow: Color(0xFFE5C07B),
    blue: Color(0xFF61AFEF),
    magenta: Color(0xFFC678DD),
    cyan: Color(0xFF56B6C2),
    white: Color(0xFFABB2BF),
    brightBlack: Color(0xFF636B78),
    brightRed: Color(0xFFE06C75),
    brightGreen: Color(0xFF98C379),
    brightYellow: Color(0xFFE5C07B),
    brightBlue: Color(0xFF61AFEF),
    brightMagenta: Color(0xFFC678DD),
    brightCyan: Color(0xFF56B6C2),
    brightWhite: Color(0xFFC8CCD4),
  );

  // ---------------------------------------------------------------------------
  // Theme 6: Catppuccin Mocha
  // ---------------------------------------------------------------------------
  static const catppuccinMocha = TerminalTheme(
    name: 'Catppuccin Mocha',
    background: Color(0xFF1E1E2E),
    foreground: Color(0xFFCDD6F4),
    cursor: Color(0xFFF5E0DC),
    selection: Color(0xFF45475A),
    black: Color(0xFF45475A),
    red: Color(0xFFF38BA8),
    green: Color(0xFFA6E3A1),
    yellow: Color(0xFFF9E2AF),
    blue: Color(0xFF89B4FA),
    magenta: Color(0xFFF5C2E7),
    cyan: Color(0xFF94E2D5),
    white: Color(0xFFBAC2DE),
    brightBlack: Color(0xFF585B70),
    brightRed: Color(0xFFF38BA8),
    brightGreen: Color(0xFFA6E3A1),
    brightYellow: Color(0xFFF9E2AF),
    brightBlue: Color(0xFF89B4FA),
    brightMagenta: Color(0xFFF5C2E7),
    brightCyan: Color(0xFF94E2D5),
    brightWhite: Color(0xFFA6ADC8),
  );

  // ---------------------------------------------------------------------------
  // Theme 7: Tokyo Night
  // ---------------------------------------------------------------------------
  static const tokyoNight = TerminalTheme(
    name: 'Tokyo Night',
    background: Color(0xFF1A1B26),
    foreground: Color(0xFFC0CAF5),
    cursor: Color(0xFFC0CAF5),
    selection: Color(0xFF33467C),
    black: Color(0xFF15161E),
    red: Color(0xFFF7768E),
    green: Color(0xFF9ECE6A),
    yellow: Color(0xFFE0AF68),
    blue: Color(0xFF7AA2F7),
    magenta: Color(0xFFBB9AF7),
    cyan: Color(0xFF7DCFFF),
    white: Color(0xFFA9B1D6),
    brightBlack: Color(0xFF414868),
    brightRed: Color(0xFFF7768E),
    brightGreen: Color(0xFF9ECE6A),
    brightYellow: Color(0xFFE0AF68),
    brightBlue: Color(0xFF7AA2F7),
    brightMagenta: Color(0xFFBB9AF7),
    brightCyan: Color(0xFF7DCFFF),
    brightWhite: Color(0xFFC0CAF5),
  );

  // ---------------------------------------------------------------------------
  // Theme 8: Gruvbox Dark
  // ---------------------------------------------------------------------------
  static const gruvboxDark = TerminalTheme(
    name: 'Gruvbox Dark',
    background: Color(0xFF282828),
    foreground: Color(0xFFEBDBB2),
    cursor: Color(0xFFEBDBB2),
    selection: Color(0xFF3C3836),
    black: Color(0xFF282828),
    red: Color(0xFFCC241D),
    green: Color(0xFF98971A),
    yellow: Color(0xFFD79921),
    blue: Color(0xFF458588),
    magenta: Color(0xFFB16286),
    cyan: Color(0xFF689D6A),
    white: Color(0xFFA89984),
    brightBlack: Color(0xFF928374),
    brightRed: Color(0xFFFB4934),
    brightGreen: Color(0xFFB8BB26),
    brightYellow: Color(0xFFFABD2F),
    brightBlue: Color(0xFF83A598),
    brightMagenta: Color(0xFFD3869B),
    brightCyan: Color(0xFF8EC07C),
    brightWhite: Color(0xFFEBDBB2),
  );

  // ---------------------------------------------------------------------------
  // Theme 9: Monokai Pro
  // ---------------------------------------------------------------------------
  static const monokaiPro = TerminalTheme(
    name: 'Monokai Pro',
    background: Color(0xFF2D2A2E),
    foreground: Color(0xFFFCFCFA),
    cursor: Color(0xFFFCFCFA),
    selection: Color(0xFF403E41),
    black: Color(0xFF403E41),
    red: Color(0xFFFF6188),
    green: Color(0xFFA9DC76),
    yellow: Color(0xFFFFD866),
    blue: Color(0xFFFC9867),
    magenta: Color(0xFFAB9DF2),
    cyan: Color(0xFF78DCE8),
    white: Color(0xFFFCFCFA),
    brightBlack: Color(0xFF727072),
    brightRed: Color(0xFFFF6188),
    brightGreen: Color(0xFFA9DC76),
    brightYellow: Color(0xFFFFD866),
    brightBlue: Color(0xFFFC9867),
    brightMagenta: Color(0xFFAB9DF2),
    brightCyan: Color(0xFF78DCE8),
    brightWhite: Color(0xFFFCFCFA),
  );

  // ---------------------------------------------------------------------------
  // Theme 10: Rosé Pine
  // ---------------------------------------------------------------------------
  static const rosePine = TerminalTheme(
    name: 'Rosé Pine',
    background: Color(0xFF191724),
    foreground: Color(0xFFE0DEF4),
    cursor: Color(0xFF524F67),
    selection: Color(0xFF2A283E),
    black: Color(0xFF26233A),
    red: Color(0xFFEB6F92),
    green: Color(0xFF9CCFD8),
    yellow: Color(0xFFF6C177),
    blue: Color(0xFF31748F),
    magenta: Color(0xFFC4A7E7),
    cyan: Color(0xFFEBBCBA),
    white: Color(0xFFE0DEF4),
    brightBlack: Color(0xFF6E6A86),
    brightRed: Color(0xFFEB6F92),
    brightGreen: Color(0xFF9CCFD8),
    brightYellow: Color(0xFFF6C177),
    brightBlue: Color(0xFF31748F),
    brightMagenta: Color(0xFFC4A7E7),
    brightCyan: Color(0xFFEBBCBA),
    brightWhite: Color(0xFFE0DEF4),
  );

  // ---------------------------------------------------------------------------
  // Theme 11: Everforest Dark
  // ---------------------------------------------------------------------------
  static const everforestDark = TerminalTheme(
    name: 'Everforest Dark',
    background: Color(0xFF2D353B),
    foreground: Color(0xFFD3C6AA),
    cursor: Color(0xFFD3C6AA),
    selection: Color(0xFF543A48),
    black: Color(0xFF475258),
    red: Color(0xFFE67E80),
    green: Color(0xFFA7C080),
    yellow: Color(0xFFDBBC7F),
    blue: Color(0xFF7FBBB3),
    magenta: Color(0xFFD699B6),
    cyan: Color(0xFF83C092),
    white: Color(0xFFD3C6AA),
    brightBlack: Color(0xFF475258),
    brightRed: Color(0xFFE67E80),
    brightGreen: Color(0xFFA7C080),
    brightYellow: Color(0xFFDBBC7F),
    brightBlue: Color(0xFF7FBBB3),
    brightMagenta: Color(0xFFD699B6),
    brightCyan: Color(0xFF83C092),
    brightWhite: Color(0xFFD3C6AA),
  );

  // ---------------------------------------------------------------------------
  // Theme 12: Ayu Dark
  // ---------------------------------------------------------------------------
  static const ayuDark = TerminalTheme(
    name: 'Ayu Dark',
    background: Color(0xFF0A0E14),
    foreground: Color(0xFFB3B1AD),
    cursor: Color(0xFFE6B450),
    selection: Color(0xFF253340),
    black: Color(0xFF01060E),
    red: Color(0xFFEA6C73),
    green: Color(0xFF91B362),
    yellow: Color(0xFFF9AF4F),
    blue: Color(0xFF53BDFA),
    magenta: Color(0xFFFAE994),
    cyan: Color(0xFF90E1C6),
    white: Color(0xFFC7C7C7),
    brightBlack: Color(0xFF686868),
    brightRed: Color(0xFFF07178),
    brightGreen: Color(0xFFC2D94C),
    brightYellow: Color(0xFFFFB454),
    brightBlue: Color(0xFF59C2FF),
    brightMagenta: Color(0xFFFFEE99),
    brightCyan: Color(0xFF95E6CB),
    brightWhite: Color(0xFFFFFFFF),
  );

  // ---------------------------------------------------------------------------
  // Theme 13: Kanagawa
  // ---------------------------------------------------------------------------
  static const kanagawa = TerminalTheme(
    name: 'Kanagawa',
    background: Color(0xFF1F1F28),
    foreground: Color(0xFFDCD7BA),
    cursor: Color(0xFFC8C093),
    selection: Color(0xFF2D4F67),
    black: Color(0xFF090618),
    red: Color(0xFFC34043),
    green: Color(0xFF76946A),
    yellow: Color(0xFFC0A36E),
    blue: Color(0xFF7E9CD8),
    magenta: Color(0xFF957FB8),
    cyan: Color(0xFF6A9589),
    white: Color(0xFFC8C093),
    brightBlack: Color(0xFF727169),
    brightRed: Color(0xFFE82424),
    brightGreen: Color(0xFF98BB6C),
    brightYellow: Color(0xFFE6C384),
    brightBlue: Color(0xFF7FB4CA),
    brightMagenta: Color(0xFF938AA9),
    brightCyan: Color(0xFF7AA89F),
    brightWhite: Color(0xFFDCD7BA),
  );

  // ---------------------------------------------------------------------------
  // Theme 14: Solarized Light
  // ---------------------------------------------------------------------------
  static const solarizedLight = TerminalTheme(
    name: 'Solarized Light',
    background: Color(0xFFFDF6E3),
    foreground: Color(0xFF657B83),
    cursor: Color(0xFF657B83),
    selection: Color(0xFFEEE8D5),
    black: Color(0xFF073642),
    red: Color(0xFFDC322F),
    green: Color(0xFF859900),
    yellow: Color(0xFFB58900),
    blue: Color(0xFF268BD2),
    magenta: Color(0xFFD33682),
    cyan: Color(0xFF2AA198),
    white: Color(0xFFEEE8D5),
    brightBlack: Color(0xFF002B36),
    brightRed: Color(0xFFCB4B16),
    brightGreen: Color(0xFF586E75),
    brightYellow: Color(0xFF657B83),
    brightBlue: Color(0xFF839496),
    brightMagenta: Color(0xFF6C71C4),
    brightCyan: Color(0xFF93A1A1),
    brightWhite: Color(0xFFFDF6E3),
  );

  // ---------------------------------------------------------------------------
  // Theme 15: GitHub Light
  // ---------------------------------------------------------------------------
  static const githubLight = TerminalTheme(
    name: 'GitHub Light',
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF24292E),
    cursor: Color(0xFF044289),
    selection: Color(0xFFC8C8FA),
    black: Color(0xFF24292E),
    red: Color(0xFFD73A49),
    green: Color(0xFF28A745),
    yellow: Color(0xFFDBAB09),
    blue: Color(0xFF0366D6),
    magenta: Color(0xFF5A32A3),
    cyan: Color(0xFF0598BC),
    white: Color(0xFF6A737D),
    brightBlack: Color(0xFF959DA5),
    brightRed: Color(0xFFCB2431),
    brightGreen: Color(0xFF22863A),
    brightYellow: Color(0xFFB08800),
    brightBlue: Color(0xFF005CC5),
    brightMagenta: Color(0xFF5A32A3),
    brightCyan: Color(0xFF3192AA),
    brightWhite: Color(0xFFD1D5DA),
  );
}
