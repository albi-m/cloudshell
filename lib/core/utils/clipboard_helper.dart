/// Secure clipboard helper for CloudShell.
///
/// Copies sensitive data to the clipboard and automatically
/// clears it after a configurable timeout to prevent
/// clipboard snooping by other applications.
library;

import 'dart:async';

import 'package:flutter/services.dart';

import '../constants/app_constants.dart';

/// Copies text to the clipboard with automatic clearing.
///
/// After [timeoutSeconds] (default: [AppConstants.defaultClipboardTimeout]),
/// the clipboard is cleared by writing an empty string.
/// Returns immediately after copying; the clear happens in the background.
void copyWithAutoClear(
  String text, {
  int timeoutSeconds = AppConstants.defaultClipboardTimeout,
}) {
  Clipboard.setData(ClipboardData(text: text));

  // Schedule clipboard clear after timeout
  Timer(Duration(seconds: timeoutSeconds), () {
    Clipboard.setData(const ClipboardData(text: ''));
  });
}
