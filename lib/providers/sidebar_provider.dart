/// Riverpod provider for desktop sidebar collapse state.
///
/// Controls whether the sidebar is shown in expanded (260px)
/// or collapsed (60px icon-only) mode. Non-persisted — resets
/// to expanded on app restart.
library;

import 'package:flutter_riverpod/legacy.dart';

/// Whether the desktop sidebar is collapsed to icon-only mode (60px vs 260px).
///
/// Manages a single boolean: `false` = expanded, `true` = collapsed.
/// Ephemeral state that resets to expanded (`false`) on app restart.
/// Rebuilt by widgets that call `ref.watch` and toggled via `ref.read(.notifier).state`.
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);
