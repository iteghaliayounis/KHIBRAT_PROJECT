import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

/// نداءات ApiClient الحقيقية (Map<String, dynamic> جاهزة، بدون Response).
class OvertimeProvider {
  final ApiClient _apiClient = ApiClient.instance;

  /// GET /api/employee/overtime/preview
  Future<Map<String, dynamic>> previewOvertime({
    required String durationType, // 'hour' | 'day'
    required int units,
  }) {
    return _apiClient.get(
      ApiConstants.overtimePreview,
      queryParameters: {
        'duration_type': durationType,
        'units': units,
      },
    );
  }

  /// POST /api/employee/overtime/apply
  Future<Map<String, dynamic>> applyOvertime({
    required String requestDate, // yyyy-MM-dd
    required String durationType, // 'hour' | 'day'
    required int units, // دائماً 1 لما durationType == 'day'
    required String reason,
  }) {
    return _apiClient.post(
      ApiConstants.overtimeApply,
      data: {
        'request_date': requestDate,
        'duration_type': durationType,
        'units': units,
        'reason': reason,
      },
    );
  }

  /// GET /api/employee/overtime
  Future<Map<String, dynamic>> getOvertimeRequests({int page = 1}) {
    return _apiClient.get(
      ApiConstants.overtimeList,
      queryParameters: {'page': page},
    );
  }
}
