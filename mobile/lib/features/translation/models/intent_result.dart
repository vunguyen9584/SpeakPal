import 'package:freezed_annotation/freezed_annotation.dart';

part 'intent_result.freezed.dart';
part 'intent_result.g.dart';

@freezed
abstract class IntentResult with _$IntentResult {
  const factory IntentResult({
    required String id,
    required String questionId,
    required String userExpression,
    required int totalScore,
    required IntentScoreBreakdown breakdown,
    required List<String> alternativeExpressions,
    required List<String> feedback,
    required int xpEarned,
  }) = _IntentResult;

  factory IntentResult.fromJson(Map<String, dynamic> json) =>
      _$IntentResultFromJson(json);
}

@freezed
abstract class IntentScoreBreakdown with _$IntentScoreBreakdown {
  const factory IntentScoreBreakdown({
    required int intentScore,
    required int naturalnessScore,
    required int vocabularyScore,
  }) = _IntentScoreBreakdown;

  factory IntentScoreBreakdown.fromJson(Map<String, dynamic> json) =>
      _$IntentScoreBreakdownFromJson(json);
}

