import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/overtime_controller.dart';
import '../widgets/overtime/overtime_hours_stepper.dart';
import '../widgets/overtime/overtime_preview_card.dart';
import '../widgets/overtime/overtime_history_card.dart';

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
        backgroundColor: const Color(0xFFF5F6FA),
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDateField(context),
                      const SizedBox(height: 18),
                      _buildDurationTypeToggle(),
                      const SizedBox(height: 18),
                      Obx(
                        () => controller.durationType.value == 'day'
                            ? _buildFullDayBox()
                            : _buildHourStepperSection(),
                      ),
                      const SizedBox(height: 16),
                      _buildPreviewCardsRow(),
                      const SizedBox(height: 18),
                      _buildReasonField(),
                      const SizedBox(height: 20),
                      _buildSubmitButton(),
                      const SizedBox(height: 28),
                      _buildHistorySection(),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر الرجوع — يظهر عاليمين بالعربي وعاليسار بالإنجليزي
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F2F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                // السهم بيشير لليمين بالعربي ولليسار بالإنجليزي
                _isArabic ? Icons.chevron_right : Icons.chevron_left,
                color: _navy,
              ),
            ),
          ),
          Text(
            'overtime_request_title'.tr,
            style: GoogleFonts.cairo(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'overtime_date_label'.tr,
          style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E4EC)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // النص أولاً → يظهر عاليمين بالعربي وعاليسار بالإنجليزي
                  Text(
                    date == null ? 'select_date'.tr : controller.formattedDate,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: date == null
                          ? Colors.grey.shade400
                          : Colors.black87,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDurationTypeToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'overtime_duration_type_label'.tr,
          style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700),
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

  Widget _buildFullDayBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'overtime_hours_required_label'.tr,
          style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF6EC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9DCB8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // النص أولاً → عاليمين بالعربي، عاليسار بالإنجليزي
              Flexible(
                child: Text(
                  'overtime_full_day_info'.tr,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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

  Widget _buildHourStepperSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'overtime_hours_required_label'.tr,
          style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700),
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

  Widget _buildReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'overtime_reason_label'.tr,
          style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E4EC)),
          ),
          child: TextField(
            controller: controller.reasonController,
            maxLines: 4,
            textAlign: TextAlign.start,
            style: GoogleFonts.cairo(fontSize: 12),
            decoration: InputDecoration(
              hintText: 'overtime_reason_hint'.tr,
              hintStyle: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
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

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // العنوان أولاً → عاليمين بالعربي، عاليسار بالإنجليزي
            Text(
              'overtime_history_title'.tr,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F2F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'sorted_descending'.tr,
                style: GoogleFonts.cairo(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
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
                  style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
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
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF0F1B4C) : const Color(0xFFE2E4EC),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected ? const Color(0xFF0F1B4C) : Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected
                    ? const Color(0xFF0F1B4C)
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
