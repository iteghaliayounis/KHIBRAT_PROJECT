import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khibrat_flutter2/core/errors/api_exception.dart';
import 'package:khibrat_flutter2/core/routes/app_routes.dart';
import 'package:khibrat_flutter2/core/utils/storage_service.dart';
import '../../domain/repositories/auth_repository.dart';


class ResetPasswordController extends GetxController {
  final AuthRepository authRepository;
  ResetPasswordController({required this.authRepository});

  late String email;
  late String code;

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isNewPasswordObscure = true.obs;
  final isConfirmPasswordObscure = true.obs;
  final isLoading = false.obs;

  final newPasswordError = ''.obs;
  final confirmPasswordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';
    code = Get.arguments?['code'] ?? '';
  }

  void toggleNewPassword() => isNewPasswordObscure.value = !isNewPasswordObscure.value;
  void toggleConfirmPassword() => isConfirmPasswordObscure.value = !isConfirmPasswordObscure.value;
Future<void> submitResetPassword() async {
    newPasswordError.value = '';
    confirmPasswordError.value = '';

    final pass = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    if (pass.length < 6) {
      newPasswordError.value = 'password_too_short'.tr;
      return;
    }
    if (pass != confirm) {
      confirmPasswordError.value = 'passwords_dont_match'.tr;
      return;
    }

    isLoading.value = true;
    try {
      if (StorageService.instance.isFirstLogin) {
        // 🔒 مسار الدخول الأول الإجباري — عبر التوكن، بدون إيميل
        await authRepository.completeFirstLogin(
          password: pass,
          passwordConfirmation: confirm,
        );
        await StorageService.instance.setFirstLogin(false);
        Get.offAllNamed(AppRoutes.home);
      } else {
        // مسار نسيت كلمة المرور العادي — بعد التحقق من OTP
        await authRepository.resetPassword(
          email: email,
          code: code,
          newPassword: pass,
          passwordConfirmation: confirm,
        );
        Get.offAllNamed(AppRoutes.login);
      }

      Get.snackbar(
        'success'.tr,
        'password_reset_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF002166),
        colorText: Colors.white,
      );
    } on ApiException catch (e) {
      Get.snackbar('error'.tr, e.message);
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_reset_password'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}