import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/constants/app_translations.dart';
import 'core/routes/app_pages.dart';
import 'core/services/push_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/khubrat_colors.dart';
import 'core/theme/theme_controller.dart';
import 'core/utils/storage_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotificationService.instance.initialize();

  // مطلوب قبل استخدام DateFormat مع locale مثل 'ar'
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');
  Get.put(ThemeController(), permanent: true);
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
      darkTheme: AppTheme.dark,
      themeMode: ThemeController.to.themeMode,
      translations: AppTranslations(),
      locale: Locale(localeParts[0], localeParts[1]),
      fallbackLocale: const Locale('ar', 'SY'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      builder: (context, child) {
        final isArabic = Get.locale?.languageCode == 'ar';
        final palette = KhubratColors.of(context);
        Widget content = child ?? const SizedBox.shrink();
        if (Theme.of(context).brightness == Brightness.dark) {
          content = DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  palette.backgroundGlow,
                  palette.backgroundDeep,
                ],
              ),
            ),
            child: content,
          );
        }
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: content,
        );
      },
    );
  }
}
