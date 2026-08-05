import 'package:get/get.dart';
import '../../data/providers/overtime_provider.dart';
import '../../data/repositories/overtime_repository_impl.dart';
import '../../domain/repositories/overtime_repository.dart';
import '../../domain/usecases/get_overtime_preview_usecase.dart';
import '../../domain/usecases/apply_overtime_usecase.dart';
import '../../domain/usecases/get_overtime_requests_usecase.dart';
import '../controllers/overtime_controller.dart';

/// ApiClient صار singleton (ApiClient.instance) وبيتنادى مباشرة من
/// جوا OvertimeProvider، فما عاد في داعي نسجله أو نعمله Get.find هون.
class OvertimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OvertimeProvider>(() => OvertimeProvider());
    Get.lazyPut<OvertimeRepository>(
      () => OvertimeRepositoryImpl(Get.find<OvertimeProvider>()),
    );
    Get.lazyPut(() => GetOvertimePreviewUsecase(Get.find<OvertimeRepository>()));
    Get.lazyPut(() => ApplyOvertimeUsecase(Get.find<OvertimeRepository>()));
    Get.lazyPut(
      () => GetOvertimeRequestsUsecase(Get.find<OvertimeRepository>()),
    );
    Get.lazyPut(
      () => OvertimeController(
        getPreviewUsecase: Get.find(),
        applyUsecase: Get.find(),
        getRequestsUsecase: Get.find(),
      ),
    );
  }
}
