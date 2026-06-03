import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';
import 'package:saranidhi/l10n/generated/app_localizations_en.dart';
import 'package:saranidhi/l10n/generated/app_localizations_ta.dart';

void main() {
  group('AppLocalizations (English)', () {
    late AppLocalizations l10n;

    setUp(() {
      l10n = AppLocalizationsEn();
    });

    test('appTitle is Saranidhi', () {
      expect(l10n.appTitle, equals('Saranidhi'));
    });

    test('tab labels are correct', () {
      expect(l10n.homeTab, equals('Home'));
      expect(l10n.journalTab, equals('Journal'));
      expect(l10n.settingsTab, equals('Settings'));
    });

    test('streakDays formats correctly', () {
      expect(l10n.streakDays(5), equals('5 days'));
      expect(l10n.streakDays(0), equals('0 days'));
      expect(l10n.streakDays(100), equals('100 days'));
    });

    test('birthBird formats correctly', () {
      expect(l10n.birthBird('Peacock'), equals('Birth Bird: Peacock'));
    });

    test('yourBird formats correctly', () {
      expect(l10n.yourBird('Vulture'), equals('Your bird: Vulture'));
    });

    test('errorLoadingDashboard formats correctly', () {
      expect(
        l10n.errorLoadingDashboard('timeout'),
        equals('Error loading dashboard: timeout'),
      );
    });

    test('all string getters return non-empty strings', () {
      final strings = [
        l10n.appTitle,
        l10n.homeTab,
        l10n.journalTab,
        l10n.settingsTab,
        l10n.dashboardTitle,
        l10n.breathJournalTitle,
        l10n.settingsTitle,
        l10n.sunrise,
        l10n.sunset,
        l10n.currentStreak,
        l10n.sevenDayRibbon,
        l10n.thirtyDayTrend,
        l10n.yamaAccuracy,
        l10n.aligned,
        l10n.notAligned,
        l10n.selectNostril,
        l10n.solar,
        l10n.lunar,
        l10n.sushumna,
        l10n.logBreathEntry,
        l10n.saving,
        l10n.clearAllData,
        l10n.clearAllDataConfirmTitle,
        l10n.clearAllDataConfirmMessage,
        l10n.cancel,
        l10n.clearData,
        l10n.dataCleared,
        l10n.onboardingWelcome,
        l10n.onboardingSubtitle,
        l10n.back,
        l10n.next,
        l10n.completeSetup,
        l10n.retry,
        l10n.pullToRefresh,
      ];

      for (final s in strings) {
        expect(s.isNotEmpty, isTrue, reason: 'String should not be empty');
      }
    });
  });

  group('AppLocalizations (Tamil)', () {
    late AppLocalizations l10n;

    setUp(() {
      l10n = AppLocalizationsTa();
    });

    test('appTitle is in Tamil', () {
      expect(l10n.appTitle, isNot(equals('Saranidhi')));
      expect(l10n.appTitle.isNotEmpty, isTrue);
    });

    test('tab labels are in Tamil', () {
      expect(l10n.homeTab, isNot(equals('Home')));
      expect(l10n.journalTab, isNot(equals('Journal')));
      expect(l10n.settingsTab, isNot(equals('Settings')));
    });

    test('streakDays formats correctly in Tamil', () {
      final result = l10n.streakDays(5);
      expect(result, contains('5'));
      expect(result.isNotEmpty, isTrue);
    });

    test('all Tamil strings are non-empty', () {
      final strings = [
        l10n.appTitle,
        l10n.homeTab,
        l10n.journalTab,
        l10n.settingsTab,
        l10n.sunrise,
        l10n.sunset,
        l10n.clearAllData,
        l10n.onboardingWelcome,
        l10n.back,
        l10n.next,
      ];

      for (final s in strings) {
        expect(s.isNotEmpty, isTrue);
      }
    });
  });

  group('AppLocalizations delegates', () {
    test('supportedLocales contains en and ta', () {
      final locales = AppLocalizations.supportedLocales;
      expect(locales.length, equals(2));
      expect(locales.any((l) => l.languageCode == 'en'), isTrue);
      expect(locales.any((l) => l.languageCode == 'ta'), isTrue);
    });

    test('localizationsDelegates is non-empty', () {
      expect(AppLocalizations.localizationsDelegates.isNotEmpty, isTrue);
    });
  });
}
