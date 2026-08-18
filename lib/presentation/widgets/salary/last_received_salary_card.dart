import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/salary_models.dart';
import 'salary_ui_helpers.dart';

class LastReceivedSalaryCard extends StatelessWidget {
  final LastReceivedSalaryModel data;
  final VoidCallback? onViewDetails;

  const LastReceivedSalaryCard({
    super.key,
    required this.data,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.brandNavy, Color(0xFF001752)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandNavy.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: -20,
              bottom: -24,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brandGold.withValues(alpha: 0.12),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.brandGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.brandGold.withValues(alpha: 0.35)),
                      ),
                      child: Text(
                        'salary_last_received_badge'.tr,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.brandGold,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded, color: Color(0xFF86EFAC), size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  SalaryUiHelpers.formatMoney(
                    data.amount,
                    currency: data.currency,
                  ),
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'salary_last_received_subtitle'.trParams({
                    'month': SalaryUiHelpers.monthName(data.month),
                    'year': '${data.year}',
                  }),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${'salary_received_at'.tr}: ${SalaryUiHelpers.formatDate(data.receivedAt)}',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                      ),
                    ),
                    if (onViewDetails != null && (data.salaryRecordId?.isNotEmpty ?? false))
                      TextButton(
                        onPressed: onViewDetails,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.brandGold,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'salary_view_notice'.tr,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.brandGold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
