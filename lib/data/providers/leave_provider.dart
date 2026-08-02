import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client_fixed.dart';

/// Raw HTTP calls for employee leave endpoints.
class LeaveProvider {
  final ApiClientFixed _client = ApiClientFixed.instance;

  Future<Map<String, dynamic>> getTypes() {
    return _client.get(ApiConstants.leaveTypes);
  }

  Future<Map<String, dynamic>> getDashboard() {
    return _client.get(ApiConstants.leaveDashboard);
  }

  Future<Map<String, dynamic>> applyLeave({
    required String leaveTypeId,
    required String durationType,
    required String startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    String? reason,
    String? attachmentPath,
    String? attachmentFileName,
  }) async {
    final map = <String, dynamic>{
      'leave_type_id': leaveTypeId,
      'duration_type': durationType,
      'start_date': startDate,
    };

    if (endDate != null && endDate.isNotEmpty) {
      map['end_date'] = endDate;
    }
    if (startTime != null && startTime.isNotEmpty) {
      map['start_time'] = startTime;
    }
    if (endTime != null && endTime.isNotEmpty) {
      map['end_time'] = endTime;
    }
    if (reason != null && reason.isNotEmpty) {
      map['reason'] = reason;
    }
    if (attachmentPath != null && attachmentPath.isNotEmpty) {
      map['attachment'] = await MultipartFile.fromFile(
        attachmentPath,
        filename: attachmentFileName ?? attachmentPath.split(RegExp(r'[\\/]')).last,
      );
    }

    final formData = FormData.fromMap(map);
    return _client.postMultipart(ApiConstants.leaveApply, formData: formData);
  }
}
