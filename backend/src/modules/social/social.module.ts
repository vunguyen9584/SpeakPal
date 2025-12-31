import { Module } from '@nestjs/common';
import { InvitationController } from './invitation/invitation.controller';
import { GroupController } from './group/group.controller';
import { InvitationService } from './invitation/invitation.service';
import { GroupService } from './group/group.service';
import { InvitationRepository } from './invitation/invitation.repository';
import { PrismaModule } from '../../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [InvitationController, GroupController],
  providers: [InvitationService, GroupService, InvitationRepository],
  exports: [InvitationService, GroupService],
})
export class SocialModule {}
