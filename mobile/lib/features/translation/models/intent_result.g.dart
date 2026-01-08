// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intent_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IntentResult _$IntentResultFromJson(Map<String, dynamic> json) =>
    _IntentResult(
      id: json['id'] as String,
      questionId: json['questionId'] as String,
      userExpression: json['userExpression'] as String,
      totalScore: (json['totalScore'] as num).toInt(),
      breakdown: IntentScoreBreakdown.fromJson(
        json['breakdown'] as Map<String, dynamic>,
      ),
      alternativeExpressions: (json['alternativeExpressions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      feedback: (json['feedback'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      xpEarned: (json['xpEarned'] as num).toInt(),
    );

Map<String, dynamic> _$IntentResultToJson(_IntentResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'userExpression': instance.userExpression,
      'totalScore': instance.totalScore,
      'breakdown': instance.breakdown,
      'alternativeExpressions': instance.alternativeExpressions,
      'feedback': instance.feedback,
      'xpEarned': instance.xpEarned,
    };

_IntentScoreBreakdown _$IntentScoreBreakdownFromJson(
  Map<String, dynamic> json,
) => _IntentScoreBreakdown(
  intentScore: (json['intentScore'] as num).toInt(),
  naturalnessScore: (json['naturalnessScore'] as num).toInt(),
  vocabularyScore: (json['vocabularyScore'] as num).toInt(),
);

Map<String, dynamic> _$IntentScoreBreakdownToJson(
  _IntentScoreBreakdown instance,
) => <String, dynamic>{
  'intentScore': instance.intentScore,
  'naturalnessScore': instance.naturalnessScore,
  'vocabularyScore': instance.vocabularyScore,
};
