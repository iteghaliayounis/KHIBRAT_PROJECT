import '../../core/constants/api_constants.dart';
import '../../core/errors/api_exception.dart';
import '../../core/network/api_client.dart';
import '../models/attendance_models.dart';

/// Talks only to the three Attendance endpoints. No device_id. No invented fields.
class AttendanceRepository {
  final ApiClient _client;

  AttendanceRepository({ApiClient? client}) : _client = client ?? ApiClient.instance;

  /// GET /api/employee/attendance/dashboard?month=YYYY-MM
  Future<AttendanceDashboardModel> getDashboard({required String month}) async {
    final json = await _client.get(
      ApiConstants.attendanceDashboard,
      queryParameters: {'month': month},
    );
    if (json['success'] == false) {
      throw ApiException.generic((json['message'] ?? 'generic_error').toString());
    }
    return AttendanceDashboardModel.fromJson(json);
  }

  /// POST /api/employee/attendance/check-in
  /// Body: qr_token, latitude, longitude only.
  Future<AttendanceActionResult> checkIn({
    required String qrToken,
    required double latitude,
    required double longitude,
  }) async {
    final json = await _client.post(
      ApiConstants.attendanceCheckIn,
      data: {
        'qr_token': qrToken,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
    if (json['success'] == false) {
      throw ApiException.generic((json['message'] ?? 'generic_error').toString());
    }
    return AttendanceActionResult.fromJson(json);
  }

  /// POST /api/employee/attendance/check-out
  /// Body: qr_token, latitude, longitude only.
  Future<AttendanceActionResult> checkOut({
    required String qrToken,
    required double latitude,
    required double longitude,
  }) async {
    final json = await _client.post(
      ApiConstants.attendanceCheckOut,
      data: {
        'qr_token': qrToken,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
    if (json['success'] == false) {
      throw ApiException.generic((json['message'] ?? 'generic_error').toString());
    }
    return AttendanceActionResult.fromJson(json);
  }
}
