import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/error/app_error.dart';
import 'package:mobile/core/error/error_handler.dart';
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
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      inviteUrl: json['inviteUrl'] ?? '',
      maxUsage: json['maxUsage'] ?? 0,
      usageCount: json['usageCount'] ?? 0,
      expiresAt: DateTime.parse(json['expiresAt'] ?? DateTime.now().toIso8601String()),
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
      totalReferrals: json['totalReferrals'] ?? 0,
      referrals: (json['referrals'] as List?)
              ?.map((r) => ReferralInfo.fromJson(r))
              .toList() ??
          [],
      rewards: (json['rewards'] as List?)
              ?.map((r) => RewardInfo.fromJson(r))
              .toList() ??
          [],
    );
  }
}

class ReferralInfo {
  final String username;
  final DateTime joinedAt;

  ReferralInfo({required this.username, required this.joinedAt});

  factory ReferralInfo.fromJson(Map<String, dynamic> json) {
    return ReferralInfo(
      username: json['username'] ?? 'Unknown',
      joinedAt: DateTime.parse(json['joinedAt'] ?? DateTime.now().toIso8601String()),
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
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      claimed: json['claimed'] ?? false,
    );
  }
}

// Repository
class InvitationRepository {
  final ApiClient _apiClient;

  InvitationRepository(this._apiClient);

  Future<Either<AppError, InvitationResponse>> generateInvite({
    int maxUsage = 10,
    int expiryDays = 30,
  }) async {
    try {
      final response = await _apiClient.post('/invitations', data: {
        'maxUsage': maxUsage,
        'expiryDays': expiryDays,
      });
      return Right(InvitationResponse.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  Future<Either<AppError, List<InvitationResponse>>> getMyInvitations() async {
    try {
      final response = await _apiClient.get('/invitations/mine');
      final data = (response.data as List)
          .map((json) => InvitationResponse.fromJson(json))
          .toList();
      return Right(data);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  Future<Either<AppError, void>> acceptInvitation(String code) async {
    try {
      await _apiClient.post('/invitations/accept', data: {'code': code});
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  Future<Either<AppError, ReferralStats>> getReferralStats() async {
    try {
      final response = await _apiClient.get('/invitations/stats');
      return Right(ReferralStats.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }
}

// Providers
final invitationRepositoryProvider = Provider<InvitationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return InvitationRepository(apiClient);
});

final myInvitationsProvider = FutureProvider<List<InvitationResponse>>((ref) async {
  final repository = ref.watch(invitationRepositoryProvider);
  final result = await repository.getMyInvitations();
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

final referralStatsProvider = FutureProvider<ReferralStats>((ref) async {
  final repository = ref.watch(invitationRepositoryProvider);
  final result = await repository.getReferralStats();
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

