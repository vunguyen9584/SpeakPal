import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_error.dart';
import '../models/stats.dart';
import '../models/history_item.dart';
import '../models/report.dart';
import '../models/history_query.dart';

abstract class ProgressRepository {
  Future<Either<AppError, Stats>> getStats(StatsPeriod period);
  Future<Either<AppError, WeeklyReport>> getWeeklyReport(int weekNumber);
  Future<Either<AppError, MonthlyReport>> getMonthlyReport(int monthNumber);
  Future<Either<AppError, PaginatedHistory>> getHistory(HistoryQuery query);
}

