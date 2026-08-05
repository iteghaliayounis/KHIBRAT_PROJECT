import '../../data/models/overtime_model.dart';
import '../repositories/overtime_repository.dart';

class ApplyOvertimeUsecase {
  final OvertimeRepository repository;

  ApplyOvertimeUsecase(this.repository);

  Future<OvertimeModel> call({
    required String requestDate,
    required String durationType,
    required int units,
    required String reason,
  }) {
    return repository.applyOvertime(
      requestDate: requestDate,
      durationType: durationType,
      units: units,
      reason: reason,
    );
  }
}
