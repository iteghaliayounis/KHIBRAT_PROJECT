import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/khubrat_colors.dart';

/// حقل قابل للتعديل (رقم الهاتف / العنوان) — زر تعديل بجانبو كيفتح
/// ورقة سفلية (Bottom Sheet) فيها input.
///
/// ⬅️ إصلاح #1: الاتجاه العام للحقل (label + قيمة) بيتبع اللغة تلقائياً
/// (start/end)، وقيمة الحقل نفسها بتاخد اتجاه مستقل (valueDirection)
/// لحالات زي رقم الهاتف يلي لازم يضل LTR دايماً بغض النظر عن اللغة —
/// بدون ما يأثر عالصف يلي فيه زر التعديل والليبل.
///
/// ⬅️ إصلاح #4: صف (زر التعديل + الليبل) مقصود يكون بعكس اتجاه باقي
/// الحقول: عربي → الأيقونة عليسار، إنكليزي → الأيقونة عليمين. هيك
/// طلب المستخدم صراحة، وبينطبق بنفس الشكل عالهاتف والعنوان مادام
/// الاتنين عم يستخدموا نفس الـ widget.
class ProfileEditableTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isSaving;
  final TextAlign valueAlign;
  final TextDirection? valueDirection;
  final Future<bool> Function(String newValue) onSave;

  const ProfileEditableTile({
    super.key,
    required this.label,
    required this.value,
    required this.isSaving,
    required this.onSave,
    this.valueAlign = TextAlign.start,
    this.valueDirection,
  });

  static const Color _navy = Color(0xFF002173);
  static const Color _goldDark = Color(0xFF835C21);

  bool get _isArabic => Get.locale?.languageCode == 'ar';

  void _openEditSheet(BuildContext context) {
    final palette = context.khubrat;
    final textController = TextEditingController(text: value);
    Get.bottomSheet(
      Directionality(
        textDirection: Directionality.of(context),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: palette.chipBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'profile_edit_field_title'.trParams({'field': label}),
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: palette.title,
                ),
              ),
              const SizedBox(height: 16),
              Directionality(
                textDirection: valueDirection ?? Directionality.of(context),
                child: TextField(
                  controller: textController,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: palette.textPrimary,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: palette.inputFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: palette.inputBorder),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        backgroundColor: palette.inputFill,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'profile_cancel'.tr,
                        style: GoogleFonts.cairo(
                          color: palette.textSecondary,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final newValue = textController.text.trim();
                        if (newValue.isEmpty) {
                          Get.snackbar(
                            'error'.tr,
                            'profile_empty_field_error'.tr,
                          );
                          return;
                        }
                        // ⬅️ إصلاح #3: نسكر الورقة فوراً بمجرد التحقق من
                        // القيمة، وما بننتظر رد السيرفر — هيك الورقة
                        // دايماً بتسكر لما تضغط "حفظ التغييرات"، وبعدين
                        // تابع PUT بيشتغل بالخلفية وبيعرض نتيجتو (نجاح/
                        // خطأ) عبر Snackbar من جوا الكونترولر.
                        Get.back();
                        onSave(newValue);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _navy,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'profile_save_edit'.tr,
                        style: GoogleFonts.cairo(
                          color: const Color(0xFFFCD88A),
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.khubrat;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          textDirection: _isArabic ? TextDirection.ltr : TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _openEditSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: palette.isDark
                      ? const Color(0xFF0F1B4C).withValues(alpha: 0.45)
                      : const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, size: 11, color: palette.title),
                    const SizedBox(width: 3),
                    Text(
                      'profile_edit'.tr,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: palette.title,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _goldDark,
              ),
            ),
          ],
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
            textDirection: valueDirection ?? Directionality.of(context),
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
