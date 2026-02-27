/// Known SSH hosts management screen.
///
/// Lists all trusted SSH host key fingerprints stored locally,
/// with search and delete actions.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/known_host_provider.dart';
import '../shared/confirmation_dialog.dart';
import '../shared/empty_state.dart';
import '../shared/error_display.dart';
import '../shared/loading_indicator.dart';

/// Screen for managing trusted SSH host keys.
class KnownHostsScreen extends ConsumerStatefulWidget {
  const KnownHostsScreen({super.key});

  @override
  ConsumerState<KnownHostsScreen> createState() => _KnownHostsScreenState();
}

class _KnownHostsScreenState extends ConsumerState<KnownHostsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final knownHostsAsync = ref.watch(allKnownHostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.knownHostsTitle, style: AppTypography.h2),
      ),
      body: knownHostsAsync.when(
        data: (hosts) {
          if (hosts.isEmpty) {
            return EmptyState(
              icon: LucideIcons.shieldCheck,
              title: l10n.knownHostsEmptyTitle,
              subtitle: l10n.knownHostsEmptySubtitle,
            );
          }

          final filtered = _searchQuery.isEmpty
              ? hosts
              : hosts.where((kh) {
                  final q = _searchQuery.toLowerCase();
                  return kh.hostname.toLowerCase().contains(q) ||
                      kh.keyType.toLowerCase().contains(q) ||
                      kh.fingerprint.toLowerCase().contains(q);
                }).toList();

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.knownHostsSearchHint,
                    prefixIcon: const Icon(LucideIcons.search, size: 18),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 16),
                            tooltip: 'Clear search',
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),

              // List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          l10n.knownHostsNoMatchQuery(_searchQuery),
                          style: AppTypography.body
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return _KnownHostTile(
                            knownHost: filtered[index],
                            onDelete: () =>
                                _deleteKnownHost(context, filtered[index]),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () =>
            LoadingIndicator(message: l10n.knownHostsLoadingMessage),
        error: (error, _) => ErrorDisplay(
          error: error,
          onRetry: () => ref.invalidate(allKnownHostsProvider),
        ),
      ),
    );
  }

  Future<void> _deleteKnownHost(
      BuildContext context, KnownHost knownHost) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmationDialog(
      context: context,
      title: l10n.knownHostsRemoveTitle,
      message: l10n.knownHostsRemoveMessage(knownHost.hostname, knownHost.port.toString()),
      confirmLabel: l10n.knownHostsRemoveConfirmLabel,
      isDestructive: true,
    );

    if (confirmed) {
      final db = ref.read(databaseProvider);
      await db.knownHostDao.deleteKnownHost(knownHost.id);
    }
  }
}

/// Individual known host list tile.
class _KnownHostTile extends StatelessWidget {
  const _KnownHostTile({
    required this.knownHost,
    required this.onDelete,
  });

  final KnownHost knownHost;
  final VoidCallback onDelete;

  String get _truncatedFingerprint {
    final fp = knownHost.fingerprint;
    if (fp.length <= 24) return fp;
    return '${fp.substring(0, 24)}...';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Key type badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                knownHost.keyType.replaceAll('ssh-', '').toUpperCase(),
                style: AppTypography.caption.copyWith(
                  color: AppColors.accentCyan,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Host info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${knownHost.hostname}:${knownHost.port}',
                    style: AppTypography.body
                        .copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _truncatedFingerprint,
                    style: AppTypography.code(fontSize: 11).copyWith(
                      color: AppColors.textTertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${l10n.knownHostsFirstSeen} ${Formatters.relativeTime(knownHost.firstSeen)} · '
                    '${l10n.knownHostsLastSeen} ${Formatters.relativeTime(knownHost.lastSeen)}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            // Delete action
            PopupMenuButton<String>(
              icon: const Icon(
                LucideIcons.moreVertical,
                size: 18,
                color: AppColors.textTertiary,
              ),
              onSelected: (value) {
                if (value == 'delete') onDelete();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(LucideIcons.trash2,
                          size: 16, color: AppColors.accentRed),
                      const SizedBox(width: 8),
                      Text(l10n.knownHostsMenuRemove),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
