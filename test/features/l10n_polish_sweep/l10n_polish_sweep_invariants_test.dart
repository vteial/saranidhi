import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/ai_wisdom/domain/wisdom_context.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/notifications/domain/notification_scheduler.dart';
import 'package:saranidhi/l10n/generated/app_localizations_en.dart';
import 'package:saranidhi/l10n/generated/app_localizations_ta.dart';

void main() {
  group('l10n Polish Sweep — Regression Invariants & Requirements', () {
    const lat = 13.08;
    const lng = 80.27;
    const utc = 5.5;
    final earlyMorning = DateTime(2026, 9, 12, 5, 0);

    group('R1 / BUG-POLISH-01 — unpinEntry distinct from delete', () {
      test('RQ.a — delete action label maps to நீக்கு in Tamil and remains distinct from unpinEntry', () {
        final ta = AppLocalizationsTa();
        final en = AppLocalizationsEn();

        // R1.1: unpinEntry uses pure Tamil script distinct from delete
        expect(ta.unpinEntry, equals('பின் அகற்று'));
        expect(ta.delete, equals('நீக்கு'));
        expect(ta.unpinEntry, isNot(equals(ta.delete)));

        // R1.2: English unpinEntry is Unpin
        expect(en.unpinEntry, equals('Unpin'));
        expect(en.delete, equals('Delete'));

        // R1.3: Other genuine delete strings are intact
        expect(ta.deleteEntryMessage, contains('நீக்கும்'));
        expect(ta.prasanamDeleteConfirm, equals('நீக்கு'));
        expect(ta.clearAllDataConfirmMessage, contains('நீக்கும்'));
      });
    });

    group('R2 / BUG-v1.11.1-03 — yama notification title localization', () {
      test('RQ.b & R2.1 — yama title in English uses Yama prefix + number', () {
        final notifications = NotificationScheduler.generateForToday(
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
          prefs: const NotificationPreferences(
            notifyRuling: true,
            notifyEating: false,
            notifyRahuKaal: false,
            notifyMorningSummary: false,
          ),
          birthBird: null,
          languageCode: 'en',
          now: earlyMorning,
        );

        expect(notifications, isNotEmpty);
        expect(notifications.first.title, equals('Saranidhi — Yama 1'));
      });

      test('R2.1 & R2.2 — yama title in Tamil uses யாம prefix + number', () {
        final notifications = NotificationScheduler.generateForToday(
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
          prefs: const NotificationPreferences(
            notifyRuling: true,
            notifyEating: false,
            notifyRahuKaal: false,
            notifyMorningSummary: false,
          ),
          birthBird: null,
          languageCode: 'ta',
          now: earlyMorning,
        );

        expect(notifications, isNotEmpty);
        expect(notifications.first.title, equals('Saranidhi — யாம 1'));
        for (var i = 0; i < notifications.length; i++) {
          expect(notifications[i].title, equals('Saranidhi — யாம ${i + 1}'));
        }
      });

      test('R2.2 — custom yamaPrefix overrides prefix cleanly', () {
        final notifications = NotificationScheduler.generateForToday(
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
          prefs: const NotificationPreferences(
            notifyRuling: true,
            notifyEating: false,
            notifyRahuKaal: false,
            notifyMorningSummary: false,
          ),
          birthBird: null,
          yamaPrefix: 'யா',
          now: earlyMorning,
        );

        expect(notifications, isNotEmpty);
        expect(notifications.first.title, equals('Saranidhi — யா 1'));
      });
    });

    group('R2.4 — AI-wisdom payload activeYama pinned decision', () {
      test('RQ.c — AI-wisdom payload activeYama keeps stable English format', () {
        const context = WisdomContext(
          currentStreak: 5,
          weeklyAccuracy: 85,
          activeBird: null,
          activeBirdState: null,
          activeYama: YamaIndex.yama1,
          isRahuKaal: false,
          activeTattva: null,
          activeHora: null,
        );

        final map = context.toMap();
        // Prompt token must remain stable English 'Yama 1' across all locales
        expect(map['activeYama'], equals('Yama 1'));

        const context5 = WisdomContext(
          currentStreak: 10,
          weeklyAccuracy: 90,
          activeBird: null,
          activeBirdState: null,
          activeYama: YamaIndex.yama5,
          isRahuKaal: false,
          activeTattva: null,
          activeHora: null,
        );
        expect(context5.toMap()['activeYama'], equals('Yama 5'));
      });
    });
  });
}
