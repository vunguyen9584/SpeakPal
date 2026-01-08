import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/translation_repository.dart';
import '../models/models.dart';

final translationQuestionProvider = FutureProvider.autoDispose
    .family<TranslationQuestion, String>((ref, topic) async {
  final repository = ref.read(translationRepositoryProvider);
  return repository.getQuestion(topic);
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
  return repository.submitAnswer(
    questionId: params.questionId,
    audioData: params.audioData,
    responseTimeSec: params.responseTimeSec,
  );
});
