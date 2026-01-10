import { IsNotEmpty, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class AcceptInvitationDto {
    @ApiProperty({
        description: 'The invitation code to accept',
        example: 'ABC12345',
    })
    @IsString()
    @IsNotEmpty()
    code: string;
}
