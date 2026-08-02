import '../../data/models/leave_type_model.dart';
import '../repositories/leave_repository.dart';

class GetLeaveTypesUseCase {
  final LeaveRepository _repository;
  GetLeaveTypesUseCase(this._repository);

  Future<List<LeaveTypeModel>> call() => _repository.getLeaveTypes();
}
