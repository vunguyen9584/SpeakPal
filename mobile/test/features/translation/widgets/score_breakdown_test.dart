import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/translation/widgets/score_breakdown.dart';
import 'package:mobile/features/translation/models/translation_result.dart';

void main() {
  group('ScoreBreakdown Widget Tests', () {
    testWidgets('should display all score categories', (WidgetTester tester) async {
      const breakdown = ScoreBreakdown(
        grammarScore: 35,
        vocabularyScore: 25,
        speedScore: 20,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScoreBreakdown(breakdown: breakdown),
          ),
        ),
      );

      expect(find.text('文法'), findsOneWidget);
      expect(find.text('語彙'), findsOneWidget);
      expect(find.text('スピード'), findsOneWidget);
    });

    testWidgets('should display correct scores', (WidgetTester tester) async {
      const breakdown = ScoreBreakdown(
        grammarScore: 35,
        vocabularyScore: 25,
        speedScore: 20,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScoreBreakdown(breakdown: breakdown),
          ),
        ),
      );

      expect(find.text('35/40'), findsOneWidget);
      expect(find.text('25/30'), findsOneWidget);
      expect(find.text('20/30'), findsOneWidget);
    });

    testWidgets('should display progress bars', (WidgetTester tester) async {
      const breakdown = ScoreBreakdown(
        grammarScore: 40,
        vocabularyScore: 30,
        speedScore: 30,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScoreBreakdown(breakdown: breakdown),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsNWidgets(3));
    });

    testWidgets('should calculate correct percentages', (WidgetTester tester) async {
      const breakdown = ScoreBreakdown(
        grammarScore: 20, // 50% of 40
        vocabularyScore: 15, // 50% of 30
        speedScore: 15, // 50% of 30
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScoreBreakdown(breakdown: breakdown),
          ),
        ),
      );

      final progressBars = tester.widgetList<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(progressBars.elementAt(0).value, 0.5);
      expect(progressBars.elementAt(1).value, 0.5);
      expect(progressBars.elementAt(2).value, 0.5);
    });

    testWidgets('should handle perfect scores', (WidgetTester tester) async {
      const breakdown = ScoreBreakdown(
        grammarScore: 40,
        vocabularyScore: 30,
        speedScore: 30,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScoreBreakdown(breakdown: breakdown),
          ),
        ),
      );

      final progressBars = tester.widgetList<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(progressBars.elementAt(0).value, 1.0);
      expect(progressBars.elementAt(1).value, 1.0);
      expect(progressBars.elementAt(2).value, 1.0);
    });

    testWidgets('should handle zero scores', (WidgetTester tester) async {
      const breakdown = ScoreBreakdown(
        grammarScore: 0,
        vocabularyScore: 0,
        speedScore: 0,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScoreBreakdown(breakdown: breakdown),
          ),
        ),
      );

      final progressBars = tester.widgetList<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(progressBars.elementAt(0).value, 0.0);
      expect(progressBars.elementAt(1).value, 0.0);
      expect(progressBars.elementAt(2).value, 0.0);
    });
  });
}
