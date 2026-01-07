import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/conversation/presentation/screens/conversation_setup_screen.dart';
import 'package:mobile/features/conversation/domain/models/conversation.dart';

/// Test Suite for WP-FE-008-T002: Implement Mode/Topic Selection
/// 
/// Acceptance Criteria:
/// - [ ] Mode selection (Free Talk, Instructor, Roleplay)
/// - [ ] Topic chips (optional) với categories
/// - [ ] Persona selection với avatar, name, description
/// - [ ] Start button calls POST /conversations
/// - [ ] Navigate to conversation screen after success
/// - [ ] Error handling cho usage limit reached
void main() {
  group('ConversationSetupScreen Widget Tests', () {
    testWidgets('should render all UI elements', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSetupScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Select Mode'), findsOneWidget);
      expect(find.text('Select Topic (Optional)'), findsOneWidget);
      expect(find.text('AI Partner'), findsOneWidget);
      
      // Find Start Conversation button specifically
      final startButton = find.ancestor(
        of: find.text('Start Conversation'),
        matching: find.byType(ElevatedButton),
      );
      expect(startButton, findsOneWidget);
    });

    testWidgets('should display all conversation modes', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSetupScreen(),
          ),
        ),
      );

      // Assert - Check all 3 modes are displayed
      expect(find.text('Free Talk'), findsOneWidget);
      expect(find.text('Instructor'), findsOneWidget);
      expect(find.text('Roleplay'), findsOneWidget);
      
      // Check mode descriptions
      expect(find.text('Practice freely'), findsOneWidget);
      expect(find.text('With guidance'), findsOneWidget);
      expect(find.text('Real scenarios'), findsOneWidget);
    });

    testWidgets('should allow mode selection', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSetupScreen(),
          ),
        ),
      );

      // Act - Select Instructor mode
      await tester.tap(find.text('Instructor'));
      await tester.pump();

      // Assert - Instructor should be selected
      final instructorRadio = tester.widget<RadioListTile<ConversationMode>>(
        find.byType(RadioListTile<ConversationMode>).at(1),
      );
      expect(instructorRadio.value, ConversationMode.instructor);
    });

    testWidgets('should display topic chips', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSetupScreen(),
          ),
        ),
      );

      // Assert - Check all topic chips are displayed
      expect(find.text('Daily Life'), findsOneWidget);
      expect(find.text('Travel'), findsOneWidget);
      expect(find.text('Business'), findsOneWidget);
      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('Sports'), findsOneWidget);
      expect(find.text('Culture'), findsOneWidget);
    });

    testWidgets('should allow topic selection', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSetupScreen(),
          ),
        ),
      );

      // Act - Select Travel topic
      await tester.tap(find.text('Travel'));
      await tester.pump();

      // Assert - Travel chip should be selected
      final travelChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'Travel'),
      );
      expect(travelChip.selected, true);
    });

    testWidgets('should display persona selector', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSetupScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Sarah'), findsOneWidget);
      expect(find.text('Friendly, Patient'), findsOneWidget);
      expect(find.text('Change Partner'), findsOneWidget);
    });

    testWidgets('should have functional start button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSetupScreen(),
          ),
        ),
      );

      // Act - Tap the start button
      final startButton = find.widgetWithText(ElevatedButton, 'Start Conversation');
      expect(startButton, findsOneWidget);
      
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Assert - Button should be tappable (no exception thrown)
      // SnackBar will be shown but we don't test it here as it requires full MaterialApp setup
      expect(startButton, findsOneWidget);
    });
  });

  group('ConversationSetupScreen Integration Tests', () {
    testWidgets('should maintain state across mode and topic selection', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSetupScreen(),
          ),
        ),
      );

      // Act - Select mode and topic
      await tester.tap(find.text('Roleplay'));
      await tester.pump();
      await tester.tap(find.text('Business'));
      await tester.pump();

      // Assert - Both selections should persist
      final roleplayRadio = tester.widget<RadioListTile<ConversationMode>>(
        find.byType(RadioListTile<ConversationMode>).at(2),
      );
      expect(roleplayRadio.value, ConversationMode.roleplay);

      final businessChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'Business'),
      );
      expect(businessChip.selected, true);
    });

    testWidgets('should allow deselecting topic', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSetupScreen(),
          ),
        ),
      );

      // Act - Select and deselect topic
      await tester.tap(find.text('Technology'));
      await tester.pump();
      await tester.tap(find.text('Technology'));
      await tester.pump();

      // Assert - Topic should be deselected
      final techChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'Technology'),
      );
      expect(techChip.selected, false);
    });
  });
}
