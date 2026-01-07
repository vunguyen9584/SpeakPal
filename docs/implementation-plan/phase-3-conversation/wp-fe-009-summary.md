# WP-FE-009: Conversation Summary (Frontend)

## Overview

| Item           | Value                                                                                  |
| -------------- | -------------------------------------------------------------------------------------- |
| ID             | WP-FE-009                                                                              |
| Name           | Conversation Summary                                                                   |
| Description    | Post-conversation summary screen with stats, corrections, vocabulary                   |
| Dependencies   | WP-FE-008 (Conversation Screen)                                                        |
| Estimated Days | 2                                                                                      |
| Total Tasks    | 5                                                                                      |
| DD References  | `09-ui-specifications/conversation-screens.md#SCR-008`, `06-component-design.md#uc017` |

---

## Tasks

### Task 1: Create Summary Screen

- **ID**: WP-FE-009-T001
- **Type**: feature
- **Description**: Create main summary screen layout
- **Files to Create**:
  - `lib/features/conversation/presentation/screens/conversation_summary_screen.dart`
  - `lib/features/conversation/presentation/providers/summary_provider.dart`
- **Wireframe Reference**:
  ```
  ┌────────────────────────────────────────┐
  │              Conversation Complete      │
  │                                         │
  │  ┌────────────────────────────────┐     │
  │  │      🎉 Great job!             │     │
  │  │                                │     │
  │  │  Duration: 8:32                │     │
  │  │  Pronunciation: 85/100         │     │
  │  │  XP Earned: +120               │     │
  │  └────────────────────────────────┘     │
  │                                         │
  │  ┌────────────────────────────────┐     │
  │  │ Level Up! 🎊                   │     │
  │  │ Level 5 → Level 6              │     │
  │  └────────────────────────────────┘     │
  │                                         │
  │  ┌────────────────────────────────┐     │
  │  │ New Badge! 🏅                  │     │
  │  │ "10 Conversations"             │     │
  │  └────────────────────────────────┘     │
  │                                         │
  │  📝 Summary                            │
  │  📚 Vocabulary Learned                 │
  │  ⚠️ Areas to Improve                  │
  │                                         │
  │  [ Back to Home ] [ Practice Again ]   │
  └────────────────────────────────────────┘
  ```
- **Implementation Details**:

  ```dart
  class ConversationSummaryScreen extends ConsumerWidget {
    final String conversationId;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final summary = ref.watch(summaryProvider(conversationId));

      return Scaffold(
        body: summary.when(
          loading: () => LoadingWidget(),
          error: (e, s) => ErrorWidget(error: e),
          data: (data) => SingleChildScrollView(
            child: Column(
              children: [
                ConversationStatsCard(stats: data),
                if (data.levelUp) LevelUpCard(newLevel: data.newLevel),
                if (data.newBadges.isNotEmpty)
                  NewBadgesCard(badges: data.newBadges),
                SummarySection(summary: data.summary),
                VocabularySection(words: data.vocabulary),
                ImprovementSection(corrections: data.corrections),
                ActionButtons(),
              ],
            ),
          ),
        ),
      );
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Display conversation stats (duration, score, XP)
  - [ ] Show level up card nếu level up
  - [ ] Show new badges nếu earned
  - [ ] Summary text section
  - [ ] Vocabulary learned section
  - [ ] Areas to improve section
  - [ ] Action buttons (Home, Practice Again)
  - [ ] Loading và error states
- **Estimated Hours**: 3
- **DD Reference**: `09-ui-specifications/conversation-screens.md#SCR-008`

---

### Task 2: Display Conversation Stats

- **ID**: WP-FE-009-T002
- **Type**: feature
- **Description**: Create stats card với animated numbers và celebrations
- **Files to Create**:
  - `lib/features/conversation/presentation/widgets/conversation_stats_card.dart`
  - `lib/features/conversation/presentation/widgets/animated_counter.dart`
  - `lib/features/conversation/presentation/widgets/score_gauge.dart`
- **Implementation Details**:

  ```dart
  class ConversationStatsCard extends StatelessWidget {
    final ConversationSummary summary;

    @override
    Widget build(BuildContext context) {
      return Card(
        child: Column(
          children: [
            Icon(Icons.celebration, size: 48, color: Colors.amber),
            Text('Great job!', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(
                  icon: Icons.timer,
                  label: 'Duration',
                  value: _formatDuration(summary.durationSeconds),
                ),
                ScoreGauge(
                  score: summary.pronunciationScore,
                  label: 'Pronunciation',
                ),
                StatItem(
                  icon: Icons.star,
                  label: 'XP Earned',
                  value: '+${summary.xpEarned}',
                  animate: true,
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Celebration icon/animation at top
  - [ ] Duration formatted as mm:ss
  - [ ] Pronunciation score với gauge visualization (0-100)
  - [ ] XP earned với count-up animation
  - [ ] Color coding (green >= 80, yellow 60-79, red < 60)
  - [ ] Confetti animation cho high scores (>= 90)
- **Estimated Hours**: 2
- **DD Reference**: `08-api-design/conversation-apis.md#API-203`

---

### Task 3: Display Corrections List

- **ID**: WP-FE-009-T003
- **Type**: feature
- **Description**: Display all corrections from conversation với detailed explanations
- **Files to Create**:
  - `lib/features/conversation/presentation/widgets/corrections_section.dart`
  - `lib/features/conversation/presentation/widgets/correction_list_item.dart`
