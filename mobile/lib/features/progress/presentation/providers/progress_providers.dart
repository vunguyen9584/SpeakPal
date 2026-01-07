import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/stats.dart';
import '../../domain/models/report.dart';
import '../../domain/models/history_item.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../screens/history_list_screen.dart';

// Repository Provider
final progressRepositoryProvider = Provider((ref) {
  return ProgressRepositoryImpl();
});

// Stats Provider
final statsProvider = FutureProvider.autoDispose.family<Stats, StatsPeriod>((ref, period) async {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.getStats(period);
});

// Weekly Report Provider
final weeklyReportProvider = FutureProvider.autoDispose.family<WeeklyReport, int>((ref, weekNumber) async {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.getWeeklyReport(weekNumber);
});

// Monthly Report Provider
final monthlyReportProvider = FutureProvider.autoDispose.family<MonthlyReport, int>((ref, monthNumber) async {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.getMonthlyReport(monthNumber);
});

// History Provider
final historyProvider = FutureProvider.autoDispose.family<PaginatedHistory, HistoryQuery>((ref, query) async {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.getHistory(query);
});

// Monthly Report Model (for completeness)
class MonthlyReport {
  final int monthNumber;
  final DateTime startDate;
  final DateTime endDate;
  final ReportSummary summary;
  final List<double> pronunciationTrend;
  final List<TopCorrection> topCorrections;
  final VocabularyProgress vocabularyProgress;
  final List<Achievement> achievements;

  MonthlyReport({
    required this.monthNumber,
    required this.startDate,
    required this.endDate,
    required this.summary,
    required this.pronunciationTrend,
    required this.topCorrections,
    required this.vocabularyProgress,
    required this.achievements,
  });

  factory MonthlyReport.fromJson(Map<String, dynamic> json) {
    return MonthlyReport(
      monthNumber: json['monthNumber'] ?? 0,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      summary: ReportSummary.fromJson(json['summary'] ?? {}),
      pronunciationTrend: (json['pronunciationTrend'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      topCorrections: (json['topCorrections'] as List?)
              ?.map((e) => TopCorrection.fromJson(e))
              .toList() ??
          [],
      vocabularyProgress:
          VocabularyProgress.fromJson(json['vocabularyProgress'] ?? {}),
      achievements: (json['achievements'] as List?)
              ?.map((e) => Achievement.fromJson(e))
              .toList() ??
          [],
    );
  }
}
