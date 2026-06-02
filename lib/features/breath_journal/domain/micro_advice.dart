import 'package:saranidhi/features/breath_journal/domain/alignment_checker.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

/// Generates contextual micro-advice based on alignment state.
class MicroAdvice {
  const MicroAdvice._();

  /// Returns a short guidance string based on the alignment result.
  static String generate({
    required AlignmentResult alignment,
    required BreathFlow actualFlow,
  }) {
    if (alignment.isAligned) {
      return _alignedAdvice(actualFlow, alignment);
    }
    return _unalignedAdvice(actualFlow, alignment);
  }

  static String _alignedAdvice(
    BreathFlow actualFlow,
    AlignmentResult alignment,
  ) {
    if (actualFlow == BreathFlow.sushumna) {
      return 'Sushumna is active — perfect balance. '
          'Ideal for meditation and spiritual practice.';
    }
    if (actualFlow == BreathFlow.solar) {
      return 'Solar flow aligned! Lead with your RIGHT foot. '
          'Good time for action, exercise, and decision-making.';
    }
    return 'Lunar flow aligned! Lead with your LEFT foot. '
        'Good time for creative work, rest, and nourishment.';
  }

  static String _unalignedAdvice(
    BreathFlow actualFlow,
    AlignmentResult alignment,
  ) {
    final expected = alignment.expectedFlow;
    if (expected == BreathFlow.solar) {
      return 'Expected Solar (Right) but your Lunar is active. '
          'Try lying on your LEFT side to shift, '
          'or press your LEFT armpit gently.';
    }
    return 'Expected Lunar (Left) but your Solar is active. '
        'Try lying on your RIGHT side to shift, '
        'or press your RIGHT armpit gently.';
  }
}
