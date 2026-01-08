import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { InvitationService } from '../invitation/invitation.service';
import { InvitationRepository } from '../invitation/invitation.repository';

describe('InvitationService', () => {
  let service: InvitationService;
  let repository: InvitationRepository;

  const mockInvitationRepository = {
    create: jest.fn(),
    findByCode: jest.fn(),
    findByUserId: jest.fn(),
    recordReferral: jest.fn(),
    getReferralCount: jest.fn(),
    getReferrals: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        InvitationService,
        {
          provide: InvitationRepository,
          useValue: mockInvitationRepository,
        },
      ],
    }).compile();

    service = module.get<InvitationService>(InvitationService);
    repository = module.get<InvitationRepository>(InvitationRepository);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('generateInviteCode', () => {
    it('should generate a unique 8-character invite code', async () => {
      const userId = 'user-123';
      const mockInvitation = {
        id: 'inv-123',
        userId,
        code: 'ABC12345',
        maxUsage: 10,
        usageCount: 0,
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
        createdAt: new Date(),
      };

      mockInvitationRepository.create.mockResolvedValue(mockInvitation);

      const result = await service.generateInviteCode(userId);

      expect(result).toBeDefined();
      expect(result.inviteCode).toBe('ABC12345');
      expect(result.maxUsage).toBe(10);
      expect(mockInvitationRepository.create).toHaveBeenCalledWith(
        expect.objectContaining({
          userId,
          maxUsage: 10,
        }),
      );
    });

    it('should respect custom maxUsage and expiryDays', async () => {
      const userId = 'user-123';
      const dto = { maxUsage: 5, expiryDays: 7 };
      const mockInvitation = {
        id: 'inv-123',
        userId,
        code: 'XYZ78910',
        maxUsage: 5,
        usageCount: 0,
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        createdAt: new Date(),
      };

      mockInvitationRepository.create.mockResolvedValue(mockInvitation);

      const result = await service.generateInviteCode(userId, dto);

      expect(result.maxUsage).toBe(5);
      expect(mockInvitationRepository.create).toHaveBeenCalledWith(
        expect.objectContaining({
          maxUsage: 5,
        }),
      );
    });

    it('should generate invite URL with base URL', async () => {
      process.env.APP_URL = 'https://speakpal.app';
      const userId = 'user-123';
      const mockInvitation = {
        id: 'inv-123',
        userId,
        code: 'TEST1234',
        maxUsage: 10,
        usageCount: 0,
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
        createdAt: new Date(),
      };

      mockInvitationRepository.create.mockResolvedValue(mockInvitation);

      const result = await service.generateInviteCode(userId);

      expect(result.inviteUrl).toBe('https://speakpal.app/invite/TEST1234');
    });
  });

  describe('acceptInvitation', () => {
    it('should accept valid invitation and record referral', async () => {
      const code = 'ABC12345';
      const inviterId = 'user-123';
      const newUserId = 'user-456';
      const mockInvitation = {
        id: 'inv-123',
        userId: inviterId,
        code,
        maxUsage: 10,
        usageCount: 0,
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
      };

      mockInvitationRepository.findByCode.mockResolvedValue(mockInvitation);
      mockInvitationRepository.recordReferral.mockResolvedValue({});
      mockInvitationRepository.getReferralCount.mockResolvedValue(1);

      await service.acceptInvitation(code, newUserId);

      expect(mockInvitationRepository.findByCode).toHaveBeenCalledWith(code);
      expect(mockInvitationRepository.recordReferral).toHaveBeenCalledWith(
        'inv-123',
        newUserId,
      );
    });

    it('should throw NotFoundException for invalid code', async () => {
      const code = 'INVALID';
      const newUserId = 'user-456';

      mockInvitationRepository.findByCode.mockResolvedValue(null);

      await expect(service.acceptInvitation(code, newUserId)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw BadRequestException if max usage reached', async () => {
      const code = 'ABC12345';
      const newUserId = 'user-456';
      const mockInvitation = {
        id: 'inv-123',
        userId: 'user-123',
        code,
        maxUsage: 10,
        usageCount: 10,
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
      };

      mockInvitationRepository.findByCode.mockResolvedValue(mockInvitation);

      await expect(service.acceptInvitation(code, newUserId)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw BadRequestException if invitation expired', async () => {
      const code = 'ABC12345';
      const newUserId = 'user-456';
      const mockInvitation = {
        id: 'inv-123',
        userId: 'user-123',
        code,
        maxUsage: 10,
        usageCount: 0,
        expiresAt: new Date(Date.now() - 1000), // Expired
      };

      mockInvitationRepository.findByCode.mockResolvedValue(mockInvitation);

      await expect(service.acceptInvitation(code, newUserId)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw BadRequestException for self-invitation', async () => {
      const code = 'ABC12345';
      const userId = 'user-123';
      const mockInvitation = {
        id: 'inv-123',
        userId,
        code,
        maxUsage: 10,
        usageCount: 0,
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
      };

      mockInvitationRepository.findByCode.mockResolvedValue(mockInvitation);

      await expect(service.acceptInvitation(code, userId)).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('getUserInvitations', () => {
    it('should return all user invitations', async () => {
      const userId = 'user-123';
      const mockInvitations = [
        {
          id: 'inv-1',
          userId,
          code: 'CODE001',
          maxUsage: 10,
          usageCount: 3,
          expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
          createdAt: new Date(),
        },
        {
          id: 'inv-2',
          userId,
          code: 'CODE002',
          maxUsage: 10,
          usageCount: 5,
          expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
          createdAt: new Date(),
        },
      ];

      mockInvitationRepository.findByUserId.mockResolvedValue(mockInvitations);

      const result = await service.getUserInvitations(userId);

      expect(result).toHaveLength(2);
      expect(result[0].inviteCode).toBe('CODE001');
      expect(result[1].inviteCode).toBe('CODE002');
    });
  });

  describe('getReferralStats', () => {
    it('should return referral statistics with rewards', async () => {
      const userId = 'user-123';
      const mockReferrals = [
        {
          id: 'ref-1',
          referredUser: {
            id: 'user-456',
            email: 'user456@example.com',
            displayName: 'User 456',
            avatar: null,
          },
          createdAt: new Date(),
        },
      ];

      mockInvitationRepository.getReferralCount.mockResolvedValue(1);
      mockInvitationRepository.getReferrals.mockResolvedValue(mockReferrals);

      const result = await service.getReferralStats(userId);

      expect(result.totalReferrals).toBe(1);
      expect(result.referrals).toHaveLength(1);
      expect(result.rewards).toBeDefined();
      expect(result.rewards.some((r) => r.type === 'streak_freeze')).toBe(true);
    });

    it('should calculate rewards correctly for 5 referrals', async () => {
      const userId = 'user-123';
      mockInvitationRepository.getReferralCount.mockResolvedValue(5);
      mockInvitationRepository.getReferrals.mockResolvedValue([]);

      const result = await service.getReferralStats(userId);

      expect(result.totalReferrals).toBe(5);
      const bonusXPReward = result.rewards.find((r) => r.type === 'bonus_xp');
      expect(bonusXPReward?.unlocked).toBe(true);
    });

    it('should calculate rewards correctly for 10 referrals', async () => {
      const userId = 'user-123';
      mockInvitationRepository.getReferralCount.mockResolvedValue(10);
      mockInvitationRepository.getReferrals.mockResolvedValue([]);

      const result = await service.getReferralStats(userId);

      expect(result.totalReferrals).toBe(10);
      const premiumTrialReward = result.rewards.find(
        (r) => r.type === 'premium_trial',
      );
      expect(premiumTrialReward?.unlocked).toBe(true);
    });
  });
});
