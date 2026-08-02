import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SubmitConfirmationSheet extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const SubmitConfirmationSheet({
    super.key,
    required this.isSubmitting,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: const Color(0xFFFFF3E0), shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: AppColors.accent, size: 32),
          ),
          const SizedBox(height: 18),
          Text('ready_to_submit'.tr, style: AppTextStyles.h1.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(
            'submit_warning'.tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: isSubmitting ? null : onConfirm,
                  child: Center(
                    child: isSubmitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.4, valueColor: AlwaysStoppedAnimation(Colors.white)),
                          )
                        : Text('submit_review'.tr, style: AppTextStyles.button),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: isSubmitting ? null : onCancel,
            child: Text('cancel'.tr, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
