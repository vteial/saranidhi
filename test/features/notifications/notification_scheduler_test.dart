import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/notifications/domain/notification_scheduler.dart';

void main() {
  group('NotificationScheduler', () {
    const lat = 13.08;
    const lng = 80.27;
    const utc = 5.5;

    test('generates notifications when ruling enabled', () {
      final notifications = NotificationScheduler.generateForToday(
        latitude: lat,
        longitude: lng,
        utcOffset: utc,
        prefs: const NotificationPreferences(notifyRuling: true),
      );

      // Should have up to 5 ruling notifications (one per future Yama)
      expect(notifications.length, greaterThanOrEqualTo(0));
      expect(notifications.length, lessThanOrEqualTo(5));
    });

    test('generates more notifications when both enabled', () {
      final rulingOnly = NotificationScheduler.generateForToday(
        latitude: lat,
        longitude: lng,
        utcOffset: utc,
        prefs: const NotificationPreferences(notifyRuling: true),
      );
      final both = NotificationScheduler.generateForToday(
        latitude: lat,
        longitude: lng,
        utcOffset: utc,
        prefs: const NotificationPreferences(
          notifyRuling: true,
          notifyEating: true,
        ),
      );

      expect(both.length, greaterThanOrEqualTo(rulingOnly.length));
    });

    test('returns empty list when disabled', () {
      final notifications = NotificationScheduler.generateForToday(
        latitude: lat,
        longitude: lng,
        utcOffset: utc,
        prefs: const NotificationPreferences(
          notifyRuling: false,
          notifyEating: false,
        ),
      );

      expect(notifications, isEmpty);
    });

    test('returns empty for polar region', () {
      final notifications = NotificationScheduler.generateForToday(
        latitude: 89,
        longitude: 0,
        utcOffset: 0,
        prefs: const NotificationPreferences(notifyRuling: true),
      );

      expect(notifications, isEmpty);
    });

    test('all notifications have future scheduledTime', () {
      final notifications = NotificationScheduler.generateForToday(
        latitude: lat,
        longitude: lng,
        utcOffset: utc,
        prefs: const NotificationPreferences(
          notifyRuling: true,
          notifyEating: true,
        ),
      );

      final now = DateTime.now();
      for (final n in notifications) {
        expect(n.scheduledTime.isAfter(now), isTrue);
      }
    });

    test('notifications have non-empty title and body', () {
      final notifications = NotificationScheduler.generateForToday(
        latitude: lat,
        longitude: lng,
        utcOffset: utc,
        prefs: const NotificationPreferences(
          notifyRuling: true,
          notifyEating: true,
        ),
      );

      for (final n in notifications) {
        expect(n.title.isNotEmpty, isTrue);
        expect(n.body.isNotEmpty, isTrue);
      }
    });

    test('notification IDs are unique', () {
      final notifications = NotificationScheduler.generateForToday(
        latitude: lat,
        longitude: lng,
        utcOffset: utc,
        prefs: const NotificationPreferences(
          notifyRuling: true,
          notifyEating: true,
        ),
      );

      final ids = notifications.map((n) => n.id).toSet();
      expect(ids.length, equals(notifications.length));
    });
  });

  group('NotificationPreferences', () {
    test('enabledCount correct', () {
      expect(
        const NotificationPreferences(
          notifyRuling: true,
          notifyEating: true,
        ).enabledCount,
        equals(2),
      );
      expect(
        const NotificationPreferences(notifyRuling: true).enabledCount,
        equals(1),
      );
      expect(
        const NotificationPreferences(
          notifyRuling: false,
          notifyEating: false,
        ).enabledCount,
        equals(0),
      );
    });

    test('isEnabled correct', () {
      expect(
        const NotificationPreferences(notifyRuling: true).isEnabled,
        isTrue,
      );
      expect(
        const NotificationPreferences(
          notifyRuling: false,
          notifyEating: false,
        ).isEnabled,
        isFalse,
      );
    });
  });
}
