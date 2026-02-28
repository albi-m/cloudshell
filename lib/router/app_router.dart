/// GoRouter configuration for CloudShell navigation.
///
/// Defines all application routes, redirects, and shell routes
/// for the adaptive scaffold (sidebar on desktop, bottom nav on mobile).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/route_names.dart';
import '../data/database/app_database.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/vault_provider.dart';
import '../ui/auth/forgot_password_screen.dart';
import '../ui/auth/reset_password_screen.dart';
import '../ui/auth/login_screen.dart';
import '../ui/auth/sign_up_screen.dart';
import '../ui/auth/totp_setup_screen.dart';
import '../ui/auth/totp_verify_screen.dart';
import '../ui/hosts/host_detail_screen.dart';
import '../ui/hosts/host_form_screen.dart';
import '../ui/hosts/hosts_screen.dart';
import '../ui/keys/key_detail_screen.dart';
import '../ui/keys/keys_screen.dart';
import '../ui/onboarding/onboarding_screen.dart';
import '../ui/port_forwarding/port_forwarding_screen.dart';
import '../ui/settings/settings_screen.dart';
import '../ui/shared/adaptive_scaffold.dart';
import '../ui/snippets/snippet_detail_screen.dart';
import '../ui/snippets/snippet_form_screen.dart';
import '../ui/snippets/snippets_screen.dart';
import '../ui/vault/master_password_setup_screen.dart';
import '../ui/vault/vault_unlock_screen.dart';

/// Global navigator key for GoRouter.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Shell navigator key for the adaptive scaffold.
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Notifier that triggers GoRouter redirect re-evaluation.
///
/// Attached to GoRouter's [refreshListenable] so that calling [notify]
/// forces all redirect guards to run again (e.g., after vault state changes).
class _RouterRefreshNotifier extends ChangeNotifier {
  /// Fires a change notification, causing GoRouter to re-run its redirect logic.
  void notify() => notifyListeners();
}

