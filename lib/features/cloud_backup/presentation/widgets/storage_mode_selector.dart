import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Widget for selecting the storage mode (Local / iCloud / Google Drive).
class StorageModeSelector extends ConsumerWidget {
  const StorageModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(storageModeProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.dataStorage, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        ...StorageMode.values.map(
          (mode) => ListTile(
            leading: Icon(_iconForMode(mode)),
            title: Text(_localizedModeName(mode, l10n)),
            subtitle: Text(_localizedModeDescription(mode, l10n)),
            trailing: currentMode == mode
                ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                : null,
            onTap: () {
              ref.read(storageModeProvider.notifier).setMode(mode);
            },
            selected: currentMode == mode,
            dense: true,
          ),
        ),
      ],
    );
  }

  IconData _iconForMode(StorageMode mode) => switch (mode) {
    StorageMode.local => Icons.phone_android,
    StorageMode.icloud => Icons.cloud,
    StorageMode.gdrive => Icons.cloud_outlined,
  };

  String _localizedModeName(StorageMode mode, AppLocalizations l10n) =>
      switch (mode) {
        StorageMode.local => l10n.localOnly,
        StorageMode.icloud => l10n.icloud,
        StorageMode.gdrive => l10n.googleDrive,
      };

  String _localizedModeDescription(StorageMode mode, AppLocalizations l10n) =>
      switch (mode) {
        StorageMode.local => l10n.localOnlySubtitle,
        StorageMode.icloud => l10n.icloudSubtitle,
        StorageMode.gdrive => l10n.googleDriveSubtitle,
      };
}
