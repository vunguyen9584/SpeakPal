import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/providers/providers.dart';

// Models
class InvitationResponse {
  final String id;
  final String code;
  final String inviteUrl;
  final int maxUsage;
  final int usageCount;
  final DateTime expiresAt;

  InvitationResponse({
    required this.id,
    required this.code,
    required this.inviteUrl,
    required this.maxUsage,
    required this.usageCount,
    required this.expiresAt,
  });

  factory InvitationResponse.fromJson(Map<String, dynamic> json) {
    return InvitationResponse(
      id: json['id'],
      code: json['code'],
      inviteUrl: json['inviteUrl'],
      maxUsage: json['maxUsage'],
      usageCount: json['usageCount'],
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}

class ReferralStats {
  final int totalReferrals;
  final List<ReferralInfo> referrals;
  final List<RewardInfo> rewards;

  ReferralStats({
    required this.totalReferrals,
    required this.referrals,
    required this.rewards,
  });

  factory ReferralStats.fromJson(Map<String, dynamic> json) {
    return ReferralStats(
      totalReferrals: json['totalReferrals'],
      referrals: (json['referrals'] as List)
          .map((r) => ReferralInfo.fromJson(r))
          .toList(),
      rewards: (json['rewards'] as List)
          .map((r) => RewardInfo.fromJson(r))
          .toList(),
    );
  }
}

class ReferralInfo {
  final String username;
  final DateTime joinedAt;

  ReferralInfo({required this.username, required this.joinedAt});

  factory ReferralInfo.fromJson(Map<String, dynamic> json) {
    return ReferralInfo(
      username: json['username'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }
}

class RewardInfo {
  final String type;
  final String description;
  final bool claimed;

  RewardInfo({
    required this.type,
    required this.description,
    required this.claimed,
  });

  factory RewardInfo.fromJson(Map<String, dynamic> json) {
    return RewardInfo(
      type: json['type'],
      description: json['description'],
      claimed: json['claimed'],
    );
  }
}

// Repository
class InvitationRepository {
  final ApiClient _apiClient;

  InvitationRepository(this._apiClient);

  Future<InvitationResponse> generateInvite({
    int maxUsage = 10,
    int expiryDays = 30,
  }) async {
    final response = await _apiClient.post('/invitations', data: {
      'maxUsage': maxUsage,
      'expiryDays': expiryDays,
    });
    return InvitationResponse.fromJson(response.data);
  }

  Future<List<InvitationResponse>> getMyInvitations() async {
    final response = await _apiClient.get('/invitations/mine');
    return (response.data as List)
        .map((json) => InvitationResponse.fromJson(json))
        .toList();
  }

  Future<void> acceptInvitation(String code) async {
    await _apiClient.post('/invitations/accept', data: {'code': code});
  }

  Future<ReferralStats> getReferralStats() async {
    final response = await _apiClient.get('/invitations/stats');
    return ReferralStats.fromJson(response.data);
  }
}

// Providers
final invitationRepositoryProvider = Provider<InvitationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return InvitationRepository(apiClient);
});

final myInvitationsProvider = FutureProvider<List<InvitationResponse>>((ref) {
  final repository = ref.watch(invitationRepositoryProvider);
  return repository.getMyInvitations();
});

final referralStatsProvider = FutureProvider<ReferralStats>((ref) {
  final repository = ref.watch(invitationRepositoryProvider);
  return repository.getReferralStats();
});

