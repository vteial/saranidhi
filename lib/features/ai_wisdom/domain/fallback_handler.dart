import 'package:saranidhi/features/ai_wisdom/domain/wisdom_library.dart';

/// Deterministic fallback handler for when no AI model or rules engine
/// can generate an insight.
///
/// Selects a proverb deterministically by date, ensuring:
/// - Same day = same proverb (no random variation)
/// - Different day = different proverb (rotates through library)
/// - Always returns a non-empty string
class FallbackHandler {
  const FallbackHandler._();

  /// Returns a deterministic proverb for today.
  static String todaysProverb() {
    return _pickForDate(DateTime.now());
  }

  /// Returns a proverb for a specific date (used in testing).
  static String proverbForDate(DateTime date) {
    return _pickForDate(date);
  }

  static String _pickForDate(DateTime date) {
    final allProverbs = [
      ...WisdomLibrary.generalWisdom,
      ...WisdomLibrary.highStreakWisdom,
      ...WisdomLibrary.noStreakWisdom,
      ...WisdomLibrary.rahuKaalWisdom,
    ];

    final daysSinceEpoch = date.difference(DateTime(2000)).inDays;
    final index = daysSinceEpoch % allProverbs.length;
    return allProverbs[index];
  }

  /// Total number of proverbs in the fallback library.
  static int get totalProverbs {
    return WisdomLibrary.generalWisdom.length +
        WisdomLibrary.highStreakWisdom.length +
        WisdomLibrary.noStreakWisdom.length +
        WisdomLibrary.rahuKaalWisdom.length;
  }
}
