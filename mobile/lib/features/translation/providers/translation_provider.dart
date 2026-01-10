import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../data/translation_repository.dart';
import '../models/models.dart';

final translationQuestionProvider = FutureProvider.autoDispose
    .family<TranslationQuestion, String>((ref, topic) async {
  final repository = ref.read(translationRepositoryProvider);
  final result = await repository.getQuestion(topic);
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

class AnswerParams {
  final String questionId;
  final Uint8List audioData;
  final double responseTimeSec;

  AnswerParams({
    required this.questionId,
    required this.audioData,
    required this.responseTimeSec,
  });
}

final submitAnswerProvider = FutureProvider.autoDispose
    .family<TranslationResult, AnswerParams>((ref, params) async {
  final repository = ref.read(translationRepositoryProvider);
  final result = await repository.submitAnswer(
    questionId: params.questionId,
    audioData: params.audioData,
    responseTimeSec: params.responseTimeSec,
  );
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

