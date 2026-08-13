import 'package:khibrat_flutter2/core/constants/api_constants.dart';
import 'package:khibrat_flutter2/core/network/api_client.dart';

class CompanyPoliciesProvider {
  final ApiClient _client = ApiClient.instance;

  Future<Map<String, dynamic>> getCompanyPolicies() {
    return _client.get(ApiConstants.companyPolicies);
  }

  Future<Map<String, dynamic>> getCompanyHolidays() {
    return _client.get(ApiConstants.companyHolidays);
  }
}
