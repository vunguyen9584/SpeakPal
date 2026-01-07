# WP-FE-018: Shadowing Practice Screen (Frontend)

> 📦 Work Package: Shadowing Practice Screen
> 📅 Estimated: 3 days (24 hours)
> 🔗 Dependencies: WP-FE-015 (Direct Translation Screen)
> 📚 DD Reference: `09-ui-specifications/translation-screens.md`, `06-component-design/translation-02.md#uc-038`

---

## 📊 Overview

| Metric     | Value                                      |
| ---------- | ------------------------------------------ |
| Tasks      | 7                                          |
| Est. Hours | 24                                         |
| UC         | UC-038 (シャドーイング練習)                |
| Screens    | Content Library + Practice Screen + Result |

---

## 📋 Task List

| Task ID | Task Name                         | Type    | Hours | Status |
| ------- | --------------------------------- | ------- | ----- | ------ |
| P5-T042 | Create Content Library Screen     | feature | 4     | ⬜     |
| P5-T043 | Implement Content Player          | feature | 5     | ⬜     |
| P5-T044 | Implement Synchronized Recording  | feature | 5     | ⬜     |
| P5-T045 | Implement Analysis Result Display | feature | 4     | ⬜     |
| P5-T046 | Create Speed Control Component    | feature | 2     | ⬜     |
| P5-T047 | Create Shadowing API Integration  | feature | 2     | ⬜     |
| P5-T048 | Shadowing Widget Tests            | test    | 2     | ⬜     |

---

## 🎯 Task Details

### P5-T042: Create Content Library Screen

**Type:** feature
**Est. Hours:** 4
**DD Ref:** `09-ui-specifications/translation-screens.md#shadowing-library`

---

#### Description

Content library screen với filtering by type (Conversation, News, Speech, Podcast), level, và duration. Premium content marked with lock for free users.

#### UI Components

```dart
ShadowingLibraryScreen
├── Header ("シャドーイング")
├── FilterBar
│   ├── TypeFilter (chips)
│   ├── LevelFilter (dropdown)
│   └── DurationFilter (slider)
├── ContentGrid/List
│   └── ContentCard × N
│       ├── Thumbnail
│       ├── Title
│       ├── Duration
│       ├── Level Badge
│       ├── ContentType Icon
│       └── LockOverlay (if premium & free user)
└── PaginationLoader
```

#### Acceptance Criteria

- [ ] Filter by type, level, duration
- [ ] Premium content locked for free users
- [ ] Pagination (infinite scroll)
- [ ] Grid/List toggle
- [ ] Thumbnail loading với placeholder

---

### P5-T043: Implement Content Player

**Type:** feature
**Est. Hours:** 5
**DD Ref:** `09-ui-specifications/translation-screens.md#shadowing-player`

---

#### Description

Audio player với synchronized transcript display. Current word/phrase highlighted as audio plays. Speed control (0.75x, 1.0x, 1.25x).

#### UI Components

```dart
ShadowingPlayerScreen
├── AudioPlayerBar
│   ├── PlayPauseButton
│   ├── ProgressSlider
│   ├── TimeDisplay (0:15 / 1:30)
│   └── SpeedSelector
├── TranscriptDisplay
│   ├── CurrentPhrase (highlighted, large)
│   ├── NextPhrase (faded)
│   └── ScrollingTranscript
├── ActionButtons
│   ├── RestartButton
│   ├── StartPracticeButton
│   └── BackButton
└── PracticeOverlay (during recording)
```

#### Audio Features

- Streaming audio playback
- Precise timestamp synchronization
- Speed adjustment (0.75x, 1.0x, 1.25x)
- Seek to timestamp on tap

#### Packages

- `just_audio` for playback
- `audio_session` for audio focus

#### Acceptance Criteria

- [ ] Audio plays with progress bar
- [ ] Transcript synchronized with audio
- [ ] Current phrase highlighted
- [ ] Speed control works
- [ ] Seek by tapping transcript

---

### P5-T044: Implement Synchronized Recording

**Type:** feature
**Est. Hours:** 5
**DD Ref:** `06-component-design/translation-02.md#shadowing-recording`

---

#### Description

Simultaneous playback and recording for shadowing practice. User hears model audio while their voice is recorded for analysis.

#### Technical Challenges

```dart
class ShadowingRecorder {
  // Play model audio through speaker
  final AudioPlayer modelPlayer;

  // Record user voice simultaneously
  final FlutterSoundRecorder recorder;

  // Avoid feedback loop
  bool useHeadphones = true;

  Future<void> startShadowing() async {
    // 1. Check headphone status
    // 2. Start model playback
    // 3. Start recording
    // 4. Sync timestamps
  }

  Future<Uint8List> stopAndGetRecording() async {
    // 1. Stop playback
    // 2. Stop recording
    // 3. Return audio buffer
  }
}
```

