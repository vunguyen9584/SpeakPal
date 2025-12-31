import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/history_item.dart';
import '../widgets/history_list_item.dart';

/// History screen displaying scrollable list of all activities
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  DateTime? _startDate;
  DateTime? _endDate;
  HistoryActivityType? _selectedType;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _buildHistoryList(),
      ),
    );
  }

  Widget _buildHistoryList() {
    // Mock data - will be replaced with provider in WP-FE-012-T006
    final historyItems = _getMockHistoryItems();
    final groupedItems = _groupItemsByDate(historyItems);

    if (groupedItems.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: groupedItems.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == groupedItems.length) {
          return _buildLoadingIndicator();
        }

        final entry = groupedItems.entries.elementAt(index);
        final date = entry.key;
        final items = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(date),
            ...items.map((item) {
              return HistoryListItem(
                item: item,
                onTap: item.type == HistoryActivityType.conversation
                    ? () => _onItemTap(item)
                    : null,
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.shade100,
      child: Text(
        _formatDateHeader(date),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No activity history',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your activities will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Activity type filter
                  const Text(
                    'Activity Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterChip('All', null, setModalState),
                      ...HistoryActivityType.values.map((type) {
                        return _buildFilterChip(
                          type.displayName,
                          type,
                          setModalState,
                        );
                      }).toList(),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Date range (placeholder)
                  const Text(
                    'Date Range',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _startDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() => _startDate = date);
                              setModalState(() {});
                            }
                          },
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            _startDate != null
                                ? _formatDate(_startDate!)
                                : 'Start Date',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _endDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() => _endDate = date);
                              setModalState(() {});
                            }
                          },
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            _endDate != null
                                ? _formatDate(_endDate!)
                                : 'End Date',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _currentPage = 1;
                        });
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(
    String label,
    HistoryActivityType? type,
    StateSetter setModalState,
  ) {
    final isSelected = _selectedType == type;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = selected ? type : null;
        });
        setModalState(() {});
      },
    );
  }

  Map<DateTime, List<HistoryItem>> _groupItemsByDate(List<HistoryItem> items) {
    final grouped = <DateTime, List<HistoryItem>>{};

    for (var item in items) {
      final date = DateTime(
        item.timestamp.year,
        item.timestamp.month,
        item.timestamp.day,
      );

      if (grouped.containsKey(date)) {
        grouped[date]!.add(item);
      } else {
        grouped[date] = [item];
      }
    }

    return grouped;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return 'Today';
    } else if (date == yesterday) {
      return 'Yesterday';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  Future<void> _onRefresh() async {
    setState(() {
      _currentPage = 1;
    });
    await Future.delayed(const Duration(seconds: 1));
  }

  void _onItemTap(HistoryItem item) {
    // Navigate to conversation summary (will be implemented later)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('View details: ${item.description}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Mock data for testing UI
  List<HistoryItem> _getMockHistoryItems() {
    final now = DateTime.now();

    return [
      HistoryItem(
        id: '1',
        type: HistoryActivityType.conversation,
        timestamp: now.subtract(const Duration(hours: 2)),
        description: 'Practiced conversation about travel',
        xpEarned: 75,
        metadata: {'mode': 'free_talk', 'duration': 15},
      ),
      HistoryItem(
        id: '2',
        type: HistoryActivityType.vocabularyReview,
        timestamp: now.subtract(const Duration(hours: 5)),
        description: 'Reviewed 12 vocabulary words',
        xpEarned: 30,
        metadata: {'words_reviewed': 12},
      ),
      HistoryItem(
        id: '3',
        type: HistoryActivityType.badgeEarned,
        timestamp: now.subtract(const Duration(hours: 8)),
        description: 'Earned "7-Day Streak" badge',
        xpEarned: 100,
        metadata: {'badge_id': 'streak_7'},
      ),
      HistoryItem(
        id: '4',
        type: HistoryActivityType.conversation,
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        description: 'Practiced conversation about food',
        xpEarned: 65,
        metadata: {'mode': 'scenario', 'scenario': 'restaurant'},
      ),
      HistoryItem(
        id: '5',
        type: HistoryActivityType.challenge,
        timestamp: now.subtract(const Duration(days: 1, hours: 6)),
        description: 'Completed daily pronunciation challenge',
        xpEarned: 50,
        metadata: {'challenge_type': 'pronunciation'},
      ),
      HistoryItem(
        id: '6',
        type: HistoryActivityType.levelUp,
        timestamp: now.subtract(const Duration(days: 2, hours: 4)),
        description: 'Reached Level 6',
        xpEarned: 0,
        metadata: {'old_level': 5, 'new_level': 6},
      ),
      HistoryItem(
        id: '7',
        type: HistoryActivityType.conversation,
        timestamp: now.subtract(const Duration(days: 2, hours: 8)),
        description: 'Practiced conversation about hobbies',
        xpEarned: 70,
        metadata: {'mode': 'free_talk', 'duration': 18},
      ),
      HistoryItem(
        id: '8',
        type: HistoryActivityType.vocabularyReview,
        timestamp: now.subtract(const Duration(days: 3, hours: 2)),
        description: 'Reviewed 15 vocabulary words',
        xpEarned: 35,
        metadata: {'words_reviewed': 15},
      ),
    ];
  }
}
