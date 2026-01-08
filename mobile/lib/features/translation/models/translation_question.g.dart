// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TranslationQuestion _$TranslationQuestionFromJson(Map<String, dynamic> json) =>
    _TranslationQuestion(
      id: json['id'] as String,
      sourceText: json['sourceText'] as String,
      sourceLanguage: json['sourceLanguage'] as String,
      targetLanguage: json['targetLanguage'] as String,
      topic: json['topic'] as String,
      difficulty: json['difficulty'] as String,
      grammarPoints: (json['grammarPoints'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      modelAnswer: json['modelAnswer'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TranslationQuestionToJson(
  _TranslationQuestion instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceText': instance.sourceText,
  'sourceLanguage': instance.sourceLanguage,
  'targetLanguage': instance.targetLanguage,
  'topic': instance.topic,
  'difficulty': instance.difficulty,
  'grammarPoints': instance.grammarPoints,
  'modelAnswer': instance.modelAnswer,
  'metadata': instance.metadata,
};
