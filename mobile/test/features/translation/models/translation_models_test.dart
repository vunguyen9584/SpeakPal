import 'package:flutter_test/flutter_test.dart';

// Simple test data classes for testing
class TestTranslationQuestion {
  final String id;
  final String sourceText;
  final String sourceLanguage;
  final String targetLanguage;
  final String topic;
  final String difficulty;
  final List<String> grammarPoints;
  final String? modelAnswer;

  const TestTranslationQuestion({
    required this.id,
    required this.sourceText,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.topic,
    required this.difficulty,
    required this.grammarPoints,
    this.modelAnswer,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'sourceText': sourceText,
    'sourceLanguage': sourceLanguage,
    'targetLanguage': targetLanguage,
    'topic': topic,
    'difficulty': difficulty,
    'grammarPoints': grammarPoints,
    'modelAnswer': modelAnswer,
  };

  factory TestTranslationQuestion.fromJson(Map<String, dynamic> json) =>
      TestTranslationQuestion(
        id: json['id'],
        sourceText: json['sourceText'],
        sourceLanguage: json['sourceLanguage'],
        targetLanguage: json['targetLanguage'],
        topic: json['topic'],
        difficulty: json['difficulty'],
        grammarPoints: List<String>.from(json['grammarPoints']),
        modelAnswer: json['modelAnswer'],
      );
}

class TestScoreBreakdown {
  final int grammarScore;
  final int vocabularyScore;
  final int speedScore;

  const TestScoreBreakdown({
    required this.grammarScore,
    required this.vocabularyScore,
    required this.speedScore,
  });
}

class TestTranslationResult {
  final String id;
  final String questionId;
  final String userAnswer;
  final int totalScore;
  final TestScoreBreakdown breakdown;
  final String modelAnswer;
  final List<String> feedback;
  final int xpEarned;

  const TestTranslationResult({
    required this.id,
    required this.questionId,
    required this.userAnswer,
    required this.totalScore,
    required this.breakdown,
    required this.modelAnswer,
    required this.feedback,
    required this.xpEarned,
  });
}

void main() {
  group('TranslationQuestion Model Tests', () {
    test('should create TranslationQuestion from JSON', () {
      final json = {
        'id': 'q1',
        'sourceText': 'こんにちは',
        'sourceLanguage': '日本語',
        'targetLanguage': 'English',
        'topic': 'daily',
        'difficulty': 'beginner',
        'grammarPoints': ['greeting'],
        'modelAnswer': 'Hello',
      };

      final question = TestTranslationQuestion.fromJson(json);

      expect(question.id, 'q1');
      expect(question.sourceText, 'こんにちは');
      expect(question.difficulty, 'beginner');
      expect(question.grammarPoints, ['greeting']);
    });

    test('should convert TranslationQuestion to JSON', () {
      const question = TestTranslationQuestion(
        id: 'q1',
        sourceText: 'こんにちは',
        sourceLanguage: '日本語',
        targetLanguage: 'English',
        topic: 'daily',
        difficulty: 'beginner',
        grammarPoints: ['greeting'],
      );

      final json = question.toJson();

      expect(json['id'], 'q1');
      expect(json['sourceText'], 'こんにちは');
      expect(json['grammarPoints'], ['greeting']);
    });
  });

  group('TranslationResult Model Tests', () {
    test('should create TranslationResult with breakdown', () {
      const result = TestTranslationResult(
        id: 'r1',
        questionId: 'q1',
        userAnswer: 'Hello',
        totalScore: 85,
        breakdown: TestScoreBreakdown(
          grammarScore: 35,
          vocabularyScore: 25,
          speedScore: 25,
        ),
        modelAnswer: 'Hello, how are you?',
        feedback: ['✓ Good pronunciation'],
        xpEarned: 20,
      );

      expect(result.totalScore, 85);
      expect(result.breakdown.grammarScore, 35);
      expect(result.xpEarned, 20);
    });

    test('should calculate total from breakdown', () {
      const breakdown = TestScoreBreakdown(
        grammarScore: 40,
        vocabularyScore: 30,
        speedScore: 30,
      );

      final total = breakdown.grammarScore + 
                    breakdown.vocabularyScore + 
                    breakdown.speedScore;

      expect(total, 100);
    });
  });

  group('Score Calculation Tests', () {
    test('should handle perfect scores', () {
      const breakdown = TestScoreBreakdown(
        grammarScore: 40,
        vocabularyScore: 30,
        speedScore: 30,
      );

      expect(breakdown.grammarScore, 40);
      expect(breakdown.vocabularyScore, 30);
      expect(breakdown.speedScore, 30);
    });

    test('should handle zero scores', () {
      const breakdown = TestScoreBreakdown(
        grammarScore: 0,
        vocabularyScore: 0,
        speedScore: 0,
      );

      final total = breakdown.grammarScore + 
                    breakdown.vocabularyScore + 
                    breakdown.speedScore;

      expect(total, 0);
    });

    test('should handle partial scores', () {
      const breakdown = TestScoreBreakdown(
        grammarScore: 20,
        vocabularyScore: 15,
        speedScore: 15,
      );

      final total = breakdown.grammarScore + 
                    breakdown.vocabularyScore + 
                    breakdown.speedScore;

      expect(total, 50);
    });
  });
}
