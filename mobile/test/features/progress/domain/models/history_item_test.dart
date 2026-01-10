import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/progress/domain/models/history_item.dart';

void main() {
  group('HistoryItem Model Tests', () {
    test('HistoryItem.fromJson creates valid object', () {
      final now = DateTime.now();
      final json = {
        'id': 'h1',
        'type': 'conversation',
        'timestamp': now.toIso8601String(),
        'duration': 120,
        'xpEarned': 50,
        'details': {'topic': 'sports'}
      };

      final item = HistoryItem.fromJson(json);

      expect(item.id, 'h1');
      expect(item.type, HistoryItemType.conversation);
      expect(item.xpEarned, 50);
      expect(item.details['topic'], 'sports');
      expect(item.duration, 120);
    });

    test('HistoryItem.fromJson handles double duration and null details', () {
       final json = {
        'id': 'h2',
        'timestamp': DateTime.now().toIso8601String(),
        'duration': 150.5,
        'details': null
      };

      final item = HistoryItem.fromJson(json);
      expect(item.duration, 150);
      expect(item.details, isEmpty);
    });

    test('HistoryItemType.fromString handles various inputs', () {
      expect(HistoryItemType.fromString('conversation'), HistoryItemType.conversation);
      expect(HistoryItemType.fromString('vocabulary_review'), HistoryItemType.vocabularyReview);
      expect(HistoryItemType.fromString('challenge'), HistoryItemType.challenge);
      expect(HistoryItemType.fromString('unknown'), HistoryItemType.conversation);
    });

    test('HistoryItemType.displayName returns correct strings', () {
      expect(HistoryItemType.conversation.displayName, 'Conversation');
      expect(HistoryItemType.vocabularyReview.displayName, 'Vocabulary Review');
      expect(HistoryItemType.challenge.displayName, 'Challenge');
    });

    test('PaginatedHistory.fromJson handles items and totals', () {
      final json = {
        'items': [
          {
            'id': 'h1',
            'type': 'conversation',
            'timestamp': DateTime.now().toIso8601String(),
            'xpEarned': 10,
            'details': {}
          }
        ],
        'total': 100,
        'page': 1,
        'limit': 20
      };

      final paginated = PaginatedHistory.fromJson(json);

      expect(paginated.items.length, 1);
      expect(paginated.total, 100);
      expect(paginated.hasMore, true);
    });

    test('PaginatedHistory.fromJson handles null items', () {
      final json = {
        'items': null,
        'total': 0,
      };

      final paginated = PaginatedHistory.fromJson(json);

      expect(paginated.items, isEmpty);
      expect(paginated.total, 0);
    });

    test('PaginatedHistory.hasMore returns false when all items loaded', () {
      final paginated = PaginatedHistory(
        items: List.generate(5, (i) => HistoryItem(
          id: '$i',
          type: HistoryItemType.conversation,
          timestamp: DateTime.now(),
          xpEarned: 0,
          details: {},
        )),
        total: 5,
        page: 1,
        limit: 10,
      );

      expect(paginated.hasMore, false);
    });
  });
}
