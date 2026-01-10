import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/conversation/presentation/screens/conversation_summary_screen.dart';

void main() {
  group('ConversationSummaryScreen Widget Tests', () {
    testWidgets('should render summary elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSummaryScreen(conversationId: 'test-123'),
          ),
        ),
      );

      // Verify header
      expect(find.text('Great job!'), findsOneWidget);
      expect(find.byIcon(Icons.celebration), findsOneWidget);

      // Verify stats
      expect(find.text('Duration'), findsOneWidget);
      expect(find.text('Pronunciation'), findsOneWidget);
      expect(find.text('XP Earned'), findsOneWidget);
      expect(find.text('8:32'), findsOneWidget);
      expect(find.text('85/100'), findsOneWidget);
      expect(find.text('+120'), findsOneWidget);

      // Verify sections
      expect(find.text('New Vocabulary'), findsOneWidget);
      expect(find.text('Areas to Improve'), findsOneWidget);

      // Verify mock data
      expect(find.text('actually'), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => 
        widget is RichText && widget.text.toPlainText().contains('I goes')), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => 
        widget is RichText && widget.text.toPlainText().contains('I go')), findsOneWidget);

      // Verify action buttons
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Export'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);
      expect(find.text('Practice Again'), findsOneWidget);
    });

    testWidgets('should allow scrolling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSummaryScreen(conversationId: 'test-123'),
          ),
        ),
      );

      // Verify scrollable exists
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      
      // Attempt scroll (if content overflows)
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pump();
      
      // Just verifying it doesn't crash is enough for basic scroll test
    });

    testWidgets('back to home button should be present', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ConversationSummaryScreen(conversationId: 'test-123'),
          ),
        ),
      );

      final backButton = find.text('Back to Home');
      expect(backButton, findsOneWidget);
      
      // We don't test navigation here as it uses popUntil (which needs a Navigator stack)
    });
  });
}
