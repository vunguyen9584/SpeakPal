import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/config/theme/typography.dart';
import 'package:mobile/config/theme/colors.dart';

void main() {
  group('AppTypography Tests', () {
    test('font family is Inter', () {
      expect(AppTypography.fontFamily, 'Inter');
    });

    test('static constants have correct values', () {
      expect(AppTypography.displayLarge.fontSize, 32);
      expect(AppTypography.displayLarge.fontWeight, FontWeight.w700);
      expect(AppTypography.displayLarge.color, AppColors.text);
    });

    test('heading aliases work', () {
      expect(AppTypography.h1, AppTypography.displayLarge);
      expect(AppTypography.h2, AppTypography.displayMedium);
      expect(AppTypography.h3, AppTypography.displaySmall);
      expect(AppTypography.h4, AppTypography.headlineLarge);
      expect(AppTypography.h5, AppTypography.headlineMedium);
      expect(AppTypography.h6, AppTypography.headlineSmall);
    });

    test('all style getters are accessible', () {
      expect(AppTypography.displayMedium, isA<TextStyle>());
      expect(AppTypography.displaySmall, isA<TextStyle>());
      expect(AppTypography.headlineLarge, isA<TextStyle>());
      expect(AppTypography.headlineMedium, isA<TextStyle>());
      expect(AppTypography.headlineSmall, isA<TextStyle>());
      expect(AppTypography.titleLarge, isA<TextStyle>());
      expect(AppTypography.titleMedium, isA<TextStyle>());
      expect(AppTypography.titleSmall, isA<TextStyle>());
      expect(AppTypography.bodyLarge, isA<TextStyle>());
      expect(AppTypography.bodyMedium, isA<TextStyle>());
      expect(AppTypography.bodySmall, isA<TextStyle>());
      expect(AppTypography.labelLarge, isA<TextStyle>());
      expect(AppTypography.labelMedium, isA<TextStyle>());
      expect(AppTypography.labelSmall, isA<TextStyle>());
      expect(AppTypography.caption, isA<TextStyle>());
      expect(AppTypography.overline, isA<TextStyle>());
      expect(AppTypography.button, isA<TextStyle>());
      expect(AppTypography.link, isA<TextStyle>());
    });

    test('dark mode variants are correct', () {
      expect(AppTypography.displayLargeDark.color, AppColors.textDark);
      expect(AppTypography.headlineLargeDark.color, AppColors.textDark);
      expect(AppTypography.bodyLargeDark.color, AppColors.textDark);
      expect(AppTypography.labelLargeDark.color, AppColors.textDark);
    });
  });
}
