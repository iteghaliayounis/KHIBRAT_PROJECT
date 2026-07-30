import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(
        LoginUseCase(Get.find<AuthRepository>()),
      ),
    );
  }
}