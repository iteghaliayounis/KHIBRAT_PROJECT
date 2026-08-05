import '../../data/models/overtime_preview_model.dart';
import '../repositories/overtime_repository.dart';

class GetOvertimePreviewUsecase {
  final OvertimeRepository repository;

  GetOvertimePreviewUsecase(this.repository);

  Future<OvertimePreviewModel> call({
    required String durationType,
    required int units,
  }) {
    return repository.previewOvertime(
      durationType: durationType,
      units: units,
    );
  }
}
