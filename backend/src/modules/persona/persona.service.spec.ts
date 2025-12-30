import { Test, TestingModule } from '@nestjs/testing';
import {
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { PersonaService } from './persona.service';
import { PersonaRepository } from './persona.repository';
import { PrismaService } from '../../prisma/prisma.service';
import { Voice, Personality, Level, SubscriptionPlan } from '@prisma/client';

describe('PersonaService', () => {
  let service: PersonaService;
  let repository: jest.Mocked<PersonaRepository>;
  let prisma: jest.Mocked<PrismaService>;

  const mockUser = {
    id: 'user-123',
    email: 'test@example.com',
  };

  const mockPersona = {
    id: 'persona-123',
    userId: 'user-123',
    name: 'Test Persona',
    voice: Voice.VOICE_1,
    personality: Personality.CHEERFUL,
    targetLevel: Level.INTERMEDIATE,
    isDefault: false,
    createdAt: new Date(),
  };

  const mockFreeSubscription = {
    id: 'sub-123',
    userId: 'user-123',
    plan: SubscriptionPlan.FREE,
    dailyUsageCount: 0,
    dailyUsageLimit: 3,
  };

  const mockPremiumSubscription = {
    id: 'sub-456',
    userId: 'user-456',
    plan: SubscriptionPlan.PREMIUM,
    dailyUsageCount: 0,
    dailyUsageLimit: 100,
  };

  beforeEach(async () => {
    const mockPersonaRepository = {
      findById: jest.fn(),
      findByUserId: jest.fn(),
      countByUserId: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
      unsetAllDefaults: jest.fn(),
      findDefault: jest.fn(),
    };

    const mockPrismaService = {
      user: {
        findUnique: jest.fn(),
      },
      subscription: {
        findUnique: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PersonaService,
        {
          provide: PersonaRepository,
          useValue: mockPersonaRepository,
        },
        {
          provide: PrismaService,
          useValue: mockPrismaService,
        },
      ],
    }).compile();

    service = module.get<PersonaService>(PersonaService);
    repository = module.get(PersonaRepository);
    prisma = module.get(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    const createDto = {
      name: 'New Persona',
      voice: Voice.VOICE_2,
      personality: Personality.STRICT,
      targetLevel: Level.ADVANCED,
    };

    it('should create persona successfully', async () => {
      repository.countByUserId.mockResolvedValue(2);
      prisma.subscription.findUnique.mockResolvedValue(mockFreeSubscription);
      prisma.user.findUnique.mockResolvedValue(mockUser);
      repository.create.mockResolvedValue({
        ...mockPersona,
        ...createDto,
        isDefault: false,
      });

      const result = await service.create(mockUser.id, createDto);

      expect(repository.countByUserId).toHaveBeenCalledWith(mockUser.id);
      expect(prisma.subscription.findUnique).toHaveBeenCalledWith({
        where: { userId: mockUser.id },
      });
      expect(result.name).toBe(createDto.name);
      expect(result.isDefault).toBe(false);
    });

    it('should set first persona as default', async () => {
      repository.countByUserId.mockResolvedValue(0);
      prisma.subscription.findUnique.mockResolvedValue(mockFreeSubscription);
      prisma.user.findUnique.mockResolvedValue(mockUser);
      repository.create.mockResolvedValue({
        ...mockPersona,
        ...createDto,
        isDefault: true,
      });

      const result = await service.create(mockUser.id, createDto);

      expect(result.isDefault).toBe(true);
      expect(repository.create).toHaveBeenCalledWith(
        expect.objectContaining({
          isDefault: true,
        }),
      );
    });

    it('should enforce limit for free users (max 5)', async () => {
      repository.countByUserId.mockResolvedValue(5);
      prisma.subscription.findUnique.mockResolvedValue(mockFreeSubscription);

      await expect(service.create(mockUser.id, createDto)).rejects.toThrow(
        ForbiddenException,
      );
    });

    it('should allow unlimited personas for premium users', async () => {
      repository.countByUserId.mockResolvedValue(10);
      prisma.subscription.findUnique.mockResolvedValue(
        mockPremiumSubscription,
      );
      prisma.user.findUnique.mockResolvedValue(mockUser);
      repository.create.mockResolvedValue({
        ...mockPersona,
        ...createDto,
      });

      const result = await service.create(mockUser.id, createDto);

      expect(result).toBeDefined();
      expect(repository.create).toHaveBeenCalled();
    });

    it('should default to FREE plan if no subscription exists', async () => {
      repository.countByUserId.mockResolvedValue(4);
      prisma.subscription.findUnique.mockResolvedValue(null);
      prisma.user.findUnique.mockResolvedValue(mockUser);
      repository.create.mockResolvedValue({
        ...mockPersona,
        ...createDto,
      });

      const result = await service.create(mockUser.id, createDto);

      expect(result).toBeDefined();
    });

    it('should throw NotFoundException if user not found', async () => {
      repository.countByUserId.mockResolvedValue(0);
      prisma.subscription.findUnique.mockResolvedValue(mockFreeSubscription);
      prisma.user.findUnique.mockResolvedValue(null);

      await expect(service.create(mockUser.id, createDto)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('findAll', () => {
    it('should return all personas for user', async () => {
      const personas = [mockPersona, { ...mockPersona, id: 'persona-456' }];
      repository.findByUserId.mockResolvedValue(personas);

      const result = await service.findAll(mockUser.id);

      expect(result).toHaveLength(2);
      expect(repository.findByUserId).toHaveBeenCalledWith(mockUser.id);
    });

    it('should return empty array if no personas', async () => {
      repository.findByUserId.mockResolvedValue([]);

      const result = await service.findAll(mockUser.id);

      expect(result).toHaveLength(0);
    });
  });

  describe('findById', () => {
    it('should return persona by ID', async () => {
      repository.findById.mockResolvedValue(mockPersona);

      const result = await service.findById(mockUser.id, mockPersona.id);

      expect(result).toEqual(expect.objectContaining({ id: mockPersona.id }));
      expect(repository.findById).toHaveBeenCalledWith(mockPersona.id);
    });

    it('should throw NotFoundException for invalid persona', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(
        service.findById(mockUser.id, 'invalid-id'),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw NotFoundException for wrong owner', async () => {
      repository.findById.mockResolvedValue({
        ...mockPersona,
        userId: 'other-user',
      });

      await expect(
        service.findById(mockUser.id, mockPersona.id),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('update', () => {
    const updateDto = {
      name: 'Updated Name',
      voice: Voice.VOICE_3,
    };

    it('should update persona successfully', async () => {
      repository.findById.mockResolvedValue(mockPersona);
      repository.update.mockResolvedValue({
        ...mockPersona,
        ...updateDto,
      });

      const result = await service.update(
        mockUser.id,
        mockPersona.id,
        updateDto,
      );

      expect(result.name).toBe(updateDto.name);
      expect(repository.update).toHaveBeenCalledWith(mockPersona.id, updateDto);
    });

    it('should verify ownership before update', async () => {
      repository.findById.mockResolvedValue({
        ...mockPersona,
        userId: 'other-user',
      });

      await expect(
        service.update(mockUser.id, mockPersona.id, updateDto),
      ).rejects.toThrow(NotFoundException);

      expect(repository.update).not.toHaveBeenCalled();
    });
  });

  describe('delete', () => {
    it('should not delete default persona', async () => {
      repository.findById.mockResolvedValue({
        ...mockPersona,
        isDefault: true,
      });

      await expect(
        service.delete(mockUser.id, mockPersona.id),
      ).rejects.toThrow(BadRequestException);

      expect(repository.delete).not.toHaveBeenCalled();
    });

    it('should delete non-default persona successfully', async () => {
      repository.findById.mockResolvedValue({
        ...mockPersona,
        isDefault: false,
      });
      repository.delete.mockResolvedValue(mockPersona);

      await service.delete(mockUser.id, mockPersona.id);

      expect(repository.delete).toHaveBeenCalledWith(mockPersona.id);
    });

    it('should verify ownership before delete', async () => {
      repository.findById.mockResolvedValue({
        ...mockPersona,
        userId: 'other-user',
      });

      await expect(
        service.delete(mockUser.id, mockPersona.id),
      ).rejects.toThrow(NotFoundException);

      expect(repository.delete).not.toHaveBeenCalled();
    });
  });

  describe('setDefault', () => {
    it('should unset previous default and set new default', async () => {
      repository.findById.mockResolvedValue(mockPersona);
      repository.update.mockResolvedValue({
        ...mockPersona,
        isDefault: true,
      });

      const result = await service.setDefault(mockUser.id, mockPersona.id);

      expect(repository.unsetAllDefaults).toHaveBeenCalledWith(mockUser.id);
      expect(repository.update).toHaveBeenCalledWith(mockPersona.id, {
        isDefault: true,
      });
      expect(result.isDefault).toBe(true);
    });

    it('should verify ownership before setting default', async () => {
      repository.findById.mockResolvedValue({
        ...mockPersona,
        userId: 'other-user',
      });

      await expect(
        service.setDefault(mockUser.id, mockPersona.id),
      ).rejects.toThrow(NotFoundException);

      expect(repository.unsetAllDefaults).not.toHaveBeenCalled();
    });
  });
});

