import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_text_styles.dart';

class VocabularyChart extends StatelessWidget {
  final Map<String, int> vocabularyByLevel; // SRS level distribution

  const VocabularyChart({
    super.key,
    required this.vocabularyByLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vocabulary by SRS Level',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sections: _buildSections(),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildLegend(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final colors = {
      'new': Colors.grey,
      'learning': Colors.blue,
      'young': Colors.green,
      'mature': Colors.orange,
      'mastered': Colors.purple,
    };

    final total = vocabularyByLevel.values.fold(0, (sum, count) => sum + count);
    if (total == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: 1,
          title: 'No data',
          radius: 60,
          titleStyle: AppTextStyles.bodySmall.copyWith(color: Colors.white),
        ),
      ];
    }

    return vocabularyByLevel.entries.map((entry) {
      final percentage = (entry.value / total * 100).toStringAsFixed(1);
      return PieChartSectionData(
        color: colors[entry.key] ?? Colors.grey,
        value: entry.value.toDouble(),
        title: '$percentage%',
        radius: 60,
        titleStyle: AppTextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    final items = {
      'new': {'color': Colors.grey, 'label': 'New'},
      'learning': {'color': Colors.blue, 'label': 'Learning'},
      'young': {'color': Colors.green, 'label': 'Young'},
      'mature': {'color': Colors.orange, 'label': 'Mature'},
      'mastered': {'color': Colors.purple, 'label': 'Mastered'},
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.entries.map((entry) {
        final count = vocabularyByLevel[entry.key] ?? 0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: entry.value['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${entry.value['label']} ($count)',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
