import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_provider.dart';

/// Widget displaying current subscription status and usage
class SubscriptionStatusWidget extends ConsumerWidget {
  const SubscriptionStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionAsync = ref.watch(subscriptionProvider);
    final usageAsync = ref.watch(usageProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subscription Status
            subscriptionAsync.when(
              data: (subscription) => _buildSubscriptionHeader(context, subscription),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(),
            ),
            const SizedBox(height: 20),

            // Usage Stats
            usageAsync.when(
              data: (usage) => _buildUsageStats(context, usage),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // CTA Button
            subscriptionAsync.when(
              data: (subscription) => _buildActionButton(context, subscription),
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionHeader(BuildContext context, SubscriptionInfo subscription) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: subscription.isPremium
                ? Colors.amber.shade100
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            subscription.isPremium
                ? Icons.workspace_premium
                : Icons.account_circle,
            color: subscription.isPremium ? Colors.amber : Colors.grey,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    subscription.isPremium ? 'Premium' : 'Free Plan',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: subscription.isActive
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subscription.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: subscription.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              if (subscription.isPremium && subscription.expiresAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Expires: ${_formatDate(subscription.expiresAt!)}',
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
    );
  }

  Widget _buildUsageStats(BuildContext context, UsageInfo usage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Usage',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Conversations Usage
        _buildUsageBar(
          label: 'Conversations',
          current: usage.dailyConversations,
          limit: usage.dailyConversationsLimit,
          icon: Icons.chat_bubble,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),

        // Vocabulary Usage
        _buildUsageBar(
          label: 'Vocabulary',
          current: usage.dailyVocabulary,
          limit: usage.dailyVocabularyLimit,
          icon: Icons.book,
          color: Colors.green,
        ),
        const SizedBox(height: 12),

        // Reset Time
        Row(
          children: [
            Icon(Icons.refresh, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              'Resets in ${_getTimeUntilReset(usage.nextResetTime)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUsageBar({
    required String label,
    required int current,
    required int limit,
    required IconData icon,
    required Color color,
  }) {
    final progress = current / limit;
    final isLimitReached = current >= limit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              '$current / $limit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isLimitReached ? Colors.red : color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isLimitReached ? Colors.red : color,
            ),
            minHeight: 8,
          ),
        ),
        if (isLimitReached) ...[
          const SizedBox(height: 4),
          Text(
            'Daily limit reached',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, SubscriptionInfo subscription) {
    if (subscription.isPremium) {
      return OutlinedButton.icon(
        onPressed: () {
          // Navigate to subscription management (platform-specific)
          Navigator.pushNamed(context, '/subscription/manage');
          // Alternative: Open platform subscription settings
          // On iOS: App Store subscription management
          // On Android: Play Store subscription management
        },
        icon: const Icon(Icons.settings),
        label: const Text('Manage Subscription'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () {
        // Navigate to plans screen
        Navigator.pushNamed(context, '/subscription/plans');
        // Alternative with go_router:
        // context.push('/subscription/plans');
      },
      icon: const Icon(Icons.upgrade),
      label: const Text('Upgrade to Premium'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.red),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Failed to load subscription info',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getTimeUntilReset(DateTime resetTime) {
    final now = DateTime.now();
    final diff = resetTime.difference(now);

    if (diff.inHours > 0) {
      return '${diff.inHours}h ${diff.inMinutes % 60}m';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m';
    } else {
      return 'soon';
    }
  }
}

