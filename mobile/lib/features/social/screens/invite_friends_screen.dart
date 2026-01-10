import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/invitation_provider.dart';

class InviteFriendsScreen extends ConsumerWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitationsAsync = ref.watch(myInvitationsProvider);
    final statsAsync = ref.watch(referralStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Friends'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myInvitationsProvider);
          ref.invalidate(referralStatsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Invite Code Card
              invitationsAsync.when(
                data: (invitations) {
                  if (invitations.isEmpty) {
                    return _buildGenerateInviteButton(context, ref);
                  }
                  final invitation = invitations.first;
                  return _buildInviteCodeCard(context, invitation);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _buildGenerateInviteButton(context, ref),
              ),
              const SizedBox(height: 24),

              // Referral Stats
              statsAsync.when(
                data: (stats) => _buildReferralStats(context, stats),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),

              // Referral History
              statsAsync.when(
                data: (stats) => _buildReferralHistory(context, stats),
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInviteCodeCard(BuildContext context, InvitationResponse invitation) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.card_giftcard, size: 48, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Your Invite Code',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200, width: 2),
              ),
              child: Text(
                invitation.code,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: invitation.code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied to clipboard!')),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Share.share(
                      'Join me on SpeakPal! Use my invite code: ${invitation.code}\n${invitation.inviteUrl}',
                      subject: 'Join SpeakPal',
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Used ${invitation.usageCount}/${invitation.maxUsage} times',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateInviteButton(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Generate your invite code to start referring friends!'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final repository = ref.read(invitationRepositoryProvider);
                  await repository.generateInvite();
                  ref.invalidate(myInvitationsProvider);
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Generate Invite Code'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralStats(BuildContext context, ReferralStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Referral Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Referrals', stats.totalReferrals.toString(), Icons.people),
                _buildStatItem('Rewards Earned', stats.rewards.length.toString(), Icons.card_giftcard),
              ],
            ),
            if (stats.rewards.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Rewards',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...stats.rewards.map((reward) => ListTile(
                    leading: Icon(
                      reward.claimed ? Icons.check_circle : Icons.circle_outlined,
                      color: reward.claimed ? Colors.green : Colors.grey,
                    ),
                    title: Text(reward.type),
                    subtitle: Text(reward.description),
                    dense: true,
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildReferralHistory(BuildContext context, ReferralStats stats) {
    if (stats.referrals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Referral History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...stats.referrals.map((referral) => ListTile(
                  leading: CircleAvatar(
                    child: Text(referral.username[0].toUpperCase()),
                  ),
                  title: Text(referral.username),
                  subtitle: Text('Joined ${_formatDate(referral.joinedAt)}'),
                  dense: true,
                )),
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