#### Headphone Detection

```dart
// Recommend headphones to avoid audio feedback
if (!await HeadphoneDetector.isHeadphonesConnected()) {
  showDialog(
    title: 'ヘッドフォンを使用してください',
    message: 'より良い録音品質のため、ヘッドフォンの使用を推奨します。',
  );
}
```

#### Acceptance Criteria

- [ ] Simultaneous playback and recording
- [ ] Headphone recommendation dialog
- [ ] Visual indicator when recording
- [ ] Audio saved with correct timing
- [ ] No audio feedback/echo issues

---

### P5-T045: Implement Analysis Result Display

**Type:** feature
**Est. Hours:** 4
**DD Ref:** `09-ui-specifications/translation-screens.md#shadowing-result`

---

#### Description

Display detailed shadowing analysis: following score, pronunciation score, rhythm score, completeness, weak segments với replay options.

#### UI Components

```dart
ShadowingResultScreen
├── OverallScore (large circle, animated)
├── ScoreBreakdown
│   ├── FollowingScore (20%) - timing accuracy
│   ├── PronunciationScore (40%) - pronunciation quality
│   ├── RhythmScore (20%) - rhythm matching
│   └── CompletenessScore (20%) - words completed
├── WeakSegmentsSection
│   ├── SectionTitle ("苦手なパート")
│   └── WeakSegmentCard × N
│       ├── TimeRange (0:15 - 0:18)
│       ├── Text
│       ├── Issue (発音 / タイミング / スキップ)
│       ├── PlayModelButton
│       └── PlayUserButton
├── FeedbackSection
│   ├── GoodPoints
│   └── Improvements
├── XPDisplay
└── ActionButtons
    ├── RetryButton
    ├── TryDifferentContentButton
    └── ShareButton
```

#### Weak Segments Interaction

- Tap to play that segment from model audio
- Compare with user's recording
- Highlight issue type (pronunciation/timing/skipped)

#### Acceptance Criteria

- [ ] All 4 score types displayed
- [ ] Weak segments identified và interactive
- [ ] Playback comparison (model vs user)
- [ ] Clear improvement suggestions
- [ ] XP awarded animation

---

### P5-T046: Create Speed Control Component

**Type:** feature
**Est. Hours:** 2

---

#### Description

Reusable speed control component với 3 options: slow (0.75x), normal (1.0x), fast (1.25x).

#### UI

```dart
SpeedSelector(
  currentSpeed: 1.0,
  options: [0.75, 1.0, 1.25],
  labels: ['Slow', 'Normal', 'Fast'],
  onSpeedChanged: (speed) => ...,
)
```

#### Acceptance Criteria

- [ ] 3-option selector
- [ ] Current speed highlighted
- [ ] Smooth transition between speeds
- [ ] Reusable component

---

### P5-T047: Create Shadowing API Integration

**Type:** feature
**Est. Hours:** 2

---

#### Description

Integrate với Shadowing APIs.

#### Repository Methods

```dart
class ShadowingRepository {
  Future<PaginatedList<ShadowingContent>> getContents(ContentQuery query);
  Future<ShadowingContentDetail> getContentById(String id);
  Future<ShadowingSession> startSession(String contentId, double speed);
  Future<ShadowingResult> analyzeRecording(String sessionId, Uint8List audio);
}
```

#### Acceptance Criteria

- [ ] Content listing với pagination
- [ ] Content detail with audio URL
- [ ] Large audio upload support
- [ ] Error handling for premium restrictions

---

### P5-T048: Shadowing Widget Tests

**Type:** test
**Est. Hours:** 2

---

#### Description

Widget tests cho Shadowing screens.

#### Acceptance Criteria

- [ ] Content library filtering tests
- [ ] Player controls tests
- [ ] Result display tests
- [ ] Speed control tests

---

## 📊 Phase Progress

| Task ID | Status     | Completed |
| ------- | ---------- | --------- |
| P5-T042 | ⬜ Pending | -         |
| P5-T043 | ⬜ Pending | -         |
| P5-T044 | ⬜ Pending | -         |
| P5-T045 | ⬜ Pending | -         |
| P5-T046 | ⬜ Pending | -         |
| P5-T047 | ⬜ Pending | -         |
| P5-T048 | ⬜ Pending | -         |

**Progress: 0/7 (0%)**

---

_Created: 2026-01-07_
