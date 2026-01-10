import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/conversation/domain/models/conversation.dart';
import 'package:mobile/features/conversation/domain/models/turn.dart';
import 'package:mobile/features/conversation/domain/models/suggestion.dart';

void main() {
  group('Conversation Models Tests', () {
    test('Conversation.fromJson and toJson', () {
      final now = DateTime.now();
      final json = {
        'id': 'c1',
        'mode': 'freetalk',
        'personaId': 'p1',
        'personaName': 'John',
        'startedAt': now.toIso8601String(),
        'status': 'active',
        'websocketUrl': 'ws://test',
        'token': 'secret',
      };

      final conversation = Conversation.fromJson(json);
      expect(conversation.id, 'c1');
      expect(conversation.mode, ConversationMode.freetalk);

      final backToJson = conversation.toJson();
      expect(backToJson['id'], 'c1');
    });

    test('Conversation with endedAt and topic', () {
      final now = DateTime.now();
      final ended = now.add(const Duration(minutes: 10));
      final json = {
        'id': 'c2',
        'mode': 'roleplay',
        'personaId': 'p2',
        'personaName': 'Mary',
        'startedAt': now.toIso8601String(),
        'endedAt': ended.toIso8601String(),
        'topic': 'Restaurant',
        'status': 'ended',
        'websocketUrl': 'ws://test2',
        'token': 'secret2',
      };

      final conversation = Conversation.fromJson(json);
      expect(conversation.endedAt, isNotNull);
      expect(conversation.topic, 'Restaurant');
      expect(conversation.duration.inMinutes, 10);
      expect(conversation.toJson()['topic'], 'Restaurant');
    });

    test('Conversation.duration returns a duration', () {
       final conversation = Conversation(
        id: 'c1',
        mode: ConversationMode.freetalk,
        personaId: 'p1',
        personaName: 'John',
        startedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        status: ConversationStatus.active,
        websocketUrl: 'ws://test',
        token: 'secret',
      );
      expect(conversation.duration.inMinutes, greaterThanOrEqualTo(5));
    });

    test('Turn.fromJson and toJson', () {
      final now = DateTime.now();
      final json = {
        'id': 't1',
        'speaker': 'user',
        'content': 'Hello',
        'sequence': 1,
        'createdAt': now.toIso8601String(),
        'corrections': [
          {
            'type': 'grammar',
            'original': 'I is',
            'corrected': 'I am',
            'explanation': 'Verb agreement',
            'explanationJa': '動詞の不一致',
            'severity': 'low',
          }
        ]
      };

      final turn = Turn.fromJson(json);
      expect(turn.content, 'Hello');
      expect(turn.corrections?.first.corrected, 'I am');

      final backToJson = turn.toJson();
      expect(backToJson['corrections'][0]['original'], 'I is');
    });

    test('Turn.fromJson handles null corrections', () {
      final json = {
        'id': 't1',
        'speaker': 'ai',
        'content': 'Hi',
        'sequence': 1,
        'createdAt': DateTime.now().toIso8601String(),
        'corrections': null
      };

      final turn = Turn.fromJson(json);
      expect(turn.corrections, isNull);
    });

    test('Suggestion.fromJson and toJson', () {
      final json = {
        'template': 'I would like to [word]',
        'vocabulary': [
          {
            'word': 'order',
            'pronunciation': 'ɔːrdər',
            'meaning': '注文する',
            'partOfSpeech': 'verb',
            'exampleSentence': 'I order food.',
          }
        ],
        'alternativeResponses': ['I want to order']
      };

      final suggestion = Suggestion.fromJson(json);
      expect(suggestion.vocabulary.first.word, 'order');
      expect(suggestion.alternativeResponses.length, 1);

      final backToJson = suggestion.toJson();
      expect(backToJson['vocabulary'][0]['meaning'], '注文する');
    });
  });
}
