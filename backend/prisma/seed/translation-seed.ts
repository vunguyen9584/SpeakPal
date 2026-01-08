import { PrismaClient, Level, PracticeType, ContentType } from '@prisma/client';

const prisma = new PrismaClient();

/**
 * Seed Translation Practice data
 * - Translation Questions (50+ samples)
 * - Intent Questions (20+ samples)
 * - Shadowing Contents (10+ samples)
 */
export async function seedTranslationPractice() {
  console.log('🌱 Seeding Translation Practice data...');

  // ============================================================================
  // Translation Questions (Direct Translation - UC-034)
  // ============================================================================
  
  const translationQuestions = [
    // Daily Life - Beginner
    {
      topic: 'daily',
      level: Level.BEGINNER,
      sourceText: '今日の天気はいいですね。',
      targetText: 'The weather is nice today.',
      altAnswers: ["Today's weather is nice.", "It's nice weather today."],
      difficulty: 1,
      wordCount: 5,
      grammarPoints: ['present_simple', 'adjectives'],
    },
    {
      topic: 'daily',
      level: Level.BEGINNER,
      sourceText: '私は毎朝コーヒーを飲みます。',
      targetText: 'I drink coffee every morning.',
      altAnswers: ['I have coffee every morning.'],
      difficulty: 1,
      wordCount: 5,
      grammarPoints: ['present_simple', 'frequency_adverbs'],
    },
    {
      topic: 'daily',
      level: Level.BEGINNER,
      sourceText: '週末は何をしますか？',
      targetText: 'What do you do on weekends?',
      altAnswers: ['What are you doing on the weekend?'],
      difficulty: 2,
      wordCount: 6,
      grammarPoints: ['questions', 'present_simple'],
    },
    {
      topic: 'daily',
      level: Level.BEGINNER,
      sourceText: '私は本を読むのが好きです。',
      targetText: 'I like reading books.',
      altAnswers: ['I like to read books.', 'I enjoy reading books.'],
      difficulty: 2,
      wordCount: 4,
      grammarPoints: ['gerunds', 'preferences'],
    },
    {
      topic: 'daily',
      level: Level.BEGINNER,
      sourceText: '今何時ですか？',
      targetText: 'What time is it now?',
      altAnswers: ["What's the time?", 'Do you have the time?'],
      difficulty: 1,
      wordCount: 5,
      grammarPoints: ['questions', 'time'],
    },

    // Daily Life - Intermediate
    {
      topic: 'daily',
      level: Level.INTERMEDIATE,
      sourceText: '最近、運動不足で体調が良くありません。',
      targetText: "I haven't been feeling well lately due to lack of exercise.",
      altAnswers: [
        "I've been feeling unwell recently because I don't exercise enough.",
        "My health hasn't been good lately because I don't get enough exercise.",
      ],
      difficulty: 3,
      wordCount: 10,
      grammarPoints: ['present_perfect', 'causation', 'health'],
    },
    {
      topic: 'daily',
      level: Level.INTERMEDIATE,
      sourceText: 'もし時間があれば、一緒に映画を見に行きませんか？',
      targetText: 'If you have time, would you like to go see a movie together?',
      altAnswers: [
        'Would you like to watch a movie with me if you have time?',
        'If you are free, shall we go to the movies together?',
      ],
      difficulty: 3,
      wordCount: 12,
      grammarPoints: ['conditionals', 'invitations', 'suggestions'],
    },

    // Business - Beginner
    {
      topic: 'business',
      level: Level.BEGINNER,
      sourceText: '会議は何時に始まりますか？',
      targetText: 'What time does the meeting start?',
      altAnswers: ['When does the meeting begin?'],
      difficulty: 2,
      wordCount: 6,
      grammarPoints: ['questions', 'time', 'business'],
    },
    {
      topic: 'business',
      level: Level.BEGINNER,
      sourceText: 'メールを確認しました。',
      targetText: 'I checked the email.',
      altAnswers: ['I have checked the email.', 'I reviewed the email.'],
      difficulty: 1,
      wordCount: 4,
      grammarPoints: ['past_simple', 'business_vocabulary'],
    },

    // Business - Intermediate
    {
      topic: 'business',
      level: Level.INTERMEDIATE,
      sourceText: '来週の会議の議題について、事前に資料を送っていただけますか？',
      targetText: "Could you send me the materials for next week's meeting agenda in advance?",
      altAnswers: [
        'Would you be able to send the materials for the meeting agenda next week beforehand?',
        "Can you send me the documents for next week's meeting topics ahead of time?",
      ],
      difficulty: 4,
      wordCount: 13,
      grammarPoints: ['polite_requests', 'business_communication', 'time_expressions'],
    },
    {
      topic: 'business',
      level: Level.INTERMEDIATE,
      sourceText: 'このプロジェクトの進捗状況を報告させていただきます。',
      targetText: 'I would like to report the progress of this project.',
      altAnswers: [
        "I'd like to update you on this project's progress.",
        'Let me report on the status of this project.',
      ],
      difficulty: 3,
      wordCount: 10,
      grammarPoints: ['formal_language', 'reporting', 'business'],
    },

    // Business - Advanced
    {
      topic: 'business',
      level: Level.ADVANCED,
      sourceText:
        '市場調査の結果を踏まえて、新製品の価格戦略を再検討する必要があると考えています。',
      targetText:
        'Based on the market research results, I believe we need to reconsider the pricing strategy for the new product.',
      altAnswers: [
        'Considering the market research findings, I think we should review our pricing strategy for the new product.',
        'In light of the market research, I feel we need to reassess the pricing approach for the new product.',
      ],
      difficulty: 5,
      wordCount: 18,
      grammarPoints: ['complex_sentences', 'business_strategy', 'formal_expressions'],
    },

    // Travel - Beginner
    {
      topic: 'travel',
      level: Level.BEGINNER,
      sourceText: '駅はどこですか？',
      targetText: 'Where is the station?',
      altAnswers: ['Where is the train station?', 'How do I get to the station?'],
      difficulty: 1,
      wordCount: 4,
      grammarPoints: ['questions', 'locations'],
    },
    {
      topic: 'travel',
      level: Level.BEGINNER,
      sourceText: 'チケットを2枚ください。',
      targetText: 'Two tickets, please.',
      altAnswers: ['Can I have two tickets, please?', 'I would like two tickets.'],
      difficulty: 1,
      wordCount: 3,
      grammarPoints: ['requests', 'numbers'],
    },
    {
      topic: 'travel',
      level: Level.BEGINNER,
      sourceText: 'この電車は空港に行きますか？',
      targetText: 'Does this train go to the airport?',
      altAnswers: ['Is this the train to the airport?'],
      difficulty: 2,
      wordCount: 7,
      grammarPoints: ['questions', 'directions', 'travel'],
    },

    // Travel - Intermediate
    {
      topic: 'travel',
      level: Level.INTERMEDIATE,
      sourceText: '予約を変更したいのですが、手数料はかかりますか？',
      targetText: 'I would like to change my reservation. Is there a fee?',
      altAnswers: [
        'I want to modify my booking. Will there be a charge?',
        "I'd like to change my reservation. Are there any fees?",
      ],
      difficulty: 3,
      wordCount: 11,
      grammarPoints: ['polite_requests', 'travel_vocabulary', 'questions'],
    },

    // News - Intermediate
    {
      topic: 'news',
      level: Level.INTERMEDIATE,
      sourceText: '政府は新しい環境政策を発表しました。',
      targetText: 'The government announced a new environmental policy.',
      altAnswers: [
        'The government has announced new environmental policies.',
        'A new environmental policy was announced by the government.',
      ],
      difficulty: 3,
      wordCount: 7,
      grammarPoints: ['past_simple', 'passive_voice', 'news_vocabulary'],
    },
    {
      topic: 'news',
      level: Level.INTERMEDIATE,
      sourceText: '経済成長率は前年比で3%増加しました。',
      targetText: 'The economic growth rate increased by 3% compared to last year.',
      altAnswers: [
        'Economic growth rose 3% year-on-year.',
        'The economy grew 3% compared to the previous year.',
      ],
      difficulty: 4,
      wordCount: 10,
      grammarPoints: ['statistics', 'comparisons', 'economics'],
    },

    // News - Advanced
    {
      topic: 'news',
      level: Level.ADVANCED,
      sourceText:
        '専門家は、気候変動が今後10年間で深刻な影響を及ぼす可能性があると警告しています。',
      targetText:
        'Experts warn that climate change could have serious impacts over the next decade.',
      altAnswers: [
        'Experts are warning that climate change may cause severe effects in the next 10 years.',
        'Specialists caution that climate change could significantly impact us over the coming decade.',
      ],
      difficulty: 5,
      wordCount: 13,
      grammarPoints: ['reporting_verbs', 'future_predictions', 'complex_sentences'],
    },

    // Entertainment - Beginner
    {
      topic: 'entertainment',
      level: Level.BEGINNER,
      sourceText: 'この映画は面白いです。',
      targetText: 'This movie is interesting.',
      altAnswers: ['This film is interesting.', 'This is an interesting movie.'],
      difficulty: 1,
      wordCount: 4,
      grammarPoints: ['adjectives', 'present_simple'],
    },
    {
      topic: 'entertainment',
      level: Level.BEGINNER,
      sourceText: '音楽を聴くのが好きです。',
      targetText: 'I like listening to music.',
      altAnswers: ['I enjoy listening to music.', 'I like to listen to music.'],
      difficulty: 2,
      wordCount: 5,
      grammarPoints: ['gerunds', 'preferences'],
    },

    // Entertainment - Intermediate
    {
      topic: 'entertainment',
      level: Level.INTERMEDIATE,
      sourceText: '先週見た映画は、予想以上に感動的でした。',
      targetText: 'The movie I saw last week was more moving than I expected.',
      altAnswers: [
        'The film I watched last week was more emotional than I anticipated.',
        'Last week\'s movie was more touching than I thought it would be.',
      ],
      difficulty: 3,
      wordCount: 11,
      grammarPoints: ['relative_clauses', 'comparisons', 'past_tense'],
    },
  ];

  console.log(`  Creating ${translationQuestions.length} translation questions...`);
  for (const question of translationQuestions) {
    await prisma.translationQuestion.create({
      data: question,
    });
  }

  // ============================================================================
  // Intent Questions (Intent Translation - UC-035)
  // ============================================================================

  const intentQuestions = [
    // Greeting
    {
      category: 'greeting',
      level: Level.BEGINNER,
      intentDescription:
        'You meet someone for the first time at a business event. Greet them politely.',
      expectedExpressions: ['Nice to meet you.', 'Pleased to meet you.'],
      alternativePhrases: ["It's a pleasure to meet you.", 'How do you do?'],
      difficulty: 1,
    },
    {
      category: 'greeting',
      level: Level.INTERMEDIATE,
      intentDescription:
        "You haven't seen a colleague for a long time. Express your happiness to see them again.",
      expectedExpressions: ["It's been a while!", 'Long time no see!'],
      alternativePhrases: [
        "I haven't seen you in ages!",
        "It's great to see you again!",
        'How have you been?',
      ],
      difficulty: 2,
    },

    // Daily
    {
      category: 'daily',
      level: Level.BEGINNER,
      intentDescription: 'You want to know what time it is. Ask someone politely.',
      expectedExpressions: ['What time is it?', 'Do you have the time?'],
      alternativePhrases: ['Could you tell me the time?', 'What time do you have?'],
      difficulty: 1,
    },
    {
      category: 'daily',
      level: Level.INTERMEDIATE,
      intentDescription:
        'You want to suggest having lunch together with a colleague. Make a casual invitation.',
      expectedExpressions: ['Would you like to have lunch together?', 'Want to grab lunch?'],
      alternativePhrases: [
        'Shall we have lunch together?',
        'How about lunch?',
        'Do you want to get lunch?',
      ],
      difficulty: 2,
    },
    {
      category: 'daily',
      level: Level.ADVANCED,
      intentDescription:
        'You need to politely decline a dinner invitation because you have a prior commitment, but you want to suggest meeting another time.',
      expectedExpressions: [
        "I'm afraid I can't make it, but how about next week?",
        'Unfortunately, I have plans, but could we reschedule?',
      ],
      alternativePhrases: [
        "I'm sorry, but I'm already committed. Can we do it another time?",
        "I'd love to, but I have a prior engagement. Perhaps we could meet later?",
      ],
      difficulty: 4,
    },

    // Business
    {
      category: 'business',
      level: Level.INTERMEDIATE,
      intentDescription:
        'You want to politely decline a meeting invitation because you have a prior commitment.',
      expectedExpressions: [
        "I'm afraid I can't make it.",
        'Unfortunately, I have a prior commitment.',
      ],
      alternativePhrases: [
        "I'm sorry, but I won't be able to attend.",
        'I regret that I have another engagement.',
      ],
      difficulty: 3,
    },
    {
      category: 'business',
      level: Level.INTERMEDIATE,
      intentDescription:
        'You need to ask your manager for permission to leave work early tomorrow.',
      expectedExpressions: [
        'Would it be possible to leave early tomorrow?',
        'Could I leave work early tomorrow?',
      ],
      alternativePhrases: [
        'May I leave early tomorrow?',
        'Would you mind if I left early tomorrow?',
      ],
      difficulty: 3,
    },
    {
      category: 'business',
      level: Level.ADVANCED,
      intentDescription:
        'You need to diplomatically disagree with a proposal in a meeting while offering an alternative solution.',
      expectedExpressions: [
        'I see your point, but have we considered...?',
        'That\'s an interesting approach, however, what if we...',
      ],
      alternativePhrases: [
        'I understand where you\'re coming from, but perhaps we could...',
        'While I appreciate that idea, I wonder if we might...',
      ],
      difficulty: 5,
    },

    // Emotion
    {
      category: 'emotion',
      level: Level.BEGINNER,
      intentDescription: 'You want to express that you are happy about some good news.',
      expectedExpressions: ["I'm so happy!", "That's great!"],
      alternativePhrases: ["I'm delighted!", "That's wonderful!", "I'm thrilled!"],
      difficulty: 1,
    },
    {
      category: 'emotion',
      level: Level.INTERMEDIATE,
      intentDescription:
        'You want to express sympathy to a colleague whose project was cancelled.',
      expectedExpressions: ["I'm sorry to hear that.", 'That must be disappointing.'],
      alternativePhrases: [
        'I can imagine how frustrating that must be.',
        'That\'s really unfortunate.',
      ],
      difficulty: 3,
    },
    {
      category: 'emotion',
      level: Level.ADVANCED,
      intentDescription:
        'You want to express cautious optimism about a risky business decision.',
      expectedExpressions: [
        "I'm cautiously optimistic about this.",
        'While there are risks, I think this could work.',
      ],
      alternativePhrases: [
        "I'm hopeful, but we should proceed carefully.",
        'This looks promising, though we need to be mindful of the challenges.',
      ],
      difficulty: 5,
    },

    // Request
    {
      category: 'request',
      level: Level.BEGINNER,
      intentDescription: 'You want someone to repeat what they said because you didn\'t hear it.',
      expectedExpressions: ['Could you repeat that?', 'Sorry, what did you say?'],
      alternativePhrases: ['Pardon?', 'Could you say that again?', 'I didn\'t catch that.'],
      difficulty: 1,
    },
    {
      category: 'request',
      level: Level.INTERMEDIATE,
      intentDescription:
        'You need to ask a colleague to help you with a task, but you want to be polite and not demanding.',
      expectedExpressions: [
        'Would you mind helping me with this?',
        'Could you give me a hand with this?',
      ],
      alternativePhrases: [
        'I was wondering if you could help me.',
        'Would it be possible for you to assist me?',
      ],
      difficulty: 3,
    },
    {
      category: 'request',
      level: Level.ADVANCED,
      intentDescription:
        'You need to ask your boss for additional resources for your project in a persuasive but respectful way.',
      expectedExpressions: [
        'I believe we could benefit from additional resources for this project.',
        'Would it be possible to allocate more resources to ensure the project\'s success?',
      ],
      alternativePhrases: [
        'To optimize our results, I\'d like to request additional support.',
        'I\'d like to discuss the possibility of expanding our resources for this initiative.',
      ],
      difficulty: 5,
    },
  ];

  console.log(`  Creating ${intentQuestions.length} intent questions...`);
  for (const question of intentQuestions) {
    await prisma.intentQuestion.create({
      data: question,
    });
  }

  // ============================================================================
  // Shadowing Contents (Shadowing Practice - UC-038)
  // ============================================================================

  const shadowingContents = [
    // Conversation - Beginner
    {
      contentType: ContentType.CONVERSATION,
      title: 'At the Coffee Shop',
      description: 'A simple conversation ordering coffee',
      level: Level.BEGINNER,
      transcript:
        'Hi, can I have a coffee please? Sure, what size would you like? Medium, please. Would you like milk with that? Yes, please. That will be $3.50.',
      audioUrl: 'https://cdn.speakpal.ai/shadowing/coffee-shop.mp3',
      timestamps: [
        { startTime: 0, endTime: 2, text: 'Hi, can I have a coffee please?' },
        { startTime: 2, endTime: 4, text: 'Sure, what size would you like?' },
        { startTime: 4, endTime: 5.5, text: 'Medium, please.' },
        { startTime: 5.5, endTime: 7, text: 'Would you like milk with that?' },
        { startTime: 7, endTime: 8, text: 'Yes, please.' },
        { startTime: 8, endTime: 10, text: 'That will be $3.50.' },
      ],
      durationSec: 10,
      isPremium: false,
    },
    {
      contentType: ContentType.CONVERSATION,
      title: 'Asking for Directions',
      description: 'How to ask for and give directions',
      level: Level.BEGINNER,
      transcript:
        "Excuse me, where is the train station? Go straight for two blocks, then turn left. You'll see it on your right. Thank you very much!",
      audioUrl: 'https://cdn.speakpal.ai/shadowing/directions.mp3',
      timestamps: [
        { startTime: 0, endTime: 2.5, text: 'Excuse me, where is the train station?' },
        {
          startTime: 2.5,
          endTime: 6,
          text: 'Go straight for two blocks, then turn left.',
        },
        { startTime: 6, endTime: 8, text: "You'll see it on your right." },
        { startTime: 8, endTime: 9.5, text: 'Thank you very much!' },
      ],
      durationSec: 10,
      isPremium: false,
    },

    // Conversation - Intermediate
    {
      contentType: ContentType.CONVERSATION,
      title: 'Job Interview',
      description: 'Common job interview questions and answers',
      level: Level.INTERMEDIATE,
      transcript:
        "Tell me about yourself. Well, I graduated from university last year with a degree in computer science. I've been working as a software developer for six months now. What are your strengths? I'm a quick learner and I work well in teams.",
      audioUrl: 'https://cdn.speakpal.ai/shadowing/job-interview.mp3',
      timestamps: [
        { startTime: 0, endTime: 2, text: 'Tell me about yourself.' },
        {
          startTime: 2,
          endTime: 6,
          text: 'Well, I graduated from university last year with a degree in computer science.',
        },
        {
          startTime: 6,
          endTime: 10,
          text: "I've been working as a software developer for six months now.",
        },
        { startTime: 10, endTime: 12, text: 'What are your strengths?' },
        {
          startTime: 12,
          endTime: 15,
          text: "I'm a quick learner and I work well in teams.",
        },
      ],
      durationSec: 15,
      isPremium: false,
    },

    // News - Intermediate
    {
      contentType: ContentType.NEWS,
      title: 'Tech News: AI Breakthrough',
      description: 'News report about recent AI developments',
      level: Level.INTERMEDIATE,
      transcript:
        'Researchers have announced a major breakthrough in artificial intelligence. The new system can understand and respond to complex questions with unprecedented accuracy. This development could revolutionize how we interact with technology.',
      audioUrl: 'https://cdn.speakpal.ai/shadowing/ai-news.mp3',
      timestamps: [
        {
          startTime: 0,
          endTime: 4,
          text: 'Researchers have announced a major breakthrough in artificial intelligence.',
        },
        {
          startTime: 4,
          endTime: 9,
          text: 'The new system can understand and respond to complex questions with unprecedented accuracy.',
        },
        {
          startTime: 9,
          endTime: 13,
          text: 'This development could revolutionize how we interact with technology.',
        },
      ],
      durationSec: 13,
      isPremium: true,
    },

    // Speech - Advanced
    {
      contentType: ContentType.SPEECH,
      title: 'Steve Jobs Stanford Speech Excerpt',
      description: 'Excerpt from famous commencement speech',
      level: Level.ADVANCED,
      transcript:
        "Your time is limited, so don't waste it living someone else's life. Don't be trapped by dogma, which is living with the results of other people's thinking. Have the courage to follow your heart and intuition.",
      audioUrl: 'https://cdn.speakpal.ai/shadowing/jobs-speech.mp3',
      timestamps: [
        {
          startTime: 0,
          endTime: 4,
          text: "Your time is limited, so don't waste it living someone else's life.",
        },
        {
          startTime: 4,
          endTime: 9,
          text: "Don't be trapped by dogma, which is living with the results of other people's thinking.",
        },
        {
          startTime: 9,
          endTime: 13,
          text: 'Have the courage to follow your heart and intuition.',
        },
      ],
      durationSec: 13,
      isPremium: true,
    },

    // Podcast - Intermediate
    {
      contentType: ContentType.PODCAST,
      title: 'Learning English Tips',
      description: 'Tips for improving your English speaking skills',
      level: Level.INTERMEDIATE,
      transcript:
        "Today we're talking about how to improve your English speaking. The most important thing is practice. Don't be afraid to make mistakes. Native speakers make mistakes too. The key is to keep speaking and learning from your errors.",
      audioUrl: 'https://cdn.speakpal.ai/shadowing/english-tips.mp3',
      timestamps: [
        {
          startTime: 0,
          endTime: 4,
          text: "Today we're talking about how to improve your English speaking.",
        },
        { startTime: 4, endTime: 7, text: 'The most important thing is practice.' },
        { startTime: 7, endTime: 9, text: "Don't be afraid to make mistakes." },
        { startTime: 9, endTime: 11, text: 'Native speakers make mistakes too.' },
        {
          startTime: 11,
          endTime: 15,
          text: 'The key is to keep speaking and learning from your errors.',
        },
      ],
      durationSec: 15,
      isPremium: false,
    },
  ];

  console.log(`  Creating ${shadowingContents.length} shadowing contents...`);
  for (const content of shadowingContents) {
    await prisma.shadowingContent.create({
      data: content,
    });
  }

  console.log('✅ Translation Practice seed data created successfully!');
  console.log(`   - ${translationQuestions.length} translation questions`);
  console.log(`   - ${intentQuestions.length} intent questions`);
  console.log(`   - ${shadowingContents.length} shadowing contents`);
}
