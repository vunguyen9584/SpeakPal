import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'package:mobile/core/providers/providers.dart';

final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  // Use shared Dio instance from core providers (already configured with API config)
  final dio = ref.watch(dioProvider);
  return TranslationRepository(dio);
});

class TranslationRepository {
  final Dio _dio;

  TranslationRepository(this._dio);

  /// Get a translation question by topic
  Future<TranslationQuestion> getQuestion(
    String topic, {
    String? level,
  }) async {
    try {
      final response = await _dio.get(
        '/translation/questions',
        queryParameters: {
          'topic': topic,
          if (level != null) 'level': level,
        },
      );
      return TranslationQuestion.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Submit translation answer with audio
  Future<TranslationResult> submitAnswer({
    required String questionId,
    required Uint8List audioData,
    required double responseTimeSec,
  }) async {
    try {
      final formData = FormData.fromMap({
        'questionId': questionId,
        'responseTimeSec': responseTimeSec,
        'audio': MultipartFile.fromBytes(
          audioData,
          filename: 'answer.webm',
        ),
      });

      final response = await _dio.post(
        '/translation/answers',
        data: formData,
      );
      return TranslationResult.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get intent question by category
  Future<IntentQuestion> getIntentQuestion(
    String category, {
    String? level,
  }) async {
    try {
      final response = await _dio.get(
        '/translation/intent-questions',
        queryParameters: {
          'category': category,
          if (level != null) 'level': level,
        },
      );
      return IntentQuestion.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Submit intent answer
  Future<IntentResult> submitIntentAnswer({
    required String questionId,
    required Uint8List audioData,
    required double responseTimeSec,
  }) async {
    try {
      final formData = FormData.fromMap({
        'questionId': questionId,
        'responseTimeSec': responseTimeSec,
        'audio': MultipartFile.fromBytes(
          audioData,
          filename: 'intent_answer.webm',
        ),
      });

      final response = await _dio.post(
        '/translation/intent-answers',
        data: formData,
      );
      return IntentResult.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 403) {
        return Exception('Level restriction: Intermediate+ required');
      }
      return Exception(
        error.response?.data['message'] ?? 'Network error occurred',
      );
    }
    return Exception('Unexpected error: $error');
  }
}
