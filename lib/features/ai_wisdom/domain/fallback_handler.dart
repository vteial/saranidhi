import 'package:saranidhi/features/ai_wisdom/domain/wisdom_library.dart';
import 'package:saranidhi/features/ai_wisdom/domain/wisdom_library_ta.dart';

/// Deterministic fallback handler for when no AI model or rules engine
/// can generate an insight.
///
/// Selects a proverb deterministically by date, ensuring:
/// - Same day = same proverb (no random variation)
/// - Different day = different proverb (rotates through library)
/// - Always returns a non-empty string
///
/// Supports locale-aware selection via [locale] parameter.
class FallbackHandler {
  const FallbackHandler._();

  /// Returns a deterministic proverb for today.
  static String todaysProverb({String locale = 'en'}) {
    return _pickForDate(DateTime.now(), locale: locale);
  }

  /// Returns a proverb for a specific date (used in testing).
  static String proverbForDate(DateTime date, {String locale = 'en'}) {
    return _pickForDate(date, locale: locale);
  }

  static String _pickForDate(DateTime date, {String locale = 'en'}) {
    final isTamil = locale == 'ta';

    final allProverbs = [
      ...(isTamil
          ? WisdomLibraryTa.generalWisdom
          : WisdomLibrary.generalWisdom),
      ...(isTamil
          ? WisdomLibraryTa.highStreakWisdom
          : WisdomLibrary.highStreakWisdom),
      ...(isTamil
          ? WisdomLibraryTa.noStreakWisdom
          : WisdomLibrary.noStreakWisdom),
      ...(isTamil
          ? WisdomLibraryTa.rahuKaalWisdom
          : WisdomLibrary.rahuKaalWisdom),
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
