import { Test, TestingModule } from '@nestjs/testing';
import {
  BadRequestException,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { GroupService } from '../group/group.service';
import { GroupRepository } from '../group/group.repository';
import { GroupRole } from '../group/dto/group-member.dto';

describe('GroupService', () => {
  let service: GroupService;
  let repository: GroupRepository;

  const mockGroupRepository = {
    create: jest.fn(),
    findById: jest.fn(),
    findByInviteCode: jest.fn(),
    findUserGroups: jest.fn(),
    addMember: jest.fn(),
    removeMember: jest.fn(),
    isMember: jest.fn(),
    getMemberRole: jest.fn(),
    getMembers: jest.fn(),
    getMembersByWeeklyXP: jest.fn(),
    updateGroup: jest.fn(),
    deleteGroup: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GroupService,
        {
          provide: GroupRepository,
          useValue: mockGroupRepository,
        },
      ],
    }).compile();

    service = module.get<GroupService>(GroupService);
    repository = module.get<GroupRepository>(GroupRepository);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('createGroup', () => {
    it('should create a group with owner', async () => {
      const userId = 'user-123';
      const dto = {
        name: 'Test Group',
        description: 'Test Description',
        isPublic: true,
      };
      const mockGroup = {
        id: 'group-123',
        name: dto.name,
        description: dto.description,
        isPublic: dto.isPublic,
        ownerId: userId,
        inviteCode: 'ABC123',
        createdAt: new Date(),
        updatedAt: new Date(),
      };
      const mockGroupWithMembers = {
        ...mockGroup,
        members: [
          {
            userId,
            role: GroupRole.OWNER,
            user: {
              id: userId,
              email: 'user@example.com',
              displayName: 'Test User',
            },
          },
        ],
      };

      mockGroupRepository.create.mockResolvedValue(mockGroup);
      mockGroupRepository.addMember.mockResolvedValue({});
      mockGroupRepository.findById.mockResolvedValue(mockGroupWithMembers);

      const result = await service.createGroup(userId, dto);

      expect(result.name).toBe(dto.name);
      expect(result.ownerId).toBe(userId);
      expect(mockGroupRepository.create).toHaveBeenCalledWith(
        expect.objectContaining({
          name: dto.name,
          ownerId: userId,
        }),
      );
      expect(mockGroupRepository.addMember).toHaveBeenCalledWith(
        'group-123',
        userId,
        GroupRole.OWNER,
      );
    });

    it('should use default isPublic value if not provided', async () => {
      const userId = 'user-123';
      const dto = {
        name: 'Test Group',
      };
      const mockGroup = {
        id: 'group-123',
        name: dto.name,
        isPublic: true,
        ownerId: userId,
        inviteCode: 'ABC123',
        createdAt: new Date(),
        updatedAt: new Date(),
      };

      mockGroupRepository.create.mockResolvedValue(mockGroup);
      mockGroupRepository.addMember.mockResolvedValue({});
      mockGroupRepository.findById.mockResolvedValue({
        ...mockGroup,
        members: [],
      });

      await service.createGroup(userId, dto);

      expect(mockGroupRepository.create).toHaveBeenCalledWith(
        expect.objectContaining({
          isPublic: true,
        }),
      );
    });
  });

  describe('joinGroup', () => {
    it('should join a group with valid code', async () => {
      const code = 'ABC123';
      const userId = 'user-456';
      const mockGroup = {
        id: 'group-123',
        name: 'Test Group',
        inviteCode: code,
      };

      mockGroupRepository.findByInviteCode.mockResolvedValue(mockGroup);
      mockGroupRepository.isMember.mockResolvedValue(false);
      mockGroupRepository.addMember.mockResolvedValue({});

      await service.joinGroup(code, userId);

      expect(mockGroupRepository.findByInviteCode).toHaveBeenCalledWith(code);
      expect(mockGroupRepository.addMember).toHaveBeenCalledWith(
        'group-123',
        userId,
        GroupRole.MEMBER,
      );
    });

    it('should throw NotFoundException for invalid code', async () => {
      const code = 'INVALID';
      const userId = 'user-456';

      mockGroupRepository.findByInviteCode.mockResolvedValue(null);

      await expect(service.joinGroup(code, userId)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw BadRequestException if already a member', async () => {
      const code = 'ABC123';
      const userId = 'user-456';
      const mockGroup = {
        id: 'group-123',
        inviteCode: code,
      };

      mockGroupRepository.findByInviteCode.mockResolvedValue(mockGroup);
      mockGroupRepository.isMember.mockResolvedValue(true);

      await expect(service.joinGroup(code, userId)).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('leaveGroup', () => {
    it('should allow member to leave group', async () => {
      const groupId = 'group-123';
      const userId = 'user-456';
      const mockGroup = {
        id: groupId,
        ownerId: 'user-123',
      };

      mockGroupRepository.findById.mockResolvedValue(mockGroup);
      mockGroupRepository.isMember.mockResolvedValue(true);
      mockGroupRepository.removeMember.mockResolvedValue({});

      await service.leaveGroup(groupId, userId);

      expect(mockGroupRepository.removeMember).toHaveBeenCalledWith(
        groupId,
        userId,
      );
    });

    it('should throw NotFoundException for non-existent group', async () => {
      const groupId = 'invalid-group';
      const userId = 'user-456';

      mockGroupRepository.findById.mockResolvedValue(null);

      await expect(service.leaveGroup(groupId, userId)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw BadRequestException if not a member', async () => {
      const groupId = 'group-123';
      const userId = 'user-456';
      const mockGroup = {
        id: groupId,
        ownerId: 'user-123',
      };

      mockGroupRepository.findById.mockResolvedValue(mockGroup);
      mockGroupRepository.isMember.mockResolvedValue(false);

      await expect(service.leaveGroup(groupId, userId)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw BadRequestException if owner tries to leave', async () => {
      const groupId = 'group-123';
      const userId = 'user-123';
      const mockGroup = {
        id: groupId,
        ownerId: userId,
      };

      mockGroupRepository.findById.mockResolvedValue(mockGroup);
      mockGroupRepository.isMember.mockResolvedValue(true);

      await expect(service.leaveGroup(groupId, userId)).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('getGroupById', () => {
    it('should return group for member', async () => {
      const groupId = 'group-123';
      const userId = 'user-456';
      const mockGroup = {
        id: groupId,
        name: 'Test Group',
        isPublic: false,
        ownerId: 'user-123',
        members: [],
      };

      mockGroupRepository.findById.mockResolvedValue(mockGroup);
      mockGroupRepository.isMember.mockResolvedValue(true);

      const result = await service.getGroupById(groupId, userId);

      expect(result.id).toBe(groupId);
    });

    it('should throw ForbiddenException for non-member even if public (current limitation)', async () => {
      const groupId = 'group-123';
      const userId = 'user-456';
      const mockGroup = {
        id: groupId,
        name: 'Public Group',
        isPublic: true,
        ownerId: 'user-123',
        members: [],
      };

      mockGroupRepository.findById.mockResolvedValue(mockGroup);
      mockGroupRepository.isMember.mockResolvedValue(false);

      await expect(service.getGroupById(groupId, userId)).rejects.toThrow(
        ForbiddenException,
      );
    });

    it('should throw ForbiddenException for private group non-member', async () => {
      const groupId = 'group-123';
      const userId = 'user-456';
      const mockGroup = {
        id: groupId,
        name: 'Private Group',
        isPublic: false,
        ownerId: 'user-123',
      };

      mockGroupRepository.findById.mockResolvedValue(mockGroup);
      mockGroupRepository.isMember.mockResolvedValue(false);

      await expect(service.getGroupById(groupId, userId)).rejects.toThrow(
        ForbiddenException,
      );
    });
  });

  describe('getGroupRanking', () => {
    it('should return group rankings', async () => {
      const groupId = 'group-123';
      const userId = 'user-456';
      const mockGroup = {
        id: groupId,
        isPublic: true,
      };
      const mockRankings = [
        {
          userId: 'user-1',
          userName: 'User 1',
          weeklyXP: 500,
          level: 5,
          rank: 1,
        },
        {
          userId: 'user-2',
          userName: 'User 2',
          weeklyXP: 300,
          level: 4,
          rank: 2,
        },
      ];

      mockGroupRepository.findById.mockResolvedValue(mockGroup);
      mockGroupRepository.isMember.mockResolvedValue(true);
      mockGroupRepository.getMembersByWeeklyXP.mockResolvedValue(mockRankings);

      const result = await service.getGroupRanking(groupId, userId);

      expect(result).toHaveLength(2);
      expect(result[0].rank).toBe(1);
      expect(result[0].weeklyXP).toBe(500);
    });
  });

  describe('updateGroup', () => {
    it('should allow owner to update group', async () => {
      const groupId = 'group-123';
      const userId = 'user-123';
      const dto = { name: 'Updated Name' };
      const mockGroup = {
        id: groupId,
        ownerId: userId,
      };
      const mockUpdatedGroup = {
        ...mockGroup,
        name: dto.name,
        members: [],
      };

      mockGroupRepository.findById.mockResolvedValue(mockGroup);
      mockGroupRepository.updateGroup.mockResolvedValue(mockUpdatedGroup);
      mockGroupRepository.findById.mockResolvedValueOnce(mockGroup);
      mockGroupRepository.findById.mockResolvedValueOnce(mockUpdatedGroup);

      const result = await service.updateGroup(groupId, userId, dto);

      expect(mockGroupRepository.updateGroup).toHaveBeenCalledWith(
        groupId,
        dto,
      );
    });

    it('should throw ForbiddenException if not owner', async () => {
      const groupId = 'group-123';
      const userId = 'user-456';
      const dto = { name: 'Updated Name' };
      const mockGroup = {
        id: groupId,
        ownerId: 'user-123',
      };

      mockGroupRepository.findById.mockResolvedValue(mockGroup);

      await expect(service.updateGroup(groupId, userId, dto)).rejects.toThrow(
        ForbiddenException,
      );
    });
  });

  describe('deleteGroup', () => {
    it('should allow owner to delete group', async () => {
      const groupId = 'group-123';
      const userId = 'user-123';
      const mockGroup = {
        id: groupId,
        ownerId: userId,
      };

      mockGroupRepository.findById.mockResolvedValue(mockGroup);
      mockGroupRepository.deleteGroup.mockResolvedValue({});

      await service.deleteGroup(groupId, userId);

      expect(mockGroupRepository.deleteGroup).toHaveBeenCalledWith(groupId);
    });

    it('should throw ForbiddenException if not owner', async () => {
      const groupId = 'group-123';
      const userId = 'user-456';
      const mockGroup = {
        id: groupId,
        ownerId: 'user-123',
      };

      mockGroupRepository.findById.mockResolvedValue(mockGroup);

      await expect(service.deleteGroup(groupId, userId)).rejects.toThrow(
        ForbiddenException,
      );
    });
  });
});
