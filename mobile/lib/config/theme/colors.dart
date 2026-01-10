import 'package:flutter/material.dart';

/// App Color Palette
/// Based on Design System from DD: 09-ui-specifications.md
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ============================================================
  // Light Mode Colors
  // ============================================================

  // Primary colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary colors
  static const Color secondary = Color(0xFFEC4899); // Pink
  static const Color secondaryLight = Color(0xFFF472B6);
  static const Color secondaryDark = Color(0xFFDB2777);

  // Semantic colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // Neutral colors (Light mode)
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color surface = Color(0xFFF9FAFB); // Gray-50
  static const Color surfaceVariant = Color(0xFFF3F4F6); // Gray-100

  static const Color text = Color(0xFF111827); // Gray-900
  static const Color textSecondary = Color(0xFF6B7280); // Gray-500
  static const Color textTertiary = Color(0xFF9CA3AF); // Gray-400
  static const Color textDisabled = Color(0xFFD1D5DB); // Gray-300

  static const Color border = Color(0xFFE5E7EB); // Gray-200
  static const Color divider = Color(0xFFF3F4F6); // Gray-100

  // ============================================================
  // Dark Mode Colors
  // ============================================================

  // Neutral colors (Dark mode)
  static const Color backgroundDark = Color(0xFF111827); // Gray-900
  static const Color surfaceDark = Color(0xFF1F2937); // Gray-800
  static const Color surfaceVariantDark = Color(0xFF374151); // Gray-700

  static const Color textDark = Color(0xFFF9FAFB); // Gray-50
  static const Color textSecondaryDark = Color(0xFF9CA3AF); // Gray-400
  static const Color textTertiaryDark = Color(0xFF6B7280); // Gray-500
  static const Color textDisabledDark = Color(0xFF4B5563); // Gray-600

  static const Color borderDark = Color(0xFF374151); // Gray-700
  static const Color dividerDark = Color(0xFF1F2937); // Gray-800

  // ============================================================
  // Gamification Colors
  // ============================================================

  // League colors
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);
  static const Color platinum = Color(0xFFE5E4E2);
  static const Color diamond = Color(0xFFB9F2FF);

  // Level colors
  static const Color beginner = Color(0xFF10B981); // Green
  static const Color elementary = Color(0xFF3B82F6); // Blue
  static const Color intermediate = Color(0xFFF59E0B); // Amber
  static const Color upperIntermediate = Color(0xFFEF4444); // Red
  static const Color advanced = Color(0xFF8B5CF6); // Purple

  // ============================================================
  // Special Colors
  // ============================================================

  // Streak fire gradient
  static const List<Color> streakGradient = [
    Color(0xFFFBA838), // Amber
    Color(0xFFEF4444), // Red
  ];

  // XP gradient
  static const List<Color> xpGradient = [
    Color(0xFF6366F1), // Primary
    Color(0xFFEC4899), // Secondary
  ];

  // AI response bubble
  static const Color aiMessageBubble = Color(0xFFF3F4F6); // Gray-100
  static const Color aiMessageBubbleDark = Color(0xFF374151); // Gray-700

  // User message bubble
  static const Color userMessageBubble = Color(0xFF6366F1); // Primary
  static const Color userMessageBubbleText = Color(0xFFFFFFFF); // White

  // Correction types
  static const Color grammarCorrection = Color(0xFFEF4444); // Red
  static const Color vocabularyCorrection = Color(0xFF3B82F6); // Blue
  static const Color pronunciationCorrection = Color(0xFFF59E0B); // Amber

  // Aliases
  static const Color accent = secondary;
  static const Color textPrimary = text;
}

