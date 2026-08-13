import 'package:khibrat_flutter2/core/errors/api_exception.dart';
import 'package:khibrat_flutter2/data/models/company_holiday_model.dart';
import 'package:khibrat_flutter2/data/models/company_policies_model.dart';
import 'package:khibrat_flutter2/data/providers/company_policies_provider.dart';

class CompanyPoliciesRepository {
  final CompanyPoliciesProvider _provider;

  CompanyPoliciesRepository({CompanyPoliciesProvider? provider})
      : _provider = provider ?? CompanyPoliciesProvider();

  Future<CompanyPoliciesModel> getCompanyPolicies() async {
    try {
      final resp = await _provider.getCompanyPolicies();
      if (resp['success'] != true) {
        throw ApiException(
          message: resp['message']?.toString() ??
              'Failed to load company policies',
        );
      }
      final data = resp['data'];
      if (data is! Map<String, dynamic>) {
        throw ApiException(message: 'Invalid company policies response');
      }
      return CompanyPoliciesModel.fromJson(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }

  Future<List<CompanyHolidayModel>> getCompanyHolidays() async {
    try {
      final resp = await _provider.getCompanyHolidays();
      if (resp['success'] != true) {
        throw ApiException(
          message: resp['message']?.toString() ??
              'Failed to load company holidays',
        );
      }
      final data = resp['data'];
      if (data is! List) {
        throw ApiException(message: 'Invalid company holidays response');
      }
      return data
          .whereType<Map>()
          .map((e) => CompanyHolidayModel.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }
}
