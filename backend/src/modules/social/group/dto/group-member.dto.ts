export enum GroupRole {
  OWNER = 'OWNER',
  ADMIN = 'ADMIN',
  MEMBER = 'MEMBER',
}

export class GroupMemberDto {
  userId: string;
  userName: string;
  userAvatar?: string;
  role: GroupRole;
  joinedAt: Date;

  constructor(partial: Partial<GroupMemberDto>) {
    Object.assign(this, partial);
  }

  static fromEntity(entity: any): GroupMemberDto {
    return new GroupMemberDto({
      userId: entity.userId || entity.user?.id,
      userName: entity.user?.displayName || entity.user?.email || 'Unknown User',
      userAvatar: entity.user?.avatar,
      role: entity.role as GroupRole,
      joinedAt: entity.joinedAt || entity.createdAt,
    });
  }
}
