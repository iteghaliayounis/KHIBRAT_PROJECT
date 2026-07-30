import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/send_reset_code_usecase.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(
        SendResetCodeUseCase(Get.find<AuthRepository>()),
      ),
    );
  }
}