import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:share_plus/share_plus.dart';
import '../providers/group_provider.dart';

/// Detailed view of a study group with members and rankings
class GroupDetailScreen extends ConsumerWidget {
  final String groupId;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(groupDetailsProvider(groupId));
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final rankingAsync = ref.watch(groupRankingProvider(groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(groupDetailsProvider(groupId));
              ref.invalidate(groupMembersProvider(groupId));
              ref.invalidate(groupRankingProvider(groupId));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(groupDetailsProvider(groupId));
          ref.invalidate(groupMembersProvider(groupId));
          ref.invalidate(groupRankingProvider(groupId));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Group Info Card
              groupAsync.when(
                data: (group) => _buildGroupInfoCard(context, ref, group),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _buildErrorCard('Failed to load group info'),
              ),
              const SizedBox(height: 16),

              // Weekly Rankings
              rankingAsync.when(
                data: (rankings) => _buildRankingsCard(rankings),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _buildErrorCard('Failed to load rankings'),
              ),
              const SizedBox(height: 16),

              // Members List
              membersAsync.when(
                data: (members) => _buildMembersCard(members),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _buildErrorCard('Failed to load members'),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              groupAsync.when(
                data: (group) => _buildActionButtons(context, ref, group),
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupInfoCard(BuildContext context, WidgetRef ref, Group group) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    group.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (group.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          group.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.people,
                  label: 'Members',
                  value: group.memberCount.toString(),
                  color: Colors.blue,
                ),
                _buildStatItem(
                  icon: Icons.calendar_today,
                  label: 'Created',
                  value: _formatDate(group.createdAt),
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Invite Code',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          group.inviteCode,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: group.inviteCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invite code copied!')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Share.share(
                    //   'Join our SpeakPal study group "${group.name}"!\nInvite code: ${group.inviteCode}',
                    //   subject: 'Join ${group.name}',
                    // );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sharing not yet available')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRankingsCard(List<GroupRanking> rankings) {
    if (rankings.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.leaderboard, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'No rankings yet',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  'Weekly Leaderboard',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rankings.length > 10 ? 10 : rankings.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final ranking = rankings[index];
                return _buildRankingTile(ranking, index + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingTile(GroupRanking ranking, int position) {
    Color? medalColor;
    IconData? medalIcon;

    if (position == 1) {
      medalColor = Colors.amber;
      medalIcon = Icons.emoji_events;
    } else if (position == 2) {
      medalColor = Colors.grey;
      medalIcon = Icons.emoji_events;
    } else if (position == 3) {
      medalColor = Colors.brown;
      medalIcon = Icons.emoji_events;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: SizedBox(
        width: 40,
        child: Row(
          children: [
            if (medalIcon != null)
              Icon(medalIcon, color: medalColor, size: 24)
            else
              Text(
                '#$position',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
      title: Text(
        ranking.username,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, size: 16, color: Colors.blue),
            const SizedBox(width: 4),
            Text(
              '${ranking.weeklyXp} XP',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersCard(List<GroupMember> members) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.people, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Members (${members.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: members.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final member = members[index];
                return _buildMemberTile(member);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(GroupMember member) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: member.role == 'owner'
            ? Colors.amber.shade100
            : Colors.blue.shade100,
        child: Text(
          member.username[0].toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: member.role == 'owner' ? Colors.amber.shade900 : Colors.blue,
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            member.username,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (member.role == 'owner') ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Owner',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text('Joined ${_formatDate(member.joinedAt)}'),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, Group group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: () => _showLeaveGroupDialog(context, ref, group),
          icon: const Icon(Icons.exit_to_app, color: Colors.red),
          label: const Text('Leave Group'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
        ),
      ],
    );
  }

  void _showLeaveGroupDialog(BuildContext context, WidgetRef ref, Group group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Group'),
        content: Text('Are you sure you want to leave "${group.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final repository = ref.read(groupRepositoryProvider);
                await repository.leaveGroup(group.id);
                
                if (!context.mounted) return;
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to groups list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Left group successfully')),
                );
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

