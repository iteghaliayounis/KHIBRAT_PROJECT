import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../controllers/salary_controller.dart';
import '../../widgets/salary/advance_eligibility_card.dart';
import '../../widgets/salary/advance_record_card.dart';
import '../../widgets/salary/last_received_salary_card.dart';
import '../../widgets/salary/salary_empty_state.dart';
import '../../widgets/salary/salary_record_card.dart';
import '../../widgets/salary/salary_tab_switcher.dart';

class SalaryDashboardView extends GetView<SalaryController> {
  const SalaryDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      body: Column(
        children: [
          _Header(controller: controller),
          Expanded(
            child: Obx(() {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, anim) {
                  return FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0.02),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  );
                },
                child: controller.selectedTab.value == SalaryTab.salaries
                    ? _SalariesTab(key: const ValueKey('salaries'), controller: controller)
                    : _AdvancesTab(key: const ValueKey('advances'), controller: controller),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final SalaryController controller;
  const _Header({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 10, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.brandNavy, Color(0xFF001752)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Color(0x33002173), blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                ),
              ),
              Expanded(
                child: Text(
                  'salary_dashboard_title'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 14),
          Obx(
            () => SalaryTabSwitcher(
              selected: controller.selectedTab.value,
              showAdvancesDot: controller.advances.isNotEmpty,
              onChanged: controller.selectTab,
            ),
          ),
        ],
      ),
    );
  }
}

class _SalariesTab extends StatelessWidget {
  final SalaryController controller;
  const _SalariesTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingSalaries.value) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: SalarySkeleton(),
        );
      }

      if (controller.salariesError.value != null && controller.salariesDashboard.value == null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(controller.salariesError.value!.tr, style: AppTextStyles.bodyMedium),
              TextButton(onPressed: controller.fetchSalaries, child: Text('retry'.tr)),
            ],
          ),
        );
      }

      final data = controller.salariesDashboard.value;
      final records = data?.records.data ?? [];
      final last = data?.lastReceivedSalary;

      return RefreshIndicator(
        color: AppColors.brandNavy,
        onRefresh: controller.fetchSalaries,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          children: [
            if (last != null) ...[
              LastReceivedSalaryCard(
                data: last,
                onViewDetails: last.salaryRecordId == null
                    ? null
                    : () => controller.openSalaryDetails(last.salaryRecordId!),
              ),
              const SizedBox(height: 18),
            ],
            SalarySectionHeader(
              title: 'salary_history_title'.tr,
              icon: Icons.history_rounded,
              trailing: 'salary_sorted_desc'.tr,
            ),
            const SizedBox(height: 12),
            if (records.isEmpty)
              SalaryEmptyState(message: 'salary_no_records'.tr)
            else
              ...records.asMap().entries.map(
                    (e) => SalaryRecordCard(
                      record: e.value,
                      index: e.key,
                      onDetails: () => controller.openSalaryDetails(e.value.id),
                    ),
                  ),
          ],
        ),
      );
    });
  }
}

class _AdvancesTab extends StatelessWidget {
  final SalaryController controller;
  const _AdvancesTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAdvances.value && controller.eligibility.value == null) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: SalarySkeleton(),
        );
      }

      return RefreshIndicator(
        color: AppColors.brandNavy,
        onRefresh: () async {
          await Future.wait([
            controller.fetchEligibility(),
            controller.fetchAdvances(),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          children: [
            if (controller.eligibility.value != null)
              AdvanceEligibilityCard(
                data: controller.eligibility.value!,
                onRequest: controller.openAdvanceRequestSheet,
              ),
            const SizedBox(height: 20),
            SalarySectionHeader(
              title: 'salary_advances_history'.tr,
              icon: Icons.receipt_long_rounded,
              trailing: 'salary_requests_count'.trParams({
                'count': '${controller.advances.length}',
              }),
            ),
            const SizedBox(height: 12),
            if (controller.advancesError.value != null && controller.advances.isEmpty)
              SalaryEmptyState(message: controller.advancesError.value!.tr)
            else if (controller.advances.isEmpty)
              SalaryEmptyState(
                message: 'salary_no_advances'.tr,
                icon: Icons.volunteer_activism_outlined,
              )
            else
              ...controller.advances.asMap().entries.map(
                    (e) => AdvanceRecordCard(record: e.value, index: e.key),
                  ),
          ],
        ),
      );
    });
  }
}
