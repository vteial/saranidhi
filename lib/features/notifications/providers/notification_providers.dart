import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/core/utils/timezone_utils.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/notifications/data/notification_service.dart';
import 'package:saranidhi/features/notifications/domain/notification_scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _notifyRulingKey = 'notify_ruling';
const _notifyEatingKey = 'notify_eating';
const _notifyRahuKaalKey = 'notify_rahu_kaal';
const _notifyMorningSummaryKey = 'notify_morning_summary';

/// Provides and persists notification preferences.
///
/// When preferences change, automatically refreshes the notification
/// schedule (cancels old, registers new with OS).
final notificationPrefsProvider =
    NotifierProvider<NotificationPrefsNotifier, NotificationPreferences>(
      NotificationPrefsNotifier.new,
    );

class NotificationPrefsNotifier extends Notifier<NotificationPreferences> {
  @override
  NotificationPreferences build() {
    _loadFromPrefs();
    return const NotificationPreferences();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final ruling = prefs.getBool(_notifyRulingKey) ?? true;
    final eating = prefs.getBool(_notifyEatingKey) ?? false;
    final rahuKaal = prefs.getBool(_notifyRahuKaalKey) ?? false;
    final morning = prefs.getBool(_notifyMorningSummaryKey) ?? false;
    state = NotificationPreferences(
      notifyRuling: ruling,
      notifyEating: eating,
      notifyRahuKaal: rahuKaal,
      notifyMorningSummary: morning,
    );
  }

  Future<void> setNotifyRuling({required bool enabled}) async {
    state = NotificationPreferences(
      notifyRuling: enabled,
      notifyEating: state.notifyEating,
      notifyRahuKaal: state.notifyRahuKaal,
      notifyMorningSummary: state.notifyMorningSummary,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifyRulingKey, enabled);
    await _refreshSchedule();
  }

  Future<void> setNotifyEating({required bool enabled}) async {
    state = NotificationPreferences(
      notifyRuling: state.notifyRuling,
      notifyEating: enabled,
      notifyRahuKaal: state.notifyRahuKaal,
      notifyMorningSummary: state.notifyMorningSummary,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifyEatingKey, enabled);
    await _refreshSchedule();
  }

  Future<void> setNotifyRahuKaal({required bool enabled}) async {
    state = NotificationPreferences(
      notifyRuling: state.notifyRuling,
      notifyEating: state.notifyEating,
      notifyRahuKaal: enabled,
      notifyMorningSummary: state.notifyMorningSummary,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifyRahuKaalKey, enabled);
    await _refreshSchedule();
  }

  Future<void> setNotifyMorningSummary({required bool enabled}) async {
    state = NotificationPreferences(
      notifyRuling: state.notifyRuling,
      notifyEating: state.notifyEating,
      notifyRahuKaal: state.notifyRahuKaal,
      notifyMorningSummary: enabled,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifyMorningSummaryKey, enabled);
    await _refreshSchedule();
  }

  /// Refresh the actual OS notification schedule based on current prefs.
  Future<void> _refreshSchedule() async {
    final service = NotificationService.instance;

    // If all notifications disabled, just cancel everything
    if (!state.isEnabled) {
      await service.cancelAll();
      return;
    }

    // Request permission if needed (first time)
    final hasPermission = await service.requestPermission();
    if (!hasPermission) {
      debugPrint('[Notifications] Permission denied');
      return;
    }

    // Get user's location from profile for sunrise calculation
    final db = ref.read(appDatabaseProvider);
    final profiles = await db.select(db.profiles).get();
    if (profiles.isEmpty) return;

    final profile = profiles.first;
    final lat = profile.locationLat ?? 13.08; // Default: Chennai
    final lng = profile.locationLng ?? 80.27;
    final utcOffset = TimezoneUtils.offsetForLocation(
      latitude: lat,
      longitude: lng,
    );

    // Generate and schedule
    final birthBird = profile.birthBird != null
        ? PakshiBird.values
            .where((b) => b.name == profile.birthBird)
            .firstOrNull
        : null;

    final notifications = await NotificationScheduler.refreshSchedule(
      latitude: lat,
      longitude: lng,
      utcOffset: utcOffset,
      prefs: state,
      birthBird: birthBird,
    );

    await service.scheduleAll(notifications);
  }
}

/// Triggers a full notification refresh (call on app open / after profile change).
final notificationRefreshProvider = FutureProvider<void>((ref) async {
  final prefs = ref.watch(notificationPrefsProvider);
  if (!prefs.isEnabled) return;

  final service = NotificationService.instance;
  final db = ref.read(appDatabaseProvider);
  final profiles = await db.select(db.profiles).get();
  if (profiles.isEmpty) return;

  final profile = profiles.first;
  final lat = profile.locationLat ?? 13.08;
  final lng = profile.locationLng ?? 80.27;
  final utcOffset = TimezoneUtils.offsetForLocation(
    latitude: lat,
    longitude: lng,
  );

  final birthBird = profile.birthBird != null
      ? PakshiBird.values
          .where((b) => b.name == profile.birthBird)
          .firstOrNull
      : null;

  final notifications = await NotificationScheduler.refreshSchedule(
    latitude: lat,
    longitude: lng,
    utcOffset: utcOffset,
    prefs: prefs,
    birthBird: birthBird,
  );

  await service.scheduleAll(notifications);
});
