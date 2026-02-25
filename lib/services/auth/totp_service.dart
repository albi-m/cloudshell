/// TOTP two-factor authentication service.
///
/// Wraps Supabase MFA API for TOTP enrollment, verification,
/// and management. Used by the auth flow and settings screen.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../providers/backend_provider.dart';

/// Result of a TOTP enrollment request.
class TotpEnrollmentResult {
  const TotpEnrollmentResult({
    required this.factorId,
    required this.totpUri,
    required this.secret,
    this.qrSvg,
  });

  /// Factor ID assigned by Supabase (needed for verification).
  final String factorId;

  /// otpauth:// URI for QR code generation.
  final String totpUri;

  /// Raw TOTP secret (for manual entry).
  final String secret;

  /// Optional SVG image of the QR code from Supabase.
  final String? qrSvg;
}

/// Result of a TOTP challenge (for login verification).
class TotpChallengeResult {
  const TotpChallengeResult({
    required this.challengeId,
    required this.factorId,
  });

  final String challengeId;
  final String factorId;
}

/// Service for TOTP two-factor authentication operations.
///
/// All operations go through Supabase's built-in MFA API.
class TotpService {
  TotpService(this._client);

  final SupabaseClient? _client;

  GoTrueMFAApi? get _mfa => _client?.auth.mfa;

  /// Whether the TOTP service is available (Supabase configured).
  bool get isAvailable => _client != null;

  /// Enrolls a new TOTP factor.
  ///
  /// Returns the factor ID, TOTP URI (for QR code), and secret.
  /// The factor is NOT active until verified with [verifyEnrollment].
  Future<TotpEnrollmentResult> enroll({String? friendlyName}) async {
    final mfa = _mfa;
    if (mfa == null) throw StateError('Supabase not configured');

    final response = await mfa.enroll(
      factorType: FactorType.totp,
      friendlyName: friendlyName ?? 'CloudShell',
    );

    final totp = response.totp;
    if (totp == null) throw StateError('TOTP enrollment returned no data');

    return TotpEnrollmentResult(
      factorId: response.id,
      totpUri: totp.uri,
      secret: totp.secret,
      qrSvg: totp.qrCode,
    );
  }

  /// Verifies initial TOTP enrollment with a 6-digit code.
  ///
  /// After this succeeds the TOTP factor is active and required
  /// on future logins.
  Future<void> verifyEnrollment(String factorId, String code) async {
    final mfa = _mfa;
    if (mfa == null) throw StateError('Supabase not configured');

    final challenge = await mfa.challenge(factorId: factorId);
    await mfa.verify(
      factorId: factorId,
      challengeId: challenge.id,
      code: code,
    );
  }

  /// Creates a challenge for an enrolled TOTP factor (used during login).
  Future<TotpChallengeResult> createChallenge(String factorId) async {
    final mfa = _mfa;
    if (mfa == null) throw StateError('Supabase not configured');

    final challenge = await mfa.challenge(factorId: factorId);
    return TotpChallengeResult(
      challengeId: challenge.id,
      factorId: factorId,
    );
  }

  /// Verifies a TOTP code during login.
  Future<void> verifyChallenge({
    required String factorId,
    required String challengeId,
    required String code,
  }) async {
    final mfa = _mfa;
    if (mfa == null) throw StateError('Supabase not configured');

    await mfa.verify(
      factorId: factorId,
      challengeId: challengeId,
      code: code,
    );
  }

  /// Removes (unenrolls) a TOTP factor, disabling 2FA.
  Future<void> unenroll(String factorId) async {
    final mfa = _mfa;
    if (mfa == null) throw StateError('Supabase not configured');

    await mfa.unenroll(factorId);
  }

  /// Lists all enrolled MFA factors for the current user.
  Future<List<Factor>> listFactors() async {
    final mfa = _mfa;
    if (mfa == null) return [];

    final response = await mfa.listFactors();
    return response.all;
  }

  /// Returns the verified TOTP factor, or null if none enrolled.
  Future<Factor?> getVerifiedTotpFactor() async {
    final factors = await listFactors();
    for (final f in factors) {
      if (f.factorType == FactorType.totp &&
          f.status == FactorStatus.verified) {
        return f;
      }
    }
    return null;
  }

  /// Whether the current user has an active TOTP factor.
  Future<bool> isTotpEnabled() async {
    final factor = await getVerifiedTotpFactor();
    return factor != null;
  }
}

/// Riverpod provider for the TOTP service.
final totpServiceProvider = Provider<TotpService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TotpService(client);
});

/// Whether TOTP 2FA is currently enabled for the user.
final totpEnabledProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(totpServiceProvider);
  if (!service.isAvailable) return false;
  return service.isTotpEnabled();
});
