import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khibrat_flutter2/core/utils/storage_service.dart';
import '../controllers/reset_password_controller.dart';
import '../widgets/custom_text_field.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

@override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !StorageService.instance.isFirstLogin,
      child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
// ── Header ──
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // إخفاء زر العودة إذا كانت عملية الدخول الأول إجبارية
    StorageService.instance.isFirstLogin
        ? const SizedBox(width: 40)
        : InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF002166),
                size: 16,
              ),
            ),
          ),
    Text(
      'reset_password_title'.tr,
      style: GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF002166),
      ),
    ),
    const SizedBox(width: 40),
  ],
),

              const SizedBox(height: 32),

              Text(
                'create_new_password'.tr,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF002166),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'enter_new_password_sub'.tr,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 32),

              // ── حقل كلمة المرور الجديدة ──
              Text(
                'new_password'.tr,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF002166),
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => CustomTextField(
                  controller: controller.newPasswordController,
                  hintText: 'enter_new_password'.tr,
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: controller.isNewPasswordObscure.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isNewPasswordObscure.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: controller.toggleNewPassword,
                  ),
                  errorText: controller.newPasswordError.value,
                ),
              ),

              const SizedBox(height: 20),

              // ── حقل تأكيد كلمة المرور الجديدة ──
              Text(
                'confirm_new_password'.tr,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF002166),
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => CustomTextField(
                  controller: controller.confirmPasswordController,
                  hintText: 'confirm_new_password_hint'.tr,
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: controller.isConfirmPasswordObscure.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordObscure.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: controller.toggleConfirmPassword,
                  ),
                  errorText: controller.confirmPasswordError.value,
                ),
              ),

              const SizedBox(height: 36),

              // ── زر حفظ كلمة المرور ──
              Obx(
                () => SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.submitResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002166),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      shadowColor: const Color(0xFF002166).withOpacity(0.35),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'save_password'.tr,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
  ) );
  }
}