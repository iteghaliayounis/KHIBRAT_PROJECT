import 'package:get/get.dart';
import '../controllers/verify_code_controller.dart';
import '../../domain/repositories/auth_repository.dart';

class VerifyCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyCodeController>(
      () => VerifyCodeController(authRepository: Get.find<AuthRepository>()),
    );
  }
}