import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_client.dart';

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
      id: json['id'],
      name: json['name'],
      description: json['description'],
      inviteCode: json['inviteCode'],
      memberCount: json['memberCount'],
      maxMembers: json['maxMembers'],
      isOwner: json['isOwner'],
      ownerName: json['ownerName'],
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
      id: json['id'],
      userId: json['userId'],
      username: json['user']['username'],
      role: json['role'],
      joinedAt: DateTime.parse(json['joinedAt']),
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
      userId: json['userId'],
      username: json['username'],
      weeklyXp: json['weeklyXp'],
      rank: json['rank'],
    );
  }
}

// Repository
class GroupRepository {
  final ApiClient _apiClient;

  GroupRepository(this._apiClient);

  Future<Group> createGroup({
    required String name,
    String? description,
    bool isPublic = true,
  }) async {
    final response = await _apiClient.post('/groups', data: {
      'name': name,
      'description': description,
      'isPublic': isPublic,
    });
    return Group.fromJson(response.data);
  }

  Future<List<Group>> getMyGroups() async {
    final response = await _apiClient.get('/groups');
    return (response.data as List).map((json) => Group.fromJson(json)).toList();
  }

  Future<Group> getGroupDetails(String groupId) async {
    final response = await _apiClient.get('/groups/$groupId');
    return Group.fromJson(response.data);
  }

  Future<void> joinGroup(String inviteCode) async {
    await _apiClient.post('/groups/join', data: {'code': inviteCode});
  }

  Future<void> leaveGroup(String groupId) async {
    await _apiClient.delete('/groups/$groupId/leave');
  }

  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    final response = await _apiClient.get('/groups/$groupId/members');
    return (response.data as List)
        .map((json) => GroupMember.fromJson(json))
        .toList();
  }

  Future<List<GroupRanking>> getGroupRanking(String groupId) async {
    final response = await _apiClient.get('/groups/$groupId/ranking');
    return (response.data as List)
        .map((json) => GroupRanking.fromJson(json))
        .toList();
  }

  Future<void> updateGroup(String groupId, {String? name, String? description}) async {
    await _apiClient.patch('/groups/$groupId', data: {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
  }

  Future<void> deleteGroup(String groupId) async {
    await _apiClient.delete('/groups/$groupId');
  }
}

// Providers
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GroupRepository(apiClient);
});

final myGroupsProvider = FutureProvider<List<Group>>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return repository.getMyGroups();
});

final groupDetailsProvider = FutureProvider.family<Group, String>((ref, groupId) {
  final repository = ref.watch(groupRepositoryProvider);
  return repository.getGroupDetails(groupId);
});

final groupMembersProvider = FutureProvider.family<List<GroupMember>, String>((ref, groupId) {
  final repository = ref.watch(groupRepositoryProvider);
  return repository.getGroupMembers(groupId);
});

final groupRankingProvider = FutureProvider.family<List<GroupRanking>, String>((ref, groupId) {
  final repository = ref.watch(groupRepositoryProvider);
  return repository.getGroupRanking(groupId);
});

