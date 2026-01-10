import 'package:flutter/material.dart';
import 'colors.dart';

/// App Typography System
/// Based on Design System from DD: 09-ui-specifications.md
/// Using Inter font family
class AppTypography {
  // Private constructor to prevent instantiation
  AppTypography._();

  // Font family
  static const String fontFamily = 'Inter';

  // Heading Aliases
  static TextStyle get h1 => displayLarge;
  static TextStyle get h2 => displayMedium;
  static TextStyle get h3 => displaySmall;
  static TextStyle get h4 => headlineLarge;
  static TextStyle get h5 => headlineMedium;
  static TextStyle get h6 => headlineSmall;

  // ============================================================
  // Display Styles (Large headings)
  // ============================================================

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700, // Bold
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.text,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.text,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.25,
    color: AppColors.text,
  );

  // ============================================================
  // Headline Styles (Section headings)
  // ============================================================

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.text,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.text,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.text,
  );

  // ============================================================
  // Title Styles (Card titles, list titles)
  // ============================================================

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.text,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.text,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.text,
  );

  // ============================================================
  // Body Styles (Main content text)
  // ============================================================

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.text,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.text,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // Label Styles (Buttons, tabs, labels)
  // ============================================================

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.15,
    color: AppColors.text,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.text,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // Special Styles
  // ============================================================

  // Caption (Helper text, timestamps)
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.4,
    color: AppColors.textTertiary,
  );

  // Overline (Category labels, tags)
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.6,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
    color: Colors.white,
  );

  // Link text
  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // ============================================================
  // Dark Mode Variants
  // ============================================================

  static TextStyle displayLargeDark = displayLarge.copyWith(
    color: AppColors.textDark,
  );

  static TextStyle headlineLargeDark = headlineLarge.copyWith(
    color: AppColors.textDark,
  );

  static TextStyle bodyLargeDark = bodyLarge.copyWith(
    color: AppColors.textDark,
  );

  static TextStyle labelLargeDark = labelLarge.copyWith(
    color: AppColors.textDark,
  );
}

