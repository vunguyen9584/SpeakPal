import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/progress/domain/models/history_item.dart';
import 'package:mobile/features/progress/domain/models/history_query.dart';
import 'package:mobile/features/progress/presentation/providers/progress_providers.dart';
import 'package:mobile/features/progress/presentation/screens/history_list_screen.dart';
import 'dart:async';

void main() {
  group('HistoryListScreen Widget Tests', () {
    testWidgets('displays loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            historyProvider.overrideWith((ref, query) => Completer<PaginatedHistory>().future),
          ],
          child: const MaterialApp(
            home: HistoryListScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message on error', (WidgetTester tester) async {
       await tester.pumpWidget(
        ProviderScope(
          overrides: [
            historyProvider.overrideWith((ref, query) => Future.error('Network Error')),
          ],
          child: const MaterialApp(
            home: HistoryListScreen(),
          ),
        ),
      );

      await tester.pumpWidget(Container()); // Clear previous
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            historyProvider.overrideWith((ref, query) => Future.error('Network Error')),
          ],
          child: const MaterialApp(
            home: HistoryListScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Network Error'), findsOneWidget);
    });

    testWidgets('displays empty state when no history', (WidgetTester tester) async {
      final emptyHistory = PaginatedHistory(items: [], total: 0, page: 1, limit: 10);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
             historyProvider.overrideWith((ref, query) => Future.value(emptyHistory)),
          ],
          child: const MaterialApp(
            home: HistoryListScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('No history yet'), findsOneWidget);
    });

    testWidgets('displays history list grouped by date', (WidgetTester tester) async {
      final now = DateTime.now();
      // Ensure we are working with midnight for "Today" comparison
      final todayMidnight = DateTime(now.year, now.month, now.day);
      
      final history = PaginatedHistory(
        items: [
          HistoryItem(
            id: '1',
            type: HistoryItemType.conversation,
            timestamp: todayMidnight.add(const Duration(hours: 10)),
            duration: 10,
            xpEarned: 50,
            details: {},
          ),
        ],
        total: 1,
        page: 1,
        limit: 10,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            historyProvider.overrideWith((ref, query) => Future.value(history)),
          ],
          child: const MaterialApp(
            home: HistoryListScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Conversation Practice'), findsOneWidget);
    });

    testWidgets('opens filter dialog when filter button tapped', (WidgetTester tester) async {
       final emptyHistory = PaginatedHistory(items: [], total: 0, page: 1, limit: 10);
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            historyProvider.overrideWith((ref, query) => Future.value(emptyHistory)),
          ],
          child: const MaterialApp(
            home: HistoryListScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Filter History'), findsOneWidget);
    });
  });
}
