import 'package:flutter/foundation.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/api_exception.dart';
import '../../core/network/api_client.dart';
import '../models/salary_models.dart';

/// Salary slips & advances — live Backend only (no mock data).
class SalaryRepository {
  final ApiClient _client;

  SalaryRepository({ApiClient? client}) : _client = client ?? ApiClient.instance;

  void _log(String title, Object? body) {
    debugPrint('========== $title ==========');
    debugPrint('$body');
  }

  /// GET /api/employee/advances/eligibility
  Future<AdvanceEligibilityModel> getEligibility() async {
    final json = await _client.get(ApiConstants.advancesEligibility);
    _log('ADVANCES ELIGIBILITY RESPONSE', json);
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
    final payload = {
      'requested_amount': requestedAmount,
      'repayment_months': repaymentMonths,
      'reason': reason,
    };
    _log('ADVANCE APPLY REQUEST', payload);
    try {
      final json = await _client.post(
        ApiConstants.advancesApply,
        data: payload,
      );
      _log('ADVANCE APPLY RESPONSE', json);
      if (json['success'] == false) {
        throw ApiException.generic((json['message'] ?? 'generic_error').toString());
      }
      return AdvanceApplyResult.fromJson(json);
    } catch (e) {
      _log('ADVANCE APPLY ERROR', e);
      rethrow;
    }
  }

  /// GET /api/employee/advances
  Future<PaginatedList<AdvanceRecordModel>> getAdvancesList() async {
    final json = await _client.get(ApiConstants.advancesList);
    _log('ADVANCES LIST RESPONSE', json);
    if (json['success'] == false) {
      throw ApiException.generic((json['message'] ?? 'generic_error').toString());
    }
    final data = json['data'];
    final fallbackCurrency =
        (json['currency'] ?? (data is Map ? data['currency'] : null))?.toString();
    if (data is Map) {
      final inner = data['data'];
      if (inner is List) {
        for (final item in inner) {
          if (item is Map) {
            debugPrint(
              'ADVANCE RAW STATUS id=${item['id']} status=${item['status']} type=${item['status'].runtimeType}',
            );
          }
        }
      }
      final page = PaginatedList.fromJson(
        Map<String, dynamic>.from(data),
        (item) => AdvanceRecordModel.fromJson(
          item,
          fallbackCurrency: fallbackCurrency,
        ),
      );
      return page;
    }
    if (data is List) {
      return PaginatedList(
        data: data
            .whereType<Map>()
            .map(
              (e) => AdvanceRecordModel.fromJson(
                Map<String, dynamic>.from(e),
                fallbackCurrency: fallbackCurrency,
              ),
            )
            .toList(),
        currentPage: 1,
        lastPage: 1,
        total: data.length,
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
    _log('SALARIES LIST RESPONSE', json);
    if (json['success'] == false) {
      throw ApiException.generic((json['message'] ?? 'generic_error').toString());
    }
    return SalariesDashboardModel.fromJson(json);
  }

  /// GET /api/employee/salaries/{id}
  Future<SalaryDetailModel> getSalaryDetail(String id) async {
    final json = await _client.get(ApiConstants.employeeSalaryDetail(id));
    _log('SALARY DETAIL RESPONSE', json);
    if (json['success'] == false) {
      throw ApiException.generic((json['message'] ?? 'generic_error').toString());
    }
    return SalaryDetailModel.fromJson(json);
  }
}
