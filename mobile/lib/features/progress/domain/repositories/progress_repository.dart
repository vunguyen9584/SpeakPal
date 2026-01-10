import '../models/stats.dart';
import '../models/history_item.dart';
import '../models/report.dart';
import '../models/history_query.dart';

abstract class ProgressRepository {
  Future<Stats> getStats(StatsPeriod period);
  Future<WeeklyReport> getWeeklyReport(int weekNumber);
  Future<MonthlyReport> getMonthlyReport(int monthNumber);
  Future<PaginatedHistory> getHistory(HistoryQuery query);
}
