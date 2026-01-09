import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { createTestingModule } from './test-helper.module';

/**
 * API Integration Test Suite
 * Tests the complete user journey from registration to conversation completion
 */
describe('API Integration - Full User Journey (e2e)', () => {
  let app: INestApplication;
  let accessToken: string;
  let refreshToken: string;
  let userId: string;
  let personaId: string;
  let conversationId: string;
  let websocketToken: string;

  beforeAll(async () => {
    const moduleFixture = await createTestingModule().compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({ whitelist: true, transform: true }),
    );
    await app.init();
  });

  afterAll(async () => {
    if (app) {
      await app.close();
    }
  });

  // Helper function for authenticated requests
  const authRequest = () =>
    request(app.getHttpServer()).set('Authorization', `Bearer ${accessToken}`);

  describe('1. Auth Flow', () => {
    const testUser = {
      email: `testuser_${Date.now()}@test.com`,
      password: 'SecurePass123!',
      username: `testuser_${Date.now()}`,
    };

    it('TST-AUTH-001: should register a new user', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/auth/register')
        .send(testUser)
        .expect(201);

      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveProperty('accessToken');
      expect(response.body.data).toHaveProperty('refreshToken');
      expect(response.body.data).toHaveProperty('user');
      expect(response.body.data.user.email).toBe(testUser.email);
      expect(response.body.data.user.level).toBe('Beginner');
      expect(response.body.data.user.totalXp).toBe(0);

      accessToken = response.body.data.accessToken;
      refreshToken = response.body.data.refreshToken;
      userId = response.body.data.user.id;
    });

    it('TST-AUTH-001: accessToken should work for protected endpoints', async () => {
      const response = await authRequest().get('/api/v1/users/me').expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.id).toBe(userId);
    });

    it('TST-AUTH-001: default subscription should be created', async () => {
      const response = await authRequest()
        .get('/api/v1/subscriptions/me')
        .expect(200);

      expect(response.body.data.plan).toBe('free');
      expect(response.body.data.dailyUsageLimit).toBeGreaterThan(0);
    });

    it('TST-AUTH-001: streak record should be created', async () => {
      const response = await authRequest().get('/api/v1/streaks').expect(200);

      expect(response.body.data.currentStreak).toBe(0);
    });

    it('TST-AUTH-001: default persona should be created', async () => {
      const response = await authRequest().get('/api/v1/personas').expect(200);

      expect(response.body.data.length).toBeGreaterThanOrEqual(1);
      const defaultPersona = response.body.data.find(
        (p: unknown) => (p as { isDefault: boolean }).isDefault,
      );
      expect(defaultPersona).toBeDefined();
      personaId = defaultPersona.id;
    });

    it('TST-AUTH-002: should login with credentials', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/auth/login')
        .send({
          email: testUser.email,
          password: testUser.password,
        })
        .expect(200);

      expect(response.body.data.accessToken).toBeDefined();
    });

    it('TST-AUTH-002: should refresh token', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/auth/refresh')
        .send({ refreshToken })
        .expect(200);

      expect(response.body.data.accessToken).toBeDefined();
      accessToken = response.body.data.accessToken;
    });

    it('TST-AUTH-003: should reject invalid email format', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/auth/register')
        .send({
          email: 'notanemail',
          password: 'SecurePass123!',
          username: 'validuser',
        })
        .expect(400);

      expect(response.body.success).toBe(false);
    });

    it('TST-AUTH-003: should reject weak password', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/auth/register')
        .send({
          email: 'valid@email.com',
          password: 'weak',
          username: 'validuser',
        })
        .expect(400);

      expect(response.body.success).toBe(false);
    });

    it('TST-AUTH-003: should reject duplicate email', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/auth/register')
        .send(testUser)
        .expect(409);

      expect(response.body.success).toBe(false);
      expect(response.body.error.code).toBe('AUTH_001');
    });
  });

  describe('2. User Profile Flow', () => {
    it('TST-USER-001: should get user profile', async () => {
      const response = await authRequest().get('/api/v1/users/me').expect(200);

      expect(response.body.data).toHaveProperty('id');
      expect(response.body.data).toHaveProperty('email');
      expect(response.body.data).toHaveProperty('username');
      expect(response.body.data).toHaveProperty('level');
      expect(response.body.data).toHaveProperty('totalXp');
    });

    it('TST-USER-001: should update user profile', async () => {
      const newUsername = `updated_${Date.now()}`;
      const response = await authRequest()
        .put('/api/v1/users/me')
        .send({
          username: newUsername,
          aiSpeed: 1.5,
          confirmationMode: true,
        })
        .expect(200);

      expect(response.body.data.username).toBe(newUsername);
      expect(response.body.data.aiSpeed).toBe(1.5);
      expect(response.body.data.confirmationMode).toBe(true);
    });

    it('TST-USER-001: should get user stats', async () => {
      const response = await authRequest()
        .get('/api/v1/users/me/stats')
        .expect(200);

      expect(response.body.data).toHaveProperty('streak');
      expect(response.body.data).toHaveProperty('xp');
      expect(response.body.data).toHaveProperty('conversations');
      expect(response.body.data).toHaveProperty('vocabulary');
    });
  });

  describe('3. Persona Management Flow', () => {
    let customPersonaId: string;

    it('TST-PERSONA-001: should list personas', async () => {
      const response = await authRequest().get('/api/v1/personas').expect(200);

      expect(Array.isArray(response.body.data)).toBe(true);
    });

    it('TST-PERSONA-001: should create custom persona', async () => {
      const response = await authRequest()
        .post('/api/v1/personas')
        .send({
          name: 'Business Mentor',
          language: 'en-US',
          voiceType: 'professional',
          personality: 'formal',
          instructions: 'Focus on business vocabulary',
        })
        .expect(201);

      expect(response.body.data.name).toBe('Business Mentor');
      customPersonaId = response.body.data.id;
    });

    it('TST-PERSONA-001: should get persona by id', async () => {
      const response = await authRequest()
        .get(`/api/v1/personas/${customPersonaId}`)
        .expect(200);

      expect(response.body.data.id).toBe(customPersonaId);
    });

    it('TST-PERSONA-001: should update persona', async () => {
      const response = await authRequest()
        .put(`/api/v1/personas/${customPersonaId}`)
        .send({ name: 'Updated Mentor' })
        .expect(200);

      expect(response.body.data.name).toBe('Updated Mentor');
    });

    it('TST-PERSONA-001: should set persona as default', async () => {
      await authRequest()
        .put(`/api/v1/personas/${customPersonaId}/default`)
        .expect(200);

      const response = await authRequest().get('/api/v1/personas').expect(200);

      const defaultPersona = response.body.data.find(
        (p: unknown) => (p as { isDefault: boolean }).isDefault,
      );
      expect(defaultPersona.id).toBe(customPersonaId);
    });

    it('TST-PERSONA-001: should delete non-default persona', async () => {
      // Create another persona to delete
      const createRes = await authRequest()
        .post('/api/v1/personas')
        .send({
          name: 'To Delete',
          language: 'en-US',
          voiceType: 'casual',
          personality: 'friendly',
        })
        .expect(201);

      await authRequest()
        .delete(`/api/v1/personas/${createRes.body.data.id}`)
        .expect(204);
    });
  });

  describe('4. Learning Flow', () => {
    let vocabularyId: string;

    it('TST-LEARN-001: should add vocabulary', async () => {
      const response = await authRequest()
        .post('/api/v1/vocabularies')
        .send({
          word: 'eloquent',
          meaning: 'fluent or persuasive in speaking',
          pronunciation: '/ˈeləkwənt/',
          exampleSentence: 'She gave an eloquent speech.',
        })
        .expect(201);

      expect(response.body.data.word).toBe('eloquent');
      expect(response.body.data.srsLevel).toBe('new');
      vocabularyId = response.body.data.id;
    });

    it('TST-LEARN-001: should list vocabularies', async () => {
      const response = await authRequest()
        .get('/api/v1/vocabularies')
        .expect(200);

      expect(Array.isArray(response.body.data)).toBe(true);
      const vocab = response.body.data.find(
        (v: unknown) => (v as { id: string }).id === vocabularyId,
      );
      expect(vocab).toBeDefined();
    });

    it('TST-LEARN-001: should get due vocabularies', async () => {
      const response = await authRequest()
        .get('/api/v1/vocabularies/due')
        .expect(200);

      expect(response.body).toHaveProperty('totalDue');
    });

    it('TST-LEARN-001: should review vocabulary', async () => {
      const response = await authRequest()
        .post(`/api/v1/vocabularies/${vocabularyId}/review`)
        .send({ result: 'correct' })
        .expect(200);

      expect(response.body.data).toHaveProperty('previousLevel');
      expect(response.body.data).toHaveProperty('newLevel');
      expect(response.body.data).toHaveProperty('xpEarned');
    });

    it('TST-LEARN-002: should list scenarios', async () => {
      const response = await authRequest().get('/api/v1/scenarios').expect(200);

      expect(Array.isArray(response.body.data)).toBe(true);
    });

    it('TST-LEARN-002: should filter scenarios by category', async () => {
      const response = await authRequest()
        .get('/api/v1/scenarios?category=business')
        .expect(200);

      response.body.data.forEach((scenario: unknown) => {
        expect((scenario as { category: string }).category).toBe('business');
      });
    });

    it('TST-LEARN-003: should get today challenges', async () => {
      const response = await authRequest()
        .get('/api/v1/challenges/today')
        .expect(200);

      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });

  describe('5. Gamification Flow', () => {
    it('TST-GAME-001: should get streak info', async () => {
      const response = await authRequest().get('/api/v1/streaks').expect(200);

      expect(response.body.data).toHaveProperty('currentStreak');
      expect(response.body.data).toHaveProperty('longestStreak');
      expect(response.body.data).toHaveProperty('freezeRemaining');
    });

    it('TST-GAME-002: should list all badges', async () => {
      const response = await authRequest().get('/api/v1/badges').expect(200);

      expect(Array.isArray(response.body.data)).toBe(true);
    });

    it('TST-GAME-002: should get earned badges', async () => {
      const response = await authRequest()
        .get('/api/v1/badges/mine')
        .expect(200);

      expect(Array.isArray(response.body.data)).toBe(true);
    });

    it('TST-GAME-003: should get weekly ranking', async () => {
      const response = await authRequest()
        .get('/api/v1/rankings/weekly')
        .expect(200);

      expect(response.body).toHaveProperty('league');
      expect(response.body).toHaveProperty('weekNumber');
      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });

  describe('6. Conversation Flow', () => {
    it('TST-CONV-001: should create conversation', async () => {
      const response = await authRequest()
        .post('/api/v1/conversations')
        .send({
          mode: 'instructor',
          personaId: personaId,
          topic: 'Daily conversation practice',
        })
        .expect(201);

      expect(response.body.data).toHaveProperty('id');
      expect(response.body.data).toHaveProperty('websocketUrl');
      expect(response.body.data).toHaveProperty('token');
      expect(response.body.data.mode).toBe('instructor');

      conversationId = response.body.data.id;
      websocketToken = response.body.data.token;
    });

    it('TST-CONV-001: should get conversation by id', async () => {
      const response = await authRequest()
        .get(`/api/v1/conversations/${conversationId}`)
        .expect(200);

      expect(response.body.data.id).toBe(conversationId);
    });

    it('TST-CONV-001: should end conversation', async () => {
      const response = await authRequest()
        .post(`/api/v1/conversations/${conversationId}/end`)
        .expect(200);

      expect(response.body.data).toHaveProperty('summary');
      expect(response.body.data).toHaveProperty('durationSeconds');
      expect(response.body.data).toHaveProperty('xpEarned');
    });

    it('TST-CONV-001: should get conversation turns', async () => {
      const response = await authRequest()
        .get(`/api/v1/conversations/${conversationId}/turns`)
        .expect(200);

      expect(Array.isArray(response.body.data)).toBe(true);
    });

    it('TST-CONV-001: should list conversations', async () => {
      const response = await authRequest()
        .get('/api/v1/conversations')
        .expect(200);

      expect(Array.isArray(response.body.data)).toBe(true);
      const conv = response.body.data.find(
        (c: unknown) => (c as { id: string }).id === conversationId,
      );
      expect(conv).toBeDefined();
    });
  });

  describe('7. Social Flow', () => {
    let invitationCode: string;

    it('TST-SOCIAL-001: should create invitation', async () => {
      const response = await authRequest()
        .post('/api/v1/invitations')
        .expect(201);

      expect(response.body.data).toHaveProperty('code');
      expect(response.body.data).toHaveProperty('shareUrl');
      expect(response.body.data.status).toBe('pending');
      invitationCode = response.body.data.code;
    });

    it('TST-SOCIAL-001: should list my invitations', async () => {
      const response = await authRequest()
        .get('/api/v1/invitations/mine')
        .expect(200);

      expect(Array.isArray(response.body.data)).toBe(true);
      const invitation = response.body.data.find(
        (i: unknown) => (i as { code: string }).code === invitationCode,
      );
      expect(invitation).toBeDefined();
    });

    it('TST-SOCIAL-002: should create group', async () => {
      const response = await authRequest()
        .post('/api/v1/groups')
        .send({
          name: 'Test Study Group',
          description: 'A group for testing',
          maxMembers: 10,
        })
        .expect(201);

      expect(response.body.data.name).toBe('Test Study Group');
    });

    it('TST-SOCIAL-002: should list groups', async () => {
      const response = await authRequest().get('/api/v1/groups').expect(200);

      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });

  describe('8. Subscription Flow', () => {
    it('TST-SUB-001: should get subscription status', async () => {
      const response = await authRequest()
        .get('/api/v1/subscriptions/me')
        .expect(200);

      expect(response.body.data).toHaveProperty('plan');
      expect(response.body.data).toHaveProperty('dailyUsageCount');
      expect(response.body.data).toHaveProperty('dailyUsageLimit');
      expect(response.body.data).toHaveProperty('features');
    });
  });

  describe('9. Translation Flow', () => {
    it('TST-TRANS-001: should get translation question', async () => {
      const response = await authRequest()
        .get('/api/v1/translation/questions?topic=daily')
        .expect(200);

      expect(response.body.data).toHaveProperty('id');
      expect(response.body.data).toHaveProperty('sourceText');
      expect(response.body.data).toHaveProperty('timeLimit');
    });

    it('TST-TRANS-005: should get shadowing contents', async () => {
      const response = await authRequest()
        .get('/api/v1/shadowing/contents')
        .expect(200);

      expect(response.body.data).toHaveProperty('items');
      expect(response.body.data).toHaveProperty('pagination');
    });
  });

  describe('10. Error Handling', () => {
    it('TST-ERR-001: should reject request without token', async () => {
      await request(app.getHttpServer()).get('/api/v1/users/me').expect(401);
    });

    it('TST-ERR-001: should reject request with invalid token', async () => {
      await request(app.getHttpServer())
        .get('/api/v1/users/me')
        .set('Authorization', 'Bearer invalid_token')
        .expect(401);
    });

    it('TST-ERR-003: should return 404 for non-existent resource', async () => {
      await authRequest()
        .get('/api/v1/conversations/00000000-0000-0000-0000-000000000000')
        .expect(404);
    });
  });
});
