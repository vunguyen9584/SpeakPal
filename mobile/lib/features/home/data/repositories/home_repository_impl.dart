import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/error/app_error.dart';
import 'package:mobile/core/error/error_handler.dart';
import 'package:mobile/core/network/api_client.dart';
import '../../domain/models/dashboard_stats.dart';
import '../../domain/models/recent_conversation.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;

  HomeRepositoryImpl(this._apiClient);

  @override
  Future<Either<AppError, DashboardStats>> getDashboardStats() async {
    try {
      final response = await _apiClient.get('/users/me/dashboard');
      return Right(DashboardStats.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, List<RecentConversation>>> getRecentConversations({int limit = 5}) async {
    try {
      final response = await _apiClient.get(
        '/conversations',
        queryParameters: {'limit': limit, 'sort': 'desc'},
      );
      final List<dynamic> data = response.data['conversations'];
      return Right(data.map((json) => RecentConversation.fromJson(json)).toList());
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, void>> refreshDashboard() async {
    try {
      final results = await Future.wait([
        getDashboardStats(),
        getRecentConversations(),
      ]);

      for (final result in results) {
        if (result.isLeft()) {
          return Left((result as Left<AppError, dynamic>).value);
        }
      }

      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }
}

