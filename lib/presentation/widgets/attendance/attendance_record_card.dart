import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/attendance_models.dart';
import 'attendance_ui_helpers.dart';

class AttendanceRecordCard extends StatelessWidget {
  final AttendanceRecordModel record;

  const AttendanceRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final statusColor = AttendanceUiHelpers.statusColor(record.status);
    final statusText = AttendanceUiHelpers.statusLabelKey(record.status).tr;
    final typeText = AttendanceUiHelpers.typeLabelKey(record.attendanceType).tr;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AttendanceUiHelpers.formatDate(record.workDate),
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: AppTextStyles.bodySmall.copyWith(color: statusColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            typeText,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TimeCell(
                  label: 'attendance_check_in'.tr,
                  value: AttendanceUiHelpers.formatTime(record.checkInTime),
                ),
              ),
              Expanded(
                child: _TimeCell(
                  label: 'attendance_check_out'.tr,
                  value: AttendanceUiHelpers.formatTime(record.checkOutTime),
                ),
              ),
              Expanded(
                child: _TimeCell(
                  label: 'attendance_late_minutes'.tr,
                  value: AttendanceUiHelpers.formatMinutes(record.lateMinutes),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeCell extends StatelessWidget {
  final String label;
  final String value;

  const _TimeCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
