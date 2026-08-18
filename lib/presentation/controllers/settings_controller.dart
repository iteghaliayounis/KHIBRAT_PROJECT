import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/errors/api_exception.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/push_notification_service.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/utils/storage_service.dart';
import '../../data/providers/auth_provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../widgets/app_feedback.dart';

class SettingsController extends GetxController {
  SettingsController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? Get.find<AuthRepository>();

  final AuthRepository _authRepository;

  final RxString selectedLocale =
      (StorageService.instance.language ?? 'ar_SY').obs;
  final RxBool twoFactorEnabled =
      (StorageService.instance.twoFactorEnabled).obs;
  final RxBool isUpdatingTwoFactor = false.obs;
  final RxBool isLoggingOut = false.obs;

  bool get isArabic => selectedLocale.value.startsWith('ar');

  @override
  void onInit() {
    super.onInit();
    selectedLocale.value = StorageService.instance.language ??
        (Get.locale?.languageCode == 'en' ? 'en_US' : 'ar_SY');
    twoFactorEnabled.value = StorageService.instance.twoFactorEnabled;
  }

  Future<void> changeTheme(bool dark) => ThemeController.to.setDark(dark);

  Future<void> changeLanguage(String code) async {
    if (selectedLocale.value == code) return;
    selectedLocale.value = code;
    await StorageService.instance.saveLanguage(code);
    final parts = code.split('_');
    Get.updateLocale(Locale(parts[0], parts[1]));
  }

  Future<void> toggleTwoFactor(bool enabled) async {
    if (isUpdatingTwoFactor.value) return;
    final previous = twoFactorEnabled.value;
    twoFactorEnabled.value = enabled;
    isUpdatingTwoFactor.value = true;
    try {
      final value = await _authRepository.setTwoFactorEnabled(enabled: enabled);
      twoFactorEnabled.value = value;
      AppFeedback.showSuccess('settings_2fa_updated');
    } on ApiException catch (e) {
      twoFactorEnabled.value = previous;
      AppFeedback.showError(e.message);
    } catch (_) {
      twoFactorEnabled.value = previous;
      AppFeedback.showError('generic_error');
    } finally {
      isUpdatingTwoFactor.value = false;
    }
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;
    isLoggingOut.value = true;
    try {
      try {
        await PushNotificationService.instance.unregisterBeforeLogout();
      } catch (_) {}
      await AuthProvider().logout();
    } catch (_) {
    } finally {
      await StorageService.instance.clearSession();
      isLoggingOut.value = false;
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
