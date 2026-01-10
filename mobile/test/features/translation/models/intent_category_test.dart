import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/translation/models/intent_category.dart';

void main() {
  group('IntentCategory Tests', () {
    test('displayName returns correct Japanese strings', () {
      expect(IntentCategory.greeting.displayName, '挨拶');
      expect(IntentCategory.daily.displayName, '日常');
      expect(IntentCategory.business.displayName, 'ビジネス');
      expect(IntentCategory.emotion.displayName, '感情');
      expect(IntentCategory.request.displayName, '依頼');
    });

    test('icon returns correct MaterialIcons', () {
      expect(IntentCategory.greeting.icon, Icons.waving_hand);
      expect(IntentCategory.daily.icon, Icons.home);
    });

    test('value returns correct string identifiers', () {
      expect(IntentCategory.greeting.value, 'greeting');
      expect(IntentCategory.business.value, 'business');
    });
  });
}
