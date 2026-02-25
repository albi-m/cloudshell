/// Named route constants for GoRouter navigation.
///
/// All route paths are defined here to prevent typos and
/// enable compile-time checking of route references.
library;

/// Centralized route path definitions for the application.
///
/// Usage with GoRouter:
/// ```dart
/// context.go(RouteNames.hosts);
/// context.push(RouteNames.hostDetail(hostId));
/// ```
abstract final class RouteNames {
  // --- Root Routes ---

  /// Splash / loading screen shown on cold start.
  static const String splash = '/';

  /// Vault unlock screen (master password / biometric).
  static const String vaultUnlock = '/unlock';

  // --- Onboarding ---

  /// Welcome screen shown on first launch.
  static const String welcome = '/welcome';

  /// Onboarding slides.
  static const String onboarding = '/onboarding';

  /// Auth choice (login / signup / skip).
  static const String authChoice = '/auth-choice';

  /// Sign up screen.
  static const String signUp = '/sign-up';

  /// Login screen.
  static const String login = '/login';

  /// Forgot password screen.
  static const String forgotPassword = '/forgot-password';

  /// TOTP 2FA setup screen.
  static const String totpSetup = '/totp-setup';

  /// TOTP 2FA verification screen (during login).
  static const String totpVerify = '/totp-verify';

  /// Master password setup screen.
  static const String masterPasswordSetup = '/master-password-setup';

  // --- Main Navigation ---

  /// Hosts list screen (default home).
  static const String hosts = '/hosts';

  /// Host detail screen.
  static String hostDetail(String id) => '/hosts/$id';

  /// Add/edit host form.
  static const String hostForm = '/hosts/form';

  /// Edit existing host form.
  static String hostEdit(String id) => '/hosts/$id/edit';

  /// Quick connect dialog route.
  static const String quickConnect = '/quick-connect';

  // --- Terminal ---

  /// Terminal workspace view (shows active sessions).
  static const String terminalRoute = '/terminal';

  /// Active terminal session (deep link).
  static String terminal(String sessionId) => '/terminal/$sessionId';

  // --- Keys ---

  /// SSH keys list screen.
  static const String keys = '/keys';

  /// Key detail screen.
  static String keyDetail(String id) => '/keys/$id';

  // --- SFTP ---

  /// SFTP file browser.
  static String sftpBrowser(String hostId) => '/sftp/$hostId';

  // --- Snippets ---

  /// Snippets list screen.
  static const String snippets = '/snippets';

  /// Snippet form (add/edit).
  static const String snippetForm = '/snippets/form';

  /// Edit existing snippet.
  static String snippetEdit(String id) => '/snippets/$id/edit';

  // --- Port Forwarding ---

  /// Port forwarding rules list.
  static const String portForwarding = '/port-forwarding';

  /// Port forwarding form.
  static const String portForwardForm = '/port-forwarding/form';

  // --- Settings ---

  /// Settings screen.
  static const String settings = '/settings';

  /// Appearance settings.
  static const String appearanceSettings = '/settings/appearance';

  /// Terminal settings.
  static const String terminalSettings = '/settings/terminal';

  /// Security settings.
  static const String securitySettings = '/settings/security';

  /// Sync settings.
  static const String syncSettings = '/settings/sync';

  /// About screen.
  static const String about = '/settings/about';
}
