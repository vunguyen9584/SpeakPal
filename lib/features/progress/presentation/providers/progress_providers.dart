import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_progress_repository.dart';
import '../../domain/models/history_item.dart';
import '../../domain/models/report.dart';
import '../../domain/models/stats.dart';
import '../../domain/repositories/progress_repository.dart';

/// Provider for the progress repository
/// Currently using mock implementation for testing
/// Will be replaced with real API implementation in WP-BE-015
final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return MockProgressRepository();
});

/// Provider for user statistics by period
/// Parameters: StatsPeriod (today, week, month, allTime)
final statsProvider = FutureProvider.family<Stats, StatsPeriod>(
  (ref, period) async {
    final repository = ref.watch(progressRepositoryProvider);
    return repository.getStats(period);
  },
);

/// Provider for weekly report
/// Parameters: int weekNumber (e.g., 52 for week 52 of the year)
final weeklyReportProvider = FutureProvider.family<WeeklyReport, int>(
  (ref, weekNumber) async {
    final repository = ref.watch(progressRepositoryProvider);
    return repository.getWeeklyReport(weekNumber);
  },
);

/// Provider for monthly report
/// Parameters: MonthYearParams containing month and year
final monthlyReportProvider = FutureProvider.family<MonthlyReport, MonthYearParams>(
  (ref, params) async {
    final repository = ref.watch(progressRepositoryProvider);
    return repository.getMonthlyReport(params.month, params.year);
  },
);

/// Provider for activity history with pagination and filtering
/// Parameters: HistoryQuery containing filters and pagination
final historyProvider = FutureProvider.family<PaginatedHistory, HistoryQuery>(
  (ref, query) async {
    final repository = ref.watch(progressRepositoryProvider);
    return repository.getHistory(query);
  },
);

/// Helper class for monthly report provider parameters
class MonthYearParams {
  final int month;
  final int year;

  const MonthYearParams({
    required this.month,
    required this.year,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonthYearParams &&
        other.month == month &&
        other.year == year;
  }

  @override
  int get hashCode => month.hashCode ^ year.hashCode;
}
