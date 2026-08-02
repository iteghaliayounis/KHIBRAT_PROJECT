import '../repositories/leave_repository.dart';

class ApplyLeaveUseCase {
  final LeaveRepository _repository;
  ApplyLeaveUseCase(this._repository);

  Future<Map<String, dynamic>> call({
    required String leaveTypeId,
    required String durationType,
    required String startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    String? reason,
    String? attachmentPath,
    String? attachmentFileName,
  }) {
    return _repository.applyLeave(
      leaveTypeId: leaveTypeId,
      durationType: durationType,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      reason: reason,
      attachmentPath: attachmentPath,
      attachmentFileName: attachmentFileName,
    );
  }
}
