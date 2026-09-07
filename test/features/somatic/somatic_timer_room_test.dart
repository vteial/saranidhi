import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/somatic/data/somatic_intervention_repository.dart';
import 'package:saranidhi/features/somatic/domain/somatic_intervention_session.dart';
import 'package:saranidhi/features/somatic/presentation/somatic_timer_room.dart';
import 'package:saranidhi/features/somatic/presentation/widgets/cross_lateral_instruction_card.dart';
import 'package:saranidhi/features/somatic/presentation/widgets/sama_vritti_pacer.dart';
import 'package:saranidhi/features/somatic/providers/somatic_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  // Wraps [child] in a localized MaterialApp with the somatic repository
  // provider backed by an in-memory database. SomaticTimerRoom supplies its
  // own Scaffold, so the child is used directly as `home`.
  Widget wrap(Widget child) {
    // Untyped list + .cast() keeps this Riverpod 3 compatible (the package
    // does not export `Override`, so the list must not be annotated).
    final overrides = [
      somaticInterventionRepositoryProvider.overrideWith(
        (ref) => SomaticInterventionRepository(db),
      ),
    ];
    return ProviderScope(
      overrides: overrides.cast(),
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: child,
      ),
    );
  }

  SomaticInterventionSession session(InterventionType type) {
    return SomaticInterventionSession(
      id: 'test-session',
      startTime: DateTime(2026, 7, 15, 10, 30),
      type: type,
      targetFlow: 'left',
      initialFlow: 'right',
    );
  }

  group('SomaticTimerRoom', () {
    testWidgets('renders the initial 03:00 countdown for postureShift + the '
        'room title, instruction card and pacer', (tester) async {
      await tester.pumpWidget(
        wrap(SomaticTimerRoom(session: session(InterventionType.postureShift))),
      );
      // NOT pumpAndSettle: the room has a periodic Timer. Pump one frame.
      await tester.pump();

      // Posture shift duration is 180s → 03:00 before the timer ticks.
      expect(find.text('03:00'), findsOneWidget);
      expect(find.text('Clear Your Breath Channel'), findsOneWidget);
      expect(find.byType(CrossLateralInstructionCard), findsOneWidget);
      expect(find.byType(SamaVrittiPacer), findsOneWidget);
    });

    testWidgets('renders the initial 05:00 countdown for axillaryPressure',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          SomaticTimerRoom(session: session(InterventionType.axillaryPressure)),
        ),
      );
      await tester.pump();

      // Axillary pressure duration is 300s → 05:00.
      expect(find.text('05:00'), findsOneWidget);
    });

    testWidgets('counts down after one second', (tester) async {
      await tester.pumpWidget(
        wrap(SomaticTimerRoom(session: session(InterventionType.postureShift))),
      );
      await tester.pump();
      expect(find.text('03:00'), findsOneWidget);

      // Advance a single tick (do NOT run to completion, which launches the
      // post-session nostril-test sheet).
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('02:59'), findsOneWidget);
    });
  });
}
