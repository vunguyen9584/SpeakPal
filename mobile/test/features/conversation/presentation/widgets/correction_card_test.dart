import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/conversation/presentation/widgets/correction_card.dart';
import 'package:mobile/features/conversation/domain/models/turn.dart';

/// Test Suite for CorrectionCard Widget
/// 
/// Acceptance Criteria from WP-FE-008-T007:
/// - [ ] Correction cards với original → corrected format
/// - [ ] Color coded by severity (high=red, medium=yellow, low=blue)
/// - [ ] Tap để expand và show full explanation
/// - [ ] Japanese explanation available
void main() {
  group('CorrectionCard Widget Tests', () {
    testWidgets('should display correction in original → corrected format', (WidgetTester tester) async {
      // Arrange
      const correction = Correction(
        type: 'grammar',
        original: 'I goes',
        corrected: 'I go',
        explanation: 'Subject-verb agreement error',
        explanationJa: '主語と動詞の一致エラー',
        severity: 'high',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectionCard(correction: correction),
          ),
        ),
      );

      // Assert - Check for RichText widget containing the correction
      expect(find.byType(RichText), findsWidgets);
      expect(find.text('Subject-verb agreement error'), findsOneWidget);
      
      // Verify the card exists
      expect(find.byType(CorrectionCard), findsOneWidget);
    });

    testWidgets('should use red color for high severity', (WidgetTester tester) async {
      // Arrange
      const correction = Correction(
        type: 'grammar',
        original: 'test',
        corrected: 'tested',
        explanation: 'Test',
        explanationJa: 'テスト',
        severity: 'high',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectionCard(correction: correction),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, Colors.red.withValues(alpha: 0.1));
    });

    testWidgets('should use orange color for medium severity', (WidgetTester tester) async {
      // Arrange
      const correction = Correction(
        type: 'vocabulary',
        original: 'good',
        corrected: 'excellent',
        explanation: 'Better word choice',
        explanationJa: 'より良い単語選択',
        severity: 'medium',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectionCard(correction: correction),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, Colors.orange.withValues(alpha: 0.1));
    });

    testWidgets('should use blue color for low severity', (WidgetTester tester) async {
      // Arrange
      const correction = Correction(
        type: 'pronunciation',
        original: 'tomato',
        corrected: 'tomato',
        explanation: 'Pronunciation improvement',
        explanationJa: '発音の改善',
        severity: 'low',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectionCard(correction: correction),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, Colors.blue.withValues(alpha: 0.1));
    });

    testWidgets('should display correct icon for grammar type', (WidgetTester tester) async {
      // Arrange
      const correction = Correction(
        type: 'grammar',
        original: 'test',
        corrected: 'tested',
        explanation: 'Test',
        explanationJa: 'テスト',
        severity: 'high',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectionCard(correction: correction),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.abc), findsOneWidget);
    });

    testWidgets('should display correct icon for vocabulary type', (WidgetTester tester) async {
      // Arrange
      const correction = Correction(
        type: 'vocabulary',
        original: 'test',
        corrected: 'tested',
        explanation: 'Test',
        explanationJa: 'テスト',
        severity: 'medium',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectionCard(correction: correction),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.book), findsOneWidget);
    });

    testWidgets('should display correct icon for pronunciation type', (WidgetTester tester) async {
      // Arrange
      const correction = Correction(
        type: 'pronunciation',
        original: 'test',
        corrected: 'tested',
        explanation: 'Test',
        explanationJa: 'テスト',
        severity: 'low',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectionCard(correction: correction),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;
      const correction = Correction(
        type: 'grammar',
        original: 'test',
        corrected: 'tested',
        explanation: 'Test',
        explanationJa: 'テスト',
        severity: 'high',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CorrectionCard(
              correction: correction,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Assert
      expect(tapped, true);
    });
  });
}
