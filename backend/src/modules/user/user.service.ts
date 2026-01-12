import {
  Injectable,
  NotFoundException,
  UnauthorizedException,
  BadRequestException,
} from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import * as fs from 'fs';
import * as path from 'path';
import { UserRepository } from './user.repository';
import { CacheService } from '../../cache/cache.service';
import { UserDto } from './dto/user.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { UpdateSettingsDto } from './dto/update-settings.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { UserStatsDto } from './dto/user-stats.dto';

@Injectable()
export class UserService {
  constructor(
    private userRepository: UserRepository,
    private cacheService: CacheService,
  ) { }

  async getProfile(userId: string): Promise<UserDto> {
    // Check cache first
    const cacheKey = `user:${userId}`;
    const cached = await this.cacheService.get<UserDto>(cacheKey);
    if (cached) {
      return cached;
    }

    // Get user from database
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Build UserDto
    const userDto: UserDto = {
      id: user.id,
      email: user.email,
      username: user.username || '',
      level: user.level,
      totalXp: user.totalXp,
      currentLevelXp: user.currentLevelXp,
      nextLevelXp: this.calculateNextLevelXp(user.level),
      league: user.league,
      aiSpeed: user.aiSpeed,
      confirmationMode: user.confirmationMode,
      isVerified: user.isVerified,
      createdAt: user.createdAt,
    };

    // Cache for 5 minutes (300 seconds)
    await this.cacheService.set(cacheKey, userDto, 300000);

    return userDto;
  }

  async updateProfile(userId: string, dto: UpdateProfileDto): Promise<UserDto> {
    // Verify user exists
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Update user
    const updatedUser = await this.userRepository.update(userId, dto);

    // Invalidate cache
    await this.cacheService.del(`user:${userId}`);

    // Build and return UserDto
    return {
      id: updatedUser.id,
      email: updatedUser.email,
      username: updatedUser.username || '',
      level: updatedUser.level,
      totalXp: updatedUser.totalXp,
      currentLevelXp: updatedUser.currentLevelXp,
      nextLevelXp: this.calculateNextLevelXp(updatedUser.level),
      league: updatedUser.league,
      aiSpeed: updatedUser.aiSpeed,
      confirmationMode: updatedUser.confirmationMode,
      isVerified: updatedUser.isVerified,
      createdAt: updatedUser.createdAt,
    };
  }

  async updateSettings(
    userId: string,
    dto: UpdateSettingsDto,
  ): Promise<UserDto> {
    // Verify user exists
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Update settings
    const updatedUser = await this.userRepository.update(userId, dto);

    // Invalidate cache
    await this.cacheService.del(`user:${userId}`);

    // Build and return UserDto
    return {
      id: updatedUser.id,
      email: updatedUser.email,
      username: updatedUser.username || '',
      level: updatedUser.level,
      totalXp: updatedUser.totalXp,
      currentLevelXp: updatedUser.currentLevelXp,
      nextLevelXp: this.calculateNextLevelXp(updatedUser.level),
      league: updatedUser.league,
      aiSpeed: updatedUser.aiSpeed,
      confirmationMode: updatedUser.confirmationMode,
      isVerified: updatedUser.isVerified,
      createdAt: updatedUser.createdAt,
    };
  }

  async changePassword(userId: string, dto: ChangePasswordDto): Promise<void> {
    // Get user
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Check if user has a password (OAuth users might not have one)
    if (!user.passwordHash) {
      throw new UnauthorizedException(
        'Cannot change password for OAuth accounts',
      );
    }

    // Verify current password
    const isPasswordValid = await bcrypt.compare(
      dto.currentPassword,
      user.passwordHash,
    );

    if (!isPasswordValid) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    // Hash new password
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(dto.newPassword, saltRounds);

    // Update password
    await this.userRepository.update(userId, {
      passwordHash: hashedPassword,
    });

    // Invalidate cache
    await this.cacheService.del(`user:${userId}`);
  }

  async uploadAvatar(userId: string, file: Express.Multer.File): Promise<string> {
    if (!file) {
      throw new BadRequestException('No file uploaded');
    }

    // Validate file type
    const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/jpg'];
    if (!allowedMimeTypes.includes(file.mimetype)) {
      throw new BadRequestException('Only JPEG and PNG images are allowed');
    }

    // Validate file size (max 5MB)
    const maxSize = 5 * 1024 * 1024; // 5MB
    if (file.size > maxSize) {
      throw new BadRequestException('File size must be less than 5MB');
    }

    // Generate unique filename
    const timestamp = Date.now();
    const ext = path.extname(file.originalname);
    const filename = `avatar-${userId}-${timestamp}${ext}`;

    // Create uploads directory if it doesn't exist
    const uploadsDir = path.join(process.cwd(), 'uploads', 'avatars');
    if (!fs.existsSync(uploadsDir)) {
      fs.mkdirSync(uploadsDir, { recursive: true });
    }

    // Save file
    const filepath = path.join(uploadsDir, filename);
    fs.writeFileSync(filepath, file.buffer);

    // Generate URL (in production, this would be a CDN URL or S3 URL)
    const avatarUrl = `/uploads/avatars/${filename}`;

    // TODO: Add avatarUrl field to User schema and uncomment this
    // await this.userRepository.update(userId, { avatarUrl });
    // await this.cacheService.del(`user:${userId}`);

    return avatarUrl;
  }

  async getStats(userId: string): Promise<UserStatsDto> {
    // Verify user exists
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Delegate to repository
    return this.userRepository.getStats(userId);
  }

  /**
   * Calculate XP required for next level based on current level
   */
  private calculateNextLevelXp(level: string): number {
    const xpMap: Record<string, number> = {
      BEGINNER: 1000,
      ELEMENTARY: 2000,
      INTERMEDIATE: 3500,
      UPPER_INTERMEDIATE: 5000,
      ADVANCED: 10000,
    };

    return xpMap[level] || 1000;
  }
}
