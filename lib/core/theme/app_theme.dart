import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'khubrat_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
        brightness: Brightness.light,
        palette: KhubratColors.light,
        overlay: SystemUiOverlayStyle.dark,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        palette: KhubratColors.dark,
        overlay: SystemUiOverlayStyle.light,
      );

  static ThemeData _build({
    required Brightness brightness,
    required KhubratColors palette,
    required SystemUiOverlayStyle overlay,
  }) {
    final isDark = brightness == Brightness.dark;
    final base = isDark ? ThemeData.dark() : ThemeData.light();
    final textTheme = GoogleFonts.cairoTextTheme(base.textTheme).apply(
      bodyColor: palette.textPrimary,
      displayColor: palette.title,
    );

    return base.copyWith(
      brightness: brightness,
      scaffoldBackgroundColor:
          isDark ? Colors.transparent : palette.pageBackground,
      primaryColor: AppColors.primary,
      canvasColor: palette.surface,
      cardColor: palette.surface,
      dividerColor: palette.chipBorder,
      colorScheme: base.colorScheme.copyWith(
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: palette.surface,
        onSurface: palette.textPrimary,
        onPrimary: Colors.white,
      ),
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[palette],
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.cairo(color: palette.textPrimary, fontSize: 13.5),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(palette.surface),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: palette.surface,
        headerBackgroundColor: AppColors.primary,
        headerForegroundColor: Colors.white,
        dayForegroundColor: WidgetStatePropertyAll(palette.textPrimary),
        yearForegroundColor: WidgetStatePropertyAll(palette.textPrimary),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: palette.surface,
        hourMinuteTextColor: palette.textPrimary,
        dialTextColor: palette.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: overlay,
        iconTheme: IconThemeData(color: palette.title),
        titleTextStyle: GoogleFonts.cairo(
          color: palette.title,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return isDark ? const Color(0xFF3A4660) : const Color(0xFFE6E8EE);
        }),
      ),
      splashFactory: InkRipple.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
