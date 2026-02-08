/// CloudShell — Cross-platform SSH client with E2E encrypted sync.
///
/// Application entry point. Initializes platform bindings,
/// logging, and the Riverpod provider scope before launching
/// the app widget tree.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

/// Application entry point.
///
/// Ensures Flutter bindings are initialized, sets up error
/// handling, and launches the app wrapped in a ProviderScope
/// for Riverpod state management.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: CloudShellApp(),
    ),
  );
}
