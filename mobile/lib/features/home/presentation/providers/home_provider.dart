import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/providers/providers.dart';
import '../../domain/models/dashboard_stats.dart';
import '../../domain/models/recent_conversation.dart';
import '../../domain/repositories/home_repository.dart';
import 'package:mobile/core/network/api_client.dart';
import '../../data/repositories/home_repository_impl.dart';

// Repository provider
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HomeRepositoryImpl(apiClient);
});

// Dashboard stats provider
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getDashboardStats();
});

// Recent conversations provider
final recentConversationsProvider = FutureProvider<List<RecentConversation>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getRecentConversations();
});

// Refresh provider
final refreshHomeProvider = FutureProvider.family<void, bool>((ref, force) async {
  if (force) {
    ref.invalidate(dashboardStatsProvider);
    ref.invalidate(recentConversationsProvider);
  }
});
