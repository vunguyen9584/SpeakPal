# 2. システムアーキテクチャ

## 2.1. 概要

本章では、SpeakPal AI のシステムアーキテクチャを定義します。リアルタイム音声通信と AI 処理を中心とした設計となっています。

---

## 2.2. アーキテクチャパターン

### 2.2.1. 採用パターン

| パターン         | 採用理由                                 |
| ---------------- | ---------------------------------------- |
| マイクロサービス | 機能ごとの独立スケーリング・デプロイ     |
| イベント駆動     | リアルタイム処理・非同期並列処理         |
| API Gateway      | 認証・レート制限・ルーティングの一元管理 |
| CQRS             | 読み書き負荷の分離（統計・ランキング）   |

### 2.2.2. レイヤー構成

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                          │
│  ┌───────────────────────────────┐  ┌─────────────┐              │
│  │      Mobile App (Flutter)     │  │   Web App   │              │
│  │       iOS / Android           │  │  (React)    │              │
│  └───────────────────────────────┘  └─────────────┘              │
├─────────────────────────────────────────────────────────────────┤
│                     API GATEWAY LAYER                           │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │   Kong / AWS API Gateway                                 │    │
│  │   - 認証・認可                                           │    │
│  │   - レート制限                                           │    │
│  │   - WebSocketアップグレード                               │    │
│  └─────────────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────────┤
│                     SERVICE LAYER                               │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐       │
│  │   Auth    │ │ User      │ │ Convers-  │ │ Feedback  │       │
│  │  Service  │ │ Service   │ │ ation     │ │  Service  │       │
│  └───────────┘ └───────────┘ └───────────┘ └───────────┘       │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐       │
│  │ Gamifi-   │ │ Progress  │ │ Learning  │ │  Social   │       │
│  │ cation    │ │  Service  │ │  Service  │ │  Service  │       │
│  └───────────┘ └───────────┘ └───────────┘ └───────────┘       │
├─────────────────────────────────────────────────────────────────┤
│                     DATA LAYER                                  │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐       │
│  │PostgreSQL │ │   Redis   │ │  S3/Blob  │ │  Elastic  │       │
│  │ (Main DB) │ │  (Cache)  │ │ (Storage) │ │ (Search)  │       │
│  └───────────┘ └───────────┘ └───────────┘ └───────────┘       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2.3. システムコンテキスト図

```mermaid
flowchart TB
    subgraph Actors["外部アクター"]
        User["👤 学習者"]
        Admin["👨‍💻 管理者"]
    end

    subgraph ExternalSystems["外部システム"]
        STT["🎤 STT Service<br/>(Deepgram/Whisper)"]
        LLM["🧠 LLM Service<br/>(GPT-4o/Groq)"]
        TTS["🔊 TTS Service<br/>(ElevenLabs)"]
        AppStore["📱 App Store<br/>(iOS/Android)"]
        AuthProvider["🔐 Auth Provider<br/>(Firebase/Auth0)"]
    end

    subgraph SpeakPal["SpeakPal AI System"]
        API["API Gateway"]
        Core["Core Services"]
    end

    User -->|"音声/テキスト"| SpeakPal
    SpeakPal -->|"音声/訂正/提案"| User
    Admin -->|"管理操作"| SpeakPal

    SpeakPal <-->|"音声→テキスト"| STT
    SpeakPal <-->|"会話生成/分析"| LLM
    SpeakPal <-->|"テキスト→音声"| TTS
    SpeakPal <-->|"決済処理"| AppStore
    SpeakPal <-->|"認証"| AuthProvider
```

---

## 2.4. コンポーネント図

### 2.4.1. 全体コンポーネント

```mermaid
flowchart TB
    subgraph Client["Client Layer"]
        Mobile["Mobile App<br/>(Flutter)"]
        Web["Web App<br/>(React)"]
    end

    subgraph Gateway["Gateway Layer"]
        APIGateway["API Gateway"]
        WSGateway["WebSocket<br/>Gateway"]
    end

    subgraph Services["Service Layer"]
        AuthSvc["Auth Service"]
        UserSvc["User Service"]
        ConvSvc["Conversation<br/>Service"]
        FeedbackSvc["Feedback<br/>Service"]
        GamifySvc["Gamification<br/>Service"]
        ProgressSvc["Progress<br/>Service"]
        LearningSvc["Learning<br/>Service"]
        SocialSvc["Social<br/>Service"]
        SubsSvc["Subscription<br/>Service"]
    end

    subgraph AI["AI Pipeline"]
        Orchestrator["Orchestrator"]
        ConvGen["Conversation<br/>Generator"]
        ErrorAnalyzer["Error<br/>Analyzer"]
        SuggestionGen["Suggestion<br/>Generator"]
    end

    subgraph Data["Data Layer"]
        PostgreSQL[(PostgreSQL)]
        Redis[(Redis)]
        S3[(S3/Blob)]
    end

    Client --> Gateway
    Gateway --> Services
    ConvSvc --> Orchestrator
    Orchestrator --> ConvGen
    Orchestrator --> ErrorAnalyzer
    Orchestrator --> SuggestionGen
    Services --> Data
```

