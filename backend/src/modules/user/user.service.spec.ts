import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException, UnauthorizedException } from '@nestjs/common';
import { UserService } from './user.service';
import { UserRepository } from './user.repository';
import { CacheService } from '../../cache/cache.service';
import { Level, League } from '@prisma/client';
import * as bcrypt from 'bcrypt';

jest.mock('bcrypt');

describe('UserService', () => {
  let service: UserService;
  let repository: jest.Mocked<UserRepository>;
  let cacheService: jest.Mocked<CacheService>;

  const mockUser = {
    id: 'user-123',
    email: 'test@example.com',
    username: 'testuser',
    passwordHash: 'hashed-password',
    level: Level.BEGINNER,
    totalXp: 500,
    currentLevelXp: 500,
    league: League.BRONZE,
    aiSpeed: 1.0,
    confirmationMode: true,
    isVerified: true,
    lastLoginAt: new Date(),
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  const mockUserDto = {
    id: mockUser.id,
    email: mockUser.email,
    username: mockUser.username,
    level: mockUser.level,
    totalXp: mockUser.totalXp,
    currentLevelXp: mockUser.currentLevelXp,
    nextLevelXp: 1000,
    league: mockUser.league,
    aiSpeed: mockUser.aiSpeed,
    confirmationMode: mockUser.confirmationMode,
    isVerified: mockUser.isVerified,
    createdAt: mockUser.createdAt,
  };

  beforeEach(async () => {
    const mockUserRepository = {
      findById: jest.fn(),
      findByEmail: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
      getStats: jest.fn(),
    };

    const mockCacheService = {
      get: jest.fn(),
      set: jest.fn(),
      del: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: UserRepository,
          useValue: mockUserRepository,
        },
        {
          provide: CacheService,
          useValue: mockCacheService,
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
    repository = module.get(UserRepository);
    cacheService = module.get(CacheService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getProfile', () => {
    it('should return user data from cache if available', async () => {
      cacheService.get.mockResolvedValue(mockUserDto);

      const result = await service.getProfile(mockUser.id);

      expect(result).toEqual(mockUserDto);
      expect(cacheService.get).toHaveBeenCalledWith(`user:${mockUser.id}`);
      expect(repository.findById).not.toHaveBeenCalled();
    });

    it('should fetch from repository and cache if not cached', async () => {
      cacheService.get.mockResolvedValue(null);
      repository.findById.mockResolvedValue(mockUser);

      const result = await service.getProfile(mockUser.id);

      expect(result).toEqual(mockUserDto);
      expect(cacheService.get).toHaveBeenCalledWith(`user:${mockUser.id}`);
      expect(repository.findById).toHaveBeenCalledWith(mockUser.id);
      expect(cacheService.set).toHaveBeenCalledWith(
        `user:${mockUser.id}`,
        mockUserDto,
        300000,
      );
    });

    it('should throw NotFoundException for invalid user', async () => {
      cacheService.get.mockResolvedValue(null);
      repository.findById.mockResolvedValue(null);

      await expect(service.getProfile('invalid-id')).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should handle null username', async () => {
      const userWithNullUsername = { ...mockUser, username: null };
      cacheService.get.mockResolvedValue(null);
      repository.findById.mockResolvedValue(userWithNullUsername);

      const result = await service.getProfile(mockUser.id);

      expect(result.username).toBe('');
    });

    it('should calculate nextLevelXp correctly for BEGINNER', async () => {
      cacheService.get.mockResolvedValue(null);
      repository.findById.mockResolvedValue(mockUser);

      const result = await service.getProfile(mockUser.id);

      expect(result.nextLevelXp).toBe(1000);
    });

    it('should calculate nextLevelXp correctly for INTERMEDIATE', async () => {
      const intermediateUser = { ...mockUser, level: Level.INTERMEDIATE };
      cacheService.get.mockResolvedValue(null);
      repository.findById.mockResolvedValue(intermediateUser);

      const result = await service.getProfile(mockUser.id);

      expect(result.nextLevelXp).toBe(3500);
    });
  });

  describe('updateProfile', () => {
    const updateDto = {
      username: 'newusername',
      aiSpeed: 1.5,
      confirmationMode: false,
    };

    it('should update user profile successfully', async () => {
      const updatedUser = { ...mockUser, ...updateDto };
      repository.findById.mockResolvedValue(mockUser);
      repository.update.mockResolvedValue(updatedUser);

      const result = await service.updateProfile(mockUser.id, updateDto);

      expect(repository.findById).toHaveBeenCalledWith(mockUser.id);
      expect(repository.update).toHaveBeenCalledWith(mockUser.id, updateDto);
      expect(result.username).toBe(updateDto.username);
      expect(result.aiSpeed).toBe(updateDto.aiSpeed);
      expect(result.confirmationMode).toBe(updateDto.confirmationMode);
    });

    it('should invalidate cache after update', async () => {
      const updatedUser = { ...mockUser, ...updateDto };
      repository.findById.mockResolvedValue(mockUser);
      repository.update.mockResolvedValue(updatedUser);

      await service.updateProfile(mockUser.id, updateDto);

      expect(cacheService.del).toHaveBeenCalledWith(`user:${mockUser.id}`);
    });

    it('should throw NotFoundException for invalid user', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(
        service.updateProfile('invalid-id', updateDto),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('updateSettings', () => {
    const settingsDto = {
      aiSpeed: 2.0,
      confirmationMode: false,
    };

    it('should update settings successfully', async () => {
      const updatedUser = { ...mockUser, ...settingsDto };
      repository.findById.mockResolvedValue(mockUser);
      repository.update.mockResolvedValue(updatedUser);

      const result = await service.updateSettings(mockUser.id, settingsDto);

      expect(repository.update).toHaveBeenCalledWith(mockUser.id, settingsDto);
      expect(result.aiSpeed).toBe(settingsDto.aiSpeed);
      expect(result.confirmationMode).toBe(settingsDto.confirmationMode);
    });

    it('should invalidate cache after update', async () => {
      const updatedUser = { ...mockUser, ...settingsDto };
      repository.findById.mockResolvedValue(mockUser);
      repository.update.mockResolvedValue(updatedUser);

      await service.updateSettings(mockUser.id, settingsDto);

      expect(cacheService.del).toHaveBeenCalledWith(`user:${mockUser.id}`);
    });
  });

  describe('changePassword', () => {
    const changePasswordDto = {
      currentPassword: 'old-password',
      newPassword: 'new-password',
    };

    beforeEach(() => {
      (bcrypt.compare as jest.Mock).mockResolvedValue(true);
      (bcrypt.hash as jest.Mock).mockResolvedValue('new-hashed-password');
    });

    it('should verify current password before changing', async () => {
      repository.findById.mockResolvedValue(mockUser);

      await service.changePassword(mockUser.id, changePasswordDto);

      expect(bcrypt.compare).toHaveBeenCalledWith(
        changePasswordDto.currentPassword,
        mockUser.passwordHash,
      );
    });

    it('should throw UnauthorizedException for invalid current password', async () => {
      repository.findById.mockResolvedValue(mockUser);
      (bcrypt.compare as jest.Mock).mockResolvedValue(false);

      await expect(
        service.changePassword(mockUser.id, changePasswordDto),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('should throw UnauthorizedException for OAuth users (no password)', async () => {
      const oauthUser = { ...mockUser, passwordHash: null };
      repository.findById.mockResolvedValue(oauthUser);

      await expect(
        service.changePassword(mockUser.id, changePasswordDto),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('should hash new password and update', async () => {
      repository.findById.mockResolvedValue(mockUser);

      await service.changePassword(mockUser.id, changePasswordDto);

      expect(bcrypt.hash).toHaveBeenCalledWith(
        changePasswordDto.newPassword,
        10,
      );
      expect(repository.update).toHaveBeenCalledWith(mockUser.id, {
        passwordHash: 'new-hashed-password',
      });
    });

    it('should invalidate cache after password change', async () => {
      repository.findById.mockResolvedValue(mockUser);

      await service.changePassword(mockUser.id, changePasswordDto);

      expect(cacheService.del).toHaveBeenCalledWith(`user:${mockUser.id}`);
    });

    it('should throw NotFoundException for invalid user', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(
        service.changePassword('invalid-id', changePasswordDto),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('getStats', () => {
    const mockStats = {
      streak: {
        current: 5,
        longest: 10,
        freezeRemaining: 2,
      },
      xp: {
        total: 1500,
        thisWeek: 300,
        level: 1,
      },
      conversations: {
        total: 25,
        thisWeek: 5,
        averageDuration: 120,
      },
      pronunciation: {
        averageScore: 85,
        trend: 'up' as const,
      },
      vocabulary: {
        total: 50,
        dueForReview: 10,
      },
    };

    it('should return user statistics from repository', async () => {
      repository.findById.mockResolvedValue(mockUser);
      repository.getStats.mockResolvedValue(mockStats);

      const result = await service.getStats(mockUser.id);

      expect(result).toEqual(mockStats);
      expect(repository.getStats).toHaveBeenCalledWith(mockUser.id);
    });

    it('should throw NotFoundException for invalid user', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(service.getStats('invalid-id')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
