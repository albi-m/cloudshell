/// Abstract authentication backend interface.
///
/// Defines the contract for auth operations. Supabase is the initial
/// implementation; swap to a custom REST API by implementing this
/// interface and changing the provider.
library;

/// Authentication state reported by the backend.
enum BackendAuthState {
  /// No active session.
  signedOut,

  /// User is signed in with a valid session.
  signedIn,

  /// Session token was refreshed.
  tokenRefreshed,

  /// Password recovery flow initiated.
  passwordRecovery,
}

/// Result of an authentication operation.
class AuthResult {
  const AuthResult({
    required this.success,
    this.error,
    this.userId,
    this.email,
    this.requires2fa = false,
    this.tempToken,
    this.factorId,
  });

  final bool success;
  final String? error;
  final String? userId;
  final String? email;
  final bool requires2fa;
  final String? tempToken;

  /// MFA factor ID (set when [requires2fa] is true).
  final String? factorId;

  const AuthResult.success({this.userId, this.email})
      : success = true,
        error = null,
        requires2fa = false,
        tempToken = null,
        factorId = null;

  const AuthResult.failure(String message)
      : success = false,
        error = message,
        userId = null,
        email = null,
        requires2fa = false,
        tempToken = null,
        factorId = null;

  const AuthResult.needs2fa({required this.tempToken, this.factorId})
      : success = false,
        error = null,
        userId = null,
        email = null,
        requires2fa = true;
}

/// Abstract auth backend — Supabase today, custom API tomorrow.
///
/// All auth operations go through this interface. The app never
/// talks to Supabase directly; it talks to this abstraction.
abstract class AuthBackend {
  /// Creates a new account.
  Future<AuthResult> signUp(String email, String password);

  /// Signs in with email + password.
  Future<AuthResult> signIn(String email, String password);

  /// Signs out, clearing the session.
  Future<void> signOut();

  /// Requests a password reset email.
  Future<AuthResult> resetPassword(String email);

  /// Deletes the user's account and all associated data.
  Future<AuthResult> deleteAccount();

  /// Current authenticated user's ID (null if signed out).
  String? get currentUserId;

  /// Current authenticated user's email (null if signed out).
  String? get currentUserEmail;

  /// Whether there is an active session.
  bool get isSignedIn;

  /// Reactive stream of auth state changes.
  Stream<BackendAuthState> get authStateChanges;

  /// Verifies a TOTP code during MFA-protected login.
  ///
  /// Called after [signIn] returns [AuthResult.needs2fa].
  /// [factorId] and [challengeId] come from the MFA challenge flow.
  Future<AuthResult> verifyMfa(
      String factorId, String challengeId, String code);
}
