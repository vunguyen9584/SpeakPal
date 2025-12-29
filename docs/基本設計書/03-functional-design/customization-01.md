# カスタマイズ機能 - ユースケース詳細

## UC-007: AI 速度調整

### 基本情報

| 項目     | 内容                    |
| -------- | ----------------------- |
| UC ID    | UC-007                  |
| UC 名    | AI 速度調整             |
| アクター | 学習者                  |
| 前提条件 | ユーザーはログイン済み  |
| 事後条件 | AI 発話速度が変更される |
| 関連 FR  | FR-007                  |
| 優先度   | Should                  |

### 基本フロー

1. 学習者が設定画面を開く
2. 「AI 速度」スライダーを表示
3. 学習者がスライダーを調整（0.75x〜1.25x）
4. システムがリアルタイムでプレビュー音声を再生
5. 学習者が保存
6. 次回会話から AI 速度が適用

### シーケンス図

```mermaid
sequenceDiagram
    participant User as 学習者
    participant App as アプリ
    participant API as Backend
    participant TTS as TTS Service

    User->>App: 設定画面を開く
    App->>API: getUserSettings()
    API-->>App: 現在の設定
    App-->>User: 速度スライダー表示

    User->>App: スライダー調整
    App->>TTS: previewVoice(speed)
    TTS-->>App: プレビュー音声
    App-->>User: 音声再生

    User->>App: 保存
    App->>API: updateSettings({speed})
    API-->>App: 成功
    App-->>User: 設定保存完了
```

### ビジネスルール

| ルール ID | ルール内容                             |
| --------- | -------------------------------------- |
| BR-014    | デフォルト速度はユーザーレベルに依存   |
| BR-015    | 速度範囲: 0.75x（遅い）〜1.25x（速い） |

---

## UC-008: ペルソナ作成

### 基本情報

| 項目     | 内容                       |
| -------- | -------------------------- |
| UC ID    | UC-008                     |
| UC 名    | ペルソナ作成               |
| アクター | 学習者                     |
| 前提条件 | ユーザーはログイン済み     |
| 事後条件 | 新しいペルソナが作成される |
| 関連 FR  | FR-008                     |
| 優先度   | Should                     |

### 基本フロー

1. 学習者がペルソナ管理画面を開く
2. 「新規作成」ボタンをタップ
3. 以下を設定:
   - 名前（必須）
   - 声（選択式: voice_1/voice_2/voice_3）
   - 性格（選択式: cheerful/strict/sarcastic）
   - 対象レベル（選択式）
4. プレビュー音声を確認
5. 保存
6. 作成したペルソナが会話で使用可能に

### バリデーション

| フィールド | ルール           |
| ---------- | ---------------- |
| 名前       | 1〜20 文字、一意 |
| 声         | 選択必須         |
| 性格       | 選択必須         |
| 対象レベル | 選択必須         |

### ビジネスルール

| ルール ID | ルール内容                                  |
| --------- | ------------------------------------------- |
| BR-016    | ペルソナ名はユーザー内で一意                |
| BR-017    | 1 ユーザーあたり最大 5 ペルソナまで作成可能 |

### シーケンス図

```mermaid
sequenceDiagram
    participant User as 学習者
    participant App as アプリ
    participant API as Backend
    participant TTS as TTS Service

    User->>App: ペルソナ管理画面を開く
    App->>API: getPersonas()
    API-->>App: ペルソナ一覧
    App-->>User: ペルソナ一覧表示

    User->>App: 新規作成タップ
    App-->>User: 作成フォーム表示

    User->>App: 設定入力（名前、声、性格）
    User->>App: プレビュー
    App->>TTS: generatePreview(voice, personality)
    TTS-->>App: プレビュー音声
    App-->>User: 音声再生

    User->>App: 保存
    App->>API: createPersona({name, voice, personality})
    API-->>App: 成功
    App-->>User: ペルソナ作成完了
```

---

## DFD レベル 2: カスタマイズモジュール

### データフローダイアグラム

```mermaid
flowchart TB
    subgraph External["外部"]
        User["👤 学習者"]
        TTS["🔊 TTS Service"]
    end

    subgraph CustomizationModule["カスタマイズモジュール"]
        P4_1["4.1<br/>速度設定管理"]
        P4_2["4.2<br/>ペルソナ管理"]
        P4_3["4.3<br/>プレビュー生成"]

        D4_1[("ユーザー<br/>設定")]
        D4_2[("ペルソナ<br/>データ")]
    end

    User -->|"速度調整"| P4_1
    P4_1 -->|"設定保存"| D4_1
    P4_1 -->|"プレビュー依頼"| P4_3

    User -->|"ペルソナ作成/編集"| P4_2
    P4_2 -->|"ペルソナ保存"| D4_2
    P4_2 -->|"プレビュー依頼"| P4_3

    P4_3 -->|"音声生成"| TTS
    TTS -->|"音声ストリーム"| P4_3
    P4_3 -->|"プレビュー再生"| User
```

### サブプロセス定義

| プロセス ID | プロセス名     | 入力          | 出力           | 説明                   |
| ----------- | -------------- | ------------- | -------------- | ---------------------- |
| 4.1         | 速度設定管理   | 速度値        | 設定データ     | AI 発話速度を管理      |
| 4.2         | ペルソナ管理   | ペルソナ情報  | ペルソナデータ | カスタムペルソナを管理 |
| 4.3         | プレビュー生成 | 設定/ペルソナ | 音声ストリーム | 設定のプレビュー音声   |

---

_関連ファイル: [\_index.md](./_index.md) | [user-01.md](./user-01.md)_
_メインファイル: [../03-functional-design.md](../03-functional-design.md)_
