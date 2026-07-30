import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khibrat_flutter2/core/errors/api_exception.dart';
import 'package:khibrat_flutter2/core/routes/app_routes.dart';
import '../../domain/repositories/auth_repository.dart';


class VerifyCodeController extends GetxController {
  final AuthRepository authRepository;
  VerifyCodeController({required this.authRepository});

  late String email;
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  final isLoading = false.obs;
  final isResending = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';
  }

  String get code => otpControllers.map((c) => c.text).join();
Future<void> verifyCode() async {
    if (code.length < 4) {
      errorMessage.value = 'enter_complete_code'.tr;
      return;
    }
    errorMessage.value = '';
    isLoading.value = true;
    try {
      await authRepository.verifyResetCode(email: email, code: code);

      Get.toNamed(AppRoutes.resetPassword, arguments: {
        'email': email,
        'code': code,
      });
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'invalid_code'.tr;
    } finally {
      isLoading.value = false;
    }
  }

Future<void> resendCode() async {
    isResending.value = true;
    try {
      await authRepository.sendResetCode(email: email);

      Get.snackbar(
        'success'.tr,
        'code_resent_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF002166),
        colorText: Colors.white,
      );
    } on ApiException catch (e) {
      Get.snackbar('error'.tr, e.message);
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_resend_code'.tr);
    } finally {
      isResending.value = false;
    }
  }

  @override
  void onClose() {
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}