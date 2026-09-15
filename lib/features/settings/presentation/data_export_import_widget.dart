import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saranidhi/features/analytics/providers/analytics_providers.dart';
import 'package:saranidhi/features/cloud_backup/domain/database_exporter.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/settings/domain/owner_identity_service.dart';
import 'package:saranidhi/features/settings/presentation/merge_import_controller.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

/// Widget providing full data export/import functionality in Settings.
///
/// - **Export**: Serializes all tables + preferences to JSON with Practice ID.
/// - **Merge from file**: Non-destructive union merge by UUID with owner-identity guard.
/// - **Restore (overwrite)**: Destructive overwrite gated behind confirmation dialog.
/// - **Journal CSV Export**: Exports breath journal entries to CSV.
class DataExportImportWidget extends ConsumerStatefulWidget {
  const DataExportImportWidget({super.key});

  @override
  ConsumerState<DataExportImportWidget> createState() =>
      _DataExportImportWidgetState();
}

class _DataExportImportWidgetState
    extends ConsumerState<DataExportImportWidget> {
  bool _isExporting = false;
  bool _isMerging = false;
  bool _isRestoring = false;
  bool _isExportingCsv = false;

  bool get _isBusy =>
      _isExporting || _isMerging || _isRestoring || _isExportingCsv;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.swap_vert,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.dataExportImportTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.dataExportImportSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Export button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isBusy ? null : _handleExport,
                icon: _isExporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_file),
                label: Text(_isExporting ? l10n.exporting : l10n.exportAllData),
              ),
            ),
            const SizedBox(height: 8),

            // Merge from file button (new default import)
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: _isBusy ? null : _handleMerge,
                icon: _isMerging
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.merge_type),
                label: Text(_isMerging ? l10n.merging : l10n.mergeFromFile),
              ),
            ),
            const SizedBox(height: 8),

            // Restore (overwrite) button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isBusy ? null : _handleRestore,
                icon: _isRestoring
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.restore),
                label: Text(
                  _isRestoring ? l10n.restoring : l10n.restoreAllData,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Journal CSV Export button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isBusy ? null : _handleCsvExport,
                icon: _isExportingCsv
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.table_chart_outlined),
                label: Text(
                  _isExportingCsv ? l10n.exporting : l10n.exportJournalCsv,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCsvExport() async {
    setState(() => _isExportingCsv = true);

    try {
      final csv = await ref.read(csvExportProvider.future);
      final bytes = Uint8List.fromList(utf8.encode(csv));

      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final filename = 'saranidhi_journal_$dateStr.csv';

      await Share.shareXFiles([
        XFile.fromData(bytes, mimeType: 'text/csv', name: filename),
      ], subject: 'Saranidhi Journal CSV Export');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).exportSuccess)),
        );
      }
    } on Exception catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).exportFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _isExportingCsv = false);
    }
  }

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);

    try {
      final exporter = ref.read(databaseExporterProvider);
      final jsonString = await exporter.exportToJsonString();
      final bytes = Uint8List.fromList(utf8.encode(jsonString));

      String? ownerId;
      try {
        ownerId = await ref.read(ownerIdProvider.future);
      } on Exception catch (_) {
        ownerId = ref.read(ownerIdProvider).asData?.value;
      }

      final filename = DatabaseExporter.buildBackupFilename(ownerId: ownerId);

      await Share.shareXFiles([
        XFile.fromData(bytes, mimeType: 'application/json', name: filename),
      ], subject: 'Saranidhi Data Export');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).exportSuccess)),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handleMerge() async {
    setState(() => _isMerging = true);
    try {
      await MergeImportController.pickAndMerge(
        context,
        ref,
        allowRestoreOnMismatch: true,
        onRestoreFallback: _showRestoreDialogAndExecute,
      );
    } finally {
      if (mounted) setState(() => _isMerging = false);
    }
  }

  Future<void> _handleRestore() async {
    final bytes = await MergeImportController.pickJsonFile(context);
    if (bytes == null || !mounted) return;
    await _showRestoreDialogAndExecute(bytes);
  }

  Future<void> _showRestoreDialogAndExecute(Uint8List bytes) async {
    final l10n = AppLocalizations.of(context);
    final summary = DatabaseExporter.summarizeExportData(bytes);
    final jsonStr = utf8.decode(bytes);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final exportedAt = data['exportedAt'] as String?;

    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.restoreConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.restoreConfirmMessage,
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (exportedAt != null)
              SummaryRow(
                label: l10n.importExportedOn,
                value: formatBackupDate(exportedAt),
              ),
            SummaryRow(
              label: l10n.importProfiles,
              value: '${summary['profiles']}',
            ),
            SummaryRow(
              label: l10n.importJournalEntries,
              value: '${summary['journal']}',
            ),
            SummaryRow(
              label: l10n.importBreathSessions,
              value: '${summary['sessions']}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.restoreConfirmButton),
          ),
        ],
      ),
    );

    if (!(confirmed ?? false) || !mounted) return;

    setState(() => _isRestoring = true);
    try {
      final exporter = ref.read(databaseExporterProvider);
      await exporter.restoreFromBytes(bytes);

      _invalidateAllDataProviders();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.restoreSuccess)));
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.importFailed}: $e')));
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  void _invalidateAllDataProviders() {
    invalidateAllDataProviders(ref);
  }
}
