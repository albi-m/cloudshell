/// CloudShell application root widget.
///
/// Configures MaterialApp with theming, routing, and
/// global providers. This is the top-level widget tree entry
/// point, wrapped by ProviderScope in main.dart.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

/// Root widget that configures the MaterialApp with theme
/// and router from the design system.
class CloudShellApp extends ConsumerWidget {
  const CloudShellApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration from design system
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark, // Default to dark mode

      // GoRouter configuration
      routerConfig: router,
    );
  }
}
