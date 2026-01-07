# WP-FE-007: Home & Dashboard (Frontend)

## Overview

| Item           | Value                                                                |
| -------------- | -------------------------------------------------------------------- |
| ID             | WP-FE-007                                                            |
| Name           | Home & Dashboard                                                     |
| Description    | Main home screen with dashboard, quick actions, recent conversations |
| Dependencies   | WP-FE-006 (Profile & Settings)                                       |
| Estimated Days | 3                                                                    |
| Total Tasks    | 6                                                                    |
| DD References  | `09-ui-specifications.md#home`, `06-component-design.md#home`        |

---

## Tasks

### Task 1: Create Home Feature Structure

- **ID**: WP-FE-007-T001
- **Type**: setup
- **Description**: Tạo feature structure cho Home với clean architecture
- **Commands**:
  ```bash
  cd mobile
  mkdir -p lib/features/home/{data,domain,presentation}/{models,repositories,providers,screens,widgets}
  ```
- **Files to Create**:
  - `lib/features/home/home_feature.dart` - Feature barrel file
  - `lib/features/home/domain/models/dashboard_stats.dart` - Stats model
  - `lib/features/home/domain/models/recent_conversation.dart` - Model
  - `lib/features/home/domain/repositories/home_repository.dart` - Repository interface
  - `lib/features/home/data/repositories/home_repository_impl.dart` - Implementation
- **Implementation Details**:
  ```dart
  // dashboard_stats.dart
  class DashboardStats {
    final int todayMinutes;
    final int weeklyMinutes;
    final int currentStreak;
    final int totalXp;
    final int level;
    final double pronunciationAvg;
    final int conversationsToday;
    final int dailyGoal;
  }
  ```
- **Acceptance Criteria**:
  - [ ] Feature folder structure theo clean architecture
  - [ ] DashboardStats model với all stats fields
  - [ ] RecentConversation model với id, mode, duration, score, date
  - [ ] HomeRepository interface defined
  - [ ] Feature barrel file exports all public classes
- **Estimated Hours**: 1
- **DD Reference**: `09-ui-specifications.md#home`

---

### Task 2: Implement Home Screen Layout

- **ID**: WP-FE-007-T002
- **Type**: feature
- **Description**: Implement main home screen layout với responsive design
- **Files to Create**:
  - `lib/features/home/presentation/screens/home_screen.dart`
  - `lib/features/home/presentation/providers/home_provider.dart`
- **Wireframe Reference**:
  ```
  ┌────────────────────────────────────────┐
  │ Good morning, BMad!        [Settings] │
  │                                        │
  │ ┌────────────────────────────────────┐ │
  │ │  Today's Progress                  │ │
  │ │  ██████████░░░ 15/30 min          │ │
  │ │  🔥 7 day streak                   │ │
  │ └────────────────────────────────────┘ │
  │                                        │
  │ Quick Actions                          │
  │ ┌─────────┐ ┌─────────┐ ┌─────────┐   │
  │ │ 🗣️ Free  │ │ 📚 Learn │ │ 🎭 Role │   │
  │ │  Talk   │ │  Mode   │ │  Play  │   │
  │ └─────────┘ └─────────┘ └─────────┘   │
  │                                        │
  │ Recent Conversations                   │
  │ ┌────────────────────────────────────┐ │
  │ │ Today - Free Talk - 8:32 - 85%    │ │
  │ │ Yesterday - Roleplay - 5:15 - 78% │ │
  │ └────────────────────────────────────┘ │
  └────────────────────────────────────────┘
  ```
- **Implementation Details**:

  ```dart
  class HomeScreen extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final stats = ref.watch(dashboardStatsProvider);
      final recentConversations = ref.watch(recentConversationsProvider);

      return Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Greeting header
              SliverToBoxAdapter(child: _buildGreeting()),
              // Daily progress card
              SliverToBoxAdapter(child: DailyProgressWidget()),
              // Quick actions
              SliverToBoxAdapter(child: QuickActionsWidget()),
              // Recent conversations list
              SliverList(delegate: SliverChildBuilderDelegate(...)),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Greeting với user name và time-based message
  - [ ] Daily progress card với progress bar
  - [ ] Quick action buttons (Free Talk, Learn, Roleplay)
  - [ ] Recent conversations list
  - [ ] Pull-to-refresh support
  - [ ] Loading và error states
- **Estimated Hours**: 3
- **DD Reference**: `09-ui-specifications.md#home`

---

### Task 3: Create Quick Action Cards

- **ID**: WP-FE-007-T003
- **Type**: feature
- **Description**: Create interactive quick action cards để start conversation modes
- **Files to Create**:
  - `lib/features/home/presentation/widgets/quick_actions_widget.dart`
  - `lib/features/home/presentation/widgets/action_card.dart`
- **Implementation Details**:
  ```dart
  class QuickActionsWidget extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionCard(
            icon: Icons.chat,
            title: 'Free Talk',
            subtitle: 'Practice freely',
            color: AppColors.primary,
            onTap: () => _startConversation(ConversationMode.freetalk),
          ),
          ActionCard(
            icon: Icons.school,
            title: 'Learn',
            subtitle: 'With guidance',
            color: AppColors.secondary,
            onTap: () => _startConversation(ConversationMode.instructor),
          ),
          ActionCard(
            icon: Icons.theater_comedy,
            title: 'Roleplay',
            subtitle: 'Scenarios',
            color: AppColors.tertiary,
            onTap: () => _navigateToScenarios(),
          ),
        ],
      );
    }
  }
  ```