### 2.4.2. 会話処理パイプライン

```mermaid
sequenceDiagram
    participant User as 学習者
    participant App as クライアント
    participant WS as WebSocket Gateway
    participant Orch as Orchestrator
    participant STT as STT Service
    participant LLM as LLM Service
    participant TTS as TTS Service

    User->>App: 音声発話
    App->>WS: 音声ストリーム
    WS->>STT: 音声送信
    STT-->>WS: テキスト変換

    par 並列処理
        WS->>Orch: テキスト
        Orch->>LLM: 会話応答生成
        Orch->>LLM: エラー分析
        Orch->>LLM: 提案生成
    end

    LLM-->>Orch: 応答テキスト
    LLM-->>Orch: 訂正情報
    LLM-->>Orch: 提案内容

    Orch->>TTS: 応答テキスト
    TTS-->>Orch: 音声ストリーム

    Orch-->>WS: 音声+訂正+提案
    WS-->>App: 統合レスポンス
    App-->>User: 音声再生+UI表示
```

---

## 2.5. デプロイメント図

```mermaid
flowchart TB
    subgraph CloudProvider["Cloud Provider (AWS/GCP)"]
        subgraph PublicSubnet["Public Subnet"]
            LB["Load Balancer"]
            CDN["CloudFront/CDN"]
        end

        subgraph PrivateSubnet["Private Subnet"]
            subgraph K8sCluster["Kubernetes Cluster"]
                APIGatewayPod["API Gateway<br/>Pods x3"]
                WSPod["WebSocket<br/>Pods x5"]
                ServicePods["Service<br/>Pods x10"]
            end

            subgraph DataTier["Data Tier"]
                RDS["Amazon RDS<br/>(PostgreSQL)"]
                ElastiCache["ElastiCache<br/>(Redis)"]
                S3Bucket["S3 Bucket"]
            end
        end
    end

    subgraph ExternalServices["External Services"]
        Deepgram["Deepgram API"]
        OpenAI["OpenAI API"]
        ElevenLabs["ElevenLabs API"]
    end

    Users["Users"] --> CDN
    CDN --> LB
    LB --> K8sCluster
    K8sCluster --> DataTier
    K8sCluster <--> ExternalServices
```

---

## 2.6. 技術スタック

### 2.6.1. フロントエンド

| カテゴリ         | 技術                    | バージョン | 目的                               |
| ---------------- | ----------------------- | ---------- | ---------------------------------- |
| Mobile App       | Flutter / Dart          | 3.x / 3.x  | iOS/Android クロスプラットフォーム |
| 状態管理(Mobile) | Riverpod / Bloc         | Latest     | Flutter 状態管理                   |
| Web              | React                   | 18.x       | Web アプリケーション               |
| 状態管理(Web)    | Redux Toolkit / Zustand | Latest     | グローバル状態管理                 |
| スタイリング     | Tailwind CSS            | 3.x        | Web UI スタイリング                |
| 音声処理         | just_audio / record     | Latest     | Flutter 音声キャプチャ・再生       |

### 2.6.2. バックエンド

| カテゴリ       | 技術                 | バージョン | 目的                   |
| -------------- | -------------------- | ---------- | ---------------------- |
| 言語           | Node.js / TypeScript | 20.x / 5.x | サーバーサイド開発     |
| フレームワーク | NestJS               | 10.x       | API サービス           |
| WebSocket      | Socket.io            | 4.x        | リアルタイム通信       |
| ORM            | Prisma               | 5.x        | データベースアクセス   |
| キュー         | BullMQ               | 4.x        | バックグラウンドジョブ |

### 2.6.3. データベース

| カテゴリ     | 技術            | バージョン | 目的                   |
| ------------ | --------------- | ---------- | ---------------------- |
| RDBMS        | PostgreSQL      | 15.x       | メインデータストア     |
| キャッシュ   | Redis           | 7.x        | セッション・キャッシュ |
| 検索         | Elasticsearch   | 8.x        | 全文検索               |
| オブジェクト | S3 / Azure Blob | -          | ファイルストレージ     |

### 2.6.4. インフラ・運用

| カテゴリ             | 技術              | 目的                 |
| -------------------- | ----------------- | -------------------- |
| コンテナ             | Docker            | コンテナ化           |
| オーケストレーション | Kubernetes        | コンテナ管理         |
| CI/CD                | GitHub Actions    | 自動ビルド・デプロイ |
| 監視                 | Datadog / Grafana | メトリクス・ログ監視 |
| APM                  | Sentry            | エラートラッキング   |

