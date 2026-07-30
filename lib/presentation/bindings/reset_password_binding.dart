import 'package:get/get.dart';
import '../controllers/reset_password_controller.dart';
import '../../domain/repositories/auth_repository.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(authRepository: Get.find<AuthRepository>()),
    );
  }
}