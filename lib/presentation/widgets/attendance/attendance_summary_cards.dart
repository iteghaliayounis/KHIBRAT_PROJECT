import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/attendance_models.dart';
import 'attendance_ui_helpers.dart';

class AttendanceSummaryCards extends StatelessWidget {
  final AttendanceDashboardModel data;

  const AttendanceSummaryCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final items = [
      _SummaryItem(
        label: 'attendance_present_days'.tr,
        value: '${data.presentDays}',
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.success,
      ),
      _SummaryItem(
        label: 'attendance_absent_days'.tr,
        value: '${data.absentDays}',
        icon: Icons.cancel_outlined,
        color: AppColors.error,
      ),
      _SummaryItem(
        label: 'attendance_leave_days'.tr,
        value: '${data.leaveDays}',
        icon: Icons.beach_access_outlined,
        color: AppColors.accent,
      ),
      _SummaryItem(
        label: 'attendance_total_late'.tr,
        value: '${data.totalLateMinutes}',
        icon: Icons.schedule_rounded,
        color: const Color(0xFFE65100),
      ),
      _SummaryItem(
        label: 'attendance_total_hours'.tr,
        value: AttendanceUiHelpers.formatWorkHours(data.totalWorkHours),
        icon: Icons.timelapse_rounded,
        color: AppColors.primary,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (_, i) => items[i],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEDED)),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.h2.copyWith(color: AppColors.primary, fontSize: 20),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
