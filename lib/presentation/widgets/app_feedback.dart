import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';

/// Central place for showing snackbars/toasts so every controller uses
/// the exact same look & feel instead of re-styling Get.snackbar calls.
class AppFeedback {
  AppFeedback._();

  static void showError(String messageKey) {
    Get.snackbar(
      '',
      messageKey.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      borderRadius: 14,
      margin: const EdgeInsets.all(14),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void showSuccess(String messageKey) {
    Get.snackbar(
      '',
      messageKey.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      borderRadius: 14,
      margin: const EdgeInsets.all(14),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }
}

/// Small reusable loading indicator (used inside buttons or standalone).
class AppLoader extends StatelessWidget {
  final double size;
  const AppLoader({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: const CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(AppColors.primary),
      ),
    );
  }
}
