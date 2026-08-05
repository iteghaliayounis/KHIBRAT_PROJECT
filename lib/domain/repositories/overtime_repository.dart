import '../../data/models/overtime_preview_model.dart';
import '../../data/models/overtime_model.dart';

abstract class OvertimeRepository {
  Future<OvertimePreviewModel> previewOvertime({
    required String durationType,
    required int units,
  });

  Future<OvertimeModel> applyOvertime({
    required String requestDate,
    required String durationType,
    required int units,
    required String reason,
  });

  Future<List<OvertimeModel>> getOvertimeRequests({int page = 1});
}
