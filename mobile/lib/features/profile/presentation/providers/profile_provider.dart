import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/profile/data/profile_repository.dart';
import 'package:mobile/features/profile/domain/models/user_stats.dart';

/// Profile Repository Provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(apiClient: ApiClient());
});

/// User Stats Provider
final userStatsProvider = FutureProvider<UserStats>((ref) async {
  final repository = ref.read(profileRepositoryProvider);
  return await repository.getStats();
});

