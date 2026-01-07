# WP-FE-017: Quick Response Screens (Frontend)

> 📦 Work Package: Quick Response Practice Screens
> 📅 Estimated: 3 days (24 hours)
> 🔗 Dependencies: WP-FE-015 (Direct Translation Screen)
> 📚 DD Reference: `09-ui-specifications/translation-screens.md`, `06-component-design/translation-02.md#uc036-037`

---

## 📊 Overview

| Metric     | Value                                             |
| ---------- | ------------------------------------------------- |
| Tasks      | 6                                                 |
| Est. Hours | 24                                                |
| UCs        | UC-036 (Word Association), UC-037 (Instant Drill) |
| Screens    | 2 (Word Association, Instant Drill)               |

---

## 📋 Task List

| Task ID | Task Name                             | Type    | Hours | Status |
| ------- | ------------------------------------- | ------- | ----- | ------ |
| P5-T036 | Create Quick Response Menu Screen     | feature | 2     | ⬜     |
| P5-T037 | Implement Word Association Screen     | feature | 6     | ⬜     |
| P5-T038 | Implement Instant Drill Screen        | feature | 6     | ⬜     |
| P5-T039 | Implement Game-like Animations        | feature | 4     | ⬜     |
| P5-T040 | Create Quick Response API Integration | feature | 4     | ⬜     |
| P5-T041 | Quick Response Widget Tests           | test    | 2     | ⬜     |

---

## 🎯 Task Details

### P5-T036: Create Quick Response Menu Screen

**Type:** feature
**Est. Hours:** 2

---

#### Description

Menu screen cho Quick Response với 2 game modes: Word Association và Instant Drill.

#### UI Components

```dart
QuickResponseMenuScreen
├── Header ("クイックレスポンス")
├── DailyProgressBanner
├── GameModeCard × 2
│   ├── WordAssociationCard
│   │   ├── Icon
│   │   ├── Title ("ワード連想")
│   │   ├── Description
│   │   ├── HighScore
│   │   └── PlayButton
│   └── InstantDrillCard
│       ├── Icon
│       ├── Title ("瞬間応答")
│       ├── Description
│       ├── BestTime
│       └── PlayButton
└── TipsSection
```

#### Acceptance Criteria

- [ ] 2 game mode cards displayed
- [ ] High scores shown
- [ ] Daily free plays remaining
- [ ] Smooth navigation to game screens

---

### P5-T037: Implement Word Association Screen

**Type:** feature
**Est. Hours:** 6
**DD Ref:** `06-component-design/translation-02.md#uc-036`

---

#### Description

60-second word association challenge. Display keyword, user speaks related word, real-time scoring với chain multiplier.

#### UI Components

```dart
WordAssociationScreen
├── SessionHeader
│   ├── Timer (60s countdown, animated)
│   ├── Score (animated on update)
│   └── ChainIndicator (× 1.5, × 2.0)
├── KeywordCard
│   ├── CurrentKeyword (large, centered)
│   └── PreviousKeyword (small, faded)
├── ListenButton (tap to hear keyword)
├── VoiceInputArea
│   ├── MicButton (always-on recording)
│   └── WaveformDisplay
├── FeedbackOverlay
│   ├── CorrectAnimation (✓ green)
│   └── IncorrectAnimation (✗ red)
└── ResultSheet (on time up)
    ├── FinalScore
    ├── CorrectCount
    ├── MaxChain
    ├── HighScoreIndicator (new record?)
    └── XPEarned
```

#### Game Flow

```
1. Countdown 3-2-1-GO!
2. Display first keyword
3. User speaks related word
4. Immediate feedback (✓/✗)
5. Next keyword appears
6. Repeat until 60s ends
7. Show final result
```

#### Acceptance Criteria

- [ ] 60-second countdown timer
- [ ] Continuous voice recognition
- [ ] Instant feedback animation
- [ ] Chain multiplier display (1.5x, 2.0x)
- [ ] High score tracking
- [ ] Celebratory animation for new record

---

### P5-T038: Implement Instant Drill Screen

**Type:** feature
**Est. Hours:** 6
**DD Ref:** `06-component-design/translation-02.md#uc-037`

