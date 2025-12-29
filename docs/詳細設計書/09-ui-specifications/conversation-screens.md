# 9.4. Conversation Screens (SCR-006 ~ SCR-008)

## SCR-007: 会話画面

### 画面情報

| 項目    | 内容                   |
| ------- | ---------------------- |
| 画面 ID | SCR-007                |
| 画面名  | 会話画面               |
| URL     | /conversation/:id      |
| 認証    | Auth                   |
| 関連 UC | UC-003, UC-006, UC-009 |

### ワイヤーフレーム

```
┌────────────────────────────────────────┐
│ [✕ End]                    [⚙ Settings]│
│                                         │
│  ┌────────────────────────────────┐     │
│  │     AI Persona Avatar          │     │
│  │         😊                      │     │
│  │      "Sarah"                   │     │
│  │  ┌─────────────────────────┐   │     │
│  │  │ 💬 "Hi! How are you     │   │     │
│  │  │     doing today?"       │   │     │
│  │  └─────────────────────────┘   │     │
│  └────────────────────────────────┘     │
│                                         │
│  ╔════════════════════════════════╗     │
│  ║  📝 Real-time Subtitles        ║     │
│  ║  "I'm doing great, thanks..."  ║     │
│  ╚════════════════════════════════╝     │
│                                         │
│  ┌────────────────────────────────┐     │
│  │ 💡 Suggestion                  │     │
│  │ "You could also say:           │     │
│  │  I'm doing well, thank you!"   │     │
│  └────────────────────────────────┘     │
│                                         │
│  ┌────────────────────────────────┐     │
│  │ ⚠️ Correction                  │     │
│  │ "I am go" → "I am going"       │     │
│  │ Grammar: Present continuous    │     │
│  └────────────────────────────────┘     │
│                                         │
│  ┌────────────────────────────────┐     │
│  │           🎙️                   │     │
│  │     Press to speak             │     │
│  │    ━━━━━◉━━━━━ 0:15           │     │
│  └────────────────────────────────┘     │
│                                         │
└────────────────────────────────────────┘
```

### コンポーネント仕様

| ID             | 要素        | 属性             | バリデーション        |
| -------------- | ----------- | ---------------- | --------------------- |
| endButton      | IconButton  | icon: close      | -                     |
| settingsButton | IconButton  | icon: settings   | -                     |
| avatar         | Avatar      | size: 120        | -                     |
| aiText         | TextBubble  | variant: ai      | -                     |
| subtitles      | SubtitleBox | realtime: true   | -                     |
| suggestion     | Card        | variant: info    | collapsible           |
| correction     | Card        | variant: warning | collapsible           |
| micButton      | FAB         | variant: primary | state: idle/recording |
| waveform       | Waveform    | animated: true   | -                     |
| timer          | Timer       | format: mm:ss    | max: 60s              |

### 状態管理

| State        | Type    | Description      |
| ------------ | ------- | ---------------- |
| isRecording  | boolean | 録音中フラグ     |
| isAISpeaking | boolean | AI 応答再生中    |
| currentText  | string  | リアルタイム字幕 |
| corrections  | array   | 訂正リスト       |
| suggestions  | array   | 提案リスト       |
| duration     | number  | 経過時間         |

### イベント

| イベント          | トリガー             | アクション                  |
| ----------------- | -------------------- | --------------------------- |
| onMicPress        | マイクボタン押下     | 録音開始、WS audio_stream   |
| onMicRelease      | マイクボタン離す     | 録音終了、isFinal: true     |
| onInterrupt       | 録音開始時 AI 再生中 | WS interrupt 送信           |
| onCorrectionTap   | 訂正カード押下       | 詳細モーダル表示            |
| onSuggestionTap   | 提案カード押下       | 語彙詳細表示                |
| onEndConversation | End ボタン押下       | 確認ダイアログ → 結果画面へ |

---

## SCR-008: 会話結果画面

### ワイヤーフレーム

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
│  ─────────────────────────────────     │
│  You practiced greetings and small     │
│  talk. Great use of present perfect!   │
│                                         │
│  📚 Vocabulary Learned                 │
│  ─────────────────────────────────     │
│  • accomplish (v.)                     │
│  • figure out (phr.v.)                 │
│                                         │
│  ⚠️ Areas to Improve                  │
│  ─────────────────────────────────     │
│  • Subject-verb agreement              │
│  • Pronunciation of "th" sounds        │
│                                         │
│  ┌────────────────────────────────┐     │
│  │    [ Back to Home ]            │     │
│  └────────────────────────────────┘     │
│  ┌────────────────────────────────┐     │
│  │    [ Practice Again ]          │     │
│  └────────────────────────────────┘     │
│                                         │
└────────────────────────────────────────┘
```

---

← [Auth Screens](./auth-screens.md) | _次: [Progress Screens](./progress-screens.md)_