- **Acceptance Criteria**:
  - [ ] 3 action cards: Free Talk, Learn Mode, Roleplay
  - [ ] Each card có icon, title, subtitle, background color
  - [ ] Tap animation (scale down effect)
  - [ ] Navigate to conversation hoặc scenario selection
  - [ ] Responsive sizing cho different screen sizes
- **Estimated Hours**: 1.5
- **DD Reference**: `09-ui-specifications.md#home`

---

### Task 4: Create Recent Conversations Widget

- **ID**: WP-FE-007-T004
- **Type**: feature
- **Description**: Create widget hiển thị recent conversations với quick access
- **Files to Create**:
  - `lib/features/home/presentation/widgets/recent_conversations_widget.dart`
  - `lib/features/home/presentation/widgets/conversation_list_item.dart`
- **Implementation Details**:

  ```dart
  class ConversationListItem extends StatelessWidget {
    final RecentConversation conversation;

    @override
    Widget build(BuildContext context) {
      return ListTile(
        leading: _getModeIcon(conversation.mode),
        title: Text(_formatDate(conversation.date)),
        subtitle: Text('${conversation.mode} - ${_formatDuration(conversation.duration)}'),
        trailing: ScoreBadge(score: conversation.pronunciationScore),
        onTap: () => _viewConversationSummary(conversation.id),
      );
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] List 5 most recent conversations
  - [ ] Each item shows: date, mode, duration, score
  - [ ] Score color coded (green/yellow/red)
  - [ ] Tap để view conversation summary
  - [ ] "View All" link to full history
  - [ ] Empty state khi no conversations yet
- **Estimated Hours**: 1.5
- **DD Reference**: `09-ui-specifications.md#home`

---

### Task 5: Create Daily Progress Widget

- **ID**: WP-FE-007-T005
- **Type**: feature
- **Description**: Create widget hiển thị daily progress với streak info
- **Files to Create**:
  - `lib/features/home/presentation/widgets/daily_progress_widget.dart`
  - `lib/features/home/presentation/widgets/streak_badge.dart`
- **Implementation Details**:

  ```dart
  class DailyProgressWidget extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final stats = ref.watch(dashboardStatsProvider);

      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Progress"),
                  StreakBadge(streak: stats.currentStreak),
                ],
              ),
              SizedBox(height: 12),
              LinearProgressIndicator(
                value: stats.todayMinutes / stats.dailyGoal,
              ),
              SizedBox(height: 8),
              Text('${stats.todayMinutes}/${stats.dailyGoal} minutes'),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Progress bar showing today's practice vs goal
  - [ ] Streak badge với fire icon và number
  - [ ] Streak animation khi đạt milestone (7, 30, 100 days)
  - [ ] Show XP earned today
  - [ ] Encourage message khi goal not met
  - [ ] Celebration animation khi goal achieved
- **Estimated Hours**: 2
- **DD Reference**: `09-ui-specifications.md#home`

---

### Task 6: Implement Navigation

- **ID**: WP-FE-007-T006
- **Type**: feature
- **Description**: Implement navigation từ Home đến các screens khác
- **Files to Modify**:
  - `lib/core/routing/app_router.dart`
  - `lib/features/home/presentation/screens/home_screen.dart`
- **Routes to Add**:
  | Route | Destination |
  | ------------------------ | ------------------------------ |
  | /home | HomeScreen |
  | /conversation/new | ConversationSetupScreen |
  | /conversation/:id | ConversationScreen |
  | /conversation/:id/summary| ConversationSummaryScreen |
  | /scenarios | ScenarioListScreen |
- **Implementation Details**:
  ```dart
  // app_router.dart additions
  GoRoute(
    path: '/home',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/conversation/new',
    builder: (context, state) {
      final mode = state.queryParams['mode'];
      return ConversationSetupScreen(mode: mode);
    },
  ),
  ```
- **Acceptance Criteria**:
  - [ ] Quick action cards navigate correctly
  - [ ] Recent conversation tap goes to summary
  - [ ] Settings icon goes to settings screen
  - [ ] Bottom navigation bar với Home, Progress, Profile tabs
  - [ ] Deep linking support cho conversation routes
- **Estimated Hours**: 1.5
- **DD Reference**: `09-ui-specifications.md`

---

## Task Summary

| Task ID        | Name                          | Type    | Hours    | Status           |
| -------------- | ----------------------------- | ------- | -------- | ---------------- |
| WP-FE-007-T001 | Create Home Feature Structure | setup   | 1        | ✅ (2026-01-07)  |
| WP-FE-007-T002 | Implement Home Screen Layout  | feature | 3        | ✅ (2026-01-07)  |
| WP-FE-007-T003 | Create Quick Action Cards     | feature | 1.5      | ✅ (2026-01-07)  |
| WP-FE-007-T004 | Create Recent Conversations   | feature | 1.5      | ✅ (2026-01-07)  |
| WP-FE-007-T005 | Create Daily Progress Widget  | feature | 2        | ✅ (2026-01-07)  |
| WP-FE-007-T006 | Implement Navigation          | feature | 1.5      | ✅ (2026-01-07)  |
| **Total**      |                               |         | **10.5** | **✅ COMPLETED** |

---

_Back to: [\_phase-3.md](./_phase-3.md)_
