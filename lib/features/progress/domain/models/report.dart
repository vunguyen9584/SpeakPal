import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

/// Weekly report model
@freezed
class WeeklyReport with _$WeeklyReport {
  const factory WeeklyReport({
    required int weekNumber,
    required DateTime weekStart,
    required DateTime weekEnd,
    required WeeklyReportSummary summary,
    required List<WeeklyAchievement> achievements,
    required PronunciationComparison pronunciationComparison,
    required List<TopCorrection> topCorrections,
    required VocabularyHighlights vocabularyHighlights,
  }) = _WeeklyReport;

  factory WeeklyReport.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReportFromJson(json);
}

/// Weekly report summary statistics
@freezed
class WeeklyReportSummary with _$WeeklyReportSummary {
  const factory WeeklyReportSummary({
    required int conversations,
    required int minutes,
    required int xpEarned,
    required int vocabularyLearned,
  }) = _WeeklyReportSummary;

  factory WeeklyReportSummary.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReportSummaryFromJson(json);
}

/// Achievement earned during the week
@freezed
class WeeklyAchievement with _$WeeklyAchievement {
  const factory WeeklyAchievement({
    required String type,
    required String title,
    required String description,
    required DateTime achievedAt,
  }) = _WeeklyAchievement;

  factory WeeklyAchievement.fromJson(Map<String, dynamic> json) =>
      _$WeeklyAchievementFromJson(json);
}

/// Pronunciation comparison between weeks
@freezed
class PronunciationComparison with _$PronunciationComparison {
  const factory PronunciationComparison({
    required double thisWeek,
    required double lastWeek,
    required double improvement,
  }) = _PronunciationComparison;

  factory PronunciationComparison.fromJson(Map<String, dynamic> json) =>
      _$PronunciationComparisonFromJson(json);
}

/// Top pronunciation corrections
@freezed
class TopCorrection with _$TopCorrection {
  const factory TopCorrection({
    required String errorType,
    required int count,
    required List<String> examples,
  }) = _TopCorrection;

  factory TopCorrection.fromJson(Map<String, dynamic> json) =>
      _$TopCorrectionFromJson(json);
}

/// Vocabulary highlights for the week
@freezed
class VocabularyHighlights with _$VocabularyHighlights {
  const factory VocabularyHighlights({
    required int newWords,
    required int masteredWords,
    required List<String> topWords,
  }) = _VocabularyHighlights;

  factory VocabularyHighlights.fromJson(Map<String, dynamic> json) =>
      _$VocabularyHighlightsFromJson(json);
}

/// Monthly report model
@freezed
class MonthlyReport with _$MonthlyReport {
  const factory MonthlyReport({
    required int month,
    required int year,
    required DateTime monthStart,
    required DateTime monthEnd,
    required MonthlyReportSummary summary,
    required List<DailyStats> dailyStats,
    required List<WeeklyAchievement> achievements,
  }) = _MonthlyReport;

  factory MonthlyReport.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportFromJson(json);
}

/// Monthly report summary
@freezed
class MonthlyReportSummary with _$MonthlyReportSummary {
  const factory MonthlyReportSummary({
    required int conversations,
    required int minutes,
    required int xpEarned,
    required int vocabularyLearned,
    required int daysActive,
  }) = _MonthlyReportSummary;

  factory MonthlyReportSummary.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportSummaryFromJson(json);
}

/// Daily statistics for monthly view
@freezed
class DailyStats with _$DailyStats {
  const factory DailyStats({
    required DateTime date,
    required int conversations,
    required int minutes,
    required int xpEarned,
  }) = _DailyStats;

  factory DailyStats.fromJson(Map<String, dynamic> json) =>
      _$DailyStatsFromJson(json);
}
