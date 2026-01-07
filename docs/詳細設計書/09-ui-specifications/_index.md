# 9. UI 仕様 - 共通仕様

> 📌 **ENHANCED**: Loading/Error/Empty states, Interaction specifications, Accessibility

---

## 9.1. 概要

### 9.1.1. 画面構成

| 項目         | 数量 |
| ------------ | ---- |
| 画面総数     | 20   |
| 認証系       | 3    |
| メイン系     | 5    |
| 会話系       | 4    |
| 学習系       | 4    |
| ソーシャル系 | 4    |

### 9.1.2. ファイル構成

| セクション | ファイル                                                               | 内容         |
| ---------- | ---------------------------------------------------------------------- | ------------ |
| 9.2        | [Auth Screens](./09-ui-specifications/auth-screens.md)                 | 認証画面詳細 |
| 9.3        | [Conversation Screens](./09-ui-specifications/conversation-screens.md) | 会話画面詳細 |
| 9.4        | [Progress Screens](./09-ui-specifications/progress-screens.md)         | 進捗画面詳細 |

---

## 9.2. Loading States

> 📌 **ENHANCED** (ENH-11): ローディング状態の仕様

### 9.2.1. ローディングタイプ

| タイプ          | 使用場面             | 表示方法                        |
| --------------- | -------------------- | ------------------------------- |
| Full Page       | 初期ロード、認証     | 中央スピナー + 背景オーバーレイ |
| Inline          | ボタン操作中         | ボタン内スピナー                |
| Skeleton        | リスト/カードロード  | グレースケルトン                |
| Progress Bar    | ファイルアップロード | 進捗バー + %表示                |
| Pull to Refresh | リスト更新           | 上部プログレスインジケーター    |

### 9.2.2. ローディング表示タイミング

```
LOADING DISPLAY RULES:
1. API 呼び出し開始から 200ms 経過後にローディング表示
   - 200ms 以内に完了する場合はローディング非表示
   - チラつき防止

2. 最低表示時間: 500ms
   - 500ms 以内に完了してもローディングは 500ms 表示
   - 視覚的安定性

3. タイムアウト: 30秒
   - 30秒経過でエラーメッセージ表示
```

### 9.2.3. スピナー CSS

```css
/* Full Page Spinner */
.loading-overlay {
  position: fixed;
  inset: 0;
  background: rgba(255, 255, 255, 0.9);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.spinner {
  width: 48px;
  height: 48px;
  border: 4px solid #e5e7eb;
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* Skeleton Loading */
.skeleton {
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}
```

---

## 9.3. Error States

> 📌 **ENHANCED** (ENH-11): エラー状態の仕様

### 9.3.1. エラータイプ

| タイプ       | 使用場面               | 表示方法                   |
| ------------ | ---------------------- | -------------------------- |
| Inline Error | フォームバリデーション | フィールド下エラーテキスト |
| Toast Error  | API 一時エラー         | 画面下部トースト (5 秒)    |
| Page Error   | 404, 500 など          | フルページエラー画面       |
| Modal Error  | 重要なエラー確認       | モーダルダイアログ         |
| Banner Error | システム全体エラー     | 画面上部固定バナー         |

### 9.3.2. Inline Error

```html
<!-- フォームフィールドエラー -->
<div class="form-field has-error">
  <label for="email">メールアドレス</label>
  <input
    type="email"
    id="email"
    aria-invalid="true"
    aria-describedby="email-error"
  />
  <span id="email-error" class="error-message" role="alert">
    有効なメールアドレスを入力してください
  </span>
</div>
```

```css
.form-field.has-error input {
  border-color: #ef4444;
  background-color: #fef2f2;
}

.error-message {
  display: block;
  color: #ef4444;
  font-size: 0.875rem;
  margin-top: 0.25rem;
}
```

### 9.3.3. Toast Error

```typescript
// Toast 表示コンポーネント
interface ToastConfig {
  type: "success" | "error" | "warning" | "info";
  message: string;
  duration: number; // ms
  action?: { label: string; onClick: () => void };
}

// 使用例
showToast({
  type: "error",
  message: "保存に失敗しました。もう一度お試しください。",
  duration: 5000,
  action: { label: "再試行", onClick: () => retry() },
});
```

### 9.3.4. Error Page Layout

```
┌────────────────────────────────────────────────────┐
│                                                    │
│              ┌─────────────────────┐              │
│              │     😕 (Icon)        │              │
│              └─────────────────────┘              │
│                                                    │
│         ページが見つかりませんでした               │
│         Error Code: 404                            │
│                                                    │
│    お探しのページは移動または削除された            │
│    可能性があります。                              │
│                                                    │
│              ┌─────────────────────┐              │
│              │   ホームに戻る       │              │
│              └─────────────────────┘              │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 9.4. Empty States

> 📌 **ENHANCED** (ENH-11): 空状態の仕様

### 9.4.1. 空状態タイプ

| 画面/コンポーネント | 空状態メッセージ                    | アクション           |
| ------------------- | ----------------------------------- | -------------------- |
| 会話履歴            | まだ会話がありません                | 最初の会話を始める   |
| 単語帳              | 単語を追加してみましょう            | 単語を追加           |
| バッジ一覧          | バッジを獲得しよう！                | 条件を確認           |
| 通知                | 新しい通知はありません              | -                    |
| 検索結果            | 「{query}」の結果はありませんでした | 別のキーワードで検索 |
| ランキング          | ランキングは週次で更新されます      | -                    |

### 9.4.2. 空状態 Layout

```
┌────────────────────────────────────────────────────┐
│                                                    │
│              ┌─────────────────────┐              │
│              │   📝 (Illustration)  │              │
│              └─────────────────────┘              │
│                                                    │
│           まだ会話がありません                     │
│                                                    │
│    英会話練習を始めて、スキルアップしましょう！    │
│                                                    │
│              ┌─────────────────────┐              │
│              │   会話を始める       │              │
│              └─────────────────────┘              │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 9.5. Interaction Specifications

