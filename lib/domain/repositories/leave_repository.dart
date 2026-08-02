import '../../data/models/leave_dashboard_model.dart';
import '../../data/models/leave_type_model.dart';

abstract class LeaveRepository {
  Future<List<LeaveTypeModel>> getLeaveTypes();

  Future<LeaveDashboardModel> getDashboard();

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
  });
}
