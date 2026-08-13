import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../core/errors/api_exception.dart';
import '../../data/models/attendance_models.dart';
import '../../data/repositories/attendance_repository.dart';
import '../widgets/app_feedback.dart';
import 'attendance_controller.dart';

/// Scanner flow: QR → GPS → check-in/out. No device_id. No lat/lng shown to user.
class AttendanceScannerController extends GetxController {
  final AttendanceRepository _repository;
  final AttendanceScanMode mode;

  AttendanceScannerController({
    required this.mode,
    AttendanceRepository? repository,
  }) : _repository = repository ?? AttendanceRepository();

  final RxBool isProcessing = false.obs;
  final RxBool showSuccess = false.obs;
  final RxnString statusMessage = RxnString();
  final Rxn<AttendanceActionResult> actionResult = Rxn<AttendanceActionResult>();

  bool _handled = false;

  Future<void> onQrDetected(String? rawValue) async {
    if (_handled || isProcessing.value) return;
    final token = rawValue?.trim();
    if (token == null || token.isEmpty) return;

    _handled = true;
    isProcessing.value = true;
    statusMessage.value = 'attendance_getting_location';

    try {
      final position = await _resolvePosition();
      statusMessage.value = mode == AttendanceScanMode.checkIn
          ? 'attendance_submitting_check_in'
          : 'attendance_submitting_check_out';

      final AttendanceActionResult result;
      if (mode == AttendanceScanMode.checkIn) {
        result = await _repository.checkIn(
          qrToken: token,
          latitude: position.latitude,
          longitude: position.longitude,
        );
      } else {
        result = await _repository.checkOut(
          qrToken: token,
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }

      actionResult.value = result;
      showSuccess.value = true;
      statusMessage.value = null;
    } on ApiException catch (e) {
      AppFeedback.showError(e.message);
      statusMessage.value = null;
      _handled = false;
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('location_services_disabled') ||
          msg.contains('attendance_location_services_disabled')) {
        AppFeedback.showError('attendance_location_services_disabled');
      } else if (msg.contains('location_permission') ||
          msg.contains('attendance_location_permission')) {
        AppFeedback.showError('attendance_location_permission_denied');
      } else {
        AppFeedback.showError('generic_error');
      }
      statusMessage.value = null;
      _handled = false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<Position> _resolvePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('attendance_location_services_disabled');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw Exception('attendance_location_permission_denied');
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception('attendance_location_permission_denied');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  void onDone() {
    Get.back(result: true);
  }
}
