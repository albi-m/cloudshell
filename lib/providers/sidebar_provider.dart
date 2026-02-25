/// Riverpod provider for desktop sidebar collapse state.
///
/// Controls whether the sidebar is shown in expanded (260px)
/// or collapsed (60px icon-only) mode. Non-persisted — resets
/// to expanded on app restart.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the desktop sidebar is collapsed (icon-only mode).
///
/// Defaults to `false` (expanded). Resets on app restart.
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);
