import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { Request } from 'express';
import { JwtRefreshPayload } from '../interfaces/jwt-payload.interface';

@Injectable()
export class JwtRefreshStrategy extends PassportStrategy(
  Strategy,
  'jwt-refresh',
) {
  constructor(private configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey:
        configService.get<string>('JWT_REFRESH_SECRET') ||
        'fallback-refresh-secret-for-development',
      passReqToCallback: true,
    });
  }

  async validate(req: Request, payload: JwtRefreshPayload) {
    if (!payload.sub || !payload.tokenId) {
      throw new UnauthorizedException('Invalid refresh token payload');
    }

    const refreshToken = req
      ?.get('authorization')
      ?.replace('Bearer', '')
      .trim();

    if (!refreshToken) {
      throw new UnauthorizedException('Refresh token not found');
    }

    return {
      userId: payload.sub,
      tokenId: payload.tokenId,
      refreshToken,
    };
  }
}
