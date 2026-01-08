import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../../src/app.module';
import { PrismaService } from '../../../src/prisma/prisma.service';

describe('Social Module (E2E)', () => {
    let app: INestApplication;
    let prisma: PrismaService;
    let authToken1: string;
    let authToken2: string;
    let userId1: string;
    let userId2: string;

    beforeAll(async () => {
        const moduleFixture: TestingModule = await Test.createTestingModule({
            imports: [AppModule],
        }).compile();

        app = moduleFixture.createNestApplication();
        app.useGlobalPipes(new ValidationPipe());
        await app.init();

        prisma = app.get<PrismaService>(PrismaService);

        // Clean up test data
        await prisma.groupMember.deleteMany({});
        await prisma.group.deleteMany({});
        await prisma.invitation.deleteMany({});
        await prisma.user.deleteMany({
            where: {
                email: {
                    in: ['social-test1@example.com', 'social-test2@example.com'],
                },
            },
        });

        // Create test users
        const user1Response = await request(app.getHttpServer())
            .post('/auth/register')
            .send({
                email: 'social-test1@example.com',
                password: 'Test123!@#',
                username: 'SocialUser1',
            });

        authToken1 = user1Response.body.accessToken;
        userId1 = user1Response.body.user.id;

        const user2Response = await request(app.getHttpServer())
            .post('/auth/register')
            .send({
                email: 'social-test2@example.com',
                password: 'Test123!@#',
                username: 'SocialUser2',
            });

        authToken2 = user2Response.body.accessToken;
        userId2 = user2Response.body.user.id;
    });

    afterAll(async () => {
        // Clean up
        await prisma.groupMember.deleteMany({});
        await prisma.group.deleteMany({});
        await prisma.invitation.deleteMany({});
        await prisma.user.deleteMany({
            where: {
                email: {
                    in: ['social-test1@example.com', 'social-test2@example.com'],
                },
            },
        });

        await app.close();
    });

    describe('Invitation Flow', () => {
        let inviteCode: string;

        it('POST /invitations - should generate invite code', async () => {
            const response = await request(app.getHttpServer())
                .post('/invitations')
                .set('Authorization', `Bearer ${authToken1}`)
                .send({
                    maxUsage: 5,
                    expiryDays: 30,
                })
                .expect(201);

            expect(response.body).toHaveProperty('code');
            expect(response.body).toHaveProperty('inviteUrl');
            expect(response.body.code).toHaveLength(8);
            expect(response.body.maxUsage).toBe(5);
            expect(response.body.usageCount).toBe(0);

            inviteCode = response.body.code;
        });

        it('GET /invitations/mine - should list user invitations', async () => {
            const response = await request(app.getHttpServer())
                .get('/invitations/mine')
                .set('Authorization', `Bearer ${authToken1}`)
                .expect(200);

            expect(Array.isArray(response.body)).toBe(true);
            expect(response.body.length).toBeGreaterThan(0);
            expect(response.body[0]).toHaveProperty('code');
            expect(response.body[0]).toHaveProperty('inviteUrl');
        });

        it('POST /invitations/accept - should accept invitation', async () => {
            const response = await request(app.getHttpServer())
                .post('/invitations/accept')
                .set('Authorization', `Bearer ${authToken2}`)
                .send({
                    code: inviteCode,
                })
                .expect(201);

            expect(response.body).toHaveProperty('message');
            expect(response.body.message).toContain('accepted');
        });

        it('POST /invitations/accept - should fail for own invitation', async () => {
            await request(app.getHttpServer())
                .post('/invitations/accept')
                .set('Authorization', `Bearer ${authToken1}`)
                .send({
                    code: inviteCode,
                })
                .expect(400);
        });

        it('POST /invitations/accept - should fail for invalid code', async () => {
            await request(app.getHttpServer())
                .post('/invitations/accept')
                .set('Authorization', `Bearer ${authToken2}`)
                .send({
                    code: 'INVALID1',
                })
                .expect(404);
        });

        it('GET /invitations/stats - should show referral statistics', async () => {
            const response = await request(app.getHttpServer())
                .get('/invitations/stats')
                .set('Authorization', `Bearer ${authToken1}`)
                .expect(200);

            expect(response.body).toHaveProperty('totalReferrals');
            expect(response.body).toHaveProperty('referrals');
            expect(response.body).toHaveProperty('rewards');
            expect(response.body.totalReferrals).toBe(1);
            expect(Array.isArray(response.body.referrals)).toBe(true);
            expect(Array.isArray(response.body.rewards)).toBe(true);
        });
    });

    describe('Group Management', () => {
        let groupId: string;
        let groupInviteCode: string;

        it('POST /groups - should create a group', async () => {
            const response = await request(app.getHttpServer())
                .post('/groups')
                .set('Authorization', `Bearer ${authToken1}`)
                .send({
                    name: 'Test Study Group',
                    description: 'A group for testing',
                    isPublic: true,
                })
                .expect(201);

            expect(response.body).toHaveProperty('id');
            expect(response.body).toHaveProperty('name', 'Test Study Group');
            expect(response.body).toHaveProperty('inviteCode');
            expect(response.body).toHaveProperty('memberCount', 1);
            expect(response.body.inviteCode).toHaveLength(6);

            groupId = response.body.id;
            groupInviteCode = response.body.inviteCode;
        });

        it('GET /groups - should list user groups', async () => {
            const response = await request(app.getHttpServer())
                .get('/groups')
                .set('Authorization', `Bearer ${authToken1}`)
                .expect(200);

            expect(Array.isArray(response.body)).toBe(true);
            expect(response.body.length).toBeGreaterThan(0);
            expect(response.body[0]).toHaveProperty('id', groupId);
            expect(response.body[0]).toHaveProperty('name', 'Test Study Group');
        });

        it('GET /groups/:id - should get group details', async () => {
            const response = await request(app.getHttpServer())
                .get(`/groups/${groupId}`)
                .set('Authorization', `Bearer ${authToken1}`)
                .expect(200);

            expect(response.body).toHaveProperty('id', groupId);
            expect(response.body).toHaveProperty('name', 'Test Study Group');
            expect(response.body).toHaveProperty('members');
            expect(Array.isArray(response.body.members)).toBe(true);
            expect(response.body.members.length).toBe(1);
        });

        it('POST /groups/join - should join group with invite code', async () => {
            const response = await request(app.getHttpServer())
                .post('/groups/join')
                .set('Authorization', `Bearer ${authToken2}`)
                .send({
                    code: groupInviteCode,
                })
                .expect(201);

            expect(response.body).toHaveProperty('message');
            expect(response.body.message).toContain('joined');
        });

        it('GET /groups/:id/members - should list group members', async () => {
            const response = await request(app.getHttpServer())
                .get(`/groups/${groupId}/members`)
                .set('Authorization', `Bearer ${authToken1}`)
                .expect(200);

            expect(Array.isArray(response.body)).toBe(true);
            expect(response.body.length).toBe(2);
            expect(response.body[0]).toHaveProperty('role');
            expect(response.body[0]).toHaveProperty('user');
        });

        it('GET /groups/:id/ranking - should get group rankings', async () => {
            const response = await request(app.getHttpServer())
                .get(`/groups/${groupId}/ranking`)
                .set('Authorization', `Bearer ${authToken1}`)
                .expect(200);

            expect(Array.isArray(response.body)).toBe(true);
            // Rankings may be empty if no XP earned yet
        });

        it('PATCH /groups/:id - should update group (owner only)', async () => {
            const response = await request(app.getHttpServer())
                .patch(`/groups/${groupId}`)
                .set('Authorization', `Bearer ${authToken1}`)
                .send({
                    name: 'Updated Study Group',
                    description: 'Updated description',
                })
                .expect(200);

            expect(response.body).toHaveProperty('name', 'Updated Study Group');
            expect(response.body).toHaveProperty('description', 'Updated description');
        });

        it('PATCH /groups/:id - should fail for non-owner', async () => {
            await request(app.getHttpServer())
                .patch(`/groups/${groupId}`)
                .set('Authorization', `Bearer ${authToken2}`)
                .send({
                    name: 'Unauthorized Update',
                })
                .expect(403);
        });

        it('DELETE /groups/:id/leave - should leave group', async () => {
            await request(app.getHttpServer())
                .delete(`/groups/${groupId}/leave`)
                .set('Authorization', `Bearer ${authToken2}`)
                .expect(200);

            // Verify member count decreased
            const response = await request(app.getHttpServer())
                .get(`/groups/${groupId}/members`)
                .set('Authorization', `Bearer ${authToken1}`)
                .expect(200);

            expect(response.body.length).toBe(1);
        });

        it('DELETE /groups/:id/leave - should fail for owner', async () => {
            await request(app.getHttpServer())
                .delete(`/groups/${groupId}/leave`)
                .set('Authorization', `Bearer ${authToken1}`)
                .expect(400);
        });

        it('DELETE /groups/:id - should delete group (owner only)', async () => {
            await request(app.getHttpServer())
                .delete(`/groups/${groupId}`)
                .set('Authorization', `Bearer ${authToken1}`)
                .expect(200);

            // Verify group is deleted
            await request(app.getHttpServer())
                .get(`/groups/${groupId}`)
                .set('Authorization', `Bearer ${authToken1}`)
                .expect(404);
        });
    });

    describe('Authorization', () => {
        it('should reject requests without auth token', async () => {
            await request(app.getHttpServer())
                .post('/invitations')
                .send({})
                .expect(401);

            await request(app.getHttpServer())
                .get('/groups')
                .expect(401);
        });

        it('should reject requests with invalid auth token', async () => {
            await request(app.getHttpServer())
                .post('/invitations')
                .set('Authorization', 'Bearer invalid_token')
                .send({})
                .expect(401);
        });
    });
});