/// Riverpod provider for the application's GoRouter instance.
///
/// Created once and never rebuilt. Route guards handle onboarding,
/// authentication, and vault-lock redirects. The router re-evaluates
/// its redirect function when vault state changes via [_RouterRefreshNotifier].
final appRouterProvider = Provider<GoRouter>((ref) {
  // Refresh router when vault or auth state changes
  final refreshNotifier = _RouterRefreshNotifier();
  ref.listen(vaultProvider, (_, _) => refreshNotifier.notify());
  ref.listen(authProvider, (_, _) => refreshNotifier.notify());

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.hosts,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final onboardingComplete = ref.read(onboardingCompleteProvider);
      final isOnboarding = state.uri.path == RouteNames.onboarding;

      // Not done onboarding → force onboarding screen
      if (!onboardingComplete && !isOnboarding) {
        return RouteNames.onboarding;
      }
      // Done onboarding but still on onboarding route → go to hosts
      if (onboardingComplete && isOnboarding) {
        return RouteNames.hosts;
      }

      // Password recovery redirect — deep link opened the app
      final isPasswordRecovery =
          ref.read(authProvider).value == AuthState.passwordRecovery;
      final isResetRoute = state.uri.path == RouteNames.resetPassword;
      if (isPasswordRecovery && !isResetRoute) {
        return RouteNames.resetPassword;
      }

      // Auth routes are always accessible — no forced redirects
      final isAuthRoute = state.uri.path == RouteNames.login ||
          state.uri.path == RouteNames.signUp ||
          state.uri.path == RouteNames.forgotPassword ||
          state.uri.path == RouteNames.totpSetup ||
          state.uri.path == RouteNames.totpVerify ||
          isResetRoute;
      if (isAuthRoute) return null;

      // Vault lock redirect — only for local-only users who set up a vault.
      // Authenticated users never see vault screens — vault is auto-managed
      // by the login flow (_autoUnlockOrCreateVault) and cached key auto-unlock.
      final vaultState = ref.read(vaultProvider).value;
      final isAuthenticated =
          ref.read(authProvider).value == AuthState.authenticated;
      final isLocalOnly =
          ref.read(authProvider).value == AuthState.localOnly;
      final isVaultRoute = state.uri.path == RouteNames.vaultUnlock ||
          state.uri.path == RouteNames.masterPasswordSetup;
      if (vaultState == VaultState.locked &&
          isLocalOnly &&
          !isVaultRoute) {
        return RouteNames.vaultUnlock;
      }
      // Vault unlocked or not needed — leave vault route
      if (vaultState != VaultState.locked && isVaultRoute) {
        return RouteNames.hosts;
      }
      // Authenticated or unauthenticated but stuck on vault route → go to hosts
      if ((isAuthenticated || !isLocalOnly) && isVaultRoute) {
        return RouteNames.hosts;
      }

      return null; // no redirect
    },
    routes: [
      // Onboarding (full-screen, outside shell)
      GoRoute(
        path: RouteNames.onboarding,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => const MaterialPage(
          child: OnboardingScreen(),
        ),
      ),

      // Vault unlock (full-screen, outside shell)
      GoRoute(
        path: RouteNames.vaultUnlock,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => const MaterialPage(
          child: VaultUnlockScreen(),
        ),
      ),

      // Master password setup (full-screen, outside shell)
      GoRoute(
        path: RouteNames.masterPasswordSetup,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => const MaterialPage(
          child: MasterPasswordSetupScreen(),
        ),
      ),

      // Login (full-screen, outside shell)
      GoRoute(
        path: RouteNames.login,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => const MaterialPage(
          child: LoginScreen(),
        ),
      ),

      // Sign up (full-screen, outside shell)
      GoRoute(
        path: RouteNames.signUp,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => const MaterialPage(
          child: SignUpScreen(),
        ),
      ),

      // Forgot password (full-screen, outside shell)
      GoRoute(
        path: RouteNames.forgotPassword,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => const MaterialPage(
          child: ForgotPasswordScreen(),
        ),
      ),

      // Reset password — shown after user clicks email reset link
      GoRoute(
        path: RouteNames.resetPassword,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => const MaterialPage(
          child: ResetPasswordScreen(),
        ),
      ),

      // TOTP 2FA setup (full-screen, outside shell)
      GoRoute(
        path: RouteNames.totpSetup,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => const MaterialPage(
          child: TotpSetupScreen(),
        ),
      ),

      // TOTP 2FA verification during login (full-screen, outside shell)
      GoRoute(
        path: RouteNames.totpVerify,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final factorId = state.uri.queryParameters['factorId'] ?? '';
          return MaterialPage(
            child: TotpVerifyScreen(factorId: factorId),
          );
        },
      ),

      // Shell route wraps all main screens in the adaptive scaffold.
      // Detail/form routes are inside the shell so the sidebar stays
      // visible (master-detail layout). Use context.push() to navigate
      // to detail/form routes — this pushes within the shell navigator,
      // keeping the sidebar and enabling the AppBar back button.
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AdaptiveScaffold(child: child);
        },
        routes: [
          // --- Hosts ---
          GoRoute(
            path: RouteNames.hosts,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HostsScreen(),
            ),
          ),
          // Host form (add/edit) — MUST be before /hosts/:id
          GoRoute(
            path: RouteNames.hostForm,
            pageBuilder: (context, state) {
              final host = state.extra as Host?;
              return MaterialPage(
                child: HostFormScreen(host: host),
              );
            },
          ),
          // Host detail
          GoRoute(
            path: '/hosts/:id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return MaterialPage(
                child: HostDetailScreen(hostId: id),
              );
            },
          ),

          // --- Keys ---
          GoRoute(
            path: RouteNames.keys,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: KeysScreen(),
            ),
          ),
          // Key detail
          GoRoute(
            path: '/keys/:id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return MaterialPage(
                child: KeyDetailScreen(keyId: id),
              );
            },
          ),

          // --- Snippets ---
          GoRoute(
            path: RouteNames.snippets,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SnippetsScreen(),
            ),
          ),
          // Snippet form (add/edit) — MUST be before /snippets/:id
          GoRoute(
            path: RouteNames.snippetForm,
            pageBuilder: (context, state) {
              final snippet = state.extra as Snippet?;
              return MaterialPage(
                child: SnippetFormScreen(snippet: snippet),
              );
            },
          ),
          // Snippet detail
          GoRoute(
            path: '/snippets/:id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return MaterialPage(
                child: SnippetDetailScreen(snippetId: id),
              );
            },
          ),

          // --- Other ---
          GoRoute(
            path: RouteNames.portForwarding,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PortForwardingScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});
