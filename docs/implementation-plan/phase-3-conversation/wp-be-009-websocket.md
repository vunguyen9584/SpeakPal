# WP-BE-009: WebSocket Gateway (Backend)

## Overview

| Item           | Value                                                                        |
| -------------- | ---------------------------------------------------------------------------- |
| ID             | WP-BE-009                                                                    |
| Name           | WebSocket Gateway                                                            |
| Description    | Real-time audio streaming gateway using Socket.io                            |
| Dependencies   | WP-BE-008 (AI Orchestrator)                                                  |
| Estimated Days | 3                                                                            |
| Total Tasks    | 6                                                                            |
| DD References  | `08-api-design/websocket-apis.md`, `05-module-design/conversation-module.md` |

---

## Tasks

### Task 1: Setup Socket.io Gateway

- **ID**: WP-BE-009-T001
- **Type**: setup
- **Description**: Setup Socket.io gateway với NestJS integration
- **Commands**:
  ```bash
  cd backend
  npm install @nestjs/websockets @nestjs/platform-socket.io socket.io
  ```
- **Files to Create**:
  - `backend/src/modules/conversation/conversation.gateway.ts` - Main gateway
  - `backend/src/modules/conversation/events/client-events.ts` - Client event types
  - `backend/src/modules/conversation/events/server-events.ts` - Server event types
- **Implementation Details**:

  ```typescript
  @WebSocketGateway({
    namespace: "/ws/conversation",
    cors: {
      origin: process.env.CORS_ORIGINS?.split(",") || ["http://localhost:3000"],
      credentials: true,
    },
    transports: ["websocket"],
  })
  export class ConversationGateway
    implements OnGatewayConnection, OnGatewayDisconnect
  {
    @WebSocketServer()
    server: Server;

    constructor(
      private orchestrator: AIOrchestrator,
      private conversationService: ConversationService
    ) {}
  }
  ```

- **Acceptance Criteria**:
  - [ ] Socket.io gateway được setup với namespace `/ws/conversation`
  - [ ] CORS được configure đúng
  - [ ] WebSocket transport only (không fallback polling)
  - [ ] Server instance được inject đúng
- **Estimated Hours**: 1.5
- **DD Reference**: `08-api-design/websocket-apis.md#接続`

---

### Task 2: Implement Connection Handler

- **ID**: WP-BE-009-T002
- **Type**: feature
- **Description**: Handle WebSocket connection với token validation
- **Files to Modify**:
  - `backend/src/modules/conversation/conversation.gateway.ts`
- **WebSocket Events**:
  | Event | Direction | Payload |
  | -------------- | --------------- | ----------------------------------------- |
  | connection | Client → Server | `{ token, conversationId }` |
  | connected | Server → Client | `{ sessionId, serverTime }` |
  | disconnect | Bi-directional | - |
- **Implementation Details**:
  ```typescript
  async handleConnection(client: Socket) {
    try {
      const { token, conversationId } = client.handshake.auth;

      // 1. Validate short-lived token
      const payload = await this.verifyToken(token);

      // 2. Verify conversation ownership
      const conversation = await this.conversationService.get(
        payload.userId,
        conversationId
      );

      // 3. Store session data
      client.data = {
        userId: payload.userId,
        conversationId,
        connectedAt: new Date(),
      };

      // 4. Join conversation room
      client.join(`conversation:${conversationId}`);

      // 5. Send connected event
      client.emit('connected', {
        sessionId: client.id,
        serverTime: new Date().toISOString(),
      });
    } catch (error) {
      client.emit('error', {
        code: 'WS_ERR_001',
        message: 'Invalid token',
        recoverable: false,
        action: 'reconnect',
      });
      client.disconnect();
    }
  }
  ```
- **Acceptance Criteria**:
  - [ ] Token validation trước khi accept connection
  - [ ] Conversation ownership check
  - [ ] Session data được store trong client.data
  - [ ] Client join conversation room
  - [ ] Error event khi validation fails
  - [ ] Disconnect khi token invalid
- **Estimated Hours**: 2
- **DD Reference**: `08-api-design/websocket-apis.md#Connection`

---

### Task 3: Implement Audio Stream Handler

- **ID**: WP-BE-009-T003
- **Type**: feature
- **Description**: Handle incoming audio stream từ client
- **Files to Modify**:
  - `backend/src/modules/conversation/conversation.gateway.ts`
- **WebSocket Events**:
  | Event | Direction | Payload |
  | ------------ | --------------- | ---------------------------------------------------- |
  | audio_stream | Client → Server | `{ chunk, sequence, sampleRate, channels, isFinal }` |
  | text_result | Server → Client | `{ text, isFinal, confidence, timestamp }` |
- **Implementation Details**:
  ```typescript
  @SubscribeMessage('audio_stream')
  async handleAudioStream(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: AudioStreamDto
  ) {
    const { conversationId } = client.data;
    const audioBuffer = Buffer.from(data.chunk, 'base64');

    // Process through orchestrator
    for await (const response of this.orchestrator.processAudioStream(
      audioBuffer,
      this.getContext(client)
    )) {
      client.emit(response.type, response.data);
    }
  }
  ```
- **Acceptance Criteria**:
  - [ ] Receive Base64 encoded audio chunks
  - [ ] Validate audio format (16kHz, mono)
  - [ ] Pass to AIOrchestrator.processAudioStream()
  - [ ] Emit text_result events (interim và final)
  - [ ] Handle sequence numbers để detect missing chunks
  - [ ] Buffer chunks nếu cần cho VAD
- **Estimated Hours**: 3
- **DD Reference**: `08-api-design/websocket-apis.md#audio_stream`

---

### Task 4: Implement Response Streaming

