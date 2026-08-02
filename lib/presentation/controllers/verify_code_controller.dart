import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khibrat_flutter2/core/errors/api_exception.dart';
import 'package:khibrat_flutter2/core/routes/app_routes.dart';
import '../../domain/repositories/auth_repository.dart';

class VerifyCodeController extends GetxController {
  /// ⚠️ لازم تطابق فترة الـ throttle/cooldown الفعلية بالباك اند لإرسال
  /// OTP (تحقق منها بكود resend-otp endpoint). القيمة الحالية افتراضية.
  static const int otpCooldownSeconds = 50;

  final AuthRepository authRepository;
  VerifyCodeController({required this.authRepository});

  late String email;
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  final isLoading = false.obs;
  final isResending = false.obs;
  final errorMessage = ''.obs;
  final RxInt cooldownRemaining = 0.obs;
  Timer? _cooldownTimer;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';
    // العميل بيوصل هالشاشة بعد ما تم إرسال أول OTP فعلياً من الشاشة
    // السابقة، فبنبدأ الـ cooldown فوراً بدل ما نستنى أول محاولة فاشلة.
    _startCooldown();
  }

  void _startCooldown([int seconds = otpCooldownSeconds]) {
    _cooldownTimer?.cancel();
    cooldownRemaining.value = seconds;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (cooldownRemaining.value <= 1) {
        cooldownRemaining.value = 0;
        timer.cancel();
      } else {
        cooldownRemaining.value--;
      }
    });
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
    // الزر أصلاً معطّل بالـ UI أثناء الـ cooldown، بس هاد guard إضافي
    // بيمنع أي استدعاء برمجي/سريع مزدوج من الوصول للـ API أصلاً.
    if (isResending.value || cooldownRemaining.value > 0) return;
    if (email.isEmpty) {
      Get.snackbar('error'.tr, 'failed_resend_code'.tr);
      return;
    }
    isResending.value = true;
    try {
      final message = await authRepository.resendOtp(email: email);

      Get.snackbar(
        'success'.tr,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF002166),
        colorText: Colors.white,
      );
      _startCooldown();
    } on ApiException catch (e) {
      // Backend messages (e.g. 429) are full sentences — show as-is.
      // Translation keys like network_error have no spaces.
      final text = e.message.contains(' ') ? e.message : e.message.tr;
      Get.snackbar(
        'error'.tr,
        text,
        snackPosition: SnackPosition.BOTTOM,
      );
      // لو وصلنا هون معناه صار 429 رغم الـ guard المحلي (مثلاً فرق ساعة
      // بين الجهاز والسيرفر) — منبدأ cooldown جديد كحماية إضافية بدل ما
      // نسيب الزر مفعّل ويكرر نفس الخطأ.
      if (e.message.toLowerCase().contains('wait')) {
        _startCooldown();
      }
    } catch (_) {
      Get.snackbar('error'.tr, 'failed_resend_code'.tr);
    } finally {
      isResending.value = false;
    }
  }

  @override
  void onClose() {
    _cooldownTimer?.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
