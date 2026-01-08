import { GroupMemberDto } from './group-member.dto';
import { Group, GroupMember } from '@prisma/client';

export class GroupResponseDto {
  id: string;
  name: string;
  description?: string;

  ownerId: string;
  memberCount: number;
  createdAt: Date;
  updatedAt: Date;
  members?: GroupMemberDto[];

  constructor(partial: Partial<GroupResponseDto>) {
    Object.assign(this, partial);
  }

  static fromEntity(
    entity: Group & { members?: GroupMember[] },
    includemembers: boolean = false,
  ): GroupResponseDto {
    return new GroupResponseDto({
      id: entity.id,
      name: entity.name,
      description: entity.description,

      ownerId: entity.ownerId,
      memberCount: entity.members?.length || 0,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      members:
        includemembers && entity.members
          ? entity.members.map((m) => GroupMemberDto.fromEntity(m))
          : undefined,
    });
  }
}
