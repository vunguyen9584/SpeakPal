// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStats _$UserStatsFromJson(Map<String, dynamic> json) => _UserStats(
  totalConversations: (json['totalConversations'] as num).toInt(),
  totalVocabulary: (json['totalVocabulary'] as num).toInt(),
  currentStreak: (json['currentStreak'] as num).toInt(),
  longestStreak: (json['longestStreak'] as num).toInt(),
  totalBadges: (json['totalBadges'] as num).toInt(),
  totalXp: (json['totalXp'] as num).toInt(),
  averageAccuracy: (json['averageAccuracy'] as num).toDouble(),
  totalMinutes: (json['totalMinutes'] as num).toInt(),
);

Map<String, dynamic> _$UserStatsToJson(_UserStats instance) =>
    <String, dynamic>{
      'totalConversations': instance.totalConversations,
      'totalVocabulary': instance.totalVocabulary,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'totalBadges': instance.totalBadges,
      'totalXp': instance.totalXp,
      'averageAccuracy': instance.averageAccuracy,
      'totalMinutes': instance.totalMinutes,
    };