- **ID**: WP-BE-009-T004
- **Type**: feature
- **Description**: Stream AI response audio back to client
- **Files to Modify**:
  - `backend/src/modules/conversation/conversation.gateway.ts`
- **WebSocket Events**:
  | Event | Direction | Payload |
  | ------------------ | --------------- | ------------------------------ |
  | ai_response_start | Server → Client | `{ responseId }` |
  | ai_response_audio | Server → Client | `{ chunk, sequence }` |
  | ai_response_end | Server → Client | `{ responseId, text }` |
  | correction | Server → Client | `{ corrections[] }` |
  | suggestion | Server → Client | `{ template, vocabulary[] }` |
- **Implementation Details**:
  ```typescript
  private async streamResponse(
    client: Socket,
    responseGenerator: AsyncGenerator<AIResponse>
  ) {
    let sequence = 0;
    const responseId = generateId();

    for await (const response of responseGenerator) {
      switch (response.type) {
        case 'ai_response_start':
          client.emit('ai_response_start', { responseId });
          break;
        case 'ai_response_audio':
          client.emit('ai_response_audio', {
            chunk: response.data.toString('base64'),
            sequence: sequence++,
          });
          break;
        case 'ai_response_end':
          client.emit('ai_response_end', {
            responseId,
            text: response.data.text,
          });
          break;
        case 'correction':
          client.emit('correction', { corrections: response.data });
          break;
        case 'suggestion':
          client.emit('suggestion', response.data);
          break;
      }
    }
  }
  ```
- **Acceptance Criteria**:
  - [ ] Emit ai_response_start trước khi stream audio
  - [ ] Stream audio chunks với sequence numbers
  - [ ] Emit ai_response_end với full text khi hoàn thành
  - [ ] Emit correction event sau response
  - [ ] Emit suggestion event sau response
  - [ ] Audio chunks được Base64 encode
- **Estimated Hours**: 2.5
- **DD Reference**: `08-api-design/websocket-apis.md#ai_response`

---

### Task 5: Add Authentication Middleware

- **ID**: WP-BE-009-T005
- **Type**: feature
- **Description**: Implement WebSocket authentication middleware
- **Files to Create**:
  - `backend/src/modules/conversation/ws-auth.guard.ts`
  - `backend/src/modules/conversation/ws-jwt.strategy.ts`
- **Implementation Details**:
  ```typescript
  @Injectable()
  export class WsAuthGuard implements CanActivate {
    constructor(private jwtService: JwtService) {}

    canActivate(context: ExecutionContext): boolean {
      const client = context.switchToWs().getClient<Socket>();
      const { token } = client.handshake.auth;

      try {
        const payload = this.jwtService.verify(token, {
          secret: process.env.WS_JWT_SECRET,
          maxAge: "1h", // Short-lived token
        });
        client.data.userId = payload.userId;
        return true;
      } catch {
        return false;
      }
    }
  }
  ```
- **Acceptance Criteria**:
  - [ ] Verify short-lived JWT token (1 hour expiry)
  - [ ] Extract userId từ token
  - [ ] Reject connection nếu token invalid/expired
  - [ ] Use separate secret cho WS tokens
  - [ ] Token được generate khi POST /conversations
- **Estimated Hours**: 1.5
- **DD Reference**: `10-security-design.md`

---

### Task 6: Add Rate Limiting

- **ID**: WP-BE-009-T006
- **Type**: feature
- **Description**: Implement rate limiting cho WebSocket events
- **Files to Create**:
  - `backend/src/modules/conversation/ws-rate-limiter.ts`
- **Implementation Details**:
  | Limit Type | Value | Action |
  | -------------------- | ------------------------ | ------------------------ |
  | Events per second | 10 events/s per client | Emit warning, then block |
  | Audio data per second| 64KB/s per client | Block excess data |
  | Concurrent sessions | 1 per user | Reject new connection |
  | Total audio per day | Free: 30 min, Premium: unlimited | End session |
- **Implementation Details**:
  ```typescript
  @Injectable()
  export class WsRateLimiter {
    private eventCounts: Map<string, number> = new Map();
    private dataSizes: Map<string, number> = new Map();

    checkEventLimit(clientId: string): boolean;
    checkDataLimit(clientId: string, size: number): boolean;
    checkConcurrentLimit(userId: string, clientId: string): boolean;
    checkDailyAudioLimit(userId: string, duration: number): boolean;

    reset(clientId: string): void;
  }
  ```
- **Acceptance Criteria**:
  - [ ] Block clients gửi quá nhiều events
  - [ ] Block clients gửi quá nhiều data
  - [ ] Only 1 active session per user
  - [ ] Track daily audio usage
  - [ ] Emit rate_limited event trước khi block
  - [ ] Reset counters mỗi giây
- **Estimated Hours**: 2
- **DD Reference**: `04-design-considerations.md#performance`

---

## Task Summary

| Task ID        | Name                         | Type    | Hours    | Status |
| -------------- | ---------------------------- | ------- | -------- | ------ |
| WP-BE-009-T001 | Setup Socket.io Gateway      | setup   | 1.5      | ⬜     |
| WP-BE-009-T002 | Implement Connection Handler | feature | 2        | ⬜     |
| WP-BE-009-T003 | Implement Audio Stream       | feature | 3        | ⬜     |
| WP-BE-009-T004 | Implement Response Streaming | feature | 2.5      | ⬜     |
| WP-BE-009-T005 | Add Auth Middleware          | feature | 1.5      | ⬜     |
| WP-BE-009-T006 | Add Rate Limiting            | feature | 2        | ⬜     |
| **Total**      |                              |         | **12.5** |        |

---

_Back to: [\_phase-3.md](./_phase-3.md)_
