import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/stats.dart';
import '../../domain/models/report.dart';
import '../../domain/models/history_item.dart';
import '../../domain/models/history_query.dart';
import '../../data/repositories/progress_repository_impl.dart';

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

