import {
  Controller,
  Get,
  Put,
  Post,
  Body,
  UseGuards,
  HttpCode,
  HttpStatus,
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiConsumes } from '@nestjs/swagger';
import { UserService } from './user.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { UserDto } from './dto/user.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { UpdateSettingsDto } from './dto/update-settings.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { UserStatsDto } from './dto/user-stats.dto';


@ApiTags('Users')
@ApiBearerAuth()
@Controller('users')
@UseGuards(JwtAuthGuard)
export class UserController {
  constructor(private readonly userService: UserService) { }

  @Get('me')
  @ApiOperation({ summary: 'Get user profile' })
  async getProfile(@CurrentUser() user: { userId: string }): Promise<UserDto> {
    return this.userService.getProfile(user.userId);
  }

  @Put('me')
  @ApiOperation({ summary: 'Update user profile' })
  async updateProfile(
    @CurrentUser() user: { userId: string },
    @Body() dto: UpdateProfileDto,
  ): Promise<UserDto> {
    return this.userService.updateProfile(user.userId, dto);
  }

  @Post('me/avatar')
  @ApiOperation({ summary: 'Upload user avatar' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file'))
  async uploadAvatar(
    @CurrentUser() user: { userId: string },
    @UploadedFile() file: Express.Multer.File,
  ) {
    const avatarUrl = await this.userService.uploadAvatar(user.userId, file);
    return { avatarUrl };
  }

  @Put('me/password')
  @ApiOperation({ summary: 'Change password' })
  @HttpCode(HttpStatus.NO_CONTENT)
  async changePassword(
    @CurrentUser() user: { userId: string },
    @Body() dto: ChangePasswordDto,
  ): Promise<void> {
    return this.userService.changePassword(user.userId, dto);
  }

  @Get('me/stats')
  @ApiOperation({ summary: 'Get user statistics' })
  async getStats(
    @CurrentUser() user: { userId: string },
  ): Promise<UserStatsDto> {
    return this.userService.getStats(user.userId);
  }

  @Put('me/settings')
  @ApiOperation({ summary: 'Update user settings' })
  async updateSettings(
    @CurrentUser() user: { userId: string },
    @Body() dto: UpdateSettingsDto,
  ): Promise<UserDto> {
    return this.userService.updateSettings(user.userId, dto);
  }
}
