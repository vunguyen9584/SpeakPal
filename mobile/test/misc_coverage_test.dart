import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/config/api_config.dart';
import 'package:mobile/features/translation/providers/translation_provider.dart';
import 'package:mobile/features/translation/data/translation_repository.dart';
import 'package:mobile/features/translation/models/models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'dart:typed_data';

class MockTranslationRepository extends Mock implements TranslationRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  group('ApiConfig Tests', () {
    test('apiBaseUrl and wsBaseUrl construction', () {
      const config = ApiConfig(baseUrl: 'https://api.example.com');
      expect(config.apiBaseUrl, 'https://api.example.com/api/v1');
      expect(config.wsBaseUrl, 'wss://api.example.com');
      expect(config.conversationWsUrl, 'wss://api.example.com/ws/conversation');
    });

    test('wsBaseUrl handles http and localhost', () {
      const config = ApiConfig(baseUrl: 'http://localhost:3000');
      expect(config.wsBaseUrl, 'ws://localhost:3000');
    });

    test('all endpoints are defined', () {
      const config = ApiConfig(baseUrl: 'http://test');
      expect(config.authEndpoint, isNotEmpty);
      expect(config.usersEndpoint, isNotEmpty);
      expect(config.conversationsEndpoint, isNotEmpty);
      expect(config.translationEndpoint, isNotEmpty);
      expect(config.learningEndpoint, isNotEmpty);
      expect(config.progressEndpoint, isNotEmpty);
      expect(config.socialEndpoint, isNotEmpty);
      expect(config.subscriptionEndpoint, isNotEmpty);
    });
  });

  group('IntentCategory Tests', () {
    test('displayName returns correct values', () {
      expect(IntentCategory.greeting.displayName, isA<String>());
      expect(IntentCategory.daily.displayName, isA<String>());
      expect(IntentCategory.business.displayName, isA<String>());
      expect(IntentCategory.emotion.displayName, isA<String>());
      expect(IntentCategory.request.displayName, isA<String>());
    });

    test('icon returns IconData', () {
      expect(IntentCategory.greeting.icon, isA<IconData>());
      expect(IntentCategory.daily.icon, isA<IconData>());
    });

    test('value returns string matching JsonValue', () {
      expect(IntentCategory.greeting.value, 'greeting');
      expect(IntentCategory.request.value, 'request');
    });
  });

  group('Translation Providers Tests', () {
    late MockTranslationRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockTranslationRepository();
      container = ProviderContainer(
        overrides: [
          translationRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });


    test('translationQuestionProvider calls repository', () async {
      final question = TranslationQuestion(
        id: 'q1',
        sourceText: 's',
        sourceLanguage: 'sl',
        targetLanguage: 'tl',
        topic: 't',
        difficulty: 'd',
        grammarPoints: [],
        modelAnswer: 'm',
      );
      when(() => mockRepo.getQuestion(any())).thenAnswer((_) async => Right(question));

      final result = await container.read(translationQuestionProvider('topic').future);
      expect(result, question);
      verify(() => mockRepo.getQuestion('topic')).called(1);
    });

    test('submitAnswerProvider calls repository', () async {
      final result = TranslationResult(
        id: 'r1',
        questionId: 'q1',
        userAnswer: 'u',
        totalScore: 80,
        breakdown: ScoreBreakdown(grammarScore: 80, vocabularyScore: 80, speedScore: 80),
        modelAnswer: 'm',
        feedback: [],
        xpEarned: 5,
      );
      final params = AnswerParams(
        questionId: 'q1',
        audioData: Uint8List(0),
        responseTimeSec: 10.0,
      );
      when(() => mockRepo.submitAnswer(
            questionId: any(named: 'questionId'),
            audioData: any(named: 'audioData'),
            responseTimeSec: any(named: 'responseTimeSec'),
          )).thenAnswer((_) async => Right(result));

      final submittedResult = await container.read(submitAnswerProvider(params).future);
      expect(submittedResult, result);
      verify(() => mockRepo.submitAnswer(
            questionId: 'q1',
            audioData: params.audioData,
            responseTimeSec: 10.0,
          )).called(1);
    });
  });
}
