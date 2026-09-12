// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get quickSyncInstruction =>
      'Follow the animation to shift your dominant nostril.';

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
  String get tamil => 'தமிழ்';

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
  String get eatingStateAlertsSubtitle =>
      'Notify when bird enters Eating state';

  @override
  String get rahuKaalAlerts => 'Rahu Kaal Alerts';

  @override
  String get rahuKaalAlertsSubtitle => 'Notify when Rahu Kaal starts and ends';

  @override
  String get morningSummaryAlerts => 'Morning Summary';

  @override
  String get morningSummaryAlertsSubtitle => 'Today\'s best times at sunrise';

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
  String get clearAllDataConfirmMessage =>
      'This will permanently delete all your breath journal entries, streak data, and profile. This action cannot be undone.';

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
  String get birthStarHint =>
      'Your birth star determines your Panja Pakshi bird.';

  @override
  String yourBird(String bird) {
    return 'Your bird: $bird';
  }

  @override
  String get yourLocation => 'Your Location';

  @override
  String get locationHint =>
      'Used for accurate sunrise/sunset calculation. Your location stays on your device.';

  @override
  String get quickSelect => 'Quick Select:';

  @override
  String get locationUseMyLocation => 'Use my current location';

  @override
  String get locationDetecting => 'Detecting your location…';

  @override
  String get locationDetected => 'Detected location';

  @override
  String get locationUnavailable =>
      'Couldn\'t detect your location. Pick a city below instead.';

  @override
  String get dataStorage => 'Data Storage';

  @override
  String get dataStorageHint =>
      'Choose where to keep your breath journal data.';

  @override
  String get changeBirthStar => 'Change Birth Star';

  @override
  String get changeBirthStarWarning =>
      'Warning: Changing your birth star will update your Pakshi bird.';

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
  String get switchToCloudHint =>
      'Switch to iCloud or Google Drive to enable backup';

  @override
  String get restoreBackupTitle => 'Restore Backup?';

  @override
  String get restoreBackupMessage =>
      'This will replace all current data with the backup. This action cannot be undone.';

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
  String get yamaCoverageHint =>
      'Log entries during different times of day to see coverage';

  @override
  String get wisdomFallback =>
      'Every breath is a gift. Practice with gratitude.';

  @override
  String historyCount(int count) {
    return 'History ($count)';
  }

  @override
  String get firstEntryHint =>
      'Select your breath flow above to log your first entry';

  @override
  String flowLabel(String flow) {
    return '$flow flow';
  }

  @override
  String get deleteEntry => 'Delete Entry?';

  @override
  String get deleteEntryMessage =>
      'This will permanently remove this breath entry.';

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
  String get adviceAlignedSushumna =>
      'Sushumna is active — perfect balance. Ideal for meditation and spiritual practice.';

  @override
  String get adviceAlignedSolar =>
      'Solar flow aligned! Lead with your RIGHT foot. Good time for action, exercise, and decision-making.';

  @override
  String get adviceAlignedLunar =>
      'Lunar flow aligned! Lead with your LEFT foot. Good time for creative work, rest, and nourishment.';

  @override
  String get adviceUnalignedSolar =>
      'Expected Solar (Right) but your Lunar is active. Try lying on your LEFT side to shift, or press your LEFT armpit gently.';

  @override
  String get adviceUnalignedLunar =>
      'Expected Lunar (Left) but your Solar is active. Try lying on your RIGHT side to shift, or press your RIGHT armpit gently.';

  @override
  String yourBirdState(String bird, String state) {
    return 'Your $bird — $state';
  }

  @override
  String get guidanceRuling =>
      'Peak power! Act boldly. Best time for important decisions.';

  @override
  String get guidanceEating =>
      'Good time for preparation, learning, and gaining strength.';

  @override
  String get guidanceWalking =>
      'Routine work is fine. Avoid critical decisions.';

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
  String get rahuKaalActive => 'Active now — avoid important decisions';

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
  String get guidanceNightRuling =>
      'Night Ruling — powerful time for meditation and spiritual practice.';

  @override
  String get guidanceNightEating =>
      'Night nourishment — absorb wisdom, journal reflections.';

  @override
  String get guidanceNightWalking =>
      'Neutral night period — light reading or gentle stretching.';

  @override
  String get guidanceNightSleeping => 'Deep rest period — ideal for sleep.';

  @override
  String get guidanceNightDying =>
      'Night\'s lowest ebb — sleep deeply, let go completely.';

  @override
  String get nightNoNostrilPattern => 'Night — no expected nostril pattern';

  @override
  String get dataExportImportTitle => 'Data Export / Import';

  @override
  String get dataExportImportSubtitle =>
      'Transfer your data between devices or create a manual backup as a JSON file.';

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
  String get importConfirmMessage =>
      'This will replace ALL existing data with the imported file.';

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

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get weeklyAlignment => 'Weekly Alignment';

  @override
  String get weeklyAlignmentEmpty =>
      'Log entries to see weekly alignment trends.';

  @override
  String get monthlyPatterns => 'Monthly Patterns (30 days)';

  @override
  String get monthlyPatternsEmpty =>
      'Practice for a few days to see patterns emerge.';

  @override
  String get bestDay => 'Best day';

  @override
  String get needsAttention => 'Needs attention';

  @override
  String get mostActiveYama => 'Most active yama';

  @override
  String get leastActiveYama => 'Least active yama';

  @override
  String get activeDays => 'Active days';

  @override
  String get avgPerDay => 'Avg/day';

  @override
  String get alignment => 'Alignment';

  @override
  String get streakInsights => 'Streak Insights';

  @override
  String get streakInsightsEmpty =>
      'Start practicing to build streak insights.';

  @override
  String get current => 'Current';

  @override
  String get longest => 'Longest';

  @override
  String get totalDays => 'Total days';

  @override
  String get practiceConsistency => 'Practice consistency';

  @override
  String get avgGapBetweenSessions => 'Avg gap between sessions';

  @override
  String get noGaps => 'No gaps';

  @override
  String get days => 'days';

  @override
  String get yamaPerformance => 'Yama Performance';

  @override
  String get yamaPerformanceSubtitle => 'Which time of day you practice most';

  @override
  String get yamaPerformanceEmpty =>
      'Log entries during different yamas to see breakdown.';

  @override
  String get holdTimeProgression => 'Hold Time Progression';

  @override
  String get holdTimeEmpty =>
      'Use the breath timer to track hold time improvement.';

  @override
  String get improving => 'Improving';

  @override
  String get stable => 'Stable';

  @override
  String get declining => 'Declining';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get bestEver => 'Best ever';

  @override
  String get allTimeAverage => 'All-time average';

  @override
  String get totalSessions => 'Total sessions';

  @override
  String get personalBestDate => 'Personal best date';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportDataSubtitle =>
      'Download your complete journal history as a CSV file.';

  @override
  String get exportAsCsv => 'Export as CSV';

  @override
  String get csvExportWebOnly => 'CSV export is available on mobile devices';

  @override
  String exportedTo(String path) {
    return 'Exported to: $path';
  }

  @override
  String get exportFailed => 'Export failed';

  @override
  String get aboutTagline => 'The Treasure House of Breath';

  @override
  String get aboutDeveloper => 'Developer';

  @override
  String get aboutContact => 'Contact';

  @override
  String get aboutWebsite => 'Website';

  @override
  String get aboutUserGuide => 'User Guide';

  @override
  String get aboutPrivacyPolicy => 'Privacy Policy';

  @override
  String get aboutBuiltIn => 'Built with 🙏 in India';

  @override
  String get aboutCopyright => '© 2026 Eialarasu. All rights reserved.';

  @override
  String get introTagline => 'The Treasure House of Breath';

  @override
  String get introWhatTitle => 'What is Saranidhi?';

  @override
  String get introWhatBody =>
      'Saranidhi (Tamil: ஸரநிதி) means \'The Treasure House of Breath\'. It is a spiritual life-guidance app rooted in the ancient Tamil sciences of Sara Kalai (breath science) and Panja Pakshi Shastra (five birds system).\n\nBy observing which nostril is dominant and aligning your actions with cosmic rhythms, you can make better decisions, find optimal timing, and deepen your spiritual practice.';

  @override
  String get introHowTitle => 'How It Works';

  @override
  String get introHowBullet1 =>
      'Your birth star (nakshatra) determines your personal Pakshi bird — it governs your daily energy cycles.';

  @override
  String get introHowBullet2 =>
      'Each day is divided into 5 Yamas (time segments). Your bird cycles through 5 states: Ruling, Eating, Walking, Sleeping, Dying.';

  @override
  String get introHowBullet3 =>
      'Track your breath flow (left/right nostril) and align it with the cosmic pattern for optimal living.';

  @override
  String get introNeedTitle => 'What You\'ll Need';

  @override
  String get introNeedBullet1 =>
      'Your birth star (nakshatra) or date of birth — to determine your Pakshi bird.';

  @override
  String get introNeedBullet2 =>
      'Your current city — for accurate sunrise/sunset times (all data stays on your device).';

  @override
  String get introGetStarted => 'Get Started';

  @override
  String get guideTitle => 'User Guide';

  @override
  String get guideWhatTitle => 'What is Saranidhi?';

  @override
  String get guideWhatBody =>
      'Saranidhi (ஸரநிதி) means \'The Treasure House of Breath\' in Tamil. The name combines \'Sara\' (breath/essence, from Sara Kalai) and \'Nidhi\' (treasure/storehouse).\n\nThis app helps you align your daily actions with ancient Vedic breath rhythms and the Panja Pakshi (Five Birds) system — a time-tested framework for optimal living passed down through Tamil spiritual traditions.';

  @override
  String get guideScienceTitle => 'The Science Behind It';

  @override
  String get guideScienceBody =>
      'Saranidhi is based on two ancient sciences:\n\n• Siva Swarodaya (Sara Kalai) — The science of breath flow (Saram). Your dominant nostril (Idakalai/Left or Pingalai/Right) cycles throughout the day and influences your energy, decision-making, and well-being. When both flow equally, the sacred Suzhumunai state is active.\n\n• Panja Pakshi Shastra — The Five Birds system. Based on your birth nakshatra, you are assigned one of five birds (Vulture, Owl, Crow, Rooster, Peacock) that governs your daily energy cycle through five states (Arasu, Uun, Nadai, Thuyil, Saavu).';

  @override
  String get guideBirdTitle => 'Your Birth Bird';

  @override
  String get guideBirdBody =>
      'Your birth star (nakshatra) determines your personal Pakshi bird. Each of the 27 nakshatras maps to one of five birds:\n\n🦅 Vulture (Hawk) — Sharp, decisive, powerful\n🦉 Owl — Wise, nocturnal, intuitive\n🐦‍⬛ Crow — Adaptable, intelligent, resourceful\n🐓 Rooster (Cock) — Disciplined, alert, punctual\n🦚 Peacock — Graceful, creative, expressive\n\nYour bird is fixed from birth and determines how your energy cycles through the day.';

  @override
  String get guideRhythmTitle => 'Daily Rhythm';

  @override
  String get guideRhythmBody =>
      'Each day (sunrise to sunset) is divided into 5 equal time segments called Yamas (Yaamam). Your bird cycles through 5 states in each Yama:\n\n👑 Arasu (Ruling) — Peak power! Best time for important decisions and bold action. [Artha window]\n🍽️ Uun (Eating) — Preparation time. Good for learning and gaining strength. [Kriya window]\n🚶 Nadai (Walking) — Routine work. Avoid critical decisions. [Artha window]\n💤 Thuyil (Sleeping) — Rest period. Avoid important actions. [Yoga window]\n💀 Saavu (Dying) — Lowest energy. Do not begin anything new. [Yoga window]\n\nThe night (sunset to sunrise) has another 5 Yamas with its own cycle. The app shows both day and night schedules.';

  @override
  String get guideHowToTitle => 'How to Use the App';

  @override
  String get guideHowToBody =>
      '1. Check your Today tab each morning to see your bird\'s state schedule for the day.\n\n2. Note your Ruling time — plan important activities during this window.\n\n3. Avoid starting new things during Dying or Rahu Kaal periods.\n\n4. Log your breath flow (which nostril is dominant) to track alignment with cosmic patterns.\n\n5. Use the Breath Timer for conscious breathing practice — builds awareness and extends hold time.\n\n6. Check the Explore tab for historical data and best times this week.';

  @override
  String get guideBestTitle => 'Best Practices';

  @override
  String get guideBestBody =>
      '• Check in at each Yama transition (the app can notify you).\n• Use your Ruling period for important meetings, decisions, and creative work.\n• During Sleeping/Dying periods, focus on routine tasks or rest.\n• Log your breath at least once per Yama to build alignment awareness.\n• Practice the Quick Sync Pacer if your nostril flow is unaligned.\n• Review your weekly alignment in the Analytics tab to spot patterns.\n• Export your data regularly as a backup (Settings → Export).';

  @override
  String get guidePadaGamanaTitle => 'Swara Pada Gamana (Grounding Step)';

  @override
  String get guidePadaGamanaBody =>
      'The Siva Swarodaya teaches that the first physical contact with the earth upon waking determines the energetic trajectory of the day.\n\n• Upon waking, check which nostril is dominant.\n• If the Right Nostril (Pingalai/Surya) is active: Touch the right side of your face, then place your RIGHT foot on the ground first.\n• If the Left Nostril (Idakalai/Chandra) is active: Touch the left side of your face, then place your LEFT foot on the ground first.\n\nThis simple ritual anchors you in somatic awareness the moment you open your eyes — shifting from reactivity to intentional living. It\'s a physical grounding technique that combats morning anxiety and encourages mindfulness before reaching for your phone.';

  @override
  String get guideSwaraAharaTitle => 'Swara-Ahara (Dietary Alignment)';

  @override
  String get guideSwaraAharaBody =>
      'In Swara science, digestion is governed by Jatharagni (internal digestive fire), closely tied to the Right Nostril (Pingalai/Surya) channel.\n\n• Eat solid food when the RIGHT nostril is active — metabolic heat is high, aiding digestion and nutrient absorption.\n• Drink water and cooling liquids when the LEFT nostril is active — the body is in receptive, cooling mode.\n• Eating when the LEFT nostril dominates leads to slow metabolism, sluggishness, and poor absorption.\n\nIf you need to eat but your left nostril is active:\n1. Lie on your LEFT side for 3 minutes, OR\n2. Apply gentle pressure under your LEFT armpit.\n\nThis shifts breath to the right nostril, preparing your stomach for digestion. The app shows your current nostril pattern — use it before meals!';

  @override
  String get guideDashboardTitle => 'Understanding the Dashboard';

  @override
  String get guideDashboardBody =>
      '• Bird Card — Shows your birth bird\'s current state (Arasu/Uun/Nadai/Thuyil/Saavu) and guidance text.\n• Rahu Kaal — The inauspicious window to avoid new beginnings (changes daily).\n• Day Schedule — Full 10-Yama view showing bird state at each time slot.\n• Nostril Pattern — Expected Pingalai (Solar) or Idakalai (Lunar) dominance per Yama.\n• Daily Wisdom — Spiritual insight tailored to your context.\n• Hold Time — Your average breath hold duration today.\n• Streak — Consecutive days with aligned entries.\n• 7-Day Ribbon — Visual week overview of your practice.';

  @override
  String get guideBenefitsTitle => 'Benefits';

  @override
  String get guideBenefitsBody =>
      '• Cosmic Timing — Know the best moment to act, rest, or wait.\n• Self-Awareness — Develop sensitivity to your breath and energy patterns.\n• Better Decisions — Use Ruling periods for important choices.\n• Consistency — Build a daily practice with streaks and visual feedback.\n• Privacy — All your data stays on your device. No servers, no tracking.\n• Ancient Wisdom, Modern App — Traditional Sara Kalai science in a clean, accessible format.';

  @override
  String get guideFaqTitle => 'Frequently Asked Questions';

  @override
  String get guideFaqBody =>
      'Q: How accurate are the calculations?\nA: Saranidhi uses the Jean Meeus astronomical algorithm for Moon position and authentic Panja Pakshi lookup tables from Prof. Dr. U.S. Pulippani\'s research. Accuracy is within ±0.5°.\n\nQ: Does it work offline?\nA: Yes! All calculations run on your device. No internet needed.\n\nQ: Is my data private?\nA: Absolutely. Your data never leaves your device unless you choose to back up to your own iCloud/Google Drive.\n\nQ: What if I don\'t know my birth star?\nA: Use the \'Calculate from DOB\' option during onboarding — enter your date and time of birth and the app will determine your nakshatra.\n\nQ: What is Rahu Kaal?\nA: A daily inauspicious window (about 90 minutes) based on Vedic astrology. Avoid starting new activities during this time.\n\nQ: Can I use this outside India?\nA: Yes! The app works anywhere. Sunrise/sunset are calculated for your location. Preset cities are Indian, but any latitude/longitude works.\n\nQ: How do I export my data?\nA: Settings → Data Export/Import → Export All Data. This creates a JSON file you can save or share.';

  @override
  String get journalEmptyTitle => 'Begin Your Breath Journey';

  @override
  String get journalEmptySubtitle =>
      'Track your nostril dominance throughout the day to discover your natural alignment with cosmic rhythms.';

  @override
  String get journalEmptyHint => 'Start by selecting your nostril flow above';

  @override
  String get analyticsEmptyTitle => 'Your Insights Await';

  @override
  String get analyticsEmptySubtitle =>
      'Log a few breath entries in the Journal tab to unlock patterns, trends, and personalized insights about your practice.';

  @override
  String get errorSomethingWentWrong => 'Something went wrong';

  @override
  String get errorTryAgainLater =>
      'An unexpected error occurred. Please try again.';

  @override
  String get exploreNoEntriesTitle => 'No entries on this day';

  @override
  String get exploreNoEntriesHint =>
      'Navigate to this date\'s Journal tab to log past entries, or explore other dates.';

  @override
  String get streakZeroTitle => 'Build Your Streak';

  @override
  String get streakZeroSubtitle =>
      'Consistency is the key to alignment awareness.';

  @override
  String get streakStep1 => 'Log your breath flow once per day';

  @override
  String get streakStep2 => 'Each aligned day adds to your streak';

  @override
  String get streakStep3 => 'Watch your consistency grow over time';

  @override
  String get celebrationTitle => 'Amazing!';

  @override
  String celebrationMilestone(int days) {
    return '$days-Day Streak!';
  }

  @override
  String get celebrationTapToDismiss => 'Tap anywhere to dismiss';

  @override
  String get celebrationWeek =>
      'One week of consistent practice. You\'re building a habit!';

  @override
  String get celebrationMonth =>
      'A full month of alignment awareness. Incredible dedication!';

  @override
  String get celebration100 =>
      '100 days! You\'ve mastered the daily rhythm. True practitioner.';

  @override
  String get celebrationYear =>
      'One year of practice. You are the breath. Namaste.';

  @override
  String get celebrationGeneric => 'Keep going! Every day counts.';

  @override
  String get presetManual => 'Manual';

  @override
  String get preset478 => '4-7-8';

  @override
  String get presetBox => 'Box';

  @override
  String get presetEnergizing => 'Energize';

  @override
  String get presetCalming => 'Calm';

  @override
  String presetTimerTitle(String name) {
    return 'Guided: $name';
  }

  @override
  String get dailySummaryTitle => 'Today\'s Practice';

  @override
  String get dailySummaryEntries => 'Entries';

  @override
  String get dailySummaryAlignment => 'Aligned';

  @override
  String get dailySummaryHold => 'Avg Hold';

  @override
  String get pinEntry => 'Pin';

  @override
  String get unpinEntry => 'Unpin';

  @override
  String get pinnedEntries => 'Pinned';

  @override
  String get whatsNewTitle => 'What\'s New';

  @override
  String get whatsNewDismiss => 'Got it!';

  @override
  String get whatsNewCelebrations => 'Streak Celebrations';

  @override
  String get whatsNewCelebrationsDesc =>
      'Hit 7, 30, or 100 days and get a celebratory moment!';

  @override
  String get whatsNewTimerPresets => 'Breathing Presets';

  @override
  String get whatsNewTimerPresetsDesc =>
      'Choose 4-7-8, Box Breathing, or other guided patterns.';

  @override
  String get whatsNewDailySummary => 'Daily Summary';

  @override
  String get whatsNewDailySummaryDesc =>
      'See your entries, alignment, and hold time at a glance.';

  @override
  String get whatsNewPinEntries => 'Pin Favourite Entries';

  @override
  String get whatsNewPinEntriesDesc =>
      'Star your best moments for quick reference.';

  @override
  String get whatsNewNightSchedule => 'Night Schedule Always Visible';

  @override
  String get whatsNewNightScheduleDesc =>
      'Full 10-yama schedule (day + night) shown at all times.';

  @override
  String get whatsNewPerformance => 'Safari & Performance Fixes';

  @override
  String get whatsNewPerformanceDesc =>
      'App now works on all browsers. Faster loading.';

  @override
  String get nostrilTestStep1Title => 'Exhale Test';

  @override
  String get nostrilTestStep1Instruction =>
      'Close your mouth. Exhale gently through your nose. Which nostril feels more air flow?';

  @override
  String get nostrilTestRight => 'Right';

  @override
  String get nostrilTestLeft => 'Left';

  @override
  String get nostrilTestBoth => 'Equal';

  @override
  String get nostrilTestStep2Title => 'Isolation Test';

  @override
  String get nostrilTestStep2Instruction =>
      'Block one nostril with your finger. Breathe through the other. Now switch. Which side flows more freely?';

  @override
  String get nostrilTestConfirmRight => 'Right is stronger';

  @override
  String get nostrilTestConfirmLeft => 'Left is stronger';

  @override
  String get nostrilTestResultTitle => 'Your Dominant Flow';

  @override
  String get nostrilTestConfirm => 'Use This Flow';

  @override
  String get nostrilTestRestart => 'Start over';

  @override
  String get guideMeButton => 'Guide me';

  @override
  String get adviceSushumnaAligned =>
      'Sushumna is active during a Yoga window — perfect alignment! Deep meditation and spiritual practice are highly favored now.';

  @override
  String get adviceSushumnaBlocked =>
      'Sushumna is active but the current window calls for outward action. The balanced state opposes material or physical tasks — consider waiting for the next Yoga window.';

  @override
  String get planetSun => 'Sun';

  @override
  String get planetMoon => 'Moon';

  @override
  String get planetMars => 'Mars';

  @override
  String get planetMercury => 'Mercury';

  @override
  String get planetJupiter => 'Jupiter';

  @override
  String get planetVenus => 'Venus';

  @override
  String get planetSaturn => 'Saturn';

  @override
  String get tattvaEarth => 'Prithvi';

  @override
  String get tattvaWater => 'Apas';

  @override
  String get tattvaFire => 'Tejas';

  @override
  String get tattvaAir => 'Vayu';

  @override
  String get tattvaEther => 'Akasha';

  @override
  String get recalculateFromDob => 'Recalculate from DOB';

  @override
  String get selectBirthDate => 'Select birth date';

  @override
  String get selectBirthTime => 'Select birth time (optional)';

  @override
  String get recalculateButton => 'Calculate';

  @override
  String get findYourBirdTitle => 'Find Your Bird';

  @override
  String get iKnowMyStar => 'I know my star';

  @override
  String get calculateFromDob => 'Calculate from DOB';

  @override
  String get calculateFromName => 'From name';

  @override
  String get iKnowMyStarShort => 'My star';

  @override
  String get calculateFromDobShort => 'From DOB';

  @override
  String get nameMethodHint =>
      'Enter your name — your bird is derived from the first vowel sound (traditional vowel method).';

  @override
  String get nameMethodNote =>
      'Note: the name method is a fallback and less precise than nakshatra or DOB.';

  @override
  String get deriveBirdFromName => 'Find My Bird';

  @override
  String get onboardingSummaryTitle => 'Review & Confirm';

  @override
  String get onboardingSummarySubtitle =>
      'Please review your details. Tap Edit to change anything.';

  @override
  String get summaryName => 'Name';

  @override
  String get summaryBird => 'Birth Bird';

  @override
  String get summaryLocation => 'Location';

  @override
  String get summaryStorage => 'Data Storage';

  @override
  String get summaryNotSet => 'Not set';

  @override
  String get summaryDerivedFromStar => 'from birth star';

  @override
  String get summaryDerivedFromDob => 'from date of birth';

  @override
  String get summaryDerivedFromName => 'from name';

  @override
  String get editAction => 'Edit';

  @override
  String get selectDate => 'Select date';

  @override
  String get birthDateLabel => 'Birth date';

  @override
  String get selectTimeOptional => 'Select time (optional)';

  @override
  String get birthTimeLabel => 'Birth time (for precise nakshatra)';

  @override
  String get calculateNakshatra => 'Calculate Nakshatra';

  @override
  String get locationSubtitle =>
      'Where are you now? (for daily sunrise/sunset)';

  @override
  String get kuligaiKaalTitle => 'Kuligai';

  @override
  String get emakandamTitle => 'Emakandam';

  @override
  String get moonWaxing => 'Waxing';

  @override
  String get moonWaning => 'Waning';

  @override
  String get bestTimesTitle => 'Best Times This Week';

  @override
  String get daySchedule => 'Day Schedule';

  @override
  String get sushumnaAdvice =>
      'Sushumna active — sacred observation. Sit in stillness, meditate.';

  @override
  String get cancelTimer => 'Cancel';

  @override
  String get tattvaEarthEnglish => 'Earth / Prithvi';

  @override
  String get tattvaWaterEnglish => 'Water / Apas';

  @override
  String get tattvaFireEnglish => 'Fire / Tejas';

  @override
  String get tattvaAirEnglish => 'Air / Vayu';

  @override
  String get tattvaEtherEnglish => 'Ether / Akasha';

  @override
  String calculatedNakshatra(String name) {
    return 'Calculated: $name';
  }

  @override
  String moonSiderealLongitude(String degrees) {
    return 'Moon sidereal longitude: $degrees°';
  }

  @override
  String get nearBoundaryWarning =>
      'Near nakshatra boundary — birth time accuracy is important. Verify with a panchangam if unsure.';

  @override
  String importVersionMismatch(int version) {
    return 'This file was exported from a newer version (v$version). Please update the app before importing.';
  }

  @override
  String get termSaramTitle => 'Saram';

  @override
  String get termSaramDescription =>
      'The sacred science of breath flow through the nostrils. Also known as Swara or Sara Kalai.';

  @override
  String get termIdakalai => 'Idakalai';

  @override
  String get termIdakalaiDescription =>
      'The left nostril channel (Ida Nadi). Carries lunar, cooling, receptive energy. Ideal for creative work, rest, and nourishment.';

  @override
  String get termPingalai => 'Pingalai';

  @override
  String get termPingalaiDescription =>
      'The right nostril channel (Pingala Nadi). Carries solar, heating, kinetic energy. Ideal for action, digestion, and decision-making.';

  @override
  String get termSuzhumunai => 'Suzhumunai';

  @override
  String get termSuzhumunaiDescription =>
      'The central channel (Sushumna Nadi). Active when both nostrils flow equally. A rare, sacred neutral state ideal for meditation and spiritual practice.';

  @override
  String get termPanjaPakshi => 'Panja Pakshi';

  @override
  String get termPanjaPakshiDescription =>
      'The ancient Tamil Five Birds system (Panja Pakshi Shastra). Maps cosmic biological rhythms through five bird archetypes based on your birth star.';

  @override
  String get termArasu => 'Arasu (Ruling)';

  @override
  String get termUun => 'Uun (Eating)';

  @override
  String get termNadai => 'Nadai (Walking)';

  @override
  String get termThuyil => 'Thuyil (Sleeping)';

  @override
  String get termSaavu => 'Saavu (Dying)';

  @override
  String get termYaamam => 'Yaamam';

  @override
  String get termYaamamDescription =>
      'A traditional Tamil time unit. Saranidhi divides daylight (sunrise→sunset) and night (sunset→sunrise) each into 5 equal Yamas. Your bird cycles through its states in each Yama.';

  @override
  String get termHorai => 'Horai';

  @override
  String get termHoraiDescription =>
      'Planetary hours that partition each day into 24 segments, each ruled by a celestial body (Sun, Moon, Mars, Mercury, Jupiter, Venus, Saturn).';

  @override
  String get termTattvam => 'Tattvam';

  @override
  String get termTattvamDescription =>
      'The five primordial elements (Earth, Water, Fire, Air, Ether) that cycle within each breath period, modifying your energy and focus.';

  @override
  String get termArtha => 'Artha';

  @override
  String get termArthaDescription =>
      'The window of material achievement and executive function. Active during Ruling and Walking bird states. Best for decisions, negotiations, coding, and physical action.';

  @override
  String get termKriya => 'Kriya';

  @override
  String get termKriyaDescription =>
      'The window of nourishment and receptive focus. Active during the Eating bird state. Best for study, exercise, meals, and gathering information.';

  @override
  String get termYoga => 'Yoga';

  @override
  String get termYogaDescription =>
      'The window of rest and inward reflection. Active during Sleeping and Dying bird states. Best for meditation, brainstorming, emotional release, and sleep.';

  @override
  String get termNakshatra => 'Nakshatra';

  @override
  String get termNakshatraDescription =>
      'Your birth star — one of 27 sidereal lunar mansions. Determines your permanent Panja Pakshi birth bird and daily energy patterns.';

  @override
  String get termRahuKaal => 'Rahu Kaal';

  @override
  String get termRahuKaalDescription =>
      'A daily inauspicious window (~90 minutes) based on Vedic astrology. Avoid starting new activities or making important decisions during this time.';

  @override
  String get termSwaraPadaGamana => 'Swara Pada Gamana';

  @override
  String get termSwaraAhara => 'Swara-Ahara';

  @override
  String get focusCardArthaAdvice =>
      'Negotiate, decide, execute. Your bird is in action mode — material tasks are cosmically favored.';

  @override
  String get focusCardKriyaAdvice =>
      'Nourish body and mind. Eat mindfully, exercise, study, or absorb information.';

  @override
  String get focusCardYogaAdvice =>
      'Turn inward. Rest, meditate, practice breath work, or brainstorm. Avoid new commitments.';

  @override
  String get focusCardRahuBlocked =>
      'Rahu Kaal active — avoid starting anything new. Observe and reflect until it passes.';

  @override
  String get actionWindowSheetTitle => 'Action Window Details';

  @override
  String get actionWindowsTitle => 'Action Windows';

  @override
  String get actionWindowSheetSchedule => 'Today’s Schedule';

  @override
  String durationMinutes(int count) {
    return '${count}min';
  }

  @override
  String get tithiShukla => 'Shukla';

  @override
  String get tithiKrishna => 'Krishna';

  @override
  String get orLabel => 'or';

  @override
  String get useYourName => 'Don’t know DOB? Use your name';

  @override
  String get save => 'Save';

  @override
  String get prasanamTitle => 'Prasanam Oracle';

  @override
  String get prasanamFabTooltip => 'Ask the Oracle';

  @override
  String get prasanamCategoryLabel => 'What is your query about?';

  @override
  String get prasanamCategoryArtha => 'Artha';

  @override
  String get prasanamCategoryKriya => 'Kriya';

  @override
  String get prasanamCategoryYoga => 'Yoga';

  @override
  String get prasanamQueryLabel => 'Your intention';

  @override
  String get prasanamQueryHint => 'What would you like guidance on?';

  @override
  String get prasanamAskButton => 'Ask the Oracle';

  @override
  String get prasanamEvaluating => 'Consulting...';

  @override
  String get prasanamAskAnother => 'Ask Another Question';

  @override
  String get prasanamSaveToHistory => 'Save to History';

  @override
  String get prasanamSaved => 'Saved to history';

  @override
  String get prasanamScore => 'Score';

  @override
  String get prasanamFloorLocked =>
      'Inauspicious window active. Score is locked at minimum.';

  @override
  String get prasanamBandSiddha => 'Strong Yes';

  @override
  String get prasanamBandVardhana => 'Favorable';

  @override
  String get prasanamBandMandha => 'Caution';

  @override
  String get prasanamBandStambhana => 'Delay';

  @override
  String get prasanamBandSunya => 'Hard No';

  @override
  String get prasanamHistoryTitle => 'Oracle History';

  @override
  String prasanamHistoryMore(int count) {
    return '$count more queries';
  }

  @override
  String get prasanamOutcomeTitle => 'Outcome Reflection';

  @override
  String get prasanamOutcomeDate => 'Date';

  @override
  String get prasanamOutcomeCategory => 'Category';

  @override
  String get prasanamOutcomeNotesLabel => 'How did it turn out?';

  @override
  String get prasanamOutcomeNotesHint =>
      'Reflect on whether the guidance was accurate...';

  @override
  String get prasanamTab => 'Oracle';

  @override
  String get prasanamDeleteTitle => 'Delete Reading';

  @override
  String get prasanamDeleteMessage =>
      'Remove this oracle reading from your history?';

  @override
  String get prasanamDeleteConfirm => 'Delete';

  @override
  String get prasanamCategoryArthaDesc =>
      'Business, finance, negotiations, material decisions';

  @override
  String get prasanamCategoryKriyaDesc =>
      'Actions, travel, health, practical tasks';

  @override
  String get prasanamCategoryYogaDesc =>
      'Spiritual practice, meditation, inner work';

  @override
  String get prasanamWindowRahu =>
      'Rahu Kaal active — readings are void-locked at 10%';

  @override
  String get prasanamWindowEmakandam =>
      'Emakandam active — readings are void-locked at 10%';

  @override
  String get prasanamWindowArtha =>
      'Artha window — favorable for material queries';

  @override
  String get prasanamWindowKriya =>
      'Kriya window — favorable for action queries';

  @override
  String get prasanamWindowYoga =>
      'Yoga window — favorable for spiritual queries';

  @override
  String birdUpdatedNotice(String bird) {
    return 'Your bird has been updated to $bird based on corrected calculations.';
  }

  @override
  String get locationUpdatedNotice =>
      'Location updated to your current position. Timings refreshed.';

  @override
  String get onboardingIstAssumption =>
      'IST (UTC+5:30) is assumed for all Indian births. The Moon moves ~0.5°/hour — negligible within India’s timezone span vs a nakshatra’s 13.33° width.';

  @override
  String get summaryIncompleteBird =>
      'Please set your birth bird before completing setup. Tap Edit on “Birth Bird” to choose your star, date of birth, or name.';

  @override
  String get summaryIncompleteLocation =>
      'Please set your location before completing setup. Tap Edit on “Location” to select your city.';

  @override
  String get somaticRoomTitle => 'Clear Your Breath Channel';

  @override
  String get somaticRoomHint =>
      'Stay in position and breathe with the pacer until the timer ends.';

  @override
  String get somaticSideLeft => 'left';

  @override
  String get somaticSideRight => 'right';

  @override
  String somaticInstructionPosture(String side) {
    return 'Lie on your $side side (lateral recumbency) to open the opposite nostril.';
  }

  @override
  String somaticInstructionAxillary(String side) {
    return 'Apply firm pressure under your $side armpit to open the opposite nostril.';
  }

  @override
  String get somaticSuccessNotice =>
      'Breath channel cleared — your nostril flow now matches the target.';

  @override
  String get somaticRetryNotice =>
      'Flow not shifted yet. You can rest and try another protocol.';

  @override
  String get pacerInhale => 'Inhale';

  @override
  String get pacerHold => 'Hold';

  @override
  String get pacerExhale => 'Exhale';

  @override
  String get clearBreathChannel => 'Clear Breath Channel';

  @override
  String get somaticSelectorTitle => 'Shift Your Breath Channel';

  @override
  String get somaticSelectorSubtitle =>
      'Choose a guided protocol to gently move your nostril flow toward the aligned state.';

  @override
  String get somaticProtocolPosture => 'Posture Shift';

  @override
  String get somaticProtocolPostureDesc =>
      'Lie on one side (lateral recumbency) to open the opposite nostril.';

  @override
  String get somaticProtocolAxillary => 'Axillary Pressure';

  @override
  String get somaticProtocolAxillaryDesc =>
      'Apply pressure under the opposite armpit (Yoga Danda technique).';

  @override
  String somaticMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get arudamNowTitle => 'Aruḍam Now';

  @override
  String get arudamClockMoment => 'Moment';

  @override
  String get arudamClockYou => 'You';

  @override
  String arudamMomentBreakdown(
    String birdState,
    String horaPlanet,
    String strength,
  ) {
    return '$birdState · $horaPlanet hora ($strength)';
  }

  @override
  String get arudamStrengthStrong => 'strong';

  @override
  String get arudamStrengthMild => 'mild';

  @override
  String get arudamStrengthWeak => 'weak';

  @override
  String get arudamAlignedNatural => 'naturally aligned ✓';

  @override
  String get arudamNotNaturallyAligned => 'not naturally aligned ⚠';

  @override
  String get arudamAlignedGuidance =>
      'Breath moves in rhythm with the cosmic current. Proceed with ease.';

  @override
  String get arudamMisalignedGuidance =>
      'Wait, accept, or note. Natural alignment is a lifelong cultivation of patience.';

  @override
  String get arudamBreathUnknown => 'breath observation needed';

  @override
  String get arudamCheckBreath => 'Check your breath →';

  @override
  String get arudamStaleGuidance =>
      'Showing current timing ceiling. Check your breath to evaluate personal readiness.';

  @override
  String get arudamUrgentAffordance => 'Urgent worldly need?';

  @override
  String get arudamUrgentSheetTitle => 'Contralateral Shift Guidance';

  @override
  String get arudamUrgentWarning =>
      'Forced breath shifting is an emergency measure for unavoidable action, not a daily habit. Actively altering your nostril dominance taxes vital reserves. A shift nudges the channel for approximately 10–60 minutes and can revert naturally at any time. It may improve your odds, but never guarantees success.';

  @override
  String get arudamUrgentTechniqueTitle => 'Rest or Pressure Technique';

  @override
  String get arudamUrgentTechniqueDesc =>
      'Lie on the side of the currently active nostril, or apply gentle pressure to the opposite armpit using a cushion or your arm for 3–5 minutes.';

  @override
  String get arudamUrgentRecheck => 'Re-check Breath';

  @override
  String get arudamShiftLoggedNotice =>
      'Shift logged. Observe how naturally the rhythm returns.';

  @override
  String get arudamWhyLabel => 'Why?';

  @override
  String get arudamWhyMomentHeading => 'Moment — the timing';

  @override
  String get arudamWhyYouHeading => 'You — your readiness';

  @override
  String get arudamWhyBlockedHeading => 'Blocked';

  @override
  String get arudamWhyBirdStrong =>
      'Your birth bird is in a strong, favourable state — a good moment to act.';

  @override
  String get arudamWhyBirdModerate =>
      'Your birth bird is in a moderate state — proceed with deliberate care.';

  @override
  String get arudamWhyBirdWeak =>
      'Your birth bird is in a low-vitality state — energy is diminished for outward action.';

  @override
  String get arudamWhyHoraStrong =>
      'The planetary hora harmonises strongly with current cosmic flow.';

  @override
  String get arudamWhyHoraModerate =>
      'The planetary hora is neutral and supportive of routine activity.';

  @override
  String get arudamWhyHoraWeak =>
      'The planetary hora is discordant with the cosmic window.';

  @override
  String get arudamWhyTarabalaStrong =>
      'Your birth star receives auspicious lunar transit energy.';

  @override
  String get arudamWhyTarabalaModerate =>
      'Your birth star receives neutral lunar transit influence.';

  @override
  String get arudamWhyTarabalaWeak =>
      'Your birth star faces challenging lunar transit energy.';

  @override
  String get arudamWhyHarmonyStrong =>
      'The nature of your activity aligns harmoniously with this action window.';

  @override
  String get arudamWhyHarmonyModerate =>
      'The activity type is moderately compatible with the current window.';

  @override
  String get arudamWhyHarmonyWeak =>
      'The activity type conflicts with the current action window.';

  @override
  String get arudamWhyReadinessAligned =>
      'Your breath is naturally aligned, so the window stands at its full height.';

  @override
  String get arudamWhyReadinessMisaligned =>
      'Your breath isn\'t naturally aligned, so the moment is dampened — not blocked. The higher path is to wait.';

  @override
  String get arudamWhySushumna =>
      'Sushumna flows — energy turns inward. Favourable for stillness and meditation, not for worldly action.';

  @override
  String get arudamWhyFloorLock =>
      'An inauspicious window is active and overrides all other factors. The higher path is to rest and turn inward.';

  @override
  String arudamWhyCitation(String conf) {
    return '· $conf';
  }

  @override
  String get stagnancyMildTitle => 'Breath Stagnancy (Mild)';

  @override
  String get stagnancyChronicTitle => 'Breath Stagnancy (Chronic)';

  @override
  String stagnancyRightMildDesc(String duration) {
    return 'Your breath has favoured the right (solar) channel for $duration. Excess warmth may build — consider cooling foods, calm hydration, or Sheetali breath.';
  }

  @override
  String stagnancyRightChronicDesc(String duration) {
    return 'Your breath has been stuck in the right (solar) channel for $duration. A rebalancing is advised — practice Sheetali pranayama and rest to cool digestive heat.';
  }

  @override
  String stagnancyLeftMildDesc(String duration) {
    return 'Your breath has favoured the left (lunar) channel for $duration. Sluggishness or cold may build — consider warming foods, gentle movement, or Surya Bhedana.';
  }

  @override
  String stagnancyLeftChronicDesc(String duration) {
    return 'Your breath has been stuck in the left (lunar) channel for $duration. A rebalancing is advised — practice Surya Bhedana pranayama and light movement to kindle metabolic fire.';
  }

  @override
  String get stagnancyRebalanceAction => 'Rebalance channel';

  @override
  String get tattvaTipCooling =>
      'Active Fire element (Tejas): cooling breathwork (Sheetali/Sitkari) is especially beneficial.';

  @override
  String get tattvaTipWarming =>
      'Active Water element (Apas): warming breathwork (Surya Bhedana) is especially beneficial.';

  @override
  String get focusCardSwaraAharaPrompt =>
      'Eating soon? Favour a right-nostril (solar) flow to strengthen digestive fire.';

  @override
  String get focusCardSwaraAharaAligned =>
      'Right nostril active — digestive fire (Jatharagni) is well-placed.';

  @override
  String get focusCardSwaraAharaNudge =>
      'Left nostril currently active. Tap to shift to right before eating.';

  @override
  String get focusCardSwaraAharaAction => 'Flip to right';
}
