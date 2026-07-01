/// Tamil names for the 27 Nakshatras.
///
/// Display format in Tamil mode: "புஷ்யம் (Pushya)"
/// Display format in English mode: "Pushya"
class NakshatraL10n {
  const NakshatraL10n._();

  /// Returns the Tamil name for a given nakshatra.
  /// Returns null if the nakshatra is not recognized.
  static String? tamilName(String nakshatra) {
    return _tamilNames[nakshatra.toLowerCase().trim()];
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
}
