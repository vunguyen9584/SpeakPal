# 3. 機能要件

> ⚠️ **注意**: このセクションは複数のファイルに分割されています。
>
> 詳細は [03-functional-requirements/](./03-functional-requirements/) フォルダを参照してください。

---

## 📁 ファイル構造

```
03-functional-requirements/
├── _index.md                 # 概要・全機能一覧・ユースケース図
├── 01-conversation.md        # FR-001〜003, 009, 010, 033（会話機能）
├── 02-feedback.md            # FR-004〜006, 017（フィードバック）
├── 03-customization.md       # FR-007〜008（カスタマイズ）
├── 04-user-management.md     # FR-011〜013（ユーザー管理）
├── 05-subscription.md        # FR-014〜016（サブスクリプション）
├── 06-gamification.md        # FR-018〜020（ゲーミフィケーション）
├── 07-progress-tracking.md   # FR-021〜023（学習進捗）
├── 08-structured-learning.md # FR-024〜026（構造化学習）
├── 09-social.md              # FR-027〜029（ソーシャル）
├── 10-advanced-learning.md   # FR-030〜032（高度な学習）
└── 11-translation-practice.md # FR-034〜038（翻訳練習）
```

---

## クイックリンク

| カテゴリ             | 機能 ID                    | リンク                                                                                |
| -------------------- | -------------------------- | ------------------------------------------------------------------------------------- |
| 会話機能             | FR-001〜003, 009, 010, 033 | [01-conversation.md](./03-functional-requirements/01-conversation.md)                 |
| フィードバック       | FR-004〜006, 017           | [02-feedback.md](./03-functional-requirements/02-feedback.md)                         |
| カスタマイズ         | FR-007〜008                | [03-customization.md](./03-functional-requirements/03-customization.md)               |
| ユーザー管理         | FR-011〜013                | [04-user-management.md](./03-functional-requirements/04-user-management.md)           |
| サブスクリプション   | FR-014〜016                | [05-subscription.md](./03-functional-requirements/05-subscription.md)                 |
| ゲーミフィケーション | FR-018〜020                | [06-gamification.md](./03-functional-requirements/06-gamification.md)                 |
| 学習進捗             | FR-021〜023                | [07-progress-tracking.md](./03-functional-requirements/07-progress-tracking.md)       |
| 構造化学習           | FR-024〜026                | [08-structured-learning.md](./03-functional-requirements/08-structured-learning.md)   |
| ソーシャル           | FR-027〜029                | [09-social.md](./03-functional-requirements/09-social.md)                             |
| 高度な学習           | FR-030〜032                | [10-advanced-learning.md](./03-functional-requirements/10-advanced-learning.md)       |
| 翻訳練習             | FR-034〜038                | [11-translation-practice.md](./03-functional-requirements/11-translation-practice.md) |

---

## 全機能一覧（サマリー）

詳細な一覧は [\_index.md](./03-functional-requirements/_index.md) を参照してください。

| ID     | 機能名                 | 優先度 |
| ------ | ---------------------- | ------ |
| FR-001 | 会話モード切替         | Must   |
| FR-002 | インストラクター会話   | Must   |
| FR-003 | フリートーク会話       | Must   |
| FR-004 | スマート提案表示       | Must   |
| FR-005 | ストリーミング字幕     | Must   |
| FR-006 | 即時訂正表示           | Must   |
| FR-007 | AI 速度調整            | Should |
| FR-008 | カスタムペルソナ作成   | Should |
| FR-009 | 割り込み対応           | Must   |
| FR-010 | フィラーワード         | Should |
| FR-011 | ユーザー登録           | Must   |
| FR-012 | ログイン/認証          | Must   |
| FR-013 | パスワード変更         | Must   |
| FR-014 | サブスクリプション管理 | Must   |
| FR-015 | 利用量制限             | Must   |
| FR-016 | プラン変更             | Must   |
| FR-017 | 語彙解説               | Should |
| FR-018 | 学習ストリーク         | Must   |
| FR-019 | 実績バッジ             | Should |
| FR-020 | 経験値＆レベル         | Should |
| FR-021 | 学習統計ダッシュボード | Must   |
| FR-022 | 発音スコア履歴         | Should |
| FR-023 | 週間/月間レポート      | Should |
| FR-024 | シナリオライブラリ     | Must   |
| FR-025 | デイリーチャレンジ     | Must   |
| FR-026 | 単語帳＆復習           | Must   |
| FR-027 | 友達招待               | Should |
| FR-028 | 週間ランキング         | Should |
| FR-029 | グループ学習           | Could  |
| FR-030 | 発音詳細分析           | Should |
| FR-031 | ロールプレイモード     | Must   |
| FR-032 | TOEIC/IELTS 対策       | Could  |
| FR-033 | 発話確認モード         | Should |
| FR-034 | ダイレクト翻訳練習     | Must   |
| FR-035 | 高度意図翻訳練習       | Must   |
| FR-036 | ワード連想チャレンジ   | Should |
| FR-037 | 瞬間応答ドリル         | Must   |
| FR-038 | シャドーイング練習     | Should |

**合計: 38 機能要件 (Must: 20, Should: 16, Could: 2)**
