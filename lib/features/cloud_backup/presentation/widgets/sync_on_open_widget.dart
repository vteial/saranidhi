import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_metadata.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/cloud_backup/providers/sync_providers.dart';

/// Widget that triggers iCloud sync when the app opens.
///
/// Place this near the top of the widget tree (below [ProviderScope]).
/// It triggers a sync on:
/// - First build (app launch)
/// - App resume from background (via [AppLifecycleListener])
///
/// Only syncs when storage mode is [StorageMode.icloud].
/// Shows a subtle sync indicator in the app when syncing.
class SyncOnOpenWidget extends ConsumerStatefulWidget {
  const SyncOnOpenWidget({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SyncOnOpenWidget> createState() => _SyncOnOpenWidgetState();
}

class _SyncOnOpenWidgetState extends ConsumerState<SyncOnOpenWidget> {
  late final AppLifecycleListener _lifecycleListener;
  bool _hasSyncedOnce = false;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: _onAppResume,
    );

    // Trigger initial sync after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerSyncIfNeeded();
    });
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  /// Called when app returns to foreground.
  void _onAppResume() {
    _triggerSyncIfNeeded();
  }

  /// Triggers sync only if storage mode is iCloud.
  void _triggerSyncIfNeeded() {
    final storageMode = ref.read(storageModeProvider);
    if (storageMode != StorageMode.icloud) return;

    final syncState = ref.read(syncNotifierProvider);
    // Don't trigger if already syncing
    if (syncState.state == SyncState.pulling ||
        syncState.state == SyncState.pushing) {
      return;
    }

    ref.read(syncNotifierProvider.notifier).performSync();
    _hasSyncedOnce = true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(syncNotifierProvider);
    final storageMode = ref.watch(storageModeProvider);

    // If storage mode just changed to iCloud and we haven't synced yet
    if (storageMode == StorageMode.icloud && !_hasSyncedOnce) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerSyncIfNeeded();
      });
    }

    return Stack(
      children: [
        widget.child,
        // Show a subtle sync indicator at top
        if (syncStatus.state == SyncState.pulling ||
            syncStatus.state == SyncState.pushing)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _SyncIndicator(),
          ),
      ],
    );
  }
}

/// A subtle progress indicator shown during sync.
class _SyncIndicator extends StatelessWidget {
  const _SyncIndicator();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: LinearProgressIndicator(
        minHeight: 2,
      ),
    );
  }
}
