import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Surface / text colors that switch with light|dark theme.
/// Brand navy / gold / bronze stay on [AppColors] and must not be used here.
class KhubratColors extends ThemeExtension<KhubratColors> {
  const KhubratColors({
    required this.pageBackground,
    required this.backgroundGlow,
    required this.backgroundDeep,
    required this.surface,
    required this.title,
    required this.textPrimary,
    required this.textSecondary,
    required this.hint,
    required this.inputFill,
    required this.inputBorder,
    required this.cardShadow,
    required this.navBar,
    required this.chipBorder,
  });

  final Color pageBackground;
  final Color backgroundGlow;
  final Color backgroundDeep;
  final Color surface;
  final Color title;
  final Color textPrimary;
  final Color textSecondary;
  final Color hint;
  final Color inputFill;
  final Color inputBorder;
  final Color cardShadow;
  final Color navBar;
  final Color chipBorder;

  static const light = KhubratColors(
    pageBackground: Color(0xFFF4F7FB),
    backgroundGlow: Color(0xFFF4F7FB),
    backgroundDeep: Color(0xFFF4F7FB),
    surface: Color(0xFFFFFFFF),
    title: AppColors.primary,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    hint: AppColors.hintText,
    inputFill: AppColors.inputFill,
    inputBorder: Color(0xFFE6EAF0),
    cardShadow: AppColors.cardShadow,
    navBar: Color(0xFFFFFFFF),
    chipBorder: Color(0xFFE6EAF0),
  );

  static const dark = KhubratColors(
    pageBackground: AppColors.nightDeep,
    backgroundGlow: AppColors.nightGlow,
    backgroundDeep: AppColors.nightDeep,
    surface: AppColors.nightSurface,
    title: Color(0xFFF4F7FB),
    textPrimary: Color(0xFFF4F7FB),
    textSecondary: Color(0xFFB8C2D6),
    hint: Color(0xFF8A93A8),
    inputFill: Color(0x14FFFFFF),
    inputBorder: Color(0x22FFFFFF),
    cardShadow: Color(0x73000000),
    navBar: AppColors.nightSurface,
    chipBorder: Color(0x33FFFFFF),
  );

  static KhubratColors of(BuildContext context) {
    return Theme.of(context).extension<KhubratColors>() ?? KhubratColors.light;
  }

  bool get isDark => pageBackground == AppColors.nightDeep;

  @override
  KhubratColors copyWith({
    Color? pageBackground,
    Color? backgroundGlow,
    Color? backgroundDeep,
    Color? surface,
    Color? title,
    Color? textPrimary,
    Color? textSecondary,
    Color? hint,
    Color? inputFill,
    Color? inputBorder,
    Color? cardShadow,
    Color? navBar,
    Color? chipBorder,
  }) {
    return KhubratColors(
      pageBackground: pageBackground ?? this.pageBackground,
      backgroundGlow: backgroundGlow ?? this.backgroundGlow,
      backgroundDeep: backgroundDeep ?? this.backgroundDeep,
      surface: surface ?? this.surface,
      title: title ?? this.title,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      hint: hint ?? this.hint,
      inputFill: inputFill ?? this.inputFill,
      inputBorder: inputBorder ?? this.inputBorder,
      cardShadow: cardShadow ?? this.cardShadow,
      navBar: navBar ?? this.navBar,
      chipBorder: chipBorder ?? this.chipBorder,
    );
  }

  @override
  KhubratColors lerp(ThemeExtension<KhubratColors>? other, double t) {
    if (other is! KhubratColors) return this;
    return KhubratColors(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      backgroundGlow: Color.lerp(backgroundGlow, other.backgroundGlow, t)!,
      backgroundDeep: Color.lerp(backgroundDeep, other.backgroundDeep, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      title: Color.lerp(title, other.title, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
      chipBorder: Color.lerp(chipBorder, other.chipBorder, t)!,
    );
  }
}

extension KhubratThemeX on BuildContext {
  KhubratColors get khubrat => KhubratColors.of(this);
}
