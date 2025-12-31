import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/badge.dart';
import '../widgets/badge_grid_item.dart';
import '../widgets/badge_detail_modal.dart';

/// Badges collection screen displaying all available and earned badges
class BadgesScreen extends ConsumerStatefulWidget {
  const BadgesScreen({super.key});

  @override
  ConsumerState<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends ConsumerState<BadgesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BadgeCategory _selectedCategory = BadgeCategory.all;

  final List<BadgeCategory> _categories = [
    BadgeCategory.all,
    BadgeCategory.streak,
    BadgeCategory.level,
    BadgeCategory.conversation,
    BadgeCategory.vocabulary,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategory = _categories[_tabController.index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badges Collection'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildCategoryTabs(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Theme.of(context).colorScheme.primary,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        tabs: _categories.map((category) {
          return Tab(
            text: category.displayName,
            icon: _getCategoryIcon(category),
          );
        }).toList(),
      ),
    );
  }

  Icon _getCategoryIcon(BadgeCategory category) {
    IconData iconData;
    switch (category) {
      case BadgeCategory.all:
        iconData = Icons.grid_view;
        break;
      case BadgeCategory.streak:
        iconData = Icons.local_fire_department;
        break;
      case BadgeCategory.level:
        iconData = Icons.emoji_events;
        break;
      case BadgeCategory.conversation:
        iconData = Icons.chat_bubble;
        break;
      case BadgeCategory.vocabulary:
        iconData = Icons.book;
        break;
    }
    return Icon(iconData, size: 20);
  }

  Widget _buildBody() {
    // For now, using mock data since providers will be created in WP-FE-011-T007
    // This will be replaced with: ref.watch(allBadgesProvider)
    return _buildBadgeGrid(_getMockBadges());
  }

  Widget _buildBadgeGrid(List<Badge> badges) {
    // Filter badges by category
    final filteredBadges = _selectedCategory == BadgeCategory.all
        ? badges
        : badges.where((b) => b.category == _selectedCategory).toList();

    if (filteredBadges.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: filteredBadges.length,
        itemBuilder: (context, index) {
          final badge = filteredBadges[index];
          return BadgeGridItem(
            badge: badge,
            onTap: () => _onBadgeTap(badge),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No badges in this category',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Refresh badge data
    // This will be implemented when providers are added
    await Future.delayed(const Duration(seconds: 1));
  }

  void _onBadgeTap(Badge badge) {
    BadgeDetailModal.show(context, badge);
  }

  // Mock data for testing UI
  List<Badge> _getMockBadges() {
    return [
      Badge(
        id: '1',
        name: 'First Steps',
        description: 'Complete your first conversation',
        iconUrl: '',
        category: BadgeCategory.conversation,
        xpBonus: 50,
        conditionDescription: 'Complete 1 conversation',
        earnedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Badge(
        id: '2',
        name: '7-Day Streak',
        description: 'Maintain a 7-day streak',
        iconUrl: '',
        category: BadgeCategory.streak,
        xpBonus: 100,
        conditionDescription: 'Practice for 7 consecutive days',
        earnedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Badge(
        id: '3',
        name: 'Vocabulary Master',
        description: 'Learn 100 new words',
        iconUrl: '',
        category: BadgeCategory.vocabulary,
        xpBonus: 200,
        conditionDescription: 'Master 100 vocabulary words',
        progress: 0.65,
      ),
      Badge(
        id: '4',
        name: 'Level 10',
        description: 'Reach level 10',
        iconUrl: '',
        category: BadgeCategory.level,
        xpBonus: 500,
        conditionDescription: 'Reach level 10',
        progress: 0.40,
      ),
      Badge(
        id: '5',
        name: 'Chatterbox',
        description: 'Complete 50 conversations',
        iconUrl: '',
        category: BadgeCategory.conversation,
        xpBonus: 300,
        conditionDescription: 'Complete 50 conversations',
        progress: 0.24,
      ),
      Badge(
        id: '6',
        name: '30-Day Streak',
        description: 'Maintain a 30-day streak',
        iconUrl: '',
        category: BadgeCategory.streak,
        xpBonus: 500,
        conditionDescription: 'Practice for 30 consecutive days',
        progress: 0.10,
      ),
    ];
  }
}
