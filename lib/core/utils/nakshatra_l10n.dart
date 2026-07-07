/// Tamil names for the 27 Nakshatras.
///
/// Display format trilingual: "Pushya / புஷ்யம் (Pushyami)"
/// Display format Tamil mode: "புஷ்யம் (Pushya)"
/// Display format English mode: "Pushya"
class NakshatraL10n {
  const NakshatraL10n._();

  /// Returns the Tamil name for a given nakshatra.
  /// Returns null if the nakshatra is not recognized.
  static String? tamilName(String nakshatra) {
    return _tamilNames[nakshatra.toLowerCase().trim()];
  }

  /// Returns the Sanskrit name for a given nakshatra.
  /// Returns null if the nakshatra is not recognized.
  static String? sanskritName(String nakshatra) {
    return _sanskritNames[nakshatra.toLowerCase().trim()];
  }

  /// Returns a localized display string for the nakshatra.
  /// Tamil mode: "புஷ்யம் (Pushya)"
  /// English mode: "Pushya" (unchanged)
  static String localizedDisplay(String nakshatra, {required bool isTamil}) {
    if (!isTamil) return nakshatra;
    final tamil = tamilName(nakshatra);
    if (tamil == null) return nakshatra;
    return '$tamil ($nakshatra)';
  }

  /// Returns a trilingual display string for nakshatra selection lists.
  /// Format: "English / தமிழ்"
  /// Always shows both languages for clarity regardless of app language.
  static String trilingualDisplay(String nakshatra) {
    final tamil = tamilName(nakshatra);
    if (tamil == null) return nakshatra;
    return '$nakshatra / $tamil';
  }

  static const Map<String, String> _tamilNames = {
    'ashwini': 'அஸ்வினி',
    'bharani': 'பரணி',
    'krittika': 'கிருத்திகை',
    'rohini': 'ரோகிணி',
    'mrigashira': 'மிருகசீரிடம்',
    'ardra': 'திருவாதிரை',
    'punarvasu': 'புனர்பூசம்',
    'pushya': 'புஷ்யம்',
    'ashlesha': 'ஆயில்யம்',
    'magha': 'மகம்',
    'purva phalguni': 'பூரம்',
    'uttara phalguni': 'உத்திரம்',
    'hasta': 'அஸ்தம்',
    'chitra': 'சித்திரை',
    'swati': 'சுவாதி',
    'vishakha': 'விசாகம்',
    'anuradha': 'அனுஷம்',
    'jyeshtha': 'கேட்டை',
    'mula': 'மூலம்',
    'purva ashadha': 'பூராடம்',
    'uttara ashadha': 'உத்திராடம்',
    'shravana': 'திருவோணம்',
    'dhanishta': 'அவிட்டம்',
    'shatabhisha': 'சதயம்',
    'purva bhadrapada': 'பூரட்டாதி',
    'uttara bhadrapada': 'உத்திரட்டாதி',
    'revati': 'ரேவதி',
  };

  static const Map<String, String> _sanskritNames = {
    'ashwini': 'Ashvini',
    'bharani': 'Bharani',
    'krittika': 'Krittika',
    'rohini': 'Rohini',
    'mrigashira': 'Mrigashirsha',
    'ardra': 'Ardra',
    'punarvasu': 'Punarvasu',
    'pushya': 'Pushyami',
    'ashlesha': 'Ashlesha',
    'magha': 'Magha',
    'purva phalguni': 'Purva Phalguni',
    'uttara phalguni': 'Uttara Phalguni',
    'hasta': 'Hasta',
    'chitra': 'Chitra',
    'swati': 'Svati',
    'vishakha': 'Vishakha',
    'anuradha': 'Anuradha',
    'jyeshtha': 'Jyeshtha',
    'mula': 'Mula',
    'purva ashadha': 'Purva Ashadha',
    'uttara ashadha': 'Uttara Ashadha',
    'shravana': 'Shravana',
    'dhanishta': 'Dhanishta',
    'shatabhisha': 'Shatabhisha',
    'purva bhadrapada': 'Purva Bhadrapada',
    'uttara bhadrapada': 'Uttara Bhadrapada',
    'revati': 'Revati',
  };
}
