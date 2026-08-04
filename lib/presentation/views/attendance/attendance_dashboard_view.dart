import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../controllers/attendance_controller.dart';
import '../../widgets/attendance/attendance_action_area.dart';
import '../../widgets/attendance/attendance_month_selector.dart';
import '../../widgets/attendance/attendance_record_card.dart';
import '../../widgets/attendance/attendance_summary_cards.dart';
import '../../widgets/attendance/attendance_ui_helpers.dart';

class AttendanceDashboardView extends GetView<AttendanceController> {
  const AttendanceDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final data = controller.dashboard.value;
                if (controller.errorMessage.value != null && data == null) {
                  return _ErrorState(
                    message: controller.errorMessage.value!.tr,
                    onRetry: () => controller.fetchDashboard(),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.refresh,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      Obx(
                        () => AttendanceMonthSelector(
                          month: controller.selectedMonth.value,
                          onPrevious: controller.previousMonth,
                          onNext: controller.nextMonth,
                          onMonthSelected: controller.selectMonth,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (controller.activeCheckIn != null) ...[
                        _CheckedInBanner(
                          checkInTime: AttendanceUiHelpers.formatTime(
                            controller.activeCheckIn!.checkInTime,
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      if (data != null) ...[
                        AttendanceSummaryCards(data: data),
                        const SizedBox(height: 20),
                        Text(
                          'attendance_records'.tr,
                          style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(height: 10),
                        if (data.records.isEmpty)
                          _EmptyState(text: 'attendance_no_records'.tr)
                        else
                          ...data.records.map(
                            (r) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: AttendanceRecordCard(record: r),
                            ),
                          ),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AttendanceActionArea(
        onQrTap: controller.openActionSheet,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
          Text(
            'attendance'.tr,
            style: AppTextStyles.h1.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _CheckedInBanner extends StatelessWidget {
  final String checkInTime;

  const _CheckedInBanner({required this.checkInTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'attendance_currently_checked_in'.trParams({'time': checkInTime}),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: Text('retry'.tr, style: AppTextStyles.button.copyWith(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}
