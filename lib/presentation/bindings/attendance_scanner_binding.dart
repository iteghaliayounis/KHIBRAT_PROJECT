import 'package:get/get.dart';
import '../../data/repositories/attendance_repository.dart';
import '../controllers/attendance_controller.dart';
import '../controllers/attendance_scanner_controller.dart';

class AttendanceScannerBinding extends Bindings {
  @override
  void dependencies() {
    final args = (Get.arguments is Map) ? Get.arguments as Map : const {};
    final modeName = args['mode']?.toString();
    final mode = modeName == AttendanceScanMode.checkOut.name
        ? AttendanceScanMode.checkOut
        : AttendanceScanMode.checkIn;

    if (!Get.isRegistered<AttendanceRepository>()) {
      Get.lazyPut<AttendanceRepository>(() => AttendanceRepository());
    }

    Get.lazyPut<AttendanceScannerController>(
      () => AttendanceScannerController(
        mode: mode,
        repository: Get.find<AttendanceRepository>(),
      ),
    );
  }
}
