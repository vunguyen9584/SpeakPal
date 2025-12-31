import '../models/stats.dart';
import '../models/report.dart';
import '../models/history_item.dart';

/// Repository interface for progress and statistics features
abstract class ProgressRepository {
  // Statistics methods
  /// Get statistics for a specific time period
  Future<Stats> getStats(StatsPeriod period);

  // Report methods
  /// Get weekly report for a specific week number
  Future<WeeklyReport> getWeeklyReport(int weekNumber);

  /// Get monthly report for a specific month and year
  Future<MonthlyReport> getMonthlyReport(int month, int year);

  // History methods
  /// Get paginated activity history
  Future<PaginatedHistory> getHistory(HistoryQuery query);

  /// Get activity history for a date range
  Future<List<HistoryItem>> getHistoryByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}
