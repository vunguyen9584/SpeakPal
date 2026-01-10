import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_error.dart';

import '../../domain/models/stats.dart';
import '../../domain/models/history_item.dart';
import '../../domain/models/report.dart';
import '../../domain/models/history_query.dart';
import '../../domain/repositories/progress_repository.dart';
import 'package:mobile/core/network/api_client.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<Either<AppError, Stats>> getStats(StatsPeriod period) async {
    try {
      final response = await _apiClient.get('/progress/stats', queryParameters: {
        'period': period.name,
      });
      return Right(Stats.fromJson(response.data));
    } catch (e) {
      // In development return mock data on error
      // TODO: Remove this mock when API is ready
      return Right(_getMockStats(period));
    }
  }

  @override
  Future<Either<AppError, WeeklyReport>> getWeeklyReport(int weekNumber) async {
    try {
      final response = await _apiClient.get('/progress/reports/weekly', queryParameters: {
        'week': weekNumber,
      });
      return Right(WeeklyReport.fromJson(response.data));
    } catch (e) {
       // TODO: Remove this mock when API is ready
      return Right(_getMockWeeklyReport(weekNumber));
    }
  }

  @override
  Future<Either<AppError, MonthlyReport>> getMonthlyReport(int monthNumber) async {
    try {
      final response = await _apiClient.get('/progress/reports/monthly', queryParameters: {
        'month': monthNumber,
      });
      return Right(MonthlyReport.fromJson(response.data));
    } catch (e) {
       // TODO: Remove this mock when API is ready
      return Right(_getMockMonthlyReport(monthNumber));
    }
  }

  @override
  Future<Either<AppError, PaginatedHistory>> getHistory(HistoryQuery query) async {
    try {
      final response = await _apiClient.get('/progress/history', queryParameters: {
        'page': query.page,
        'limit': 20,
        if (query.startDate != null) 'startDate': query.startDate!.toIso8601String(),
        if (query.endDate != null) 'endDate': query.endDate!.toIso8601String(),
        if (query.type != null) 'type': query.type!.name,
      });
      return Right(PaginatedHistory.fromJson(response.data));
    } catch (e) {
       // TODO: Remove this mock when API is ready
      return Right(_getMockHistory(query));
    }
  }

  // Mock data methods for development
  Stats _getMockStats(StatsPeriod period) {
    return Stats(
      daily: DailyStats(conversations: 3, minutes: 45, xp: 150, vocabulary: 12),
      weekly: WeeklyStats(conversations: 15, minutes: 240, xp: 850, vocabulary: 45),
      monthly: MonthlyStats(conversations: 60, minutes: 980, xp: 3200, vocabulary: 180),
      allTime: AllTimeStats(totalConversations: 250, totalMinutes: 4500, totalXp: 15000),
      averagePronunciation: 82.5,
      currentStreak: 7,
    );
  }

  WeeklyReport _getMockWeeklyReport(int weekNumber) {
    return WeeklyReport(
      weekNumber: weekNumber,
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now(),
      summary: ReportSummary(totalConversations: 15, totalMinutes: 240, totalXp: 850),
      pronunciationTrend: [75.0, 78.0, 80.0, 82.0, 85.0, 83.0, 87.0],
      topCorrections: [
        TopCorrection(type: 'Grammar', count: 12, example: 'I goes 竊・I go'),
        TopCorrection(type: 'Pronunciation', count: 8, example: 'th sound'),
        TopCorrection(type: 'Vocabulary', count: 5, example: 'Word choice'),
      ],
      vocabularyProgress: VocabularyProgress(newWords: 45, masteredWords: 12),
      achievements: [
        Achievement(
          type: 'streak',
          name: '7-Day Streak',
          description: 'Practiced for 7 days in a row',
          earnedAt: DateTime.now(),
        ),
      ],
    );
  }

  MonthlyReport _getMockMonthlyReport(int monthNumber) {
    return MonthlyReport(
      monthNumber: monthNumber,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now(),
      summary: ReportSummary(totalConversations: 60, totalMinutes: 980, totalXp: 3200),
      pronunciationTrend: List.generate(30, (i) => 70.0 + (i * 0.5)),
      topCorrections: [
        TopCorrection(type: 'Grammar', count: 45, example: 'Tense errors'),
        TopCorrection(type: 'Pronunciation', count: 32, example: 'th, r sounds'),
        TopCorrection(type: 'Vocabulary', count: 28, example: 'Word choice'),
      ],
      vocabularyProgress: VocabularyProgress(newWords: 180, masteredWords: 45),
      achievements: [
        Achievement(
          type: 'level',
          name: 'Level 5',
          description: 'Reached level 5',
          earnedAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ],
    );
  }

  PaginatedHistory _getMockHistory(HistoryQuery query) {
    final items = List.generate(20, (i) {
      return HistoryItem(
        id: 'hist_$i',
        type: HistoryItemType.values[i % 3],
        timestamp: DateTime.now().subtract(Duration(hours: i * 2)),
        duration: i % 2 == 0 ? 15 + (i * 2) : null,
        xpEarned: 50 + (i * 5),
        details: {},
      );
    });

    return PaginatedHistory(
      items: items,
      total: 100,
      page: query.page,
      limit: 20,
    );
  }
}

