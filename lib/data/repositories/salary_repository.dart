import '../../core/constants/api_constants.dart';
import '../../core/errors/api_exception.dart';
import '../../core/network/api_client.dart';
import '../models/salary_models.dart';

/// Salary slips & advances — live Backend only (no mock data).
class SalaryRepository {
  final ApiClient _client;

  SalaryRepository({ApiClient? client}) : _client = client ?? ApiClient.instance;

  /// GET /api/employee/advances/eligibility
  Future<AdvanceEligibilityModel> getEligibility() async {
    final json = await _client.get(ApiConstants.advancesEligibility);
    if (json['success'] == false) {
      throw ApiException.generic((json['message'] ?? 'generic_error').toString());
    }
    return AdvanceEligibilityModel.fromJson(json);
  }

  /// POST /api/employee/advances/apply
  Future<AdvanceApplyResult> applyForAdvance({
    required double requestedAmount,
    required int repaymentMonths,
    required String reason,
  }) async {
    final json = await _client.post(
      ApiConstants.advancesApply,
      data: {
        'requested_amount': requestedAmount,
        'repayment_months': repaymentMonths,
        'reason': reason,
      },
    );
    if (json['success'] == false) {
      throw ApiException.generic((json['message'] ?? 'generic_error').toString());
    }
    return AdvanceApplyResult.fromJson(json);
  }

  /// GET /api/employee/advances
  Future<PaginatedList<AdvanceRecordModel>> getAdvancesList() async {
    final json = await _client.get(ApiConstants.advancesList);
    if (json['success'] == false) {
      throw ApiException.generic((json['message'] ?? 'generic_error').toString());
    }
    final data = json['data'];
    if (data is Map) {
      return PaginatedList.fromJson(
        Map<String, dynamic>.from(data),
        AdvanceRecordModel.fromJson,
      );
    }
    return const PaginatedList(data: [], currentPage: 1, lastPage: 1, total: 0);
  }

  /// GET /api/employee/salaries?year=&per_page=
  Future<SalariesDashboardModel> getSalaries({int? year, int perPage = 12}) async {
    final json = await _client.get(
      ApiConstants.employeeSalaries,
      queryParameters: {
        'year': ?year,
        'per_page': perPage,
      },
    );
    if (json['success'] == false) {
      throw ApiException.generic((json['message'] ?? 'generic_error').toString());
    }
    return SalariesDashboardModel.fromJson(json);
  }

  /// GET /api/employee/salaries/{id}
  Future<SalaryDetailModel> getSalaryDetail(String id) async {
    final json = await _client.get(ApiConstants.employeeSalaryDetail(id));
    if (json['success'] == false) {
      throw ApiException.generic((json['message'] ?? 'generic_error').toString());
    }
    return SalaryDetailModel.fromJson(json);
  }
}
