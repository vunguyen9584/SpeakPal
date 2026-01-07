# WP-FE-015: Direct Translation Screen (Frontend)

> 📦 Work Package: Direct Translation Practice Screen
> 📅 Estimated: 3 days (24 hours)
> 🔗 Dependencies: WP-FE-008 (Conversation UI)
> 📚 DD Reference: `09-ui-specifications/translation-screens.md`, `06-component-design/translation-01.md`

---

## 📊 Overview

| Metric     | Value                       |
| ---------- | --------------------------- |
| Tasks      | 6                           |
| Est. Hours | 24                          |
| UC         | UC-034 (ダイレクト翻訳練習) |
| Screens    | 1 main + 3 modals           |

---

## 📋 Task List

| Task ID | Task Name                           | Type    | Hours | Status |
| ------- | ----------------------------------- | ------- | ----- | ------ |
| P5-T025 | Create Translation Screen Layout    | feature | 4     | ⬜     |
| P5-T026 | Implement Topic Selection           | feature | 3     | ⬜     |
| P5-T027 | Implement Voice Recording Component | feature | 6     | ⬜     |
| P5-T028 | Implement Score Display             | feature | 4     | ⬜     |
| P5-T029 | Create Translation API Integration  | feature | 4     | ⬜     |
| P5-T030 | Translation Screen Widget Tests     | test    | 3     | ⬜     |

---

## 🎯 Task Details

### P5-T025: Create Translation Screen Layout

**Type:** feature
**Est. Hours:** 4
**DD Ref:** `09-ui-specifications/translation-screens.md#direct`

---

#### Description

Tạo main layout cho Direct Translation screen với header (daily progress), topic selector, question display area, recording button, và result display.

#### Files

| Action | Path                                                              |
| ------ | ----------------------------------------------------------------- |
| Create | `lib/features/translation/screens/direct_translation_screen.dart` |
| Create | `lib/features/translation/widgets/translation_header.dart`        |
| Create | `lib/features/translation/widgets/question_card.dart`             |

#### UI Components

```dart
DirectTranslationScreen
├── TranslationHeader
│   ├── DailyProgress (completed/limit)
│   └── TopicDropdown
├── QuestionCard
│   ├── SourceLanguageLabel ("日本語")
│   ├── SourceTextDisplay
│   ├── DifficultyIndicator
│   └── GrammarPointsTags
├── RecordingButton (center, large)
├── Timer (countdown 30s)
└── ResultSheet (bottom sheet)
```

#### Acceptance Criteria

- [ ] Screen navigable from main menu
- [ ] Header shows daily progress (X/10)
- [ ] Question card displays Japanese text clearly
- [ ] Large, accessible recording button
- [ ] Responsive layout for various screen sizes
- [ ] Dark mode support

---

### P5-T026: Implement Topic Selection

**Type:** feature
**Est. Hours:** 3
**DD Ref:** `09-ui-specifications/translation-screens.md#topic-selector`

---

#### Description

Implement topic dropdown với 5 topics: Daily, Business, Travel, News, Entertainment. Persist last selected topic.

#### Topics

```dart
enum TranslationTopic {
  daily('日常会話', 'daily'),
  business('ビジネス', 'business'),
  travel('旅行', 'travel'),
  news('ニュース', 'news'),
  entertainment('エンタメ', 'entertainment');

  final String displayName;
  final String value;
  const TranslationTopic(this.displayName, this.value);
}
```

#### Files

| Action | Path                                                     |
| ------ | -------------------------------------------------------- |
| Create | `lib/features/translation/widgets/topic_selector.dart`   |
| Create | `lib/features/translation/providers/topic_provider.dart` |

#### Acceptance Criteria

- [ ] Dropdown với 5 topic options
- [ ] Selected topic persisted via SharedPreferences
- [ ] Topic change triggers new question fetch
- [ ] Visual indicator for selected topic
- [ ] Accessible with screen readers

---

### P5-T027: Implement Voice Recording Component

**Type:** feature
**Est. Hours:** 6
**DD Ref:** `06-component-design/translation-01.md#voice-input`

---

#### Description

Implement voice recording với microphone permission, audio capture, timer display (30s countdown), và waveform visualization.

#### Files

| Action | Path                                                         |
| ------ | ------------------------------------------------------------ |
| Create | `lib/features/translation/widgets/voice_recorder.dart`       |
| Create | `lib/features/translation/providers/recording_provider.dart` |

#### Features

```dart
class VoiceRecorder extends ConsumerStatefulWidget {
  // States: idle, permission_denied, recording, processing
  // Timer: 30 second countdown
  // Waveform: real-time audio level visualization
  // Auto-stop when timer reaches 0
}
```

