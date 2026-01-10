import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/translation/widgets/feedback_card.dart';

void main() {
  group('FeedbackCard Widget Tests', () {
    testWidgets('should display good points section', (WidgetTester tester) async {
      const feedback = [
        '👍 文法が正確です',
        '👍 発音が良いです',
        '改善: もっと早く話しましょう',
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeedbackCard(feedback: feedback),
          ),
        ),
      );

      expect(find.text('良い点'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should display improvements section', (WidgetTester tester) async {
      const feedback = [
        '👍 文法が正確です',
        '改善: もっと早く話しましょう',
        '改善: 語彙を増やしましょう',
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeedbackCard(feedback: feedback),
          ),
        ),
      );

      expect(find.text('改善点'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb), findsOneWidget);
    });

    testWidgets('should display feedback as chips', (WidgetTester tester) async {
      const feedback = [
        '👍 文法が正確です',
        '👍 発音が良いです',
        '改善: スピードアップ',
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeedbackCard(feedback: feedback),
          ),
        ),
      );

      expect(find.byType(Chip), findsNWidgets(3));
    });

    testWidgets('should remove thumbs up prefix from good points', (WidgetTester tester) async {
      const feedback = [
        '👍 文法が正確です',
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeedbackCard(feedback: feedback),
          ),
        ),
      );

      expect(find.text('文法が正確です'), findsOneWidget);
      expect(find.text('👍 文法が正確です'), findsNothing);
    });

    testWidgets('should handle empty feedback list', (WidgetTester tester) async {
      const feedback = <String>[];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeedbackCard(feedback: feedback),
          ),
        ),
      );

      expect(find.text('フィードバック'), findsOneWidget);
      expect(find.byType(Chip), findsNothing);
    });

    testWidgets('should handle only good points', (WidgetTester tester) async {
      const feedback = [
        '👍 完璧です',
        '👍 素晴らしい',
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeedbackCard(feedback: feedback),
          ),
        ),
      );

      expect(find.text('良い点'), findsOneWidget);
      expect(find.text('改善点'), findsNothing);
    });

    testWidgets('should handle only improvements', (WidgetTester tester) async {
      const feedback = [
        '改善: もっと練習が必要',
        '改善: 語彙を増やす',
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeedbackCard(feedback: feedback),
          ),
        ),
      );

      expect(find.text('良い点'), findsNothing);
      expect(find.text('改善点'), findsOneWidget);
    });
  });
}
