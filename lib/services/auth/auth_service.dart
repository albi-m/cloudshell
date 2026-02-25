/// Authentication service for CloudShell sync accounts.
///
/// Thin wrapper around the AuthBackend interface. Delegates all
/// operations to the configured backend (Supabase by default).
/// When no backend is configured, all operations return failure
/// with a "not configured" message.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/backend_provider.dart';
import '../backend/auth_backend.dart';

// Re-export AuthResult so consumers can import from one place.
export '../backend/auth_backend.dart' show AuthResult;

/// Manages user authentication via the configured backend.
///
/// This service is backend-agnostic. It delegates to whatever
/// AuthBackend is configured in the backend provider. When no
/// backend is available (local-only mode), all operations fail
/// gracefully.
class AuthService {
  AuthService({required this.backend});

  /// The auth backend implementation (null in local-only mode).
  final AuthBackend? backend;

  /// Creates a new account.
  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    if (backend == null) {
      return const AuthResult.failure('Backend not configured');
    }

    final normalizedEmail = email.toLowerCase().trim();
    if (!_isValidEmail(normalizedEmail)) {
      return const AuthResult.failure('Invalid email address');
    }

    return backend!.signUp(normalizedEmail, password);
  }

  /// Signs in with email and password.
  Future<AuthResult> logIn({
    required String email,
    required String password,
  }) async {
    if (backend == null) {
      return const AuthResult.failure('Backend not configured');
    }

    final normalizedEmail = email.toLowerCase().trim();
    if (!_isValidEmail(normalizedEmail)) {
      return const AuthResult.failure('Invalid email address');
    }

    return backend!.signIn(normalizedEmail, password);
  }

  /// Signs out and clears the session.
  Future<void> logOut() async {
    await backend?.signOut();
  }

  /// Requests a password reset email.
  Future<AuthResult> resetPassword(String email) async {
    if (backend == null) {
      return const AuthResult.failure('Backend not configured');
    }

    final normalizedEmail = email.toLowerCase().trim();
    if (!_isValidEmail(normalizedEmail)) {
      return const AuthResult.failure('Invalid email address');
    }

    return backend!.resetPassword(normalizedEmail);
  }

  /// Deletes the user's account.
  Future<AuthResult> deleteAccount() async {
    if (backend == null) {
      return const AuthResult.failure('Backend not configured');
    }
    return backend!.deleteAccount();
  }

  /// Validates an email address format.
  bool _isValidEmail(String email) {
    final regex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );
    return regex.hasMatch(email);
  }
}

/// Riverpod provider for the auth service.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(backend: ref.watch(authBackendProvider));
});
