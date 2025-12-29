# 2. 参考資料・用語集

## 2.1. 参考資料

### 2.1.1. 内部資料

| ドキュメント       | バージョン | 場所                   | 説明               |
| ------------------ | ---------- | ---------------------- | ------------------ |
| システム要件定義書 | 1.0        | ../システム要件定義書/ | 機能・非機能要件   |
| 基本設計書         | 1.0        | ../基本設計書/         | アーキテクチャ設計 |

### 2.1.2. 外部資料

| ドキュメント             | URL                                  | 説明             |
| ------------------------ | ------------------------------------ | ---------------- |
| Flutter Documentation    | https://flutter.dev/docs             | モバイル開発     |
| NestJS Documentation     | https://docs.nestjs.com/             | バックエンド開発 |
| PostgreSQL Documentation | https://www.postgresql.org/docs/15/  | データベース     |
| OpenAI API Reference     | https://platform.openai.com/docs     | GPT-4o API       |
| Deepgram API Reference   | https://developers.deepgram.com/docs | STT Service      |
| ElevenLabs API Reference | https://docs.elevenlabs.io/          | TTS Service      |
| Socket.io Documentation  | https://socket.io/docs/              | WebSocket        |
| Prisma Documentation     | https://www.prisma.io/docs           | ORM              |

### 2.1.3. 技術標準

| 標準/ガイドライン             | 適用箇所         |
| ----------------------------- | ---------------- |
| OpenAPI 3.0 Specification     | API 設計         |
| OAuth 2.0 / OpenID Connect    | 認証・認可       |
| OWASP Top 10                  | セキュリティ設計 |
| RFC 7519 (JWT)                | トークン管理     |
| WebSocket Protocol (RFC 6455) | リアルタイム通信 |

---

## 2.2. 用語集

### 2.2.1. ビジネス用語

| 用語               | 略語 | 定義                                              |
| ------------------ | ---- | ------------------------------------------------- |
| 学習者             | -    | SpeakPal を利用して英会話を練習するエンドユーザー |
| インストラクター   | -    | AI パートナーの指導者モード                       |
| フリートーク       | -    | AI パートナーと自由に会話するモード               |
| ペルソナ           | -    | AI パートナーの性格・声・話し方の設定             |
| ストリーク         | -    | 連続学習日数                                      |
| フリーズ           | -    | ストリークを保持するための一時停止機能            |
| デイリーチャレンジ | -    | 毎日更新される学習課題                            |
| シナリオ           | -    | ロールプレイ用の会話設定（空港、レストラン等）    |

### 2.2.2. 技術用語

| 用語                              | 略語 | 定義                                         |
| --------------------------------- | ---- | -------------------------------------------- |
| Speech-to-Text                    | STT  | 音声をテキストに変換する技術                 |
| Text-to-Speech                    | TTS  | テキストを音声に変換する技術                 |
| Large Language Model              | LLM  | 大規模言語モデル（GPT-4o 等）                |
| Voice Activity Detection          | VAD  | 音声区間を検出する技術                       |
| Spaced Repetition System          | SRS  | 間隔反復学習システム                         |
| JSON Web Token                    | JWT  | 認証用のトークン形式                         |
| WebSocket                         | WS   | 双方向リアルタイム通信プロトコル             |
| Application Programming Interface | API  | アプリケーション間の通信インターフェース     |
| Object-Relational Mapping         | ORM  | オブジェクトとリレーショナル DB のマッピング |
| Create, Read, Update, Delete      | CRUD | データ操作の基本 4 操作                      |
| Role-Based Access Control         | RBAC | 役割ベースのアクセス制御                     |

### 2.2.3. プロジェクト固有用語

| 用語   | 定義                                                            |
| ------ | --------------------------------------------------------------- |
| XP     | 経験値（Experience Points）。学習活動で獲得するポイント         |
| リーグ | ランキングのグループ（Bronze, Silver, Gold, Platinum, Diamond） |
| バッジ | 特定の達成条件で獲得できる称号                                  |
| 訂正   | AI による発話の文法・発音・語彙の修正                           |
| 提案   | AI による次の発話のテンプレートや語彙提案                       |
| ターン | 会話の 1 往復（ユーザー発話 + AI 応答）                         |

---

## 2.3. 略語一覧

| 略語  | 正式名称                            | 説明                              |
| ----- | ----------------------------------- | --------------------------------- |
| BD    | Basic Design                        | 基本設計                          |
| DD    | Detailed Design                     | 詳細設計                          |
| SRS   | Software Requirements Specification | ソフトウェア要件定義書            |
| UC    | Use Case                            | ユースケース                      |
| FR    | Functional Requirement              | 機能要件                          |
| NFR   | Non-Functional Requirement          | 非機能要件                        |
| API   | Application Programming Interface   | アプリケーションインターフェース  |
| DB    | Database                            | データベース                      |
| UI    | User Interface                      | ユーザーインターフェース          |
| UX    | User Experience                     | ユーザー体験                      |
| DTO   | Data Transfer Object                | データ転送オブジェクト            |
| VO    | Value Object                        | 値オブジェクト                    |
| DI    | Dependency Injection                | 依存性注入                        |
| ORM   | Object-Relational Mapping           | オブジェクト関係マッピング        |
| CRUD  | Create, Read, Update, Delete        | データ操作                        |
| CCU   | Concurrent Users                    | 同時接続ユーザー数                |
| RPS   | Requests Per Second                 | 秒間リクエスト数                  |
| RTO   | Recovery Time Objective             | 復旧目標時間                      |
| RPO   | Recovery Point Objective            | 復旧目標時点                      |
| CI/CD | Continuous Integration/Deployment   | 継続的インテグレーション/デプロイ |
| K8s   | Kubernetes                          | コンテナオーケストレーション      |

---

## 2.4. 命名規約

### 2.4.1. コード命名規約

| 対象          | 規約        | 例                      |
| ------------- | ----------- | ----------------------- |
| クラス名      | PascalCase  | UserService             |
| メソッド名    | camelCase   | getUserById()           |
| 変数名        | camelCase   | currentUser             |
| 定数名        | UPPER_SNAKE | MAX_CONVERSATION_LENGTH |
| ファイル名    | kebab-case  | user-service.ts         |
| DB テーブル名 | snake_case  | user_badges             |
| DB カラム名   | snake_case  | created_at              |
| API パス      | kebab-case  | /api/v1/user-profiles   |

### 2.4.2. ファイル・フォルダ命名規約

| 対象                 | 規約                  | 例                   |
| -------------------- | --------------------- | -------------------- |
| ドキュメントファイル | 番号-kebab-case       | 01-introduction.md   |
| コンポーネント       | PascalCase            | UserProfile.tsx      |
| テストファイル       | _.spec.ts / _.test.ts | user.service.spec.ts |
| 設定ファイル         | lowercase             | docker-compose.yml   |

---

← [目次](./_index.md) | _次のセクション: [03-system-overview.md](./03-system-overview.md)_
