import 'package:get/get.dart';
import '../../data/repositories/salary_repository.dart';
import '../controllers/salary_controller.dart';

class SalaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalaryRepository>(() => SalaryRepository());
    Get.lazyPut<SalaryController>(
      () => SalaryController(repository: Get.find<SalaryRepository>()),
    );
  }
}
