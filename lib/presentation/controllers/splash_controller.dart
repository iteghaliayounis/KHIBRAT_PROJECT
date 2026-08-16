import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/push_notification_service.dart';
import '../../core/utils/storage_service.dart';

/// Splash controller مع انتقال تلقائي بعد ثانيتين
class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    debugPrint('✅ SplashController: onReady تم استدعاؤه');
    _navigateToNext();
  }

  /// الانتقال التلقائي بعد ثانيتين مع معالجة أخطاء
  void _navigateToNext() {
    debugPrint('⏱️ SplashController: بدء العد التنازلي 2 ثانية...');

    Future.delayed(const Duration(seconds: 2), () async {
      debugPrint('⏰ SplashController: انتهى الوقت!');

      try {
        if (Get.context == null) {
          debugPrint('❌ خطأ: Get.context فارغ!');
          return;
        }

        if (!Get.context!.mounted) {
          debugPrint('❌ خطأ: Context غير mounted!');
          return;
        }

        final token = StorageService.instance.token;
        final hasSession = token != null && token.isNotEmpty;

        if (hasSession) {
          debugPrint('🚀 جلسة موجودة — الانتقال إلى Home');
          Get.offAllNamed(AppRoutes.home);
          // Register/refresh FCM token + handle terminated-state notification tap.
          await PushNotificationService.instance.syncTokenAfterAuth();
          await PushNotificationService.instance.consumeInitialMessage();
          return;
        }

        debugPrint('🚀 جاري الانتقال إلى: ${AppRoutes.language}');
        Get.offAllNamed(
          AppRoutes.language,
          predicate: (route) => false,
        );
        debugPrint('✅ الانتقال تم بنجاح!');
      } catch (e, stackTrace) {
        debugPrint('❌❌❌ حدث خطأ أثناء الانتقال ❌❌❌');
        debugPrint('نوع الخطأ: ${e.runtimeType}');
        debugPrint('رسالة الخطأ: $e');
        debugPrint('Stack Trace: $stackTrace');
      }
    });
  }
}
