import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/config/theme/text_styles.dart';
import 'package:mobile/config/theme/typography.dart';

void main() {
  group('AppTextStyles Tests', () {
    test('h1 matches displayLarge', () {
      expect(AppTextStyles.h1, AppTypography.displayLarge);
    });

    test('bodyMedium matches bodyMedium', () {
      expect(AppTextStyles.bodyMedium, AppTypography.bodyMedium);
    });

    test('caption matches caption', () {
      expect(AppTextStyles.caption, AppTypography.caption);
    });

    // Calling more getters to increase coverage
    test('access all getters', () {
      expect(AppTextStyles.h2, isA<TextStyle>());
      expect(AppTextStyles.h3, isA<TextStyle>());
      expect(AppTextStyles.h4, isA<TextStyle>());
      expect(AppTextStyles.h5, isA<TextStyle>());
      expect(AppTextStyles.h6, isA<TextStyle>());
      expect(AppTextStyles.titleLarge, isA<TextStyle>());
      expect(AppTextStyles.titleMedium, isA<TextStyle>());
      expect(AppTextStyles.titleSmall, isA<TextStyle>());
      expect(AppTextStyles.bodyLarge, isA<TextStyle>());
      expect(AppTextStyles.bodySmall, isA<TextStyle>());
      expect(AppTextStyles.labelLarge, isA<TextStyle>());
      expect(AppTextStyles.labelMedium, isA<TextStyle>());
      expect(AppTextStyles.labelSmall, isA<TextStyle>());
      expect(AppTextStyles.overline, isA<TextStyle>());
      expect(AppTextStyles.button, isA<TextStyle>());
    });
  });
}
