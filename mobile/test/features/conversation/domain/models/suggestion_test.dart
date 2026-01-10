import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/conversation/domain/models/suggestion.dart';

void main() {
  group('Suggestion Model Tests', () {
    test('VocabularyItem fromJson/toJson', () {
      final json = {
        'word': 'hello',
        'pronunciation': 'həˈlō',
        'meaning': 'a greeting',
        'partOfSpeech': 'exclamation',
        'exampleSentence': 'Hello, how are you?',
      };

      final item = VocabularyItem.fromJson(json);
      expect(item.word, 'hello');
      expect(item.toJson(), json);
    });

    test('Suggestion fromJson/toJson', () {
      final json = {
        'template': 'Say {word}',
        'vocabulary': [
          {
            'word': 'hello',
            'pronunciation': 'həˈlō',
            'meaning': 'a greeting',
            'partOfSpeech': 'exclamation',
            'exampleSentence': 'Hello, how are you?',
          }
        ],
        'alternativeResponses': ['Hi there', 'Good morning'],
      };

      final suggestion = Suggestion.fromJson(json);
      expect(suggestion.template, 'Say {word}');
      expect(suggestion.vocabulary.length, 1);
      expect(suggestion.vocabulary[0].word, 'hello');
      expect(suggestion.alternativeResponses, ['Hi there', 'Good morning']);
      expect(suggestion.toJson(), json);
    });
  });
}
