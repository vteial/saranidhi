import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/notifications/domain/notification_scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _notifyRulingKey = 'notify_ruling';
const _notifyEatingKey = 'notify_eating';

/// Provides and persists notification preferences.
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
    state = NotificationPreferences(notifyRuling: ruling, notifyEating: eating);
  }

  Future<void> setNotifyRuling({required bool enabled}) async {
    state = NotificationPreferences(
      notifyRuling: enabled,
      notifyEating: state.notifyEating,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifyRulingKey, enabled);
  }

  Future<void> setNotifyEating({required bool enabled}) async {
    state = NotificationPreferences(
      notifyRuling: state.notifyRuling,
      notifyEating: enabled,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifyEatingKey, enabled);
  }
}
