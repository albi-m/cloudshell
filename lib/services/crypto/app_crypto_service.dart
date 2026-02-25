/// AES-256-GCM encryption service for local secret storage.
///
/// Encrypts and decrypts secret values stored in the Drift
/// database. Uses a machine-derived key so secrets are tied
/// to this device — no keychain, no password prompts.
library;

import 'dart:convert';
import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Service for AES-256-GCM encrypt/decrypt of secret values.
///
/// The encryption key is derived from the machine's hardware UUID
/// combined with a fixed app-specific salt via PBKDF2. This means:
/// - Secrets are device-bound (can't be copied to another Mac)
/// - No keychain involvement, no password prompts
/// - Security relies on macOS file permissions + full-disk encryption
class AppCryptoService {
  static final _log = Logger();

  SecretKey? _cachedKey;

  /// Encrypts a plaintext value. Returns base64(ciphertext+mac) and base64(nonce).
  Future<({String ciphertext, String nonce})> encrypt(String plaintext) async {
    final key = await _getOrDeriveKey();
    final algorithm = AesGcm.with256bits();
    final secretBox = await algorithm.encryptString(
      plaintext,
      secretKey: key,
    );
    return (
      ciphertext: base64Encode(secretBox.concatenation(nonce: false, mac: true)),
      nonce: base64Encode(secretBox.nonce),
    );
  }

  /// Decrypts a ciphertext+mac blob using the provided nonce.
  Future<String> decrypt(String ciphertextBase64, String nonceBase64) async {
    final key = await _getOrDeriveKey();
    final algorithm = AesGcm.with256bits();
    final ciphertextAndMac = base64Decode(ciphertextBase64);
    final nonce = base64Decode(nonceBase64);

    // Last 16 bytes are the GCM MAC tag
    final macLength = 16;
    final ciphertext = ciphertextAndMac.sublist(0, ciphertextAndMac.length - macLength);
    final mac = Mac(ciphertextAndMac.sublist(ciphertextAndMac.length - macLength));

    final secretBox = SecretBox(
      ciphertext,
      nonce: nonce,
      mac: mac,
    );
    final cleartext = await algorithm.decrypt(secretBox, secretKey: key);
    return utf8.decode(cleartext);
  }

  /// Derives (or returns cached) the AES-256 key from machine identity.
  Future<SecretKey> _getOrDeriveKey() async {
    if (_cachedKey != null) return _cachedKey!;

    final machineId = await _getMachineId();
    // Fixed app-specific salt — not secret, just prevents rainbow tables
    const salt = 'CloudShell_LocalSecrets_v1';
    final saltBytes = utf8.encode(salt);

    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );

    _cachedKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(machineId)),
      nonce: saltBytes,
    );
    return _cachedKey!;
  }

  /// Gets a stable machine identifier.
  ///
  /// On macOS: hardware UUID via `sysctl kern.uuid`
  /// On other platforms: falls back to a fixed per-app string
  /// (will be improved when targeting other platforms).
  Future<String> _getMachineId() async {
    if (Platform.isMacOS) {
      try {
        final result = await Process.run(
          'ioreg',
          ['-rd1', '-c', 'IOPlatformExpertDevice'],
        );
        final output = result.stdout as String;
        // Extract IOPlatformUUID from ioreg output
        final regex = RegExp(r'"IOPlatformUUID"\s*=\s*"([^"]+)"');
        final match = regex.firstMatch(output);
        if (match != null) return match.group(1)!;
      } catch (e, stackTrace) {
        // Fall through to fallback
        _log.d('macOS machine ID lookup failed', error: e, stackTrace: stackTrace);
      }
    }
    if (Platform.isLinux) {
      try {
        final result = await Process.run('cat', ['/etc/machine-id']);
        final id = (result.stdout as String).trim();
        if (id.isNotEmpty) return id;
      } catch (e, stackTrace) {
        // Fall through to fallback
        _log.d('Linux machine ID lookup failed', error: e, stackTrace: stackTrace);
      }
    }
    if (Platform.isWindows) {
      try {
        final result = await Process.run('wmic', ['csproduct', 'get', 'UUID']);
        final lines = (result.stdout as String).split('\n');
        if (lines.length > 1) {
          final id = lines[1].trim();
          if (id.isNotEmpty) return id;
        }
      } catch (e, stackTrace) {
        // Fall through to fallback
        _log.d('Windows machine ID lookup failed', error: e, stackTrace: stackTrace);
      }
    }
    // Fallback — not ideal but stable per-install
    return 'CloudShell_FallbackDeviceId_${Platform.localHostname}';
  }
}

/// Riverpod provider for the crypto service singleton.
final appCryptoServiceProvider = Provider<AppCryptoService>((ref) {
  return AppCryptoService();
});
