import {
  Controller,
  Post,
  Get,
  Body,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { InvitationService } from './invitation.service';
import { CreateInvitationDto } from './dto/create-invitation.dto';
import { AcceptInvitationDto } from './dto/accept-invitation.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import type { RequestWithUser } from '../../../common/interfaces/request.interface';

@Controller('invitations')
@UseGuards(JwtAuthGuard)
export class InvitationController {
  constructor(private readonly invitationService: InvitationService) { }

  /**
   * POST /invitations
   * Generate a new invite code
   */
  @Post()
  async generateInviteCode(
    @Request() req: RequestWithUser,
    @Body() dto: CreateInvitationDto,
  ) {
    return this.invitationService.generateInviteCode(req.user.userId, dto);
  }

  /**
   * GET /invitations/mine
   * Get all my invitations
   */
  @Get('mine')
  async getMyInvitations(@Request() req: RequestWithUser) {
    return this.invitationService.getUserInvitations(req.user.userId);
  }

  /**
   * POST /invitations/accept
   * Accept an invitation code
   */
  @Post('accept')
  @HttpCode(HttpStatus.OK)
  async acceptInvitation(
    @Request() req: RequestWithUser,
    @Body() dto: AcceptInvitationDto,
  ) {
    await this.invitationService.acceptInvitation(dto.code, req.user.userId);
    return { message: 'Invitation accepted successfully' };
  }

  /**
   * GET /invitations/stats
   * Get referral statistics
   */
  @Get('stats')
  async getReferralStats(@Request() req: RequestWithUser) {
    return this.invitationService.getReferralStats(req.user.userId);
  }
}
