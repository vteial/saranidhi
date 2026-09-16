import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saranidhi/core/l10n/locale_provider.dart';
import 'package:saranidhi/core/theme/theme_provider.dart';
import 'package:saranidhi/features/analytics/providers/analytics_providers.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/features/cloud_backup/domain/database_exporter.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/notifications/providers/notification_providers.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';
import 'package:saranidhi/features/settings/domain/owner_identity_service.dart';
import 'package:saranidhi/features/settings/providers/profile_providers.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Formats an ISO 8601 date string for display in import/restore dialogs.
String formatBackupDate(String isoDate) {
  try {
    final dt = DateTime.parse(isoDate);
    return DateFormat('MMM d, yyyy – HH:mm').format(dt);
  } on Exception {
    return isoDate;
  }
}

/// Invalidates all data-dependent Riverpod providers across the application using [WidgetRef].
///
/// Called after a successful database Merge, Restore, or Cloud Sync.
void invalidateAllDataProviders(WidgetRef ref) {
  ref
    ..invalidate(dashboardDataProvider)
    ..invalidate(journalEntriesProvider)
    ..invalidate(weeklyAnalyticsProvider)
    ..invalidate(monthlyPatternsProvider)
    ..invalidate(streakInsightsProvider)
    ..invalidate(holdTimeProgressionProvider)
    ..invalidate(ownerIdProvider)
    ..invalidate(profileProvider)
    ..invalidate(themeProvider)
    ..invalidate(localeProvider)
    ..invalidate(notificationPrefsProvider)
    ..invalidate(onboardingCompleteProvider);
}

/// Invalidates all data-dependent Riverpod providers across the application using [Ref].
void invalidateAllDataProvidersWithRef(Ref ref) {
  ref
    ..invalidate(dashboardDataProvider)
    ..invalidate(journalEntriesProvider)
    ..invalidate(weeklyAnalyticsProvider)
    ..invalidate(monthlyPatternsProvider)
    ..invalidate(streakInsightsProvider)
    ..invalidate(holdTimeProgressionProvider)
    ..invalidate(ownerIdProvider)
    ..invalidate(profileProvider)
    ..invalidate(themeProvider)
    ..invalidate(localeProvider)
    ..invalidate(notificationPrefsProvider)
    ..invalidate(onboardingCompleteProvider);
}

/// Shared row component for backup summary dialogs.
class SummaryRow extends StatelessWidget {
  const SummaryRow({required this.label, required this.value, super.key});

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

/// Controller providing the shared guard-aware JSON file picker, confirmation dialogs,
/// and merge execution flow for both Settings and Onboarding Intro.
class MergeImportController {
  const MergeImportController._();

