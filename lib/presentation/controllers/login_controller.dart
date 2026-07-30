import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/errors/api_exception.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/storage_service.dart';
import '../../domain/usecases/login_usecase.dart';
import '../widgets/app_feedback.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isPasswordHidden = true.obs;
  final RxBool isLoading = false.obs;

  final RxnString emailError = RxnString();
  final RxnString passwordError = RxnString();

  final LoginUseCase _loginUseCase;

  LoginController(this._loginUseCase);

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;

  bool _validate() {
    emailError.value = null;
    passwordError.value = null;

    final email = emailController.text.trim();
    final password = passwordController.text;

    bool isValid = true;

    if (email.isEmpty) {
      emailError.value = 'email_required'.tr;
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'email_invalid'.tr;
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError.value = 'password_required'.tr;
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = 'password_min'.tr;
      isValid = false;
    }

    return isValid;
  }

Future<void> login() async {
  if (!_validate()) return;

  isLoading.value = true;
  try {
    print("🚀 1. بدء عملية تسجيل الدخول...");
    
    final result = await _loginUseCase.call(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    print("✅ 2. نجاح الاستجابة من السيرفر. Token: ${result.data.token}");

    // حفظ البيانات
    await StorageService.instance.saveToken(result.data.token);
    await StorageService.instance.saveUser(result.data.user.toJson());
    await StorageService.instance.saveCompany(result.data.company.toJson());
    await StorageService.instance.setFirstLogin(result.data.user.isFirstLogin);

    print("STATUS isFirstLogin: ${result.data.user.isFirstLogin}");

    // التوجيه
    if (result.data.user.isFirstLogin) {
      Get.offAllNamed(AppRoutes.resetPassword);
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  } on ApiException catch (e) {
    print("🔴 3. ApiException (خطأ من الـ API أو الشبكة): ${e.message}");
    AppFeedback.showError(e.message ?? 'generic_error');
  } catch (e, stack) {
    print("💥 4. Crash Error (خطأ تحويل بيانات JSON أو مسار غير موجود): $e");
    print("📚 STACKTRACE:\n$stack");
    AppFeedback.showError(e.toString()); // سيعرض لكِ الخطأ نصياً في أسفل الشاشة
  } finally {
    isLoading.value = false;
  }
}
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}