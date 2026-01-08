// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shadowing_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShadowingContent _$ShadowingContentFromJson(Map<String, dynamic> json) =>
    _ShadowingContent(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      level: json['level'] as String,
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      audioUrl: json['audioUrl'] as String,
      transcript: json['transcript'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isPremium: json['isPremium'] as bool,
    );

Map<String, dynamic> _$ShadowingContentToJson(_ShadowingContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'level': instance.level,
      'durationSeconds': instance.durationSeconds,
      'audioUrl': instance.audioUrl,
      'transcript': instance.transcript,
      'thumbnailUrl': instance.thumbnailUrl,
      'isPremium': instance.isPremium,
    };

_ShadowingResult _$ShadowingResultFromJson(Map<String, dynamic> json) =>
    _ShadowingResult(
      id: json['id'] as String,
      overallScore: (json['overallScore'] as num).toInt(),
      breakdown: ShadowingScoreBreakdown.fromJson(
        json['breakdown'] as Map<String, dynamic>,
      ),
      weakSegments: (json['weakSegments'] as List<dynamic>)
          .map((e) => WeakSegment.fromJson(e as Map<String, dynamic>))
          .toList(),
      feedback: (json['feedback'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      xpEarned: (json['xpEarned'] as num).toInt(),
    );

Map<String, dynamic> _$ShadowingResultToJson(_ShadowingResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'overallScore': instance.overallScore,
      'breakdown': instance.breakdown,
      'weakSegments': instance.weakSegments,
      'feedback': instance.feedback,
      'xpEarned': instance.xpEarned,
    };

_ShadowingScoreBreakdown _$ShadowingScoreBreakdownFromJson(
  Map<String, dynamic> json,
) => _ShadowingScoreBreakdown(
  followingScore: (json['followingScore'] as num).toInt(),
  pronunciationScore: (json['pronunciationScore'] as num).toInt(),
  rhythmScore: (json['rhythmScore'] as num).toInt(),
  completenessScore: (json['completenessScore'] as num).toInt(),
);

Map<String, dynamic> _$ShadowingScoreBreakdownToJson(
  _ShadowingScoreBreakdown instance,
) => <String, dynamic>{
  'followingScore': instance.followingScore,
  'pronunciationScore': instance.pronunciationScore,
  'rhythmScore': instance.rhythmScore,
  'completenessScore': instance.completenessScore,
};

_WeakSegment _$WeakSegmentFromJson(Map<String, dynamic> json) => _WeakSegment(
  startTime: (json['startTime'] as num).toDouble(),
  endTime: (json['endTime'] as num).toDouble(),
  text: json['text'] as String,
  issueType: json['issueType'] as String,
);

Map<String, dynamic> _$WeakSegmentToJson(_WeakSegment instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'text': instance.text,
      'issueType': instance.issueType,
    };
