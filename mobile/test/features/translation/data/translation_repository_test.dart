import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/translation/data/translation_repository.dart';
// import 'package:mobile/features/translation/models/models.dart';
import 'dart:typed_data';

class MockDio extends Mock implements Dio {}

void main() {
  group('TranslationRepository Tests', () {
    late MockDio mockDio;
    late TranslationRepository repository;

    setUp(() {
      mockDio = MockDio();
      repository = TranslationRepository(mockDio);
      
      // Register fallback for FormData if needed, but we can just use any() for now
      registerFallbackValue(Options());
    });

    test('getQuestion returns TranslationQuestion on success', () async {
      final responseData = {
        'data': {
          'id': 'q1',
          'sourceText': 'Hello',
          'sourceLanguage': 'English',
          'targetLanguage': 'Japanese',
          'topic': 'greeting',
          'difficulty': 'beginner',
          'grammarPoints': ['greeting'],
          'modelAnswer': 'こんにちは',
        }
      };

      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await repository.getQuestion('greeting');

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.id, 'q1');
          expect(r.sourceText, 'Hello');
        },
      );
      
      verify(() => mockDio.get(
            '/translation/questions',
            queryParameters: {'topic': 'greeting'},
          )).called(1);
    });

    test('getQuestion with level calls correctly', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
            data: {'data': {'id': 'q1', 'sourceText': 'Hello', 'sourceLanguage': 'en', 'targetLanguage': 'ja', 'topic': 't', 'difficulty': 'd', 'grammarPoints': [], 'modelAnswer': ''}},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      await repository.getQuestion('greeting', level: 'intermediate');

      verify(() => mockDio.get(
            '/translation/questions',
            queryParameters: {'topic': 'greeting', 'level': 'intermediate'},
          )).called(1);
    });

    test('getQuestion returns Left on error', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: {'message': 'Error occurs'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      final result = await repository.getQuestion('greeting');
      expect(result.isLeft(), true);
    });

    test('getIntentQuestion returns IntentQuestion on success', () async {
      final responseData = {
        'data': {
          'id': 'iq1',
          'situation': 'You are lost in Tokyo',
          'intent': 'Ask for help',
          'category': 'travel',
          'difficulty': 'beginner',
          'hint': 'Use "help"',
        }
      };

      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await repository.getIntentQuestion('travel');

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.id, 'iq1');
          expect(r.intent, 'Ask for help');
        },
      );
    });

    test('getIntentQuestion with level calls correctly', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
            data: {'data': {'id': 'iq1', 'situation': 's', 'intent': 'i', 'category': 'c', 'difficulty': 'd', 'hint': 'h'}},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      await repository.getIntentQuestion('travel', level: 'advanced');

      verify(() => mockDio.get(
            '/translation/intent-questions',
            queryParameters: {'category': 'travel', 'level': 'advanced'},
          )).called(1);
    });

    test('submitAnswer returns TranslationResult on success', () async {
      final responseData = {
        'data': {
          'id': 'res1',
          'questionId': 'q1',
          'userAnswer': 'Test answer',
          'totalScore': 85,
          'breakdown': {
            'grammarScore': 90,
            'vocabularyScore': 80,
            'speedScore': 85,
          },
          'modelAnswer': 'Correct answer',
          'feedback': ['Good'],
          'xpEarned': 10,
        }
      };

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await repository.submitAnswer(
        questionId: 'q1',
        audioData: Uint8List(0),
        responseTimeSec: 5.0,
      );

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.totalScore, 85),
      );
      
      verify(() => mockDio.post('/translation/answers', data: any(named: 'data'))).called(1);
    });

    test('submitIntentAnswer returns IntentResult on success', () async {
      final responseData = {
        'data': {
          'id': 'ires1',
          'questionId': 'iq1',
          'userExpression': 'Can you help me?',
          'totalScore': 90,
          'breakdown': {
            'intentScore': 95,
            'naturalnessScore': 85,
            'vocabularyScore': 90,
          },
          'alternativeExpressions': ['Could you assist me?'],
          'feedback': ['Great'],
          'xpEarned': 15,
        }
      };

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await repository.submitIntentAnswer(
        questionId: 'iq1',
        audioData: Uint8List(0),
        responseTimeSec: 4.0,
      );

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.totalScore, 90);
          expect(r.userExpression, 'Can you help me?');
        },
      );
    });
  });
}

