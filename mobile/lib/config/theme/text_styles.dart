import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

/// App Text Styles (Alias and Extension for AppTypography)
/// This class provides a bridged access to typography according to legacy usage
/// while following the new design system.
class AppTextStyles {
  AppTextStyles._();

  // Headings
  static TextStyle get h1 => AppTypography.displayLarge;
  static TextStyle get h2 => AppTypography.displayMedium;
  static TextStyle get h3 => AppTypography.displaySmall;
  static TextStyle get h4 => AppTypography.headlineLarge;
  static TextStyle get h5 => AppTypography.headlineMedium;
  static TextStyle get h6 => AppTypography.headlineSmall;

  // Titles
  static TextStyle get titleLarge => AppTypography.titleLarge;
  static TextStyle get titleMedium => AppTypography.titleMedium;
  static TextStyle get titleSmall => AppTypography.titleSmall;

  // Body
  static TextStyle get bodyLarge => AppTypography.bodyLarge;
  static TextStyle get bodyMedium => AppTypography.bodyMedium;
  static TextStyle get bodySmall => AppTypography.bodySmall;

  // Others
  static TextStyle get labelLarge => AppTypography.labelLarge;
  static TextStyle get labelMedium => AppTypography.labelMedium;
  static TextStyle get labelSmall => AppTypography.labelSmall;
  static TextStyle get caption => AppTypography.caption;
  static TextStyle get overline => AppTypography.overline;
  static TextStyle get button => AppTypography.button;
}

