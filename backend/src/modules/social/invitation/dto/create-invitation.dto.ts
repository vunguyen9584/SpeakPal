import { IsInt, IsOptional, IsDateString, Min, Max } from 'class-validator';

export class CreateInvitationDto {


  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(365)
  expiryDays?: number = 30;
}
