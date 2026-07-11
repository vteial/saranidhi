import 'package:saranidhi/features/astro_engine/domain/action_window.dart';

/// A consolidated temporal block representing a contiguous Action Window.
///
/// The `ActionWindowsEngine` merges adjacent yamas that share the same
/// [ActionWindow] type into single segments, reducing notification noise
/// and providing clear lifestyle guidance blocks.
class ActionWindowSegment {
  const ActionWindowSegment({
    required this.window,
    required this.start,
    required this.end,
    required this.birdStateName,
    this.isBlockedByRahu = false,
  });

  /// The action window type (Artha, Kriya, or Yoga).
  final ActionWindow window;

  /// Start time of this consolidated segment.
  final DateTime start;

  /// End time of this consolidated segment.
  final DateTime end;

  /// Human-readable bird state name(s) within this segment.
  /// If multiple states are consolidated (e.g., Walking + Ruling → Artha),
  /// they are joined with "/".
  final String birdStateName;

  /// Whether this segment is blocked by Rahu Kaal.
  /// When true, Artha/Kriya windows are clamped to 10% effectiveness.
  final bool isBlockedByRahu;

  /// Duration of this segment.
  Duration get duration => end.difference(start);

  /// Whether the given [time] falls within this segment
  /// (inclusive start, exclusive end).
  bool contains(DateTime time) {
    return !time.isBefore(start) && time.isBefore(end);
  }

  /// Creates a copy with the Rahu blocked flag set.
  ActionWindowSegment copyWithRahuBlocked({required bool blocked}) {
    return ActionWindowSegment(
      window: window,
      start: start,
      end: end,
      birdStateName: birdStateName,
      isBlockedByRahu: blocked,
    );
  }
}
