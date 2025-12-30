import 'package:dio/dio.dart';
import '../../domain/models/badge.dart';
import '../../domain/models/streak.dart';
import '../../domain/models/ranking.dart';
import '../../domain/repositories/gamification_repository.dart';
import '../../../../core/network/api_client.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  final ApiClient _apiClient;

  GamificationRepositoryImpl(this._apiClient);

  @override
  Future<List<Badge>> getAllBadges() async {
    try {
      final response = await _apiClient.get('/badges');
      return (response.data as List)
          .map((json) => Badge.fromJson(json))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<UserBadge>> getUserBadges() async {
    try {
      final response = await _apiClient.get('/badges/mine');
      return (response.data as List)
          .map((json) => UserBadge.fromJson(json))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<Streak> getStreak() async {
    try {
      final response = await _apiClient.get('/streaks');
      return Streak.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> useStreakFreeze() async {
    try {
      await _apiClient.post('/streaks/freeze');
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<Leaderboard> getWeeklyRanking({String? league}) async {
    try {
      final queryParams = league != null ? {'league': league} : null;
      final response = await _apiClient.get(
        '/rankings/weekly',
        queryParameters: queryParams,
      );
      return Leaderboard.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}
