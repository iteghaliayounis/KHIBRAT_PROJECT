import '../../core/errors/api_exception.dart';
import '../../domain/repositories/leave_repository.dart';
import '../models/leave_dashboard_model.dart';
import '../models/leave_type_model.dart';
import '../providers/leave_provider.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveProvider _provider;

  LeaveRepositoryImpl({LeaveProvider? provider})
      : _provider = provider ?? LeaveProvider();

  @override
  Future<List<LeaveTypeModel>> getLeaveTypes() async {
    try {
      final resp = await _provider.getTypes();
      final data = resp['data'];
      if (data is! List) return [];
      return data
          .whereType<Map>()
          .map((e) => LeaveTypeModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  @override
  Future<LeaveDashboardModel> getDashboard() async {
    try {
      final resp = await _provider.getDashboard();
      final data = resp['data'];
      if (data is! Map) {
        throw ApiException.generic('generic_error');
      }
      return LeaveDashboardModel.fromJson(Map<String, dynamic>.from(data));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  @override
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
    try {
      return await _provider.applyLeave(
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
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }
}
