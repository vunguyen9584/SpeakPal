import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/translation/data/translation_repository.dart';
import 'package:mobile/features/translation/models/models.dart';
import 'package:mobile/features/translation/providers/translation_provider.dart';

class MockTranslationRepository extends Mock implements TranslationRepository {}

void main() {
  group('TranslationProvider Tests', () {
    late MockTranslationRepository mockRepository;

    setUp(() {
      mockRepository = MockTranslationRepository();
      registerFallbackValue(Uint8List(0));
    });

    test('translationQuestionProvider calls repository.getQuestion', () async {
      final container = ProviderContainer(
        overrides: [
          translationRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final question = TranslationQuestion(
        id: 'q1',
        topic: 'daily',
        difficulty: 'beginner',
        sourceText: 'Hello',
        sourceLanguage: 'en',
        targetLanguage: 'ja',
        grammarPoints: [],
      );

      when(() => mockRepository.getQuestion('daily'))
          .thenAnswer((_) async => Right(question));

      final result = await container.read(translationQuestionProvider('daily').future);

      expect(result.id, 'q1');
      verify(() => mockRepository.getQuestion('daily')).called(1);
    });

    test('submitAnswerProvider calls repository.submitAnswer', () async {
      final container = ProviderContainer(
        overrides: [
          translationRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = TranslationResult(
        id: 'r1',
        questionId: 'q1',
        userAnswer: 'Hello',
        totalScore: 90,
        breakdown: const ScoreBreakdown(grammarScore: 90, vocabularyScore: 90, speedScore: 90),
        modelAnswer: 'Hello',
        feedback: ['Good'],
        xpEarned: 10,
      );

      final params = AnswerParams(
        questionId: 'q1',
        audioData: Uint8List(0),
        responseTimeSec: 1.5,
      );

      when(() => mockRepository.submitAnswer(
            questionId: 'q1',
            audioData: any(named: 'audioData'),
            responseTimeSec: 1.5,
          )).thenAnswer((_) async => Right(result));

      final response = await container.read(submitAnswerProvider(params).future);

      expect(response.totalScore, 90);
      verify(() => mockRepository.submitAnswer(
            questionId: 'q1',
            audioData: any(named: 'audioData'),
            responseTimeSec: 1.5,
          )).called(1);
    });
  });
}
