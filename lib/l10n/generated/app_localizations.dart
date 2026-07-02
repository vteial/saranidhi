import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in
/// `MaterialApp.localizationsDelegates` and define the supported locales.
///
/// ```dart
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update Localizations
///
/// To update localizations run `flutter gen-l10n`.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// The application title
  String get appTitle;

  /// Home tab label
  String get homeTab;

  /// Journal tab label
  String get journalTab;

  /// Settings tab label
  String get settingsTab;

  /// Dashboard app bar title
  String get dashboardTitle;

  /// Breath journal screen title
  String get breathJournalTitle;

  /// Settings screen title
  String get settingsTitle;

  /// Sunrise label
  String get sunrise;

  /// Sunset label
  String get sunset;

  /// Streak day count
  String streakDays(int count);

  /// Current streak label
  String get currentStreak;

  /// Seven day ribbon title
  String get sevenDayRibbon;

  /// Thirty day trend title
  String get thirtyDayTrend;

  /// Yama accuracy section title
  String get yamaAccuracy;

  /// Alignment label when aligned
  String get aligned;

  /// Alignment label when not aligned
  String get notAligned;

  /// Empty state for journal
  String get noEntries;

  /// Breath entry instruction
  String get selectNostril;

  /// Solar/right nostril label
  String get solar;

  /// Lunar/left nostril label
  String get lunar;

  /// Both nostrils label
  String get sushumna;

  /// Aligned result message
  String get breathAligned;

  /// Not aligned result message
  String get breathNotAligned;

  /// Expected flow label
  String get expected;

  /// Actual flow label
  String get actual;

  /// Submit button label
  String get logBreathEntry;

  /// Saving state label
  String get saving;

  /// Timer incomplete message
  String get completeTimerToLog;

  /// Success message after saving
  String get entryLoggedSuccess;

  /// Inhale phase label
  String get inhale;

  /// Hold phase label
  String get hold;

  /// Exhale phase label
  String get exhale;

  /// Start timer button
  String get startTimer;

  /// Reset timer button
  String get resetTimer;

  /// Pacer title
  String get quickSyncPacer;

  /// Pacer instruction text
  String get quickSyncInstruction;

  /// Journal history section label
  String get journalHistory;

  /// Today date group
  String get today;

  /// Yesterday date group
  String get yesterday;

  /// Profile section title
  String get profile;

  /// Name field label
  String get name;

  /// Birth star label
  String get birthStar;

  /// Birth bird display
  String birthBird(String bird);

  /// Location label
  String get location;

  /// Placeholder for empty fields
  String get notSet;

  /// Appearance section title
  String get appearance;

  /// Color accent section title
  String get colorAccent;

  /// Light theme mode
  String get light;

  /// Dark theme mode
  String get dark;

  /// System theme mode
  String get system;

  /// Language setting label
  String get language;

  /// English language name
  String get english;

  /// Tamil language name
  String get tamil;

  /// Notification section title
  String get notifications;

  /// Notifications subtitle
  String get notificationsSubtitle;

  /// Ruling notification toggle
  String get rulingStateAlerts;

  /// Ruling notification subtitle
  String get rulingStateAlertsSubtitle;

  /// Eating notification toggle
  String get eatingStateAlerts;

  /// Eating notification subtitle
  String get eatingStateAlertsSubtitle;

  /// Storage section title
  String get storageAndBackup;

  /// Local storage option
  String get localOnly;

  /// Local storage subtitle
  String get localOnlySubtitle;

  /// iCloud option
  String get icloud;

  /// iCloud subtitle
  String get icloudSubtitle;

  /// Google Drive option
  String get googleDrive;

  /// Google Drive subtitle
  String get googleDriveSubtitle;

  /// Clear data option label
  String get clearAllData;

  /// Clear data subtitle
  String get clearAllDataSubtitle;

  /// Clear data confirm dialog title
  String get clearAllDataConfirmTitle;

  /// Clear data confirm dialog body
  String get clearAllDataConfirmMessage;

  /// Cancel button label
  String get cancel;

  /// Confirm clear data button
  String get clearData;

  /// Snackbar after data cleared
  String get dataCleared;

  /// Onboarding welcome title
  String get onboardingWelcome;

  /// Onboarding subtitle
  String get onboardingSubtitle;

  /// Name field label in onboarding
  String get yourName;

  /// Back button
  String get back;

  /// Next button
  String get next;

  /// Final onboarding button
  String get completeSetup;

  /// Birth star step title
  String get birthStarNakshatra;

  /// Birth star help text
  String get birthStarHint;

  /// Bird result display
  String yourBird(String bird);

  /// Location step title
  String get yourLocation;

  /// Location help text
  String get locationHint;

  /// Quick select label for cities
  String get quickSelect;

  /// Storage step title
  String get dataStorage;

  /// Storage step help text
  String get dataStorageHint;

  /// Edit birth star dialog title
  String get changeBirthStar;

  /// Birth star change warning
  String get changeBirthStarWarning;

  /// Edit location dialog title
  String get changeLocation;

  /// Retry button label
  String get retry;

  /// Dashboard error message
  String errorLoadingDashboard(String error);

  /// AI wisdom card title
  String get wisdomTitle;

  /// Wisdom loading state
  String get wisdomLoading;

  /// Bird name
  String get vulture;

  /// Bird name
  String get owl;

  /// Bird name
  String get crow;

  /// Bird name
  String get rooster;

  /// Bird name
  String get peacock;

  /// Bird state
  String get ruling;

  /// Bird state
  String get eating;

  /// Bird state
  String get walking;

  /// Bird state
  String get sleeping;

  /// Bird state
  String get dying;

  /// Pull to refresh semantic label
  String get pullToRefresh;

  /// Default color accent name
  String get accentDefault;

  /// Emerald color accent name
  String get accentEmerald;

  /// Gold color accent name
  String get accentGold;

  /// Purple color accent name
  String get accentPurple;

  /// Last backup label
  String get lastBackup;

  /// Backup now button
  String get backupNow;

  /// Backup in progress
  String get backingUp;

  /// Restore button
  String get restore;

  /// Restore in progress
  String get restoring;

  /// Hint when local mode is selected
  String get switchToCloudHint;

  /// Restore confirmation dialog title
  String get restoreBackupTitle;

  /// Restore confirmation dialog body
  String get restoreBackupMessage;

  /// Streak active today message
  String get activeToday;

  /// Streak prompt to log today
  String get logTodayToContinue;

  /// Streak empty state message
  String get startYourStreak;

  /// Best streak label
  String get best;

  /// Trend summary text
  String trendSummary(int aligned, int total);

  /// Yama coverage empty state hint
  String get yamaCoverageHint;

  /// Wisdom card fallback text
  String get wisdomFallback;

  /// History section header with count
  String historyCount(int count);

  /// Empty history hint text
  String get firstEntryHint;

  /// Flow label in history entry
  String flowLabel(String flow);

  /// Delete entry dialog title
  String get deleteEntry;

  /// Delete entry dialog body
  String get deleteEntryMessage;

  /// Delete button label
  String get delete;

  /// Timer inhale short label
  String get timerIn;

  /// Timer exhale short label
  String get timerOut;

  /// Breath timer title
  String get breathTimer;

  /// Inhaling phase label
  String get inhaling;

  /// Holding phase label
  String get holding;

  /// Exhaling phase label
  String get exhaling;

  /// Timer complete label
  String get timerComplete;

  /// Timer idle instruction
  String get tapToStartInhale;

  /// Timer inhale instruction
  String get tapWhenInhaleComplete;

  /// Timer hold instruction
  String get tapWhenReadyToExhale;

  /// Timer exhale instruction
  String get tapWhenExhaleComplete;

  /// Timer complete instruction
  String get tapToReset;

  /// Pacer active instruction
  String get breatheWithCircle;

  /// Yama label prefix
  String get yamaPrefix;

  /// Sunday abbreviation
  String get daySun;

  /// Monday abbreviation
  String get dayMon;

  /// Tuesday abbreviation
  String get dayTue;

  /// Wednesday abbreviation
  String get dayWed;

  /// Thursday abbreviation
  String get dayThu;

  /// Friday abbreviation
  String get dayFri;

  /// Saturday abbreviation
  String get daySat;

  /// Micro-advice when Sushumna aligned
  String get adviceAlignedSushumna;

  /// Micro-advice when Solar aligned
  String get adviceAlignedSolar;

  /// Micro-advice when Lunar aligned
  String get adviceAlignedLunar;

  /// Micro-advice when Solar expected but unaligned
  String get adviceUnalignedSolar;

  /// Micro-advice when Lunar expected but unaligned
  String get adviceUnalignedLunar;

  /// Birth bird state display on dashboard
  String yourBirdState(String bird, String state);

  /// Guidance text for Ruling state
  String get guidanceRuling;

  /// Guidance text for Eating state
  String get guidanceEating;

  /// Guidance text for Walking state
  String get guidanceWalking;

  /// Guidance text for Sleeping state
  String get guidanceSleeping;

  /// Guidance text for Dying state
  String get guidanceDying;

  /// Yama progress indicator
  String yamaProgress(int number, String timeLeft);

  /// Rahu Kaal card title
  String get rahuKaalTitle;

  /// Rahu Kaal active warning
  String get rahuKaalActive;

  /// Rahu Kaal starting soon hint
  String get rahuKaalSoon;

  /// Full day schedule card title
  String get todaysSchedule;

  /// Best yama indicator
  String get bestTime;

  /// Current yama indicator
  String get now;

  /// Align27 comparison row
  String align27Shows(String bird, String state);

  /// Nostril dominance chart title
  String get nostrilPattern;

  /// Countdown to next nostril switch
  String nextSwitch(int minutes);

  /// Nostril alignment status
  String get alignedStatus;

  /// Hold time card title
  String get todaysHold;

  /// Average hold time display
  String avgHold(String seconds, int count);

  /// Empty state for today's hold card
  String get noEntriesToday;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
