import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

/// Resolves the birth bird using the name's phonetic vowel sounds.
///
/// In Tamil Panja Pakshi Shastra, the first dominant vowel sound of a name
/// represents the vital breath element (Prana) of the person:
/// - Vulture (Earth): A, Ā (அ, ஆ, ஐ)
/// - Owl (Water): I, Ī (இ, ஈ)
/// - Crow (Fire): U, Ū (உ, ஊ)
/// - Rooster (Air): E, Ē (எ, ஏ)
/// - Peacock (Ether): O, Ō, AU (ஒ, ஓ, ஔ)
///
/// This is a tertiary fallback when both nakshatra and DOB are unavailable.
class NameBirdParser {
  const NameBirdParser._();

  /// Parses the user's name and returns the corresponding birth bird.
  ///
  /// Logic:
  /// 1. Try Tamil Unicode vowel mapping (first character)
  /// 2. Fall back to English vowel scan (first vowel in name)
  /// 3. Default to Vulture if no vowel found
  static PakshiBird parse(String name) {
    final cleaned = name.trim().toLowerCase();
    if (cleaned.isEmpty) return PakshiBird.vulture;

    // 1. Attempt Tamil Unicode Character Mapping
    final firstChar = cleaned[0];
    final tamilBird = _mapTamilVowel(firstChar);
    if (tamilBird != null) return tamilBird;

    // 2. Scan for the first English vowel sound
    final vowelRegExp = RegExp(r'[aeiou]');
    final match = vowelRegExp.firstMatch(cleaned);
    if (match == null) {
      return PakshiBird.vulture; // Default fallback
    }

    final firstVowel = match.group(0)!;
    return switch (firstVowel) {
      'a' => PakshiBird.vulture,
      'i' => PakshiBird.owl,
      'u' => PakshiBird.crow,
      'e' => PakshiBird.rooster,
      'o' => PakshiBird.peacock,
      _ => PakshiBird.vulture,
    };
  }

  /// Maps Tamil Unicode vowel characters to birds.
  static PakshiBird? _mapTamilVowel(String char) {
    const mappings = {
      '\u0B85': PakshiBird.vulture, // அ
      '\u0B86': PakshiBird.vulture, // ஆ
      '\u0B90': PakshiBird.vulture, // ஐ
      '\u0B87': PakshiBird.owl, // இ
      '\u0B88': PakshiBird.owl, // ஈ
      '\u0B89': PakshiBird.crow, // உ
      '\u0B8A': PakshiBird.crow, // ஊ
      '\u0B8E': PakshiBird.rooster, // எ
      '\u0B8F': PakshiBird.rooster, // ஏ
      '\u0B92': PakshiBird.peacock, // ஒ
      '\u0B93': PakshiBird.peacock, // ஓ
      '\u0B94': PakshiBird.peacock, // ஔ
    };
    return mappings[char];
  }
}
