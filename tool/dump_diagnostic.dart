// tool/dump_diagnostic.dart
//
// Saranidhi Diagnostic Dump Tool (Accuracy & Validation Epic)
//
// Generates a 7-day (default) read-only diagnostic dump of Saranidhi's internal
// engine outputs (sunrise, sunset, lunar phase, nakshatra, and all 10 yamas with
// ruling bird and subject-bird states) for 3-way accuracy calibration against
// Align27 and Tamil Panchangam.

import 'dart:convert';
import 'dart:io';

import 'package:saranidhi/core/utils/timezone_utils.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/nakshatra_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/sunrise_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

const List<String> validBirds = [
  'vulture',
  'owl',
  'crow',
  'rooster',
  'peacock',
];

const List<String> _weekdays = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

/// Record for a single Yama (Y1–Y10).
class YamaRecord {
  const YamaRecord({
    required this.date,
    required this.index,
    required this.start,
    required this.end,
    required this.rulingBird,
    required this.subjectBird,
    required this.subjectState,
  });

  final String date;
  final int index;
  final DateTime start;
  final DateTime end;
  final PakshiBird rulingBird;
  final PakshiBird subjectBird;
  final PakshiState subjectState;

  Map<String, dynamic> toJson() => {
    'date': date,
    'end': end.toIso8601String(),
    'index': index,
    'rulingBird': rulingBird.name,
    'start': start.toIso8601String(),
    'subjectBird': subjectBird.name,
    'subjectState': subjectState.name,
  };
}

/// Record for a single day including 10 yama segments.
class DayRecord {
  const DayRecord({
    required this.date,
    required this.weekday,
    required this.sunrise,
    required this.sunset,
    required this.lunarPhase,
    required this.nakshatra,
    required this.yamas,
  });

  final String date;
  final String weekday;
  final DateTime sunrise;
  final DateTime sunset;
  final LunarPhase lunarPhase;
  final String nakshatra;
  final List<YamaRecord> yamas;

  Map<String, dynamic> toJson() => {
    'date': date,
    'lunarPhase': lunarPhase.name,
    'nakshatra': nakshatra,
    'sunrise': sunrise.toIso8601String(),
    'sunset': sunset.toIso8601String(),
    'weekday': weekday,
    'yamas': yamas.map((y) => y.toJson()).toList(),
  };
}

/// Top-level report container for the diagnostic dump.
class DiagnosticDumpReport {
  const DiagnosticDumpReport({
    required this.bird,
    required this.latitude,
    required this.longitude,
    required this.startDate,
    required this.days,
    required this.records,
  });

  final PakshiBird bird;
  final double latitude;
  final double longitude;
  final String startDate;
  final int days;
  final List<DayRecord> records;

  /// Flattened list of all yama records across all days.
  List<YamaRecord> get allYamas => records.expand((d) => d.yamas).toList();

  Map<String, dynamic> toJson() => {
    'bird': bird.name,
    'days': days,
    'latitude': latitude,
    'longitude': longitude,
    'records': records.map((r) => r.toJson()).toList(),
    'startDate': startDate,
  };

  /// Deterministic JSON with alphabetically sorted keys.
  String toJsonString() {
    final sorted = _sortMap(toJson());
    return '${const JsonEncoder.withIndent('  ').convert(sorted)}\n';
  }

  /// GitHub-renderable Markdown table.
  String toMarkdown() {
    final buf = StringBuffer()
      ..writeln('# Saranidhi Diagnostic Dump')
      ..writeln()
      ..writeln('- **Bird:** ${bird.name}')
      ..writeln('- **Latitude:** $latitude')
      ..writeln('- **Longitude:** $longitude')
      ..writeln('- **Start Date:** $startDate')
      ..writeln('- **Days:** $days')
      ..writeln()
      ..writeln(
        '| Date | Weekday | Yama | Start | End | Ruling Bird | Subject Bird | Subject State | Sunrise | Sunset | Lunar Phase | Nakshatra |',
      )
      ..writeln(
        '| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |',
      );

    for (final day in records) {
      for (final yama in day.yamas) {
        buf.writeln(
          '| ${yama.date} '
          '| ${day.weekday} '
          '| ${yama.index} '
          '| ${yama.start.toIso8601String()} '
          '| ${yama.end.toIso8601String()} '
          '| ${yama.rulingBird.name} '
          '| ${yama.subjectBird.name} '
          '| ${yama.subjectState.name} '
          '| ${day.sunrise.toIso8601String()} '
          '| ${day.sunset.toIso8601String()} '
          '| ${day.lunarPhase.name} '
          '| ${day.nakshatra} |',
        );
      }
    }
    return buf.toString();
  }
}

Map<String, dynamic> _sortMap(Map<String, dynamic> map) {
  final sortedKeys = map.keys.toList()..sort();
  final result = <String, dynamic>{};
  for (final key in sortedKeys) {
    final dynamic value = map[key];
    if (value is Map<String, dynamic>) {
      result[key] = _sortMap(value);
    } else if (value is List) {
      result[key] = value.map((dynamic item) {
        if (item is Map<String, dynamic>) {
          return _sortMap(item);
        }
        return item;
      }).toList();
    } else {
      result[key] = value;
    }
  }
  return result;
}

