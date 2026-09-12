import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/core/providers/profile_location_provider.dart';
import 'package:saranidhi/core/utils/timezone_utils.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/astro_engine/domain/emakandam_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/alignment_checker.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/features/home/presentation/widgets/arudam_now_card.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('ArudamNowCard', () {
    testWidgets(
      'renders title, band, and two-clock breakdown when no breath entry',
      (tester) async {
        final data = createTestDashboardData(
          birthBirdState: PakshiState.ruling,
        );

        await tester.pumpWidget(
          testableWidget(
            ArudamNowCard(data: data),
            overrides: [
              profileLocationProvider.overrideWith(
                (ref) => Future.value(const ProfileLocation()),
              ),
              latestJournalEntryProvider.overrideWith(
                (ref) => Stream.value(null),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('ARUḌAM NOW'), findsOneWidget);
        expect(
          find.textContaining('Moment:', findRichText: true),
          findsOneWidget,
        );
        expect(find.textContaining('You:', findRichText: true), findsOneWidget);
        expect(
          find.textContaining('breath observation needed', findRichText: true),
          findsOneWidget,
        );
        expect(find.textContaining('Check your breath →'), findsOneWidget);
      },
    );

    testWidgets(
      'shows naturally aligned when fresh entry matches expected flow',
      (tester) async {
        final now = DateTime.now();
        const location = ProfileLocation();
        final offset = TimezoneUtils.offsetForLocation(
          latitude: location.latitude,
          longitude: location.longitude,
        );

        // Determine which flow is aligned right now
        final solarCheck = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: now,
          latitude: location.latitude,
          longitude: location.longitude,
          utcOffset: offset,
        );
        final alignedFlow = (solarCheck?.isAligned ?? false)
            ? BreathFlow.solar
            : BreathFlow.lunar;

        final entry = SaraKalaiJournalData(
          id: 'entry-aligned',
          timestamp: now
              .subtract(const Duration(minutes: 5))
              .millisecondsSinceEpoch,
          expectedFlow: alignedFlow.name,
          actualFlow: alignedFlow.name,
          isAligned: true,
          nostril: alignedFlow.nostril,
          isPinned: false,
          wasForcedShift: false,
        );

        final data = createTestDashboardData(
          birthBirdState: PakshiState.ruling,
        );

        await tester.pumpWidget(
          testableWidget(
            ArudamNowCard(data: data),
            overrides: [
              profileLocationProvider.overrideWith(
                (ref) => Future.value(const ProfileLocation()),
              ),
              latestJournalEntryProvider.overrideWith(
                (ref) => Stream.value(entry),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.textContaining('naturally aligned ✓', findRichText: true),
          findsOneWidget,
        );
        expect(find.textContaining('Urgent worldly need?'), findsNothing);
      },
    );

    testWidgets(
      'shows not naturally aligned and opens urgent sheet when misaligned',
      (tester) async {
        final now = DateTime.now();
        const location = ProfileLocation();
        final offset = TimezoneUtils.offsetForLocation(
          latitude: location.latitude,
          longitude: location.longitude,
        );

        // Determine which flow is misaligned right now
        final solarCheck = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: now,
          latitude: location.latitude,
          longitude: location.longitude,
          utcOffset: offset,
        );
        final misalignedFlow = (solarCheck?.isAligned ?? false)
            ? BreathFlow.lunar
            : BreathFlow.solar;

        final entry = SaraKalaiJournalData(
          id: 'entry-misaligned',
          timestamp: now
              .subtract(const Duration(minutes: 5))
              .millisecondsSinceEpoch,
          expectedFlow: misalignedFlow == BreathFlow.solar ? 'lunar' : 'solar',
          actualFlow: misalignedFlow.name,
          isAligned: false,
          nostril: misalignedFlow.nostril,
          isPinned: false,
          wasForcedShift: false,
        );

        final data = createTestDashboardData(
          birthBirdState: PakshiState.ruling,
        );

        await tester.pumpWidget(
          testableWidget(
            ArudamNowCard(data: data),
            overrides: [
              profileLocationProvider.overrideWith(
                (ref) => Future.value(const ProfileLocation()),
              ),
              latestJournalEntryProvider.overrideWith(
                (ref) => Stream.value(entry),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.textContaining('not naturally aligned ⚠', findRichText: true),
          findsOneWidget,
        );
        final urgentBtn = find.textContaining('Urgent worldly need?');
        expect(urgentBtn, findsOneWidget);

        // Tap urgent button to open modal bottom sheet
        await tester.tap(urgentBtn);
        await tester.pumpAndSettle();

        // Modal bottom sheet should display warning tone and shift guidance
        expect(
          find.textContaining('Contralateral Shift Guidance'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Forced breath shifting is an emergency measure'),
          findsOneWidget,
        );
        expect(find.textContaining('Re-check Breath'), findsOneWidget);
      },
    );

    testWidgets('degrades when entry is stale (>30 minutes)', (tester) async {
      final now = DateTime.now();
      final entry = SaraKalaiJournalData(
        id: 'entry-stale',
        timestamp: now
            .subtract(const Duration(minutes: 45))
            .millisecondsSinceEpoch,
        expectedFlow: 'solar',
        actualFlow: 'solar',
        isAligned: true,
        nostril: 'right',
        isPinned: false,
        wasForcedShift: false,
      );

      final data = createTestDashboardData(birthBirdState: PakshiState.ruling);

      await tester.pumpWidget(
        testableWidget(
          ArudamNowCard(data: data),
          overrides: [
            profileLocationProvider.overrideWith(
              (ref) => Future.value(const ProfileLocation()),
            ),
            latestJournalEntryProvider.overrideWith(
              (ref) => Stream.value(entry),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('breath observation needed', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('naturally aligned', findRichText: true),
        findsNothing,
      );
      expect(find.textContaining('Check your breath →'), findsOneWidget);
    });

    testWidgets('enforces floor-lock during active Rahu Kaal', (tester) async {
      final now = DateTime.now();
      final rahu = createTestRahuKaal(
        start: now.subtract(const Duration(minutes: 15)),
        end: now.add(const Duration(minutes: 45)),
      );

      final data = createTestDashboardData(
        birthBirdState: PakshiState.ruling,
        rahuKaal: rahu,
      );

      await tester.pumpWidget(
        testableWidget(
          ArudamNowCard(data: data),
          overrides: [
            profileLocationProvider.overrideWith(
              (ref) => Future.value(const ProfileLocation()),
            ),
            latestJournalEntryProvider.overrideWith(
              (ref) => Stream.value(null),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Hard No (10)'), findsOneWidget);
    });

    testWidgets('enforces floor-lock during active Emakandam', (tester) async {
      final now = DateTime.now();
      final ema = EmakandamResult(
        start: now.subtract(const Duration(minutes: 10)),
        end: now.add(const Duration(minutes: 50)),
        weekday: now.weekday,
      );

      final data = createTestDashboardData(
        birthBirdState: PakshiState.ruling,
        emakandam: ema,
      );

      await tester.pumpWidget(
        testableWidget(
          ArudamNowCard(data: data),
          overrides: [
            profileLocationProvider.overrideWith(
              (ref) => Future.value(const ProfileLocation()),
            ),
            latestJournalEntryProvider.overrideWith(
              (ref) => Stream.value(null),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Hard No (10)'), findsOneWidget);
    });

    testWidgets('Why accordion is collapsed by default and expands on tap', (
      tester,
    ) async {
      final data = createTestDashboardData(birthBirdState: PakshiState.ruling);

      await tester.pumpWidget(
        testableWidget(
          ArudamNowCard(data: data),
          overrides: [
            profileLocationProvider.overrideWith(
              (ref) => Future.value(const ProfileLocation()),
            ),
            latestJournalEntryProvider.overrideWith(
              (ref) => Stream.value(null),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Why? label is rendered
      final whyLabel = find.text('Why?');
      expect(whyLabel, findsOneWidget);

      // Body is collapsed: reason prose and CONF citations are NOT visible
      expect(find.textContaining('CONF-'), findsNothing);
      expect(find.textContaining('Moment — the timing'), findsNothing);

      // Tap Why? to expand
      await tester.tap(whyLabel);
      await tester.pumpAndSettle();

      // Body is now visible with Moment heading, doctrinal prose, and CONF citations
      expect(find.textContaining('Moment — the timing'), findsOneWidget);
      expect(find.textContaining('CONF-PP-004'), findsOneWidget);
      expect(find.textContaining('CONF-'), findsWidgets);
    });

    testWidgets(
      'floor-locked card displays blocked reason and CONF-018 without Moment/You subheads',
      (tester) async {
        final now = DateTime.now();
        final rahu = createTestRahuKaal(
          start: now.subtract(const Duration(minutes: 15)),
          end: now.add(const Duration(minutes: 45)),
        );

        final data = createTestDashboardData(
          birthBirdState: PakshiState.ruling,
          rahuKaal: rahu,
        );

        await tester.pumpWidget(
          testableWidget(
            ArudamNowCard(data: data),
            overrides: [
              profileLocationProvider.overrideWith(
                (ref) => Future.value(const ProfileLocation()),
              ),
              latestJournalEntryProvider.overrideWith(
                (ref) => Stream.value(null),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Tap Why? to expand
        await tester.tap(find.text('Why?'));
        await tester.pumpAndSettle();

        // Shows Blocked heading and CONF-018
        expect(find.text('Blocked'), findsOneWidget);
        expect(find.textContaining('CONF-018'), findsOneWidget);

        // Does NOT show Moment or You subheads
        expect(find.textContaining('Moment — the timing'), findsNothing);
        expect(find.textContaining('You — your readiness'), findsNothing);
      },
    );

    testWidgets(
      'misaligned card shows dampened not blocked readiness line on expand',
      (tester) async {
        final now = DateTime.now();
        const location = ProfileLocation();
        final offset = TimezoneUtils.offsetForLocation(
          latitude: location.latitude,
          longitude: location.longitude,
        );

        final solarCheck = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: now,
          latitude: location.latitude,
          longitude: location.longitude,
          utcOffset: offset,
        );
        final misalignedFlow = (solarCheck?.isAligned ?? false)
            ? BreathFlow.lunar
            : BreathFlow.solar;

        final entry = SaraKalaiJournalData(
          id: 'entry-misaligned-why',
          timestamp: now
              .subtract(const Duration(minutes: 5))
              .millisecondsSinceEpoch,
          expectedFlow: misalignedFlow == BreathFlow.solar ? 'lunar' : 'solar',
          actualFlow: misalignedFlow.name,
          isAligned: false,
          nostril: misalignedFlow.nostril,
          isPinned: false,
          wasForcedShift: false,
        );

        final data = createTestDashboardData(
          birthBirdState: PakshiState.ruling,
        );

        await tester.pumpWidget(
          testableWidget(
            ArudamNowCard(data: data),
            overrides: [
              profileLocationProvider.overrideWith(
                (ref) => Future.value(const ProfileLocation()),
              ),
              latestJournalEntryProvider.overrideWith(
                (ref) => Stream.value(entry),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Tap Why? to expand
        await tester.tap(find.text('Why?'));
        await tester.pumpAndSettle();

        expect(find.textContaining('You — your readiness'), findsOneWidget);
        expect(find.textContaining('dampened — not blocked'), findsOneWidget);
        expect(find.textContaining('CONF-016 / CONF-017'), findsOneWidget);
      },
    );

    testWidgets('renders Why section in Tamil script under ta locale', (
      tester,
    ) async {
      final data = createTestDashboardData(birthBirdState: PakshiState.ruling);

      await tester.pumpWidget(
        testableWidget(
          ArudamNowCard(data: data),
          locale: const Locale('ta'),
          overrides: [
            profileLocationProvider.overrideWith(
              (ref) => Future.value(const ProfileLocation()),
            ),
            latestJournalEntryProvider.overrideWith(
              (ref) => Stream.value(null),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Why? in Tamil
      final whyTa = find.text('ஏன்?');
      expect(whyTa, findsOneWidget);

      // Expand
      await tester.tap(whyTa);
      await tester.pumpAndSettle();

      // Heading in Tamil
      expect(find.text('நேரம் — பிரபஞ்ச தருணம்'), findsOneWidget);
      // Bird reason in Tamil
      expect(find.textContaining('உங்கள் பிறப்புப் பட்சி'), findsOneWidget);
      // Citation still carries CONF id
      expect(find.textContaining('CONF-PP-004'), findsOneWidget);
    });
  });
}
