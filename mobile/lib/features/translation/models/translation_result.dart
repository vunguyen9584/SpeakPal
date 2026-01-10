import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation_result.freezed.dart';
part 'translation_result.g.dart';

@freezed
abstract class TranslationResult with _$TranslationResult {
  const factory TranslationResult({
    required String id,
    required String questionId,
    required String userAnswer,
    required int totalScore,
    required ScoreBreakdown breakdown,
    required String modelAnswer,
    required List<String> feedback,
    required int xpEarned,
    DateTime? createdAt,
  }) = _TranslationResult;

  factory TranslationResult.fromJson(Map<String, dynamic> json) =>
      _$TranslationResultFromJson(json);
}

@freezed
abstract class ScoreBreakdown with _$ScoreBreakdown {
  const factory ScoreBreakdown({
    required int grammarScore,
    required int vocabularyScore,
    required int speedScore,
  }) = _ScoreBreakdown;

  factory ScoreBreakdown.fromJson(Map<String, dynamic> json) =>
      _$ScoreBreakdownFromJson(json);
}

