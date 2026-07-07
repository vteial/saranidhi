import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';
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
    this.yamaIndex,
    this.payload,
  });

  final int id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final YamaIndex? yamaIndex;

  /// Optional payload for deep linking (e.g., 'quick_log' to open journal).
  final String? payload;
}

/// Notification preferences.
class NotificationPreferences {
  const NotificationPreferences({
    this.notifyRuling = true,
    this.notifyEating = false,
    this.notifyRahuKaal = false,
    this.notifyMorningSummary = false,
  });

  final bool notifyRuling;
  final bool notifyEating;
  final bool notifyRahuKaal;
  final bool notifyMorningSummary;

  int get enabledCount =>
      (notifyRuling ? 1 : 0) +
      (notifyEating ? 1 : 0) +
      (notifyRahuKaal ? 1 : 0) +
      (notifyMorningSummary ? 1 : 0);
  bool get isEnabled =>
      notifyRuling || notifyEating || notifyRahuKaal || notifyMorningSummary;
}

/// Generates notification schedule for Yama boundary times.
///
/// Notifications include:
/// - Yama transitions with bird state (Ruling/Eating)
/// - Rahu Kaal start/end warnings
/// - Morning daily summary (at sunrise)
class NotificationScheduler {
  const NotificationScheduler._();

  /// State-specific guidance text for notifications.
  static const Map<PakshiState, String> _stateGuidance = {
    PakshiState.ruling: 'Act boldly — this is your power hour.',
    PakshiState.eating: 'Prepare and nourish — intake is favored now.',
    PakshiState.walking: 'Routine tasks — steady progress, no big moves.',
    PakshiState.sleeping: 'Rest and observe — avoid new initiatives.',
    PakshiState.dying: 'Hard stop — delay important decisions.',
  };

  /// Bird display names for notifications.
  static const Map<PakshiBird, String> _birdNames = {
    PakshiBird.vulture: 'Vulture',
    PakshiBird.owl: 'Owl',
    PakshiBird.crow: 'Crow',
    PakshiBird.rooster: 'Rooster',
    PakshiBird.peacock: 'Peacock',
  };

