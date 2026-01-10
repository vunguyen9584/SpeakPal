import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/progress/domain/models/report.dart';

void main() {
  group('Report Models Tests', () {
    test('WeeklyReport.fromJson and toJson parity', () {
      final now = DateTime.now().toIso8601String();
      final json = {
        'weekNumber': 45,
        'startDate': now,
        'endDate': now,
        'summary': {
          'totalConversations': 10,
          'totalMinutes': 120,
          'totalXp': 500,
        },
        'pronunciationTrend': [80.0, 85.5, 90.0],
        'topCorrections': [
          {
            'type': 'grammar',
            'count': 5,
            'example': 'I is -> I am',
          }
        ],
        'vocabularyProgress': {
          'newWords': 50,
          'masteredWords': 30,
        },
        'achievements': [
          {
            'type': 'streak',
            'name': '7 Day Streak',
            'description': 'You kept it up for a week!',
            'earnedAt': now,
          }
        ]
      };

      final report = WeeklyReport.fromJson(json);
      expect(report.weekNumber, 45);
      expect(report.toJson(), json);
    });

    test('MonthlyReport.fromJson and toJson parity', () {
      final now = DateTime.now().toIso8601String();
      final json = {
        'monthNumber': 11,
        'startDate': now,
        'endDate': now,
        'summary': {
          'totalConversations': 40,
          'totalMinutes': 500,
          'totalXp': 2000,
        },
        'pronunciationTrend': [],
        'topCorrections': [],
        'vocabularyProgress': {
          'newWords': 200,
          'masteredWords': 150,
        },
        'achievements': []
      };

      final report = MonthlyReport.fromJson(json);
      expect(report.monthNumber, 11);
      expect(report.toJson(), json);
    });

    test('ReportSummary.fromJson handles missing data', () {
      final summary = ReportSummary.fromJson({});
      expect(summary.totalConversations, 0);
      expect(summary.totalMinutes, 0);
      expect(summary.totalXp, 0);
    });

    test('TopCorrection.fromJson handles missing data', () {
      final correction = TopCorrection.fromJson({});
      expect(correction.type, '');
      expect(correction.count, 0);
    });

    test('VocabularyProgress.fromJson handles missing data', () {
      final progress = VocabularyProgress.fromJson({});
      expect(progress.newWords, 0);
      expect(progress.masteredWords, 0);
    });

    test('Achievement.fromJson creates valid object', () {
      final now = DateTime.now();
      final json = {
        'type': 'badge',
        'name': 'Explorer',
        'description': 'Description',
        'earnedAt': now.toIso8601String(),
      };
      
      final ach = Achievement.fromJson(json);
      expect(ach.name, 'Explorer');
      expect(ach.toJson(), json);
    });
  });
}
