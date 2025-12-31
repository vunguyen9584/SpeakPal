import { Module } from '@nestjs/common';
import { InvitationController } from './invitation/invitation.controller';
import { GroupController } from './group/group.controller';
import { InvitationService } from './invitation/invitation.service';
import { GroupService } from './group/group.service';

@Module({
  controllers: [InvitationController, GroupController],
  providers: [InvitationService, GroupService]
})
export class SocialModule {}
