import {
  WebSocketGateway,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger } from '@nestjs/common';
import { ConversationService } from './conversation.service';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

interface ClientData {
  userId: string;
  conversationId: string;
  connectedAt: Date;
}

@WebSocketGateway({
  namespace: '/ws/conversation',
  cors: {
    origin: true, // Will be configured in constructor
    credentials: true,
  },
  transports: ['websocket'],
})
export class ConversationGateway
  implements OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(ConversationGateway.name);

  constructor(
    private readonly conversationService: ConversationService,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {
    // Configure CORS origins from centralized config
    const corsOrigins = this.configService.get<string[]>(
      'externalServices.app.corsOrigins',
      ['http://localhost:3000'],
    );
    this.logger.log(`CORS origins configured: ${corsOrigins.join(', ')}`);
  }

  /**
   * Handle new client connection
   */
  async handleConnection(client: Socket) {
    try {
      this.logger.log(`Client attempting connection: ${client.id}`);

      // Extract auth data from handshake
      const { token, conversationId } = client.handshake.auth as {
        token: string;
        conversationId: string;
      };

      if (!token || !conversationId) {
        this.emitError(client, 'WS_ERR_001', 'Missing authentication data');
        client.disconnect();
        return;
      }

      // Validate WebSocket token
      let payload: { userId: string };
      try {
        payload = this.jwtService.verify(token, {
          secret: this.configService.get('WS_JWT_SECRET'),
        });
      } catch (error) {
        this.emitError(client, 'WS_ERR_002', 'Invalid or expired token');
        client.disconnect();
        return;
      }

      // Verify conversation ownership
      try {
        const conversation = await this.conversationService.getConversation(
          payload.userId,
          conversationId,
        );

        if (!conversation) {
          this.emitError(client, 'WS_ERR_003', 'Conversation not found');
          client.disconnect();
          return;
        }
      } catch (error) {
        this.emitError(
          client,
          'WS_ERR_004',
          'Not authorized to access this conversation',
        );
        client.disconnect();
        return;
      }

      // Store session data
      const clientData: ClientData = {
        userId: payload.userId,
        conversationId,
        connectedAt: new Date(),
      };
      client.data = clientData;

      // Join conversation room
      await client.join(`conversation:${conversationId}`);

      // Send connected event
      client.emit('connected', {
        sessionId: client.id,
        serverTime: new Date().toISOString(),
      });

      this.logger.log(
        `Client connected successfully: ${client.id} (user: ${payload.userId}, conversation: ${conversationId})`,
      );
    } catch (error) {
      this.logger.error('Connection error:', error);
      this.emitError(
        client,
        'WS_ERR_005',
        'Internal server error during connection',
      );
      client.disconnect();
    }
  }

  /**
   * Handle client disconnection
   */
  async handleDisconnect(client: Socket) {
    const clientData = client.data as ClientData;

    if (clientData) {
      this.logger.log(
        `Client disconnected: ${client.id} (user: ${clientData.userId}, conversation: ${clientData.conversationId})`,
      );

      // Leave conversation room
      await client.leave(`conversation:${clientData.conversationId}`);

      // TODO: Cleanup streaming resources
      // await this.streamingHandler.stopStream(client.id);
    } else {
      this.logger.log(`Client disconnected: ${client.id} (no session data)`);
    }
  }

  /**
   * Emit error to client
   * @private
   */
  private emitError(
    client: Socket,
    code: string,
    message: string,
    recoverable = false,
  ): void {
    client.emit('error', {
      code,
      message,
      recoverable,
      action: recoverable ? 'retry' : 'reconnect',
    });
  }

  /**
   * Handle incoming message (placeholder)
   */
  @SubscribeMessage('message')
  handleMessage(
    @ConnectedSocket() _client: Socket,
    @MessageBody() _payload: unknown,
  ): string {
    return 'Hello world!';
  }

  /**
   * Handle incoming audio stream
   */
  @SubscribeMessage('audio_stream')
  handleAudioStream(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { chunk: string; sequence: number; isFinal?: boolean },
  ) {
    try {
      const clientData = client.data as ClientData;
      if (!clientData) {
        this.emitError(client, 'WS_ERR_006', 'No session data');
        return;
      }

      // Decode Base64 audio chunk
      const audioBuffer = Buffer.from(data.chunk, 'base64');

      // TODO: Validate audio format (16kHz, mono)
      // TODO: Process through AIOrchestrator
      // const context = this.buildContext(clientData);
      // for await (const response of this.orchestrator.processAudioStream(audioBuffer, context)) {
      //   client.emit(response.type, response.data);
      // }

      // Mock implementation - echo back text result
      client.emit('text_result', {
        text: 'Mock transcription result',
        isFinal: data.isFinal || false,
        confidence: 0.95,
        timestamp: new Date().toISOString(),
      });

      this.logger.debug(
        `Audio stream chunk received: ${audioBuffer.length} bytes, sequence: ${data.sequence}`,
      );
    } catch (error) {
      this.logger.error('Audio stream error:', error);
      this.emitError(
        client,
        'WS_ERR_007',
        'Failed to process audio stream',
        true,
      );
    }
  }

  /**
   * Handle interrupt signal (user starts speaking during AI response)
   */
  @SubscribeMessage('interrupt')
  handleInterrupt(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { reason: string },
  ) {
    try {
      const clientData = client.data as ClientData;
      if (!clientData) {
        return;
      }

      this.logger.log(`Interrupt requested: ${data.reason}`);

      // TODO: Stop AI response streaming
      // await this.streamingHandler.stopStream(client.id);

      client.emit('interrupted', {
        message: 'AI response stopped',
      });
    } catch (error) {
      this.logger.error('Interrupt error:', error);
    }
  }

  /**
   * Stream AI response to client
   * @private
   */
  private async streamResponse(
    client: Socket,
    responseGenerator: AsyncGenerator<unknown>,
  ) {
    let sequence = 0;
    const responseId = this.generateResponseId();

    try {
      for await (const rawResponse of responseGenerator) {
        const response = rawResponse as {
          type: string;
          data: Record<string, any>;
        };
        switch (response.type) {
          case 'ai_response_start':
            client.emit('ai_response_start', { responseId });
            break;

          case 'ai_response_audio':
            client.emit('ai_response_audio', {
              chunk: (response.data.chunk as Buffer).toString('base64'),
              sequence: sequence++,
            });
            break;

          case 'ai_response_end':
            client.emit('ai_response_end', {
              responseId,
              text: (response.data.text as string) || '',
            });
            break;

          case 'correction':
            client.emit('correction', { corrections: response.data });
            break;

          case 'suggestion':
            client.emit('suggestion', response.data);
            break;

          default:
            this.logger.warn(`Unknown response type: ${response.type}`);
        }
      }
    } catch (error) {
      this.logger.error('Response streaming error:', error);
      this.emitError(
        client,
        'WS_ERR_008',
        'Failed to stream AI response',
        true,
      );
    }
  }

  /**
   * Generate unique response ID
   * @private
   */
  private generateResponseId(): string {
    return `resp_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
}
