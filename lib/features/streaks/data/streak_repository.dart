import 'package:drift/drift.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';

/// Repository for querying journal data needed for streak calculations.
class StreakRepository {
  StreakRepository(this._db);

  final AppDatabase _db;

  /// Returns daily alignment summaries for the last [days] days.
  Future<List<DailyAlignmentSummary>> getDailySummaries({
    required int days,
    required DateTime fromDate,
  }) async {
    final startDate = DateTime(
      fromDate.year,
      fromDate.month,
      fromDate.day,
    ).subtract(Duration(days: days - 1));
    final startMs = startDate.millisecondsSinceEpoch;

    final entries =
        await (_db.select(_db.saraKalaiJournal)
              ..where((t) => t.timestamp.isBiggerOrEqualValue(startMs))
              ..orderBy([(t) => OrderingTerm(expression: t.timestamp)]))
            .get();

    // Group by date
    final grouped = <String, List<SaraKalaiJournalData>>{};
    for (final entry in entries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}'
          '-${date.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(entry);
    }

    // Convert to summaries
    return grouped.entries.map((e) {
      final parts = e.key.split('-');
      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      final dayEntries = e.value;
      final alignedCount = dayEntries.where((x) => x.isAligned).length;

      return DailyAlignmentSummary(
        date: date,
        hasAlignedEntry: alignedCount > 0,
        totalEntries: dayEntries.length,
        alignedEntries: alignedCount,
      );
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Returns all Yama values from the last [days] days for accuracy tracking.
  Future<List<String?>> getYamaValues({required int days}) async {
    final startDate = DateTime.now().subtract(Duration(days: days));
    final startMs = startDate.millisecondsSinceEpoch;

    final entries = await (_db.select(
      _db.saraKalaiJournal,
    )..where((t) => t.timestamp.isBiggerOrEqualValue(startMs))).get();

    return entries.map((e) => e.activeYama).toList();
  }
}
