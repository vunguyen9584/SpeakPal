import 'package:flutter/material.dart';
import '../../domain/models/challenge.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Use todayChallengesProvider
    final challenges = <UserChallenge>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenges'),
      ),
      body: challenges.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header
                Card(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.emoji_events, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          'Today\'s Challenges',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Complete challenges to earn bonus XP!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Challenges list
                ...challenges.map((challenge) {
                  return ChallengeCard(challenge: challenge);
                }),

                const SizedBox(height: 16),

                // Timer until refresh
                Center(
                  child: Text(
                    'New challenges in 12h 34m',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final UserChallenge challenge;

  const ChallengeCard({super.key, required this.challenge});

  IconData _getChallengeIcon(String type) {
    switch (type) {
      case 'conversation':
        return Icons.chat;
      case 'vocabulary':
        return Icons.book;
      case 'pronunciation':
        return Icons.record_voice_over;
      case 'streak':
        return Icons.local_fire_department;
      case 'time':
        return Icons.timer;
      default:
        return Icons.star;
    }
  }

  Color _getChallengeColor(String type) {
    switch (type) {
      case 'conversation':
        return Colors.blue;
      case 'vocabulary':
        return Colors.green;
      case 'pronunciation':
        return Colors.orange;
      case 'streak':
        return Colors.red;
      case 'time':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getChallengeColor(challenge.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getChallengeIcon(challenge.type),
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        challenge.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (challenge.completed)
                  const Icon(Icons.check_circle, color: Colors.green)
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+${challenge.xpReward} XP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: challenge.currentProgress / challenge.targetProgress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
                const SizedBox(height: 4),
                Text(
                  '${challenge.currentProgress}/${challenge.targetProgress}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

