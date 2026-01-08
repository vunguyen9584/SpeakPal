export enum GroupRole {
  OWNER = 'OWNER',
  ADMIN = 'ADMIN',
  MEMBER = 'MEMBER',
}

import { GroupMember, User } from '@prisma/client';

export class GroupMemberDto {
  userId: string;
  userName: string;
  userAvatar?: string;
  role: GroupRole;
  joinedAt: Date;

  constructor(partial: Partial<GroupMemberDto>) {
    Object.assign(this, partial);
  }

  static fromEntity(
    entity: GroupMember & { user?: Partial<User> },
  ): GroupMemberDto {
    return new GroupMemberDto({
      userId: entity.userId || entity.user?.id,
      userName: entity.user?.username || entity.user?.email || 'Unknown User',
      userAvatar: undefined,
      role: entity.role as unknown as GroupRole,
      joinedAt: entity.joinedAt,
    });
  }
}
