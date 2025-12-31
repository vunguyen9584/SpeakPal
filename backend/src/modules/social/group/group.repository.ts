import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { GroupRole } from './dto/group-member.dto';

@Injectable()
export class GroupRepository {
  constructor(private prisma: PrismaService) {}

  async create(data: {
    name: string;
    description?: string;
    isPublic: boolean;
    ownerId: string;
    inviteCode: string;
  }) {
    return this.prisma.group.create({
      data,
    });
  }

  async findById(groupId: string) {
    return this.prisma.group.findUnique({
      where: { id: groupId },
      include: {
        members: {
          include: {
            user: {
              select: {
                id: true,
                email: true,
                displayName: true,
                avatar: true,
              },
            },
          },
          orderBy: {
            createdAt: 'asc',
          },
        },
      },
    });
  }

  async findByInviteCode(inviteCode: string) {
    return this.prisma.group.findUnique({
      where: { inviteCode },
    });
  }

  async findUserGroups(userId: string) {
    return this.prisma.group.findMany({
      where: {
        members: {
          some: {
            userId,
          },
        },
      },
      include: {
        members: {
          include: {
            user: {
              select: {
                id: true,
                email: true,
                displayName: true,
                avatar: true,
              },
            },
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  async addMember(groupId: string, userId: string, role: GroupRole) {
    return this.prisma.groupMember.create({
      data: {
        groupId,
        userId,
        role,
      },
    });
  }

  async removeMember(groupId: string, userId: string) {
    return this.prisma.groupMember.deleteMany({
      where: {
        groupId,
        userId,
      },
    });
  }

  async isMember(groupId: string, userId: string): Promise<boolean> {
    const member = await this.prisma.groupMember.findFirst({
      where: {
        groupId,
        userId,
      },
    });
    return !!member;
  }

  async getMemberRole(groupId: string, userId: string): Promise<GroupRole | null> {
    const member = await this.prisma.groupMember.findFirst({
      where: {
        groupId,
        userId,
      },
    });
    return member ? (member.role as GroupRole) : null;
  }

  async getMemberCount(groupId: string): Promise<number> {
    return this.prisma.groupMember.count({
      where: { groupId },
    });
  }

  async getMembers(groupId: string) {
    return this.prisma.groupMember.findMany({
      where: { groupId },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            displayName: true,
            avatar: true,
          },
        },
      },
      orderBy: {
        createdAt: 'asc',
      },
    });
  }

  async getMembersByWeeklyXP(groupId: string) {
    // Get all members with their weekly XP
    const members = await this.prisma.groupMember.findMany({
      where: { groupId },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            displayName: true,
            avatar: true,
            currentXP: true,
            currentLevel: true,
          },
        },
      },
    });

    // TODO: Calculate weekly XP from user's activity
    // For now, using current XP as placeholder
    return members
      .map((member) => ({
        userId: member.user.id,
        userName: member.user.displayName || member.user.email,
        userAvatar: member.user.avatar,
        weeklyXP: member.user.currentXP || 0, // TODO: Calculate actual weekly XP
        level: member.user.currentLevel || 1,
        rank: 0, // Will be set after sorting
      }))
      .sort((a, b) => b.weeklyXP - a.weeklyXP)
      .map((entry, index) => ({
        ...entry,
        rank: index + 1,
      }));
  }

  async updateGroup(
    groupId: string,
    data: {
      name?: string;
      description?: string;
      isPublic?: boolean;
    },
  ) {
    return this.prisma.group.update({
      where: { id: groupId },
      data,
    });
  }

  async deleteGroup(groupId: string) {
    // Delete all members first
    await this.prisma.groupMember.deleteMany({
      where: { groupId },
    });

    // Delete the group
    return this.prisma.group.delete({
      where: { id: groupId },
    });
  }
}
