// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intent_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IntentQuestion _$IntentQuestionFromJson(Map<String, dynamic> json) =>
    _IntentQuestion(
      id: json['id'] as String,
      situation: json['situation'] as String,
      intent: json['intent'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      hint: json['hint'] as String?,
      expectedExpressions: (json['expectedExpressions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$IntentQuestionToJson(_IntentQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'situation': instance.situation,
      'intent': instance.intent,
      'category': instance.category,
      'difficulty': instance.difficulty,
      'hint': instance.hint,
      'expectedExpressions': instance.expectedExpressions,
    };
