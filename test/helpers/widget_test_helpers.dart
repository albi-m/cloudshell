// Helper utilities for widget tests.
//
// Provides a common test scaffold that wraps widgets in
// ProviderScope + MaterialApp with localization support.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloudshell/l10n/app_localizations.dart';

/// Wraps a [child] widget in a ProviderScope and MaterialApp
/// configured with localization delegates and English locale.
///
/// Pass [overrides] to inject test doubles for providers.
Widget buildTestApp({
  required Widget child,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: child,
    ),
  );
}
