import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/conversation/presentation/screens/conversation_screen.dart';

/// Test Suite for WP-FE-008-T005: Implement Chat UI
/// 
/// Acceptance Criteria:
/// - [ ] AI messages aligned left với avatar
/// - [ ] User messages aligned right
/// - [ ] Real-time subtitle box (updating as STT streams)
/// - [ ] Typing indicator khi AI đang respond
/// - [ ] Smooth scroll to bottom on new messages
/// - [ ] Correction indicator on messages with errors
/// - [ ] Tap message để xem corrections
void main() {
  group('ConversationScreen Widget Tests', () {
    testWidgets('should render main UI elements', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationScreen(conversationId: 'test-123'),
          ),
        ),
      );

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('Sarah'), findsOneWidget);
    });

    testWidgets('should display AI avatar', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationScreen(conversationId: 'test-123'),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.text('Sarah'), findsOneWidget);
    });

    testWidgets('should display mic button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationScreen(conversationId: 'test-123'),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.mic_none), findsOneWidget);
    });

    testWidgets('should show end conversation dialog on close', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationScreen(conversationId: 'test-123'),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('End Conversation?'), findsOneWidget);
      expect(find.text('Are you sure you want to end this conversation?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('End'), findsOneWidget);
    });

    testWidgets('should show settings sheet', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationScreen(conversationId: 'test-123'),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('AI Speaking Speed'), findsOneWidget);
      expect(find.text('Show Real-time Corrections'), findsOneWidget);
    });

    testWidgets('should toggle recording state on mic button press', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationScreen(conversationId: 'test-123'),
          ),
        ),
      );

      // Act - Press mic button
      final micButton = find.byIcon(Icons.mic_none);
      await tester.press(micButton);
      await tester.pump();

      // Assert - Should show recording icon
      expect(find.byIcon(Icons.mic), findsOneWidget);
    });
  });

  group('ConversationScreen Session Controls Tests', () {
    testWidgets('should display elapsed time', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationScreen(conversationId: 'test-123'),
          ),
        ),
      );

      // Assert - Should show time in mm:ss format
      expect(find.textContaining(':'), findsOneWidget);
    });

    testWidgets('should cancel end conversation dialog', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationScreen(conversationId: 'test-123'),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Assert - Dialog should be dismissed
      expect(find.text('End Conversation?'), findsNothing);
    });
  });
}
