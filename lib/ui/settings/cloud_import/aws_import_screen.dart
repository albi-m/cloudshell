/// AWS EC2 instance import screen for CloudShell.
///
/// Multi-step wizard: enter credentials → select instances → configure → import.
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
import '../../../services/cloud_import/aws_import_service.dart';

/// Full-screen AWS EC2 instance import wizard.
class AwsImportScreen extends ConsumerStatefulWidget {
  const AwsImportScreen({super.key});

  @override
  ConsumerState<AwsImportScreen> createState() => _AwsImportScreenState();
}

class _AwsImportScreenState extends ConsumerState<AwsImportScreen> {
  final _accessKeyController = TextEditingController();
  final _secretKeyController = TextEditingController();
  final _usernameController = TextEditingController(text: 'ec2-user');

  int _step = 0;
  bool _isLoading = false;
  bool _isImporting = false;
  bool _obscureSecret = true;
  bool _runningOnly = true;
  String _selectedRegion = 'us-east-1';
  String? _error;

  List<Ec2Instance> _instances = [];
  final Set<String> _selectedIds = {};

  @override
  void dispose() {
    _accessKeyController.dispose();
    _secretKeyController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _fetchInstances() async {
    final l10n = AppLocalizations.of(context);
    final accessKey = _accessKeyController.text.trim();
    final secretKey = _secretKeyController.text.trim();

    if (accessKey.isEmpty) {
      setState(() => _error = l10n.awsErrorAccessKeyRequired);
      return;
    }
    if (secretKey.isEmpty) {
      setState(() => _error = l10n.awsErrorSecretKeyRequired);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = AwsImportService(
        accessKeyId: accessKey,
        secretAccessKey: secretKey,
        region: _selectedRegion,
      );
      final instances = await service.listInstances();
      if (!mounted) return;
      setState(() {
        _instances = instances;
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
          : 'ec2-user';

      var imported = 0;
      for (final instance in _instances) {
        if (!_selectedIds.contains(instance.instanceId)) continue;
        if (instance.connectIp.isEmpty) continue;

        final host = HostsCompanion.insert(
          id: uuid.v4(),
          label: instance.displayName,
          hostname: instance.connectIp,
          port: const Value(22),
          username: username,
          authMethod: AuthMethodType.password,
          tags: Value('aws,ec2,$_selectedRegion'),
          notes: Value(
              'Imported from AWS EC2: ${instance.instanceId} '
              '(${instance.instanceType ?? "unknown"})'),
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
        SnackBar(content: Text(l10n.awsImportResult(imported))),
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

  List<Ec2Instance> get _visibleInstances => _runningOnly
      ? _instances.where((i) => i.isRunning).toList()
      : _instances;

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
        title: Text(l10n.awsImportTitle),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _step == 0
                ? _buildCredentialsStep(theme)
                : _step == 1
                    ? _buildSelectionStep(theme)
                    : _buildConfigStep(theme),
          ),
        ),
      ),
    );
  }

  // Step 0: AWS Credentials
  Widget _buildCredentialsStep(ThemeData theme) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(LucideIcons.cloud, size: 48, color: AppColors.accentOrange),
        const SizedBox(height: 16),
        Text(l10n.awsConnectTitle, style: AppTypography.h2),
        const SizedBox(height: 8),
        Text(
          l10n.awsConnectSubtitle,
          style: AppTypography.body.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _accessKeyController,
          decoration: InputDecoration(
            labelText: l10n.awsAccessKeyIdLabel,
            prefixIcon: const Icon(LucideIcons.key, size: 18),
            helperText: l10n.awsAccessKeyIdHelper,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _secretKeyController,
          obscureText: _obscureSecret,
          decoration: InputDecoration(
            labelText: l10n.awsSecretAccessKeyLabel,
            prefixIcon: const Icon(LucideIcons.lock, size: 18),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureSecret ? LucideIcons.eyeOff : LucideIcons.eye,
                size: 18,
              ),
              tooltip: 'Toggle visibility',
              onPressed: () =>
                  setState(() => _obscureSecret = !_obscureSecret),
            ),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedRegion,
          decoration: InputDecoration(
            labelText: l10n.awsRegionLabel,
            prefixIcon: const Icon(LucideIcons.globe, size: 18),
          ),
          items: awsRegions
              .map((r) => DropdownMenuItem(value: r, child: Text(r)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedRegion = v);
          },
        ),
        const SizedBox(height: 16),
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
                  l10n.awsCredentialsInfo,
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
            onPressed: _isLoading ? null : _fetchInstances,
            child: _isLoading
                ? _LoadingLabel(text: l10n.awsFetchingInstances)
                : Text(l10n.awsFetchInstances),
          ),
        ),
      ],
    );
  }

  // Step 1: Instance Selection
  Widget _buildSelectionStep(ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    final visible = _visibleInstances;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.awsSelectInstances, style: AppTypography.h2)),
            FilterChip(
              label: Text(l10n.awsRunningOnlyFilter),
              selected: _runningOnly,
              onSelected: (v) => setState(() => _runningOnly = v),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (visible.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                _runningOnly
                    ? l10n.awsNoRunningInstances
                    : l10n.awsNoInstances,
                style: AppTypography.body
                    .copyWith(color: AppColors.textTertiary),
              ),
            ),
          )
        else
          ...visible.map((i) => _InstanceTile(
                instance: i,
                isSelected: _selectedIds.contains(i.instanceId),
                onToggle: () {
                  setState(() {
                    if (_selectedIds.contains(i.instanceId)) {
                      _selectedIds.remove(i.instanceId);
                    } else {
                      _selectedIds.add(i.instanceId);
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
              onPressed: _selectedIds.isEmpty
                  ? null
                  : () => setState(() => _step = 2),
              child: Text(l10n.awsNextButton(_selectedIds.length)),
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
        Text(l10n.awsConfigureImport, style: AppTypography.h2),
        const SizedBox(height: 24),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: l10n.awsDefaultUsernameLabel,
            prefixIcon: const Icon(LucideIcons.user, size: 18),
            helperText: l10n.awsDefaultUsernameHelper,
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
              Text(l10n.awsInstancesToImport, style: AppTypography.overline),
              const SizedBox(height: 8),
              ..._instances
                  .where((i) => _selectedIds.contains(i.instanceId))
                  .map((i) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(LucideIcons.server,
                                size: 14,
                                color: AppColors.accentOrange),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(i.displayName,
                                  style: AppTypography.bodySmall),
                            ),
                            Text(i.connectIp,
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
                  ? _LoadingLabel(text: l10n.awsImporting)
                  : Text(l10n.awsImportHostsButton(_selectedIds.length)),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Instance Tile
// ---------------------------------------------------------------------------

class _InstanceTile extends StatelessWidget {
  const _InstanceTile({
    required this.instance,
    required this.isSelected,
    required this.onToggle,
  });

  final Ec2Instance instance;
  final bool isSelected;
  final VoidCallback onToggle;

  Color _stateColor() => switch (instance.state) {
        'running' => AppColors.statusOnline,
        'stopped' => AppColors.accentRed,
        'pending' || 'shutting-down' || 'stopping' => AppColors.accentOrange,
        _ => AppColors.statusIdle,
      };

  @override
  Widget build(BuildContext context) {
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
              // State dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _stateColor(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(instance.displayName,
                        style: AppTypography.body
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(instance.instanceId,
                            style: AppTypography.code(fontSize: 10)),
                        if (instance.connectIp.isNotEmpty) ...[
                          Text('  \u00B7  ',
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                          Text(instance.connectIp,
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                        ],
                        if (instance.instanceType != null) ...[
                          Text('  \u00B7  ',
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                          Text(instance.instanceType!,
                              style: AppTypography.caption
                                  .copyWith(fontSize: 10)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // State badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _stateColor().withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  instance.state,
                  style: AppTypography.caption.copyWith(
                    color: _stateColor(),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
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
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.accentRed)),
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