- **Implementation Details**:

  ```dart
  class CorrectionsSection extends StatelessWidget {
    final List<CorrectionSummary> corrections;

    @override
    Widget build(BuildContext context) {
      // Group corrections by type
      final grouped = corrections.groupBy((c) => c.type);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.edit,
            title: 'Areas to Improve',
            count: corrections.length,
          ),
          if (grouped['grammar'] != null)
            CorrectionTypeGroup(
              title: 'Grammar',
              icon: Icons.abc,
              corrections: grouped['grammar']!,
            ),
          if (grouped['vocabulary'] != null)
            CorrectionTypeGroup(
              title: 'Vocabulary',
              icon: Icons.book,
              corrections: grouped['vocabulary']!,
            ),
          if (grouped['pronunciation'] != null)
            CorrectionTypeGroup(
              title: 'Pronunciation',
              icon: Icons.mic,
              corrections: grouped['pronunciation']!,
            ),
        ],
      );
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Group corrections by type (grammar, vocabulary, pronunciation)
  - [ ] Each correction shows original → corrected
  - [ ] Tap để expand và show full explanation
  - [ ] Japanese explanation available
  - [ ] Count badge per category
  - [ ] Encouragement message nếu ít corrections
  - [ ] Empty state nếu no corrections ("Perfect conversation!")
- **Estimated Hours**: 2
- **DD Reference**: `06-component-design.md#uc017`

---

### Task 4: Display New Vocabulary

- **ID**: WP-FE-009-T004
- **Type**: feature
- **Description**: Display vocabulary learned với option to save to word list
- **Files to Create**:
  - `lib/features/conversation/presentation/widgets/vocabulary_section.dart`
  - `lib/features/conversation/presentation/widgets/vocabulary_card.dart`
- **Implementation Details**:

  ```dart
  class VocabularySection extends StatelessWidget {
    final List<VocabularyItem> words;

    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.menu_book,
            title: 'New Vocabulary',
            count: words.length,
            action: TextButton(
              onPressed: () => _saveAllToWordList(),
              child: Text('Save All'),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: words.length,
            itemBuilder: (context, index) => VocabularyCard(
              word: words[index],
              onSave: () => _saveToWordList(words[index]),
            ),
          ),
        ],
      );
    }
  }

  class VocabularyCard extends StatelessWidget {
    final VocabularyItem word;

    @override
    Widget build(BuildContext context) {
      return Card(
        child: ListTile(
          title: Text(word.word),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(word.pronunciation, style: TextStyle(fontStyle: FontStyle.italic)),
              Text(word.meaning),
            ],
          ),
          trailing: IconButton(
            icon: Icon(word.saved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: onSave,
          ),
        ),
      );
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] List vocabulary với word, pronunciation, meaning
  - [ ] Part of speech indicator (noun, verb, etc.)
  - [ ] Example sentence
  - [ ] Save to word list button (individual và save all)
  - [ ] Bookmark icon changes when saved
  - [ ] Tap để hear pronunciation
  - [ ] Empty state nếu no new vocabulary
- **Estimated Hours**: 2
- **DD Reference**: `05-module-design/feedback-module.md`

---

### Task 5: Implement Share/Save Actions

- **ID**: WP-FE-009-T005
- **Type**: feature
- **Description**: Implement share functionality và navigation
- **Files to Create**:
  - `lib/features/conversation/presentation/widgets/summary_actions.dart`
  - `lib/features/conversation/presentation/widgets/share_summary_sheet.dart`
- **Implementation Details**:
  ```dart
  class SummaryActions extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.share),
                    label: Text('Share'),
                    onPressed: () => _showShareSheet(context),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.download),
                    label: Text('Export'),
                    onPressed: () => _exportToPDF(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _navigateToHome(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Back to Home'),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => _practiceAgain(),
              child: Text('Practice Again'),
            ),
          ],
        ),
      );
    }
  }
  ```
- **Share Options**:
  - Share as image (summary card)
  - Share as text (conversation transcript)
  - Export to PDF (full summary with corrections)
- **Acceptance Criteria**:
  - [ ] Share button opens share sheet
  - [ ] Share as image - generate summary image
  - [ ] Share as text - copy/share transcript
  - [ ] Export to PDF - downloadable report
  - [ ] Back to Home button
  - [ ] Practice Again button - start new conversation với same settings
  - [ ] Navigate correctly on both actions
- **Estimated Hours**: 2
- **DD Reference**: `09-ui-specifications/conversation-screens.md`

---

## Task Summary

| Task ID        | Name                         | Type    | Hours  | Status           |
| -------------- | ---------------------------- | ------- | ------ | ---------------- |
| WP-FE-009-T001 | Create Summary Screen        | feature | 3      | ✅ (2026-01-07)  |
| WP-FE-009-T002 | Display Conversation Stats   | feature | 2      | ✅ (2026-01-07)  |
| WP-FE-009-T003 | Display Corrections List     | feature | 2      | ✅ (2026-01-07)  |
| WP-FE-009-T004 | Display New Vocabulary       | feature | 2      | ✅ (2026-01-07)  |
| WP-FE-009-T005 | Implement Share/Save Actions | feature | 2      | ✅ (2026-01-07)  |
| **Total**      |                              |         | **11** | **✅ COMPLETED** |

---

_Back to: [\_phase-3.md](./_phase-3.md)_
