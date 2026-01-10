import 'package:mobile/core/network/api_client.dart';
import '../../domain/models/dashboard_stats.dart';
import '../../domain/models/recent_conversation.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;

  HomeRepositoryImpl(this._apiClient);

  @override
  Future<DashboardStats> getDashboardStats() async {
    try {
      final response = await _apiClient.get('/users/me/dashboard');
      return DashboardStats.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load dashboard stats: $e');
    }
  }

  @override
  Future<List<RecentConversation>> getRecentConversations({int limit = 5}) async {
    try {
      final response = await _apiClient.get(
        '/conversations',
        queryParameters: {'limit': limit, 'sort': 'desc'},
      );
      final List<dynamic> data = response.data['conversations'];
      return data.map((json) => RecentConversation.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load recent conversations: $e');
    }
  }

  @override
  Future<void> refreshDashboard() async {
    // Refresh is handled by re-fetching data
    await Future.wait([
      getDashboardStats(),
      getRecentConversations(),
    ]);
  }
}
