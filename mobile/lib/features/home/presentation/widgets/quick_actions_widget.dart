import 'package:flutter/material.dart';

enum ConversationMode {
  freetalk,
  instructor,
  roleplay,
}

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ActionCard(
                  icon: Icons.chat,
                  title: 'Free Talk',
                  subtitle: 'Practice freely',
                  color: Theme.of(context).colorScheme.primary,
                  onTap: () => _startConversation(context, ConversationMode.freetalk),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionCard(
                  icon: Icons.school,
                  title: 'Learn',
                  subtitle: 'With guidance',
                  color: Theme.of(context).colorScheme.secondary,
                  onTap: () => _startConversation(context, ConversationMode.instructor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionCard(
                  icon: Icons.theater_comedy,
                  title: 'Roleplay',
                  subtitle: 'Scenarios',
                  color: Theme.of(context).colorScheme.tertiary,
                  onTap: () => _navigateToScenarios(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startConversation(BuildContext context, ConversationMode mode) {
    // Navigate to conversation setup with selected mode
    Navigator.pushNamed(
      context,
      '/conversation/setup',
      arguments: {'mode': mode.name},
    );
    // Alternative with go_router (if using go_router):
    // context.push('/conversation/setup?mode=${mode.name}');
  }

  void _navigateToScenarios(BuildContext context) {
    // Navigate to scenarios list
    Navigator.pushNamed(context, '/scenarios');
    // Alternative with go_router (if using go_router):
    // context.push('/scenarios');
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

