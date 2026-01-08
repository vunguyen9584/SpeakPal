import {
  Controller,
  Post,
  Get,
  Delete,
  Patch,
  Body,
  Param,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { GroupService } from './group.service';
import { CreateGroupDto } from './dto/create-group.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';

@Controller('groups')
@UseGuards(JwtAuthGuard)
export class GroupController {
  constructor(private readonly groupService: GroupService) {}

  /**
   * POST /groups
   * Create a new group
   */
  @Post()
  async createGroup(@Request() req, @Body() dto: CreateGroupDto) {
    return this.groupService.createGroup(req.user.userId, dto);
  }

  /**
   * GET /groups
   * List my groups
   */
  @Get()
  async getMyGroups(@Request() req) {
    return this.groupService.getUserGroups(req.user.userId);
  }

  /**
   * POST /groups/join
   * Join a group with invite code
   */
  @Post('join')
  @HttpCode(HttpStatus.OK)
  async joinGroup(@Request() req, @Body() body: { code: string }) {
    await this.groupService.joinGroup(body.code, req.user.userId);
    return { message: 'Successfully joined the group' };
  }

  /**
   * GET /groups/:id
   * Get group details
   */
  @Get(':id')
  async getGroupById(@Request() req, @Param('id') groupId: string) {
    return this.groupService.getGroupById(groupId, req.user.userId);
  }

  /**
   * GET /groups/:id/members
   * List group members
   */
  @Get(':id/members')
  async getGroupMembers(@Request() req, @Param('id') groupId: string) {
    return this.groupService.getGroupMembers(groupId, req.user.userId);
  }

  /**
   * GET /groups/:id/ranking
   * Get group weekly rankings
   */
  @Get(':id/ranking')
  async getGroupRanking(@Request() req, @Param('id') groupId: string) {
    return this.groupService.getGroupRanking(groupId, req.user.userId);
  }

  /**
   * PATCH /groups/:id
   * Update group details (owner only)
   */
  @Patch(':id')
  async updateGroup(
    @Request() req,
    @Param('id') groupId: string,
    @Body() dto: Partial<CreateGroupDto>,
  ) {
    return this.groupService.updateGroup(groupId, req.user.userId, dto);
  }

  /**
   * DELETE /groups/:id/leave
   * Leave a group
   */
  @Delete(':id/leave')
  @HttpCode(HttpStatus.OK)
  async leaveGroup(@Request() req, @Param('id') groupId: string) {
    await this.groupService.leaveGroup(groupId, req.user.userId);
    return { message: 'Successfully left the group' };
  }

  /**
   * DELETE /groups/:id
   * Delete a group (owner only)
   */
  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  async deleteGroup(@Request() req, @Param('id') groupId: string) {
    await this.groupService.deleteGroup(groupId, req.user.userId);
    return { message: 'Group deleted successfully' };
  }
}
