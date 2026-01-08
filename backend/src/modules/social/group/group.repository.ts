import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { GroupMemberRole } from '@prisma/client';

@Injectable()
export class GroupRepository {
  constructor(private prisma: PrismaService) { }

  async create(data: {
    name: string;
    description?: string;
    ownerId: string;
  }) {
    return this.prisma.group.create({
      data: {
        name: data.name,
        description: data.description,
        ownerId: data.ownerId,
        isActive: true,
      },
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
                username: true,
                level: true,
                totalXp: true,
              },
            },
          },
          orderBy: {
            joinedAt: 'asc',
          },
        },
      },
    });
  }

  async findByInviteCode(inviteCode: string) {
    // Since inviteCode is not in schema, we assume the code might be the GLobal ID
    return this.prisma.group.findUnique({
      where: { id: inviteCode },
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
        isActive: true,
      },
      include: {
        members: {
          include: {
            user: {
              select: {
                id: true,
                email: true,
                username: true,
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

  async addMember(groupId: string, userId: string, role: GroupMemberRole) {
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

  async getMemberRole(
    groupId: string,
    userId: string,
  ): Promise<GroupMemberRole | null> {
    const member = await this.prisma.groupMember.findFirst({
      where: {
        groupId,
        userId,
      },
    });
    return member ? member.role : null;
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
            username: true,
          },
        },
      },
      orderBy: {
        joinedAt: 'asc',
      },
    });
  }

  async getMembersByWeeklyXP(groupId: string) {
    // Get all members with their XP details
    // Ideally we would join with UserRanking for current week, but for now using User properties
    const members = await this.prisma.groupMember.findMany({
      where: { groupId },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            username: true,
            totalXp: true,
            level: true,
          },
        },
      },
    });

    return members
      .map((member) => ({
        userId: member.user.id,
        userName: member.user.username || member.user.email,
        userAvatar: null,
        weeklyXP: member.user.totalXp || 0, // Placeholder
        level: member.user.level,
        rank: 0,
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
    },
  ) {
    return this.prisma.group.update({
      where: { id: groupId },
      data,
    });
  }

  async deleteGroup(groupId: string) {
    const deleteMembers = this.prisma.groupMember.deleteMany({
      where: { groupId },
    });

    const deleteGroup = this.prisma.group.delete({
      where: { id: groupId },
    });

    return this.prisma.$transaction([deleteMembers, deleteGroup]);
  }
}
