import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

/// Extended attributes for each Pakshi bird based on traditional
/// Panja Pakshi Shastra (Tamil Siddha system).
///
/// Each bird is associated with:
/// - An element (Pancha Bhoota)
/// - A ruling planet (Graha)
/// - A cardinal direction (Disha)
/// - A colour
/// - Friend and enemy birds (natural relationships)
///
/// Sources: Prof. Dr. U.S. Pulippani's "Biorhythms of Natal Moon",
/// traditional Tamil Siddha texts on Pancha Pakshi.
class PakshiAttributes {
  const PakshiAttributes({
    required this.bird,
    required this.element,
    required this.planet,
    required this.direction,
    required this.waningDirection,
    required this.colour,
    required this.friends,
    required this.enemies,
    required this.nature,
  });

  /// The Pakshi bird this attributes set belongs to.
  final PakshiBird bird;

  /// The associated element (Pancha Bhoota).
  final PakshiElement element;

  /// The ruling planet (Graha).
  final PakshiPlanet planet;

  /// The cardinal direction (Disha) during waxing moon (Valarpirai).
  final PakshiDirection direction;

  /// The cardinal direction (Disha) during waning moon (Theipirai).
  final PakshiDirection waningDirection;

  /// Returns the cardinal direction for this bird given the [phase].
  PakshiDirection directionForPhase(LunarPhase phase) => switch (phase) {
    LunarPhase.waxing => direction,
    LunarPhase.waning => waningDirection,
  };

  /// Returns the cardinal direction for the given [bird] and [phase].
  static PakshiDirection directionFor(PakshiBird bird, LunarPhase phase) {
    return forBird(bird).directionForPhase(phase);
  }

  /// The associated colour.
  final PakshiColour colour;

  /// Friend birds — natural allies (their Ruling helps you).
  final List<PakshiBird> friends;

  /// Enemy birds — natural opponents (their Ruling harms you).
  final List<PakshiBird> enemies;

  /// Brief description of this bird's nature/personality.
  final String nature;

  /// Returns the attributes for a given bird.
  static PakshiAttributes forBird(PakshiBird bird) {
    return _attributes[bird]!;
  }
}

/// The five elements (Pancha Bhoota) associated with the birds.
enum PakshiElement {
  earth,
  water,
  fire,
  air,
  ether;

  String get displayName => switch (this) {
    PakshiElement.earth => 'Earth (Prithvi)',
    PakshiElement.water => 'Water (Apas)',
    PakshiElement.fire => 'Fire (Tejas)',
    PakshiElement.air => 'Air (Vayu)',
    PakshiElement.ether => 'Ether (Akasha)',
  };

  String get tamilName => switch (this) {
    PakshiElement.earth => '\u0BAA\u0BC2\u0BAE\u0BBF (Prithvi)',
    PakshiElement.water => '\u0BA8\u0BC0\u0BB0\u0BCD (Apas)',
    PakshiElement.fire =>
      '\u0BA8\u0BC6\u0BB0\u0BC1\u0BAA\u0BCD\u0BAA\u0BC1 (Tejas)',
    PakshiElement.air => '\u0B95\u0BBE\u0BB1\u0BCD\u0BB1\u0BC1 (Vayu)',
    PakshiElement.ether => '\u0B86\u0B95\u0BBE\u0BAF\u0BAE\u0BCD (Akasha)',
  };

  String get emoji => switch (this) {
    PakshiElement.earth => '\uD83C\uDF0D',
    PakshiElement.water => '\uD83D\uDCA7',
    PakshiElement.fire => '\uD83D\uDD25',
    PakshiElement.air => '\uD83D\uDCA8',
    PakshiElement.ether => '\u2728',
  };
}

/// Ruling planets for each bird.
enum PakshiPlanet {
  saturn,
  mars,
  venus,
  jupiter,
  mercury;

  String get displayName => switch (this) {
    PakshiPlanet.saturn => 'Saturn (Shani)',
    PakshiPlanet.mars => 'Mars (Mangal)',
    PakshiPlanet.venus => 'Venus (Shukra)',
    PakshiPlanet.jupiter => 'Jupiter (Guru)',
    PakshiPlanet.mercury => 'Mercury (Budha)',
  };

