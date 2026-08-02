import 'package:get/get.dart';

import '../../data/repositories/leave_repository_impl.dart';
import '../../domain/repositories/leave_repository.dart';
import '../../domain/usecases/apply_leave_usecase.dart';
import '../../domain/usecases/get_leave_types_usecase.dart';
import '../controllers/apply_leave_controller.dart';

class ApplyLeaveBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LeaveRepository>()) {
      Get.lazyPut<LeaveRepository>(() => LeaveRepositoryImpl());
    }
    Get.lazyPut<ApplyLeaveController>(
      () => ApplyLeaveController(
        GetLeaveTypesUseCase(Get.find<LeaveRepository>()),
        ApplyLeaveUseCase(Get.find<LeaveRepository>()),
      ),
    );
  }
}
