import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([super.locale = 'en']);

  @override
  String get appTitle => 'Saranidhi';

  @override
  String get homeTab => 'Home';

  @override
  String get journalTab => 'Journal';

  @override
  String get settingsTab => 'Settings';

  @override
  String get todayTab => 'Today';

  @override
  String get exploreTab => 'Explore';

  @override
  String get dashboardTitle => 'Saranidhi';

  @override
  String get breathJournalTitle => 'Breath Journal';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get sunset => 'Sunset';

  @override
  String streakDays(int count) {
    return '$count days';
  }

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get sevenDayRibbon => 'Last 7 Days';

  @override
  String get thirtyDayTrend => '30-Day Trend';

  @override
  String get yamaAccuracy => 'Yama Accuracy';

  @override
  String get aligned => 'Aligned';

  @override
  String get notAligned => 'Not Aligned';

  @override
  String get noEntries => 'No entries yet';

  @override
  String get selectNostril => 'Select your active nostril';

  @override
  String get solar => 'Solar (Right)';

  @override
  String get lunar => 'Lunar (Left)';

  @override
  String get sushumna => 'Sushumna (Both)';

  @override
  String get breathAligned => 'Your breath is aligned!';

  @override
  String get breathNotAligned => 'Your breath is not aligned.';

  @override
  String get expected => 'Expected';

  @override
  String get actual => 'Actual';

  @override
  String get logBreathEntry => 'Log Breath Entry';

  @override
  String get saving => 'Saving...';

  @override
  String get completeTimerToLog => 'Complete timer to log';

  @override
  String get entryLoggedSuccess => 'Entry logged successfully!';

  @override
  String get inhale => 'Inhale';

  @override
  String get hold => 'Hold';

  @override
  String get exhale => 'Exhale';

  @override
  String get startTimer => 'Start Timer';

  @override
  String get resetTimer => 'Reset';

  @override
  String get quickSyncPacer => 'Quick Sync Pacer';

  @override
  String get quickSyncInstruction => 'Follow the animation to shift your dominant nostril.';

  @override
  String get journalHistory => 'History';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get profile => 'Profile';

  @override
  String get name => 'Name';

  @override
  String get birthStar => 'Birth Star';

  @override
  String birthBird(String bird) {
    return 'Birth Bird: $bird';
  }

  @override
  String get location => 'Location';

  @override
  String get notSet => 'Not set';

  @override
  String get appearance => 'Appearance';

  @override
  String get colorAccent => 'Color Accent';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get tamil => '\u0BA4\u0BAE\u0BBF\u0BB4\u0BCD';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsSubtitle => 'Yama transition alerts (mobile only)';

  @override
  String get rulingStateAlerts => 'Ruling state alerts';

  @override
  String get rulingStateAlertsSubtitle => 'Notify at Yama start (Ruling bird)';

  @override
  String get eatingStateAlerts => 'Eating state alerts';

  @override
  String get eatingStateAlertsSubtitle => 'Notify when bird enters Eating state';

  @override
  String get storageAndBackup => 'Storage & Backup';

  @override
  String get localOnly => 'Local Only';

  @override
  String get localOnlySubtitle => 'Data stays on this device only';

  @override
  String get icloud => 'iCloud (iOS)';

  @override
  String get icloudSubtitle => 'Backup to your iCloud account';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get googleDriveSubtitle => 'Backup to your Google Drive';

  @override
  String get clearAllData => 'Clear All Data';

  @override
  String get clearAllDataSubtitle => 'Delete all local data and reset app';

  @override
  String get clearAllDataConfirmTitle => 'Clear All Data?';

  @override
  String get clearAllDataConfirmMessage => 'This will permanently delete all your breath journal entries, streak data, and profile. This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get clearData => 'Clear Data';

  @override
  String get dataCleared => 'All data cleared successfully.';

  @override
  String get onboardingWelcome => 'Welcome to Saranidhi';

  @override
  String get onboardingSubtitle => 'The Treasure House of Breath';

  @override
  String get yourName => 'Your Name';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get completeSetup => 'Complete Setup';

  @override
  String get birthStarNakshatra => 'Birth Star (Nakshatra)';

  @override
  String get birthStarHint => 'Your birth star determines your Panja Pakshi bird.';

  @override
  String yourBird(String bird) {
    return 'Your bird: $bird';
  }

  @override
  String get yourLocation => 'Your Location';

  @override
  String get locationHint => 'Used for accurate sunrise/sunset calculation. Your location stays on your device.';

  @override
  String get quickSelect => 'Quick Select:';

  @override
  String get dataStorage => 'Data Storage';

  @override
  String get dataStorageHint => 'Choose where to keep your breath journal data.';

  @override
  String get changeBirthStar => 'Change Birth Star';

  @override
  String get changeBirthStarWarning => 'Warning: Changing your birth star will update your Pakshi bird.';

  @override
  String get changeLocation => 'Change Location';

  @override
  String get retry => 'Retry';

  @override
  String errorLoadingDashboard(String error) {
    return 'Error loading dashboard: $error';
  }

  @override
  String get wisdomTitle => 'Daily Wisdom';

  @override
  String get wisdomLoading => 'Generating insight...';

  @override
  String get vulture => 'Vulture';

  @override
  String get owl => 'Owl';

  @override
  String get crow => 'Crow';

  @override
  String get rooster => 'Rooster';

  @override
  String get peacock => 'Peacock';

  @override
  String get ruling => 'Ruling';

  @override
  String get eating => 'Eating';

  @override
  String get walking => 'Walking';

  @override
  String get sleeping => 'Sleeping';

  @override
  String get dying => 'Dying';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get accentDefault => 'Default';

  @override
  String get accentEmerald => 'Emerald';

  @override
  String get accentGold => 'Gold';

  @override
  String get accentPurple => 'Purple';

  @override
  String get lastBackup => 'Last Backup';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get backingUp => 'Backing up...';

  @override
  String get restore => 'Restore';

  @override
  String get restoring => 'Restoring...';

  @override
  String get switchToCloudHint => 'Switch to iCloud or Google Drive to enable backup';

  @override
  String get restoreBackupTitle => 'Restore Backup?';

  @override
  String get restoreBackupMessage => 'This will replace all current data with the backup. This action cannot be undone.';

  @override
  String get activeToday => 'Active today!';

  @override
  String get logTodayToContinue => 'Log today to continue';

  @override
  String get startYourStreak => 'Start your streak';

  @override
  String get best => 'Best';

  @override
  String trendSummary(int aligned, int total) {
    return '$aligned aligned of $total days logged';
  }

  @override
  String get yamaCoverageHint => 'Log entries during different times of day to see coverage';

  @override
  String get wisdomFallback => 'Every breath is a gift. Practice with gratitude.';

  @override
  String historyCount(int count) {
    return 'History ($count)';
  }

  @override
  String get firstEntryHint => 'Select your breath flow above to log your first entry';

  @override
  String flowLabel(String flow) {
    return '$flow flow';
  }

  @override
  String get deleteEntry => 'Delete Entry?';

  @override
  String get deleteEntryMessage => 'This will permanently remove this breath entry.';

  @override
  String get delete => 'Delete';

  @override
  String get timerIn => 'In';

  @override
  String get timerOut => 'Out';

  @override
  String get breathTimer => 'Breath Timer';

  @override
  String get inhaling => 'Inhaling...';

  @override
  String get holding => 'Holding...';

  @override
  String get exhaling => 'Exhaling...';

  @override
  String get timerComplete => 'Complete!';

  @override
  String get tapToStartInhale => 'Tap to start inhale';

  @override
  String get tapWhenInhaleComplete => 'Tap when inhale complete';

  @override
  String get tapWhenReadyToExhale => 'Tap when ready to exhale';

  @override
  String get tapWhenExhaleComplete => 'Tap when exhale complete';

  @override
  String get tapToReset => 'Tap to reset';

  @override
  String get breatheWithCircle => 'Breathe with the circle';

  @override
  String get yamaPrefix => 'Yama';

  @override
  String get daySun => 'S';

  @override
  String get dayMon => 'M';

  @override
  String get dayTue => 'T';

  @override
  String get dayWed => 'W';

  @override
  String get dayThu => 'T';

  @override
  String get dayFri => 'F';

  @override
  String get daySat => 'S';

  @override
  String get adviceAlignedSushumna => 'Sushumna is active \u2014 perfect balance. Ideal for meditation and spiritual practice.';

  @override
  String get adviceAlignedSolar => 'Solar flow aligned! Lead with your RIGHT foot. Good time for action, exercise, and decision-making.';

  @override
  String get adviceAlignedLunar => 'Lunar flow aligned! Lead with your LEFT foot. Good time for creative work, rest, and nourishment.';

  @override
  String get adviceUnalignedSolar => 'Expected Solar (Right) but your Lunar is active. Try lying on your LEFT side to shift, or press your LEFT armpit gently.';

  @override
  String get adviceUnalignedLunar => 'Expected Lunar (Left) but your Solar is active. Try lying on your RIGHT side to shift, or press your RIGHT armpit gently.';

  @override
  String yourBirdState(String bird, String state) {
    return 'Your $bird \u2014 $state';
  }

  @override
  String get guidanceRuling => 'Peak power! Act boldly. Best time for important decisions.';

  @override
  String get guidanceEating => 'Good time for preparation, learning, and gaining strength.';

  @override
  String get guidanceWalking => 'Routine work is fine. Avoid critical decisions.';

  @override
  String get guidanceSleeping => 'Rest and wait. Avoid important actions.';

  @override
  String get guidanceDying => 'Hard stop. Do not begin anything new.';

  @override
  String yamaProgress(int number, String timeLeft) {
    return 'Yama $number ($timeLeft left)';
  }

  @override
  String get rahuKaalTitle => 'Rahu Kaal';

  @override
  String get rahuKaalActive => 'Active now \u2014 avoid important decisions';

  @override
  String get rahuKaalSoon => 'Starting soon';

  @override
  String get todaysSchedule => 'Today\'s Schedule';

  @override
  String get bestTime => 'Best time!';

  @override
  String get now => 'NOW';

  @override
  String align27Shows(String bird, String state) {
    return 'Align27: $bird / $state';
  }

  @override
  String get nostrilPattern => 'Nostril Pattern';

  @override
  String nextSwitch(int minutes) {
    return 'Next switch: in $minutes min';
  }

  @override
  String get alignedStatus => 'Aligned';

  @override
  String get todaysHold => 'Today\'s Hold';

  @override
  String avgHold(String seconds, int count) {
    return '${seconds}s avg ($count entries)';
  }

  @override
  String get noEntriesToday => 'No entries yet today';

  @override
  String get nightYamas => 'Night Schedule';

  @override
  String get guidanceNightRuling => 'Night Ruling \u2014 powerful time for meditation and spiritual practice.';

  @override
  String get guidanceNightEating => 'Night nourishment \u2014 absorb wisdom, journal reflections.';

  @override
  String get guidanceNightWalking => 'Neutral night period \u2014 light reading or gentle stretching.';

  @override
  String get guidanceNightSleeping => 'Deep rest period \u2014 ideal for sleep.';

  @override
  String get guidanceNightDying => 'Night\'s lowest ebb \u2014 sleep deeply, let go completely.';

  @override
  String get nightNoNostrilPattern => 'Night \u2014 no expected nostril pattern';

  @override
  String get dataExportImportTitle => 'Data Export / Import';

  @override
  String get dataExportImportSubtitle => 'Transfer your data between devices or create a manual backup as a JSON file.';

  @override
  String get exportAllData => 'Export All Data';

  @override
  String get exporting => 'Exporting...';

  @override
  String get exportSuccess => 'Data exported successfully';

  @override
  String get importData => 'Import Data';

  @override
  String get importing => 'Importing...';

  @override
  String get importConfirmTitle => 'Import Data?';

  @override
  String get importConfirmMessage => 'This will replace ALL existing data with the imported file.';

  @override
  String get importExportedOn => 'Exported on';

  @override
  String get importProfiles => 'Profiles';

  @override
  String get importJournalEntries => 'Journal entries';

  @override
  String get importBreathSessions => 'Breath sessions';

  @override
  String get importWarning => 'This action cannot be undone.';

  @override
  String get importConfirmButton => 'Import';

  @override
  String get importSuccess => 'Data imported successfully';

  @override
  String get importFailed => 'Import failed';

  @override
  String get importFailedReadFile => 'Could not read selected file';

  @override
  String get importInvalidFile => 'Invalid export file';
}
