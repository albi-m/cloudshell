/// Supabase client configuration and initialization.
///
/// Reads project URL and anon key from compile-time environment
/// variables (--dart-define). When not configured, the app runs
/// in local-only mode with no backend calls.
library;

import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase configuration and initialization.
///
/// Usage:
/// ```sh
/// flutter run \
///   --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=eyJ...
/// ```
class SupabaseConfig {
  SupabaseConfig._();

  /// Project URL from --dart-define.
  static const _url = String.fromEnvironment('SUPABASE_URL');

  /// Anonymous key from --dart-define.
  static const _anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Deep link redirect URL for auth emails (confirmation, password reset).
  static const redirectUrl = 'cloudshell://auth-callback';

  /// Whether Supabase credentials are configured.
  static bool get isConfigured => _url.isNotEmpty && _anonKey.isNotEmpty;

  /// The Supabase client instance. Null if not configured.
  static SupabaseClient? get client =>
      isConfigured ? Supabase.instance.client : null;

  /// Initializes the Supabase client.
  ///
  /// Call this in main() before runApp(). No-op if credentials
  /// are not provided (local-only mode).
  static Future<void> initialize() async {
    if (!isConfigured) return;
    await Supabase.initialize(url: _url, anonKey: _anonKey);
  }
}
