import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';

/// Widget displaying backup/restore actions and last backup info.
class BackupActionsWidget extends ConsumerWidget {
  const BackupActionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backupState = ref.watch(backupNotifierProvider);
    final storageMode = ref.watch(storageModeProvider);
    final theme = Theme.of(context);
    final isLocal = storageMode == StorageMode.local;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Backup & Restore', style: theme.textTheme.titleSmall),
        const SizedBox(height: 12),

        // Last backup info
        if (backupState.metadata != null) ...[
          Card(
            child: ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Last Backup'),
              subtitle: Text(_formatDate(backupState.metadata!.lastBackupDate)),
              trailing: Text(
                _formatSize(backupState.metadata!.sizeBytes),
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Backup button
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: isLocal || backupState.isBackingUp
                    ? null
                    : () => ref
                          .read(backupNotifierProvider.notifier)
                          .performBackup(),
                icon: backupState.isBackingUp
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.backup),
                label: Text(
                  backupState.isBackingUp ? 'Backing up...' : 'Backup Now',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isLocal || backupState.isRestoring
                    ? null
                    : () => _confirmRestore(context, ref),
                icon: backupState.isRestoring
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.restore),
                label: Text(
                  backupState.isRestoring ? 'Restoring...' : 'Restore',
                ),
              ),
            ),
          ],
        ),

        if (isLocal) ...[
          const SizedBox(height: 8),
          Text(
            'Switch to iCloud or Google Drive to enable backup',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],

        // Result message
        if (backupState.lastResult != null) ...[
          const SizedBox(height: 12),
          Card(
            color: backupState.lastResult!.success
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : theme.colorScheme.errorContainer.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    backupState.lastResult!.success
                        ? Icons.check_circle
                        : Icons.error_outline,
                    size: 20,
                    color: backupState.lastResult!.success
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      backupState.lastResult!.message ?? 'Operation complete',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _confirmRestore(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Backup?'),
        content: const Text(
          'This will replace all current data with the backup. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(backupNotifierProvider.notifier).performRestore();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
