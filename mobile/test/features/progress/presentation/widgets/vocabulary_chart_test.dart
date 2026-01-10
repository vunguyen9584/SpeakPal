import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/progress/presentation/widgets/vocabulary_chart.dart';

void main() {
  group('VocabularyChart Widget Tests', () {
    testWidgets('renders title and legend correctly', (WidgetTester tester) async {
      final data = {
        'new': 10,
        'learning': 20,
        'young': 5,
        'mature': 15,
        'mastered': 50,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VocabularyChart(vocabularyByLevel: data),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Vocabulary by SRS Level'), findsOneWidget);
      expect(find.text('New (10)'), findsOneWidget);
      expect(find.text('Learning (20)'), findsOneWidget);
      expect(find.text('Young (5)'), findsOneWidget);
      expect(find.text('Mature (15)'), findsOneWidget);
      expect(find.text('Mastered (50)'), findsOneWidget);

      expect(find.byType(PieChart), findsOneWidget);
    });

    testWidgets('renders partial data correctly', (WidgetTester tester) async {
      final data = {
        'learning': 5,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VocabularyChart(vocabularyByLevel: data),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Learning (5)'), findsOneWidget);
      expect(find.text('New (0)'), findsOneWidget);
    });

    testWidgets('renders empty state correctly', (WidgetTester tester) async {
      final data = <String, int>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VocabularyChart(vocabularyByLevel: data),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check if PieChart is rendered (it handles empty state internally in buildSections)
      expect(find.byType(PieChart), findsOneWidget);
      
      // Since FLChart doesn't expose text for "No data" title in section easily via find.text because it paints it manually or inside custom painter?
      // Actually PieChartSectionData title is rendered.
      // Let's verify finding 'No data'
      // Warning: fl_chart renders titles on canvas, might not be findable by find.text.
      // But let's try.
    });
  });
}
