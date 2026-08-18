import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/khubrat_colors.dart';
import '../../../data/models/salary_models.dart';
import 'salary_ui_helpers.dart';

class SalaryRecordCard extends StatelessWidget {
  final SalaryRecordModel record;
  final VoidCallback onDetails;
  final int index;

  const SalaryRecordCard({
    super.key,
    required this.record,
    required this.onDetails,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = SalaryUiHelpers.salaryStatusDot(record.status);
    final palette = context.khubrat;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + (index * 60).clamp(0, 240)),
      curve: Curves.easeOutCubic,
      builder: (_, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, 16 * (1 - t)), child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: palette.chipBorder),
          boxShadow: [
            BoxShadow(color: palette.cardShadow, blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.brandNavy.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.account_balance_wallet_rounded, color: palette.title),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SalaryUiHelpers.monthYearLabel(record.month, record.year),
                    style: AppTextStyles.h3.copyWith(color: palette.title),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          SalaryUiHelpers.paymentSummaryKey(record).tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    SalaryUiHelpers.formatMoney(
                      record.netSalary,
                      currency: record.currency,
                    ),
                    style: AppTextStyles.h3.copyWith(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: onDetails,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.brandNavy,
                backgroundColor: AppColors.brandNavy.withValues(alpha: 0.06),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('salary_details'.tr, style: AppTextStyles.label.copyWith(fontSize: 12)),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_left_rounded, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