  String get tamilName => switch (this) {
    PakshiPlanet.saturn => '\u0B9A\u0BA9\u0BBF (Shani)',
    PakshiPlanet.mars =>
      '\u0B9A\u0BC6\u0BB5\u0BCD\u0BB5\u0BBE\u0BAF\u0BCD (Sevvai)',
    PakshiPlanet.venus =>
      '\u0B9A\u0BC1\u0B95\u0BCD\u0B95\u0BBF\u0BB0\u0BA9\u0BCD (Sukran)',
    PakshiPlanet.jupiter => '\u0B95\u0BC1\u0BB0\u0BC1 (Guru)',
    PakshiPlanet.mercury => '\u0BAA\u0BC1\u0BA4\u0BA9\u0BCD (Budhan)',
  };

  String get symbol => switch (this) {
    PakshiPlanet.saturn => '\u2644',
    PakshiPlanet.mars => '\u2642',
    PakshiPlanet.venus => '\u2640',
    PakshiPlanet.jupiter => '\u2643',
    PakshiPlanet.mercury => '\u263F',
  };
}

/// Cardinal directions associated with each bird.
enum PakshiDirection {
  north,
  south,
  east,
  west,
  center;

  String get displayName => switch (this) {
    PakshiDirection.north => 'North',
    PakshiDirection.south => 'South',
    PakshiDirection.east => 'East',
    PakshiDirection.west => 'West',
    PakshiDirection.center => 'Center',
  };

  String get tamilName => switch (this) {
    PakshiDirection.north => '\u0BB5\u0B9F\u0B95\u0BCD\u0B95\u0BC1',
    PakshiDirection.south => '\u0BA4\u0BC6\u0BA9\u0BCD',
    PakshiDirection.east => '\u0B95\u0BBF\u0BB4\u0B95\u0BCD\u0B95\u0BC1',
    PakshiDirection.west => '\u0BAE\u0BC7\u0BB1\u0BCD\u0B95\u0BC1',
    PakshiDirection.center =>
      '\u0BAE\u0BA4\u0BCD\u0BA4\u0BBF\u0BAF\u0BAE\u0BCD',
  };

  String get emoji => switch (this) {
    PakshiDirection.north => '\u2B06\uFE0F',
    PakshiDirection.south => '\u2B07\uFE0F',
    PakshiDirection.east => '\u27A1\uFE0F',
    PakshiDirection.west => '\u2B05\uFE0F',
    PakshiDirection.center => '\u2B55',
  };
}

/// Colours associated with each bird.
enum PakshiColour {
  black,
  red,
  white,
  yellow,
  green;

  String get displayName => switch (this) {
    PakshiColour.black => 'Black',
    PakshiColour.red => 'Red',
    PakshiColour.white => 'White',
    PakshiColour.yellow => 'Yellow',
    PakshiColour.green => 'Green',
  };

  String get tamilName => switch (this) {
    PakshiColour.black => '\u0B95\u0BB0\u0BC1\u0BAA\u0BCD\u0BAA\u0BC1',
    PakshiColour.red => '\u0B9A\u0BBF\u0BB5\u0BAA\u0BCD\u0BAA\u0BC1',
    PakshiColour.white => '\u0BB5\u0BC6\u0BB3\u0BCD\u0BB3\u0BC8',
    PakshiColour.yellow => '\u0BAE\u0B9E\u0BCD\u0B9A\u0BB3\u0BCD',
    PakshiColour.green => '\u0BAA\u0B9A\u0BCD\u0B9A\u0BC8',
  };

  /// Hex color value for UI rendering.
  int get hexValue => switch (this) {
    PakshiColour.black => 0xFF212121,
    PakshiColour.red => 0xFFD32F2F,
    PakshiColour.white => 0xFFF5F5F5,
    PakshiColour.yellow => 0xFFFFC107,
    PakshiColour.green => 0xFF388E3C,
  };
}

