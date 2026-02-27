/// DigitalOcean droplet import screen for CloudShell.
///
/// Multi-step wizard: enter API token → select droplets → configure → import.
library;

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/error_handler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/database/app_database.dart';
import '../../../data/database/tables/hosts_table.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/cloud_import/do_import_service.dart';

/// Full-screen DigitalOcean droplet import wizard.
class DoImportScreen extends ConsumerStatefulWidget {
  const DoImportScreen({super.key});

  @override
  ConsumerState<DoImportScreen> createState() => _DoImportScreenState();
}

class _DoImportScreenState extends ConsumerState<DoImportScreen> {
  final _tokenController = TextEditingController();
  final _usernameController = TextEditingController(text: 'root');

  int _step = 0;
  bool _isLoading = false;
  bool _isImporting = false;
  bool _obscureToken = true;
  bool _activeOnly = true;
  String? _error;

  List<DoDroplet> _droplets = [];
  final Set<int> _selectedIds = {};

  @override
  void dispose() {
    _tokenController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _fetchDroplets() async {
    final l10n = AppLocalizations.of(context);
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      setState(() => _error = l10n.doErrorTokenRequired);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = DoImportService(apiToken: token);
      final droplets = await service.listDroplets();
      if (!mounted) return;
      setState(() {
        _droplets = droplets;
        _selectedIds.clear();
        _isLoading = false;
        _step = 1;
      });
    } catch (e) {
      ErrorHandler.handle(e);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = ErrorHandler.userMessage(e);
      });
    }
  }

  Future<void> _importSelected() async {
    if (_selectedIds.isEmpty) return;

    setState(() {
      _isImporting = true;
      _error = null;
    });

    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();
      final uuid = const Uuid();
      final username = _usernameController.text.trim().isNotEmpty
          ? _usernameController.text.trim()
          : 'root';

      var imported = 0;
      for (final droplet in _droplets) {
        if (!_selectedIds.contains(droplet.id)) continue;
        if (droplet.connectIp.isEmpty) continue;

        final host = HostsCompanion.insert(
          id: uuid.v4(),
          label: droplet.name,
          hostname: droplet.connectIp,
          port: const Value(22),
          username: username,
          authMethod: AuthMethodType.password,
          tags: Value('digitalocean,${droplet.region ?? "unknown"}'),
          notes: Value(
              'Imported from DigitalOcean: ${droplet.name} '
              '(${droplet.sizeSlug ?? "unknown"})'),
          createdAt: now,
          updatedAt: now,
        );

        await db.hostDao.insertHost(host);
        imported++;
      }

      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.doImportResult(imported))),
      );
    } catch (e) {
      ErrorHandler.handle(e);
      if (!mounted) return;
      setState(() {
        _isImporting = false;
        _error = ErrorHandler.userMessage(e);
      });
    }
  }

  List<DoDroplet> get _visibleDroplets =>
      _activeOnly ? _droplets.where((d) => d.isActive).toList() : _droplets;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.doImportTitle),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _step == 0
                ? _buildTokenStep(theme)
                : _step == 1
                    ? _buildSelectionStep(theme)
                    : _buildConfigStep(theme),
          ),
        ),
      ),
    );
  }

  // Step 0: API Token
  Widget _buildTokenStep(ThemeData theme) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(LucideIcons.cloud, size: 48, color: AppColors.accentPrimary),
        const SizedBox(height: 16),
        Text(l10n.doConnectTitle, style: AppTypography.h2),
        const SizedBox(height: 8),
        Text(
          l10n.doConnectSubtitle,
          style: AppTypography.body.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _tokenController,
          obscureText: _obscureToken,
          decoration: InputDecoration(
            labelText: l10n.doApiTokenLabel,
            prefixIcon: const Icon(LucideIcons.key, size: 18),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureToken ? LucideIcons.eyeOff : LucideIcons.eye,
                size: 18,
              ),
              tooltip: 'Toggle visibility',
              onPressed: () =>
                  setState(() => _obscureToken = !_obscureToken),
            ),
            helperText: l10n.doApiTokenHelper,
          ),
          onSubmitted: (_) => _fetchDroplets(),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accentCyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.info, size: 16, color: AppColors.accentCyan),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.doTokenInfo,
                  style: AppTypography.caption.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.7)),
                ),
              ),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          _ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: _isLoading ? null : _fetchDroplets,
            child: _isLoading
                ? _LoadingLabel(text: l10n.doFetchingDroplets)
                : Text(l10n.doFetchDroplets),
          ),
        ),
      ],
    );
  }

  // Step 1: Droplet Selection
  Widget _buildSelectionStep(ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    final visible = _visibleDroplets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.doSelectDroplets, style: AppTypography.h2),
            ),
            FilterChip(
              label: Text(l10n.doActiveOnlyFilter),
              selected: _activeOnly,
              onSelected: (v) => setState(() => _activeOnly = v),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (visible.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                _activeOnly
                    ? l10n.doNoActiveDroplets
                    : l10n.doNoDroplets,
                style: AppTypography.body
                    .copyWith(color: AppColors.textTertiary),
              ),
            ),
          )
        else
          ...visible.map((d) => _DropletTile(
                droplet: d,
                isSelected: _selectedIds.contains(d.id),
                onToggle: () {
                  setState(() {
                    if (_selectedIds.contains(d.id)) {
                      _selectedIds.remove(d.id);
                    } else {
                      _selectedIds.add(d.id);
                    }
                  });
                },
              )),
        const SizedBox(height: 24),
        Row(
          children: [
            TextButton(
              onPressed: () => setState(() => _step = 0),
              child: Text(l10n.cancel),
            ),
            const Spacer(),
            FilledButton(
              onPressed:
                  _selectedIds.isEmpty ? null : () => setState(() => _step = 2),
              child: Text(l10n.doNextButton(_selectedIds.length)),
            ),
          ],
        ),
      ],
    );
  }

  // Step 2: Configure + Import
  Widget _buildConfigStep(ThemeData theme) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.doConfigureImport, style: AppTypography.h2),
        const SizedBox(height: 24),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: l10n.doDefaultUsernameLabel,
            prefixIcon: const Icon(LucideIcons.user, size: 18),
            helperText: l10n.doDefaultUsernameHelper,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.doHostsToImport, style: AppTypography.overline),
              const SizedBox(height: 8),
              ..._droplets
                  .where((d) => _selectedIds.contains(d.id))
                  .map((d) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(LucideIcons.server,
                                size: 14, color: AppColors.accentPrimary),
                            const SizedBox(width: 8),
                            Text(d.name, style: AppTypography.bodySmall),
                            const SizedBox(width: 8),
                            Text(d.connectIp,
                                style: AppTypography.code(fontSize: 11)),
                          ],
                        ),
                      )),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          _ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 24),
        Row(
          children: [
            TextButton(
              onPressed: _isImporting ? null : () => setState(() => _step = 1),
              child: Text(l10n.cancel),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _isImporting ? null : _importSelected,
              child: _isImporting
                  ? _LoadingLabel(text: l10n.doImporting)
                  : Text(l10n.doImportHostsButton(_selectedIds.length)),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Droplet Tile
// ---------------------------------------------------------------------------

class _DropletTile extends StatelessWidget {
  const _DropletTile({
    required this.droplet,
    required this.isSelected,
    required this.onToggle,
  });

  final DoDroplet droplet;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (_) => onToggle(),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 8),
              // Status dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: droplet.isActive
                      ? AppColors.statusOnline
                      : AppColors.statusIdle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(droplet.name,
                        style: AppTypography.body
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (droplet.connectIp.isNotEmpty)
                          Text(droplet.connectIp,
                              style: AppTypography.code(fontSize: 11)),
                        if (droplet.region != null) ...[
                          Text('  \u00B7  ',
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                          Text(droplet.region!,
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                        ],
                        if (droplet.sizeSlug != null) ...[
                          Text('  \u00B7  ',
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                          Text(droplet.sizeSlug!,
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Image tag
              if (droplet.image != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    droplet.image!,
                    style: AppTypography.caption.copyWith(fontSize: 10),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared Widgets
// ---------------------------------------------------------------------------

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accentRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.alertCircle,
              size: 16, color: AppColors.accentRed),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style:
                    AppTypography.bodySmall.copyWith(color: AppColors.accentRed)),
          ),
        ],
      ),
    );
  }
}

class _LoadingLabel extends StatelessWidget {
  const _LoadingLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Text(text),
      ],
    );
  }
}
