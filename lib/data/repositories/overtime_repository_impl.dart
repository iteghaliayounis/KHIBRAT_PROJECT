import '../../core/errors/api_exception.dart';
import '../../domain/repositories/overtime_repository.dart';
import '../models/overtime_preview_model.dart';
import '../models/overtime_model.dart';
import '../providers/overtime_provider.dart';

/// ملاحظة: ApiClientFixed بيرمي ApiException تلقائياً لأي خطأ HTTP
/// (401/403/422/429/network/...)، فهون بس لازم نتعامل مع حالة
/// "الطلب نجح (200) بس success == false جوا الـ body".
class OvertimeRepositoryImpl implements OvertimeRepository {
  final OvertimeProvider _provider;

  OvertimeRepositoryImpl(this._provider);

  @override
  Future<OvertimePreviewModel> previewOvertime({
    required String durationType,
    required int units,
  }) async {
    final body = await _provider.previewOvertime(
      durationType: durationType,
      units: units,
    );

    if (body['success'] == true && body['data'] != null) {
      return OvertimePreviewModel.fromJson(
        body['data'] as Map<String, dynamic>,
      );
    }
    throw ApiException.generic(
      body['message']?.toString() ?? 'تعذر جلب مقدار الزيادة',
    );
  }

  @override
  Future<OvertimeModel> applyOvertime({
    required String requestDate,
    required String durationType,
    required int units,
    required String reason,
  }) async {
    final body = await _provider.applyOvertime(
      requestDate: requestDate,
      durationType: durationType,
      units: units,
      reason: reason,
    );

    if (body['success'] == true && body['data'] != null) {
      return OvertimeModel.fromJson(body['data'] as Map<String, dynamic>);
    }
    throw ApiException.generic(
      body['message']?.toString() ?? 'تعذر إرسال طلب العمل الإضافي',
    );
  }

  @override
  Future<List<OvertimeModel>> getOvertimeRequests({int page = 1}) async {
    final body = await _provider.getOvertimeRequests(page: page);

    if (body['success'] == true && body['data'] != null) {
      final List list = (body['data']['data'] as List?) ?? [];
      return list
          .map((e) => OvertimeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw ApiException.generic(
      body['message']?.toString() ?? 'تعذر جلب سجل طلبات العمل الإضافي',
    );
  }
}
