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

  /// Desktop sidebar width in logical pixels.
  static const double sidebarWidth = 260.0;

  /// Breakpoint width at which the layout switches from mobile to desktop.
  static const double desktopBreakpoint = 768.0;

  /// Breakpoint width for wide desktop layouts.
  static const double wideDesktopBreakpoint = 1200.0;

  /// Minimum touch target size per Apple HIG (44x44 points).
  static const double minTouchTarget = 44.0;

  /// Standard animation duration for UI transitions.
  static const Duration animationDuration = Duration(milliseconds: 200);

  /// Slow animation duration for page transitions.
  static const Duration slowAnimationDuration = Duration(milliseconds: 350);

  // --- Sync ---

  /// Maximum number of vault entries per sync batch.
  static const int syncBatchSize = 50;

  /// Minimum interval between sync attempts in seconds.
  static const int syncMinIntervalSeconds = 30;
}
