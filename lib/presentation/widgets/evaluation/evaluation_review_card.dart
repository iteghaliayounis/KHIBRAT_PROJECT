import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/evaluation_models.dart';
import 'evaluation_ui_helpers.dart';

class EvaluationReviewCard extends StatelessWidget {
  final EvaluationReviewModel review;
  final VoidCallback onTap;

  const EvaluationReviewCard({super.key, required this.review, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final iconInfo = EvaluationUiHelpers.iconFor(review.reviewType);
    final title = EvaluationUiHelpers.titleFor(review.reviewType, fallback: 'evaluation_default_title'.tr);

    // "For: <employee>" for self-reviews, "You're evaluating <employee>" for
    // peer/manager reviews — purely a phrasing choice, the name itself is
    // always the backend-provided employee.displayName.
    final isSelf = (review.reviewType ?? '').toLowerCase().contains('self');
    final personLabel = isSelf ? 'for_label'.tr : 'evaluating_label'.tr;
    final personName = review.employee?.displayName;
    final hasPersonName = personName != null && personName.isNotEmpty;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEDEDED)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconInfo.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(iconInfo.icon, color: iconInfo.color == iconInfo.background ? Colors.white : iconInfo.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
                    const SizedBox(height: 2),
                    if (hasPersonName)
                      Text('$personLabel $personName', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 10),
                    if (review.isPending) _PendingFooter(review: review) else _CompletedFooter(review: review),
                  ],
                ),
              ),
              if (review.isPending) ...[
                const SizedBox(width: 8),
                _StartButton(onTap: onTap),
              ] else
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.chevron_right_rounded, color: Color(0xFFBDBDBD)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingFooter extends StatelessWidget {
  final EvaluationReviewModel review;
  const _PendingFooter({required this.review});

  @override
  Widget build(BuildContext context) {
    final overdue = review.isOverdue;
    final dueLabel = EvaluationUiHelpers.formatDate(review.dueDate);
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: overdue ? AppColors.error : const Color(0xFFFFA726),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          overdue ? 'overdue'.tr : 'pending'.tr,
          style: AppTextStyles.bodySmall.copyWith(
            color: overdue ? AppColors.error : const Color(0xFFFFA726),
            fontWeight: FontWeight.w600,
          ),
        ),
        if (dueLabel.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text('${'due'.tr} $dueLabel', style: AppTextStyles.bodySmall),
        ],
      ],
    );
  }
}

class _CompletedFooter extends StatelessWidget {
  final EvaluationReviewModel review;
  const _CompletedFooter({required this.review});

  @override
  Widget build(BuildContext context) {
    final completedLabel = EvaluationUiHelpers.formatDate(review.completedAt);
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('completed'.tr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
        if (completedLabel.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text('${'completed_on'.tr} $completedLabel', style: AppTextStyles.bodySmall),
        ],
      ],
    );
  }
}

class _StartButton extends StatelessWidget {
  final VoidCallback onTap;
  const _StartButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('start'.tr, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
