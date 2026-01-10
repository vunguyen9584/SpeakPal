// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TranslationResult _$TranslationResultFromJson(Map<String, dynamic> json) =>
    _TranslationResult(
      id: json['id'] as String,
      questionId: json['questionId'] as String,
      userAnswer: json['userAnswer'] as String,
      totalScore: (json['totalScore'] as num).toInt(),
      breakdown: ScoreBreakdown.fromJson(
        json['breakdown'] as Map<String, dynamic>,
      ),
      modelAnswer: json['modelAnswer'] as String,
      feedback: (json['feedback'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      xpEarned: (json['xpEarned'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TranslationResultToJson(_TranslationResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'userAnswer': instance.userAnswer,
      'totalScore': instance.totalScore,
      'breakdown': instance.breakdown,
      'modelAnswer': instance.modelAnswer,
      'feedback': instance.feedback,
      'xpEarned': instance.xpEarned,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_ScoreBreakdown _$ScoreBreakdownFromJson(Map<String, dynamic> json) =>
    _ScoreBreakdown(
      grammarScore: (json['grammarScore'] as num).toInt(),
      vocabularyScore: (json['vocabularyScore'] as num).toInt(),
      speedScore: (json['speedScore'] as num).toInt(),
    );

Map<String, dynamic> _$ScoreBreakdownToJson(_ScoreBreakdown instance) =>
    <String, dynamic>{
      'grammarScore': instance.grammarScore,
      'vocabularyScore': instance.vocabularyScore,
      'speedScore': instance.speedScore,
    };

