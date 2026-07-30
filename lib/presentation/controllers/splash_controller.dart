import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';

/// Splash controller مع انتقال تلقائي بعد ثانيتين
class SplashController extends GetxController {
  
  @override
  void onReady() {
    super.onReady();
    // onReady يضمن إن كلشي جاهز (Context، Binding، إلخ)
    debugPrint('✅ SplashController: onReady تم استدعاؤه');
    _navigateToNext();
  }

  /// الانتقال التلقائي بعد ثانيتين مع معالجة أخطاء
  void _navigateToNext() {
    debugPrint('⏱️ SplashController: بدء العد التنازلي 2 ثانية...');
    
    Future.delayed(const Duration(seconds: 2), () {
      debugPrint('⏰ SplashController: انتهى الوقت!');
      
      try {
        // التحقق من وجود Context
        if (Get.context == null) {
          debugPrint('❌ خطأ: Get.context فارغ!');
          return;
        }
        
        if (!Get.context!.mounted) {
          debugPrint('❌ خطأ: Context غير mounted!');
          return;
        }
        
        debugPrint('🚀 جاري الانتقال إلى: ${AppRoutes.language}');
        
        // التنقل مع تأكيد
        Get.offAllNamed(
          AppRoutes.language,
          predicate: (route) => false, // يحذف كل الشاشات السابقة
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