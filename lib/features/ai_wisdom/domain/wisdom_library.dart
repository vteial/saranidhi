/// Static wisdom library of spiritual proverbs and Sara Kalai teachings.
///
/// Contains 60+ curated entries categorized by context.
/// Used as fallback when no AI/rules engine is available,
/// and as source material for the rules-based engine.
class WisdomLibrary {
  const WisdomLibrary._();

  /// General proverbs about breath and cosmic alignment.
  static const List<String> generalWisdom = [
    'The breath is the bridge between body and spirit. Cross it mindfully.',
    'As the sun moves, so moves the life force. Align and thrive.',
    'He who masters breath, masters life itself. — Siva Swarodaya',
    'The right nostril is the sun; the left is the moon. Balance is liberation.',
    'When both nostrils flow equally, the door to meditation opens.',
    'Observe your breath before every important action. The cosmos will guide you.',
    'The five elements dance within each breath cycle. Witness them.',
    'Consistency in practice builds the bridge to cosmic awareness.',
    'Your breath pattern today writes your destiny tomorrow.',
    'In Sara Kalai, there are no mistakes — only opportunities to realign.',
  ];

  /// Wisdom for high streak (5+ consecutive days).
  static const List<String> highStreakWisdom = [
    'Your dedication is bearing fruit. The cosmic rhythm recognizes consistency.',
    'A steady flame burns brightest. Your practice strengthens with each day.',
    'The ancient masters taught: 21 days transforms habit into nature.',
    'Your streak reflects inner discipline. The birds of Panja Pakshi honor you.',
    'Consistent alignment creates a field of positive energy around you.',
  ];

  /// Wisdom for broken streak (0 days).
  static const List<String> noStreakWisdom = [
    'Every moment is a fresh beginning. The cosmic clock resets with each sunrise.',
    'Do not mourn missed days — celebrate this present breath.',
    'The lotus grows from mud. Begin again with compassion for yourself.',
    'Even the greatest yogis faltered. What matters is returning to the path.',
    'One conscious breath today is worth more than a hundred unconscious ones yesterday.',
  ];

  /// Wisdom during Rahu Kaal.
  static const List<String> rahuKaalWisdom = [
    'Rahu Kaal is active. Observe, do not initiate. This is a time for reflection.',
    'The shadow planet teaches patience. Wait for the window to pass.',
    'Use this Rahu period for inner work — meditation, not action.',
    'When Rahu governs, the wise look inward. New ventures can wait.',
    'This too shall pass. Rahu Kaal is temporary; your practice is eternal.',
  ];

  /// Wisdom by element (Tattva).
  static const Map<String, List<String>> tattvaWisdom = {
    'Earth': [
      'Earth element active — ground yourself. Stand firm in your practice.',
      'Prithvi flows through you. This is a time for stability and nourishment.',
    ],
    'Water': [
      'Water element active — flow with change. Adaptability is strength.',
      'Apas energy surrounds you. Let emotions cleanse like a gentle stream.',
    ],
    'Fire': [
      'Fire element active — transform with courage. Action brings results now.',
      'Tejas burns within. Channel this energy into focused intention.',
    ],
    'Air': [
      'Air element active — expand your awareness. Breathe deeply and freely.',
      'Vayu carries wisdom. Listen to the subtle messages in your breath.',
    ],
    'Ether': [
      'Ether element active — connect to the infinite. Space within is limitless.',
      'Akasha opens above. This is the most spiritual of elements. Meditate.',
    ],
  };

  /// Wisdom by bird state.
  static const Map<String, List<String>> birdStateWisdom = {
    'ruling': [
      'The Ruling bird commands this hour. Lead with confidence and clarity.',
      'Authority flows to you now. Make decisions with conviction.',
    ],
    'eating': [
      'The bird enters Eating state. Nourish body and mind with equal care.',
      'A time for intake — food, knowledge, and positive impressions.',
    ],
    'walking': [
      'Walking state — movement brings insight. Take a mindful walk.',
      'The bird walks between worlds. Transition gracefully between tasks.',
    ],
    'sleeping': [
      'Sleeping state — rest is sacred. Allow yourself to recharge.',
      'Even in stillness, the cosmos moves. Trust the process of rest.',
    ],
    'dying': [
      'Dying state — let go of what no longer serves. Release with gratitude.',
      'Endings birth new beginnings. The bird will rule again tomorrow.',
    ],
  };

  /// Wisdom by planetary hora.
  static const Map<String, List<String>> horaWisdom = {
    'Sun': [
      'Sun hora — vitality peaks. Express yourself with solar confidence.',
    ],
    'Moon': ['Moon hora — intuition is sharp. Trust your inner knowing.'],
    'Mars': ['Mars hora — courage is available. Face challenges head-on.'],
    'Mercury': [
      'Mercury hora — communication flows. Share your wisdom with others.',
    ],
    'Jupiter': [
      'Jupiter hora — expansion and blessings. Gratitude amplifies grace.',
    ],
    'Venus': [
      'Venus hora — beauty and harmony surround you. Create something lovely.',
    ],
    'Saturn': [
      'Saturn hora — discipline and patience. Structure serves freedom.',
    ],
  };
}