---

## 2.7. セキュリティアーキテクチャ

### 2.7.1. 認証・認可フロー

```mermaid
sequenceDiagram
    participant User as 学習者
    participant App as クライアント
    participant Auth as Auth Service
    participant API as API Gateway
    participant Service as Backend Service

    User->>App: ログイン情報入力
    App->>Auth: 認証リクエスト
    Auth->>Auth: 検証
    Auth-->>App: JWT Token (Access + Refresh)

    App->>API: APIリクエスト + Access Token
    API->>API: Token検証
    API->>Service: 認可済みリクエスト
    Service-->>App: レスポンス

    Note over App,Auth: Access Token期限切れ時
    App->>Auth: Refresh Token
    Auth-->>App: 新しいAccess Token
```

### 2.7.2. セキュリティレイヤー

| レイヤー | 対策                                               |
| -------- | -------------------------------------------------- |
| 通信     | TLS 1.3 による暗号化                               |
| 認証     | JWT + Refresh Token、OAuth 2.0 対応                |
| 認可     | RBAC (Role-Based Access Control)                   |
| データ   | DB 暗号化（at rest）、センシティブデータマスキング |
| API      | レート制限、CORS 設定                              |
| コード   | 依存関係スキャン、SAST                             |

---

## 2.8. スケーラビリティ設計

### 2.8.1. 水平スケーリング

| コンポーネント   | スケーリング戦略                  | トリガー               |
| ---------------- | --------------------------------- | ---------------------- |
| API Gateway      | Pod Auto-scaling                  | CPU > 70%              |
| WebSocket Server | Pod Auto-scaling + Sticky Session | Connection Count > 200 |
| Service Pods     | Pod Auto-scaling                  | CPU > 70%              |
| PostgreSQL       | Read Replica                      | Query Latency > 100ms  |
| Redis            | Cluster Mode                      | Memory > 80%           |

### 2.8.2. キャパシティプランニング

| メトリック                | 初期値    | スケール目標 |
| ------------------------- | --------- | ------------ |
| 同時接続数                | 1,000 CCU | 10,000 CCU   |
| 日次アクティブユーザー    | 10,000    | 100,000      |
| 1 秒あたり API リクエスト | 1,000 RPS | 10,000 RPS   |

---

## 2.9. パッケージ構成

```
speakpal/
├── apps/
│   ├── mobile/               # Flutter モバイルアプリ (iOS/Android)
│   └── web/                  # React Web アプリ
├── services/
│   ├── api-gateway/          # API Gateway
│   ├── auth-service/         # 認証サービス
│   ├── user-service/         # ユーザーサービス
│   ├── conversation-service/ # 会話サービス
│   ├── feedback-service/     # フィードバックサービス
│   ├── gamification-service/ # ゲーミフィケーション
│   ├── progress-service/     # 進捗サービス
│   ├── learning-service/     # 学習サービス
│   ├── social-service/       # ソーシャルサービス
│   └── subscription-service/ # サブスクサービス
├── packages/
│   ├── shared-types/         # 共有型定義
│   ├── shared-utils/         # 共有ユーティリティ
│   └── ai-pipeline/          # AI処理パイプライン
└── infrastructure/
    ├── kubernetes/           # K8s マニフェスト
    ├── terraform/            # IaC
    └── docker/               # Dockerfile群
```

---

## 2.10. データフローダイアグラム (DFD)

### 2.10.1. DFD レベル 0 (コンテキスト図)

```mermaid
flowchart TB
    User["👤 学習者"]
    Admin["👨‍💻 管理者"]

    System[("SpeakPal AI<br/>System")]

    STT["🎤 STT Service"]
    LLM["🧠 LLM Service"]
    TTS["🔊 TTS Service"]
    Payment["💳 Payment<br/>(App Store)"]

    User -->|"D1: 音声入力<br/>D2: テキスト入力<br/>D3: 設定変更"| System
    System -->|"D4: AI音声応答<br/>D5: 訂正・提案<br/>D6: 学習統計"| User

    Admin -->|"D7: 管理コマンド"| System
    System -->|"D8: システム統計"| Admin

    System <-->|"D9: 音声→テキスト"| STT
    System <-->|"D10: 会話・分析"| LLM
    System <-->|"D11: テキスト→音声"| TTS
    System <-->|"D12: 決済処理"| Payment
```

### 2.10.2. コンテキスト図のデータフロー一覧

