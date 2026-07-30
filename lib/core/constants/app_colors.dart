import 'package:flutter/material.dart';

/// Centralized brand color palette for the Khubrat app.
/// These values come directly from the brand guideline provided
/// (RGB 252-216-138 / 131-92-33 / 0-33-115) and must not be altered
/// without explicit design approval.
class AppColors {
  AppColors._();

  /// Primary Navy Blue - RGB(0, 33, 115)
  static const Color primary = Color.fromRGBO(0, 33, 115, 1);

  /// Secondary Gold / Cream - RGB(252, 216, 138)
  static const Color secondary = Color.fromRGBO(252, 216, 138, 1);

  /// Accent Bronze / Brown - RGB(131, 92, 33)
  static const Color accent = Color.fromRGBO(131, 92, 33, 1);

  // Derived / supporting shades used across the UI
  static const Color background = Color(0xFFFFFFFF);
  static const Color splashBackground = primary;

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color hintText = Color(0xFFB4B4B4);

  static const Color inputBorder = Color(0xFFE8D9B5);
  static const Color inputFill = Color(0xFFFFFFFF);

  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);

  static const Color cardShadow = Color(0x1A000000);

  // Gradient used for primary buttons (gold gradient as seen in language screen)
  static const List<Color> goldGradient = [
    Color(0xFFF5C453),
    accent,
  ];

  static const List<Color> navyGradient = [
    Color(0xFF041B5C),
    primary,
  ];
}
