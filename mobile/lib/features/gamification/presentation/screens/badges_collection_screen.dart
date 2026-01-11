import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/badge.dart';
import '../widgets/badge_detail_modal.dart';
import '../providers/gamification_providers.dart';

class BadgesCollectionScreen extends ConsumerStatefulWidget {
  const BadgesCollectionScreen({super.key});

  @override
  ConsumerState<BadgesCollectionScreen> createState() => _BadgesCollectionScreenState();
}

class _BadgesCollectionScreenState extends ConsumerState<BadgesCollectionScreen> {
  String _selectedCategory = 'All';
  final _categories = ['All', 'Streak', 'Level', 'Conversation', 'Vocabulary', 'Other'];

  @override
  Widget build(BuildContext context) {
    final allBadgesAsync = ref.watch(allBadgesProvider);
    final userBadgesAsync = ref.watch(userBadgesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Badge Collection'),
      ),
      body: allBadgesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (allBadges) {
          return userBadgesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (userBadges) {
              final earnedBadgeCodes = userBadges.map((ub) => ub.badgeCode).toSet();

              // Filter badges by category
              final filteredBadges = _selectedCategory == 'All'
                  ? allBadges
                  : allBadges.where((b) => b.category == _selectedCategory.toLowerCase()).toList();

              return Column(
                children: [
                  // Stats header
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          context,
                          'Collected',
                          '${userBadges.length}',
                          Icons.emoji_events,
                          Colors.amber,
                        ),
                        _buildStatCard(
                          context,
                          'Total',
                          '${allBadges.length}',
                          Icons.stars,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          context,
                          'Progress',
                          allBadges.isEmpty
                              ? '0%'
                              : '${((userBadges.length / allBadges.length) * 100).toInt()}%',
                          Icons.trending_up,
                          Colors.green,
                        ),
                      ],
                    ),
                  ),

          // Category filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Badge grid
          Expanded(
            child: filteredBadges.isEmpty
                ? const Center(child: Text('No badges in this category'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filteredBadges.length,
                    itemBuilder: (context, index) {
                      final badge = filteredBadges[index];
                      final isEarned = earnedBadgeCodes.contains(badge.code);
                      return BadgeCardWidget(
                        badge: badge,
                        isEarned: isEarned,
                        onTap: () => _showBadgeDetail(badge, isEarned),
                      );
                    },
                  ),
          ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _showBadgeDetail(Badge badge, bool isEarned) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BadgeDetailModal(
        badge: badge,
        isEarned: isEarned,
      ),
    );
  }
}

class BadgeCardWidget extends StatelessWidget {
  final Badge badge;
  final bool isEarned;
  final VoidCallback onTap;

  const BadgeCardWidget({
    super.key,
    required this.badge,
    required this.isEarned,
    required this.onTap,
  });

  IconData _getBadgeIcon(String icon) {
    switch (icon) {
      case 'fire':
        return Icons.local_fire_department;
      case 'star':
        return Icons.star;
      case 'chat':
        return Icons.chat;
      case 'book':
        return Icons.book;
      case 'trophy':
        return Icons.emoji_events;
      default:
        return Icons.star;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'streak':
        return Colors.red;
      case 'level':
        return Colors.purple;
      case 'conversation':
        return Colors.blue;
      case 'vocabulary':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(badge.category);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isEarned ? 4 : 1,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isEarned ? color.withValues(alpha: 0.2) : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getBadgeIcon(badge.icon),
                  size: 32,
                  color: isEarned ? color : Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                badge.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: isEarned ? FontWeight.bold : FontWeight.normal,
                      color: isEarned ? null : Colors.grey,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isEarned) ...[
                const SizedBox(height: 4),
                Icon(Icons.lock, size: 16, color: Colors.grey[400]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

