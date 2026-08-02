import 'package:get/get.dart';
import '../../data/repositories/evaluation_repository.dart';
import '../controllers/my_evaluations_controller.dart';

class MyEvaluationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EvaluationRepository>(() => EvaluationRepository());
    Get.lazyPut<MyEvaluationsController>(
      () => MyEvaluationsController(repository: Get.find<EvaluationRepository>()),
    );
  }
}
