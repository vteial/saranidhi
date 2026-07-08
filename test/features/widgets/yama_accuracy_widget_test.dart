import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/yama_accuracy_widget.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('YamaAccuracyWidget', () {
    testWidgets('shows hint text when no entries', (tester) async {
      const accuracy = YamaAccuracyResult(
        yamaEntries: {
          'yama1': 0, 'yama2': 0, 'yama3': 0, 'yama4': 0, 'yama5': 0,
        },
        totalEntries: 0,
      );

      await tester.pumpWidget(
        testableWidget(YamaAccuracyWidget(accuracy: accuracy)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(YamaAccuracyWidget), findsOneWidget);
      // Should show empty state hint
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('shows progress bars when entries exist', (tester) async {
      const accuracy = YamaAccuracyResult(
        yamaEntries: {
          'yama1': 5, 'yama2': 3, 'yama3': 7, 'yama4': 2, 'yama5': 1,
        },
        totalEntries: 18,
      );

      await tester.pumpWidget(
        testableWidget(YamaAccuracyWidget(accuracy: accuracy)),
      );
      await tester.pumpAndSettle();

      // 5 progress bars for 5 yamas
      expect(find.byType(LinearProgressIndicator), findsNWidgets(5));
    });

    testWidgets('displays coverage percentage', (tester) async {
      const accuracy = YamaAccuracyResult(
        yamaEntries: {
          'yama1': 5, 'yama2': 3, 'yama3': 7, 'yama4': 0, 'yama5': 0,
        },
        totalEntries: 15,
      );

      await tester.pumpWidget(
        testableWidget(YamaAccuracyWidget(accuracy: accuracy)),
      );
      await tester.pumpAndSettle();

      // 3 out of 5 yamas captured = 60%
      expect(find.text('60%'), findsOneWidget);
    });
  });
}
