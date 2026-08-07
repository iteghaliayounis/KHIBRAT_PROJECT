import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/salary_models.dart';
import 'salary_ui_helpers.dart';

class AdvanceRecordCard extends StatelessWidget {
  final AdvanceRecordModel record;
  final int index;

  const AdvanceRecordCard({super.key, required this.record, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final bg = SalaryUiHelpers.advanceStatusBg(record.status);
    final fg = SalaryUiHelpers.advanceStatusFg(record.status);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 200)),
      curve: Curves.easeOutCubic,
      builder: (_, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, 12 * (1 - t)), child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8EDF5)),
          boxShadow: const [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.brandGold.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.payments_rounded, color: AppColors.brandBrown),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'salary_advance_amount_of'.trParams({
                      'amount': SalaryUiHelpers.formatMoney(record.requestedAmount),
                    }),
                    style: AppTextStyles.h3.copyWith(color: AppColors.brandNavy),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${record.repaymentMonths} ${'salary_months_short'.tr} | ${'salary_installment'.tr}: ${SalaryUiHelpers.formatMoney(record.monthlyInstallment)}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${'salary_date'.tr}: ${SalaryUiHelpers.formatDate(record.createdAt)}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.hintText),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                SalaryUiHelpers.advanceStatusLabelKey(record.status).tr,
                style: AppTextStyles.bodySmall.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
