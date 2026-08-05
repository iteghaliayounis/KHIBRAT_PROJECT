import '../../data/models/overtime_model.dart';
import '../repositories/overtime_repository.dart';

class GetOvertimeRequestsUsecase {
  final OvertimeRepository repository;

  GetOvertimeRequestsUsecase(this.repository);

  Future<List<OvertimeModel>> call({int page = 1}) {
    return repository.getOvertimeRequests(page: page);
  }
}
