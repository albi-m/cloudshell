/// GoRouter configuration for CloudShell navigation.
///
/// Defines all application routes, redirects, and shell routes
/// for the adaptive scaffold (sidebar on desktop, bottom nav on mobile).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/route_names.dart';
import '../ui/hosts/hosts_screen.dart';
import '../ui/keys/keys_screen.dart';
import '../ui/settings/settings_screen.dart';
import '../ui/shared/adaptive_scaffold.dart';
import '../ui/snippets/snippets_screen.dart';

/// Global navigator key for GoRouter.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Shell navigator key for the adaptive scaffold.
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Riverpod provider for the GoRouter instance.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.hosts,
    routes: [
      // Shell route wraps all main screens in the adaptive scaffold
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AdaptiveScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: RouteNames.hosts,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HostsScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.keys,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: KeysScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.snippets,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SnippetsScreen(),
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
