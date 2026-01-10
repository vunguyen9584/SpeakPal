import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/error/app_error.dart';
import 'package:mobile/core/error/error_handler.dart';
import 'package:mobile/core/providers/providers.dart';

// Models
class Group {
  final String id;
  final String name;
  final String? description;
  final String inviteCode;
  final int memberCount;
  final int maxMembers;
  final bool isOwner;
  final String ownerName;
  final DateTime createdAt;

  Group({
    required this.id,
    required this.name,
    this.description,
    required this.inviteCode,
    required this.memberCount,
    required this.maxMembers,
    required this.isOwner,
    required this.ownerName,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      inviteCode: json['inviteCode'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      maxMembers: json['maxMembers'] ?? 10,
      isOwner: json['isOwner'] ?? false,
      ownerName: json['ownerName'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class GroupMember {
  final String id;
  final String userId;
  final String username;
  final String role;
  final DateTime joinedAt;

  GroupMember({
    required this.id,
    required this.userId,
    required this.username,
    required this.role,
    required this.joinedAt,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['user']?['username'] ?? 'Unknown',
      role: json['role'] ?? 'MEMBER',
      joinedAt: DateTime.parse(json['joinedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class GroupRanking {
  final String userId;
  final String username;
  final int weeklyXp;
  final int rank;

  GroupRanking({
    required this.userId,
    required this.username,
    required this.weeklyXp,
    required this.rank,
  });

  factory GroupRanking.fromJson(Map<String, dynamic> json) {
    return GroupRanking(
      userId: json['userId'] ?? '',
      username: json['username'] ?? 'Unknown',
      weeklyXp: json['weeklyXp'] ?? 0,
      rank: json['rank'] ?? 0,
    );
  }
}

// Repository
class GroupRepository {
  final ApiClient _apiClient;

  GroupRepository(this._apiClient);

  Future<Either<AppError, Group>> createGroup({
    required String name,
    String? description,
    bool isPublic = true,
  }) async {
    try {
      final response = await _apiClient.post('/groups', data: {
        'name': name,
        'description': description,
        'isPublic': isPublic,
      });
      return Right(Group.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  Future<Either<AppError, List<Group>>> getMyGroups() async {
    try {
      final response = await _apiClient.get('/groups');
      final data = (response.data as List).map((json) => Group.fromJson(json)).toList();
      return Right(data);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  Future<Either<AppError, Group>> getGroupDetails(String groupId) async {
    try {
      final response = await _apiClient.get('/groups/$groupId');
      return Right(Group.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  Future<Either<AppError, void>> joinGroup(String inviteCode) async {
    try {
      await _apiClient.post('/groups/join', data: {'code': inviteCode});
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  Future<Either<AppError, void>> leaveGroup(String groupId) async {
    try {
      await _apiClient.delete('/groups/$groupId/leave');
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  Future<Either<AppError, List<GroupMember>>> getGroupMembers(String groupId) async {
    try {
      final response = await _apiClient.get('/groups/$groupId/members');
      final data = (response.data as List)
          .map((json) => GroupMember.fromJson(json))
          .toList();
      return Right(data);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  Future<Either<AppError, List<GroupRanking>>> getGroupRanking(String groupId) async {
    try {
      final response = await _apiClient.get('/groups/$groupId/ranking');
      final data = (response.data as List)
          .map((json) => GroupRanking.fromJson(json))
          .toList();
      return Right(data);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  Future<Either<AppError, void>> updateGroup(String groupId, {String? name, String? description}) async {
    try {
      await _apiClient.patch('/groups/$groupId', data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
      });
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  Future<Either<AppError, void>> deleteGroup(String groupId) async {
    try {
      await _apiClient.delete('/groups/$groupId');
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }
}

// Providers
final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GroupRepository(apiClient);
});

final myGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final repository = ref.watch(groupRepositoryProvider);
  final result = await repository.getMyGroups();
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

final groupDetailsProvider = FutureProvider.family<Group, String>((ref, groupId) async {
  final repository = ref.watch(groupRepositoryProvider);
  final result = await repository.getGroupDetails(groupId);
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

final groupMembersProvider = FutureProvider.family<List<GroupMember>, String>((ref, groupId) async {
  final repository = ref.watch(groupRepositoryProvider);
  final result = await repository.getGroupMembers(groupId);
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

final groupRankingProvider = FutureProvider.family<List<GroupRanking>, String>((ref, groupId) async {
  final repository = ref.watch(groupRepositoryProvider);
  final result = await repository.getGroupRanking(groupId);
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