---

#### Description

10-question drill với AI-generated questions. Each question has 10-second limit. Question displayed as text + audio (TTS).

#### UI Components

```dart
InstantDrillScreen
├── DrillHeader
│   ├── ProgressBar (1/10, 2/10, ...)
│   ├── QuestionTimer (10s countdown)
│   └── CurrentScore
├── QuestionCard
│   ├── QuestionText (displayed)
│   ├── PlayAudioButton (TTS)
│   └── QuestionNumber
├── VoiceInputArea
├── AnswerFeedback (after each answer)
│   ├── UserAnswer
│   ├── Score (speed/accuracy/naturalness)
│   └── NextQuestionButton
└── DrillResultScreen
    ├── AverageScore
    ├── QuestionByQuestionBreakdown
    ├── WeakpointAnalysis
    └── XPEarned
```

#### Acceptance Criteria

- [ ] 10 fixed questions per session
- [ ] Audio playback for each question
- [ ] 10-second timer per question
- [ ] Score breakdown after each answer
- [ ] Weakpoint analysis at end (if 3+ sessions)
- [ ] XP bonus for avg 80+

---

### P5-T039: Implement Game-like Animations

**Type:** feature
**Est. Hours:** 4

---

#### Description

Add engaging game-like animations: countdown, score pop, chain multiplier effects, correct/incorrect feedback, confetti for high scores.

#### Animations

```dart
// Countdown animation (3-2-1-GO!)
class CountdownAnimation extends StatefulWidget { ... }

// Score pop when points earned
class ScorePopAnimation extends StatefulWidget {
  final int points;
  final double multiplier;
}

// Chain indicator glow effect
class ChainIndicator extends StatefulWidget {
  final int chain;
  // Glows more intensely at higher chains
}

// Correct/Incorrect overlay
class AnswerFeedbackOverlay extends StatefulWidget {
  final bool correct;
  // Slide in, hold, slide out
}
```

#### Packages

- `flutter_animate` for declarative animations
- `confetti_widget` for celebrations

#### Acceptance Criteria

- [ ] Smooth 3-2-1-GO countdown
- [ ] Score points pop up animation
- [ ] Chain multiplier glow effect
- [ ] Quick feedback overlays
- [ ] Confetti for high scores
- [ ] Sound effects (optional)

---

### P5-T040: Create Quick Response API Integration

**Type:** feature
**Est. Hours:** 4

---

#### Description

Integrate với 7 Quick Response APIs for both game modes.

#### Repository Methods

```dart
class QuickResponseRepository {
  // Word Association
  Future<WordAssociationSession> startWordAssociation({String? difficulty});
  Future<WordAssociationAnswer> submitWordAnswer(String sessionId, Uint8List audio);
  Future<WordAssociationResult> endWordAssociation(String sessionId);

  // Instant Drill
  Future<InstantDrillSession> startInstantDrill(String category);
  Future<DrillQuestion> getNextQuestion(String sessionId);
  Future<DrillAnswer> submitDrillAnswer(String sessionId, Uint8List audio);
  Future<InstantDrillResult> endInstantDrill(String sessionId);
}
```

#### Acceptance Criteria

- [ ] All 7 API methods implemented
- [ ] Session management
- [ ] Audio streaming for continuous recognition
- [ ] Error handling for session expiry
- [ ] Local caching of keywords (Word Association)

---

### P5-T041: Quick Response Widget Tests

**Type:** test
**Est. Hours:** 2

---

#### Description

Widget tests cho game screens.

#### Acceptance Criteria

- [ ] Timer countdown tests
- [ ] Score calculation tests
- [ ] Animation trigger tests
- [ ] State management tests

---

## 📊 Phase Progress

| Task ID | Status     | Completed |
| ------- | ---------- | --------- |
| P5-T036 | ⬜ Pending | -         |
| P5-T037 | ⬜ Pending | -         |
| P5-T038 | ⬜ Pending | -         |
| P5-T039 | ⬜ Pending | -         |
| P5-T040 | ⬜ Pending | -         |
| P5-T041 | ⬜ Pending | -         |

**Progress: 0/6 (0%)**

---

_Created: 2026-01-07_
