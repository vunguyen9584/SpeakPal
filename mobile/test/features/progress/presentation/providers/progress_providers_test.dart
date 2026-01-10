import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/progress/presentation/providers/progress_providers.dart';
import 'package:mobile/features/progress/domain/models/stats.dart';
import 'package:mobile/features/progress/domain/models/history_item.dart';
import 'package:mobile/features/progress/domain/models/history_query.dart';
import 'package:mobile/features/progress/domain/models/report.dart';
import 'package:mobile/features/progress/data/repositories/progress_repository_impl.dart';

class MockProgressRepository extends Mock implements ProgressRepositoryImpl {}

void main() {
  group('ProgressProviders Tests', () {
    late MockProgressRepository mockRepository;

    setUp(() {
      mockRepository = MockProgressRepository();
    });

    test('statsProvider calls repository.getStats', () async {
      final container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      when(() => mockRepository.getStats(StatsPeriod.thisWeek))
          .thenAnswer((_) async => Right(Stats.fromJson({})));

      await container.read(statsProvider(StatsPeriod.thisWeek).future);

      verify(() => mockRepository.getStats(StatsPeriod.thisWeek)).called(1);
    });

    test('historyProvider calls repository.getHistory', () async {
       final container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final query = HistoryQuery(page: 1);
      final emptyHistory = PaginatedHistory(items: [], total: 0, page: 1, limit: 10);

      when(() => mockRepository.getHistory(query))
          .thenAnswer((_) async => Right(emptyHistory));

      await container.read(historyProvider(query).future);

      verify(() => mockRepository.getHistory(query)).called(1);
    });

    test('weeklyReportProvider calls repository.getWeeklyReport', () async {
      final container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final now = DateTime.now().toIso8601String();
      when(() => mockRepository.getWeeklyReport(any()))
          .thenAnswer((_) async => Right(WeeklyReport.fromJson({
                'startDate': now,
                'endDate': now,
              })));

      await container.read(weeklyReportProvider(1).future);

      verify(() => mockRepository.getWeeklyReport(1)).called(1);
    });

    test('monthlyReportProvider calls repository.getMonthlyReport', () async {
      final container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final now = DateTime.now().toIso8601String();
      when(() => mockRepository.getMonthlyReport(any()))
          .thenAnswer((_) async => Right(MonthlyReport.fromJson({
                'startDate': now,
                'endDate': now,
              })));

      await container.read(monthlyReportProvider(1).future);

      verify(() => mockRepository.getMonthlyReport(1)).called(1);
    });
  });
}
