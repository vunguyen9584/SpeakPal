import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../domain/models/history_item.dart';
import '../providers/progress_providers.dart';

class HistoryListScreen extends ConsumerStatefulWidget {
  const HistoryListScreen({super.key});

  @override
  ConsumerState<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends ConsumerState<HistoryListScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  DateTime? _startDate;
  DateTime? _endDate;
  HistoryItemType? _selectedType;

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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      // Load more when 90% scrolled
      _loadMore();
    }
  }

  void _loadMore() {
    setState(() => _currentPage++);
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider(HistoryQuery(
      page: _currentPage,
      startDate: _startDate,
      endDate: _endDate,
      type: _selectedType,
    )));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning History'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          // Active Filters
          if (_startDate != null || _endDate != null || _selectedType != null)
            _buildActiveFilters(),

          // History List
          Expanded(
            child: historyAsync.when(
              data: (history) => _buildHistoryList(history),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading history: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (_startDate != null || _endDate != null)
            Chip(
              label: Text(
                '${_formatDate(_startDate ?? DateTime.now())} - ${_formatDate(_endDate ?? DateTime.now())}',
              ),
              onDeleted: () => setState(() {
                _startDate = null;
                _endDate = null;
                _currentPage = 1;
              }),
            ),
          if (_selectedType != null)
            Chip(
              label: Text(_selectedType!.displayName),
              onDeleted: () => setState(() {
                _selectedType = null;
                _currentPage = 1;
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(PaginatedHistory history) {
    if (history.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No history yet',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Start practicing to see your history',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    // Group items by date
    final groupedItems = _groupByDate(history.items);

    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _currentPage = 1);
        ref.invalidate(historyProvider);
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: groupedItems.length + (history.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= groupedItems.length) {
            // Loading indicator for pagination
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final entry = groupedItems.entries.elementAt(index);
          return _buildDateGroup(entry.key, entry.value);
        },
      ),
    );
  }

  Widget _buildDateGroup(DateTime date, List<HistoryItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            _formatDateHeader(date),
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
        ),
        ...items.map((item) => _buildHistoryItem(item)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHistoryItem(HistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getTypeColor(item.type).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getTypeIcon(item.type),
            color: _getTypeColor(item.type),
          ),
        ),
        title: Text(
          _getItemTitle(item),
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              _formatTime(item.timestamp),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            if (item.duration != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${item.duration} min',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, size: 16, color: AppColors.accent),
              const SizedBox(width: 4),
              Text(
                '+${item.xpEarned}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        onTap: () => _showItemDetails(item),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter History'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date Range
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Date Range'),
              subtitle: Text(
                _startDate != null
                    ? '${_formatDate(_startDate!)} - ${_formatDate(_endDate ?? DateTime.now())}'
                    : 'All time',
              ),
              onTap: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (range != null) {
                  setState(() {
                    _startDate = range.start;
                    _endDate = range.end;
                    _currentPage = 1;
                  });
                  Navigator.pop(context);
                }
              },
            ),

            // Activity Type
            const Divider(),
            const Text('Activity Type'),
            ...HistoryItemType.values.map((type) {
              return RadioListTile<HistoryItemType?>(
                title: Text(type.displayName),
                value: type,
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                    _currentPage = 1;
                  });
                  Navigator.pop(context);
                },
              );
            }),
            RadioListTile<HistoryItemType?>(
              title: const Text('All'),
              value: null,
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = null;
                  _currentPage = 1;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _startDate = null;
                _endDate = null;
                _selectedType = null;
                _currentPage = 1;
              });
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showItemDetails(HistoryItem item) {
    // Navigate to detail screen based on type
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View details for ${_getItemTitle(item)}')),
    );
  }

  Map<DateTime, List<HistoryItem>> _groupByDate(List<HistoryItem> items) {
    final grouped = <DateTime, List<HistoryItem>>{};
    for (final item in items) {
      final date = DateTime(
        item.timestamp.year,
        item.timestamp.month,
        item.timestamp.day,
      );
      grouped.putIfAbsent(date, () => []).add(item);
    }
    return grouped;
  }

  IconData _getTypeIcon(HistoryItemType type) {
    switch (type) {
      case HistoryItemType.conversation:
        return Icons.chat_bubble;
      case HistoryItemType.vocabularyReview:
        return Icons.book;
      case HistoryItemType.challenge:
        return Icons.flag;
    }
  }

  Color _getTypeColor(HistoryItemType type) {
    switch (type) {
      case HistoryItemType.conversation:
        return AppColors.primary;
      case HistoryItemType.vocabularyReview:
        return AppColors.success;
      case HistoryItemType.challenge:
        return AppColors.warning;
    }
  }

  String _getItemTitle(HistoryItem item) {
    switch (item.type) {
      case HistoryItemType.conversation:
        return 'Conversation Practice';
      case HistoryItemType.vocabularyReview:
        return 'Vocabulary Review';
      case HistoryItemType.challenge:
        return 'Daily Challenge';
    }
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class HistoryQuery {
  final int page;
  final DateTime? startDate;
  final DateTime? endDate;
  final HistoryItemType? type;

  HistoryQuery({
    required this.page,
    this.startDate,
    this.endDate,
    this.type,
  });
}
