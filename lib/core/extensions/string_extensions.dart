/// String utility extensions for CloudShell.
///
/// Provides common string operations used throughout
/// the application for validation and formatting.
library;

/// Utility extensions on [String] for validation and transformation.
extension StringExtensions on String {
  /// Whether this string is a valid IPv4 address.
  bool get isValidIpv4 {
    final parts = split('.');
    if (parts.length != 4) return false;
    return parts.every((part) {
      final n = int.tryParse(part);
      return n != null && n >= 0 && n <= 255;
    });
  }

  /// Whether this string is a valid IPv6 address (basic check).
  bool get isValidIpv6 => RegExp(r'^([0-9a-fA-F]{0,4}:){2,7}[0-9a-fA-F]{0,4}$').hasMatch(this);

  /// Whether this string is a valid hostname (RFC 1123).
  bool get isValidHostname {
    if (isEmpty || length > 253) return false;
    return RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$')
        .hasMatch(this);
  }

  /// Whether this string is a valid SSH host (IP or hostname).
  bool get isValidSshHost => isValidIpv4 || isValidIpv6 || isValidHostname;

  /// Whether this string is a valid port number (1-65535).
  bool get isValidPort {
    final n = int.tryParse(this);
    return n != null && n >= 1 && n <= 65535;
  }

  /// Truncates the string to [maxLength] with an ellipsis suffix.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 1)}\u2026';
  }

  /// Masks all but the last [visibleChars] characters with asterisks.
  String mask({int visibleChars = 4}) {
    if (length <= visibleChars) return this;
    return '${'*' * (length - visibleChars)}${substring(length - visibleChars)}';
  }
}

/// Utility extensions on nullable [String].
extension NullableStringExtensions on String? {
  /// Whether this string is null or empty after trimming whitespace.
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// Returns this string if not null or blank, otherwise [fallback].
  String orDefault([String fallback = '']) => isNullOrBlank ? fallback : this!;
}
