/// Riverpod providers for backend service selection.
///
/// This is the single point of configuration for swapping between
/// backend implementations. Change these providers to migrate from
/// Supabase to a custom REST API.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/backend/auth_backend.dart';
import '../services/backend/supabase/supabase_auth_backend.dart';
import '../services/backend/supabase/supabase_config.dart';
import '../services/backend/supabase/supabase_sync_backend.dart';
import '../services/backend/sync_backend.dart';

/// Provides the auth backend implementation.
///
/// Returns null when Supabase is not configured (local-only mode).
/// To swap to a custom API, return a different AuthBackend here.
final authBackendProvider = Provider<AuthBackend?>((ref) {
  final client = SupabaseConfig.client;
  if (client == null) return null;
  return SupabaseAuthBackend(client);
});

/// Provides the sync backend implementation.
///
/// Returns null when Supabase is not configured (local-only mode).
/// To swap to a custom API, return a different SyncBackend here.
final syncBackendProvider = Provider<SyncBackend?>((ref) {
  final client = SupabaseConfig.client;
  if (client == null) return null;
  return SupabaseSyncBackend(client);
});

/// Whether a backend is configured and available.
final backendAvailableProvider = Provider<bool>((ref) {
  return SupabaseConfig.isConfigured;
});

/// Provides the raw Supabase client (for services that need it directly).
///
/// Returns null when Supabase is not configured.
final supabaseClientProvider = Provider((ref) {
  return SupabaseConfig.client;
});
