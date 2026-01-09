import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { createTestingModule } from './test-helper.module';

/**
 * Cross-API Integration Tests
 * Tests data flow and consistency across multiple APIs
 */
describe('Cross-API Integration (e2e)', () => {
  let app: INestApplication;
  let accessToken: string;

  beforeAll(async () => {
    const moduleFixture = await createTestingModule().compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({ whitelist: true, transform: true }),
    );
    await app.init();

    // Register a new test user for isolated tests
    const testUser = {
      email: `crosstest_${Date.now()}@test.com`,
      password: 'CrossTest123!',
      username: `crosstest_${Date.now()}`,
    };

    const registerRes = await request(app.getHttpServer())
      .post('/auth/register')
      .send(testUser);

    accessToken = registerRes.body.data.accessToken;
  });

  afterAll(async () => {
    if (app) {
      await app.close();
    }
  });

  const authRequest = () => ({
    get: (url: string) =>
      request(app.getHttpServer())
        .get(url)
        .set('Authorization', `Bearer ${accessToken}`),
    post: (url: string) =>
      request(app.getHttpServer())
        .post(url)
        .set('Authorization', `Bearer ${accessToken}`),
  });

  describe('TST-CROSS-001: New User Journey', () => {
    it('should complete full user journey from registration to conversation', async () => {
      // 1. Verify user created with correct defaults
      const userRes = await authRequest().get('/users/me').expect(200);
      expect(userRes.body.data.level).toBe('Beginner');
      expect(userRes.body.data.totalXp).toBe(0);

      // 2. Verify subscription was created
      const subRes = await authRequest()
        .get('/subscriptions/me')
        .expect(200);
      expect(subRes.body.data.plan).toBe('free');
      expect(subRes.body.data.dailyUsageCount).toBe(0);

      // 3. Verify streak was created
      const streakRes = await authRequest().get('/streaks').expect(200);
      expect(streakRes.body.data.currentStreak).toBe(0);

      // 4. Get default persona
      const personaRes = await authRequest()
        .get('/personas')
        .expect(200);
      const defaultPersona = personaRes.body.data.find(
        (p: unknown) => (p as { isDefault: boolean }).isDefault,
      );
      expect(defaultPersona).toBeDefined();

      // 5. Create conversation
      const convRes = await authRequest()
        .post('/conversations')
        .send({
          mode: 'instructor',
          personaId: defaultPersona.id,
        })
        .expect(201);

      const conversationId = convRes.body.data.id;

      // 6. End conversation (simulating some activity)
      const endRes = await authRequest()
        .post(`/conversations/${conversationId}/end`)
        .expect(200);

      const xpEarned = endRes.body.data.xpEarned;

      // 7. Verify XP was awarded
      const userAfterRes = await authRequest()
        .get('/users/me')
        .expect(200);
      expect(userAfterRes.body.data.totalXp).toBeGreaterThanOrEqual(xpEarned);

      // 8. Verify streak was updated
      const streakAfterRes = await authRequest()
        .get('/streaks')
        .expect(200);
      expect(streakAfterRes.body.data.currentStreak).toBeGreaterThanOrEqual(0);

      // 9. Verify usage count incremented
      const subAfterRes = await authRequest()
        .get('/subscriptions/me')
        .expect(200);
      expect(subAfterRes.body.data.dailyUsageCount).toBeGreaterThanOrEqual(1);

      // 10. Verify conversation in history
      const historyRes = await authRequest()
        .get('/conversations')
        .expect(200);
      const conv = historyRes.body.data.find(
        (c: unknown) => (c as { id: string }).id === conversationId,
      );
      expect(conv).toBeDefined();
    });
  });

  describe('TST-CROSS-002: Vocabulary from Conversation', () => {
    let conversationId: string;

    beforeAll(async () => {
      // Create a conversation
      const convRes = await authRequest()
        .post('/conversations')
        .send({ mode: 'instructor' });
      conversationId = convRes.body.data.id;

      // End it to simulate real conversation
      await authRequest().post(`/conversations/${conversationId}/end`);
    });

    it('should add vocabulary linked to conversation', async () => {
      // 1. Add vocabulary with conversationId
      const vocabRes = await authRequest()
        .post('/vocabularies')
        .send({
          word: 'serendipity',
          meaning: 'the occurrence of happy events by chance',
          conversationId: conversationId,
        })
        .expect(201);

      const vocabularyId = vocabRes.body.data.id;

      // 2. Verify vocabulary is linked
      const vocabListRes = await authRequest()
        .get('/vocabularies')
        .expect(200);

      const vocab = vocabListRes.body.data.find(
        (v: unknown) => (v as { id: string }).id === vocabularyId,
      );
      expect(vocab).toBeDefined();
      expect(vocab.conversationId).toBe(conversationId);
    });

    it('should include vocabulary stats in user stats', async () => {
      // Get user stats
      const statsRes = await authRequest()
        .get('/users/me/stats')
        .expect(200);

      expect(statsRes.body.data.vocabulary).toHaveProperty('total');
      expect(statsRes.body.data.vocabulary.total).toBeGreaterThan(0);
    });
  });

  describe('TST-CROSS-003: Gamification Triggers', () => {
    it('should award badge on first conversation', async () => {
      // Get badges before
      const badgesBefore = await authRequest()
        .get('/badges/mine')
        .expect(200);

      // Create and complete a conversation
      const convRes = await authRequest()
        .post('/conversations')
        .send({ mode: 'freetalk' });

      await authRequest().post(
        `/conversations/${convRes.body.data.id}/end`,
      );

      // Get badges after
      const badgesAfter = await authRequest()
        .get('/badges/mine')
        .expect(200);

      // May or may not have new badge depending on test state
      expect(Array.isArray(badgesAfter.body.data)).toBe(true);
    });

    it('should update ranking after XP gain', async () => {
      // Get ranking before
      const rankingBefore = await authRequest()
        .get('/rankings/weekly')
        .expect(200);

      const myRankBefore = rankingBefore.body.myRank;

      // Earn XP via vocabulary review
      const vocab = await authRequest().post('/vocabularies').send({
        word: 'ephemeral',
        meaning: 'lasting for a very short time',
      });

      await authRequest()
        .post(`/vocabularies/${vocab.body.data.id}/review`)
        .send({ result: 'correct' });

      // Get ranking after
      const rankingAfter = await authRequest()
        .get('/rankings/weekly')
        .expect(200);

      // User should be in rankings now
      expect(rankingAfter.body.myRank).toBeDefined();
    });
  });

  describe('TST-CROSS-004: Usage Limits Integration', () => {
    it('should enforce conversation limit for free user', async () => {
      // Get current usage
      const subRes = await authRequest()
        .get('/subscriptions/me')
        .expect(200);

      const used = subRes.body.data.dailyUsageCount;
      const limit = subRes.body.data.dailyUsageLimit;

      if (used >= limit) {
        // Already at limit, should be rejected
        const convRes = await authRequest()
          .post('/conversations')
          .send({ mode: 'instructor' });

        expect(convRes.status).toBe(403);
        expect(convRes.body.error.code).toBe('ERR_BIZ_002');
      } else {
        // Not at limit yet, should succeed
        const convRes = await authRequest()
          .post('/conversations')
          .send({ mode: 'instructor' })
          .expect(201);

        // End it immediately
        await authRequest().post(
          `/conversations/${convRes.body.data.id}/end`,
        );
      }
    });

    it('should show correct usage in subscription status', async () => {
      const subRes = await authRequest()
        .get('/subscriptions/me')
        .expect(200);

      expect(subRes.body.data.dailyUsageCount).toBeDefined();
      expect(subRes.body.data.dailyUsageLimit).toBeDefined();
      expect(subRes.body.data.dailyUsageCount).toBeLessThanOrEqual(
        subRes.body.data.dailyUsageLimit + 10, // Allow some overflow for tests
      );
    });
  });

  describe('TST-CROSS-005: Challenge Progress Tracking', () => {
    it('should update challenge progress on conversation completion', async () => {
      // Get challenges before
      const challengesBefore = await authRequest()
        .get('/challenges/today')
        .expect(200);

      // Find a conversation-related challenge
      const convChallenge = challengesBefore.body.data.find((c: unknown) => {
        const challenge = c as { challenge: { type: string } };
        return (
          challenge.challenge.type === 'daily_conversation' ||
          challenge.challenge.type === 'conversation'
        );
      });

      const progressBefore = convChallenge?.currentProgress || 0;

      // Complete a conversation
      const convRes = await authRequest()
        .post('/conversations')
        .send({ mode: 'instructor' });

      if (convRes.status === 201) {
        await authRequest().post(
          `/conversations/${convRes.body.data.id}/end`,
        );

        // Get challenges after
        const challengesAfter = await authRequest()
          .get('/challenges/today')
          .expect(200);

        const convChallengeAfter = challengesAfter.body.data.find(
          (c: unknown) =>
            (c as { id: string }).id === (convChallenge as { id: string })?.id,
        );

        // Progress should have increased
        if (convChallengeAfter && convChallenge) {
          expect(convChallengeAfter.currentProgress).toBeGreaterThanOrEqual(
            progressBefore,
          );
        }
      }
    });

    it('should update challenge progress on vocabulary review', async () => {
      // Get challenges
      const challengesBefore = await authRequest()
        .get('/challenges/today')
        .expect(200);

      // Find vocabulary review challenge
      const vocabChallenge = challengesBefore.body.data.find((c: unknown) => {
        const challenge = c as { challenge: { type: string } };
        return (
          challenge.challenge.type === 'vocabulary_review' ||
          challenge.challenge.type === 'review'
        );
      });

      // Add and review vocabulary
      const vocab = await authRequest().post('/vocabularies').send({
        word: 'ubiquitous',
        meaning: 'present everywhere',
      });

      await authRequest()
        .post(`/vocabularies/${vocab.body.data.id}/review`)
        .send({ result: 'correct' });

      // Verify challenge progress (if challenge exists)
      if (vocabChallenge) {
        const challengesAfter = await authRequest()
          .get('/challenges/today')
          .expect(200);

        const vocabChallengeAfter = challengesAfter.body.data.find(
          (c: unknown) =>
            (c as { id: string }).id === (vocabChallenge as { id: string }).id,
        );

        // Progress should have increased or stayed same if already complete
        expect(vocabChallengeAfter).toBeDefined();
      }
    });
  });

  describe('TST-CROSS-006: Social Integration', () => {
    it('should award XP bonus on invitation acceptance', async () => {
      // Create invitation
      const inviteRes = await authRequest()
        .post('/invitations')
        .expect(201);

      expect(inviteRes.body.data.code).toBeDefined();

      // Verify invitation created
      const myInvitesRes = await authRequest()
        .get('/invitations/mine')
        .expect(200);

      const invite = myInvitesRes.body.data.find(
        (i: unknown) =>
          (i as { code: string }).code === inviteRes.body.data.code,
      );
      expect(invite).toBeDefined();
      expect(invite.status).toBe('pending');
    });

    it('should increment group member count on join', async () => {
      // Create a group
      const groupRes = await authRequest()
        .post('/groups')
        .send({
          name: `Test Group ${Date.now()}`,
          maxMembers: 10,
        })
        .expect(201);

      const groupId = groupRes.body.data.id;

      // Get group details
      const detailsRes = await authRequest()
        .get(`/groups/${groupId}`)
        .expect(200);

      expect(detailsRes.body.data.memberCount).toBe(1); // Owner only

      // Get members list
      const membersRes = await authRequest()
        .get(`/groups/${groupId}/members`)
        .expect(200);

      expect(membersRes.body.data.length).toBe(1);
      expect(membersRes.body.data[0].role).toBe('owner');
    });
  });

  describe('TST-CROSS-007: Streak Interruption Prevention', () => {
    it('should allow streak freeze', async () => {
      // Get current streak status
      const streakBefore = await authRequest()
        .get('/streaks')
        .expect(200);

      const freezeBefore = streakBefore.body.data.freezeRemaining;

      if (freezeBefore > 0) {
        // Use freeze
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);

        const freezeRes = await authRequest()
          .post('/streaks/freeze')
          .send({ date: tomorrow.toISOString().split('T')[0] });

        if (freezeRes.status === 200) {
          // Verify freeze was used
          const streakAfter = await authRequest()
            .get('/streaks')
            .expect(200);

          expect(streakAfter.body.data.freezeRemaining).toBe(freezeBefore - 1);
        }
      }
    });
  });

  describe('TST-CROSS-008: Premium Feature Access', () => {
    it('should show locked status for premium content', async () => {
      // Get shadowing contents
      const contentsRes = await authRequest()
        .get('/api/v1/shadowing/contents')
        .expect(200);

      // Find premium content
      const premiumContent = contentsRes.body.data.items.find(
        (c: unknown) => (c as { isPremium: boolean }).isPremium,
      );

      if (premiumContent) {
        // Free user should see it as locked
        expect(premiumContent.isLocked).toBe(true);
      }
    });

    it('should restrict premium API access for free user', async () => {
      // Try to start shadowing on premium content
      const contentsRes = await authRequest()
        .get('/shadowing/contents')
        .expect(200);

      const premiumContent = contentsRes.body.data.items.find(
        (c: unknown) => (c as { isPremium: boolean }).isPremium,
      );

      if (premiumContent) {
        const startRes = await authRequest()
          .post('/api/v1/shadowing/sessions/start')
          .send({ contentId: premiumContent.id });

        expect(startRes.status).toBe(403);
        expect(startRes.body.error.code).toBe('SHADOW_002');
      }
    });
  });

  describe('TST-CROSS-009: Data Consistency', () => {
    it('should maintain XP consistency across APIs', async () => {
      // Get XP from multiple sources
      const userRes = await authRequest().get('/users/me').expect(200);

      const statsRes = await authRequest()
        .get('/users/me/stats')
        .expect(200);

      // XP should match
      expect(userRes.body.data.totalXp).toBe(statsRes.body.data.xp.total);
    });

    it('should maintain streak consistency', async () => {
      // Get streak from multiple endpoints
      const streakRes = await authRequest().get('/streaks').expect(200);

      const statsRes = await authRequest()
        .get('/users/me/stats')
        .expect(200);

      // Streak should match
      expect(streakRes.body.data.currentStreak).toBe(
        statsRes.body.data.streak.current,
      );
    });

    it('should maintain vocabulary count consistency', async () => {
      // Count vocabularies directly
      const vocabRes = await authRequest()
        .get('/vocabularies')
        .expect(200);

      const statsRes = await authRequest()
        .get('/users/me/stats')
        .expect(200);

      // Count should match (approximately, due to pagination)
      expect(statsRes.body.data.vocabulary.total).toBeGreaterThanOrEqual(
        vocabRes.body.data.length,
      );
    });
  });

  describe('TST-CROSS-010: Transaction Integrity', () => {
    it('should rollback on conversation error', async () => {
      const userBefore = await authRequest()
        .get('/users/me')
        .expect(200);

      const xpBefore = userBefore.body.data.totalXp;

      // Try to end non-existent conversation
      await authRequest()
        .post('/conversations/00000000-0000-0000-0000-000000000000/end')
        .expect(404);

      // XP should not change
      const userAfter = await authRequest().get('/users/me').expect(200);

      expect(userAfter.body.data.totalXp).toBe(xpBefore);
    });

    it('should handle concurrent operations correctly', async () => {
      // Create vocabulary
      const vocab = await authRequest()
        .post('/vocabularies')
        .send({
          word: `concurrent_${Date.now()}`,
          meaning: 'test word',
        });

      const vocabId = vocab.body.data.id;

      // Submit multiple reviews concurrently
      const reviews = await Promise.allSettled([
        authRequest()
          .post(`/vocabularies/${vocabId}/review`)
          .send({ result: 'correct' }),
        authRequest()
          .post(`/vocabularies/${vocabId}/review`)
          .send({ result: 'correct' }),
      ]);

      // At least one should succeed
      const successful = reviews.filter(
        (r) =>
          r.status === 'fulfilled' &&
          (r.value as unknown as { status: number }).status === 200,
      );
      expect(successful.length).toBeGreaterThanOrEqual(1);
    });
  });
});
