import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { Socket } from 'socket.io';

@Injectable()
export class WsAuthGuard implements CanActivate {
  constructor(
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  canActivate(context: ExecutionContext): boolean {
    const client = context.switchToWs().getClient<Socket>();
    const auth = client.handshake.auth as Record<string, unknown>;
    const token = auth.token as string | undefined;

    if (!token) {
      return false;
    }

    try {
      const payload = this.jwtService.verify<{
        userId: string;
        conversationId: string;
      }>(token, {
        secret: this.configService.get<string>('WS_JWT_SECRET'),
        maxAge: '1h', // Short-lived token
      });

      const clientData = client.data as Record<string, unknown>;
      clientData.userId = payload.userId;
      clientData.conversationId = payload.conversationId;

      return true;
    } catch (error) {
      return false;
    }
  }
}
