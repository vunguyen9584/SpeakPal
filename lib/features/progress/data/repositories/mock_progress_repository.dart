import 'package:flutter/foundation.dart';
import '../../domain/models/history_item.dart';
import '../../domain/models/report.dart';
import '../../domain/models/stats.dart';
import '../../domain/repositories/progress_repository.dart';

/// Mock implementation of ProgressRepository for testing UI
class MockProgressRepository implements ProgressRepository {
  @override
  Future<Stats> getStats(StatsPeriod period) async {
    await Future.delayed(const Duration(milliseconds: 500));

    switch (period) {
      case StatsPeriod.today:
        return const Stats(
          period: StatsPeriod.today,
          conversations: 2,
          minutes: 35,
          xpEarned: 150,
          vocabularyLearned: 8,
          averagePronunciation: 82.5,
          currentStreak: 7,
        );
      case StatsPeriod.week:
        return const Stats(
          period: StatsPeriod.week,
          conversations: 12,
          minutes: 180,
          xpEarned: 850,
          vocabularyLearned: 45,
          averagePronunciation: 78.3,
          currentStreak: 7,
        );
      case StatsPeriod.month:
        return const Stats(
          period: StatsPeriod.month,
          conversations: 48,
          minutes: 720,
          xpEarned: 3200,
          vocabularyLearned: 165,
          averagePronunciation: 76.8,
          currentStreak: 7,
        );
      case StatsPeriod.allTime:
        return const Stats(
          period: StatsPeriod.allTime,
          conversations: 245,
          minutes: 3680,
          xpEarned: 15750,
          vocabularyLearned: 892,
          averagePronunciation: 74.2,
          currentStreak: 7,
        );
    }
  }

