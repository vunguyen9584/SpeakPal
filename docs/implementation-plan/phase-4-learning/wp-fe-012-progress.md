# WP-FE-012: Progress Screens (Frontend)

## Overview

| Item           | Value                                                 |
| -------------- | ----------------------------------------------------- |
| ID             | WP-FE-012                                             |
| Name           | Progress Screens                                      |
| Description    | Statistics dashboard, charts, weekly reports, history |
| Dependencies   | WP-FE-011 (Gamification Screens)                      |
| Estimated Days | 2                                                     |
| Total Tasks    | 6                                                     |
| DD References  | `09-ui-specifications/progress-screens.md`            |

---

## Tasks

### Task 1: Create Progress Feature Structure

- **ID**: WP-FE-012-T001
- **Type**: setup
- **Description**: Tạo feature structure cho Progress
- **Commands**:
  ```bash
  mkdir -p lib/features/progress/{data,domain,presentation}/{models,repositories,providers,screens,widgets}
  ```
- **Files to Create**:
  - `progress_feature.dart`
  - `domain/models/stats.dart`, `report.dart`, `history_item.dart`
  - `domain/repositories/progress_repository.dart`
- **Acceptance Criteria**:
  - [ ] Feature folder structure complete
  - [ ] Models defined
- **Estimated Hours**: 1
- **DD Reference**: N/A

---

### Task 2: Implement Statistics Dashboard

- **ID**: WP-FE-012-T002
- **Type**: feature
- **Description**: Main dashboard với key metrics
- **Files**: `screens/statistics_screen.dart`, `widgets/stat_card.dart`
- **Dashboard Sections**:
  - Period selector: Today / This Week / This Month / All Time
  - Key metrics cards:
    - Total conversations
    - Total practice minutes
    - Total XP earned
    - Vocabulary count
  - Pronunciation average gauge
  - Current streak display
- **Acceptance Criteria**:
  - [ ] Period selector working
  - [ ] 4 stat cards với icons
  - [ ] Pronunciation gauge (0-100)
  - [ ] Data refreshes on period change
- **Estimated Hours**: 2.5
- **DD Reference**: `09-ui-specifications/progress-screens.md`

---

### Task 3: Implement Charts

- **ID**: WP-FE-012-T003
- **Type**: feature
- **Description**: Charts cho trends và visualization
- **Files**: `widgets/conversation_chart.dart`, `widgets/vocabulary_chart.dart`, `widgets/xp_chart.dart`
- **Dependencies**:
  ```yaml
  dependencies:
    fl_chart: ^0.65.0
  ```
- **Charts**:
  - Conversations per day (bar chart, 7 days)
  - Vocabulary progress (pie chart: by SRS level)
  - XP trend (line chart, 30 days)
  - Pronunciation trend (line chart, 30 days)
- **Acceptance Criteria**:
  - [ ] Bar chart cho conversations
  - [ ] Pie chart cho vocabulary levels
  - [ ] Line chart cho XP trend
  - [ ] Interactive tooltips
  - [ ] Responsive sizing
- **Estimated Hours**: 3.5
- **DD Reference**: `09-ui-specifications/progress-screens.md`

---

### Task 4: Implement Weekly Report Screen

- **ID**: WP-FE-012-T004
- **Type**: feature
- **Description**: Detailed weekly report view
- **Files**: `screens/weekly_report_screen.dart`
- **Sections**:
  - Week header (Week 52, Dec 23-29)
  - Summary card (conversations, minutes, XP, vocab)
  - Achievements this week (badges, level ups)
  - Pronunciation comparison (this week vs last week)
  - Top corrections (most common error types)
  - Vocabulary highlights (new words, mastered words)
- **Acceptance Criteria**:
  - [ ] Week selector (prev/next)
  - [ ] All sections displayed
  - [ ] Comparison với previous week
  - [ ] Share report button
- **Estimated Hours**: 2.5
- **DD Reference**: `06-component-design.md#uc023`

---

### Task 5: Implement History List Screen

- **ID**: WP-FE-012-T005
- **Type**: feature
- **Description**: Scrollable history của all activities
- **Files**: `screens/history_screen.dart`, `widgets/history_list_item.dart`
- **Features**:
  - Grouped by date
  - Activity types: Conversation, Vocabulary Review, Challenge
  - Each item shows: time, type icon, description, XP earned
  - Tap conversation to view summary
  - Date range filter
- **Implementation**:
  ```dart
  class HistoryListItem extends StatelessWidget {
    final HistoryItem item;

    IconData get typeIcon => switch (item.type) {
      'conversation' => Icons.chat,
      'vocabulary_review' => Icons.book,
      'challenge' => Icons.flag,
      _ => Icons.star,
    };
  }
  ```
- **Acceptance Criteria**:
  - [ ] Infinite scroll pagination
  - [ ] Date grouping headers
  - [ ] Type icons và colors
  - [ ] XP display per activity
  - [ ] Date range filter
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

### Task 6: Create Progress Providers

- **ID**: WP-FE-012-T006
- **Type**: feature
- **Description**: Riverpod providers cho Progress
- **Files**: `presentation/providers/progress_providers.dart`
- **Providers**:
  ```dart
  final statsProvider = FutureProvider.autoDispose.family<Stats, StatsPeriod>();
  final weeklyReportProvider = FutureProvider.autoDispose.family<WeeklyReport, int>();
  final monthlyReportProvider = FutureProvider.autoDispose.family<MonthlyReport, int>();
  final historyProvider = FutureProvider.autoDispose.family<PaginatedHistory, HistoryQuery>();
  ```
- **Acceptance Criteria**:
  - [ ] All providers implemented
  - [ ] Period-based caching
  - [ ] Pagination support for history
- **Estimated Hours**: 1.5
- **DD Reference**: N/A

---

## Task Summary

| Task ID        | Name                      | Type    | Hours  | Status |
| -------------- | ------------------------- | ------- | ------ | ------ |
| WP-FE-012-T001 | Create Feature Structure  | setup   | 1      | ⬜     |
| WP-FE-012-T002 | Statistics Dashboard      | feature | 2.5    | ⬜     |
| WP-FE-012-T003 | Implement Charts          | feature | 3.5    | ⬜     |
| WP-FE-012-T004 | Weekly Report Screen      | feature | 2.5    | ⬜     |
| WP-FE-012-T005 | History List Screen       | feature | 2      | ⬜     |
| WP-FE-012-T006 | Create Progress Providers | feature | 1.5    | ⬜     |
| **Total**      |                           |         | **13** |        |

---

_Back to: [\_phase-4.md](./_phase-4.md)_
