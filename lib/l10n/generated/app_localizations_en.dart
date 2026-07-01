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
}