  /// Generates all scheduled notifications for today.
  ///
  /// [birthBird] is used to personalize notifications with the user's
  /// birth bird state per yama.
  static List<ScheduledNotification> generateForToday({
    required double latitude,
    required double longitude,
    required double utcOffset,
    required NotificationPreferences prefs,
    PakshiBird? birthBird,
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

    // Calculate Pakshi day result for bird state per yama
    final lunarPhaseResult = LunarPhaseCalculator.calculate(today);
    final weekday = PakshiCalculator.dartWeekdayToSunBased(today.weekday);
    final pakshiDay = PakshiCalculator.calculate(
      weekday: weekday,
      lunarPhase: lunarPhaseResult.phase,
    );

    final notifications = <ScheduledNotification>[];
    var idCounter = 100; // Start at 100 to avoid conflicts

    // --- Yama transition notifications ---
    for (final yama in yamaResult.yamas) {
      if (yama.start.isBefore(today)) continue;

      // Determine birth bird's state for this yama
      PakshiState? birdState;
      if (birthBird != null) {
        birdState = pakshiDay.stateForBird(birthBird, yama.index);
      }

      if (prefs.notifyRuling) {
        notifications.add(
          ScheduledNotification(
            id: idCounter++,
            title: _buildTitle(yama.index, birthBird, birdState),
            body: _buildBody(yama.index, birthBird, birdState),
            scheduledTime: yama.start,
            yamaIndex: yama.index,
          ),
        );
      }

      if (prefs.notifyEating && birdState == PakshiState.eating) {
        final eatingOffset = yama.duration ~/ 5;
        final eatingTime = yama.start.add(eatingOffset);
        if (eatingTime.isAfter(today)) {
          notifications.add(
            ScheduledNotification(
              id: idCounter++,
              title: 'Saranidhi — Eating State Active',
              body: birthBird != null
                  ? 'Your ${_birdNames[birthBird]} enters Eating state. '
                      'Nourish body and mind.'
                  : 'Eating state — a good time for mindful consumption.',
              scheduledTime: eatingTime,
              yamaIndex: yama.index,
            ),
          );
        }
      }
    }

    // --- Rahu Kaal notifications ---
    if (prefs.notifyRahuKaal) {
      final rahuNotifications = _generateRahuKaalNotifications(
        sunResult: sunResult,
        today: today,
        idStart: idCounter,
      );
      idCounter += rahuNotifications.length;
      notifications.addAll(rahuNotifications);
    }

    // --- Morning summary notification ---
    if (prefs.notifyMorningSummary) {
      final summary = _generateMorningSummary(
        sunResult: sunResult,
        yamaResult: yamaResult,
        pakshiDay: pakshiDay,
        birthBird: birthBird,
        today: today,
        id: idCounter++,
      );
      if (summary != null) notifications.add(summary);
    }

    return notifications;
  }

  /// Build notification title with bird name + state.
  static String _buildTitle(
    YamaIndex yama,
    PakshiBird? bird,
    PakshiState? state,
  ) {
    if (bird != null && state != null) {
      final birdName = _birdNames[bird] ?? 'Bird';
      final stateName =
          state.name[0].toUpperCase() + state.name.substring(1);
      return 'Your $birdName is now $stateName';
    }
    return 'Saranidhi — ${yama.label}';
  }

  /// Build notification body with guidance text.
  static String _buildBody(
    YamaIndex yama,
    PakshiBird? bird,
    PakshiState? state,
  ) {
    if (state != null) {
      return _stateGuidance[state] ?? 'Check your Saranidhi dashboard.';
    }
    // Fallback generic messages
    return switch (yama) {
      YamaIndex.yama1 => 'Morning energy rises. Start with intention.',
      YamaIndex.yama2 => 'Mid-morning shift. Observe your breath.',
      YamaIndex.yama3 => 'Midday transition. Check nostril dominance.',
      YamaIndex.yama4 => 'Afternoon flow. Align with cosmic rhythm.',
      YamaIndex.yama5 => 'Final daylight yama. Complete your practice.',
    };
  }

  /// Generate Rahu Kaal start/end notifications.
  static List<ScheduledNotification> _generateRahuKaalNotifications({
    required SunriseSunsetResult sunResult,
    required DateTime today,
    required int idStart,
  }) {
    final rahuResult = RahuKaalCalculator.calculate(
      sunrise: sunResult.sunrise,
      sunset: sunResult.sunset,
      weekday: PakshiCalculator.dartWeekdayToSunBased(today.weekday),
    );

    final notifications = <ScheduledNotification>[];
    var id = idStart;

    // Rahu Kaal start notification
    if (rahuResult.start.isAfter(today)) {
      notifications.add(
        ScheduledNotification(
          id: id++,
          title: 'Rahu Kaal Begins',
          body: 'Avoid new initiatives until '
              '${_formatTime(rahuResult.end)}. Observe and reflect.',
          scheduledTime: rahuResult.start,
        ),
      );
    }

    // Rahu Kaal end notification
    if (rahuResult.end.isAfter(today)) {
      notifications.add(
        ScheduledNotification(
          id: id++,
          title: 'Rahu Kaal Ended',
          body: 'The shadow period has passed. You may proceed with '
              'confidence.',
          scheduledTime: rahuResult.end,
        ),
      );
    }

    return notifications;
  }

  /// Generate morning summary notification at sunrise.
  static ScheduledNotification? _generateMorningSummary({
    required SunriseSunsetResult sunResult,
    required YamaResult yamaResult,
    required PakshiDayResult pakshiDay,
    required PakshiBird? birthBird,
    required DateTime today,
    required int id,
  }) {
    // Schedule at sunrise (or skip if sunrise already passed)
    if (sunResult.sunrise.isBefore(today)) return null;

    // Build summary of today's best times
    var body = 'Today: Sunrise ${_formatTime(sunResult.sunrise)}';

    if (birthBird != null) {
      // Find which yama the birth bird is Ruling
      for (final yama in yamaResult.yamas) {
        final state = pakshiDay.stateForBird(birthBird, yama.index);
        if (state == PakshiState.ruling) {
          body += ' | Best time: ${_formatTime(yama.start)}'
              '–${_formatTime(yama.end)}';
          break;
        }
      }
    }

    return ScheduledNotification(
      id: id,
      title: 'Good Morning — Saranidhi',
      body: body,
      scheduledTime: sunResult.sunrise,
    );
  }

  /// Format a DateTime to HH:mm string.
  static String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
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
    PakshiBird? birthBird,
  }) async {
    await cancelAll();
    return generateForToday(
      latitude: latitude,
      longitude: longitude,
      utcOffset: utcOffset,
      prefs: prefs,
      birthBird: birthBird,
    );
  }
}
