import 'package:freezed_annotation/freezed_annotation.dart';

part 'quick_response_models.freezed.dart';
part 'quick_response_models.g.dart';

@freezed
abstract class WordAssociationSession with _$WordAssociationSession {
  const factory WordAssociationSession({
    required String id,
    required String currentKeyword,
    required int score,
    required int chain,
    required int timeRemaining,
    String? previousKeyword,
  }) = _WordAssociationSession;

  factory WordAssociationSession.fromJson(Map<String, dynamic> json) =>
      _$WordAssociationSessionFromJson(json);
}

@freezed
abstract class InstantDrillSession with _$InstantDrillSession {
  const factory InstantDrillSession({
    required String id,
    required List<DrillQuestion> questions,
    required int currentQuestionIndex,
    required int totalScore,
  }) = _InstantDrillSession;

  factory InstantDrillSession.fromJson(Map<String, dynamic> json) =>
      _$InstantDrillSessionFromJson(json);
}

@freezed
abstract class DrillQuestion with _$DrillQuestion {
  const factory DrillQuestion({
    required String id,
    required String questionText,
    required String audioUrl,
  }) = _DrillQuestion;

  factory DrillQuestion.fromJson(Map<String, dynamic> json) =>
      _$DrillQuestionFromJson(json);
}

@freezed
abstract class QuickResponseResult with _$QuickResponseResult {
  const factory QuickResponseResult({
    required int finalScore,
    required int correctCount,
    required int maxChain,
    required int xpEarned,
    bool? isNewRecord,
  }) = _QuickResponseResult;

  factory QuickResponseResult.fromJson(Map<String, dynamic> json) =>
      _$QuickResponseResultFromJson(json);
}

