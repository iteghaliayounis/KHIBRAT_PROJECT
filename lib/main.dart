import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/constants/app_translations.dart';
import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  // مطلوب قبل استخدام DateFormat مع locale مثل 'ar'
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');
  runApp(const KhubratApp());
}

class KhubratApp extends StatelessWidget {
  const KhubratApp({super.key});

  @override
  Widget build(BuildContext context) {
    final savedLanguage = StorageService.instance.language ?? 'ar_SY';
    final localeParts = savedLanguage.split('_');

    return GetMaterialApp(
      title: 'Khubrat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      translations: AppTranslations(),
      locale: Locale(localeParts[0], localeParts[1]),
      fallbackLocale: const Locale('ar', 'SY'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      builder: (context, child) {
        // Force RTL/LTR based on the selected language so every
        // screen respects the chosen direction automatically.
        final isArabic = Get.locale?.languageCode == 'ar';
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
