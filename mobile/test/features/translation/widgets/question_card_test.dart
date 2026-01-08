import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/translation/widgets/question_card.dart';
import 'package:mobile/features/translation/models/translation_question.dart';
import 'package:mobile/features/translation/providers/translation_provider.dart';
import 'package:mobile/features/translation/providers/topic_provider.dart';

void main() {
  group('QuestionCard Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          translationQuestionProvider('daily').overrideWith(
            (ref) async => const TranslationQuestion(
              id: 'test-1',
              sourceText: 'こんにちは、元気ですか？',
              sourceLanguage: '日本語',
              targetLanguage: 'English',
              topic: 'daily',
              difficulty: 'beginner',
              grammarPoints: ['greeting', 'question'],
              modelAnswer: 'Hello, how are you?',
            ),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should display question text', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: QuestionCard(),
            ),
          ),
        ),
      );

      // Wait for async data to load
      await tester.pumpAndSettle();

      expect(find.text('こんにちは、元気ですか？'), findsOneWidget);
    });

    testWidgets('should display source language label', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: QuestionCard(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('日本語'), findsOneWidget);
    });

    testWidgets('should display difficulty badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: QuestionCard(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('beginner'), findsOneWidget);
    });

    testWidgets('should display grammar points as chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: QuestionCard(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('greeting'), findsOneWidget);
      expect(find.text('question'), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(2));
    });

    testWidgets('should show loading indicator while fetching', (WidgetTester tester) async {
      final loadingContainer = ProviderContainer(
        overrides: [
          translationQuestionProvider('daily').overrideWith(
            (ref) async {
              await Future.delayed(const Duration(seconds: 1));
              return const TranslationQuestion(
                id: 'test-1',
                sourceText: 'Test',
                sourceLanguage: 'JP',
                targetLanguage: 'EN',
                topic: 'daily',
                difficulty: 'beginner',
                grammarPoints: [],
              );
            },
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: loadingContainer,
          child: const MaterialApp(
            home: Scaffold(
              body: QuestionCard(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      loadingContainer.dispose();
    });

    testWidgets('should show error state on failure', (WidgetTester tester) async {
      final errorContainer = ProviderContainer(
        overrides: [
          translationQuestionProvider('daily').overrideWith(
            (ref) async => throw Exception('Network error'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: errorContainer,
          child: const MaterialApp(
            home: Scaffold(
              body: QuestionCard(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('エラーが発生しました'), findsOneWidget);

      errorContainer.dispose();
    });
  });
}
