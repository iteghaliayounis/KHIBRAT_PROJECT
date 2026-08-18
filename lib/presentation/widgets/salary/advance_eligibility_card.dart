import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/khubrat_colors.dart';
import '../../../data/models/salary_models.dart';
import 'salary_ui_helpers.dart';

class AdvanceEligibilityCard extends StatelessWidget {
  final AdvanceEligibilityModel data;
  final VoidCallback onRequest;

  const AdvanceEligibilityCard({
    super.key,
    required this.data,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final blockedByActiveAdvance =
        data.hasActiveAdvance && !data.allowMultipleActiveAdvances;
    final palette = context.khubrat;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: palette.chipBorder),
            boxShadow: [
              BoxShadow(color: palette.cardShadow, blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: AppColors.brandGold, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'salary_advance_eligibility'.tr,
                      style: AppTextStyles.h3.copyWith(color: palette.title),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: blockedByActiveAdvance
                          ? const Color(0xFFFEF3C7)
                          : const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      blockedByActiveAdvance
                          ? 'salary_active_advance'.tr
                          : 'salary_eligible'.tr,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: blockedByActiveAdvance
                            ? const Color(0xFF78350F)
                            : const Color(0xFF065F46),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'salary_basic'.tr,
                      value: SalaryUiHelpers.formatMoney(
                        data.basicSalary,
                        currency: data.currency,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MiniStat(
                      label: 'salary_max_allowed'.tr,
                      value: SalaryUiHelpers.formatMoney(
                        data.maxAllowedAmount,
                        currency: data.currency,
                      ),
                      highlight: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MiniStat(
                      label: 'salary_max_months'.tr,
                      value: '${data.maxRepaymentMonths} ${'salary_months_short'.tr}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (blockedByActiveAdvance) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: palette.isDark
                  ? const Color(0xFF3A2A12)
                  : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: palette.isDark ? AppColors.brandGold : const Color(0xFF92400E),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'salary_active_advance_hint'.tr,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: palette.isDark ? AppColors.brandGold : const Color(0xFF92400E),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: onRequest,
            icon: const Icon(Icons.volunteer_activism_rounded, color: AppColors.brandGold),
            label: Text(
              'salary_request_advance'.tr,
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandNavy,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _MiniStat({required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    final palette = context.khubrat;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.brandGold.withValues(alpha: palette.isDark ? 0.22 : 0.2)
            : palette.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.chipBorder),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(color: palette.textSecondary, fontSize: 10),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label.copyWith(
              color: highlight ? AppColors.brandGold : palette.title,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
