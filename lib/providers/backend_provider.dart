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

/// Provides the auth backend implementation used for login, signup, and session management.
///
/// Returns null when Supabase is not configured (local-only mode).
/// Synchronous provider that reads eagerly on first access and never rebuilds.
final authBackendProvider = Provider<AuthBackend?>((ref) {
  final client = SupabaseConfig.client;
  if (client == null) return null;
  return SupabaseAuthBackend(client);
});

/// Provides the sync backend implementation used for cloud data synchronization.
///
/// Returns null when Supabase is not configured (local-only mode).
/// Synchronous provider that reads eagerly on first access and never rebuilds.
final syncBackendProvider = Provider<SyncBackend?>((ref) {
  final client = SupabaseConfig.client;
  if (client == null) return null;
  return SupabaseSyncBackend(client);
});

/// Whether a cloud backend is configured and available for sync and auth.
///
/// Returns `true` when Supabase environment variables are set. Never rebuilds.
final backendAvailableProvider = Provider<bool>((ref) {
  return SupabaseConfig.isConfigured;
});

/// Provides the raw Supabase client for services that need direct API access.
///
/// Returns null when Supabase is not configured. Never rebuilds.
final supabaseClientProvider = Provider((ref) {
  return SupabaseConfig.client;
});
