/// Form field validators for CloudShell.
///
/// All validators return null on success or an error message
/// string on failure, compatible with Flutter's TextFormField.
library;

import '../extensions/string_extensions.dart';

/// Centralized validation functions for form fields.
///
/// Each validator returns null if the value is valid,
/// or a user-friendly error message if invalid.
abstract final class Validators {
  /// Validates that a field is not empty.
  static String? required(String? value) {
    if (value.isNullOrBlank) return 'This field is required';
    return null;
  }

  /// Validates a hostname or IP address.
  static String? hostname(String? value) {
    if (value.isNullOrBlank) return 'Hostname is required';
    if (!value!.trim().isValidSshHost) {
      return 'Enter a valid hostname or IP address';
    }
    return null;
  }

  /// Validates a port number (1-65535).
  static String? port(String? value) {
    if (value.isNullOrBlank) return 'Port is required';
    final n = int.tryParse(value!.trim());
    if (n == null || n < 1 || n > 65535) {
      return 'Enter a valid port (1-65535)';
    }
    return null;
  }

  /// Validates a username (non-empty, no spaces or shell metacharacters).
  static String? username(String? value) {
    if (value.isNullOrBlank) return 'Username is required';
    final v = value!.trim();
    if (v.contains(' ')) return 'Username cannot contain spaces';
    if (v.contains(RegExp(r'[;&|`$(){}\\<>!#]'))) {
      return 'Username contains invalid characters';
    }
    if (v.length > 64) return 'Username must be 64 characters or less';
    return null;
  }

  /// Validates a host label/display name.
  static String? label(String? value) {
    if (value.isNullOrBlank) return 'Label is required';
    if (value!.trim().length > 64) return 'Label must be 64 characters or less';
    return null;
  }

  /// Validates a master password meets security requirements.
  ///
  /// Requirements:
  /// - At least 12 characters
  /// - Contains uppercase and lowercase letters
  /// - Contains at least one digit
  static String? masterPassword(String? value) {
    if (value.isNullOrBlank) return 'Password is required';
    final pw = value!;
    if (pw.length < 12) return 'Must be at least 12 characters';
    if (!pw.contains(RegExp(r'[A-Z]'))) return 'Must contain an uppercase letter';
    if (!pw.contains(RegExp(r'[a-z]'))) return 'Must contain a lowercase letter';
    if (!pw.contains(RegExp(r'[0-9]'))) return 'Must contain a number';
    return null;
  }

  /// Validates that confirmation matches the original password.
  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value.isNullOrBlank) return 'Please confirm your password';
      if (value != password) return 'Passwords do not match';
      return null;
    };
  }

  /// Validates a snippet name.
  static String? snippetName(String? value) {
    if (value.isNullOrBlank) return 'Snippet name is required';
    if (value!.trim().length > 100) {
      return 'Name must be 100 characters or less';
    }
    return null;
  }

  /// Validates a snippet command.
  static String? snippetCommand(String? value) {
    if (value.isNullOrBlank) return 'Command is required';
    return null;
  }

  /// Validates an SSH key label.
  static String? keyLabel(String? value) {
    if (value.isNullOrBlank) return 'Key label is required';
    if (value!.trim().length > 64) return 'Label must be 64 characters or less';
    return null;
  }

  /// Validates an email address.
  static String? email(String? value) {
    if (value.isNullOrBlank) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }
}
