import 'package:get/get.dart';
import '../../data/repositories/attendance_repository.dart';
import '../controllers/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceRepository>(() => AttendanceRepository());
    Get.lazyPut<AttendanceController>(
      () => AttendanceController(repository: Get.find<AttendanceRepository>()),
    );
  }
}
