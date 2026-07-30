import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// All typography in the app uses Cairo font family with fine-tuned sizes and weights
/// for a clean, modern, and non-heavy UI.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    Color color = AppColors.textPrimary,
    double? height,
  }) {
    return GoogleFonts.cairo(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  // ── Headings (العناوين - تم تخفيف الوزن من w800/w700 إلى w600/w700) ──
  static TextStyle h1 = _base(size: 22, weight: FontWeight.w700);
  static TextStyle h2 = _base(size: 18, weight: FontWeight.w600);
  static TextStyle h3 = _base(size: 16, weight: FontWeight.w600);

  // ── Body (النصوص العادية وحقول الإدخال - ناعمة وخفيفة) ──
  static TextStyle bodyLarge = _base(size: 15, weight: FontWeight.w400);
  static TextStyle bodyMedium = _base(size: 13, weight: FontWeight.w400);
  static TextStyle bodySmall = _base(size: 11, weight: FontWeight.w400);

  // ── Labels & Titles (عناوين الحقول مثل "البريد الإلكتروني") ──
  static TextStyle label = _base(size: 13, weight: FontWeight.w600);

  // ── Buttons (الأزرار - وزنه متناسق وغير مبالغ فيه) ──
  static TextStyle button = _base(
    size: 15,
    weight: FontWeight.w600,
    color: Colors.white,
  );

  // ── Links & Hints ──
  static TextStyle hint = _base(size: 13, weight: FontWeight.w400, color: AppColors.hintText);
  static TextStyle link = _base(size: 12, weight: FontWeight.w600, color: AppColors.accent);
  static TextStyle error = _base(size: 11, weight: FontWeight.w500, color: AppColors.error);

  // ── Splash Screen ──
  static TextStyle splashTitle = _base(
    size: 26,
    weight: FontWeight.w700,
    color: AppColors.secondary,
  );

  static TextStyle splashSubtitle = _base(
    size: 13,
    weight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle splashTagline = _base(
    size: 12,
    weight: FontWeight.w400,
    color: Colors.white70,
    height: 1.5,
  );

  // ── Legacy Arabic Styles (للخلف) ──
  static TextStyle get arabicTitle => _base(
        size: 20,
        weight: FontWeight.w700,
        color: Colors.white,
        height: 1.3,
      );

  static TextStyle get arabicSubTitle => _base(
        size: 12,
        weight: FontWeight.w400,
        color: Colors.white.withOpacity(0.8),
        height: 1.5,
      );
}