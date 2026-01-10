import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/models/badge.dart';
import '../../domain/models/streak.dart';
import '../../domain/models/ranking.dart';
import '../../domain/repositories/gamification_repository.dart';
import '../../../../core/network/api_client.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  final ApiClient _apiClient;

  GamificationRepositoryImpl(this._apiClient);

  @override
  Future<Either<AppError, List<Badge>>> getAllBadges() async {
    try {
      final response = await _apiClient.get('/badges');
      final data = (response.data as List)
          .map((json) => Badge.fromJson(json))
          .toList();
      return Right(data);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, List<UserBadge>>> getUserBadges() async {
    try {
      final response = await _apiClient.get('/badges/mine');
      final data = (response.data as List)
          .map((json) => UserBadge.fromJson(json))
          .toList();
      return Right(data);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, Streak>> getStreak() async {
    try {
      final response = await _apiClient.get('/streaks');
      return Right(Streak.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, void>> useStreakFreeze() async {
    try {
      await _apiClient.post('/streaks/freeze');
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, Leaderboard>> getWeeklyRanking({String? league}) async {
    try {
      final queryParams = league != null ? {'league': league} : null;
      final response = await _apiClient.get(
        '/rankings/weekly',
        queryParameters: queryParams,
      );
      return Right(Leaderboard.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }
}

