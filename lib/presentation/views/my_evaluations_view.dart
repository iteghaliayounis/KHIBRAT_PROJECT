import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../controllers/my_evaluations_controller.dart';
import '../widgets/evaluation/evaluation_progress_card.dart';
import '../widgets/evaluation/evaluation_review_card.dart';

class MyEvaluationsView extends GetView<MyEvaluationsController> {
  const MyEvaluationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (controller.errorMessage.value != null && controller.pendingReviews.isEmpty && controller.completedReviews.isEmpty) {
                  return _ErrorState(
                    message: controller.errorMessage.value!.tr,
                    onRetry: () => controller.fetchMyReviews(),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.refresh,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      EvaluationProgressCard(
                        pending: controller.pending.value,
                        completed: controller.completed.value,
                        completionPercentage: controller.completionPercentage.value,
                      ),
                      const SizedBox(height: 20),
                      _SectionTitle(title: 'pending'.tr),
                      const SizedBox(height: 10),
                      if (controller.pendingReviews.isEmpty)
                        _EmptyState(text: 'no_pending_evaluations'.tr)
                      else
                        ...controller.pendingReviews.map(
                          (review) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: EvaluationReviewCard(
                              review: review,
                              onTap: () => controller.startReview(review),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      _SectionTitle(title: 'completed'.tr),
                      const SizedBox(height: 10),
                      if (controller.completedReviews.isEmpty)
                        _EmptyState(text: 'no_completed_evaluations'.tr)
                      else
                        ...controller.completedReviews.map(
                          (review) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: EvaluationReviewCard(
                              review: review,
                              onTap: () => controller.openCompletedReview(review),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Get.back(),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.arrow_back_rounded, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('my_evaluations'.tr, style: AppTextStyles.h1.copyWith(color: AppColors.primary)),
              Text('my_evaluations_subtitle'.tr, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.h2.copyWith(color: AppColors.primary));
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      alignment: Alignment.center,
      child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            TextButton(onPressed: onRetry, child: Text('retry'.tr)),
          ],
        ),
      ),
    );
  }
}
