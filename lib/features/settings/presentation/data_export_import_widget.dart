import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saranidhi/features/cloud_backup/domain/database_exporter.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

/// Widget providing full data export/import functionality in Settings.
///
/// - **Export**: Serializes all tables + preferences to JSON, triggers
///   share sheet (mobile) or download (web).
/// - **Import**: Opens file picker for .json file, validates, shows
///   confirmation with data summary, then imports destructively.
class DataExportImportWidget extends ConsumerStatefulWidget {
  const DataExportImportWidget({super.key});

  @override
  ConsumerState<DataExportImportWidget> createState() =>
      _DataExportImportWidgetState();
}

class _DataExportImportWidgetState
    extends ConsumerState<DataExportImportWidget> {
  bool _isExporting = false;
  bool _isImporting = false;

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
                onPressed: _isExporting ? null : _handleExport,
                icon: _isExporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_file),
                label: Text(
                  _isExporting ? l10n.exporting : l10n.exportAllData,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Import button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isImporting ? null : _handleImport,
                icon: _isImporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: Text(
                  _isImporting ? l10n.importing : l10n.importData,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);

    try {
      final exporter = ref.read(databaseExporterProvider);
      final jsonString = await exporter.exportToJsonString();
      final bytes = Uint8List.fromList(utf8.encode(jsonString));

      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final filename = 'saranidhi_backup_$dateStr.json';

      if (kIsWeb) {
        // On web, trigger download via share_plus or fallback
        await Share.shareXFiles(
          [XFile.fromData(bytes, mimeType: 'application/json', name: filename)],
          subject: 'Saranidhi Data Export',
        );
      } else {
        // On mobile/desktop, use share sheet
        await Share.shareXFiles(
          [XFile.fromData(bytes, mimeType: 'application/json', name: filename)],
          subject: 'Saranidhi Data Export',
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).exportSuccess),
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handleImport() async {
    final l10n = AppLocalizations.of(context);

    // 1. Pick file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.importFailedReadFile)),
        );
      }
      return;
    }

    // 2. Validate
    final validationError = DatabaseExporter.validateExportData(bytes);
    if (validationError != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.importInvalidFile}: $validationError')),
        );
      }
      return;
    }

    // 3. Show confirmation with data summary
    final summary = DatabaseExporter.summarizeExportData(bytes);
    final jsonStr = utf8.decode(bytes);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final exportedAt = data['exportedAt'] as String?;

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.importConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.importConfirmMessage),
            const SizedBox(height: 16),
            if (exportedAt != null)
              _SummaryRow(
                label: l10n.importExportedOn,
                value: _formatDate(exportedAt),
              ),
            _SummaryRow(
              label: l10n.importProfiles,
              value: '${summary['profiles']}',
            ),
            _SummaryRow(
              label: l10n.importJournalEntries,
              value: '${summary['journal']}',
            ),
            _SummaryRow(
              label: l10n.importBreathSessions,
              value: '${summary['sessions']}',
            ),
            const SizedBox(height: 12),
            Text(
              l10n.importWarning,
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.importConfirmButton),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // 4. Perform import
    setState(() => _isImporting = true);

    try {
      final exporter = ref.read(databaseExporterProvider);
      await exporter.importFromBytes(bytes);

      // Invalidate all dashboard data to reflect imported data
      ref.invalidate(dashboardDataProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.importSuccess)),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.importFailed}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return DateFormat('MMM d, yyyy – HH:mm').format(dt);
    } on Exception {
      return isoDate;
    }
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
