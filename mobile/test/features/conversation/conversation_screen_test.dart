import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/conversation/presentation/screens/conversation_screen.dart';

void main() {
  const testConversationId = 'test-id-123';

  testWidgets('ConversationScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ConversationScreen(conversationId: testConversationId),
        ),
      ),
    );

    // Verify Avatar
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.text('Sarah'), findsOneWidget);

    // Verify Timer (00:00)
    expect(find.text('00:00'), findsOneWidget);

    // Verify Mic Button
    expect(find.byIcon(Icons.mic_none), findsOneWidget);
    
    // Verify Text is empty (no turns yet)
    // We expect 0 ChatBubble widgets - hard to check directly as widget is private _ConversationScreenState method result.
    // But we can check ListView
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('ConversationScreen interaction', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ConversationScreen(conversationId: testConversationId),
        ),
      ),
    );

    // Verify initial state
    expect(find.byIcon(Icons.mic_none), findsOneWidget);

    // Press and hold Mic
    // Find the mic icon to locate the button
    final micIconFinder = find.byIcon(Icons.mic_none);
    final micGesture = await tester.startGesture(tester.getCenter(micIconFinder));
    await tester.pump();
    
    // Check if mic icon changed to recording state (Icons.mic)
    expect(find.byIcon(Icons.mic), findsOneWidget);
    
    // Release
    await micGesture.up();
    await tester.pump();
    
    // Back to normal
    expect(find.byIcon(Icons.mic_none), findsOneWidget);
  });

  testWidgets('ConversationScreen open settings', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ConversationScreen(conversationId: testConversationId),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('AI Speaking Speed'), findsOneWidget);
    expect(find.text('Show Real-time Corrections'), findsOneWidget);
  });

  testWidgets('ConversationScreen end dialog', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ConversationScreen(conversationId: testConversationId),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('End Conversation?'), findsOneWidget);
    expect(find.text('End'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });
}
