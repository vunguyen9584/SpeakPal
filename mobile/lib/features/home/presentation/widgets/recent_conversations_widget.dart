import 'package:flutter/material.dart';
import '../../domain/models/recent_conversation.dart';

class RecentConversationsWidget extends StatelessWidget {
  final List<RecentConversation> conversations;

  const RecentConversationsWidget({
    super.key,
    required this.conversations,
  });

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyState(context),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= conversations.length) return null;
          return ConversationListItem(conversation: conversations[index]);
        },
        childCount: conversations.length,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start your first conversation to practice!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }
}

class ConversationListItem extends StatelessWidget {
  final RecentConversation conversation;

  const ConversationListItem({
    super.key,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _getModeIcon(),
      title: Text(_formatDate()),
      subtitle: Text(
        '${conversation.mode} - ${conversation.formattedDuration}',
      ),
      trailing: ScoreBadge(score: conversation.pronunciationScore),
      onTap: () => _viewConversationSummary(context),
    );
  }

  Widget _getModeIcon() {
    IconData icon;
    Color color;

    switch (conversation.mode.toLowerCase()) {
      case 'freetalk':
        icon = Icons.chat;
        color = Colors.blue;
        break;
      case 'instructor':
        icon = Icons.school;
        color = Colors.green;
        break;
      case 'roleplay':
        icon = Icons.theater_comedy;
        color = Colors.orange;
        break;
      default:
        icon = Icons.chat;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.2),
      child: Icon(icon, color: color, size: 20),
    );
  }

  String _formatDate() {
    final now = DateTime.now();
    final diff = now.difference(conversation.date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${conversation.date.month}/${conversation.date.day}';
    }
  }

  void _viewConversationSummary(BuildContext context) {
    // TODO: Navigate to summary
    // context.go('/conversation/${conversation.id}/summary');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening conversation summary...')),
    );
  }
}

class ScoreBadge extends StatelessWidget {
  final int score;

  const ScoreBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (score >= 80) {
      color = Colors.green;
    } else if (score >= 60) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$score%',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

