import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/storage_service.dart';

class LanguageController extends GetxController {
  final RxString selectedLocale = 'ar_SY'.obs;

  void selectArabic() => selectedLocale.value = 'ar_SY';
  void selectEnglish() => selectedLocale.value = 'en_US';

  /// Called when the user taps the gold "متابعة / Continue" button.
  /// Saves the chosen locale, applies it app-wide, then sends the
  /// user to the onboarding welcome screen.
  Future<void> confirmSelection() async {
    final code = selectedLocale.value;
    await StorageService.instance.saveLanguage(code);

    final parts = code.split('_');
    Get.updateLocale(Locale(parts[0], parts[1]));

    Get.offAllNamed(AppRoutes.onboarding);
  }
}