/// Builds a [DiagnosticDumpReport] from pure Dart calculation engines.
DiagnosticDumpReport buildDiagnosticDump({
  required PakshiBird bird,
  required double latitude,
  required double longitude,
  required DateTime startDate,
  int days = 7,
  double? utcOffset,
}) {
  final resolvedUtcOffset =
      utcOffset ??
      TimezoneUtils.offsetForLocation(
        latitude: latitude,
        longitude: longitude,
      );

  final records = <DayRecord>[];

  for (var d = 0; d < days; d++) {
    final currentDay = DateTime(
      startDate.year,
      startDate.month,
      startDate.day + d,
    );
    final nextDay = DateTime(
      startDate.year,
      startDate.month,
      startDate.day + d + 1,
    );

    final sunResult = SunriseCalculator.calculate(
      date: currentDay,
      latitude: latitude,
      longitude: longitude,
      utcOffset: resolvedUtcOffset,
    );

    if (sunResult == null) {
      throw StateError(
        'Could not calculate sunrise/sunset for date $currentDay at $latitude, $longitude',
      );
    }

    final nextSunResult = SunriseCalculator.calculate(
      date: nextDay,
      latitude: latitude,
      longitude: longitude,
      utcOffset: resolvedUtcOffset,
    );

    if (nextSunResult == null) {
      throw StateError(
        'Could not calculate sunrise/sunset for date $nextDay at $latitude, $longitude',
      );
    }

    final dateStr =
        '${currentDay.year.toString().padLeft(4, '0')}-'
        '${currentDay.month.toString().padLeft(2, '0')}-'
        '${currentDay.day.toString().padLeft(2, '0')}';

    final weekdayStr = _weekdays[currentDay.weekday - 1];

    final lunarPhase = LunarPhaseCalculator.phaseForDate(sunResult.sunrise);
    final nakshatraResult = NakshatraCalculator.calculate(sunResult.sunrise);
    final sunBasedWeekday = PakshiCalculator.dartWeekdayToSunBased(
      currentDay.weekday,
    );

    // Day yamas (Y1–Y5)
    final dayYamaResult = YamaCalculator.calculate(
      sunrise: sunResult.sunrise,
      sunset: sunResult.sunset,
    );

    final dayPakshiResult = PakshiCalculator.calculate(
      weekday: sunBasedWeekday,
      lunarPhase: lunarPhase,
    );

    // Night yamas (Y6–Y10)
    final nightYamaResult = YamaCalculator.calculateNight(
      sunset: sunResult.sunset,
      nextSunrise: nextSunResult.sunrise,
    );

    final nightPakshiResult = PakshiCalculator.calculateNight(
      weekday: sunBasedWeekday,
      lunarPhase: lunarPhase,
    );

    final yamas = <YamaRecord>[];

    // Yamas 1 to 5
    for (var i = 0; i < 5; i++) {
      final yamaSegment = dayYamaResult.yamas[i];
      final ruling = dayPakshiResult.forYama(YamaIndex.values[i]).bird;
      final state = dayPakshiResult.stateForBird(bird, YamaIndex.values[i]);

      yamas.add(
        YamaRecord(
          date: dateStr,
          index: i + 1,
          start: yamaSegment.start,
          end: yamaSegment.end,
          rulingBird: ruling,
          subjectBird: bird,
          subjectState: state,
        ),
      );
    }

    // Yamas 6 to 10
    for (var i = 0; i < 5; i++) {
      final nightSegment = nightYamaResult.yamas[i];
      final ruling = nightPakshiResult.entries[i].bird;
      final state = nightPakshiResult.stateForBird(bird, YamaIndex.values[i]);

      yamas.add(
        YamaRecord(
          date: dateStr,
          index: i + 6,
          start: nightSegment.start,
          end: nightSegment.end,
          rulingBird: ruling,
          subjectBird: bird,
          subjectState: state,
        ),
      );
    }

    records.add(
      DayRecord(
        date: dateStr,
        weekday: weekdayStr,
        sunrise: sunResult.sunrise,
        sunset: sunResult.sunset,
        lunarPhase: lunarPhase,
        nakshatra: nakshatraResult.displayName,
        yamas: yamas,
      ),
    );
  }

  final startDateStr =
      '${startDate.year.toString().padLeft(4, '0')}-'
      '${startDate.month.toString().padLeft(2, '0')}-'
      '${startDate.day.toString().padLeft(2, '0')}';

  return DiagnosticDumpReport(
    bird: bird,
    latitude: latitude,
    longitude: longitude,
    startDate: startDateStr,
    days: days,
    records: records,
  );
}

