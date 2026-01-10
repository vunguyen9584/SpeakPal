import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation_question.freezed.dart';
part 'translation_question.g.dart';

@freezed
abstract class TranslationQuestion with _$TranslationQuestion {
  const factory TranslationQuestion({
    required String id,
    required String sourceText,
    required String sourceLanguage,
    required String targetLanguage,
    required String topic,
    required String difficulty,
    required List<String> grammarPoints,
    String? modelAnswer,
    Map<String, dynamic>? metadata,
  }) = _TranslationQuestion;

  factory TranslationQuestion.fromJson(Map<String, dynamic> json) =>
      _$TranslationQuestionFromJson(json);
}
