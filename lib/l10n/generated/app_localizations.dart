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
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Saranidhi'**
  String get appTitle;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// Journal tab label
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journalTab;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// Today sub-tab label on Home screen
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTab;

  /// Explore sub-tab label on Home screen
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreTab;

  /// Dashboard app bar title
  ///
  /// In en, this message translates to:
  /// **'Saranidhi'**
  String get dashboardTitle;

  /// Breath journal screen title
  ///
  /// In en, this message translates to:
  /// **'Breath Journal'**
  String get breathJournalTitle;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Sunrise label
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// Sunset label
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// Streak day count
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String streakDays(int count);

  /// Current streak label
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// Seven day ribbon title
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get sevenDayRibbon;

  /// Thirty day trend title
  ///
  /// In en, this message translates to:
  /// **'30-Day Trend'**
  String get thirtyDayTrend;

  /// Yama accuracy section title
  ///
  /// In en, this message translates to:
  /// **'Yama Accuracy'**
  String get yamaAccuracy;

  /// Alignment label when aligned
  ///
  /// In en, this message translates to:
  /// **'Aligned'**
  String get aligned;

  /// Alignment label when not aligned
  ///
  /// In en, this message translates to:
  /// **'Not Aligned'**
  String get notAligned;

  /// Empty state for journal
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get noEntries;

  /// Breath entry instruction
  ///
  /// In en, this message translates to:
  /// **'Select your active nostril'**
  String get selectNostril;

  /// Solar/right nostril label
  ///
  /// In en, this message translates to:
  /// **'Solar (Right)'**
  String get solar;

  /// Lunar/left nostril label
  ///
  /// In en, this message translates to:
  /// **'Lunar (Left)'**
  String get lunar;

  /// Both nostrils label
  ///
  /// In en, this message translates to:
  /// **'Sushumna (Both)'**
  String get sushumna;

  /// Aligned result message
  ///
  /// In en, this message translates to:
  /// **'Your breath is aligned!'**
  String get breathAligned;

  /// Not aligned result message
  ///
  /// In en, this message translates to:
  /// **'Your breath is not aligned.'**
  String get breathNotAligned;

  /// Expected flow label
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get expected;

  /// Actual flow label
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get actual;

  /// Submit button label
  ///
  /// In en, this message translates to:
  /// **'Log Breath Entry'**
  String get logBreathEntry;

  /// Saving state label
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Timer incomplete message
  ///
  /// In en, this message translates to:
  /// **'Complete timer to log'**
  String get completeTimerToLog;

  /// Success message after saving
  ///
  /// In en, this message translates to:
  /// **'Entry logged successfully!'**
  String get entryLoggedSuccess;

  /// Inhale phase label
  ///
  /// In en, this message translates to:
  /// **'Inhale'**
  String get inhale;

  /// Hold phase label
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get hold;

  /// Exhale phase label
  ///
  /// In en, this message translates to:
  /// **'Exhale'**
  String get exhale;

  /// Start timer button
  ///
  /// In en, this message translates to:
  /// **'Start Timer'**
  String get startTimer;

  /// Reset timer button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetTimer;

  /// Pacer title
  ///
  /// In en, this message translates to:
  /// **'Quick Sync Pacer'**
  String get quickSyncPacer;

  /// Pacer instruction text
  ///
  /// In en, this message translates to:
  /// **'Follow the animation to shift your dominant nostril.'**
  String get quickSyncInstruction;

  /// Journal history section label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get journalHistory;

  /// Today date group
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday date group
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Profile section title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Birth star label
  ///
  /// In en, this message translates to:
  /// **'Birth Star'**
  String get birthStar;

  /// Birth bird display
  ///
  /// In en, this message translates to:
  /// **'Birth Bird: {bird}'**
  String birthBird(String bird);

  /// Location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Placeholder for empty fields
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// Appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Color accent section title
  ///
  /// In en, this message translates to:
  /// **'Color Accent'**
  String get colorAccent;

  /// Light theme mode
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme mode
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System theme mode
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Tamil language name
  ///
  /// In en, this message translates to:
  /// **'தமிழ்'**
  String get tamil;

  /// Notification section title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'Yama transition alerts (mobile only)'**
  String get notificationsSubtitle;

  /// Ruling notification toggle
  ///
  /// In en, this message translates to:
  /// **'Ruling state alerts'**
  String get rulingStateAlerts;

  /// Ruling notification subtitle
  ///
  /// In en, this message translates to:
  /// **'Notify at Yama start (Ruling bird)'**
  String get rulingStateAlertsSubtitle;

  /// Eating notification toggle
  ///
  /// In en, this message translates to:
  /// **'Eating state alerts'**
  String get eatingStateAlerts;

  /// Eating notification subtitle
  ///
  /// In en, this message translates to:
  /// **'Notify when bird enters Eating state'**
  String get eatingStateAlertsSubtitle;

  /// Storage section title
  ///
  /// In en, this message translates to:
  /// **'Storage & Backup'**
  String get storageAndBackup;

  /// Local storage option
  ///
  /// In en, this message translates to:
  /// **'Local Only'**
  String get localOnly;

  /// Local storage subtitle
  ///
  /// In en, this message translates to:
  /// **'Data stays on this device only'**
  String get localOnlySubtitle;

  /// iCloud option
  ///
  /// In en, this message translates to:
  /// **'iCloud (iOS)'**
  String get icloud;

  /// iCloud subtitle
  ///
  /// In en, this message translates to:
  /// **'Backup to your iCloud account'**
  String get icloudSubtitle;

  /// Google Drive option
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get googleDrive;

  /// Google Drive subtitle
  ///
  /// In en, this message translates to:
  /// **'Backup to your Google Drive'**
  String get googleDriveSubtitle;

  /// Clear data option label
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// Clear data subtitle
  ///
  /// In en, this message translates to:
  /// **'Delete all local data and reset app'**
  String get clearAllDataSubtitle;

  /// Clear data confirm dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear All Data?'**
  String get clearAllDataConfirmTitle;

  /// Clear data confirm dialog body
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your breath journal entries, streak data, and profile. This action cannot be undone.'**
  String get clearAllDataConfirmMessage;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm clear data button
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clearData;

  /// Snackbar after data cleared
  ///
  /// In en, this message translates to:
  /// **'All data cleared successfully.'**
  String get dataCleared;

  /// Onboarding welcome title
  ///
  /// In en, this message translates to:
  /// **'Welcome to Saranidhi'**
  String get onboardingWelcome;

  /// Onboarding subtitle
  ///
  /// In en, this message translates to:
  /// **'The Treasure House of Breath'**
  String get onboardingSubtitle;

  /// Name field label in onboarding
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Final onboarding button
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// Birth star step title
  ///
  /// In en, this message translates to:
  /// **'Birth Star (Nakshatra)'**
  String get birthStarNakshatra;

  /// Birth star help text
  ///
  /// In en, this message translates to:
  /// **'Your birth star determines your Panja Pakshi bird.'**
  String get birthStarHint;

  /// Bird result display
  ///
  /// In en, this message translates to:
  /// **'Your bird: {bird}'**
  String yourBird(String bird);

  /// Location step title
  ///
  /// In en, this message translates to:
  /// **'Your Location'**
  String get yourLocation;

  /// Location help text
  ///
  /// In en, this message translates to:
  /// **'Used for accurate sunrise/sunset calculation. Your location stays on your device.'**
  String get locationHint;

  /// Quick select label for cities
  ///
  /// In en, this message translates to:
  /// **'Quick Select:'**
  String get quickSelect;

  /// Button to trigger browser geolocation on the onboarding location step
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get locationUseMyLocation;

  /// Status shown while browser geolocation is in progress
  ///
  /// In en, this message translates to:
  /// **'Detecting your location…'**
  String get locationDetecting;

  /// Label used for a location populated from browser geolocation coordinates
  ///
  /// In en, this message translates to:
  /// **'Detected location'**
  String get locationDetected;

  /// Quiet inline hint shown when browser geolocation is denied or unavailable
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t detect your location. Pick a city below instead.'**
  String get locationUnavailable;

  /// Storage step title
  ///
  /// In en, this message translates to:
  /// **'Data Storage'**
  String get dataStorage;

  /// Storage step help text
  ///
  /// In en, this message translates to:
  /// **'Choose where to keep your breath journal data.'**
  String get dataStorageHint;

  /// Edit birth star dialog title
  ///
  /// In en, this message translates to:
  /// **'Change Birth Star'**
  String get changeBirthStar;

  /// Birth star change warning
  ///
  /// In en, this message translates to:
  /// **'Warning: Changing your birth star will update your Pakshi bird.'**
  String get changeBirthStarWarning;

  /// Edit location dialog title
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get changeLocation;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Dashboard error message
  ///
  /// In en, this message translates to:
  /// **'Error loading dashboard: {error}'**
  String errorLoadingDashboard(String error);

  /// AI wisdom card title
  ///
  /// In en, this message translates to:
  /// **'Daily Wisdom'**
  String get wisdomTitle;

  /// Wisdom loading state
  ///
  /// In en, this message translates to:
  /// **'Generating insight...'**
  String get wisdomLoading;

  /// Bird name
  ///
  /// In en, this message translates to:
  /// **'Vulture'**
  String get vulture;

  /// Bird name
  ///
  /// In en, this message translates to:
  /// **'Owl'**
  String get owl;

  /// Bird name
  ///
  /// In en, this message translates to:
  /// **'Crow'**
  String get crow;

  /// Bird name
  ///
  /// In en, this message translates to:
  /// **'Rooster'**
  String get rooster;

  /// Bird name
  ///
  /// In en, this message translates to:
  /// **'Peacock'**
  String get peacock;

  /// Bird state
  ///
  /// In en, this message translates to:
  /// **'Ruling'**
  String get ruling;

  /// Bird state
  ///
  /// In en, this message translates to:
  /// **'Eating'**
  String get eating;

  /// Bird state
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get walking;

  /// Bird state
  ///
  /// In en, this message translates to:
  /// **'Sleeping'**
  String get sleeping;

  /// Bird state
  ///
  /// In en, this message translates to:
  /// **'Dying'**
  String get dying;

  /// Pull to refresh semantic label
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// Default color accent name
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get accentDefault;

  /// Emerald color accent name
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get accentEmerald;

  /// Gold color accent name
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get accentGold;

  /// Purple color accent name
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get accentPurple;

  /// Last backup label
  ///
  /// In en, this message translates to:
  /// **'Last Backup'**
  String get lastBackup;

  /// Backup now button
  ///
  /// In en, this message translates to:
  /// **'Backup Now'**
  String get backupNow;

  /// Backup in progress
  ///
  /// In en, this message translates to:
  /// **'Backing up...'**
  String get backingUp;

  /// Restore button
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// Restore in progress
  ///
  /// In en, this message translates to:
  /// **'Restoring...'**
  String get restoring;

  /// Hint when local mode is selected
  ///
  /// In en, this message translates to:
  /// **'Switch to iCloud or Google Drive to enable backup'**
  String get switchToCloudHint;

  /// Restore confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Restore Backup?'**
  String get restoreBackupTitle;

  /// Restore confirmation dialog body
  ///
  /// In en, this message translates to:
  /// **'This will replace all current data with the backup. This action cannot be undone.'**
  String get restoreBackupMessage;

  /// Streak active today message
  ///
  /// In en, this message translates to:
  /// **'Active today!'**
  String get activeToday;

  /// Streak prompt to log today
  ///
  /// In en, this message translates to:
  /// **'Log today to continue'**
  String get logTodayToContinue;

  /// Streak empty state message
  ///
  /// In en, this message translates to:
  /// **'Start your streak'**
  String get startYourStreak;

  /// Best streak label
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get best;

  /// Trend summary text
  ///
  /// In en, this message translates to:
  /// **'{aligned} aligned of {total} days logged'**
  String trendSummary(int aligned, int total);

  /// Yama coverage empty state hint
  ///
  /// In en, this message translates to:
  /// **'Log entries during different times of day to see coverage'**
  String get yamaCoverageHint;

  /// Wisdom card fallback text
  ///
  /// In en, this message translates to:
  /// **'Every breath is a gift. Practice with gratitude.'**
  String get wisdomFallback;

  /// History section header with count
  ///
  /// In en, this message translates to:
  /// **'History ({count})'**
  String historyCount(int count);

  /// Empty history hint text
  ///
  /// In en, this message translates to:
  /// **'Select your breath flow above to log your first entry'**
  String get firstEntryHint;

  /// Flow label in history entry
  ///
  /// In en, this message translates to:
  /// **'{flow} flow'**
  String flowLabel(String flow);

  /// Delete entry dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Entry?'**
  String get deleteEntry;

  /// Delete entry dialog body
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove this breath entry.'**
  String get deleteEntryMessage;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Timer inhale short label
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get timerIn;

  /// Timer exhale short label
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get timerOut;

  /// Breath timer title
  ///
  /// In en, this message translates to:
  /// **'Breath Timer'**
  String get breathTimer;

  /// Inhaling phase label
  ///
  /// In en, this message translates to:
  /// **'Inhaling...'**
  String get inhaling;

  /// Holding phase label
  ///
  /// In en, this message translates to:
  /// **'Holding...'**
  String get holding;

  /// Exhaling phase label
  ///
  /// In en, this message translates to:
  /// **'Exhaling...'**
  String get exhaling;

  /// Timer complete label
  ///
  /// In en, this message translates to:
  /// **'Complete!'**
  String get timerComplete;

  /// Timer idle instruction
  ///
  /// In en, this message translates to:
  /// **'Tap to start inhale'**
  String get tapToStartInhale;

  /// Timer inhale instruction
  ///
  /// In en, this message translates to:
  /// **'Tap when inhale complete'**
  String get tapWhenInhaleComplete;

  /// Timer hold instruction
  ///
  /// In en, this message translates to:
  /// **'Tap when ready to exhale'**
  String get tapWhenReadyToExhale;

  /// Timer exhale instruction
  ///
  /// In en, this message translates to:
  /// **'Tap when exhale complete'**
  String get tapWhenExhaleComplete;

  /// Timer complete instruction
  ///
  /// In en, this message translates to:
  /// **'Tap to reset'**
  String get tapToReset;

  /// Pacer active instruction
  ///
  /// In en, this message translates to:
  /// **'Breathe with the circle'**
  String get breatheWithCircle;

  /// Yama label prefix
  ///
  /// In en, this message translates to:
  /// **'Yama'**
  String get yamaPrefix;

  /// Sunday abbreviation
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get daySun;

  /// Monday abbreviation
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get dayMon;

  /// Tuesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayTue;

  /// Wednesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get dayWed;

  /// Thursday abbreviation
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayThu;

  /// Friday abbreviation
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get dayFri;

  /// Saturday abbreviation
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get daySat;

  /// Micro-advice when Sushumna aligned
  ///
  /// In en, this message translates to:
  /// **'Sushumna is active — perfect balance. Ideal for meditation and spiritual practice.'**
  String get adviceAlignedSushumna;

  /// Micro-advice when Solar aligned
  ///
  /// In en, this message translates to:
  /// **'Solar flow aligned! Lead with your RIGHT foot. Good time for action, exercise, and decision-making.'**
  String get adviceAlignedSolar;

  /// Micro-advice when Lunar aligned
  ///
  /// In en, this message translates to:
  /// **'Lunar flow aligned! Lead with your LEFT foot. Good time for creative work, rest, and nourishment.'**
  String get adviceAlignedLunar;

  /// Micro-advice when Solar expected but unaligned
  ///
  /// In en, this message translates to:
  /// **'Expected Solar (Right) but your Lunar is active. Try lying on your LEFT side to shift, or press your LEFT armpit gently.'**
  String get adviceUnalignedSolar;

  /// Micro-advice when Lunar expected but unaligned
  ///
  /// In en, this message translates to:
  /// **'Expected Lunar (Left) but your Solar is active. Try lying on your RIGHT side to shift, or press your RIGHT armpit gently.'**
  String get adviceUnalignedLunar;

  /// Birth bird state display on dashboard
  ///
  /// In en, this message translates to:
  /// **'Your {bird} — {state}'**
  String yourBirdState(String bird, String state);

  /// Guidance text for Ruling state
  ///
  /// In en, this message translates to:
  /// **'Peak power! Act boldly. Best time for important decisions.'**
  String get guidanceRuling;

  /// Guidance text for Eating state
  ///
  /// In en, this message translates to:
  /// **'Good time for preparation, learning, and gaining strength.'**
  String get guidanceEating;

  /// Guidance text for Walking state
  ///
  /// In en, this message translates to:
  /// **'Routine work is fine. Avoid critical decisions.'**
  String get guidanceWalking;

  /// Guidance text for Sleeping state
  ///
  /// In en, this message translates to:
  /// **'Rest and wait. Avoid important actions.'**
  String get guidanceSleeping;

  /// Guidance text for Dying state
  ///
  /// In en, this message translates to:
  /// **'Hard stop. Do not begin anything new.'**
  String get guidanceDying;

  /// Yama progress indicator
  ///
  /// In en, this message translates to:
  /// **'Yama {number} ({timeLeft} left)'**
  String yamaProgress(int number, String timeLeft);

  /// Rahu Kaal card title
  ///
  /// In en, this message translates to:
  /// **'Rahu Kaal'**
  String get rahuKaalTitle;

  /// Rahu Kaal active warning
  ///
  /// In en, this message translates to:
  /// **'Active now — avoid important decisions'**
  String get rahuKaalActive;

  /// Rahu Kaal starting soon hint
  ///
  /// In en, this message translates to:
  /// **'Starting soon'**
  String get rahuKaalSoon;

  /// Full day schedule card title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaysSchedule;

  /// Best yama indicator
  ///
  /// In en, this message translates to:
  /// **'Best time!'**
  String get bestTime;

  /// Current yama indicator
  ///
  /// In en, this message translates to:
  /// **'NOW'**
  String get now;

  /// Align27 comparison row
  ///
  /// In en, this message translates to:
  /// **'Align27: {bird} / {state}'**
  String align27Shows(String bird, String state);

  /// Nostril dominance chart title
  ///
  /// In en, this message translates to:
  /// **'Nostril Pattern'**
  String get nostrilPattern;

  /// Countdown to next nostril switch
  ///
  /// In en, this message translates to:
  /// **'Next switch: in {minutes} min'**
  String nextSwitch(int minutes);

  /// Nostril alignment status
  ///
  /// In en, this message translates to:
  /// **'Aligned'**
  String get alignedStatus;

  /// Hold time card title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Hold'**
  String get todaysHold;

  /// Average hold time display
  ///
  /// In en, this message translates to:
  /// **'{seconds}s avg ({count} entries)'**
  String avgHold(String seconds, int count);

  /// Empty state for today's hold card
  ///
  /// In en, this message translates to:
  /// **'No entries yet today'**
  String get noEntriesToday;

  /// Night yamas section header
  ///
  /// In en, this message translates to:
  /// **'Night Schedule'**
  String get nightYamas;

  /// Night guidance for Ruling state
  ///
  /// In en, this message translates to:
  /// **'Night Ruling — powerful time for meditation and spiritual practice.'**
  String get guidanceNightRuling;

  /// Night guidance for Eating state
  ///
  /// In en, this message translates to:
  /// **'Night nourishment — absorb wisdom, journal reflections.'**
  String get guidanceNightEating;

  /// Night guidance for Walking state
  ///
  /// In en, this message translates to:
  /// **'Neutral night period — light reading or gentle stretching.'**
  String get guidanceNightWalking;

  /// Night guidance for Sleeping state
  ///
  /// In en, this message translates to:
  /// **'Deep rest period — ideal for sleep.'**
  String get guidanceNightSleeping;

  /// Night guidance for Dying state
  ///
  /// In en, this message translates to:
  /// **'Night\'s lowest ebb — sleep deeply, let go completely.'**
  String get guidanceNightDying;

  /// Note shown in nostril chart during nighttime
  ///
  /// In en, this message translates to:
  /// **'Night — no expected nostril pattern'**
  String get nightNoNostrilPattern;

  /// Export/import section title in settings
  ///
  /// In en, this message translates to:
  /// **'Data Export / Import'**
  String get dataExportImportTitle;

  /// Export/import section subtitle
  ///
  /// In en, this message translates to:
  /// **'Transfer your data between devices or create a manual backup as a JSON file.'**
  String get dataExportImportSubtitle;

  /// Export button label
  ///
  /// In en, this message translates to:
  /// **'Export All Data'**
  String get exportAllData;

  /// Export in progress label
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exporting;

  /// Export success snackbar
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get exportSuccess;

  /// Import button label
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// Import in progress label
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get importing;

  /// Import confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Import Data?'**
  String get importConfirmTitle;

  /// Import confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'This will replace ALL existing data with the imported file.'**
  String get importConfirmMessage;

  /// Label for export date in summary
  ///
  /// In en, this message translates to:
  /// **'Exported on'**
  String get importExportedOn;

  /// Profile count label in import summary
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get importProfiles;

  /// Journal entry count in import summary
  ///
  /// In en, this message translates to:
  /// **'Journal entries'**
  String get importJournalEntries;

  /// Breath session count in import summary
  ///
  /// In en, this message translates to:
  /// **'Breath sessions'**
  String get importBreathSessions;

  /// Import warning text
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get importWarning;

  /// Import confirmation button
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importConfirmButton;

  /// Import success snackbar
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get importSuccess;

  /// Import failure prefix
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get importFailed;

  /// File read error on import
  ///
  /// In en, this message translates to:
  /// **'Could not read selected file'**
  String get importFailedReadFile;

  /// Validation error prefix on import
  ///
  /// In en, this message translates to:
  /// **'Invalid export file'**
  String get importInvalidFile;

  /// Analytics screen title
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// Weekly summary card title
  ///
  /// In en, this message translates to:
  /// **'Weekly Alignment'**
  String get weeklyAlignment;

  /// Weekly summary empty state
  ///
  /// In en, this message translates to:
  /// **'Log entries to see weekly alignment trends.'**
  String get weeklyAlignmentEmpty;

  /// Monthly patterns card title
  ///
  /// In en, this message translates to:
  /// **'Monthly Patterns (30 days)'**
  String get monthlyPatterns;

  /// Monthly patterns empty state
  ///
  /// In en, this message translates to:
  /// **'Practice for a few days to see patterns emerge.'**
  String get monthlyPatternsEmpty;

  /// Best day label in monthly patterns
  ///
  /// In en, this message translates to:
  /// **'Best day'**
  String get bestDay;

  /// Worst day label in monthly patterns
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get needsAttention;

  /// Most active yama label
  ///
  /// In en, this message translates to:
  /// **'Most active yama'**
  String get mostActiveYama;

  /// Least active yama label
  ///
  /// In en, this message translates to:
  /// **'Least active yama'**
  String get leastActiveYama;

  /// Active days stat label
  ///
  /// In en, this message translates to:
  /// **'Active days'**
  String get activeDays;

  /// Average per day stat label
  ///
  /// In en, this message translates to:
  /// **'Avg/day'**
  String get avgPerDay;

  /// Alignment stat label
  ///
  /// In en, this message translates to:
  /// **'Alignment'**
  String get alignment;

  /// Streak insights card title
  ///
  /// In en, this message translates to:
  /// **'Streak Insights'**
  String get streakInsights;

  /// Streak insights empty state
  ///
  /// In en, this message translates to:
  /// **'Start practicing to build streak insights.'**
  String get streakInsightsEmpty;

  /// Current streak label
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// Longest streak label
  ///
  /// In en, this message translates to:
  /// **'Longest'**
  String get longest;

  /// Total practice days label
  ///
  /// In en, this message translates to:
  /// **'Total days'**
  String get totalDays;

  /// Practice consistency label
  ///
  /// In en, this message translates to:
  /// **'Practice consistency'**
  String get practiceConsistency;

  /// Average gap label
  ///
  /// In en, this message translates to:
  /// **'Avg gap between sessions'**
  String get avgGapBetweenSessions;

  /// No gaps between sessions
  ///
  /// In en, this message translates to:
  /// **'No gaps'**
  String get noGaps;

  /// Days unit suffix
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// Yama performance card title
  ///
  /// In en, this message translates to:
  /// **'Yama Performance'**
  String get yamaPerformance;

  /// Yama performance subtitle
  ///
  /// In en, this message translates to:
  /// **'Which time of day you practice most'**
  String get yamaPerformanceSubtitle;

  /// Yama performance empty state
  ///
  /// In en, this message translates to:
  /// **'Log entries during different yamas to see breakdown.'**
  String get yamaPerformanceEmpty;

  /// Hold time card title
  ///
  /// In en, this message translates to:
  /// **'Hold Time Progression'**
  String get holdTimeProgression;

  /// Hold time empty state
  ///
  /// In en, this message translates to:
  /// **'Use the breath timer to track hold time improvement.'**
  String get holdTimeEmpty;

  /// Trend direction improving
  ///
  /// In en, this message translates to:
  /// **'Improving'**
  String get improving;

  /// Trend direction stable
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// Trend direction declining
  ///
  /// In en, this message translates to:
  /// **'Declining'**
  String get declining;

  /// This week stat label
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// This month stat label
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// Best ever stat label
  ///
  /// In en, this message translates to:
  /// **'Best ever'**
  String get bestEver;

  /// All-time average label
  ///
  /// In en, this message translates to:
  /// **'All-time average'**
  String get allTimeAverage;

  /// Total sessions label
  ///
  /// In en, this message translates to:
  /// **'Total sessions'**
  String get totalSessions;

  /// Personal best date label
  ///
  /// In en, this message translates to:
  /// **'Personal best date'**
  String get personalBestDate;

  /// Export card title
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// Export card subtitle
  ///
  /// In en, this message translates to:
  /// **'Download your complete journal history as a CSV file.'**
  String get exportDataSubtitle;

  /// Export CSV button label
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get exportAsCsv;

  /// CSV web limitation message
  ///
  /// In en, this message translates to:
  /// **'CSV export is available on mobile devices'**
  String get csvExportWebOnly;

  /// Export success with path
  ///
  /// In en, this message translates to:
  /// **'Exported to: {path}'**
  String exportedTo(String path);

  /// Export failure prefix
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// App tagline in About card
  ///
  /// In en, this message translates to:
  /// **'The Treasure House of Breath'**
  String get aboutTagline;

  /// Developer label
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get aboutDeveloper;

  /// Contact label
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get aboutContact;

  /// Website label
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get aboutWebsite;

  /// User Guide link label
  ///
  /// In en, this message translates to:
  /// **'User Guide'**
  String get aboutUserGuide;

  /// Privacy Policy link label
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacyPolicy;

  /// Built in footer text
  ///
  /// In en, this message translates to:
  /// **'Built with 🙏 in India'**
  String get aboutBuiltIn;

  /// Copyright notice
  ///
  /// In en, this message translates to:
  /// **'© 2026 Eialarasu. All rights reserved.'**
  String get aboutCopyright;

  /// Intro screen tagline
  ///
  /// In en, this message translates to:
  /// **'The Treasure House of Breath'**
  String get introTagline;

  /// Intro section title
  ///
  /// In en, this message translates to:
  /// **'What is Saranidhi?'**
  String get introWhatTitle;

  /// Intro what is section body
  ///
  /// In en, this message translates to:
  /// **'Saranidhi (Tamil: ஸரநிதி) means \'The Treasure House of Breath\'. It is a spiritual life-guidance app rooted in the ancient Tamil sciences of Sara Kalai (breath science) and Panja Pakshi Shastra (five birds system).\n\nBy observing which nostril is dominant and aligning your actions with cosmic rhythms, you can make better decisions, find optimal timing, and deepen your spiritual practice.'**
  String get introWhatBody;

  /// Intro how it works section title
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get introHowTitle;

  /// Intro how bullet 1
  ///
  /// In en, this message translates to:
  /// **'Your birth star (nakshatra) determines your personal Pakshi bird — it governs your daily energy cycles.'**
  String get introHowBullet1;

  /// Intro how bullet 2
  ///
  /// In en, this message translates to:
  /// **'Each day is divided into 5 Yamas (time segments). Your bird cycles through 5 states: Ruling, Eating, Walking, Sleeping, Dying.'**
  String get introHowBullet2;

  /// Intro how bullet 3
  ///
  /// In en, this message translates to:
  /// **'Track your breath flow (left/right nostril) and align it with the cosmic pattern for optimal living.'**
  String get introHowBullet3;

  /// Intro what you need section title
  ///
  /// In en, this message translates to:
  /// **'What You\'ll Need'**
  String get introNeedTitle;

  /// Intro need bullet 1
  ///
  /// In en, this message translates to:
  /// **'Your birth star (nakshatra) or date of birth — to determine your Pakshi bird.'**
  String get introNeedBullet1;

  /// Intro need bullet 2
  ///
  /// In en, this message translates to:
  /// **'Your current city — for accurate sunrise/sunset times (all data stays on your device).'**
  String get introNeedBullet2;

  /// Get Started button on intro screen
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get introGetStarted;

  /// User Guide screen title
  ///
  /// In en, this message translates to:
  /// **'User Guide'**
  String get guideTitle;

  /// Guide section 1 title
  ///
  /// In en, this message translates to:
  /// **'What is Saranidhi?'**
  String get guideWhatTitle;

  /// Guide section 1 body
  ///
  /// In en, this message translates to:
  /// **'Saranidhi (ஸரநிதி) means \'The Treasure House of Breath\' in Tamil. The name combines \'Sara\' (breath/essence, from Sara Kalai) and \'Nidhi\' (treasure/storehouse).\n\nThis app helps you align your daily actions with ancient Vedic breath rhythms and the Panja Pakshi (Five Birds) system — a time-tested framework for optimal living passed down through Tamil spiritual traditions.'**
  String get guideWhatBody;

  /// Guide section 2 title
  ///
  /// In en, this message translates to:
  /// **'The Science Behind It'**
  String get guideScienceTitle;

  /// Guide section 2 body
  ///
  /// In en, this message translates to:
  /// **'Saranidhi is based on two ancient sciences:\n\n• Siva Swarodaya (Sara Kalai) — The science of breath flow (Saram). Your dominant nostril (Idakalai/Left or Pingalai/Right) cycles throughout the day and influences your energy, decision-making, and well-being. When both flow equally, the sacred Suzhumunai state is active.\n\n• Panja Pakshi Shastra — The Five Birds system. Based on your birth nakshatra, you are assigned one of five birds (Vulture, Owl, Crow, Rooster, Peacock) that governs your daily energy cycle through five states (Arasu, Uun, Nadai, Thuyil, Saavu).'**
  String get guideScienceBody;

  /// Guide section 3 title
  ///
  /// In en, this message translates to:
  /// **'Your Birth Bird'**
  String get guideBirdTitle;

  /// Guide section 3 body
  ///
  /// In en, this message translates to:
  /// **'Your birth star (nakshatra) determines your personal Pakshi bird. Each of the 27 nakshatras maps to one of five birds:\n\n🦅 Vulture (Hawk) — Sharp, decisive, powerful\n🦉 Owl — Wise, nocturnal, intuitive\n🐦‍⬛ Crow — Adaptable, intelligent, resourceful\n🐓 Rooster (Cock) — Disciplined, alert, punctual\n🦚 Peacock — Graceful, creative, expressive\n\nYour bird is fixed from birth and determines how your energy cycles through the day.'**
  String get guideBirdBody;

  /// Guide section 4 title
  ///
  /// In en, this message translates to:
  /// **'Daily Rhythm'**
  String get guideRhythmTitle;

  /// Guide section 4 body
  ///
  /// In en, this message translates to:
  /// **'Each day (sunrise to sunset) is divided into 5 equal time segments called Yamas (Yaamam). Your bird cycles through 5 states in each Yama:\n\n👑 Arasu (Ruling) — Peak power! Best time for important decisions and bold action. [Artha window]\n🍽️ Uun (Eating) — Preparation time. Good for learning and gaining strength. [Kriya window]\n🚶 Nadai (Walking) — Routine work. Avoid critical decisions. [Artha window]\n💤 Thuyil (Sleeping) — Rest period. Avoid important actions. [Yoga window]\n💀 Saavu (Dying) — Lowest energy. Do not begin anything new. [Yoga window]\n\nThe night (sunset to sunrise) has another 5 Yamas with its own cycle. The app shows both day and night schedules.'**
  String get guideRhythmBody;

  /// Guide section 5 title
  ///
  /// In en, this message translates to:
  /// **'How to Use the App'**
  String get guideHowToTitle;

  /// Guide section 5 body
  ///
  /// In en, this message translates to:
  /// **'1. Check your Today tab each morning to see your bird\'s state schedule for the day.\n\n2. Note your Ruling time — plan important activities during this window.\n\n3. Avoid starting new things during Dying or Rahu Kaal periods.\n\n4. Log your breath flow (which nostril is dominant) to track alignment with cosmic patterns.\n\n5. Use the Breath Timer for conscious breathing practice — builds awareness and extends hold time.\n\n6. Check the Explore tab for historical data and best times this week.'**
  String get guideHowToBody;

  /// Guide section 6 title
  ///
  /// In en, this message translates to:
  /// **'Best Practices'**
  String get guideBestTitle;

  /// Guide section 6 body
  ///
  /// In en, this message translates to:
  /// **'• Check in at each Yama transition (the app can notify you).\n• Use your Ruling period for important meetings, decisions, and creative work.\n• During Sleeping/Dying periods, focus on routine tasks or rest.\n• Log your breath at least once per Yama to build alignment awareness.\n• Practice the Quick Sync Pacer if your nostril flow is unaligned.\n• Review your weekly alignment in the Analytics tab to spot patterns.\n• Export your data regularly as a backup (Settings → Export).'**
  String get guideBestBody;

  /// Guide section: Grounding foot step rule
  ///
  /// In en, this message translates to:
  /// **'Swara Pada Gamana (Grounding Step)'**
  String get guidePadaGamanaTitle;

  /// Guide Swara Pada Gamana section body
  ///
  /// In en, this message translates to:
  /// **'The Siva Swarodaya teaches that the first physical contact with the earth upon waking determines the energetic trajectory of the day.\n\n• Upon waking, check which nostril is dominant.\n• If the Right Nostril (Pingalai/Surya) is active: Touch the right side of your face, then place your RIGHT foot on the ground first.\n• If the Left Nostril (Idakalai/Chandra) is active: Touch the left side of your face, then place your LEFT foot on the ground first.\n\nThis simple ritual anchors you in somatic awareness the moment you open your eyes — shifting from reactivity to intentional living. It\'s a physical grounding technique that combats morning anxiety and encourages mindfulness before reaching for your phone.'**
  String get guidePadaGamanaBody;

  /// Guide section: Dietary chronobiology
  ///
  /// In en, this message translates to:
  /// **'Swara-Ahara (Dietary Alignment)'**
  String get guideSwaraAharaTitle;

  /// Guide Swara-Ahara section body
  ///
  /// In en, this message translates to:
  /// **'In Swara science, digestion is governed by Jatharagni (internal digestive fire), closely tied to the Right Nostril (Pingalai/Surya) channel.\n\n• Eat solid food when the RIGHT nostril is active — metabolic heat is high, aiding digestion and nutrient absorption.\n• Drink water and cooling liquids when the LEFT nostril is active — the body is in receptive, cooling mode.\n• Eating when the LEFT nostril dominates leads to slow metabolism, sluggishness, and poor absorption.\n\nIf you need to eat but your left nostril is active:\n1. Lie on your LEFT side for 3 minutes, OR\n2. Apply gentle pressure under your LEFT armpit.\n\nThis shifts breath to the right nostril, preparing your stomach for digestion. The app shows your current nostril pattern — use it before meals!'**
  String get guideSwaraAharaBody;

  /// Guide section 7 title
  ///
  /// In en, this message translates to:
  /// **'Understanding the Dashboard'**
  String get guideDashboardTitle;

  /// Guide section 7 body
  ///
  /// In en, this message translates to:
  /// **'• Bird Card — Shows your birth bird\'s current state (Arasu/Uun/Nadai/Thuyil/Saavu) and guidance text.\n• Rahu Kaal — The inauspicious window to avoid new beginnings (changes daily).\n• Day Schedule — Full 10-Yama view showing bird state at each time slot.\n• Nostril Pattern — Expected Pingalai (Solar) or Idakalai (Lunar) dominance per Yama.\n• Daily Wisdom — Spiritual insight tailored to your context.\n• Hold Time — Your average breath hold duration today.\n• Streak — Consecutive days with aligned entries.\n• 7-Day Ribbon — Visual week overview of your practice.'**
  String get guideDashboardBody;

  /// Guide section 8 title
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get guideBenefitsTitle;

  /// Guide section 8 body
  ///
  /// In en, this message translates to:
  /// **'• Cosmic Timing — Know the best moment to act, rest, or wait.\n• Self-Awareness — Develop sensitivity to your breath and energy patterns.\n• Better Decisions — Use Ruling periods for important choices.\n• Consistency — Build a daily practice with streaks and visual feedback.\n• Privacy — All your data stays on your device. No servers, no tracking.\n• Ancient Wisdom, Modern App — Traditional Sara Kalai science in a clean, accessible format.'**
  String get guideBenefitsBody;

  /// Guide section 9 title
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get guideFaqTitle;

  /// No description provided for @guideFaqBody.
  ///
  /// In en, this message translates to:
  /// **'Q: How accurate are the calculations?\nA: Saranidhi uses the Jean Meeus astronomical algorithm for Moon position and authentic Panja Pakshi lookup tables from Prof. Dr. U.S. Pulippani\'s research. Accuracy is within ±0.5°.\n\nQ: Does it work offline?\nA: Yes! All calculations run on your device. No internet needed.\n\nQ: Is my data private?\nA: Absolutely. Your data never leaves your device unless you choose to back up to your own iCloud/Google Drive.\n\nQ: What if I don\'t know my birth star?\nA: Use the \'Calculate from DOB\' option during onboarding — enter your date and time of birth and the app will determine your nakshatra.\n\nQ: What is Rahu Kaal?\nA: A daily inauspicious window (about 90 minutes) based on Vedic astrology. Avoid starting new activities during this time.\n\nQ: Can I use this outside India?\nA: Yes! The app works anywhere. Sunrise/sunset are calculated for your location. Preset cities are Indian, but any latitude/longitude works.\n\nQ: How do I export my data?\nA: Settings → Data Export/Import → Export All Data. This creates a JSON file you can save or share.'**
  String get guideFaqBody;

  /// Journal empty state title when no entries exist
  ///
  /// In en, this message translates to:
  /// **'Begin Your Breath Journey'**
  String get journalEmptyTitle;

  /// Journal empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Track your nostril dominance throughout the day to discover your natural alignment with cosmic rhythms.'**
  String get journalEmptySubtitle;

  /// Journal empty state action hint
  ///
  /// In en, this message translates to:
  /// **'Start by selecting your nostril flow above'**
  String get journalEmptyHint;

  /// Analytics empty state title
  ///
  /// In en, this message translates to:
  /// **'Your Insights Await'**
  String get analyticsEmptyTitle;

  /// Analytics empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Log a few breath entries in the Journal tab to unlock patterns, trends, and personalized insights about your practice.'**
  String get analyticsEmptySubtitle;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorSomethingWentWrong;

  /// Generic error subtitle
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorTryAgainLater;

  /// Explore tab empty state title for selected date
  ///
  /// In en, this message translates to:
  /// **'No entries on this day'**
  String get exploreNoEntriesTitle;

  /// Explore tab empty state hint
  ///
  /// In en, this message translates to:
  /// **'Navigate to this date\'s Journal tab to log past entries, or explore other dates.'**
  String get exploreNoEntriesHint;

  /// Streak zero-state title for new users
  ///
  /// In en, this message translates to:
  /// **'Build Your Streak'**
  String get streakZeroTitle;

  /// Streak zero-state subtitle
  ///
  /// In en, this message translates to:
  /// **'Consistency is the key to alignment awareness.'**
  String get streakZeroSubtitle;

  /// Streak onboarding step 1
  ///
  /// In en, this message translates to:
  /// **'Log your breath flow once per day'**
  String get streakStep1;

  /// Streak onboarding step 2
  ///
  /// In en, this message translates to:
  /// **'Each aligned day adds to your streak'**
  String get streakStep2;

  /// Streak onboarding step 3
  ///
  /// In en, this message translates to:
  /// **'Watch your consistency grow over time'**
  String get streakStep3;

  /// Streak milestone celebration title
  ///
  /// In en, this message translates to:
  /// **'Amazing!'**
  String get celebrationTitle;

  /// Milestone streak count
  ///
  /// In en, this message translates to:
  /// **'{days}-Day Streak!'**
  String celebrationMilestone(int days);

  /// Celebration dismiss hint
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to dismiss'**
  String get celebrationTapToDismiss;

  /// 7-day milestone message
  ///
  /// In en, this message translates to:
  /// **'One week of consistent practice. You\'re building a habit!'**
  String get celebrationWeek;

  /// 30-day milestone message
  ///
  /// In en, this message translates to:
  /// **'A full month of alignment awareness. Incredible dedication!'**
  String get celebrationMonth;

  /// 100-day milestone message
  ///
  /// In en, this message translates to:
  /// **'100 days! You\'ve mastered the daily rhythm. True practitioner.'**
  String get celebration100;

  /// 365-day milestone message
  ///
  /// In en, this message translates to:
  /// **'One year of practice. You are the breath. Namaste.'**
  String get celebrationYear;

  /// Generic milestone message
  ///
  /// In en, this message translates to:
  /// **'Keep going! Every day counts.'**
  String get celebrationGeneric;

  /// Manual timer mode (free-form)
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get presetManual;

  /// 4-7-8 relaxing breath preset name
  ///
  /// In en, this message translates to:
  /// **'4-7-8'**
  String get preset478;

  /// Box breathing preset name
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get presetBox;

  /// Energizing breath preset name
  ///
  /// In en, this message translates to:
  /// **'Energize'**
  String get presetEnergizing;

  /// Calming breath preset name
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get presetCalming;

  /// Timer title when using a preset
  ///
  /// In en, this message translates to:
  /// **'Guided: {name}'**
  String presetTimerTitle(String name);

  /// Daily summary card title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Practice'**
  String get dailySummaryTitle;

  /// Daily summary entries label
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get dailySummaryEntries;

  /// Daily summary alignment label
  ///
  /// In en, this message translates to:
  /// **'Aligned'**
  String get dailySummaryAlignment;

  /// Daily summary hold time label
  ///
  /// In en, this message translates to:
  /// **'Avg Hold'**
  String get dailySummaryHold;

  /// Pin/star entry action label
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pinEntry;

  /// Unpin entry action label
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpinEntry;

  /// Pinned entries section header
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinnedEntries;

  /// What's New screen title
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get whatsNewTitle;

  /// What's New dismiss button
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get whatsNewDismiss;

  /// What's New feature: celebrations
  ///
  /// In en, this message translates to:
  /// **'Streak Celebrations'**
  String get whatsNewCelebrations;

  /// What's New celebrations description
  ///
  /// In en, this message translates to:
  /// **'Hit 7, 30, or 100 days and get a celebratory moment!'**
  String get whatsNewCelebrationsDesc;

  /// What's New feature: timer presets
  ///
  /// In en, this message translates to:
  /// **'Breathing Presets'**
  String get whatsNewTimerPresets;

  /// What's New timer presets description
  ///
  /// In en, this message translates to:
  /// **'Choose 4-7-8, Box Breathing, or other guided patterns.'**
  String get whatsNewTimerPresetsDesc;

  /// What's New feature: daily summary
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get whatsNewDailySummary;

  /// What's New daily summary description
  ///
  /// In en, this message translates to:
  /// **'See your entries, alignment, and hold time at a glance.'**
  String get whatsNewDailySummaryDesc;

  /// What's New feature: pin entries
  ///
  /// In en, this message translates to:
  /// **'Pin Favourite Entries'**
  String get whatsNewPinEntries;

  /// What's New pin entries description
  ///
  /// In en, this message translates to:
  /// **'Star your best moments for quick reference.'**
  String get whatsNewPinEntriesDesc;

  /// What's New feature: night schedule
  ///
  /// In en, this message translates to:
  /// **'Night Schedule Always Visible'**
  String get whatsNewNightSchedule;

  /// What's New night schedule description
  ///
  /// In en, this message translates to:
  /// **'Full 10-yama schedule (day + night) shown at all times.'**
  String get whatsNewNightScheduleDesc;

  /// What's New feature: performance
  ///
  /// In en, this message translates to:
  /// **'Safari & Performance Fixes'**
  String get whatsNewPerformance;

  /// What's New performance description
  ///
  /// In en, this message translates to:
  /// **'App now works on all browsers. Faster loading.'**
  String get whatsNewPerformanceDesc;

  /// Guided nostril test step 1 title
  ///
  /// In en, this message translates to:
  /// **'Exhale Test'**
  String get nostrilTestStep1Title;

  /// Step 1 instruction
  ///
  /// In en, this message translates to:
  /// **'Close your mouth. Exhale gently through your nose. Which nostril feels more air flow?'**
  String get nostrilTestStep1Instruction;

  /// Right nostril choice
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get nostrilTestRight;

  /// Left nostril choice
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get nostrilTestLeft;

  /// Both nostrils equal choice
  ///
  /// In en, this message translates to:
  /// **'Equal'**
  String get nostrilTestBoth;

  /// Guided nostril test step 2 title
  ///
  /// In en, this message translates to:
  /// **'Isolation Test'**
  String get nostrilTestStep2Title;

  /// Step 2 instruction
  ///
  /// In en, this message translates to:
  /// **'Block one nostril with your finger. Breathe through the other. Now switch. Which side flows more freely?'**
  String get nostrilTestStep2Instruction;

  /// Confirm right nostril dominant
  ///
  /// In en, this message translates to:
  /// **'Right is stronger'**
  String get nostrilTestConfirmRight;

  /// Confirm left nostril dominant
  ///
  /// In en, this message translates to:
  /// **'Left is stronger'**
  String get nostrilTestConfirmLeft;

  /// Step 3 result title
  ///
  /// In en, this message translates to:
  /// **'Your Dominant Flow'**
  String get nostrilTestResultTitle;

  /// Confirm and use detected flow
  ///
  /// In en, this message translates to:
  /// **'Use This Flow'**
  String get nostrilTestConfirm;

  /// Reset the guided nostril test to step 1
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get nostrilTestRestart;

  /// Button to launch guided nostril test
  ///
  /// In en, this message translates to:
  /// **'Guide me'**
  String get guideMeButton;

  /// Sushumna aligned in Yoga window advice
  ///
  /// In en, this message translates to:
  /// **'Sushumna is active during a Yoga window — perfect alignment! Deep meditation and spiritual practice are highly favored now.'**
  String get adviceSushumnaAligned;

  /// Sushumna blocked in Artha/Kriya window advice
  ///
  /// In en, this message translates to:
  /// **'Sushumna is active but the current window calls for outward action. The balanced state opposes material or physical tasks — consider waiting for the next Yoga window.'**
  String get adviceSushumnaBlocked;

  /// Sun hora planet name
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get planetSun;

  /// Moon hora planet name
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get planetMoon;

  /// Mars hora planet name
  ///
  /// In en, this message translates to:
  /// **'Mars'**
  String get planetMars;

  /// Mercury hora planet name
  ///
  /// In en, this message translates to:
  /// **'Mercury'**
  String get planetMercury;

  /// Jupiter hora planet name
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get planetJupiter;

  /// Venus hora planet name
  ///
  /// In en, this message translates to:
  /// **'Venus'**
  String get planetVenus;

  /// Saturn hora planet name
  ///
  /// In en, this message translates to:
  /// **'Saturn'**
  String get planetSaturn;

  /// Earth tattva name
  ///
  /// In en, this message translates to:
  /// **'Prithvi'**
  String get tattvaEarth;

  /// Water tattva name
  ///
  /// In en, this message translates to:
  /// **'Apas'**
  String get tattvaWater;

  /// Fire tattva name
  ///
  /// In en, this message translates to:
  /// **'Tejas'**
  String get tattvaFire;

  /// Air tattva name
  ///
  /// In en, this message translates to:
  /// **'Vayu'**
  String get tattvaAir;

  /// Ether tattva name
  ///
  /// In en, this message translates to:
  /// **'Akasha'**
  String get tattvaEther;

  /// Recalculate birth star from date of birth option
  ///
  /// In en, this message translates to:
  /// **'Recalculate from DOB'**
  String get recalculateFromDob;

  /// DOB date picker label
  ///
  /// In en, this message translates to:
  /// **'Select birth date'**
  String get selectBirthDate;

  /// DOB time picker label
  ///
  /// In en, this message translates to:
  /// **'Select birth time (optional)'**
  String get selectBirthTime;

  /// DOB recalculate confirm button
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get recalculateButton;

  /// Onboarding step 2 title
  ///
  /// In en, this message translates to:
  /// **'Find Your Bird'**
  String get findYourBirdTitle;

  /// Segmented button: manual nakshatra selection
  ///
  /// In en, this message translates to:
  /// **'I know my star'**
  String get iKnowMyStar;

  /// Segmented button: auto-calculate from date of birth
  ///
  /// In en, this message translates to:
  /// **'Calculate from DOB'**
  String get calculateFromDob;

  /// Tab: derive bird from name (vowel method)
  ///
  /// In en, this message translates to:
  /// **'From name'**
  String get calculateFromName;

  /// Short tab label for manual nakshatra selection
  ///
  /// In en, this message translates to:
  /// **'My star'**
  String get iKnowMyStarShort;

  /// Short tab label for DOB calculation
  ///
  /// In en, this message translates to:
  /// **'From DOB'**
  String get calculateFromDobShort;

  /// Hint text for name-based bird derivation
  ///
  /// In en, this message translates to:
  /// **'Enter your name — your bird is derived from the first vowel sound (traditional vowel method).'**
  String get nameMethodHint;

  /// Accuracy caveat for name method
  ///
  /// In en, this message translates to:
  /// **'Note: the name method is a fallback and less precise than nakshatra or DOB.'**
  String get nameMethodNote;

  /// Button to derive bird from name
  ///
  /// In en, this message translates to:
  /// **'Find My Bird'**
  String get deriveBirdFromName;

  /// Summary step title
  ///
  /// In en, this message translates to:
  /// **'Review & Confirm'**
  String get onboardingSummaryTitle;

  /// Summary step subtitle
  ///
  /// In en, this message translates to:
  /// **'Please review your details. Tap Edit to change anything.'**
  String get onboardingSummarySubtitle;

  /// Summary row: name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get summaryName;

  /// Summary row: bird
  ///
  /// In en, this message translates to:
  /// **'Birth Bird'**
  String get summaryBird;

  /// Summary row: location
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get summaryLocation;

  /// Summary row: storage mode
  ///
  /// In en, this message translates to:
  /// **'Data Storage'**
  String get summaryStorage;

  /// Placeholder when a field is empty
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get summaryNotSet;

  /// Bird derivation source: manual nakshatra
  ///
  /// In en, this message translates to:
  /// **'from birth star'**
  String get summaryDerivedFromStar;

  /// Bird derivation source: DOB
  ///
  /// In en, this message translates to:
  /// **'from date of birth'**
  String get summaryDerivedFromDob;

  /// Bird derivation source: name
  ///
  /// In en, this message translates to:
  /// **'from name'**
  String get summaryDerivedFromName;

  /// Edit button on summary rows
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// DOB date field placeholder
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// DOB date field subtitle
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get birthDateLabel;

  /// DOB time field placeholder
  ///
  /// In en, this message translates to:
  /// **'Select time (optional)'**
  String get selectTimeOptional;

  /// DOB time field subtitle
  ///
  /// In en, this message translates to:
  /// **'Birth time (for precise nakshatra)'**
  String get birthTimeLabel;

  /// DOB calculate button
  ///
  /// In en, this message translates to:
  /// **'Calculate Nakshatra'**
  String get calculateNakshatra;

  /// Location step instruction text
  ///
  /// In en, this message translates to:
  /// **'Where are you now? (for daily sunrise/sunset)'**
  String get locationSubtitle;

  /// Kuligai Kaal card title
  ///
  /// In en, this message translates to:
  /// **'Kuligai'**
  String get kuligaiKaalTitle;

  /// Emakandam (Yama Kandam) title
  ///
  /// In en, this message translates to:
  /// **'Emakandam'**
  String get emakandamTitle;

  /// Waxing moon phase label
  ///
  /// In en, this message translates to:
  /// **'Waxing'**
  String get moonWaxing;

  /// Waning moon phase label
  ///
  /// In en, this message translates to:
  /// **'Waning'**
  String get moonWaning;

  /// Best Times This Week card title
  ///
  /// In en, this message translates to:
  /// **'Best Times This Week'**
  String get bestTimesTitle;

  /// Day schedule card title (pairs with Night Schedule)
  ///
  /// In en, this message translates to:
  /// **'Day Schedule'**
  String get daySchedule;

  /// Sushumna meditation advice when timer disabled
  ///
  /// In en, this message translates to:
  /// **'Sushumna active — sacred observation. Sit in stillness, meditate.'**
  String get sushumnaAdvice;

  /// Cancel timer button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelTimer;

  /// Tattva Earth with Sanskrit
  ///
  /// In en, this message translates to:
  /// **'Earth / Prithvi'**
  String get tattvaEarthEnglish;

  /// Tattva Water with Sanskrit
  ///
  /// In en, this message translates to:
  /// **'Water / Apas'**
  String get tattvaWaterEnglish;

  /// Tattva Fire with Sanskrit
  ///
  /// In en, this message translates to:
  /// **'Fire / Tejas'**
  String get tattvaFireEnglish;

  /// Tattva Air with Sanskrit
  ///
  /// In en, this message translates to:
  /// **'Air / Vayu'**
  String get tattvaAirEnglish;

  /// Tattva Ether with Sanskrit
  ///
  /// In en, this message translates to:
  /// **'Ether / Akasha'**
  String get tattvaEtherEnglish;

  /// DOB calculation result
  ///
  /// In en, this message translates to:
  /// **'Calculated: {name}'**
  String calculatedNakshatra(String name);

  /// DOB calculation moon position
  ///
  /// In en, this message translates to:
  /// **'Moon sidereal longitude: {degrees}°'**
  String moonSiderealLongitude(String degrees);

  /// Warning when calculated nakshatra is near boundary
  ///
  /// In en, this message translates to:
  /// **'Near nakshatra boundary — birth time accuracy is important. Verify with a panchangam if unsure.'**
  String get nearBoundaryWarning;

  /// Import version mismatch error
  ///
  /// In en, this message translates to:
  /// **'This file was exported from a newer version (v{version}). Please update the app before importing.'**
  String importVersionMismatch(int version);

  /// The science of breath flow (Sara Kalai)
  ///
  /// In en, this message translates to:
  /// **'Saram'**
  String get termSaramTitle;

  /// Saram concept description
  ///
  /// In en, this message translates to:
  /// **'The sacred science of breath flow through the nostrils. Also known as Swara or Sara Kalai.'**
  String get termSaramDescription;

  /// Left/Lunar nostril channel — Ida in Sanskrit
  ///
  /// In en, this message translates to:
  /// **'Idakalai'**
  String get termIdakalai;

  /// Idakalai full description
  ///
  /// In en, this message translates to:
  /// **'The left nostril channel (Ida Nadi). Carries lunar, cooling, receptive energy. Ideal for creative work, rest, and nourishment.'**
  String get termIdakalaiDescription;

  /// Right/Solar nostril channel — Pingala in Sanskrit
  ///
  /// In en, this message translates to:
  /// **'Pingalai'**
  String get termPingalai;

  /// Pingalai full description
  ///
  /// In en, this message translates to:
  /// **'The right nostril channel (Pingala Nadi). Carries solar, heating, kinetic energy. Ideal for action, digestion, and decision-making.'**
  String get termPingalaiDescription;

  /// Central channel — Sushumna in Sanskrit
  ///
  /// In en, this message translates to:
  /// **'Suzhumunai'**
  String get termSuzhumunai;

  /// Suzhumunai full description
  ///
  /// In en, this message translates to:
  /// **'The central channel (Sushumna Nadi). Active when both nostrils flow equally. A rare, sacred neutral state ideal for meditation and spiritual practice.'**
  String get termSuzhumunaiDescription;

  /// Five Birds system title
  ///
  /// In en, this message translates to:
  /// **'Panja Pakshi'**
  String get termPanjaPakshi;

  /// Panja Pakshi concept description
  ///
  /// In en, this message translates to:
  /// **'The ancient Tamil Five Birds system (Panja Pakshi Shastra). Maps cosmic biological rhythms through five bird archetypes based on your birth star.'**
  String get termPanjaPakshiDescription;

  /// Tamil term for Ruling bird state
  ///
  /// In en, this message translates to:
  /// **'Arasu (Ruling)'**
  String get termArasu;

  /// Tamil term for Eating bird state
  ///
  /// In en, this message translates to:
  /// **'Uun (Eating)'**
  String get termUun;

  /// Tamil term for Walking bird state
  ///
  /// In en, this message translates to:
  /// **'Nadai (Walking)'**
  String get termNadai;

  /// Tamil term for Sleeping bird state
  ///
  /// In en, this message translates to:
  /// **'Thuyil (Sleeping)'**
  String get termThuyil;

  /// Tamil term for Dying bird state
  ///
  /// In en, this message translates to:
  /// **'Saavu (Dying)'**
  String get termSaavu;

  /// Traditional time segment (1/5 of day or night)
  ///
  /// In en, this message translates to:
  /// **'Yaamam'**
  String get termYaamam;

  /// Yaamam concept description
  ///
  /// In en, this message translates to:
  /// **'A traditional Tamil time unit. Saranidhi divides daylight (sunrise→sunset) and night (sunset→sunrise) each into 5 equal Yamas. Your bird cycles through its states in each Yama.'**
  String get termYaamamDescription;

  /// Planetary hour — Hora in Sanskrit
  ///
  /// In en, this message translates to:
  /// **'Horai'**
  String get termHorai;

  /// Horai concept description
  ///
  /// In en, this message translates to:
  /// **'Planetary hours that partition each day into 24 segments, each ruled by a celestial body (Sun, Moon, Mars, Mercury, Jupiter, Venus, Saturn).'**
  String get termHoraiDescription;

  /// Five elements concept — Tattva in Sanskrit
  ///
  /// In en, this message translates to:
  /// **'Tattvam'**
  String get termTattvam;

  /// Tattvam concept description
  ///
  /// In en, this message translates to:
  /// **'The five primordial elements (Earth, Water, Fire, Air, Ether) that cycle within each breath period, modifying your energy and focus.'**
  String get termTattvamDescription;

  /// Action window: material achievement / executive function
  ///
  /// In en, this message translates to:
  /// **'Artha'**
  String get termArtha;

  /// Artha window description
  ///
  /// In en, this message translates to:
  /// **'The window of material achievement and executive function. Active during Ruling and Walking bird states. Best for decisions, negotiations, coding, and physical action.'**
  String get termArthaDescription;

  /// Action window: nourishment / receptive focus
  ///
  /// In en, this message translates to:
  /// **'Kriya'**
  String get termKriya;

  /// Kriya window description
  ///
  /// In en, this message translates to:
  /// **'The window of nourishment and receptive focus. Active during the Eating bird state. Best for study, exercise, meals, and gathering information.'**
  String get termKriyaDescription;

  /// Action window: rest / spiritual practice
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get termYoga;

  /// Yoga window description
  ///
  /// In en, this message translates to:
  /// **'The window of rest and inward reflection. Active during Sleeping and Dying bird states. Best for meditation, brainstorming, emotional release, and sleep.'**
  String get termYogaDescription;

  /// Lunar mansion / birth star
  ///
  /// In en, this message translates to:
  /// **'Nakshatra'**
  String get termNakshatra;

  /// Nakshatra concept description
  ///
  /// In en, this message translates to:
  /// **'Your birth star — one of 27 sidereal lunar mansions. Determines your permanent Panja Pakshi birth bird and daily energy patterns.'**
  String get termNakshatraDescription;

  /// Inauspicious time window
  ///
  /// In en, this message translates to:
  /// **'Rahu Kaal'**
  String get termRahuKaal;

  /// Rahu Kaal concept description
  ///
  /// In en, this message translates to:
  /// **'A daily inauspicious window (~90 minutes) based on Vedic astrology. Avoid starting new activities or making important decisions during this time.'**
  String get termRahuKaalDescription;

  /// Grounding foot step ritual
  ///
  /// In en, this message translates to:
  /// **'Swara Pada Gamana'**
  String get termSwaraPadaGamana;

  /// Dietary chronobiology — digestive fire alignment
  ///
  /// In en, this message translates to:
  /// **'Swara-Ahara'**
  String get termSwaraAhara;

  /// Focus card guidance for Artha window
  ///
  /// In en, this message translates to:
  /// **'Negotiate, decide, execute. Your bird is in action mode — material tasks are cosmically favored.'**
  String get focusCardArthaAdvice;

  /// Focus card guidance for Kriya window
  ///
  /// In en, this message translates to:
  /// **'Nourish body and mind. Eat mindfully, exercise, study, or absorb information.'**
  String get focusCardKriyaAdvice;

  /// Focus card guidance for Yoga window
  ///
  /// In en, this message translates to:
  /// **'Turn inward. Rest, meditate, practice breath work, or brainstorm. Avoid new commitments.'**
  String get focusCardYogaAdvice;

  /// Focus card warning when Rahu blocks the window
  ///
  /// In en, this message translates to:
  /// **'Rahu Kaal active — avoid starting anything new. Observe and reflect until it passes.'**
  String get focusCardRahuBlocked;

  /// Bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Action Window Details'**
  String get actionWindowSheetTitle;

  /// Action Bar card title on Today tab
  ///
  /// In en, this message translates to:
  /// **'Action Windows'**
  String get actionWindowsTitle;

  /// Schedule section header in bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Today’s Schedule'**
  String get actionWindowSheetSchedule;

  /// Localized duration in minutes
  ///
  /// In en, this message translates to:
  /// **'{count}min'**
  String durationMinutes(int count);

  /// Waxing moon fortnight (Shukla Paksha)
  ///
  /// In en, this message translates to:
  /// **'Shukla'**
  String get tithiShukla;

  /// Waning moon fortnight (Krishna Paksha)
  ///
  /// In en, this message translates to:
  /// **'Krishna'**
  String get tithiKrishna;

  /// Separator label between options
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orLabel;

  /// Tertiary fallback link in onboarding to derive bird from name
  ///
  /// In en, this message translates to:
  /// **'Don’t know DOB? Use your name'**
  String get useYourName;

  /// Generic save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Prasanam screen title
  ///
  /// In en, this message translates to:
  /// **'Prasanam Oracle'**
  String get prasanamTitle;

  /// FAB tooltip for Prasanam
  ///
  /// In en, this message translates to:
  /// **'Ask the Oracle'**
  String get prasanamFabTooltip;

  /// Category selector label
  ///
  /// In en, this message translates to:
  /// **'What is your query about?'**
  String get prasanamCategoryLabel;

  /// Material/business category
  ///
  /// In en, this message translates to:
  /// **'Artha'**
  String get prasanamCategoryArtha;

  /// Action/practical category
  ///
  /// In en, this message translates to:
  /// **'Kriya'**
  String get prasanamCategoryKriya;

  /// Spiritual/inner category
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get prasanamCategoryYoga;

  /// Query text field label
  ///
  /// In en, this message translates to:
  /// **'Your intention'**
  String get prasanamQueryLabel;

  /// Query text field hint
  ///
  /// In en, this message translates to:
  /// **'What would you like guidance on?'**
  String get prasanamQueryHint;

  /// Submit query button
  ///
  /// In en, this message translates to:
  /// **'Ask the Oracle'**
  String get prasanamAskButton;

  /// Loading state while evaluating
  ///
  /// In en, this message translates to:
  /// **'Consulting...'**
  String get prasanamEvaluating;

  /// Reset button after result
  ///
  /// In en, this message translates to:
  /// **'Ask Another Question'**
  String get prasanamAskAnother;

  /// User-initiated save button on result screen
  ///
  /// In en, this message translates to:
  /// **'Save to History'**
  String get prasanamSaveToHistory;

  /// Confirmation text after saving to history
  ///
  /// In en, this message translates to:
  /// **'Saved to history'**
  String get prasanamSaved;

  /// Score label
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get prasanamScore;

  /// Floor lock warning message
  ///
  /// In en, this message translates to:
  /// **'Inauspicious window active. Score is locked at minimum.'**
  String get prasanamFloorLocked;

  /// Siddha band label (90-100)
  ///
  /// In en, this message translates to:
  /// **'Strong Yes'**
  String get prasanamBandSiddha;

  /// Vardhana band label (70-89)
  ///
  /// In en, this message translates to:
  /// **'Favorable'**
  String get prasanamBandVardhana;

  /// Mandha band label (50-69)
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get prasanamBandMandha;

  /// Stambhana band label (30-49)
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get prasanamBandStambhana;

  /// Sunya band label (0-29)
  ///
  /// In en, this message translates to:
  /// **'Hard No'**
  String get prasanamBandSunya;

  /// Prasanam history card title
  ///
  /// In en, this message translates to:
  /// **'Oracle History'**
  String get prasanamHistoryTitle;

  /// More queries indicator
  ///
  /// In en, this message translates to:
  /// **'{count} more queries'**
  String prasanamHistoryMore(int count);

  /// Outcome notes dialog title
  ///
  /// In en, this message translates to:
  /// **'Outcome Reflection'**
  String get prasanamOutcomeTitle;

  /// Outcome dialog date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get prasanamOutcomeDate;

  /// Outcome dialog category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get prasanamOutcomeCategory;

  /// Outcome notes section label
  ///
  /// In en, this message translates to:
  /// **'How did it turn out?'**
  String get prasanamOutcomeNotesLabel;

  /// Outcome notes input hint
  ///
  /// In en, this message translates to:
  /// **'Reflect on whether the guidance was accurate...'**
  String get prasanamOutcomeNotesHint;

  /// Prasanam bottom nav tab label
  ///
  /// In en, this message translates to:
  /// **'Oracle'**
  String get prasanamTab;

  /// Delete confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Reading'**
  String get prasanamDeleteTitle;

  /// Delete confirmation dialog body
  ///
  /// In en, this message translates to:
  /// **'Remove this oracle reading from your history?'**
  String get prasanamDeleteMessage;

  /// Delete confirmation button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get prasanamDeleteConfirm;

  /// Artha category description
  ///
  /// In en, this message translates to:
  /// **'Business, finance, negotiations, material decisions'**
  String get prasanamCategoryArthaDesc;

  /// Kriya category description
  ///
  /// In en, this message translates to:
  /// **'Actions, travel, health, practical tasks'**
  String get prasanamCategoryKriyaDesc;

  /// Yoga category description
  ///
  /// In en, this message translates to:
  /// **'Spiritual practice, meditation, inner work'**
  String get prasanamCategoryYogaDesc;

  /// Rahu Kaal warning banner
  ///
  /// In en, this message translates to:
  /// **'Rahu Kaal active — readings are void-locked at 10%'**
  String get prasanamWindowRahu;

  /// Emakandam warning banner
  ///
  /// In en, this message translates to:
  /// **'Emakandam active — readings are void-locked at 10%'**
  String get prasanamWindowEmakandam;

  /// Artha window status
  ///
  /// In en, this message translates to:
  /// **'Artha window — favorable for material queries'**
  String get prasanamWindowArtha;

  /// Kriya window status
  ///
  /// In en, this message translates to:
  /// **'Kriya window — favorable for action queries'**
  String get prasanamWindowKriya;

  /// Yoga window status
  ///
  /// In en, this message translates to:
  /// **'Yoga window — favorable for spiritual queries'**
  String get prasanamWindowYoga;

  /// One-time notice when auto-recalculation changes the birth bird
  ///
  /// In en, this message translates to:
  /// **'Your bird has been updated to {bird} based on corrected calculations.'**
  String birdUpdatedNotice(String bird);

  /// One-time notice when app auto-updates location on open after the user has moved
  ///
  /// In en, this message translates to:
  /// **'Location updated to your current position. Timings refreshed.'**
  String get locationUpdatedNotice;

  /// Info note in the DOB birth-bird path explaining the IST timezone assumption
  ///
  /// In en, this message translates to:
  /// **'IST (UTC+5:30) is assumed for all Indian births. The Moon moves ~0.5°/hour — negligible within India’s timezone span vs a nakshatra’s 13.33° width.'**
  String get onboardingIstAssumption;

  /// Warning on the summary step when no birth bird has been determined
  ///
  /// In en, this message translates to:
  /// **'Please set your birth bird before completing setup. Tap Edit on “Birth Bird” to choose your star, date of birth, or name.'**
  String get summaryIncompleteBird;

  /// Warning on the summary step when no location has been set
  ///
  /// In en, this message translates to:
  /// **'Please set your location before completing setup. Tap Edit on “Location” to select your city.'**
  String get summaryIncompleteLocation;

  /// Title of the full-screen somatic intervention timer room
  ///
  /// In en, this message translates to:
  /// **'Clear Your Breath Channel'**
  String get somaticRoomTitle;

  /// Hint below the countdown in the somatic timer room
  ///
  /// In en, this message translates to:
  /// **'Stay in position and breathe with the pacer until the timer ends.'**
  String get somaticRoomHint;

  /// Body side (left) used inside somatic instruction sentences
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get somaticSideLeft;

  /// Body side (right) used inside somatic instruction sentences
  ///
  /// In en, this message translates to:
  /// **'right'**
  String get somaticSideRight;

  /// Posture-shift instruction
  ///
  /// In en, this message translates to:
  /// **'Lie on your {side} side (lateral recumbency) to open the opposite nostril.'**
  String somaticInstructionPosture(String side);

  /// Axillary-pressure instruction
  ///
  /// In en, this message translates to:
  /// **'Apply firm pressure under your {side} armpit to open the opposite nostril.'**
  String somaticInstructionAxillary(String side);

  /// Shown when the post-intervention flow matches the target
  ///
  /// In en, this message translates to:
  /// **'Breath channel cleared — your nostril flow now matches the target.'**
  String get somaticSuccessNotice;

  /// Shown when the post-intervention flow does not match the target
  ///
  /// In en, this message translates to:
  /// **'Flow not shifted yet. You can rest and try another protocol.'**
  String get somaticRetryNotice;

  /// Sama Vritti pacer phase label — inhale
  ///
  /// In en, this message translates to:
  /// **'Inhale'**
  String get pacerInhale;

  /// Sama Vritti pacer phase label — hold
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get pacerHold;

  /// Sama Vritti pacer phase label — exhale
  ///
  /// In en, this message translates to:
  /// **'Exhale'**
  String get pacerExhale;

  /// Action button shown when a breath entry is unaligned, opening the somatic intervention selector
  ///
  /// In en, this message translates to:
  /// **'Clear Breath Channel'**
  String get clearBreathChannel;

  /// Title of the intervention protocol selector bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Shift Your Breath Channel'**
  String get somaticSelectorTitle;

  /// Subtitle of the intervention protocol selector
  ///
  /// In en, this message translates to:
  /// **'Choose a guided protocol to gently move your nostril flow toward the aligned state.'**
  String get somaticSelectorSubtitle;

  /// Name of the lateral-recumbency intervention protocol
  ///
  /// In en, this message translates to:
  /// **'Posture Shift'**
  String get somaticProtocolPosture;

  /// Description of the posture-shift protocol
  ///
  /// In en, this message translates to:
  /// **'Lie on one side (lateral recumbency) to open the opposite nostril.'**
  String get somaticProtocolPostureDesc;

  /// Name of the axillary-pressure intervention protocol
  ///
  /// In en, this message translates to:
  /// **'Axillary Pressure'**
  String get somaticProtocolAxillary;

  /// Description of the axillary-pressure protocol
  ///
  /// In en, this message translates to:
  /// **'Apply pressure under the opposite armpit (Yoga Danda technique).'**
  String get somaticProtocolAxillaryDesc;

  /// Duration label in minutes for an intervention protocol
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String somaticMinutes(int minutes);

  /// Title for the ambient Aruḍam Now card on Home
  ///
  /// In en, this message translates to:
  /// **'Aruḍam Now'**
  String get arudamNowTitle;

  /// Label for Clock 1 — cosmic timing quality
  ///
  /// In en, this message translates to:
  /// **'Moment'**
  String get arudamClockMoment;

  /// Label for Clock 2 — personal breath alignment
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get arudamClockYou;

  /// Two-clock breakdown for Moment: bird state, hora planet, and strength
  ///
  /// In en, this message translates to:
  /// **'{birdState} · {horaPlanet} hora ({strength})'**
  String arudamMomentBreakdown(
    String birdState,
    String horaPlanet,
    String strength,
  );

  /// Strength indicator: strong
  ///
  /// In en, this message translates to:
  /// **'strong'**
  String get arudamStrengthStrong;

  /// Strength indicator: mild
  ///
  /// In en, this message translates to:
  /// **'mild'**
  String get arudamStrengthMild;

  /// Strength indicator: weak
  ///
  /// In en, this message translates to:
  /// **'weak'**
  String get arudamStrengthWeak;

  /// Status when breath flow naturally matches the current cosmic window
  ///
  /// In en, this message translates to:
  /// **'naturally aligned ✓'**
  String get arudamAlignedNatural;

  /// Status when breath flow does not match the current cosmic window
  ///
  /// In en, this message translates to:
  /// **'not naturally aligned ⚠'**
  String get arudamNotNaturallyAligned;

  /// Affirmation guidance when naturally aligned
  ///
  /// In en, this message translates to:
  /// **'Breath moves in rhythm with the cosmic current. Proceed with ease.'**
  String get arudamAlignedGuidance;

  /// Primary guidance when misaligned: cultivate patience, don't force
  ///
  /// In en, this message translates to:
  /// **'Wait, accept, or note. Natural alignment is a lifelong cultivation of patience.'**
  String get arudamMisalignedGuidance;

  /// Status when last breath log is older than 30 minutes
  ///
  /// In en, this message translates to:
  /// **'breath observation needed'**
  String get arudamBreathUnknown;

  /// Action affordance to log breath observation when stale
  ///
  /// In en, this message translates to:
  /// **'Check your breath →'**
  String get arudamCheckBreath;

  /// Guidance when swara observation is stale
  ///
  /// In en, this message translates to:
  /// **'Showing current timing ceiling. Check your breath to evaluate personal readiness.'**
  String get arudamStaleGuidance;

  /// Low-emphasis link when misaligned to open contralateral shift guidance
  ///
  /// In en, this message translates to:
  /// **'Urgent worldly need?'**
  String get arudamUrgentAffordance;

  /// Title of the forced breath shift guidance bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Contralateral Shift Guidance'**
  String get arudamUrgentSheetTitle;

  /// Warning-toned doctrinal framing for forced shift
  ///
  /// In en, this message translates to:
  /// **'Forced breath shifting is an emergency measure for unavoidable action, not a daily habit. Actively altering your nostril dominance taxes vital reserves. A shift nudges the channel for approximately 10–60 minutes and can revert naturally at any time. It may improve your odds, but never guarantees success.'**
  String get arudamUrgentWarning;

  /// Title for the physical shift instructions
  ///
  /// In en, this message translates to:
  /// **'Rest or Pressure Technique'**
  String get arudamUrgentTechniqueTitle;

  /// Physical steps to nudge contralateral dominance
  ///
  /// In en, this message translates to:
  /// **'Lie on the side of the currently active nostril, or apply gentle pressure to the opposite armpit using a cushion or your arm for 3–5 minutes.'**
  String get arudamUrgentTechniqueDesc;

  /// Action button ending the shift loop — prompts verification rather than assuming done
  ///
  /// In en, this message translates to:
  /// **'Re-check Breath'**
  String get arudamUrgentRecheck;

  /// Notice shown after recording a force-shifted breath entry
  ///
  /// In en, this message translates to:
  /// **'Shift logged. Observe how naturally the rhythm returns.'**
  String get arudamShiftLoggedNotice;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ta'].contains(locale.languageCode);

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
