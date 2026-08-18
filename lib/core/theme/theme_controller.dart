import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/storage_service.dart';

/// Isolated dark/light switch. Delete this file + its storage key to remove
/// the appearance feature without touching brand colors.
class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  final RxBool isDark = false.obs;

  ThemeMode get themeMode => isDark.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    isDark.value = StorageService.instance.isDarkTheme;
  }

  Future<void> setDark(bool dark) async {
    if (isDark.value == dark) return;
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
    isDark.value = dark;
    await StorageService.instance.saveDarkTheme(dark);
  }
}
