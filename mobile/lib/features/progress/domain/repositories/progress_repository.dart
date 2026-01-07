import '../models/stats.dart';
import '../models/history_item.dart';
import '../../presentation/providers/progress_providers.dart';
import '../../presentation/screens/history_list_screen.dart';

abstract class ProgressRepository {
  Future<Stats> getStats(StatsPeriod period);
  Future<WeeklyReport> getWeeklyReport(int weekNumber);
  Future<MonthlyReport> getMonthlyReport(int monthNumber);
  Future<PaginatedHistory> getHistory(HistoryQuery query);
}
