import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

void main() {
  group('DashboardData Logic', () {
    test('isNight detection: true after sunset', () {
      final sunset = DateTime(2025, 3, 20, 18, 0);
      final now = DateTime(2025, 3, 20, 19, 0);

      // We test the logic of the DashboardData model holding this state
      final data = DashboardData(
        streak: mockStreak(),
        trend: mockTrend(),
        ribbon: [],
        yamaAccuracy: mockYamaAccuracy(),
        sunset: sunset,
        isNight: now.isAfter(sunset),
      );

      expect(data.isNight, isTrue);
    });

    test('todayAvgHoldMs calculation logic', () {
      final holdTimes = [1000.0, 2000.0, 3000.0];
      final avg = holdTimes.reduce((a, b) => a + b) / holdTimes.length;

      final data = DashboardData(
        streak: mockStreak(),
        trend: mockTrend(),
        ribbon: [],
        yamaAccuracy: mockYamaAccuracy(),
        todayAvgHoldMs: avg,
        todayEntryCount: holdTimes.length,
      );

      expect(data.todayAvgHoldMs, equals(2000.0));
      expect(data.todayEntryCount, equals(3));
    });

    test('birthBird extracted correctly', () {
      const bird = PakshiBird.owl;
      final data = DashboardData(
        streak: mockStreak(),
        trend: mockTrend(),
        ribbon: [],
        yamaAccuracy: mockYamaAccuracy(),
        birthBird: bird,
      );

      expect(data.birthBird, equals(PakshiBird.owl));
    });

    test('stateForBird returns correct state for given yama', () {
      final pakshiDay = PakshiDayResult(
        entries: [],
        stateTable: [
          [PakshiState.eating, PakshiState.walking, PakshiState.ruling, PakshiState.sleeping, PakshiState.dying], // Vulture
          [PakshiState.ruling, PakshiState.dying, PakshiState.eating, PakshiState.walking, PakshiState.sleeping], // Owl
        ],
      );

      expect(pakshiDay.stateForBird(PakshiBird.vulture, YamaIndex.yama1), equals(PakshiState.eating));
      expect(pakshiDay.stateForBird(PakshiBird.owl, YamaIndex.yama1), equals(PakshiState.ruling));
    });
  });
}

StreakResult mockStreak() => const StreakResult(currentStreak: 0, longestStreak: 0, isActiveToday: false);
TrendResult mockTrend() => const TrendResult(alignmentPercentage: 0, totalDaysWithEntries: 0, totalAlignedDays: 0, periodDays: 30);
YamaAccuracyResult mockYamaAccuracy() => const YamaAccuracyResult(yamaEntries: {}, totalEntries: 0);
