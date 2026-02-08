/// Connection status indicator widget for CloudShell.
///
/// Displays a small colored dot to indicate server or
/// connection status (online, offline, warning, idle).
library;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Connection status states for visual indication.
enum ConnectionStatus { online, offline, warning, idle }

/// Small colored dot widget indicating connection status.
///
/// Uses the design system status colors for consistency.
class StatusIndicator extends StatelessWidget {
  const StatusIndicator({
    super.key,
    required this.status,
    this.size = 8,
    this.animate = true,
  });

  /// The current connection status.
  final ConnectionStatus status;

  /// Diameter of the indicator dot in logical pixels.
  final double size;

  /// Whether to show a pulsing animation for active states.
  final bool animate;

  Color get _color => switch (status) {
    ConnectionStatus.online => AppColors.statusOnline,
    ConnectionStatus.offline => AppColors.statusOffline,
    ConnectionStatus.warning => AppColors.statusWarning,
    ConnectionStatus.idle => AppColors.statusIdle,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _color,
        shape: BoxShape.circle,
        boxShadow: status == ConnectionStatus.online
            ? [
                BoxShadow(
                  color: _color.withValues(alpha: 0.4),
                  blurRadius: size,
                  spreadRadius: size * 0.25,
                ),
              ]
            : null,
      ),
    );
  }
}
