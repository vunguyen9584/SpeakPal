# WP-FE-016: Intent Translation Screen (Frontend)

> 📦 Work Package: Intent Translation Practice Screen
> 📅 Estimated: 2 days (16 hours)
> 🔗 Dependencies: WP-FE-015 (Direct Translation Screen)
> 📚 DD Reference: `09-ui-specifications/translation-screens.md`, `06-component-design/translation-01.md#uc-035`

---

## 📊 Overview

| Metric     | Value                     |
| ---------- | ------------------------- |
| Tasks      | 5                         |
| Est. Hours | 16                        |
| UC         | UC-035 (高度意図翻訳練習) |
| Level Req  | Intermediate+             |

---

## 📋 Task List

| Task ID | Task Name                      | Type    | Hours | Status |
| ------- | ------------------------------ | ------- | ----- | ------ |
| P5-T031 | Create Intent Screen Layout    | feature | 3     | ⬜     |
| P5-T032 | Implement Category Selection   | feature | 2     | ⬜     |
| P5-T033 | Implement Situation Display    | feature | 3     | ⬜     |
| P5-T034 | Implement Alternatives Display | feature | 4     | ⬜     |
| P5-T035 | Create Intent API Integration  | feature | 4     | ⬜     |

---

## 🎯 Task Details

### P5-T031: Create Intent Screen Layout

**Type:** feature
**Est. Hours:** 3
**DD Ref:** `09-ui-specifications/translation-screens.md#intent`

---

#### Description

Tạo layout cho Intent Translation screen. Reuse components từ Direct Translation nhưng thay đổi UI để display situation/intent thay vì fixed text.

#### UI Components

```dart
IntentTranslationScreen
├── LevelRestrictionBanner (if Beginner)
├── CategorySelector
├── IntentCard
│   ├── SituationLabel ("シチュエーション")
│   ├── IntentDescription (Japanese)
│   ├── DifficultyBadge
│   └── HintButton (optional)
├── VoiceRecorder (reuse from WP-FE-015)
└── IntentResultSheet
    ├── UserExpression
    ├── ScoreBreakdown (intent/naturalness/vocab)
    ├── AlternativeExpressions (3+ options)
    └── XPDisplay
```

#### Acceptance Criteria

- [ ] Level restriction banner for Beginner users
- [ ] Intent/situation displayed prominently
- [ ] Reuses VoiceRecorder component
- [ ] Different result layout for alternatives

---

### P5-T032: Implement Category Selection

**Type:** feature
**Est. Hours:** 2
**DD Ref:** `08-api-design/translation-apis.md#intent-categories`

---

#### Description

Implement category selector với 5 categories: Greeting, Daily, Business, Emotion, Request.

#### Categories

```dart
enum IntentCategory {
  greeting('挨拶', 'greeting', Icons.waving_hand),
  daily('日常', 'daily', Icons.home),
  business('ビジネス', 'business', Icons.work),
  emotion('感情', 'emotion', Icons.emoji_emotions),
  request('依頼', 'request', Icons.handshake);
}
```

#### Acceptance Criteria

- [ ] Chip-based category selector
- [ ] Icons for each category
- [ ] Persist last selected
- [ ] Category change triggers new question

---

### P5-T033: Implement Situation Display

**Type:** feature
**Est. Hours:** 3

---

#### Description

Display the situation/intent description in an engaging card format with visual context.

#### Acceptance Criteria

- [ ] Card với clear situation text
- [ ] Optional hint toggle
- [ ] Difficulty indicator
- [ ] Smooth transitions

---

### P5-T034: Implement Alternatives Display

**Type:** feature
**Est. Hours:** 4

---

#### Description

Display 3+ alternative expressions after evaluation. Users can tap to hear pronunciation.

#### UI Components

```dart
AlternativesSection
├── SectionTitle ("他の表現例")
├── AlternativeCard × 3+
│   ├── ExpressionText
│   ├── SpeakButton (TTS)
│   └── CopyButton
└── ShowMoreButton (if >3)
```

#### Acceptance Criteria

- [ ] Minimum 3 alternatives displayed
- [ ] TTS playback for each
- [ ] Copy to clipboard
- [ ] Expandable for more

---

### P5-T035: Create Intent API Integration

**Type:** feature
**Est. Hours:** 4

---

#### Description

Integrate với GET /intent-questions và POST /intent-answers APIs.

#### Acceptance Criteria

- [ ] Repository methods implemented
- [ ] Level check before API call
- [ ] Proper error handling for 403 (level restriction)
- [ ] Response mapped correctly

---

## 📊 Phase Progress

| Task ID | Status     | Completed |
| ------- | ---------- | --------- |
| P5-T031 | ⬜ Pending | -         |
| P5-T032 | ⬜ Pending | -         |
| P5-T033 | ⬜ Pending | -         |
| P5-T034 | ⬜ Pending | -         |
| P5-T035 | ⬜ Pending | -         |

**Progress: 0/5 (0%)**

---

_Created: 2026-01-07_
