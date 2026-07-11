import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window_segment.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

/// Raw mapping of a single yama to its action window.
class _RawYamaMapping {
  const _RawYamaMapping({
    required this.start,
    required this.end,
    required this.state,
    required this.window,
  });

  final DateTime start;
  final DateTime end;
  final PakshiState state;
  final ActionWindow window;
}

/// Engine that consolidates raw yama-level bird states into actionable
/// lifestyle windows (Artha / Kriya / Yoga).
///
/// The consolidation algorithm merges consecutive yamas that map to the
/// same [ActionWindow], reducing notification spam and providing clear
/// temporal blocks for user guidance.
///
/// See `docs/research/action_windows_engine.md` for full spec.
class ActionWindowsEngine {
  const ActionWindowsEngine._();

  /// Consolidates day + night yamas into [ActionWindowSegment] list.
  ///
  /// Merges adjacent yamas with the same window type into single segments.
  /// The [userBird] determines which bird's state sequence to follow.
  ///
  /// Returns an empty list if no yamas are provided.
  static List<ActionWindowSegment> consolidate({
    required List<YamaSegment> dayYamas,
    required List<NightYamaSegment> nightYamas,
    required PakshiDayResult dayPakshi,
    required PakshiDayResult nightPakshi,
    required PakshiBird userBird,
  }) {
    final rawList = <_RawYamaMapping>[];

    // Map day yamas to action windows
    for (final yama in dayYamas) {
      final state = dayPakshi.stateForBird(userBird, yama.index);
      rawList.add(_RawYamaMapping(
        start: yama.start,
        end: yama.end,
        state: state,
        window: ActionWindow.fromBirdState(state),
      ));
    }

    // Map night yamas to action windows
    for (final yama in nightYamas) {
      final state = nightPakshi.stateTable[userBird.index][yama.index.index];
      rawList.add(_RawYamaMapping(
        start: yama.start,
        end: yama.end,
        state: state,
        window: ActionWindow.fromBirdState(state),
      ));
    }

    // Sort chronologically
    rawList.sort((a, b) => a.start.compareTo(b.start));

    if (rawList.isEmpty) return [];

    // Consolidation: merge consecutive same-window yamas
    final segments = <ActionWindowSegment>[];
    var currentWindow = rawList.first.window;
    var segmentStart = rawList.first.start;
    final currentStates = <String>{rawList.first.state.displayName};

    for (var i = 1; i < rawList.length; i++) {
      final current = rawList[i];

      if (current.window == currentWindow) {
        // Same window — extend and collect state name
        currentStates.add(current.state.displayName);
      } else {
        // Different window — close current segment
        segments.add(ActionWindowSegment(
          window: currentWindow,
          start: segmentStart,
          end: rawList[i - 1].end,
          birdStateName: currentStates.join('/'),
        ));

        // Start new segment
        currentWindow = current.window;
        segmentStart = current.start;
        currentStates
          ..clear()
          ..add(current.state.displayName);
      }
    }

    // Close trailing segment
    segments.add(ActionWindowSegment(
      window: currentWindow,
      start: segmentStart,
      end: rawList.last.end,
      birdStateName: currentStates.join('/'),
    ));

    return segments;
  }

  /// Applies Rahu Kaal guardrail to segments.
  ///
  /// Any Artha or Kriya segment that overlaps with Rahu Kaal gets
  /// its [isBlockedByRahu] flag set to true. Yoga segments are unaffected
  /// (spiritual practice during Rahu is actually favorable).
  static List<ActionWindowSegment> applyRahuGuardrail({
    required List<ActionWindowSegment> segments,
    required RahuKaalResult rahuKaal,
  }) {
    return segments.map((segment) {
      // Check if segment overlaps with Rahu Kaal
      final overlaps = segment.start.isBefore(rahuKaal.end) &&
          segment.end.isAfter(rahuKaal.start);

      if (overlaps && segment.window != ActionWindow.yoga) {
        return segment.copyWithRahuBlocked(blocked: true);
      }
      return segment;
    }).toList();
  }

  /// Returns the currently active segment for the given [time].
  static ActionWindowSegment? activeSegment(
    List<ActionWindowSegment> segments,
    DateTime time,
  ) {
    for (final segment in segments) {
      if (segment.contains(time)) return segment;
    }
    return null;
  }
}
