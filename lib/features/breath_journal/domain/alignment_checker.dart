import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/sunrise_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

/// Result of an alignment check between actual and expected breath flow.
class AlignmentResult {
  const AlignmentResult({
    required this.expectedFlow,
    required this.isAligned,
    required this.activeYama,
    required this.activeBird,
    required this.activeBirdState,
    this.actionWindow,
  });

  /// The cosmically expected flow direction for the current time.
  final BreathFlow expectedFlow;

  /// Whether the actual flow matches the expected flow.
  final bool isAligned;

  /// The current active Yama (null if before sunrise / after sunset).
  final YamaIndex? activeYama;

  /// The active Panja Pakshi bird.
  final PakshiBird? activeBird;

  /// The active bird state.
  final PakshiState? activeBirdState;

  /// The current action window (derived from bird state).
  /// Used for context-dependent Sushumna alignment logic.
  final ActionWindow? actionWindow;
}

/// Determines the expected breath flow and checks alignment.
///
/// In Sara Kalai tradition, the expected nostril dominance alternates
/// based on the Yama (time segment) and the active Panja Pakshi bird state.
///
/// Simplified rule for this implementation:
/// - Odd Yamas (1, 3, 5) → Solar (Right nostril expected)
/// - Even Yamas (2, 4) → Lunar (Left nostril expected)
///
/// **Sushumna (both) — context-dependent (Sprint 27):**
/// - Yoga window (Sleeping/Dying states) → Fully aligned (spiritual practice)
/// - Artha window (Ruling/Walking states) → Blocked (opposes material action)
/// - Kriya window (Eating state) → Blocked (opposes nourishment/physical)
class AlignmentChecker {
  const AlignmentChecker._();

  /// Checks alignment of [actualFlow] against the cosmic expectation.
  ///
  /// Uses [latitude], [longitude], and [utcOffset] to calculate sunrise/sunset,
  /// then determines the active Yama and expected flow.
  ///
  /// Returns `null` if sunrise/sunset cannot be calculated (polar regions).
  static AlignmentResult? check({
    required BreathFlow actualFlow,
    required DateTime time,
    required double latitude,
    required double longitude,
    required double utcOffset,
  }) {
    final sunResult = SunriseCalculator.calculate(
      date: time,
      latitude: latitude,
      longitude: longitude,
      utcOffset: utcOffset,
    );

    if (sunResult == null) return null;

    final yamaResult = YamaCalculator.calculate(
      sunrise: sunResult.sunrise,
      sunset: sunResult.sunset,
    );

    final activeYamaSegment = yamaResult.activeYama(time);

    // If outside daylight hours, default to lunar
    final expectedFlow = _expectedFlowForYama(activeYamaSegment?.index);

    // Get Pakshi info
    final weekday = PakshiCalculator.dartWeekdayToSunBased(time.weekday);
    // Default to waxing for now — lunar phase integration happens via provider
    final pakshiResult = PakshiCalculator.calculate(
      weekday: weekday,
      lunarPhase: LunarPhase.waxing,
    );

    PakshiBird? activeBird;
    PakshiState? activeBirdState;
    ActionWindow? actionWindow;

    if (activeYamaSegment != null) {
      final pakshiEntry = pakshiResult.forYama(activeYamaSegment.index);
      activeBird = pakshiEntry.bird;
      activeBirdState = pakshiEntry.state;
      actionWindow = ActionWindow.fromBirdState(activeBirdState);
    }

    // Determine alignment based on flow type
    final bool isAligned;
    if (actualFlow == BreathFlow.sushumna) {
      // Context-dependent Sushumna: aligned only in Yoga window
      isAligned = actionWindow?.isSushumnaAligned ?? false;
    } else {
      isAligned = actualFlow == expectedFlow;
    }

    return AlignmentResult(
      expectedFlow: expectedFlow,
      isAligned: isAligned,
      activeYama: activeYamaSegment?.index,
      activeBird: activeBird,
      activeBirdState: activeBirdState,
      actionWindow: actionWindow,
    );
  }

  /// Determines expected flow based on Yama index.
  /// Odd yamas (1,3,5) → Solar; Even yamas (2,4) → Lunar.
  /// Outside daylight → Lunar (default).
  static BreathFlow _expectedFlowForYama(YamaIndex? yama) {
    if (yama == null) return BreathFlow.lunar;
    return switch (yama) {
      YamaIndex.yama1 => BreathFlow.solar,
      YamaIndex.yama2 => BreathFlow.lunar,
      YamaIndex.yama3 => BreathFlow.solar,
      YamaIndex.yama4 => BreathFlow.lunar,
      YamaIndex.yama5 => BreathFlow.solar,
    };
  }
}
