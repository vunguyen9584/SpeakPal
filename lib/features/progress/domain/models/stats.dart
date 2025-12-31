import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats.freezed.dart';
part 'stats.g.dart';

/// Statistics model for user progress tracking
@freezed
class Stats with _$Stats {
  const factory Stats({
    required int totalConversations,
    required int totalMinutes,
    required int totalXp,
    required int vocabularyCount,
    required double pronunciationAverage,
    required int currentStreak,
    required StatsPeriod period,
    required DateTime startDate,
    required DateTime endDate,
  }) = _Stats;

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);
}

/// Time period for statistics aggregation
enum StatsPeriod {
  @JsonValue('today')
  today,
  @JsonValue('week')
  week,
  @JsonValue('month')
  month,
  @JsonValue('all_time')
  allTime,
}

/// Extension for display names
extension StatsPeriodExtension on StatsPeriod {
  String get displayName {
    switch (this) {
      case StatsPeriod.today:
        return 'Today';
      case StatsPeriod.week:
        return 'This Week';
      case StatsPeriod.month:
        return 'This Month';
      case StatsPeriod.allTime:
        return 'All Time';
    }
  }
}
