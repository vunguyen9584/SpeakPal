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
    const { token } = client.handshake.auth;

    if (!token) {
      return false;
    }

    try {
      const payload = this.jwtService.verify(token, {
        secret: this.configService.get('WS_JWT_SECRET'),
        maxAge: '1h', // Short-lived token
      });

      client.data.userId = payload.userId;
      client.data.conversationId = payload.conversationId;

      return true;
    } catch (error) {
      return false;
    }
  }
}
