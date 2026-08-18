import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/khubrat_colors.dart';

/// حقل عرض فقط (بحال "الاسم الكامل" / "البريد الإلكتروني" / ...)
///
/// ⬅️ إصلاح: بدل الاعتماد على CrossAxisAlignment.end (يلي ثبت إنو مو
/// موثوق بمشروعك ومظل عم يحط الليبل يمين بكل الحالات)، صرت أفحص
/// اللغة الحالية مباشرة (نفس الأسلوب المستخدم بالـ AppBar وبقية
/// الملف) وأحدد مكان الليبل يدوياً: يمين بالعربي، يسار بالإنكليزي.
class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final TextAlign valueAlign;
  final TextDirection? valueDirection;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.valueAlign = TextAlign.start,
    this.valueDirection,
  });

  static const Color _goldDark = Color(0xFF835C21);

  bool get _isArabic => Get.locale?.languageCode == 'ar';

  @override
  Widget build(BuildContext context) {
    final palette = context.khubrat;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: _isArabic ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: _goldDark,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: palette.inputFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.chipBorder),
          ),
          child: Directionality(
            textDirection:
                valueDirection ??
                (_isArabic ? TextDirection.rtl : TextDirection.ltr),
            child: Text(
              value.isEmpty ? '—' : value,
              textAlign: valueAlign,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: palette.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
