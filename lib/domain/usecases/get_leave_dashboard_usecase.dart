import '../../data/models/leave_dashboard_model.dart';
import '../repositories/leave_repository.dart';

class GetLeaveDashboardUseCase {
  final LeaveRepository _repository;
  GetLeaveDashboardUseCase(this._repository);

  Future<LeaveDashboardModel> call() => _repository.getDashboard();
}
