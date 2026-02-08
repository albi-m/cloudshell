/// Platform detection utilities for CloudShell.
///
/// Provides runtime platform checks for conditional behavior
/// like biometric availability, secure storage backends,
/// and UI layout decisions.
library;

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Runtime platform detection for cross-platform behavior.
///
/// Usage:
/// ```dart
/// if (PlatformUtils.isDesktop) {
///   // Show sidebar navigation
/// } else {
///   // Show bottom tab bar
/// }
/// ```
abstract final class PlatformUtils {
  /// Whether the app is running on iOS.
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Whether the app is running on Android.
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Whether the app is running on macOS.
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Whether the app is running on Windows.
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Whether the app is running on Linux.
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Whether the app is running on a mobile platform (iOS or Android).
  static bool get isMobile => isIOS || isAndroid;

  /// Whether the app is running on a desktop platform.
  static bool get isDesktop => isMacOS || isWindows || isLinux;

  /// Whether the platform supports biometric authentication.
  ///
  /// iOS uses Face ID / Touch ID, Android uses BiometricPrompt,
  /// macOS uses Touch ID. Windows and Linux do not have
  /// standardized biometric APIs.
  static bool get supportsBiometrics => isIOS || isAndroid || isMacOS;

  /// The name of the platform secure storage backend.
  ///
  /// Used in UI to inform users where their keys are stored.
  static String get secureStorageBackend {
    if (isIOS || isMacOS) return 'Keychain';
    if (isAndroid) return 'Android Keystore';
    if (isWindows) return 'Windows DPAPI';
    if (isLinux) return 'libsecret';
    return 'Secure Storage';
  }

  /// The current platform name for display purposes.
  static String get platformName {
    if (isIOS) return 'iOS';
    if (isAndroid) return 'Android';
    if (isMacOS) return 'macOS';
    if (isWindows) return 'Windows';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }
}
