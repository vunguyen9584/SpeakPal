import {
  Injectable,
  BadRequestException,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { GroupRepository } from './group.repository';
import { CreateGroupDto } from './dto/create-group.dto';
import { GroupResponseDto } from './dto/group-response.dto';
import { GroupMemberDto, GroupRole } from './dto/group-member.dto';
import { randomBytes } from 'crypto';

@Injectable()
export class GroupService {
  constructor(private readonly groupRepo: GroupRepository) {}

  /**
   * Create a new group with the user as owner
   */
  async createGroup(
    userId: string,
    dto: CreateGroupDto,
  ): Promise<GroupResponseDto> {
    const inviteCode = this.generateInviteCode();

    const group = await this.groupRepo.create({
      name: dto.name,
      description: dto.description,
      isPublic: dto.isPublic ?? true,
      ownerId: userId,
      inviteCode,
    });

    // Add creator as owner member
    await this.groupRepo.addMember(group.id, userId, GroupRole.OWNER);

    // Fetch group with members
    const groupWithMembers = await this.groupRepo.findById(group.id);
    return GroupResponseDto.fromEntity(groupWithMembers, true);
  }

  /**
   * Join a group using invite code
   */
  async joinGroup(code: string, userId: string): Promise<void> {
    const group = await this.groupRepo.findByInviteCode(code);

    if (!group) {
      throw new NotFoundException('Group not found');
    }

    // Check if already a member
    const isMember = await this.groupRepo.isMember(group.id, userId);
    if (isMember) {
      throw new BadRequestException('You are already a member of this group');
    }

    // Add as member
    await this.groupRepo.addMember(group.id, userId, GroupRole.MEMBER);
  }

  /**
   * Leave a group
   */
  async leaveGroup(groupId: string, userId: string): Promise<void> {
    const group = await this.groupRepo.findById(groupId);

    if (!group) {
      throw new NotFoundException('Group not found');
    }

    // Check if user is a member
    const isMember = await this.groupRepo.isMember(groupId, userId);
    if (!isMember) {
      throw new BadRequestException('You are not a member of this group');
    }

    // Owner cannot leave, must delete group instead
    if (group.ownerId === userId) {
      throw new BadRequestException(
        'Group owner cannot leave. Delete the group instead.',
      );
    }

    await this.groupRepo.removeMember(groupId, userId);
  }

  /**
   * Get all groups the user is a member of
   */
  async getUserGroups(userId: string): Promise<GroupResponseDto[]> {
    const groups = await this.groupRepo.findUserGroups(userId);
    return groups.map((group) => GroupResponseDto.fromEntity(group, false));
  }

  /**
   * Get group details by ID
   */
  async getGroupById(groupId: string, userId: string): Promise<GroupResponseDto> {
    const group = await this.groupRepo.findById(groupId);

    if (!group) {
      throw new NotFoundException('Group not found');
    }

    // Check if user has access (member or public group)
    const isMember = await this.groupRepo.isMember(groupId, userId);
    if (!group.isPublic && !isMember) {
      throw new ForbiddenException('You do not have access to this group');
    }

    return GroupResponseDto.fromEntity(group, true);
  }

  /**
   * Get group members
   */
  async getGroupMembers(groupId: string, userId: string): Promise<GroupMemberDto[]> {
    const group = await this.groupRepo.findById(groupId);

    if (!group) {
      throw new NotFoundException('Group not found');
    }

    // Check if user has access
    const isMember = await this.groupRepo.isMember(groupId, userId);
    if (!group.isPublic && !isMember) {
      throw new ForbiddenException('You do not have access to this group');
    }

    const members = await this.groupRepo.getMembers(groupId);
    return members.map((member) => GroupMemberDto.fromEntity(member));
  }

  /**
   * Get group ranking by weekly XP
   */
  async getGroupRanking(groupId: string, userId: string) {
    const group = await this.groupRepo.findById(groupId);

    if (!group) {
      throw new NotFoundException('Group not found');
    }

    // Check if user has access
    const isMember = await this.groupRepo.isMember(groupId, userId);
    if (!group.isPublic && !isMember) {
      throw new ForbiddenException('You do not have access to this group');
    }

    return this.groupRepo.getMembersByWeeklyXP(groupId);
  }

  /**
   * Update group details (owner only)
   */
  async updateGroup(
    groupId: string,
    userId: string,
    dto: Partial<CreateGroupDto>,
  ): Promise<GroupResponseDto> {
    const group = await this.groupRepo.findById(groupId);

    if (!group) {
      throw new NotFoundException('Group not found');
    }

    // Only owner can update
    if (group.ownerId !== userId) {
      throw new ForbiddenException('Only group owner can update group details');
    }

    const updatedGroup = await this.groupRepo.updateGroup(groupId, dto);
    const groupWithMembers = await this.groupRepo.findById(updatedGroup.id);
    return GroupResponseDto.fromEntity(groupWithMembers, true);
  }

  /**
   * Delete group (owner only)
   */
  async deleteGroup(groupId: string, userId: string): Promise<void> {
    const group = await this.groupRepo.findById(groupId);

    if (!group) {
      throw new NotFoundException('Group not found');
    }

    // Only owner can delete
    if (group.ownerId !== userId) {
      throw new ForbiddenException('Only group owner can delete the group');
    }

    await this.groupRepo.deleteGroup(groupId);
  }

  /**
   * Generate unique 6-character invite code for groups
   */
  private generateInviteCode(): string {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const bytes = randomBytes(6);
    let code = '';

    for (let i = 0; i < 6; i++) {
      code += chars[bytes[i] % chars.length];
    }

    return code;
  }
}