#### Packages Required

- `flutter_sound` for audio recording
- `permission_handler` for microphone permission
- `audio_waveforms` for visualization

#### Acceptance Criteria

- [ ] Request microphone permission on first use
- [ ] Large animated recording button (press to start/stop)
- [ ] 30-second countdown timer display
- [ ] Real-time audio waveform visualization
- [ ] Auto-submit when timer ends
- [ ] Error handling for permission denied
- [ ] Audio saved in webm/mp3 format

---

### P5-T028: Implement Score Display

**Type:** feature
**Est. Hours:** 4
**DD Ref:** `09-ui-specifications/translation-screens.md#result`

---

#### Description

Implement result display với total score, breakdown (grammar/vocab/speed), model answer, feedback, và XP earned animation.

#### Files

| Action | Path                                                             |
| ------ | ---------------------------------------------------------------- |
| Create | `lib/features/translation/widgets/translation_result_sheet.dart` |
| Create | `lib/features/translation/widgets/score_breakdown.dart`          |
| Create | `lib/features/translation/widgets/feedback_card.dart`            |

#### UI Components

```dart
TranslationResultSheet
├── ScoreCircle (animated, 0-100)
├── ScoreBreakdown
│   ├── GrammarScore (40%)
│   ├── VocabScore (30%)
│   └── SpeedScore (30%)
├── UserAnswerDisplay
├── ModelAnswerDisplay (expandable)
├── FeedbackCard
│   ├── GoodPoints (green chips)
│   └── Improvements (orange chips)
├── XPAnimation (+20 XP, streak bonus if any)
└── ActionButtons
    ├── TryAgain
    └── NextQuestion
```

#### Acceptance Criteria

- [ ] Animated score reveal (counting up)
- [ ] Color-coded breakdown (green/yellow/red)
- [ ] Model answer expandable/collapsible
- [ ] Feedback displayed as readable chips
- [ ] XP earned với confetti animation for 80+
- [ ] Next question button fetches new question

---

### P5-T029: Create Translation API Integration

**Type:** feature
**Est. Hours:** 4
**DD Ref:** `08-api-design/translation-apis.md`

---

#### Description

Integrate với backend APIs: GET /questions, POST /answers. Handle loading states, error states, và caching.

#### Files

| Action | Path                                                           |
| ------ | -------------------------------------------------------------- |
| Create | `lib/features/translation/data/translation_repository.dart`    |
| Create | `lib/features/translation/providers/translation_provider.dart` |

#### Repository Methods

```dart
class TranslationRepository {
  Future<TranslationQuestion> getQuestion(String topic, {String? level});
  Future<TranslationResult> submitAnswer({
    required String questionId,
    required Uint8List audioData,
    required double responseTimeSec,
  });
}
```

#### State Management (Riverpod)

```dart
// Question state
final translationQuestionProvider = FutureProvider.autoDispose
  .family<TranslationQuestion, String>((ref, topic) async {
    return ref.read(translationRepositoryProvider).getQuestion(topic);
  });

// Answer submission
final submitAnswerProvider = FutureProvider.autoDispose
  .family<TranslationResult, AnswerParams>((ref, params) async {
    return ref.read(translationRepositoryProvider).submitAnswer(
      questionId: params.questionId,
      audioData: params.audioData,
      responseTimeSec: params.responseTimeSec,
    );
  });
```

#### Acceptance Criteria

- [ ] Repository handles API calls
- [ ] Proper error handling với user-friendly messages
- [ ] Loading states displayed
- [ ] Retry mechanism for network errors
- [ ] Audio multipart upload working
- [ ] Response mapped to UI models

---

### P5-T030: Translation Screen Widget Tests

**Type:** test
**Est. Hours:** 3

---

#### Description

Widget tests cho Translation screen components.

#### Test Cases

- Topic selection changes
- Recording button states
- Timer countdown
- Score display rendering
- Error state handling

#### Acceptance Criteria

- [ ] ≥80% widget coverage
- [ ] Golden tests for UI consistency
- [ ] Mock API responses
- [ ] Accessibility tests

---

## 📊 Phase Progress

| Task ID | Status     | Completed |
| ------- | ---------- | --------- |
| P5-T025 | ⬜ Pending | -         |
| P5-T026 | ⬜ Pending | -         |
| P5-T027 | ⬜ Pending | -         |
| P5-T028 | ⬜ Pending | -         |
| P5-T029 | ⬜ Pending | -         |
| P5-T030 | ⬜ Pending | -         |

**Progress: 0/6 (0%)**

---

_Created: 2026-01-07_
