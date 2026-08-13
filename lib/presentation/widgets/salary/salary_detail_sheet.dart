import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/salary_models.dart';
import '../../controllers/salary_controller.dart';
import 'salary_ui_helpers.dart';

class SalaryDetailSheet {
  SalaryDetailSheet._();

  static void show({required SalaryController controller}) {
    Get.bottomSheet(
      _SalaryDetailBody(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(milliseconds: 320),
      exitBottomSheetDuration: const Duration(milliseconds: 220),
    );
  }
}

class _SalaryDetailBody extends StatelessWidget {
  final SalaryController controller;

  const _SalaryDetailBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.9;

    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isLoadingDetail.value || controller.currentDetail.value == null) {
            return const SizedBox(
              height: 280,
              child: Center(child: CircularProgressIndicator(color: AppColors.brandNavy)),
            );
          }
          final d = controller.currentDetail.value!;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'salary_detail_title'.tr,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h2.copyWith(color: AppColors.brandNavy),
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.brandNavy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.description_rounded, color: Colors.white, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _MetaCard(detail: d),
                const SizedBox(height: 14),
                _LinesSection(
                  title: 'salary_earnings'.tr,
                  emptyText: 'salary_no_additions'.tr,
                  items: d.additions.where((e) => e.amount > 0).toList(),
                  positive: true,
                  totalLabel: 'salary_total_earnings'.tr,
                  total: d.baseSalary + d.totalAdditions,
                  baseLabel: 'salary_basic'.tr,
                  baseAmount: d.baseSalary,
                ),
                const SizedBox(height: 12),
                _LinesSection(
                  title: 'salary_deductions'.tr,
                  emptyText: 'salary_no_deductions'.tr,
                  items: d.deductions.where((e) => e.amount > 0).toList(),
                  positive: false,
                  totalLabel: 'salary_total_deductions'.tr,
                  total: d.totalDeductions,
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.brandNavy,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'salary_net_payable'.tr,
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        SalaryUiHelpers.formatMoney(d.netSalary),
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.brandGold,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'salary_transferred_bank'.tr,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.brandGold.withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _MetaCard extends StatelessWidget {
  final SalaryDetailModel detail;
  const _MetaCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('salary_currency'.tr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text('salary_currency_syp'.tr, style: AppTextStyles.label.copyWith(color: AppColors.brandNavy)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('salary_period_label'.tr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(
                  SalaryUiHelpers.monthYearLabel(detail.month, detail.year),
                  style: AppTextStyles.label.copyWith(color: AppColors.brandNavy),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinesSection extends StatelessWidget {
  final String title;
  final String emptyText;
  final List<SalaryLineItemModel> items;
  final bool positive;
  final String totalLabel;
  final double total;
  final String? baseLabel;
  final double? baseAmount;

  const _LinesSection({
    required this.title,
    required this.emptyText,
    required this.items,
    required this.positive,
    required this.totalLabel,
    required this.total,
    this.baseLabel,
    this.baseAmount,
  });

  @override
  Widget build(BuildContext context) {
    final bg = positive ? const Color(0xFFF0FDF4) : const Color(0xFFFFF1F2);
    final border = positive ? const Color(0xFFBBF7D0) : const Color(0xFFFECDD3);
    final accent = positive ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.label.copyWith(color: AppColors.brandNavy)),
            ],
          ),
          const SizedBox(height: 12),
          if (baseLabel != null && baseAmount != null)
            _LineRow(label: baseLabel!, amount: baseAmount!, signed: false, positive: true),
          if (items.isEmpty && baseLabel == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(emptyText, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            )
          else if (items.isEmpty && baseLabel != null)
            const SizedBox.shrink()
          else
            ...items.map(
              (e) => _LineRow(
                label: SalaryUiHelpers.lineItemLabel(e.type, e.label),
                amount: e.amount,
                signed: true,
                positive: positive,
              ),
            ),
          if (items.isEmpty && baseLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                emptyText,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ),
          const Divider(height: 20),
          Row(
            children: [
              Expanded(child: Text(totalLabel, style: AppTextStyles.label.copyWith(color: AppColors.brandNavy))),
              Text(
                SalaryUiHelpers.formatMoney(total),
                style: AppTextStyles.label.copyWith(color: AppColors.brandNavy, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool signed;
  final bool positive;

  const _LineRow({
    required this.label,
    required this.amount,
    required this.signed,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final prefix = !signed ? '' : (positive ? '+ ' : '- ');
    final color = !signed
        ? AppColors.textPrimary
        : (positive ? AppColors.success : AppColors.error);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            positive ? Icons.card_giftcard_rounded : Icons.shield_outlined,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
          ),
          Text(
            '$prefix${SalaryUiHelpers.formatMoney(amount)}',
            style: AppTextStyles.label.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