| フロー ID | From   | To      | データ内容                       |
| --------- | ------ | ------- | -------------------------------- |
| D1        | 学習者 | System  | 音声ストリーム、発話音声         |
| D2        | 学習者 | System  | テキスト入力、チャットメッセージ |
| D3        | 学習者 | System  | 設定変更（速度、ペルソナ等）     |
| D4        | System | 学習者  | AI 音声応答ストリーム            |
| D5        | System | 学習者  | 発音訂正、文法訂正、語彙提案     |
| D6        | System | 学習者  | 学習統計、進捗レポート           |
| D7        | 管理者 | System  | ユーザー管理、コンテンツ管理     |
| D8        | System | 管理者  | システムメトリクス、ユーザー統計 |
| D9        | System | STT     | 音声データ → テキスト変換        |
| D10       | System | LLM     | 会話生成、エラー分析、提案生成   |
| D11       | System | TTS     | テキスト → 音声変換              |
| D12       | System | Payment | サブスクリプション決済処理       |

### 2.10.3. DFD レベル 1 (システム概要)

```mermaid
flowchart TB
    User["👤 学習者"]

    subgraph SpeakPal["SpeakPal AI System"]
        P1["1.0<br/>認証・ユーザー管理"]
        P2["2.0<br/>会話処理"]
        P3["3.0<br/>フィードバック生成"]
        P4["4.0<br/>学習管理"]
        P5["5.0<br/>ゲーミフィケーション"]
        P6["6.0<br/>ソーシャル"]
        P7["7.0<br/>サブスクリプション"]

        D1[("Users<br/>DB")]
        D2[("Conversations<br/>DB")]
        D3[("Vocabulary<br/>DB")]
        D4[("Gamification<br/>DB")]
        D5[("Social<br/>DB")]
    end

    STT["🎤 STT"]
    LLM["🧠 LLM"]
    TTS["🔊 TTS"]

    User -->|"認証情報"| P1
    P1 -->|"ユーザーデータ"| D1

    User -->|"音声入力"| P2
    P2 <-->|"音声→テキスト"| STT
    P2 <-->|"会話生成"| LLM
    P2 <-->|"テキスト→音声"| TTS
    P2 -->|"会話ログ"| D2
    P2 -->|"AI応答"| User

    P2 -->|"発話テキスト"| P3
    P3 <-->|"エラー分析"| LLM
    P3 -->|"訂正・提案"| User

    P2 -->|"学習完了"| P4
    P4 -->|"語彙データ"| D3
    P4 -->|"進捗統計"| User

    P4 -->|"学習イベント"| P5
    P5 -->|"XP・バッジ"| D4
    P5 -->|"報酬通知"| User

    User <-->|"ソーシャル操作"| P6
    P6 -->|"社会データ"| D5

    User <-->|"サブスク操作"| P7
    P7 -->|"利用制限"| P2
```

### 2.10.4. プロセス定義

| プロセス ID | プロセス名           | 説明                                       |
| ----------- | -------------------- | ------------------------------------------ |
| 1.0         | 認証・ユーザー管理   | ユーザー登録、ログイン、プロフィール管理   |
| 2.0         | 会話処理             | 音声入力 →AI 処理 → 音声出力のメインフロー |
| 3.0         | フィードバック生成   | 発音・文法・語彙エラー分析と提案生成       |
| 4.0         | 学習管理             | 語彙保存、シナリオ、チャレンジ、復習管理   |
| 5.0         | ゲーミフィケーション | ストリーク、XP、バッジ、レベル管理         |
| 6.0         | ソーシャル           | 招待、ランキング、グループ管理             |
| 7.0         | サブスクリプション   | プラン管理、利用量制限、決済連携           |

### 2.10.5. データストア定義

| ストア ID | ストア名         | 主要エンティティ                           |
| --------- | ---------------- | ------------------------------------------ |
| D1        | Users DB         | User, UserLevel, Persona                   |
| D2        | Conversations DB | Conversation, ConversationTurn, Correction |
| D3        | Vocabulary DB    | Vocabulary, Scenario, Challenge            |
| D4        | Gamification DB  | Streak, Badge, UserBadge, XP               |
| D5        | Social DB        | Invitation, Ranking, Group                 |

### 2.10.6. 外部エンティティ定義

| エンティティ | タイプ       | データ交換内容                   |
| ------------ | ------------ | -------------------------------- |
| 学習者       | ユーザー     | 音声、テキスト、設定、アクション |
| 管理者       | ユーザー     | 管理コマンド、統計閲覧           |
| STT Service  | 外部システム | 音声 → テキスト変換              |
| LLM Service  | 外部システム | 会話生成、エラー分析、提案生成   |
| TTS Service  | 外部システム | テキスト → 音声変換              |
| Payment      | 外部システム | サブスクリプション決済           |

---

← [目次](./_index.md) | _次のセクション: [03-functional-design.md](./03-functional-design.md)_
