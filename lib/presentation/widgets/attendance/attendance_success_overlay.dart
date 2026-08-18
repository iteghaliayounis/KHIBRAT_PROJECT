import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/khubrat_colors.dart';
import '../../../data/models/attendance_models.dart';
import 'attendance_ui_helpers.dart';

/// Shown only after API success == true.
class AttendanceSuccessOverlay extends StatefulWidget {
  final AttendanceActionResult result;
  final bool isCheckIn;
  final VoidCallback onDone;

  const AttendanceSuccessOverlay({
    super.key,
    required this.result,
    required this.isCheckIn,
    required this.onDone,
  });

  @override
  State<AttendanceSuccessOverlay> createState() => _AttendanceSuccessOverlayState();
}

class _AttendanceSuccessOverlayState extends State<AttendanceSuccessOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.result.record;
    final title = widget.isCheckIn
        ? 'attendance_check_in_success'.tr
        : 'attendance_check_out_success'.tr;

    return Container(
      color: context.khubrat.isDark ? Colors.transparent : Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            ScaleTransition(
              scale: _scale,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, size: 56, color: AppColors.success),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h1.copyWith(color: context.khubrat.title),
            ),
            if (widget.result.message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                widget.result.message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: context.khubrat.textSecondary),
              ),
            ],
            const SizedBox(height: 28),
            _InfoRow(
              label: 'attendance_date'.tr,
              value: AttendanceUiHelpers.formatDate(record.workDate),
            ),
            if (record.checkInTime != null)
              _InfoRow(
                label: 'attendance_check_in'.tr,
                value: AttendanceUiHelpers.formatTime(record.checkInTime),
              ),
            if (record.checkOutTime != null)
              _InfoRow(
                label: 'attendance_check_out'.tr,
                value: AttendanceUiHelpers.formatTime(record.checkOutTime),
              ),
            if (record.lateMinutes != null)
              _InfoRow(
                label: 'attendance_late_minutes'.tr,
                value: AttendanceUiHelpers.formatMinutes(record.lateMinutes),
              ),
            const Spacer(flex: 3),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: widget.onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'done'.tr,
                  style: AppTextStyles.button.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: context.khubrat.textSecondary)),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.khubrat.title,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
