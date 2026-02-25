/// CloudShell application root widget.
///
/// Configures MaterialApp with theming, routing, and
/// global providers. Includes app-level biometric lock
/// with lifecycle-aware auto-lock on background.
/// Restores the last active workspace on startup.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_lock_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/workspace_provider.dart';
import 'router/app_router.dart';
import 'ui/shared/app_lock_screen.dart';

/// Root widget that configures the MaterialApp with theme,
/// router, and biometric lock overlay.
class CloudShellApp extends ConsumerStatefulWidget {
  const CloudShellApp({super.key});

  @override
  ConsumerState<CloudShellApp> createState() => _CloudShellAppState();
}

class _CloudShellAppState extends ConsumerState<CloudShellApp>
    with WidgetsBindingObserver {
  bool _workspaceRestored = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restoreWorkspace();
  }

  Future<void> _restoreWorkspace() async {
    if (_workspaceRestored) return;
    _workspaceRestored = true;
    // Restore after the first frame to ensure providers are ready
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ref.read(workspaceProvider.notifier).restoreWorkspace();
      } catch (e) {
        debugPrint('Workspace restore failed: $e');
        // Workspace restore is best-effort
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final notifier = ref.read(appLockProvider.notifier);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      // App went to background — schedule lock after grace period
      final gracePeriodSeconds = ref.read(appLockGracePeriodProvider);
      notifier.scheduleLock(Duration(seconds: gracePeriodSeconds));
    } else if (state == AppLifecycleState.resumed) {
      // App returned to foreground — cancel pending lock
      notifier.cancelScheduledLock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final lockState = ref.watch(appLockProvider);
    final isLocked = lockState != AppLockState.unlocked;

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration from design system
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Localization
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,

      // GoRouter configuration
      routerConfig: router,

      // Lock screen overlay
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            if (isLocked) const AppLockScreen(),
          ],
        );
      },
    );
  }
}