void printUsage({String? error}) {
  final out = error != null ? stderr : stdout;
  if (error != null) {
    out
      ..writeln('Error: $error')
      ..writeln();
  }
  out
    ..writeln('Usage: dart run tool/dump_diagnostic.dart [options]')
    ..writeln()
    ..writeln('Options:')
    ..writeln(
      '  --bird <name>       Subject bird (vulture, owl, crow, rooster, peacock). Default: owl',
    )
    ..writeln('  --lat <number>      Latitude in degrees (required, -90 to 90)')
    ..writeln(
      '  --lng <number>      Longitude in degrees (required, -180 to 180)',
    )
    ..writeln(
      '  --start <date>      Start date in YYYY-MM-DD format (required)',
    )
    ..writeln('  --days <number>     Number of days to dump (default: 7)')
    ..writeln(
      '  --utc-offset <num>  UTC offset in hours (default: derived from location)',
    )
    ..writeln(
      '  --format <json|md>  Output format: json (default) or md (markdown table)',
    )
    ..writeln('  --out <path>        Output file path (default: stdout)')
    ..writeln('  -h, --help          Print this help message');
}

void main(List<String> args) {
  // Parse command line arguments
  final options = <String, String>{};
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '-h' || arg == '--help') {
      printUsage();
      exit(0);
    }
    if (arg.startsWith('--')) {
      final equalsIndex = arg.indexOf('=');
      if (equalsIndex != -1) {
        final key = arg.substring(2, equalsIndex);
        final val = arg.substring(equalsIndex + 1);
        options[key] = val;
      } else {
        final key = arg.substring(2);
        if (i + 1 < args.length && !args[i + 1].startsWith('--')) {
          options[key] = args[i + 1];
          i++;
        } else {
          options[key] = 'true';
        }
      }
    }
  }

  // Parse bird (default: owl)
  final birdName = (options['bird'] ?? 'owl').toLowerCase().trim();
  PakshiBird? subjectBird;
  for (final b in PakshiBird.values) {
    if (b.name == birdName) {
      subjectBird = b;
      break;
    }
  }
  if (subjectBird == null) {
    stderr.writeln(
      'Error: Invalid bird "$birdName". Valid birds are: ${validBirds.join(', ')}.',
    );
    exit(1);
  }

  // Parse latitude
  final latStr = options['lat'];
  if (latStr == null || latStr.isEmpty) {
    stderr.writeln('Error: Missing required option: --lat');
    exit(1);
  }
  final lat = double.tryParse(latStr);
  if (lat == null || lat < -90 || lat > 90) {
    stderr.writeln(
      'Error: Invalid latitude "$latStr". Must be a number between -90 and 90.',
    );
    exit(1);
  }

  // Parse longitude
  final lngStr = options['lng'];
  if (lngStr == null || lngStr.isEmpty) {
    stderr.writeln('Error: Missing required option: --lng');
    exit(1);
  }
  final lng = double.tryParse(lngStr);
  if (lng == null || lng < -180 || lng > 180) {
    stderr.writeln(
      'Error: Invalid longitude "$lngStr". Must be a number between -180 and 180.',
    );
    exit(1);
  }

  // Parse start date
  final startStr = options['start'];
  if (startStr == null || startStr.isEmpty) {
    stderr.writeln('Error: Missing required option: --start');
    exit(1);
  }
  DateTime? parsedStart;
  try {
    parsedStart = DateTime.parse(startStr);
  } on FormatException {
    stderr.writeln(
      'Error: Invalid start date "$startStr". Must be a valid date (YYYY-MM-DD).',
    );
    exit(1);
  }
  final startDate = DateTime(
    parsedStart.year,
    parsedStart.month,
    parsedStart.day,
  );

  // Parse days (default: 7)
  var days = 7;
  if (options.containsKey('days')) {
    final daysStr = options['days']!;
    final parsedDays = int.tryParse(daysStr);
    if (parsedDays == null || parsedDays <= 0) {
      stderr.writeln(
        'Error: Invalid days "$daysStr". Must be a positive integer.',
      );
      exit(1);
    }
    days = parsedDays;
  }

  // Parse optional UTC offset
  double? utcOffset;
  if (options.containsKey('utc-offset')) {
    final offsetStr = options['utc-offset']!;
    final parsedOffset = double.tryParse(offsetStr);
    if (parsedOffset == null || parsedOffset < -14 || parsedOffset > 14) {
      stderr.writeln(
        'Error: Invalid utc-offset "$offsetStr". Must be a number between -14 and 14.',
      );
      exit(1);
    }
    utcOffset = parsedOffset;
  }

  // Parse format (default: json)
  final format = (options['format'] ?? 'json').toLowerCase().trim();
  if (format != 'json' && format != 'md') {
    stderr.writeln('Error: Invalid format "$format". Must be "json" or "md".');
    exit(1);
  }

  // Run calculation
  final report = buildDiagnosticDump(
    bird: subjectBird,
    latitude: lat,
    longitude: lng,
    startDate: startDate,
    days: days,
    utcOffset: utcOffset,
  );

  final content = format == 'md' ? report.toMarkdown() : report.toJsonString();

  final outPath = options['out'];
  if (outPath != null && outPath.isNotEmpty) {
    File(outPath).writeAsStringSync(content);
  } else {
    stdout.write(content);
  }
}
