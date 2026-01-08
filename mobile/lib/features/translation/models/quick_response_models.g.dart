// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_response_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WordAssociationSession _$WordAssociationSessionFromJson(
  Map<String, dynamic> json,
) => _WordAssociationSession(
  id: json['id'] as String,
  currentKeyword: json['currentKeyword'] as String,
  score: (json['score'] as num).toInt(),
  chain: (json['chain'] as num).toInt(),
  timeRemaining: (json['timeRemaining'] as num).toInt(),
  previousKeyword: json['previousKeyword'] as String?,
);

Map<String, dynamic> _$WordAssociationSessionToJson(
  _WordAssociationSession instance,
) => <String, dynamic>{
  'id': instance.id,
  'currentKeyword': instance.currentKeyword,
  'score': instance.score,
  'chain': instance.chain,
  'timeRemaining': instance.timeRemaining,
  'previousKeyword': instance.previousKeyword,
};

_InstantDrillSession _$InstantDrillSessionFromJson(Map<String, dynamic> json) =>
    _InstantDrillSession(
      id: json['id'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => DrillQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentQuestionIndex: (json['currentQuestionIndex'] as num).toInt(),
      totalScore: (json['totalScore'] as num).toInt(),
    );

Map<String, dynamic> _$InstantDrillSessionToJson(
  _InstantDrillSession instance,
) => <String, dynamic>{
  'id': instance.id,
  'questions': instance.questions,
  'currentQuestionIndex': instance.currentQuestionIndex,
  'totalScore': instance.totalScore,
};

_DrillQuestion _$DrillQuestionFromJson(Map<String, dynamic> json) =>
    _DrillQuestion(
      id: json['id'] as String,
      questionText: json['questionText'] as String,
      audioUrl: json['audioUrl'] as String,
    );

Map<String, dynamic> _$DrillQuestionToJson(_DrillQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionText': instance.questionText,
      'audioUrl': instance.audioUrl,
    };

_QuickResponseResult _$QuickResponseResultFromJson(Map<String, dynamic> json) =>
    _QuickResponseResult(
      finalScore: (json['finalScore'] as num).toInt(),
      correctCount: (json['correctCount'] as num).toInt(),
      maxChain: (json['maxChain'] as num).toInt(),
      xpEarned: (json['xpEarned'] as num).toInt(),
      isNewRecord: json['isNewRecord'] as bool?,
    );

Map<String, dynamic> _$QuickResponseResultToJson(
  _QuickResponseResult instance,
) => <String, dynamic>{
  'finalScore': instance.finalScore,
  'correctCount': instance.correctCount,
  'maxChain': instance.maxChain,
  'xpEarned': instance.xpEarned,
  'isNewRecord': instance.isNewRecord,
};
