import 'package:get/get.dart';
import '../../data/repositories/evaluation_repository.dart';
import '../controllers/evaluation_controller.dart';

class EvaluationBinding extends Bindings {
  @override
  void dependencies() {
    final args = (Get.arguments is Map) ? Get.arguments as Map : const {};
    final reviewId = args['reviewId'];
    final readOnly = args['readOnly'] == true;

    Get.lazyPut<EvaluationRepository>(() => EvaluationRepository());
    Get.lazyPut<EvaluationController>(
      () => EvaluationController(
        reviewId: reviewId,
        readOnly: readOnly,
        repository: Get.find<EvaluationRepository>(),
      ),
    );
  }
}
