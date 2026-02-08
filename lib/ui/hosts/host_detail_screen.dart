/// Host detail screen showing full information for a single host.
///
/// Displays all connection details, authentication info, group,
/// notes, and provides actions to connect, edit, and delete.
/// Matches wireframe S2.2.
library;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/database/app_database.dart';
import '../../data/database/tables/hosts_table.dart';
import '../../providers/connection_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/host_provider.dart';
import '../../providers/key_provider.dart';
import '../../services/ssh/ssh_service.dart';
import '../shared/confirmation_dialog.dart';
import '../shared/loading_indicator.dart';
import '../terminal/terminal_screen.dart';
import 'host_form_screen.dart';

/// Detail view for a single SSH host.
///
/// Shows all host metadata and provides connect, edit, delete,
/// and favorite toggle actions.
class HostDetailScreen extends ConsumerWidget {
  const HostDetailScreen({super.key, required this.hostId});

  final String hostId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostAsync = ref.watch(hostByIdProvider(hostId));

    return hostAsync.when(
      data: (host) {
        if (host == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Host not found')),
          );
        }
        return _HostDetailView(host: host);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const LoadingIndicator(message: 'Loading host...'),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            'Failed to load host',
            style: AppTypography.body.copyWith(color: AppColors.accentRed),
          ),
        ),
      ),
    );
  }
}

class _HostDetailView extends ConsumerWidget {
  const _HostDetailView({required this.host});

  final Host host;

  String get _authMethodLabel => switch (host.authMethod) {
        AuthMethodType.key => 'SSH Key',
        AuthMethodType.password => 'Password',
        AuthMethodType.keyAndPassword => 'Key + Password',
        AuthMethodType.interactive => 'Interactive',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connections = ref.watch(activeConnectionsProvider);
    final isConnected = connections.values.any(
      (c) => c.hostId == host.id && c.status == ConnectionStatus.connected,
    );

    return Scaffold(
      backgroundColor: AppColors.bgDeepest,
      appBar: AppBar(
        title: Text(host.label, style: AppTypography.h2),
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.star,
              color: host.isFavorite
                  ? AppColors.accentOrange
                  : AppColors.textTertiary,
            ),
            tooltip:
                host.isFavorite ? 'Remove from favorites' : 'Add to favorites',
            onPressed: () => _toggleFavorite(ref),
          ),
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _edit(context);
                case 'delete':
                  _delete(context, ref);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(LucideIcons.pencil, size: 16),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2,
                        size: 16, color: AppColors.accentRed),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Connection status banner
          _StatusBanner(isConnected: isConnected),
          const SizedBox(height: 16),