  /// Prompts user to select a JSON backup file and validates its contents.
  ///
  /// Returns raw bytes if valid, or `null` if cancelled or invalid.
  static Future<Uint8List?> pickJsonFile(
    BuildContext context, {
    Future<FilePickerResult?> Function()? customPicker,
  }) async {
    final l10n = AppLocalizations.of(context);
    final result = customPicker != null
        ? await customPicker()
        : await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['json'],
            withData: true,
          );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.importFailedReadFile)));
      }
      return null;
    }

    final validationError = DatabaseExporter.validateExportData(bytes);
    if (validationError != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.importInvalidFile}: $validationError'),
          ),
        );
      }
      return null;
    }

    return bytes;
  }

  /// Runs the full guard-aware merge-from-file flow:
  ///
  /// 1. Pick and validate JSON backup file.
  /// 2. Check [OwnerGuardCheck]:
  ///    - [OwnerGuardStatus.mismatch]: Refuses merge dialog. If [allowRestoreOnMismatch] is true,
  ///      allows user to switch to restore flow via [onRestoreFallback].
  ///    - [OwnerGuardStatus.legacyNoOwnerId]: Warns user and requires explicit confirmation.
  ///    - [OwnerGuardStatus.match] / [OwnerGuardStatus.emptyLocal]: Shows confirmation dialog
  ///      with Practice ID status ("Adopting" or "Matches") and record count summary.
  /// 3. Executes `mergeFromBytes`, invalidates all data providers, reloads onboarding prefs,
  ///    and displays the result snackbar.
  ///
  /// Returns `true` if a merge (or fallback restore) occurred, `false` otherwise.
  static Future<bool> pickAndMerge(
    BuildContext context,
    WidgetRef ref, {
    bool allowRestoreOnMismatch = false,
    Future<void> Function(Uint8List bytes)? onRestoreFallback,
    Future<FilePickerResult?> Function()? customPicker,
  }) async {
    final l10n = AppLocalizations.of(context);
    final bytes = await pickJsonFile(context, customPicker: customPicker);
    if (bytes == null || !context.mounted) return false;

    final exporter = ref.read(databaseExporterProvider);
    final jsonStr = utf8.decode(bytes);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final guardCheck = await exporter.checkOwnerGuard(data);

    // 1. Identity Mismatch -> REFUSE
    if (guardCheck.status == OwnerGuardStatus.mismatch) {
      if (!context.mounted) return false;
      final shouldSwitchToRestore = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: Theme.of(ctx).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(l10n.practiceIdMismatchTitle)),
            ],
          ),
          content: Text(
            l10n.practiceIdMismatchMessage(
              guardCheck.localOwnerId ?? '',
              guardCheck.fileOwnerId ?? '',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel),
            ),
            if (allowRestoreOnMismatch)
              FilledButton.tonal(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.restoreConfirmButton),
              ),
          ],
        ),
      );

      if ((shouldSwitchToRestore ?? false) && context.mounted) {
        if (onRestoreFallback != null) {
          await onRestoreFallback(bytes);
          return true;
        }
      }
      return false;
    }

    // 2. Legacy backup with no Practice ID -> warn and require confirm
    if (guardCheck.status == OwnerGuardStatus.legacyNoOwnerId) {
      final summary = DatabaseExporter.summarizeExportData(bytes);
      if (!context.mounted) return false;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.legacyBackupWarningTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.legacyBackupWarningMessage),
              const SizedBox(height: 16),
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
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.continueMerge),
            ),
          ],
        ),
      );

      if ((confirmed ?? false) && context.mounted) {
        return executeMerge(context, ref, bytes, allowLegacy: true);
      }
      return false;
    }

    // 3. Match or Empty Local -> Summary confirm dialog
    final summary = DatabaseExporter.summarizeExportData(bytes);
    final exportedAt = data['exportedAt'] as String?;
    final practiceIdStatusText = guardCheck.status == OwnerGuardStatus.match
        ? l10n.practiceIdMatches
        : l10n.practiceIdAdopting;

    if (!context.mounted) return false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.mergeConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.mergeConfirmMessage),
            const SizedBox(height: 16),
            SummaryRow(label: l10n.practiceId, value: practiceIdStatusText),
            if (exportedAt != null)
              SummaryRow(
                label: l10n.importExportedOn,
                value: formatBackupDate(exportedAt),
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
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.mergeConfirmButton),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && context.mounted) {
      return executeMerge(context, ref, bytes, allowLegacy: false);
    }
    return false;
  }

  /// Directly executes the merge operation on the database, invalidates Riverpod providers,
  /// reloads SharedPreferences onboarding state, and displays feedback.
  static Future<bool> executeMerge(
    BuildContext context,
    WidgetRef ref,
    Uint8List bytes, {
    required bool allowLegacy,
  }) async {
    final l10n = AppLocalizations.of(context);

    try {
      final exporter = ref.read(databaseExporterProvider);
      final result = await exporter.mergeFromBytes(
        bytes,
        allowLegacy: allowLegacy,
      );

      invalidateAllDataProviders(ref);
      await ref.read(onboardingCompleteProvider.notifier).reload();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.mergeSuccess(result.totalInserted))),
        );
      }
      return true;
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.importFailed}: $e')));
      }
      return false;
    }
  }
}
