import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak.freezed.dart';
part 'streak.g.dart';

/// Streak model tracking user's consecutive activity days
@freezed
class Streak with _$Streak {
  const factory Streak({
    required int currentStreak,
    required int longestStreak,
    required int freezeRemaining,
    required DateTime? lastActivityDate,
    required bool isActiveToday,
    required int daysToNextMilestone,
    required int nextMilestone,
    required List<StreakDay> recentDays,
  }) = _Streak;

  factory Streak.fromJson(Map<String, dynamic> json) => _$StreakFromJson(json);
}

/// Represents a single day in the streak calendar
@freezed
class StreakDay with _$StreakDay {
  const factory StreakDay({
    required DateTime date,
    required bool hasActivity,
    required bool wasFrozen,
  }) = _StreakDay;

  factory StreakDay.fromJson(Map<String, dynamic> json) =>
      _$StreakDayFromJson(json);
}

/// Response when using a streak freeze
@freezed
class StreakFreezeResponse with _$StreakFreezeResponse {
  const factory StreakFreezeResponse({
    required bool success,
    required int freezeRemaining,
    required String message,
  }) = _StreakFreezeResponse;

  factory StreakFreezeResponse.fromJson(Map<String, dynamic> json) =>
      _$StreakFreezeResponseFromJson(json);
}
