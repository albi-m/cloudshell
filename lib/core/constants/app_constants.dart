/// Application-wide constants for CloudShell.
///
/// Centralizes all magic numbers and configuration values
/// to prevent duplication and ensure consistency.
library;

/// Core application identity and versioning constants.
abstract final class AppConstants {
  /// Application display name shown in UI.
  static const String appName = 'CloudShell';

  /// Application tagline for onboarding and about screens.
  static const String appTagline = 'Your servers. Everywhere.';

  /// Bundle identifier prefix for all platforms.
  static const String bundleId = 'com.cloudshell';

  // --- SSH Defaults ---

  /// Default SSH port for new host connections.
  static const int defaultSshPort = 22;

  /// Default connection timeout in seconds.
  static const int defaultConnectionTimeout = 30;

  /// Default keep-alive interval in seconds to prevent idle disconnects.
  static const int defaultKeepAliveInterval = 60;

  /// Default character encoding for terminal sessions.
  static const String defaultEncoding = 'UTF-8';

  // --- Terminal Defaults ---

  /// Default scrollback buffer size (number of lines retained).
  static const int defaultScrollbackLines = 10000;

  /// Default terminal font size on desktop platforms (in logical pixels).
  static const double defaultTerminalFontSizeDesktop = 14.0;

  /// Default terminal font size on mobile platforms (in logical pixels).
  static const double defaultTerminalFontSizeMobile = 12.0;

  /// Terminal line height multiplier for readable spacing.
  static const double terminalLineHeight = 1.5;

  /// Default terminal font family.
  static const String defaultTerminalFontFamily = 'JetBrainsMono';

  /// Available terminal font families.
  ///
  /// First entry is bundled; the rest load via Google Fonts.
  static const List<String> terminalFonts = [
    'JetBrainsMono',
    'Fira Code',
    'Source Code Pro',
    'Roboto Mono',
    'IBM Plex Mono',
    'Inconsolata',
    'Ubuntu Mono',
    'Cousine',
    'Anonymous Pro',
    'PT Mono',
  ];

  // --- Security Defaults ---

  /// Auto-lock timeout in seconds (5 minutes).
  static const int defaultAutoLockSeconds = 300;

  /// Clipboard auto-clear timeout in seconds.
  static const int defaultClipboardTimeout = 30;

  /// Argon2id memory cost in bytes (64 MB).
  static const int argon2MemoryCost = 64 * 1024 * 1024;

  /// Argon2id iteration count.
  static const int argon2Iterations = 3;

  /// Argon2id parallelism factor.
  static const int argon2Parallelism = 4;

  // --- UI Constants ---

  // --- Border Radii ---

  /// Small radius for buttons, inputs, and compact elements.
  static const double radiusSmall = 4.0;

  /// Medium radius for standard components.
  static const double radiusMedium = 6.0;

  /// Large radius for cards, popups, and containers.
  static const double radiusLarge = 10.0;

  /// Extra-large radius for modals and dialogs.
  static const double radiusXLarge = 14.0;

  /// Desktop sidebar width in logical pixels.
  static const double sidebarWidth = 256.0;

  /// Desktop sidebar collapsed width (icon-only mode) in logical pixels.
  static const double sidebarCollapsedWidth = 60.0;

  /// Breakpoint below which phone/mobile layout is used (bottom nav bar).
  ///
  /// Covers iPhone and iPad Slide Over narrow mode.
  static const double phoneBreakpoint = 600.0;

  /// Breakpoint width at which the layout switches from mobile to desktop.
  static const double desktopBreakpoint = 768.0;

  /// Breakpoint below which the sidebar is forced to icon-only collapsed mode.
  ///
  /// Ensures iPad Split View (50/50) and narrow desktop windows get a
  /// usable compact sidebar instead of the full expanded sidebar.
  static const double compactSidebarBreakpoint = 900.0;

  /// Breakpoint width for wide desktop layouts.
  static const double wideDesktopBreakpoint = 1200.0;

  /// Minimum touch target size per Apple HIG (44x44 points).
  static const double minTouchTarget = 44.0;

  /// Standard animation duration for UI transitions.
  static const Duration animationDuration = Duration(milliseconds: 200);

  /// Slow animation duration for page transitions.
  static const Duration slowAnimationDuration = Duration(milliseconds: 350);

  // --- Reconnect ---

  /// Maximum number of automatic reconnection attempts.
  static const int maxReconnectAttempts = 5;

  /// Exponential backoff delays in seconds for reconnect attempts.
  static const List<int> reconnectBackoffSeconds = [1, 2, 5, 10, 30];

  /// Default bind address for local port forwarding.
  static const String defaultLocalBindAddress = '127.0.0.1';

  /// Default threshold in seconds for long-running command notification.
  static const int defaultCommandNotifyThreshold = 30;

  // --- Sync ---

  /// Maximum number of vault entries per sync batch.
  static const int syncBatchSize = 50;

  /// Minimum interval between sync attempts in seconds.
  static const int syncMinIntervalSeconds = 30;
}
