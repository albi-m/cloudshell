/// CloudShell — Cross-platform SSH client with E2E encrypted sync.
///
/// Application entry point. Initializes platform bindings,
/// logging, and the Riverpod provider scope before launching
/// the app widget tree.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'services/backend/supabase/supabase_config.dart';

/// Application entry point that bootstraps all platform services.
///
/// Initialization sequence:
/// 1. Ensures Flutter bindings are ready for async platform calls.
/// 2. Initializes the Supabase client (no-op when `--dart-define` vars are absent).
/// 3. Wraps the widget tree in a [ProviderScope] for Riverpod dependency injection.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase (no-op if --dart-define not set)
  await SupabaseConfig.initialize();

  runApp(
    const ProviderScope(
      child: CloudShellApp(),
    ),
  );
}
