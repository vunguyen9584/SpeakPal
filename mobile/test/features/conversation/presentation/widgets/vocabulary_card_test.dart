import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/conversation/presentation/widgets/vocabulary_card.dart';
import 'package:mobile/features/conversation/domain/models/suggestion.dart';

/// Test Suite for VocabularyCard Widget
/// 
/// Acceptance Criteria from WP-FE-009-T004:
/// - [ ] List vocabulary với word, pronunciation, meaning
/// - [ ] Part of speech indicator (noun, verb, etc.)
/// - [ ] Example sentence
/// - [ ] Save to word list button
/// - [ ] Bookmark icon changes when saved
/// - [ ] Tap để hear pronunciation
void main() {
  group('VocabularyCard Widget Tests', () {
    testWidgets('should display all vocabulary information', (WidgetTester tester) async {
      // Arrange
      const vocab = VocabularyItem(
        word: 'actually',
        pronunciation: '/ˈæktʃuəli/',
        meaning: '実は、実際には',
        partOfSpeech: 'adverb',
        exampleSentence: 'I actually enjoyed the movie.',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VocabularyCard(word: vocab),
          ),
        ),
      );

      // Assert
      expect(find.text('actually'), findsOneWidget);
      expect(find.text('/ˈæktʃuəli/'), findsOneWidget);
      expect(find.text('実は、実際には'), findsOneWidget);
      expect(find.text('adverb'), findsOneWidget);
      expect(find.text('I actually enjoyed the movie.'), findsOneWidget);
    });

    testWidgets('should display part of speech badge', (WidgetTester tester) async {
      // Arrange
      const vocab = VocabularyItem(
        word: 'run',
        pronunciation: '/rʌn/',
        meaning: '走る',
        partOfSpeech: 'verb',
        exampleSentence: 'I run every morning.',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VocabularyCard(word: vocab),
          ),
        ),
      );

      // Assert
      expect(find.text('verb'), findsOneWidget);
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('verb'),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('should show bookmark border icon initially', (WidgetTester tester) async {
      // Arrange
      const vocab = VocabularyItem(
        word: 'test',
        pronunciation: '/test/',
        meaning: 'テスト',
        partOfSpeech: 'noun',
        exampleSentence: 'This is a test.',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VocabularyCard(word: vocab),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    });

    testWidgets('should toggle bookmark icon when tapped', (WidgetTester tester) async {
      // Arrange
      const vocab = VocabularyItem(
        word: 'test',
        pronunciation: '/test/',
        meaning: 'テスト',
        partOfSpeech: 'noun',
        exampleSentence: 'This is a test.',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VocabularyCard(word: vocab),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsNothing);
    });

    testWidgets('should call onSave when bookmark is tapped', (WidgetTester tester) async {
      // Arrange
      bool saved = false;
      const vocab = VocabularyItem(
        word: 'test',
        pronunciation: '/test/',
        meaning: 'テスト',
        partOfSpeech: 'noun',
        exampleSentence: 'This is a test.',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VocabularyCard(
              word: vocab,
              onSave: () => saved = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pump();

      // Assert
      expect(saved, true);
    });

    testWidgets('should have pronunciation play button', (WidgetTester tester) async {
      // Arrange
      const vocab = VocabularyItem(
        word: 'test',
        pronunciation: '/test/',
        meaning: 'テスト',
        partOfSpeech: 'noun',
        exampleSentence: 'This is a test.',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VocabularyCard(word: vocab),
          ),
        ),
      );

      // Assert - Find IconButton with volume_up icon
      final iconButtons = find.byType(IconButton);
      expect(iconButtons, findsWidgets);
      
      // Find the volume_up icon specifically
      final volumeIcon = find.descendant(
        of: find.byType(IconButton),
        matching: find.byIcon(Icons.volume_up),
      );
      expect(volumeIcon, findsOneWidget);
    });

    testWidgets('should call onPlayPronunciation when volume icon tapped', (WidgetTester tester) async {
      // Arrange
      bool played = false;
      const vocab = VocabularyItem(
        word: 'test',
        pronunciation: '/test/',
        meaning: 'テスト',
        partOfSpeech: 'noun',
        exampleSentence: 'This is a test.',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VocabularyCard(
              word: vocab,
              onPlayPronunciation: () => played = true,
            ),
          ),
        ),
      );

      // Act - Find and tap the pronunciation button
      final volumeButton = find.ancestor(
        of: find.byIcon(Icons.volume_up),
        matching: find.byType(IconButton),
      );
      await tester.tap(volumeButton.first);
      await tester.pump();

      // Assert
      expect(played, true);
    });

    testWidgets('should display example sentence in styled container', (WidgetTester tester) async {
      // Arrange
      const vocab = VocabularyItem(
        word: 'beautiful',
        pronunciation: '/ˈbjuːtɪfl/',
        meaning: '美しい',
        partOfSpeech: 'adjective',
        exampleSentence: 'The sunset is beautiful.',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VocabularyCard(word: vocab),
          ),
        ),
      );

      // Assert - Check example sentence is displayed
      expect(find.text('The sunset is beautiful.'), findsOneWidget);
      
      // Check quote icon exists
      final quoteIcon = find.byIcon(Icons.format_quote);
      expect(quoteIcon, findsOneWidget);
      
      // Verify it's in a Container with decoration
      final container = find.ancestor(
        of: find.text('The sunset is beautiful.'),
        matching: find.byType(Container),
      );
      expect(container, findsWidgets);
    });
  });
}
