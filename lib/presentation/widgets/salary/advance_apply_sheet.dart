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
      ignoreSafeArea: false,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(milliseconds: 280),
      exitBottomSheetDuration: const Duration(milliseconds: 200),
    );
  }
}

class _AdvanceApplyBody extends StatefulWidget {
  final SalaryController controller;

  const _AdvanceApplyBody({required this.controller});

  @override
  State<_AdvanceApplyBody> createState() => _AdvanceApplyBodyState();
}

class _AdvanceApplyBodyState extends State<_AdvanceApplyBody> {
  late final TextEditingController _amountController;
  late final TextEditingController _reasonController;
  late final FocusNode _amountFocus;
  late final FocusNode _reasonFocus;

  SalaryController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: controller.requestedAmount.value > 0
          ? controller.requestedAmount.value.toInt().toString()
          : '',
    );
    _reasonController = TextEditingController(text: controller.reason.value);
    _amountFocus = FocusNode();
    _reasonFocus = FocusNode();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    _amountFocus.dispose();
    _reasonFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height - keyboard - 12;
    final elig = controller.eligibility.value;
    final maxAmount = elig?.maxAllowedAmount ?? 600000;
    final maxMonths = controller.safeMaxRepaymentMonths;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight.clamp(280, double.infinity)),
        child: Material(
          color: context.khubrat.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
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
                  Obx(() {
                    final err = controller.advanceErrorMsg.value;
                    if (err == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
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
                                    err,
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
                    );
                  }),
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
                          child: Obx(
                            () => Text(
                              'salary_advance_limit_alert'.trParams({
                                'amount': SalaryUiHelpers.formatNumber(maxAmount),
                                'currency': controller.advanceCurrency,
                              }),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.brandBrown,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('salary_requested_amount'.tr, style: AppTextStyles.label.copyWith(color: context.khubrat.title)),
                  const SizedBox(height: 8),
                  Obx(
                    () => TextFormField(
                      controller: _amountController,
                      focusNode: _amountFocus,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: AppTextStyles.bodyLarge.copyWith(color: context.khubrat.textPrimary),
                      decoration: InputDecoration(
                        prefixText: '${controller.advanceCurrency}  ',
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.brandNavy, width: 1.4),
                        ),
                      ),
                      onChanged: (v) {
                        controller.requestedAmount.value = double.tryParse(v) ?? 0;
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('salary_repayment_months'.tr, style: AppTextStyles.label.copyWith(color: context.khubrat.title)),
                  const SizedBox(height: 8),
                  Obx(
                    () => DropdownButtonFormField<int>(
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
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.khubrat.inputFill,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.khubrat.chipBorder),
                      ),
                      child: Text(
                        'salary_monthly_installment_preview'.trParams({
                          'amount': SalaryUiHelpers.formatNumber(controller.calculatedInstallment),
                          'currency': controller.advanceCurrency,
                        }),
                        style: AppTextStyles.label.copyWith(color: context.khubrat.title),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('salary_advance_reason'.tr, style: AppTextStyles.label.copyWith(color: context.khubrat.title)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _reasonController,
                    focusNode: _reasonFocus,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.brandNavy, width: 1.4),
                      ),
                    ),
                    onChanged: (v) => controller.reason.value = v,
                  ),
                  const SizedBox(height: 18),
                  Obx(
                    () => SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: controller.isSubmittingAdvance.value
                            ? null
                            : () {
                                controller.requestedAmount.value =
                                    double.tryParse(_amountController.text.trim()) ?? 0;
                                controller.reason.value = _reasonController.text;
                                controller.submitAdvance();
                              },
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
