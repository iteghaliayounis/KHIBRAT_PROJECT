import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class EvaluationProgressCard extends StatelessWidget {
  final int pending;
  final int completed;
  final double completionPercentage;

  const EvaluationProgressCard({
    super.key,
    required this.pending,
    required this.completed,
    required this.completionPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final pct = completionPercentage.clamp(0, 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.28),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'evaluation_progress_title'.tr,
            style: AppTextStyles.h3.copyWith(color: Colors.white70, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _StatBlock(value: '$pending', label: 'pending'.tr),
              const SizedBox(width: 32),
              _StatBlock(value: '$completed', label: 'completed'.tr),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Container(height: 8, color: Colors.white.withOpacity(0.18)),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 8,
                      width: constraints.maxWidth * (pct / 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(colors: AppColors.goldGradient),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              '${pct.round()}%',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String value;
  final String label;
  const _StatBlock({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.h1.copyWith(color: AppColors.secondary, fontSize: 28, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
      ],
    );
  }
}
