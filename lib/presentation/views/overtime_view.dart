import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/overtime_controller.dart';
import '../widgets/overtime/overtime_hours_stepper.dart';
import '../widgets/overtime/overtime_preview_card.dart';
import '../widgets/overtime/overtime_history_card.dart';
import '../../core/theme/khubrat_colors.dart';

/// واجهة طلب العمل الإضافي
/// كل النصوص تستخدم مفاتيح الترجمة 'key'.tr لتدعم العربية والإنجليزية
/// الاتجاه (RTL/LTR) يتبع لغة التطبيق تلقائياً عبر Directionality
/// ملاحظة: تم توحيد الخط (Cairo) وأحجامه مع باقي واجهات التطبيق
/// (مثل واجهة الإجازات LeaveDashboardView) بناءً على طلب التعديل.
class OvertimeView extends GetView<OvertimeController> {
  const OvertimeView({super.key});

  static const Color _navy = Color(0xFF0F1B4C);
  static const Color _goldStart = Color(0xFFFCD88A);
  static const Color _goldEnd = Color(0xFF835C21);

  /// هل اللغة الحالية عربية؟ يحدد اتجاه النص (RTL = يمين، LTR = يسار)
  bool get _isArabic => Get.locale?.languageCode == 'ar';

  @override
  Widget build(BuildContext context) {
    // نلف الـ Scaffold كامل بـ Directionality عشان كل العناصر تتبع اللغة
    // عربي → RTL (يمين) / إنجليزي → LTR (يسار)
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDateField(context),
                      const SizedBox(height: 18),
                      _buildDurationTypeToggle(context),
                      const SizedBox(height: 18),
                      Obx(
                        () => controller.durationType.value == 'day'
                            ? _buildFullDayBox(context)
                            : _buildHourStepperSection(context),
                      ),
                      const SizedBox(height: 16),
                      _buildPreviewCardsRow(),
                      const SizedBox(height: 18),
                      _buildReasonField(context),
                      const SizedBox(height: 20),
                      _buildSubmitButton(),
                      const SizedBox(height: 28),
                      _buildHistorySection(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final palette = context.khubrat;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: palette.inputFill,
                shape: BoxShape.circle,
                border: Border.all(color: palette.chipBorder),
              ),
              child: Icon(
                _isArabic ? Icons.chevron_right : Icons.chevron_left,
                color: palette.title,
              ),
            ),
          ),
          Text(
            'overtime_request_title'.tr,
            style: GoogleFonts.cairo(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: palette.title,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    final palette = context.khubrat;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'overtime_date_label'.tr,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Obx(() {
          final date = controller.selectedDate.value;
          return InkWell(
            onTap: () => controller.pickDate(context),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: palette.inputFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.inputBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date == null ? 'select_date'.tr : controller.formattedDate,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: date == null ? palette.hint : palette.textPrimary,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: palette.textSecondary,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDurationTypeToggle(BuildContext context) {
    final palette = context.khubrat;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'overtime_duration_type_label'.tr,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final type = controller.durationType.value;
          return Row(
            children: [
              Expanded(
                child: _ToggleButton(
                  label: 'overtime_hours'.tr,
                  icon: Icons.access_time,
                  selected: type == 'hour',
                  onTap: () => controller.selectDurationType('hour'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ToggleButton(
                  label: 'overtime_full_day'.tr,
                  icon: Icons.event_available,
                  selected: type == 'day',
                  onTap: () => controller.selectDurationType('day'),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildFullDayBox(BuildContext context) {
    final palette = context.khubrat;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'overtime_hours_required_label'.tr,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            color: palette.inputFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.inputBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'overtime_full_day_info'.tr,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFF835C21),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHourStepperSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'overtime_hours_required_label'.tr,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: context.khubrat.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => OvertimeHoursStepper(
            value: controller.hoursCount.value,
            onIncrement: controller.incrementHours,
            onDecrement: controller.decrementHours,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewCardsRow() {
    return Obx(() {
      final hourPreview = controller.hourPreview.value;

      return Row(
        children: [
          // كرت المكافأة على الساعة أولاً → يظهر عاليمين (مقابل زر "ساعات")
          Expanded(
            child: OvertimePreviewCard(
              title: 'overtime_hour_rate_label'.tr,
              preview: hourPreview,
              isLoading: controller.isLoadingHourPreview.value,
              amountColor: const Color(0xFF16A34A),
              selected: controller.durationType.value == 'hour',
              onTap: () => controller.selectDurationType('hour'),
            ),
          ),
          const SizedBox(width: 10),
          // كرت المكافأة على اليوم ثانياً → يظهر عاليسار (مقابل زر "يوم كامل")
          Expanded(
            child: OvertimePreviewCard(
              title: 'overtime_day_rate_label'.tr,
              preview: controller.dayPreview.value,
              isLoading: controller.isLoadingDayPreview.value,
              selected: controller.durationType.value == 'day',
              onTap: () => controller.selectDurationType('day'),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildReasonField(BuildContext context) {
    final palette = context.khubrat;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'overtime_reason_label'.tr,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: palette.inputFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.inputBorder),
          ),
          child: TextField(
            controller: controller.reasonController,
            maxLines: 4,
            textAlign: TextAlign.start,
            style: GoogleFonts.cairo(fontSize: 12, color: palette.textPrimary),
            decoration: InputDecoration(
              hintText: 'overtime_reason_hint'.tr,
              hintStyle: GoogleFonts.cairo(fontSize: 11, color: palette.hint),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final loading = controller.isSubmitting.value;
      return InkWell(
        onTap: loading ? null : controller.submitRequest,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_goldStart, _goldEnd]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _navy,
                  ),
                )
              : Text(
                  'overtime_submit_button'.tr,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildHistorySection(BuildContext context) {
    final palette = context.khubrat;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'overtime_history_title'.tr,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: palette.title,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: palette.inputFill,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: palette.chipBorder),
              ),
              child: Text(
                'sorted_descending'.tr,
                style: GoogleFonts.cairo(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: palette.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.isLoadingHistory.value) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (controller.historyList.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'overtime_no_history'.tr,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: palette.textSecondary,
                  ),
                ),
              ),
            );
          }
          return Column(
            children: controller.historyList
                .map((item) => OvertimeHistoryCard(item: item))
                .toList(),
          );
        }),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.khubrat;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: palette.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF0F1B4C) : palette.chipBorder,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected ? palette.title : palette.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? palette.title : palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
