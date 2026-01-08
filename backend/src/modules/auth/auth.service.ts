import {
  Injectable,
  ConflictException,
  UnauthorizedException,
  BadRequestException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import * as crypto from 'crypto';
import { PrismaService } from '../../prisma/prisma.service';
import { CacheService } from '../../cache/cache.service';
import { FirebaseService } from '../../integrations/firebase/firebase.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { TokenDto } from './dto/token.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { OAuthDto } from './dto/oauth.dto';
import {
  JwtPayload,
  JwtRefreshPayload,
} from './interfaces/jwt-payload.interface';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private cacheService: CacheService,
    private firebaseService: FirebaseService,
  ) {}

  async register(dto: RegisterDto): Promise<TokenDto> {
    // Check if email already exists
    const existingUser = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (existingUser) {
      throw new ConflictException('Email already exists');
    }

    // Check if username already exists (if provided)
    if (dto.username) {
      const existingUsername = await this.prisma.user.findFirst({
        where: { username: dto.username },
      });

      if (existingUsername) {
        throw new ConflictException('Username already exists');
      }
    }

    // Hash password
    const hashedPassword = await this.hashPassword(dto.password);

    // Create user with default values
    const user = await this.prisma.user.create({
      data: {
        email: dto.email,
        username: dto.username,
        passwordHash: hashedPassword,
        level: 'BEGINNER', // Default level
        totalXp: 0,
        currentLevelXp: 0,
        league: 'BRONZE', // Default league
        aiSpeed: 1.0, // Normal speed
        confirmationMode: true, // Default to confirmation mode
        isVerified: false,
      },
    });

    // Generate tokens
    const tokens = await this.generateTokens(user.id, user.email);

    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresIn: tokens.expiresIn,
      user: {
        id: user.id,
        email: user.email,
        username: user.username || '',
        level: user.level,
        totalXp: user.totalXp,
      },
    };
  }

  async login(dto: LoginDto): Promise<TokenDto> {
    // Find user by email
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (!user || !user.passwordHash) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Verify password
    const isPasswordValid = await this.verifyPassword(
      dto.password,
      user.passwordHash,
    );

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Update last login timestamp
    await this.prisma.user.update({
      where: { id: user.id },
      data: { lastLoginAt: new Date() },
    });

    // Generate tokens
    const tokens = await this.generateTokens(user.id, user.email);

    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresIn: tokens.expiresIn,
      user: {
        id: user.id,
        email: user.email,
        username: user.username || '',
        level: user.level,
        totalXp: user.totalXp,
      },
    };
  }

  async logout(userId: string, refreshToken: string): Promise<void> {
    // Validate that the user exists
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid user');
    }

    // Decode the refresh token to get the tokenId
    try {
      const decoded = this.jwtService.verify<JwtRefreshPayload>(refreshToken, {
        secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      });

      // Add the refresh token to blacklist in Redis
      // TTL should match the token's remaining lifetime
      const now = Math.floor(Date.now() / 1000);
      const expirySeconds = decoded.exp ? decoded.exp - now : 604800; // Default 7 days if no exp

      if (expirySeconds > 0) {
        await this.cacheService.set(
          `blacklist:${decoded.tokenId}`,
          '1',
          expirySeconds * 1000, // Convert to milliseconds for cache-manager
        );
      }
    } catch (error) {
      // If token is invalid or expired, no need to blacklist
      // Just return successfully
    }
  }

  async refreshTokens(refreshToken: string): Promise<TokenDto> {
    // Verify the refresh token
    let decoded: JwtRefreshPayload;
    try {
      decoded = this.jwtService.verify<JwtRefreshPayload>(refreshToken, {
        secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      });
    } catch (error) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    // Check if token is blacklisted
    const isBlacklisted = await this.cacheService.get(
      `blacklist:${decoded.tokenId}`,
    );

    if (isBlacklisted) {
      throw new UnauthorizedException('Refresh token has been revoked');
    }

    // Get user from database
    const user = await this.prisma.user.findUnique({
      where: { id: decoded.sub },
    });

    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    // Blacklist the old refresh token (rotation)
    const now = Math.floor(Date.now() / 1000);
    const expirySeconds = decoded.exp ? decoded.exp - now : 604800;

    if (expirySeconds > 0) {
      await this.cacheService.set(
        `blacklist:${decoded.tokenId}`,
        '1',
        expirySeconds * 1000,
      );
    }

    // Generate new tokens
    const tokens = await this.generateTokens(user.id, user.email);

    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresIn: tokens.expiresIn,
      user: {
        id: user.id,
        email: user.email,
        username: user.username || '',
        level: user.level,
        totalXp: user.totalXp,
      },
    };
  }

  async forgotPassword(dto: ForgotPasswordDto): Promise<void> {
    // Find user by email
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    // Always return success to prevent email enumeration
    if (!user) {
      // Log for debugging but don't reveal to user
      console.log(
        `Password reset requested for non-existent email: ${dto.email}`,
      );
      return;
    }

    // Generate secure reset token
    const resetToken = crypto.randomBytes(32).toString('hex');

    // Store reset token in Redis with 15 minutes expiry
    const resetKey = `password-reset:${resetToken}`;
    await this.cacheService.set(resetKey, user.id, 15 * 60 * 1000); // 15 minutes

    // TODO: Implement email service integration
    // In production, send email with reset link instead of logging
    // Example implementation:
    // const resetLink = `${this.configService.get('FRONTEND_URL')}/reset-password?token=${resetToken}`;
    // await this.emailService.sendPasswordResetEmail({
    //   to: user.email,
    //   subject: 'Password Reset Request',
    //   resetLink: resetLink,
    //   expiresIn: '15 minutes',
    // });

    // TEMPORARY: Log to console (REMOVE IN PRODUCTION)
    console.log(`Password reset token for ${user.email}: ${resetToken}`);
    console.log(
      `Reset link: ${this.configService.get('FRONTEND_URL')}/reset-password?token=${resetToken}`,
    );
  }

  async resetPassword(dto: ResetPasswordDto): Promise<void> {
    // Verify reset token exists in Redis
    const resetKey = `password-reset:${dto.token}`;
    const userId = await this.cacheService.get<string>(resetKey);

    if (!userId) {
      throw new BadRequestException('Invalid or expired reset token');
    }

    // Get user
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new BadRequestException('User not found');
    }

    // Hash new password
    const hashedPassword = await this.hashPassword(dto.newPassword);

    // Update user password
    await this.prisma.user.update({
      where: { id: userId },
      data: { passwordHash: hashedPassword },
    });

    // Delete the reset token from Redis
    await this.cacheService.del(resetKey);

    // Invalidate all existing refresh tokens by adding user to a "force logout" list
    // Any tokens issued before this timestamp should be invalidated
    const forceLogoutKey = `force-logout:${userId}`;
    await this.cacheService.set(
      forceLogoutKey,
      Date.now().toString(),
      30 * 24 * 60 * 60 * 1000, // 30 days
    );

    // TODO: Implement password change notification email
    // Send email to notify user that their password was changed
    // await this.emailService.sendPasswordChangeNotification({
    //   to: user.email,
    //   username: user.username || user.email,
    //   timestamp: new Date(),
    // });

    // TODO: Implement security event logging
    // Log password reset event for security audit trail
    // await this.auditService.logSecurityEvent({
    //   userId: user.id,
    //   event: 'PASSWORD_RESET',
    //   ipAddress: requestIp,
    //   userAgent: requestUserAgent,
    //   timestamp: new Date(),
    // });

    // TEMPORARY: Log to console (REMOVE IN PRODUCTION)
    console.log(`Password reset successful for user: ${user.email}`);
  }

  async oauthLogin(dto: OAuthDto): Promise<TokenDto> {
    // Verify Firebase ID token
    const decodedToken = await this.firebaseService.verifyIdToken(dto.idToken);

    // Extract user info from Firebase token
    const { uid, email, name, picture } = decodedToken;

    if (!email) {
      throw new BadRequestException('Email not provided by OAuth provider');
    }

    // Check if user already exists
    let user = await this.prisma.user.findUnique({
      where: { email },
    });

    // Create new user if doesn't exist (OAuth registration)
    if (!user) {
      // Generate username from email or name
      let username = name || email.split('@')[0];

      // Ensure username is unique
      const existingUsername = await this.prisma.user.findFirst({
        where: { username },
      });

      if (existingUsername) {
        // Append random suffix to make unique
        username = `${username}_${crypto.randomBytes(4).toString('hex')}`;
      }

      user = await this.prisma.user.create({
        data: {
          email,
          username,
          passwordHash: null, // OAuth users don't have password
          level: 'BEGINNER',
          totalXp: 0,
          currentLevelXp: 0,
          league: 'BRONZE',
          aiSpeed: 1.0,
          confirmationMode: true,
          isVerified: true, // OAuth users are pre-verified
        },
      });

      console.log(`New OAuth user created: ${email} via ${dto.provider}`);
    }

    // Update last login timestamp
    await this.prisma.user.update({
      where: { id: user.id },
      data: { lastLoginAt: new Date() },
    });

    // Generate tokens
    const tokens = await this.generateTokens(user.id, user.email);

    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresIn: tokens.expiresIn,
      user: {
        id: user.id,
        email: user.email,
        username: user.username || '',
        level: user.level,
        totalXp: user.totalXp,
      },
    };
  }

  private async generateTokens(
    userId: string,
    email: string,
  ): Promise<{
    accessToken: string;
    refreshToken: string;
    expiresIn: number;
  }> {
    const tokenId = uuidv4(); // Unique ID for token rotation

    // Create access token payload
    const accessPayload: JwtPayload = {
      sub: userId,
      email: email,
    };

    // Create refresh token payload
    const refreshPayload: JwtRefreshPayload = {
      sub: userId,
      tokenId: tokenId,
    };

    const accessExpiresIn = this.configService.get<string>(
      'JWT_EXPIRES_IN',
      '15m',
    );
    const refreshExpiresIn = this.configService.get<string>(
      'JWT_REFRESH_EXPIRES_IN',
      '7d',
    );

    // Generate access token
    const accessToken = this.jwtService.sign(accessPayload, {
      secret: this.configService.get<string>('JWT_SECRET'),
      expiresIn: accessExpiresIn as `${number}${'ms' | 's' | 'm' | 'h' | 'd'}`,
    });

    // Generate refresh token
    const refreshToken = this.jwtService.sign(refreshPayload, {
      secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      expiresIn: refreshExpiresIn as `${number}${'ms' | 's' | 'm' | 'h' | 'd'}`,
    });

    // Parse expiresIn to seconds for the response
    const expiresIn = this.parseExpiresIn(accessExpiresIn);

    return {
      accessToken,
      refreshToken,
      expiresIn,
    };
  }

  private async hashPassword(password: string): Promise<string> {
    const saltRounds = 10;
    return bcrypt.hash(password, saltRounds);
  }

  private async verifyPassword(
    password: string,
    hashedPassword: string,
  ): Promise<boolean> {
    return bcrypt.compare(password, hashedPassword);
  }

  private parseExpiresIn(expiresIn: string): number {
    // Parse strings like '15m', '7d', '1h' into seconds
    const unit = expiresIn.slice(-1);
    const value = parseInt(expiresIn.slice(0, -1), 10);

    switch (unit) {
      case 's':
        return value;
      case 'm':
        return value * 60;
      case 'h':
        return value * 60 * 60;
      case 'd':
        return value * 24 * 60 * 60;
      default:
        return 900; // Default 15 minutes
    }
  }
}
