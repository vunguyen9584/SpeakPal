import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/conversation/presentation/widgets/chat_bubble.dart';
import 'package:mobile/features/conversation/domain/models/turn.dart';

/// Test Suite for ChatBubble Widget
/// 
/// Verifies:
/// - AI messages aligned left
/// - User messages aligned right
/// - Correction indicator display
/// - Tap handling for corrections
void main() {
  group('ChatBubble Widget Tests', () {
    testWidgets('should display AI message aligned left', (WidgetTester tester) async {
      // Arrange
      final turn = Turn(
        id: '1',
        speaker: TurnSpeaker.ai,
        content: 'Hello, how are you?',
        sequence: 1,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubble(turn: turn),
          ),
        ),
      );

      // Assert
      final align = tester.widget<Align>(find.byType(Align));
      expect(align.alignment, Alignment.centerLeft);
      expect(find.text('Hello, how are you?'), findsOneWidget);
    });

    testWidgets('should display user message aligned right', (WidgetTester tester) async {
      // Arrange
      final turn = Turn(
        id: '2',
        speaker: TurnSpeaker.user,
        content: 'I am fine, thank you!',
        sequence: 2,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubble(turn: turn),
          ),
        ),
      );

      // Assert
      final align = tester.widget<Align>(find.byType(Align));
      expect(align.alignment, Alignment.centerRight);
      expect(find.text('I am fine, thank you!'), findsOneWidget);
    });

    testWidgets('should show correction indicator when corrections exist', (WidgetTester tester) async {
      // Arrange
      final turn = Turn(
        id: '3',
        speaker: TurnSpeaker.user,
        content: 'I goes to school',
        sequence: 3,
        createdAt: DateTime.now(),
        corrections: [
          const Correction(
            type: 'grammar',
            original: 'I goes',
            corrected: 'I go',
            explanation: 'Subject-verb agreement',
            explanationJa: '主語と動詞の一致',
            severity: 'high',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubble(turn: turn),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.text('1 correction'), findsOneWidget);
    });

    testWidgets('should show plural corrections text', (WidgetTester tester) async {
      // Arrange
      final turn = Turn(
        id: '4',
        speaker: TurnSpeaker.user,
        content: 'I goes to school yesterday',
        sequence: 4,
        createdAt: DateTime.now(),
        corrections: [
          const Correction(
            type: 'grammar',
            original: 'I goes',
            corrected: 'I go',
            explanation: 'Subject-verb agreement',
            explanationJa: '主語と動詞の一致',
            severity: 'high',
          ),
          const Correction(
            type: 'grammar',
            original: 'go',
            corrected: 'went',
            explanation: 'Past tense',
            explanationJa: '過去形',
            severity: 'medium',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubble(turn: turn),
          ),
        ),
      );

      // Assert
      expect(find.text('2 corrections'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped with corrections', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;
      final turn = Turn(
        id: '5',
        speaker: TurnSpeaker.user,
        content: 'Test message',
        sequence: 5,
        createdAt: DateTime.now(),
        corrections: [
          const Correction(
            type: 'grammar',
            original: 'test',
            corrected: 'tested',
            explanation: 'Test',
            explanationJa: 'テスト',
            severity: 'low',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              turn: turn,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Assert
      expect(tapped, true);
    });

    testWidgets('should not be tappable without corrections', (WidgetTester tester) async {
      // Arrange
      final turn = Turn(
        id: '6',
        speaker: TurnSpeaker.user,
        content: 'Perfect message',
        sequence: 6,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubble(turn: turn),
          ),
        ),
      );

      // Assert
      final gestureDetector = tester.widget<GestureDetector>(find.byType(GestureDetector));
      expect(gestureDetector.onTap, isNull);
    });
  });
}
