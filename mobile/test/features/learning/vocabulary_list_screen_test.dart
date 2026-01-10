import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/learning/presentation/screens/vocabulary_list_screen.dart';

void main() {
  testWidgets('VocabularyListScreen renders empty state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: VocabularyListScreen(),
        ),
      ),
    );

    // Verify title
    expect(find.text('My Vocabulary'), findsOneWidget);
    
    // Verify search bar
    expect(find.byType(TextField), findsOneWidget);
    
    // Verify filter chips
    expect(find.text('All'), findsOneWidget);
    expect(find.text('new'), findsOneWidget);
    
    // Verify empty state
    expect(find.text('No vocabulary yet'), findsOneWidget);
  });
}