> 📌 **ENHANCED** (ENH-12): インタラクション仕様

### 9.5.1. Button States

| State    | Visual Change                   | Cursor      |
| -------- | ------------------------------- | ----------- |
| Default  | 通常カラー                      | pointer     |
| Hover    | 背景色 10% 明るく、シャドウ追加 | pointer     |
| Active   | 背景色 10% 暗く                 | pointer     |
| Focus    | フォーカスリング (2px offset)   | pointer     |
| Disabled | opacity: 0.5, グレースケール    | not-allowed |
| Loading  | テキスト非表示、スピナー表示    | wait        |

```css
.button {
  transition: all 0.15s ease-in-out;
}

.button:hover:not(:disabled) {
  background-color: var(--color-primary-hover);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.button:active:not(:disabled) {
  background-color: var(--color-primary-active);
  transform: translateY(1px);
}

.button:focus-visible {
  outline: 2px solid var(--color-focus);
  outline-offset: 2px;
}

.button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
```

### 9.5.2. Input States

| State    | Visual Change                    |
| -------- | -------------------------------- |
| Default  | グレーボーダー                   |
| Focus    | プライマリカラーボーダー、リング |
| Filled   | 薄いプライマリ背景               |
| Error    | レッドボーダー、薄いレッド背景   |
| Disabled | グレー背景、薄いテキスト         |

### 9.5.3. Micro-Animations

| Element          | Animation               | Duration |
| ---------------- | ----------------------- | -------- |
| Page Transition  | Fade + Slide Up         | 200ms    |
| Modal Open       | Fade + Scale (0.95 → 1) | 200ms    |
| Modal Close      | Fade + Scale (1 → 0.95) | 150ms    |
| Toast Enter      | Slide Up + Fade         | 300ms    |
| Toast Exit       | Slide Down + Fade       | 200ms    |
| List Item Add    | Slide In + Fade         | 250ms    |
| List Item Remove | Slide Out + Fade        | 200ms    |
| XP Gain          | Pop + Glow              | 500ms    |
| Level Up         | Confetti + Modal        | 1000ms   |
| Badge Unlock     | 3D Flip + Glow          | 800ms    |

---

## 9.6. Accessibility (a11y)

### 9.6.1. WCAG 2.1 AA 準拠

| Guideline           | 要件                           | 実装                       |
| ------------------- | ------------------------------ | -------------------------- |
| Color Contrast      | 4.5:1 (通常), 3:1 (大文字)     | カラーパレット設計         |
| Focus Visible       | フォーカス状態を明示           | focus-visible スタイル     |
| Text Resize         | 200% ズームでコンテンツ維持    | rem 単位、流動レイアウト   |
| Keyboard Navigation | 全機能がキーボードでアクセス可 | tabindex, focus management |
| Screen Reader       | 適切な ARIA ラベル             | aria-label, role 属性      |

### 9.6.2. Keyboard Navigation

| Key         | Action                          |
| ----------- | ------------------------------- |
| Tab         | 次のフォーカス可能要素へ移動    |
| Shift+Tab   | 前のフォーカス可能要素へ移動    |
| Enter/Space | ボタン/リンクのアクティベート   |
| Escape      | モーダル/ドロップダウンを閉じる |
| Arrow Keys  | リスト/メニュー内の移動         |

### 9.6.3. ARIA Guidelines

| 場面           | ARIA 属性                      | 例                    |
| -------------- | ------------------------------ | --------------------- |
| ボタン         | aria-label (アイコンのみ時)    | aria-label="閉じる"   |
| フォームエラー | aria-invalid, aria-describedby | aria-invalid="true"   |
| ローディング   | aria-busy, aria-live           | aria-busy="true"      |
| モーダル       | role="dialog", aria-modal      | aria-modal="true"     |
| タブ           | role="tablist", role="tab"     | aria-selected="true"  |
| アラート       | role="alert", aria-live        | aria-live="assertive" |

---

## 9.7. Responsive Breakpoints

| Breakpoint | Min Width | Max Width | Target Device                |
| ---------- | --------- | --------- | ---------------------------- |
| xs         | 0         | 374px     | Small phones                 |
| sm         | 375px     | 767px     | Phones (iPhone SE+)          |
| md         | 768px     | 1023px    | Tablets (portrait)           |
| lg         | 1024px    | 1279px    | Tablets (landscape), Desktop |
| xl         | 1280px    | ∞         | Large Desktop                |

---

## 9.8. BD 参照マトリクス

| DD Section       | BD Section          | Coverage |
| ---------------- | ------------------- | -------- |
| 9.2 Auth Screens | BD 04-screen-design | ✅ 100%  |
| 9.3 Conversation | BD 04-screen-design | ✅ 100%  |
| 9.4 Progress     | BD 04-screen-design | ✅ 100%  |

> 📋 BD Reference: [基本設計書/04-screen-design.md](../基本設計書/04-screen-design.md)

---

_メインファイル: [../09-ui-specifications.md](../09-ui-specifications.md)_