  @override
  Future<WeeklyReport> getWeeklyReport(int weekNumber) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return WeeklyReport(
      weekNumber: weekNumber,
      weekStart: weekStart,
      weekEnd: weekEnd,
      summary: const WeeklyReportSummary(
        conversations: 18,
        minutes: 240,
        xpEarned: 1250,
        vocabularyLearned: 65,
      ),
      achievements: [
        WeeklyAchievement(
          type: 'badge',
          title: '7-Day Streak Badge',
          description: 'Practiced for 7 consecutive days',
          achievedAt: now.subtract(const Duration(days: 2)),
        ),
        WeeklyAchievement(
          type: 'level_up',
          title: 'Reached Level 6',
          description: 'Leveled up from 5 to 6',
          achievedAt: now.subtract(const Duration(days: 4)),
        ),
      ],
      pronunciationComparison: const PronunciationComparison(
        thisWeek: 82.5,
        lastWeek: 78.3,
        improvement: 4.2,
      ),
      topCorrections: const [
        TopCorrection(
          errorType: 'Pronunciation: "th" sound',
          count: 8,
          examples: ['thing → ting'],
        ),
        TopCorrection(
          errorType: 'Grammar: Present Perfect',
          count: 5,
          examples: ['I have went → I have gone'],
        ),
        TopCorrection(
          errorType: 'Vocabulary: Prepositions',
          count: 4,
          examples: ['depend of → depend on'],
        ),
      ],
      vocabularyHighlights: const VocabularyHighlights(
        newWords: 65,
        masteredWords: 12,
        topWords: ['enthusiasm', 'magnificent', 'sophisticated', 'resilient', 'extraordinary'],
      ),
    );
  }

  @override
  Future<MonthlyReport> getMonthlyReport(int month, int year) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final monthStart = DateTime(year, month, 1);
    final monthEnd = DateTime(year, month + 1, 0);

    return MonthlyReport(
      month: month,
      year: year,
      monthStart: monthStart,
      monthEnd: monthEnd,
      summary: const MonthlyReportSummary(
        conversations: 72,
        minutes: 960,
        xpEarned: 4800,
        vocabularyLearned: 245,
        averagePronunciation: 79.2,
      ),
      weeklyProgress: [
        WeeklyProgress(
          weekNumber: 1,
          conversations: 15,
          xpEarned: 980,
          averagePronunciation: 76.5,
          weekStart: monthStart,
        ),
        WeeklyProgress(
          weekNumber: 2,
          conversations: 18,
          xpEarned: 1150,
          averagePronunciation: 78.2,
          weekStart: monthStart.add(const Duration(days: 7)),
        ),
        WeeklyProgress(
          weekNumber: 3,
          conversations: 21,
          xpEarned: 1320,
          averagePronunciation: 80.1,
          weekStart: monthStart.add(const Duration(days: 14)),
        ),
        WeeklyProgress(
          weekNumber: 4,
          conversations: 18,
          xpEarned: 1350,
          averagePronunciation: 81.8,
          weekStart: monthStart.add(const Duration(days: 21)),
        ),
      ],
      topAchievements: [
        TopAchievement(
          title: 'Most Active Week',
          description: 'Week 3 with 21 conversations',
          value: '21',
          icon: 'trophy',
        ),
        TopAchievement(
          title: 'Best Pronunciation',
          description: 'Achieved 81.8 average in Week 4',
          value: '81.8',
          icon: 'mic',
        ),
        TopAchievement(
          title: 'Longest Streak',
          description: 'Maintained 28-day streak',
          value: '28',
          icon: 'fire',
        ),
      ],
      categoryBreakdown: const {
        'Travel': 18,
        'Business': 15,
        'Daily Life': 22,
        'Food': 12,
        'Other': 5,
      },
      improvementAreas: const [
        ImprovementArea(
          category: 'Pronunciation',
          area: '"r" and "l" sounds',
          occurrences: 24,
          recommendation: 'Practice minimal pairs exercises',
        ),
        ImprovementArea(
          category: 'Grammar',
          area: 'Article usage (a/an/the)',
          occurrences: 18,
          recommendation: 'Review definite and indefinite article rules',
        ),
        ImprovementArea(
          category: 'Vocabulary',
          area: 'Phrasal verbs',
          occurrences: 15,
          recommendation: 'Study common phrasal verbs in context',
        ),
      ],
    );
  }

  @override
  Future<PaginatedHistory> getHistory(HistoryQuery query) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final allItems = _generateMockHistoryItems(now);

    // Filter by type
    var filteredItems = query.type != null
        ? allItems.where((item) => item.type == query.type).toList()
        : allItems;

    // Filter by date range
    if (query.startDate != null) {
      filteredItems = filteredItems
          .where((item) => item.timestamp.isAfter(query.startDate!))
          .toList();
    }
    if (query.endDate != null) {
      filteredItems = filteredItems
          .where((item) => item.timestamp.isBefore(query.endDate!))
          .toList();
    }

    // Sort by timestamp descending
    filteredItems.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Pagination
    final startIndex = (query.page - 1) * query.limit;
    final endIndex = startIndex + query.limit;
    final pageItems = filteredItems.sublist(
      startIndex,
      endIndex > filteredItems.length ? filteredItems.length : endIndex,
    );

    return PaginatedHistory(
      items: pageItems,
      totalCount: filteredItems.length,
      page: query.page,
      limit: query.limit,
      hasMore: endIndex < filteredItems.length,
    );
  }

  List<HistoryItem> _generateMockHistoryItems(DateTime now) {
    return [
      HistoryItem(
        id: '1',
        type: HistoryActivityType.conversation,
        timestamp: now.subtract(const Duration(hours: 2)),
        description: 'Practiced conversation about travel',
        xpEarned: 75,
        metadata: const {'mode': 'free_talk', 'duration': 15},
      ),
      HistoryItem(
        id: '2',
        type: HistoryActivityType.vocabularyReview,
        timestamp: now.subtract(const Duration(hours: 5)),
        description: 'Reviewed 12 vocabulary words',
        xpEarned: 30,
        metadata: const {'words_reviewed': 12},
      ),
      HistoryItem(
        id: '3',
        type: HistoryActivityType.badgeEarned,
        timestamp: now.subtract(const Duration(hours: 8)),
        description: 'Earned "7-Day Streak" badge',
        xpEarned: 100,
        metadata: const {'badge_id': 'streak_7'},
      ),
      HistoryItem(
        id: '4',
        type: HistoryActivityType.conversation,
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        description: 'Practiced conversation about food',
        xpEarned: 65,
        metadata: const {'mode': 'scenario', 'scenario': 'restaurant'},
      ),
      HistoryItem(
        id: '5',
        type: HistoryActivityType.challenge,
        timestamp: now.subtract(const Duration(days: 1, hours: 6)),
        description: 'Completed daily pronunciation challenge',
        xpEarned: 50,
        metadata: const {'challenge_type': 'pronunciation'},
      ),
      HistoryItem(
        id: '6',
        type: HistoryActivityType.levelUp,
        timestamp: now.subtract(const Duration(days: 2, hours: 4)),
        description: 'Reached Level 6',
        xpEarned: 0,
        metadata: const {'old_level': 5, 'new_level': 6},
      ),
      HistoryItem(
        id: '7',
        type: HistoryActivityType.conversation,
        timestamp: now.subtract(const Duration(days: 2, hours: 8)),
        description: 'Practiced conversation about hobbies',
        xpEarned: 70,
        metadata: const {'mode': 'free_talk', 'duration': 18},
      ),
      HistoryItem(
        id: '8',
        type: HistoryActivityType.vocabularyReview,
        timestamp: now.subtract(const Duration(days: 3, hours: 2)),
        description: 'Reviewed 15 vocabulary words',
        xpEarned: 35,
        metadata: const {'words_reviewed': 15},
      ),
      HistoryItem(
        id: '9',
        type: HistoryActivityType.conversation,
        timestamp: now.subtract(const Duration(days: 3, hours: 7)),
        description: 'Practiced conversation about business',
        xpEarned: 80,
        metadata: const {'mode': 'scenario', 'scenario': 'meeting'},
      ),
      HistoryItem(
        id: '10',
        type: HistoryActivityType.challenge,
        timestamp: now.subtract(const Duration(days: 4, hours: 2)),
        description: 'Completed daily grammar challenge',
        xpEarned: 45,
        metadata: const {'challenge_type': 'grammar'},
      ),
      HistoryItem(
        id: '11',
        type: HistoryActivityType.conversation,
        timestamp: now.subtract(const Duration(days: 4, hours: 5)),
        description: 'Practiced conversation about shopping',
        xpEarned: 60,
        metadata: const {'mode': 'scenario', 'scenario': 'shopping'},
      ),
      HistoryItem(
        id: '12',
        type: HistoryActivityType.badgeEarned,
        timestamp: now.subtract(const Duration(days: 5, hours: 1)),
        description: 'Earned "Pronunciation Master" badge',
        xpEarned: 150,
        metadata: const {'badge_id': 'pronunciation_master'},
      ),
      HistoryItem(
        id: '13',
        type: HistoryActivityType.vocabularyReview,
        timestamp: now.subtract(const Duration(days: 5, hours: 4)),
        description: 'Reviewed 20 vocabulary words',
        xpEarned: 40,
        metadata: const {'words_reviewed': 20},
      ),
      HistoryItem(
        id: '14',
        type: HistoryActivityType.conversation,
        timestamp: now.subtract(const Duration(days: 6, hours: 3)),
        description: 'Practiced conversation about health',
        xpEarned: 70,
        metadata: const {'mode': 'free_talk', 'duration': 16},
      ),
      HistoryItem(
        id: '15',
        type: HistoryActivityType.challenge,
        timestamp: now.subtract(const Duration(days: 6, hours: 6)),
        description: 'Completed daily vocabulary challenge',
        xpEarned: 55,
        metadata: const {'challenge_type': 'vocabulary'},
      ),
    ];
  }
}
