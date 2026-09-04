import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

/// The physiological protocol used to shift the breath channel.
///
/// Both rely on cross-lateral (contralateral) pressure — the body's
/// respiratory channels respond to pressure applied on the opposite side.
enum InterventionType {
  /// Lie in lateral recumbency on the side opposite the target nostril.
  postureShift,

  /// Apply axillary (armpit) pressure on the side opposite the target
  /// nostril — the classic Yoga Danda technique.
  axillaryPressure;

  /// Value stored in the database (`protocolType`).
  String get storageValue => name;

  /// Parses a stored `protocolType` value back into an [InterventionType].
  static InterventionType fromStorage(String value) =>
      InterventionType.values.firstWhere(
        (t) => t.name == value,
        orElse: () => InterventionType.postureShift,
      );

  /// Recommended timer duration for this protocol.
  Duration get duration => switch (this) {
        InterventionType.postureShift => const Duration(seconds: 180),
        InterventionType.axillaryPressure => const Duration(seconds: 300),
      };

  /// Timer duration in whole seconds (for DB `durationSeconds`).
  int get durationSeconds => duration.inSeconds;
}

/// Lifecycle status of a somatic intervention session.
enum SomaticSessionStatus { active, completed, cancelled }

/// Cross-lateral physiological mapping for shifting the breath channel.
///
/// Respiratory channels respond to *contralateral* pressure. To activate a
/// given nostril, the user applies posture/pressure on the **opposite** side
/// of the body. See `docs/research/advanced_somatic_mastery.md` §1.1.
class CrossLateralMapping {
  const CrossLateralMapping._();

  /// The body side to lie on / apply pressure to, in order to activate the
  /// [target] nostril flow.
  ///
  /// - Target Lunar (left / Ida) → act on the **right** side.
  /// - Target Solar (right / Pingala) → act on the **left** side.
  ///
  /// Sushumna is not a valid intervention target (there is no single
  /// contralateral side); callers should not request it.
  static BodySide bodySideFor(BreathFlow target) => switch (target) {
        BreathFlow.lunar => BodySide.right,
        BreathFlow.solar => BodySide.left,
        // Defensive: Sushumna has no contralateral side; default to right.
        BreathFlow.sushumna => BodySide.right,
      };
}

/// A side of the body used for cross-lateral intervention instructions.
enum BodySide { left, right }

/// An active or historical guided intervention session.
///
/// Records the protocol, the flow the user is trying to reach ([targetFlow]),
/// and the flow they started from ([initialFlow]). After the post-session
/// verification, [evaluateSuccess] determines whether the resolved flow
/// matched the target. See `docs/research/advanced_somatic_mastery.md` §1.3.
class SomaticInterventionSession {
  const SomaticInterventionSession({
    required this.id,
    required this.startTime,
    required this.type,
    required this.targetFlow,
    required this.initialFlow,
    this.status = SomaticSessionStatus.active,
  });

  final String id;
  final DateTime startTime;
  final InterventionType type;

  /// The nostril flow the user is trying to activate (`'left'` or `'right'`).
  final String targetFlow;

  /// The nostril flow the user started from (`'left'` or `'right'`).
  final String initialFlow;

  final SomaticSessionStatus status;

  /// The body side to act on for this session's target flow.
  BodySide get bodySide =>
      CrossLateralMapping.bodySideFor(_flowFromNostril(targetFlow));

  /// The timer duration for this session's protocol.
  Duration get duration => type.duration;

  /// Evaluates whether the post-intervention flow matches the target.
  bool evaluateSuccess(String postInterventionFlow) {
    return postInterventionFlow == targetFlow;
  }

  SomaticInterventionSession copyWith({SomaticSessionStatus? status}) {
    return SomaticInterventionSession(
      id: id,
      startTime: startTime,
      type: type,
      targetFlow: targetFlow,
      initialFlow: initialFlow,
      status: status ?? this.status,
    );
  }

  /// Maps a stored nostril string (`'left'`/`'right'`/`'both'`) to [BreathFlow].
  static BreathFlow _flowFromNostril(String nostril) => switch (nostril) {
        'left' => BreathFlow.lunar,
        'right' => BreathFlow.solar,
        _ => BreathFlow.sushumna,
      };
}
