import { Test, TestingModule } from '@nestjs/testing';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { Level, League } from '@prisma/client';

describe('UserController', () => {
  let controller: UserController;
  let service: jest.Mocked<UserService>;

  const mockUserDto = {
    id: 'user-123',
    email: 'test@example.com',
    username: 'testuser',
    level: Level.BEGINNER,
    totalXp: 500,
    currentLevelXp: 500,
    nextLevelXp: 1000,
    league: League.BRONZE,
    aiSpeed: 1.0,
    confirmationMode: true,
    isVerified: true,
    createdAt: new Date(),
  };

  const mockStatsDto = {
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

  beforeEach(async () => {
    const mockUserService = {
      getProfile: jest.fn(),
      updateProfile: jest.fn(),
      updateSettings: jest.fn(),
      changePassword: jest.fn(),
      getStats: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [UserController],
      providers: [
        {
          provide: UserService,
          useValue: mockUserService,
        },
      ],
    }).compile();

    controller = module.get<UserController>(UserController);
    service = module.get(UserService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getProfile', () => {
    it('should return user profile', async () => {
      const user = { userId: 'user-123' };
      service.getProfile.mockResolvedValue(mockUserDto);

      const result = await controller.getProfile(user);

      expect(result).toEqual(mockUserDto);
      expect(service.getProfile).toHaveBeenCalledWith(user.userId);
    });
  });

  describe('updateProfile', () => {
    it('should update and return user profile', async () => {
      const user = { userId: 'user-123' };
      const updateDto = {
        username: 'newusername',
        aiSpeed: 1.5,
        confirmationMode: false,
      };
      const updatedUser = { ...mockUserDto, ...updateDto };
      service.updateProfile.mockResolvedValue(updatedUser);

      const result = await controller.updateProfile(user, updateDto);

      expect(result).toEqual(updatedUser);
      expect(service.updateProfile).toHaveBeenCalledWith(
        user.userId,
        updateDto,
      );
    });
  });

  describe('changePassword', () => {
    it('should change password', async () => {
      const user = { userId: 'user-123' };
      const changePasswordDto = {
        currentPassword: 'old-password',
        newPassword: 'new-password',
      };
      service.changePassword.mockResolvedValue(undefined);

      const result = await controller.changePassword(user, changePasswordDto);

      expect(result).toBeUndefined();
      expect(service.changePassword).toHaveBeenCalledWith(
        user.userId,
        changePasswordDto,
      );
    });
  });

  describe('getStats', () => {
    it('should return user statistics', async () => {
      const user = { userId: 'user-123' };
      service.getStats.mockResolvedValue(mockStatsDto);

      const result = await controller.getStats(user);

      expect(result).toEqual(mockStatsDto);
      expect(service.getStats).toHaveBeenCalledWith(user.userId);
    });
  });

  describe('updateSettings', () => {
    it('should update and return user settings', async () => {
      const user = { userId: 'user-123' };
      const settingsDto = {
        aiSpeed: 2.0,
        confirmationMode: false,
      };
      const updatedUser = { ...mockUserDto, ...settingsDto };
      service.updateSettings.mockResolvedValue(updatedUser);

      const result = await controller.updateSettings(user, settingsDto);

      expect(result).toEqual(updatedUser);
      expect(service.updateSettings).toHaveBeenCalledWith(
        user.userId,
        settingsDto,
      );
    });
  });
});