/// Traditional Panja Pakshi bird attribute mappings.
///
/// These associations come from classical Tamil Siddha literature
/// (Prof. Dr. U.S. Pulippani's reference texts).
///
/// Content rephrased for compliance with licensing restrictions.
final Map<PakshiBird, PakshiAttributes> _attributes = {
  PakshiBird.vulture: const PakshiAttributes(
    bird: PakshiBird.vulture,
    element: PakshiElement.earth,
    planet: PakshiPlanet.jupiter, // Guru (CONF-PP-004)
    direction: PakshiDirection.east, // Waxing: East (CONF-PP-005)
    waningDirection: PakshiDirection.east, // Waning: East
    colour: PakshiColour.yellow, // Sandal / Gold / Yellow
    friends: [PakshiBird.peacock, PakshiBird.owl], // CONF-PP-003
    enemies: [PakshiBird.crow, PakshiBird.rooster],
    nature:
        'Grounded, patient, observant. Excels in sustained effort, '
        'endurance, and strategic waiting. Strongest in evening hours.',
  ),
  PakshiBird.owl: const PakshiAttributes(
    bird: PakshiBird.owl,
    element: PakshiElement.water,
    planet: PakshiPlanet.venus, // Sukran (CONF-PP-004)
    direction: PakshiDirection.south, // Waxing: South (CONF-PP-005)
    waningDirection: PakshiDirection.north, // Waning: North
    colour: PakshiColour.white, // Pure White / Silk
    friends: [PakshiBird.vulture, PakshiBird.crow], // CONF-PP-003
    enemies: [PakshiBird.peacock, PakshiBird.rooster],
    nature:
        'Intuitive, perceptive, powerful at night. Excels in hidden '
        'knowledge, research, and decisive action. Strongest after dark.',
  ),
  PakshiBird.crow: const PakshiAttributes(
    bird: PakshiBird.crow,
    element: PakshiElement.fire,
    planet: PakshiPlanet.mars, // Sevvai (CONF-PP-004)
    direction: PakshiDirection.west, // Waxing: West (CONF-PP-005)
    waningDirection: PakshiDirection.south, // Waning: South
    colour: PakshiColour.red, // Deep Red / Crimson
    friends: [PakshiBird.owl, PakshiBird.rooster], // CONF-PP-003
    enemies: [PakshiBird.vulture, PakshiBird.peacock],
    nature:
        'Adaptable, clever, communicative. Excels in social situations, '
        'trade, and creative problem-solving. Strongest mid-morning.',
  ),
  PakshiBird.rooster: const PakshiAttributes(
    bird: PakshiBird.rooster,
    element: PakshiElement.air,
    planet: PakshiPlanet.mercury, // Budhan (CONF-PP-004)
    direction: PakshiDirection.north, // Waxing: North (CONF-PP-005)
    waningDirection: PakshiDirection.center, // Waning: Center
    colour: PakshiColour.green, // Green / Emerald
    friends: [PakshiBird.peacock, PakshiBird.crow], // CONF-PP-003
    enemies: [PakshiBird.vulture, PakshiBird.owl],
    nature:
        'Disciplined, courageous, early-rising. Excels in leadership, '
        'announcements, and new beginnings. Strongest at dawn.',
  ),
  PakshiBird.peacock: const PakshiAttributes(
    bird: PakshiBird.peacock,
    element: PakshiElement.ether,
    planet: PakshiPlanet.saturn, // Shani (CONF-PP-004)
    direction: PakshiDirection.center, // Waxing: Center / Sky (CONF-PP-005)
    waningDirection: PakshiDirection.west, // Waning: West
    colour: PakshiColour.black, // Black / Navy Blue
    friends: [PakshiBird.vulture, PakshiBird.rooster], // CONF-PP-003
    enemies: [PakshiBird.owl, PakshiBird.crow],
    nature:
        'Spiritual, expansive, charismatic. Excels in teaching, healing, '
        'and artistic expression. Strongest at midday.',
  ),
};
