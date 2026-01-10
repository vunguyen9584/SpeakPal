/// App Spacing System
/// Based on Design System from DD: 09-ui-specifications.md
/// Using 4px base unit
class AppSpacing {
  // Private constructor to prevent instantiation
  AppSpacing._();

  // Base unit: 4px
  static const double baseUnit = 4.0;

  // Spacing scale (multiples of base unit)
  static const double xs = baseUnit; // 4px
  static const double sm = baseUnit * 2; // 8px
  static const double md = baseUnit * 3; // 12px
  static const double lg = baseUnit * 4; // 16px
  static const double xl = baseUnit * 5; // 20px
  static const double xxl = baseUnit * 6; // 24px
  static const double xxxl = baseUnit * 8; // 32px

  // Common spacing values
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Layout spacing
  static const double screenPadding = spacing16;
  static const double screenPaddingHorizontal = spacing20;
  static const double sectionSpacing = spacing24;
  static const double cardSpacing = spacing16;
  static const double listItemSpacing = spacing12;
  static const double iconTextSpacing = spacing8;

  // Component spacing
  static const double buttonPaddingVertical = spacing12;
  static const double buttonPaddingHorizontal = spacing24;
  static const double inputPaddingVertical = spacing12;
  static const double inputPaddingHorizontal = spacing16;
  static const double chipPaddingVertical = spacing8;
  static const double chipPaddingHorizontal = spacing12;
}

