import { GroupMemberDto } from './group-member.dto';

export class GroupResponseDto {
  id: string;
  name: string;
  description?: string;
  isPublic: boolean;
  ownerId: string;
  memberCount: number;
  createdAt: Date;
  updatedAt: Date;
  members?: GroupMemberDto[];

  constructor(partial: Partial<GroupResponseDto>) {
    Object.assign(this, partial);
  }

  static fromEntity(entity: any, includemembers: boolean = false): GroupResponseDto {
    return new GroupResponseDto({
      id: entity.id,
      name: entity.name,
      description: entity.description,
      isPublic: entity.isPublic,
      ownerId: entity.ownerId,
      memberCount: entity.members?.length || 0,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      members: includemembers && entity.members
        ? entity.members.map((m: any) => GroupMemberDto.fromEntity(m))
        : undefined,
    });
  }
}
