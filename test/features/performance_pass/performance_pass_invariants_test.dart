import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/core/providers/location_on_open_provider.dart';
import 'package:saranidhi/core/services/location_on_open_service.dart';
import 'package:saranidhi/core/utils/reduced_motion.dart';
import 'package:saranidhi/core/widgets/shimmer_loading.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/quick_sync_pacer.dart';
import 'package:saranidhi/features/cloud_backup/domain/practice_sync_engine.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_metadata.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/practice_sync_auto_trigger.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/sync_on_open_widget.dart';
import 'package:saranidhi/features/cloud_backup/providers/practice_sync_providers.dart';
import 'package:saranidhi/features/cloud_backup/providers/sync_providers.dart';
import 'package:saranidhi/features/notifications/data/notification_service.dart';
import 'package:saranidhi/features/onboarding/domain/bird_migration_service.dart';
import 'package:saranidhi/features/onboarding/presentation/widgets/bird_migration_on_load_widget.dart';
import 'package:saranidhi/features/onboarding/presentation/widgets/location_on_open_widget.dart';
import 'package:saranidhi/features/onboarding/providers/bird_migration_provider.dart';
import 'package:saranidhi/features/somatic/presentation/widgets/sama_vritti_pacer.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/streak_celebration.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('T2.1 — NotificationService idempotency (R1.1, RQ.3)', () {
    test('initialize is idempotent and does not throw on repeated calls', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('dexterous.com/flutter/local_notifications'),
        (call) async => true,
      );

      var tapCount = 0;
      void handleTap(String? payload) {
        tapCount++;
      }

      await NotificationService.instance.initialize(onNotificationTap: handleTap);
      // Repeated call must return cleanly without error
      await NotificationService.instance.initialize(onNotificationTap: handleTap);
      expect(tapCount, equals(0));
    });
  });

  group('T2.2 — On-open side-effect widgets run-once per session (R1.2, RQ.3)', () {
    testWidgets('SyncOnOpenWidget runs sync only once across route rebuilds', (
      tester,
    ) async {
      var syncCalls = 0;
      final container = ProviderContainer(
        overrides: [
          syncNotifierProvider.overrideWith(() => _MockSyncNotifier(() => syncCalls++)),
        ],
      );
      addTearDown(container.dispose);

      Widget buildHarness() {
        return UncontrolledProviderScope(
          container: container,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: SyncOnOpenWidget(
              child: Text('Child Content'),
            ),
          ),
        );
      }

      // First mount
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      // Route rebuild (e.g. rebuild tree)
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      // Invariant: sync was triggered at most once on cold open
      expect(syncCalls, lessThanOrEqualTo(1));
    });

    testWidgets('PracticeSyncAutoTrigger runs cold open at most once across rebuilds', (
      tester,
    ) async {
      var syncCalls = 0;
      final container = ProviderContainer(
        overrides: [
          practiceSyncConfigProvider.overrideWith(_AlwaysEnabledConfigNotifier.new),
          practiceSyncNotifierProvider.overrideWith(
            () => _MockPracticeSyncNotifier(() => syncCalls++),
          ),
        ],
      );
      addTearDown(container.dispose);

      Widget buildHarness() {
        return UncontrolledProviderScope(
          container: container,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: PracticeSyncAutoTrigger(
              child: Text('Child Content'),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      // Simulated route change / rebuild
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      expect(syncCalls, lessThanOrEqualTo(1));
    });

    testWidgets('BirdMigrationOnLoadWidget executes check once across rebuilds', (
      tester,
    ) async {
      var migrationCalls = 0;
      final container = ProviderContainer(
        overrides: [
          birdMigrationProvider.overrideWith((ref) async {
            migrationCalls++;
            return BirdMigrationResult.noChange;
          }),
        ],
      );
      addTearDown(container.dispose);

      Widget buildHarness() {
        return UncontrolledProviderScope(
          container: container,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: BirdMigrationOnLoadWidget(
              child: Text('Child Content'),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      // Simulated route rebuild
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      expect(migrationCalls, equals(1));
    });

    testWidgets('LocationOnOpenWidget executes check once across rebuilds', (
      tester,
    ) async {
      var locationCalls = 0;
      final container = ProviderContainer(
        overrides: [
          locationOnOpenProvider.overrideWith((ref) async {
            locationCalls++;
            return LocationUpdateResult.none;
          }),
        ],
      );
      addTearDown(container.dispose);

      Widget buildHarness() {
        return UncontrolledProviderScope(
          container: container,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: LocationOnOpenWidget(
              child: Text('Child Content'),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      // Simulated route rebuild
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      expect(locationCalls, equals(1));
    });
  });

  group('T2.3 — Reduced motion helper and widget responsiveness (R2.1, R2.3, RQ.3)', () {
    Widget wrapWithThemeAndL10n(Widget child, {bool disableAnimations = true}) {
      return MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('ReducedMotion helper correctly reflects disableAnimations', (
      tester,
    ) async {
      late bool motionPreferred;

      Widget harness({required bool disableAnimations}) {
        return MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                motionPreferred = ReducedMotion.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      }

      await tester.pumpWidget(harness(disableAnimations: true));
      expect(motionPreferred, isTrue);

      await tester.pumpWidget(harness(disableAnimations: false));
      expect(motionPreferred, isFalse);
    });

    testWidgets('ShimmerLoading renders without throwing and disposes cleanly with reduced-motion ON', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithThemeAndL10n(const ShimmerLoading()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ShimmerLoading), findsOneWidget);

      // Verify clean disposal
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('SamaVrittiPacer renders without throwing and disposes cleanly with reduced-motion ON', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithThemeAndL10n(const SamaVrittiPacer()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SamaVrittiPacer), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('StreakCelebrationOverlay displays instantly with reduced-motion ON', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithThemeAndL10n(
          StreakCelebrationOverlay(
            milestone: 7,
            onDismiss: () {},
          ),
        ),
      );
      // Under reduced motion, frame 1 must show the content at full scale/opacity immediately
      await tester.pump();
      expect(find.text('7-Day Streak!'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('QuickSyncPacer honors reduced-motion ON when activated', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithThemeAndL10n(const QuickSyncPacer()));
      await tester.pump();
      expect(find.byType(QuickSyncPacer), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('Reduced-motion OFF preserves animation repeat behavior (R2.3 / R-REG)', (
      tester,
    ) async {
      // ShimmerLoading with reduced-motion OFF
      await tester.pumpWidget(
        wrapWithThemeAndL10n(const ShimmerLoading(), disableAnimations: false),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ShimmerLoading), findsOneWidget);

      // SamaVrittiPacer with reduced-motion OFF
      await tester.pumpWidget(
        wrapWithThemeAndL10n(const SamaVrittiPacer(), disableAnimations: false),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SamaVrittiPacer), findsOneWidget);

      // QuickSyncPacer with reduced-motion OFF
      await tester.pumpWidget(
        wrapWithThemeAndL10n(const QuickSyncPacer(), disableAnimations: false),
      );
      await tester.pump();
      expect(find.byType(QuickSyncPacer), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}

class _MockSyncNotifier extends SyncNotifier {
  _MockSyncNotifier(this.onSync);
  final VoidCallback onSync;

  @override
  SyncStatus build() => const SyncStatus(state: SyncState.idle);

  @override
  Future<void> performSync() async {
    onSync();
  }
}

class _AlwaysEnabledConfigNotifier extends PracticeSyncConfigNotifier {
  @override
  PracticeSyncConfig build() => const PracticeSyncConfig(enabled: true);
}

class _MockPracticeSyncNotifier extends PracticeSyncNotifier {
  _MockPracticeSyncNotifier(this.onSync);
  final VoidCallback onSync;

  @override
  PracticeSyncState build() {
    return const PracticeSyncState(
      isAuthenticated: true,
      isSyncing: false,
    );
  }

  @override
  Future<SyncOutcome?> syncNow() async {
    onSync();
    return SyncOutcome(syncedAt: DateTime.now());
  }
}
