import 'package:get/get.dart';

import '../../data/repositories/leave_repository_impl.dart';
import '../../domain/repositories/leave_repository.dart';
import '../../domain/usecases/get_leave_dashboard_usecase.dart';
import '../controllers/leave_dashboard_controller.dart';

class LeaveDashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LeaveRepository>()) {
      Get.lazyPut<LeaveRepository>(() => LeaveRepositoryImpl());
    }
    Get.lazyPut<LeaveDashboardController>(
      () => LeaveDashboardController(
        GetLeaveDashboardUseCase(Get.find<LeaveRepository>()),
      ),
    );
  }
}
