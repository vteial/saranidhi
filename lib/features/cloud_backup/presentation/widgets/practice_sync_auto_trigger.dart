import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/cloud_backup/providers/practice_sync_providers.dart';

/// Minimum interval between auto-syncs when returning to or reopening the app.
const kAutoSyncMinInterval = Duration(minutes: 5);

/// Widget that triggers Practice Sync when the app opens or resumes.
///
/// Wraps the app shell or route tree near the root (below [ProviderScope]).
///
/// Automatic sync fires ONLY WHEN:
/// - [PracticeSyncConfig.enabled] is true (explicit user opt-in)
/// - [PracticeSyncState.isAuthenticated] is true (valid PocketBase session)
/// - [PracticeSyncState.isSyncing] is false (no in-flight sync)
///
/// Debouncing rules:
/// - Fires at most once per foreground session on cold open.
/// - Fires on app resume only if at least [minInterval] (default 5 minutes)
///   has elapsed since [PracticeSyncConfig.lastSyncedAt].
/// - Fails silently in the background without blocking the UI or throwing.
class PracticeSyncAutoTrigger extends ConsumerStatefulWidget {
  /// Creates a [PracticeSyncAutoTrigger].
  const PracticeSyncAutoTrigger({
    required this.child,
    this.minInterval = kAutoSyncMinInterval,
    this.clock,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The minimum interval before an automatic sync is allowed again on resume.
  final Duration minInterval;

  /// Optional clock provider for deterministic testing of debounce intervals.
  final DateTime Function()? clock;

  @override
  ConsumerState<PracticeSyncAutoTrigger> createState() =>
      _PracticeSyncAutoTriggerState();
}

class _PracticeSyncAutoTriggerState
    extends ConsumerState<PracticeSyncAutoTrigger> {
  late final AppLifecycleListener _lifecycleListener;
  bool _firedThisSession = false;

  DateTime _now() => widget.clock != null ? widget.clock!() : DateTime.now();

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: _onAppResume,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerSyncIfNeeded(isResume: false);
    });
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  void _onAppResume() {
    _triggerSyncIfNeeded(isResume: true);
  }

  bool _shouldAutoSync() {
    final config = ref.read(practiceSyncConfigProvider);
    final state = ref.read(practiceSyncNotifierProvider);
    return config.enabled && state.isAuthenticated && !state.isSyncing;
  }

  void _triggerSyncIfNeeded({required bool isResume}) {
    if (!mounted) return;
    if (!_shouldAutoSync()) return;

    final config = ref.read(practiceSyncConfigProvider);
    final now = _now();
    final lastSynced = config.lastSyncedAt;

    if (isResume) {
      if (lastSynced != null &&
          now.difference(lastSynced) < widget.minInterval) {
        return;
      }
    } else {
      if (_firedThisSession || ref.read(practiceSyncColdOpenFiredProvider)) {
        return;
      }
      ref.read(practiceSyncColdOpenFiredProvider.notifier).markFired();
      if (lastSynced != null &&
          now.difference(lastSynced) < widget.minInterval) {
        _firedThisSession = true;
        return;
      }
      _firedThisSession = true;
    }

    _performSync();
  }

  void _performSync() {
    try {
      unawaited(
        ref
            .read(practiceSyncNotifierProvider.notifier)
            .syncNow()
            .catchError((Object error, StackTrace stackTrace) {
              debugPrint('PracticeSyncAutoTrigger auto-sync error: $error');
              return null;
            }),
      );
    } on Object catch (error) {
      debugPrint('PracticeSyncAutoTrigger unexpected error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PracticeSyncConfig>(practiceSyncConfigProvider, (_, _) {
      if (!_firedThisSession) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _triggerSyncIfNeeded(isResume: false);
        });
      }
    });

    ref.listen<PracticeSyncState>(practiceSyncNotifierProvider, (_, _) {
      if (!_firedThisSession) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _triggerSyncIfNeeded(isResume: false);
        });
      }
    });

    return widget.child;
  }
}
