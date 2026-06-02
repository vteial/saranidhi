import 'package:saranidhi/features/astro_engine/domain/hora_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/tattva_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

/// Context payload passed to the wisdom engine for personalized insight.
///
/// Contains the user's current spiritual state — streak, accuracy,
/// active bird, Rahu status, element, and planetary hour.
class WisdomContext {
  const WisdomContext({
    required this.currentStreak,
    required this.weeklyAccuracy,
    this.activeBird,
    this.activeBirdState,
    this.activeYama,
    this.isRahuKaal = false,
    this.activeTattva,
    this.activeHora,
  });

  /// Current consecutive aligned days.
  final int currentStreak;

  /// Alignment percentage over last 7 days (0–100).
  final int weeklyAccuracy;

  /// The active Panja Pakshi bird (null if outside daylight).
  final PakshiBird? activeBird;

  /// The active bird state (null if outside daylight).
  final PakshiState? activeBirdState;

  /// The active Yama index.
  final YamaIndex? activeYama;

  /// Whether current time is in Rahu Kaal.
  final bool isRahuKaal;

  /// The active element/tattva.
  final Tattva? activeTattva;

  /// The active planetary hora.
  final HoraPlanet? activeHora;

  /// Converts to a map for potential LLM prompt building.
  Map<String, dynamic> toMap() => {
    'currentStreak': currentStreak,
    'weeklyAccuracy': weeklyAccuracy,
    'activeBird': activeBird?.name,
    'activeBirdState': activeBirdState?.name,
    'activeYama': activeYama?.label,
    'isRahuKaal': isRahuKaal,
    'activeTattva': activeTattva?.displayName,
    'activeHora': activeHora?.displayName,
  };
}
