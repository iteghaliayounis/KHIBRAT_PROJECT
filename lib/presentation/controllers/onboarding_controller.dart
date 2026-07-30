import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/login_response_model.dart';
import '../../domain/repositories/auth_repository.dart';

// كلاس وهمي سريع جداً لتفادي خطأ GetX أثناء التنقل التجريبي
class _TempMockAuthRepository implements AuthRepository {
  @override
  Future<LoginResponseModel> login({required String email, required String password}) async => throw UnimplementedError();
  @override
  Future<void> sendResetCode({required String email}) async {}
  @override
  Future<void> verifyResetCode({required String email, required String code}) async {}
  @override
  Future<void> resetPassword({required String email, required String code, required String newPassword, required String passwordConfirmation}) async {}
  @override
  Future<void> completeFirstLogin({required String password, required String passwordConfirmation}) async {}
}

class OnboardingController extends GetxController {
  void goToLogin() {
    // 🔹 تسجيل المستودع الوهمي بالذاكرة قبل الانتقال
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put<AuthRepository>(_TempMockAuthRepository(), permanent: true);
    }

    Get.offAllNamed(AppRoutes.login);
  }
}