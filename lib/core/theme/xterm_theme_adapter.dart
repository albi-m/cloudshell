/// Adapter to convert CloudShell terminal themes to xterm.dart themes.
///
/// Bridges between our [TerminalTheme] model (defined in
/// terminal_themes.dart) and xterm.dart's [TerminalTheme] widget class.
library;

import 'package:xterm/xterm.dart' as xterm;

import 'terminal_themes.dart' as cs;

/// Converts a CloudShell [TerminalTheme] to an xterm.dart [TerminalTheme].
///
/// Adds search highlight colors that xterm requires but our
/// theme model doesn't define.
xterm.TerminalTheme toXtermTheme(cs.TerminalTheme theme) {
  return xterm.TerminalTheme(
    cursor: theme.cursor,
    selection: theme.selection.withValues(alpha: 0.5),
    foreground: theme.foreground,
    background: theme.background,
    black: theme.black,
    red: theme.red,
    green: theme.green,
    yellow: theme.yellow,
    blue: theme.blue,
    magenta: theme.magenta,
    cyan: theme.cyan,
    white: theme.white,
    brightBlack: theme.brightBlack,
    brightRed: theme.brightRed,
    brightGreen: theme.brightGreen,
    brightYellow: theme.brightYellow,
    brightBlue: theme.brightBlue,
    brightMagenta: theme.brightMagenta,
    brightCyan: theme.brightCyan,
    brightWhite: theme.brightWhite,
    // Search highlight defaults
    searchHitBackground: theme.yellow.withValues(alpha: 0.3),
    searchHitBackgroundCurrent: theme.yellow.withValues(alpha: 0.6),
    searchHitForeground: theme.foreground,
  );
}
