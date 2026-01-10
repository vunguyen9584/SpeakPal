import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/config/theme/colors.dart';

void main() {
  group('AppColors Tests', () {
    test('static color constants are correct', () {
      expect(AppColors.primary, const Color(0xFF6366F1));
      expect(AppColors.error, const Color(0xFFEF4444));
    });

    test('gradients contain colors', () {
      expect(AppColors.streakGradient.length, 2);
      expect(AppColors.xpGradient.length, 2);
    });

    test('aliases match base colors', () {
      expect(AppColors.accent, AppColors.secondary);
      expect(AppColors.textPrimary, AppColors.text);
    });
  });
}
