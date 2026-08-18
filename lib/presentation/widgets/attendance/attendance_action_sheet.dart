import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/khubrat_colors.dart';

class AttendanceActionSheet {
  AttendanceActionSheet._();

  static void show({
    required VoidCallback onCheckIn,
    required VoidCallback onCheckOut,
  }) {
    final palette = Get.context!.khubrat;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: palette.chipBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'attendance_choose_action'.tr,
                style: AppTextStyles.h2.copyWith(color: palette.title),
              ),
              const SizedBox(height: 6),
              Text(
                'attendance_choose_action_hint'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: palette.textSecondary),
              ),
              const SizedBox(height: 20),
              _ActionButton(
                label: 'attendance_check_in'.tr,
                icon: Icons.login_rounded,
                color: AppColors.primary,
                onTap: () {
                  Get.back();
                  onCheckIn();
                },
              ),
              const SizedBox(height: 12),
              _ActionButton(
                label: 'attendance_check_out'.tr,
                icon: Icons.logout_rounded,
                color: AppColors.accent,
                onTap: () {
                  Get.back();
                  onCheckOut();
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: AppTextStyles.button.copyWith(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
