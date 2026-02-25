/// Supabase implementation of the AuthBackend interface.
///
/// Uses supabase_flutter for email/password authentication,
/// session management, and password reset.
library;

import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth_backend.dart';

/// Supabase-backed authentication.
///
/// Delegates all auth operations to the Supabase Auth service.
/// Session tokens and refresh are handled automatically by the SDK.
class SupabaseAuthBackend implements AuthBackend {
  SupabaseAuthBackend(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  @override
  Future<AuthResult> signUp(String email, String password) async {
    try {
      final response = await _auth.signUp(
        email: email.toLowerCase().trim(),
        password: password,
      );

      if (response.user == null) {
        return const AuthResult.failure('Sign up failed. Please try again.');
      }

      return AuthResult.success(
        userId: response.user!.id,
        email: response.user!.email,
      );
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('Sign up failed: $e');
    }
  }

  @override
  Future<AuthResult> signIn(String email, String password) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );

      if (response.user == null) {
        return const AuthResult.failure('Sign in failed. Please try again.');
      }

      // Check if user has verified TOTP factors requiring MFA
      final factors = await _auth.mfa.listFactors();
      final verifiedTotp = factors.totp
          .where((f) => f.status == FactorStatus.verified)
          .toList();

      if (verifiedTotp.isNotEmpty) {
        // MFA required — return factor ID so UI can challenge
        return AuthResult.needs2fa(
          tempToken: response.session?.accessToken,
          factorId: verifiedTotp.first.id,
        );
      }

      return AuthResult.success(
        userId: response.user!.id,
        email: response.user!.email,
      );
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('Sign in failed: $e');
    }
  }

  @override
  Future<AuthResult> verifyMfa(
      String factorId, String challengeId, String code) async {
    try {
      await _auth.mfa.verify(
        factorId: factorId,
        challengeId: challengeId,
        code: code,
      );

      final user = _auth.currentUser;
      return AuthResult.success(
        userId: user?.id,
        email: user?.email,
      );
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('Verification failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<AuthResult> resetPassword(String email) async {
    try {
      await _auth.resetPasswordForEmail(email.toLowerCase().trim());
      return const AuthResult.success();
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('Password reset failed: $e');
    }
  }

  @override
  Future<AuthResult> deleteAccount() async {
    try {
      // Account deletion requires a server-side function.
      // Call an RPC function that deletes the user (needs service role).
      await _client.rpc('delete_user');
      await _auth.signOut();
      return const AuthResult.success();
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e));
    } catch (e) {
      return AuthResult.failure('Account deletion failed: $e');
    }
  }

  @override
  String? get currentUserId => _auth.currentUser?.id;

  @override
  String? get currentUserEmail => _auth.currentUser?.email;

  @override
  bool get isSignedIn => _auth.currentSession != null;

  @override
  Stream<BackendAuthState> get authStateChanges {
    return _auth.onAuthStateChange.map((data) {
      return switch (data.event) {
        AuthChangeEvent.signedIn => BackendAuthState.signedIn,
        AuthChangeEvent.signedOut => BackendAuthState.signedOut,
        AuthChangeEvent.tokenRefreshed => BackendAuthState.tokenRefreshed,
        AuthChangeEvent.passwordRecovery => BackendAuthState.passwordRecovery,
        _ => BackendAuthState.signedOut,
      };
    });
  }

  /// Maps Supabase auth errors to user-friendly messages.
  String _mapAuthError(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('invalid login credentials') ||
        message.contains('invalid email or password')) {
      return 'Invalid email or password';
    }
    if (message.contains('email already registered') ||
        message.contains('user already registered')) {
      return 'An account with this email already exists';
    }
    if (message.contains('email not confirmed')) {
      return 'Please check your email and confirm your account';
    }
    if (message.contains('password')) {
      return 'Password must be at least 6 characters';
    }
    if (message.contains('rate limit') || message.contains('too many')) {
      return 'Too many attempts. Please wait and try again.';
    }

    return e.message;
  }
}
