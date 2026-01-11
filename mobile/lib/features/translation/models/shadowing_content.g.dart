// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shadowing_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShadowingContent _$ShadowingContentFromJson(Map<String, dynamic> json) =>
    _ShadowingContent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
      topic: $enumDecode(_$TranslationTopicEnumMap, json['topic']),
      text: json['text'] as String,
      audioUrl: json['audioUrl'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      isPremium: json['isPremium'] as bool,
      segments: (json['segments'] as List<dynamic>)
          .map((e) => TextSegment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShadowingContentToJson(_ShadowingContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
      'topic': _$TranslationTopicEnumMap[instance.topic]!,
      'text': instance.text,
      'audioUrl': instance.audioUrl,
      'duration': instance.duration.inMicroseconds,
      'isPremium': instance.isPremium,
      'segments': instance.segments,
    };

const _$DifficultyEnumMap = {
  Difficulty.beginner: 'beginner',
  Difficulty.intermediate: 'intermediate',
  Difficulty.advanced: 'advanced',
};

const _$TranslationTopicEnumMap = {
  TranslationTopic.daily: 'daily',
  TranslationTopic.business: 'business',
  TranslationTopic.travel: 'travel',
  TranslationTopic.news: 'news',
  TranslationTopic.entertainment: 'entertainment',
};

_TextSegment _$TextSegmentFromJson(Map<String, dynamic> json) => _TextSegment(
  id: json['id'] as String,
  text: json['text'] as String,
  startTime: Duration(microseconds: (json['startTime'] as num).toInt()),
  endTime: Duration(microseconds: (json['endTime'] as num).toInt()),
);

Map<String, dynamic> _$TextSegmentToJson(_TextSegment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'startTime': instance.startTime.inMicroseconds,
      'endTime': instance.endTime.inMicroseconds,
    };
