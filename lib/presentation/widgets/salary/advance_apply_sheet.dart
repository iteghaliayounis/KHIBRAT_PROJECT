import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/khubrat_colors.dart';
import '../../controllers/salary_controller.dart';
import 'salary_ui_helpers.dart';

class AdvanceApplySheet {
  AdvanceApplySheet._();

  static void show({required SalaryController controller}) {
    Get.bottomSheet(
      _AdvanceApplyBody(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(milliseconds: 320),
      exitBottomSheetDuration: const Duration(milliseconds: 220),
    );
  }
}

class _AdvanceApplyBody extends StatelessWidget {
  final SalaryController controller;

  const _AdvanceApplyBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    final elig = controller.eligibility.value;
    final maxAmount = elig?.maxAllowedAmount ?? 600000;
    final maxMonths = controller.safeMaxRepaymentMonths;

    // ✅ Root-cause fix: back to Flutter's canonical minimal pattern for a
    // scrollable, keyboard-safe modal bottom sheet — no fixed SizedBox
    // height, no nested Scaffold (those two were fighting each other and
    // leaving a dead gap). Just:
    //   1) one Padding(bottom: viewInsets.bottom) so the whole sheet slides
    //      up exactly as much as the keyboard needs, no more/no less;
    //   2) the content sizes itself (mainAxisSize.min) instead of being
    //      forced into a fixed height — so there's never leftover blank
    //      space, and SingleChildScrollView only scrolls if content is
    //      genuinely taller than the visible area above the keyboard.
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: context.khubrat.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: context.khubrat.chipBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: context.khubrat.inputFill,
                              shape: BoxShape.circle,
                              border: Border.all(color: context.khubrat.chipBorder),
                            ),
                            child: Icon(Icons.close_rounded, size: 18, color: context.khubrat.title),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.edit_note_rounded, color: context.khubrat.title, size: 22),
                        const SizedBox(width: 6),
                        Text(
                          'salary_apply_title'.tr,
                          style: AppTextStyles.h3.copyWith(color: context.khubrat.title),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (controller.advanceErrorMsg.value != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFECDD3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Color(0xFFBE123C), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'salary_advance_422_title'.tr,
                                    style: AppTextStyles.label.copyWith(color: const Color(0xFF9F1239)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    controller.advanceErrorMsg.value!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: const Color(0xFF9F1239),
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.brandGold),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded, color: AppColors.brandBrown, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'salary_advance_limit_alert'.trParams({
                                'amount': SalaryUiHelpers.formatNumber(maxAmount),
                              }),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.brandBrown,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('salary_requested_amount'.tr, style: AppTextStyles.label.copyWith(color: context.khubrat.title)),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: controller.requestedAmount.value > 0
                          ? controller.requestedAmount.value.toInt().toString()
                          : '',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: AppTextStyles.bodyLarge.copyWith(color: context.khubrat.textPrimary),
                      decoration: InputDecoration(
                        prefixText: 'SYP  ',
                        prefixStyle: AppTextStyles.label.copyWith(color: context.khubrat.textSecondary),
                        filled: true,
                        fillColor: context.khubrat.inputFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      onChanged: (v) {
                        controller.requestedAmount.value = double.tryParse(v) ?? 0;
                      },
                    ),
                    const SizedBox(height: 14),
                    Text('salary_repayment_months'.tr, style: AppTextStyles.label.copyWith(color: context.khubrat.title)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: controller.repaymentMonths.value.clamp(1, maxMonths).toInt(),
                      dropdownColor: context.khubrat.surface,
                      style: AppTextStyles.bodyLarge.copyWith(color: context.khubrat.textPrimary),
                      items: List.generate(
                        maxMonths,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text(
                            '${i + 1} ${'salary_months_short'.tr}',
                            style: AppTextStyles.bodyLarge.copyWith(color: context.khubrat.textPrimary),
                          ),
                        ),
                      ),
                      onChanged: (v) {
                        if (v != null) controller.repaymentMonths.value = v;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.khubrat.inputFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: context.khubrat.inputBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: context.khubrat.inputBorder),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.khubrat.inputFill,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.khubrat.chipBorder),
                      ),
                      child: Text(
                        'salary_monthly_installment_preview'.trParams({
                          'amount': SalaryUiHelpers.formatNumber(controller.calculatedInstallment),
                        }),
                        style: AppTextStyles.label.copyWith(color: context.khubrat.title),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('salary_advance_reason'.tr, style: AppTextStyles.label.copyWith(color: context.khubrat.title)),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: controller.reason.value,
                      maxLines: 3,
                      style: AppTextStyles.bodyLarge.copyWith(color: context.khubrat.textPrimary),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.khubrat.inputFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: context.khubrat.inputBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: context.khubrat.inputBorder),
                        ),
                      ),
                      onChanged: (v) => controller.reason.value = v,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: controller.isSubmittingAdvance.value ? null : controller.submitAdvance,
                        icon: controller.isSubmittingAdvance.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                        label: Text(
                          'salary_submit_advance'.tr,
                          style: AppTextStyles.button.copyWith(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandNavy,
                          disabledBackgroundColor: AppColors.brandNavy.withValues(alpha: 0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}