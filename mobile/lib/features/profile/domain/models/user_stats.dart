import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    required int totalConversations,
    required int totalVocabulary,
    required int currentStreak,
    required int longestStreak,
    required int totalBadges,
    required int totalXp,
    required double averageAccuracy,
    required int totalMinutes,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}
