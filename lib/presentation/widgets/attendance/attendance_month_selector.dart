import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/khubrat_colors.dart';
import '../../../core/theme/khubrat_colors.dart';
import 'attendance_ui_helpers.dart';

class AttendanceMonthSelector extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onMonthSelected;

  const AttendanceMonthSelector({
    super.key,
    required this.month,
    required this.onPrevious,
    required this.onNext,
    required this.onMonthSelected,
  });

  Future<void> _openMonthPicker(BuildContext context) async {
    final now = DateTime.now();
    // Temporary lower bound — no employee/system start date exists in the app.
    // Change DateTime(2023) here if you need a different earliest month.
    final firstDate = DateTime(2023);
    final lastDate = now;
    final initialDate = month.isAfter(lastDate) ? lastDate : (month.isBefore(firstDate) ? firstDate : month);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'attendance'.tr,
    );
    if (picked == null) return;
    onMonthSelected(DateTime(picked.year, picked.month));
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Get.locale?.languageCode == 'ar';
    final label = AttendanceUiHelpers.formatMonthLabel(
      AttendanceUiHelpers.monthQuery(month),
      isArabic: isArabic,
    );

    final palette = context.khubrat;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.chipBorder),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: Icon(Icons.chevron_left_rounded, color: palette.title),
            tooltip: 'attendance_previous_month'.tr,
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _openMonthPicker(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2.copyWith(color: palette.title),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: Icon(Icons.chevron_right_rounded, color: palette.title),
            tooltip: 'attendance_next_month'.tr,
          ),
        ],
      ),
    );
  }
}