          // Connect button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _connect(context, ref),
              icon: Icon(
                isConnected ? LucideIcons.terminal : LucideIcons.play,
                size: 18,
              ),
              label: Text(isConnected ? 'Open Terminal' : 'Connect'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Connection details
          _SectionCard(
            title: 'CONNECTION',
            children: [
              _DetailRow(
                icon: LucideIcons.globe,
                label: 'Hostname',
                value: host.hostname,
              ),
              _DetailRow(
                icon: LucideIcons.hash,
                label: 'Port',
                value: '${host.port}',
              ),
              _DetailRow(
                icon: LucideIcons.user,
                label: 'Username',
                value: host.username,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Authentication
          _SectionCard(
            title: 'AUTHENTICATION',
            children: [
              _DetailRow(
                icon: LucideIcons.shieldCheck,
                label: 'Method',
                value: _authMethodLabel,
              ),
              if (host.keyId != null)
                _KeyDetailRow(keyId: host.keyId!),
            ],
          ),
          const SizedBox(height: 12),

          // Group & metadata
          _SectionCard(
            title: 'DETAILS',
            children: [
              if (host.groupId != null)
                _GroupDetailRow(groupId: host.groupId!),
              if (host.tags.isNotEmpty)
                _DetailRow(
                  icon: LucideIcons.tag,
                  label: 'Tags',
                  value: host.tags,
                ),
              _DetailRow(
                icon: LucideIcons.clock,
                label: 'Last connected',
                value: host.lastConnectedAt != null
                    ? Formatters.relativeTime(host.lastConnectedAt!)
                    : 'Never',
              ),
              _DetailRow(
                icon: LucideIcons.calendar,
                label: 'Created',
                value: Formatters.relativeTime(host.createdAt),
              ),
            ],
          ),

          // Advanced settings
          if (host.startupCommand != null ||
              host.keepAliveSeconds != 60 ||
              host.notes != null) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: 'ADVANCED',
              children: [
                if (host.startupCommand != null)
                  _DetailRow(
                    icon: LucideIcons.terminal,
                    label: 'Startup command',
                    value: host.startupCommand!,
                  ),
                if (host.keepAliveSeconds != 60)
                  _DetailRow(
                    icon: LucideIcons.heartPulse,
                    label: 'Keep alive',
                    value: '${host.keepAliveSeconds}s',
                  ),
                if (host.notes != null)
                  _DetailRow(
                    icon: LucideIcons.stickyNote,
                    label: 'Notes',
                    value: host.notes!,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _connect(BuildContext context, WidgetRef ref) async {
    final sshService = ref.read(sshServiceProvider);
    final connections = ref.read(activeConnectionsProvider.notifier);

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connecting to ${host.label}...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final session = await sshService.connect(host: host);

      connections.addConnection(session.sessionId, host.id);
      connections.updateStatus(session.sessionId, ConnectionStatus.connected);

      // Update last connected timestamp
      final db = ref.read(databaseProvider);
      await db.hostDao.updateLastConnected(host.id);

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TerminalScreen(
              session: session,
              hostLabel: host.label,
            ),
          ),
        );
      }
    } catch (e) {
      ErrorHandler.handle(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.userMessage(e)),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  void _edit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HostFormScreen(host: host),
      ),
    );
  }

  Future<void> _toggleFavorite(WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    await db.hostDao.updateHost(HostsCompanion(
      id: Value(host.id),
      isFavorite: Value(!host.isFavorite),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Host',
      message:
          'Are you sure you want to delete "${host.label}"? This cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (!confirmed) return;

    final db = ref.read(databaseProvider);
    await db.hostDao.softDeleteHost(host.id);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

/// Status banner showing connected/disconnected state.
class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isConnected
            ? AppColors.statusOnline.withValues(alpha: 0.1)
            : AppColors.bgSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isConnected
              ? AppColors.statusOnline.withValues(alpha: 0.3)
              : AppColors.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isConnected ? AppColors.statusOnline : AppColors.statusOffline,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            isConnected ? 'Connected' : 'Disconnected',
            style: AppTypography.body.copyWith(
              color: isConnected
                  ? AppColors.statusOnline
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section card with a title label and list of detail rows.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.overline
                  .copyWith(color: AppColors.textTertiary),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Single detail row with icon, label, and value.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style:
                  AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.body,
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail row that resolves a key ID to show the key label.
class _KeyDetailRow extends ConsumerWidget {
  const _KeyDetailRow({required this.keyId});

  final String keyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyAsync = ref.watch(keyByIdProvider(keyId));
    final keyLabel = keyAsync.whenOrNull(data: (k) => k?.label) ?? 'Loading...';

    return _DetailRow(
      icon: LucideIcons.keyRound,
      label: 'SSH Key',
      value: keyLabel,
    );
  }
}

/// Detail row that resolves a group ID to show the group name.
class _GroupDetailRow extends ConsumerWidget {
  const _GroupDetailRow({required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(groupByIdProvider(groupId));
    final groupName =
        groupAsync.whenOrNull(data: (g) => g?.name) ?? 'Loading...';

    return _DetailRow(
      icon: LucideIcons.folder,
      label: 'Group',
      value: groupName,
    );
  }
}
