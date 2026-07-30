import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/errors/api_exception.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/usecases/send_reset_code_usecase.dart';
import '../widgets/app_feedback.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxnString emailError = RxnString();

  final SendResetCodeUseCase _sendResetCodeUseCase;

  // 🔹 التمرير عبر الـ Constructor
  ForgotPasswordController(this._sendResetCodeUseCase);

  bool _validate() {
    emailError.value = null;
    final email = emailController.text.trim();

    if (email.isEmpty) {
      emailError.value = 'email_required'.tr;
      return false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'invalid_email'.tr;
      return false;
    }
    return true;
  }

Future<void> sendResetCode() async {
    if (!_validate()) return;

    isLoading.value = true;
    try {
      final email = emailController.text.trim();

await _sendResetCodeUseCase.call(email: email);

      AppFeedback.showSuccess('reset_code_sent_success'.tr);
      
      // الانتقال للواجهة التالية بإيميل وهمي أو الإيميل المكتوب
      Get.toNamed(AppRoutes.verifyCode, arguments: {'email': email});
    } on ApiException catch (e) {
      AppFeedback.showError(e.message);
    } catch (_) {
      AppFeedback.showError('generic_error'.tr);
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}