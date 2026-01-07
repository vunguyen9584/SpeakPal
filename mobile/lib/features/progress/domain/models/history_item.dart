class HistoryItem {
  final String id;
  final HistoryItemType type;
  final DateTime timestamp;
  final int? duration;
  final int xpEarned;
  final Map<String, dynamic> details;

  HistoryItem({
    required this.id,
    required this.type,
    required this.timestamp,
    this.duration,
    required this.xpEarned,
    required this.details,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] ?? '',
      type: HistoryItemType.fromString(json['type'] ?? 'conversation'),
      timestamp: DateTime.parse(json['timestamp']),
      duration: json['duration'],
      xpEarned: json['xpEarned'] ?? 0,
      details: json['details'] ?? {},
    );
  }
}

enum HistoryItemType {
  conversation,
  vocabularyReview,
  challenge;

  static HistoryItemType fromString(String value) {
    switch (value) {
      case 'conversation':
        return HistoryItemType.conversation;
      case 'vocabulary_review':
        return HistoryItemType.vocabularyReview;
      case 'challenge':
        return HistoryItemType.challenge;
      default:
        return HistoryItemType.conversation;
    }
  }

  String get displayName {
    switch (this) {
      case HistoryItemType.conversation:
        return 'Conversation';
      case HistoryItemType.vocabularyReview:
        return 'Vocabulary Review';
      case HistoryItemType.challenge:
        return 'Challenge';
    }
  }
}

class PaginatedHistory {
  final List<HistoryItem> items;
  final int total;
  final int page;
  final int limit;

  PaginatedHistory({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedHistory.fromJson(Map<String, dynamic> json) {
    return PaginatedHistory(
      items: (json['items'] as List?)
              ?.map((e) => HistoryItem.fromJson(e))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
    );
  }

  bool get hasMore => items.length < total;
}
