import 'package:saranidhi/features/astro_engine/domain/sunrise_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/notifications/data/notification_service.dart';

/// Represents a scheduled notification for a Yama boundary.
class ScheduledNotification {
  const ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.yamaIndex,
  });

  final int id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final YamaIndex yamaIndex;
}

/// Notification preferences.
class NotificationPreferences {
  const NotificationPreferences({
    this.notifyRuling = true,
    this.notifyEating = false,
  });

  final bool notifyRuling;
  final bool notifyEating;

  int get enabledCount => (notifyRuling ? 1 : 0) + (notifyEating ? 1 : 0);
  bool get isEnabled => notifyRuling || notifyEating;
}

/// Generates notification schedule for Yama boundary times.
///
/// On mobile: these would be registered with the local notification plugin.
/// On web: notifications are not supported (silently skipped).
class NotificationScheduler {
  const NotificationScheduler._();

  static const List<String> _rulingWisdom = [
    'Yama 1 begins — The Ruling bird is active. Start with intention.',
    'Yama 2 begins — A new bird takes the throne. Observe your breath.',
    'Yama 3 begins — Midday energy shift. Check your nostril dominance.',
    'Yama 4 begins — Afternoon transition. Align with the cosmic flow.',
    'Yama 5 begins — Final Yama of daylight. Complete your practice.',
  ];

  static const List<String> _eatingWisdom = [
    'The bird enters Eating state — nourish your body and spirit.',
    'Eating state active — a good time for mindful consumption.',
    'The bird feeds — align your meals with cosmic rhythm.',
    'Nourishment time — eat with awareness of the elements.',
    'Feeding state — let food be your medicine today.',
  ];

  /// Generates scheduled notifications for today based on sunrise/sunset.
  static List<ScheduledNotification> generateForToday({
    required double latitude,
    required double longitude,
    required double utcOffset,
    required NotificationPreferences prefs,
  }) {
    if (!prefs.isEnabled) return [];

    final today = DateTime.now();
    final sunResult = SunriseCalculator.calculate(
      date: today,
      latitude: latitude,
      longitude: longitude,
      utcOffset: utcOffset,
    );

    if (sunResult == null) return [];

    final yamaResult = YamaCalculator.calculate(
      sunrise: sunResult.sunrise,
      sunset: sunResult.sunset,
    );

    final notifications = <ScheduledNotification>[];
    var idCounter = 0;

    for (final yama in yamaResult.yamas) {
      if (yama.start.isBefore(today)) continue;

      if (prefs.notifyRuling) {
        notifications.add(
          ScheduledNotification(
            id: idCounter++,
            title: 'Saranidhi — ${yama.index.label}',
            body: _rulingWisdom[yama.index.index],
            scheduledTime: yama.start,
            yamaIndex: yama.index,
          ),
        );
      }

      if (prefs.notifyEating) {
        final eatingOffset = yama.duration ~/ 5;
        final eatingTime = yama.start.add(eatingOffset);
        if (eatingTime.isAfter(today)) {
          notifications.add(
            ScheduledNotification(
              id: idCounter++,
              title: 'Saranidhi — Eating State',
              body: _eatingWisdom[yama.index.index],
              scheduledTime: eatingTime,
              yamaIndex: yama.index,
            ),
          );
        }
      }
    }

    return notifications;
  }

  /// Clears all previously scheduled notifications.
  static Future<void> cancelAll() async {
    await NotificationService.instance.cancelAll();
  }

  /// Re-schedules all notifications for today (cancel + regenerate).
  static Future<List<ScheduledNotification>> refreshSchedule({
    required double latitude,
    required double longitude,
    required double utcOffset,
    required NotificationPreferences prefs,
  }) async {
    await cancelAll();
    return generateForToday(
      latitude: latitude,
      longitude: longitude,
      utcOffset: utcOffset,
      prefs: prefs,
    );
  }
}
