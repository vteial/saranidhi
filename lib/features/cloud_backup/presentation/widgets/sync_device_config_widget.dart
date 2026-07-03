import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_metadata.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/cloud_backup/providers/sync_providers.dart';

/// Settings widget for configuring iCloud sync device settings.
///
/// Shows:
/// - Current device info (name, primary status)
/// - Toggle to mark this device as primary
/// - Manual sync trigger button
/// - Last sync status
/// - List of other registered devices
///
/// Only visible when storage mode is [StorageMode.icloud].
class SyncDeviceConfigWidget extends ConsumerWidget {
  const SyncDeviceConfigWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageMode = ref.watch(storageModeProvider);

    // Only show when iCloud sync is active
    if (storageMode != StorageMode.icloud) {
      return const SizedBox.shrink();
    }

    return const _SyncConfigContent();
  }
}

class _SyncConfigContent extends ConsumerWidget {
  const _SyncConfigContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(syncNotifierProvider);
    final deviceInfoAsync = ref.watch(currentDeviceInfoProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Icon(Icons.sync, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'iCloud Sync',
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Sync status card
        _SyncStatusCard(syncStatus: syncStatus),
        const SizedBox(height: 12),

        // Device info + primary toggle
        deviceInfoAsync.when(
          data: (deviceInfo) => _DeviceInfoCard(deviceInfo: deviceInfo),
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 12),

        // Manual sync button
        _ManualSyncButton(syncStatus: syncStatus),
        const SizedBox(height: 8),

        // Registered devices
        _RegisteredDevicesList(),
      ],
    );
  }
}

/// Shows the current sync status.
class _SyncStatusCard extends StatelessWidget {
  const _SyncStatusCard({required this.syncStatus});

  final SyncStatus syncStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (icon, label, color) = switch (syncStatus.state) {
      SyncState.disabled => (
          Icons.cloud_off,
          'Sync disabled',
          theme.colorScheme.onSurfaceVariant,
        ),
      SyncState.idle => (
          Icons.cloud_outlined,
          'Ready to sync',
          theme.colorScheme.onSurfaceVariant,
        ),
      SyncState.pulling => (
          Icons.cloud_download,
          'Pulling changes...',
          theme.colorScheme.primary,
        ),
      SyncState.pushing => (
          Icons.cloud_upload,
          'Pushing changes...',
          theme.colorScheme.primary,
        ),
      SyncState.synced => (
          Icons.cloud_done,
          _syncedLabel(syncStatus),
          theme.colorScheme.primary,
        ),
      SyncState.error => (
          Icons.cloud_off,
          syncStatus.message ?? 'Sync error',
          theme.colorScheme.error,
        ),
    };

    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label, style: TextStyle(color: color)),
        subtitle: syncStatus.state == SyncState.synced &&
                syncStatus.lastSyncTime != null
            ? Text(
                '${syncStatus.recordsPulled} pulled, '
                '${syncStatus.recordsPushed} pushed',
                style: theme.textTheme.bodySmall,
              )
            : null,
      ),
    );
  }

  String _syncedLabel(SyncStatus status) {
    if (status.lastSyncTime == null) return 'Synced';
    final ago = DateTime.now().difference(status.lastSyncTime!);
    if (ago.inMinutes < 1) return 'Synced just now';
    if (ago.inMinutes < 60) return 'Synced ${ago.inMinutes}m ago';
    if (ago.inHours < 24) return 'Synced ${ago.inHours}h ago';
    return 'Synced ${ago.inDays}d ago';
  }
}

/// Shows device info with primary toggle and name edit.
class _DeviceInfoCard extends ConsumerStatefulWidget {
  const _DeviceInfoCard({required this.deviceInfo});

  final SyncDeviceInfo deviceInfo;

  @override
  ConsumerState<_DeviceInfoCard> createState() => _DeviceInfoCardState();
}

class _DeviceInfoCardState extends ConsumerState<_DeviceInfoCard> {
  late bool _isPrimary;

  @override
  void initState() {
    super.initState();
    _isPrimary = widget.deviceInfo.isPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _platformIcon(widget.deviceInfo.platform),
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This Device',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                // Edit name button
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => _editDeviceName(context),
                  tooltip: 'Edit device name',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.deviceInfo.deviceName,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            // Primary device toggle
            SwitchListTile(
              title: const Text('Primary device'),
              subtitle: Text(
                _isPrimary
                    ? 'This device wins on sync conflicts'
                    : 'Remote changes override local on conflict',
                style: theme.textTheme.bodySmall,
              ),
              value: _isPrimary,
              onChanged: (value) async {
                setState(() => _isPrimary = value);
                await ref
                    .read(syncNotifierProvider.notifier)
                    .setPrimaryDevice(isPrimary: value);
                // Refresh device info
                ref.invalidate(currentDeviceInfoProvider);
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editDeviceName(BuildContext context) async {
    final controller = TextEditingController(
      text: widget.deviceInfo.deviceName,
    );

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Device Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. iPhone SE, iMac Office',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && mounted) {
      await ref.read(syncNotifierProvider.notifier).setDeviceName(newName);
      ref.invalidate(currentDeviceInfoProvider);
    }
  }

  IconData _platformIcon(String platform) => switch (platform) {
        'ios' => Icons.phone_iphone,
        'macos' => Icons.desktop_mac,
        _ => Icons.devices,
      };
}

/// Manual sync trigger button.
class _ManualSyncButton extends ConsumerWidget {
  const _ManualSyncButton({required this.syncStatus});

  final SyncStatus syncStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSyncing = syncStatus.state == SyncState.pulling ||
        syncStatus.state == SyncState.pushing;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isSyncing
            ? null
            : () => ref.read(syncNotifierProvider.notifier).performSync(),
        icon: isSyncing
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.sync),
        label: Text(isSyncing ? 'Syncing...' : 'Sync Now'),
      ),
    );
  }
}

/// Shows other registered devices in the sync group.
class _RegisteredDevicesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(registeredDevicesProvider);
    final currentDeviceAsync = ref.watch(currentDeviceInfoProvider);
    final theme = Theme.of(context);

    return devicesAsync.when(
      data: (devices) {
        final currentId = currentDeviceAsync.value?.deviceId;
        // Filter out current device
        final otherDevices = devices
            .where((d) => d.deviceId != currentId)
            .toList();

        if (otherDevices.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No other devices registered yet. '
              'Open the app on another Apple device to sync.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Other Devices',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...otherDevices.map(
              (device) => Card(
                child: ListTile(
                  leading: Icon(
                    _platformIcon(device.platform),
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  title: Text(device.deviceName),
                  subtitle: Text(
                    device.isPrimary ? 'Primary' : 'Secondary',
                    style: TextStyle(
                      color: device.isPrimary
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Text(
                    _lastSyncLabel(device.lastSyncTimestamp),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  IconData _platformIcon(String platform) => switch (platform) {
        'ios' => Icons.phone_iphone,
        'macos' => Icons.desktop_mac,
        _ => Icons.devices,
      };

  String _lastSyncLabel(DateTime lastSync) {
    final ago = DateTime.now().difference(lastSync);
    if (ago.inMinutes < 1) return 'Just now';
    if (ago.inMinutes < 60) return '${ago.inMinutes}m ago';
    if (ago.inHours < 24) return '${ago.inHours}h ago';
    return '${ago.inDays}d ago';
  }
}
