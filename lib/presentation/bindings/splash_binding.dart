import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_fixed.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // استخدام put بدلاً من lazyPut لضمان تشغيله فوراً
    Get.put<SplashController>(SplashController());

    // Register concrete AuthRepository implementation so other bindings (login, reset, verify)
    // can call Get.find<AuthRepository>(). Keep permanent to reuse across app lifecycle.
    if (!Get.isRegistered<AuthRepository>()) {
    Get.put<AuthRepository>(AuthRepositoryFixed(), permanent: true);
    }
  }
}