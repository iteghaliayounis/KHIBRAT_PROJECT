import 'package:khibrat_flutter2/core/constants/api_constants.dart';
import 'package:khibrat_flutter2/core/network/api_client.dart';

class CompanyProvider {
  final ApiClient _client = ApiClient.instance;

  Future<Map<String, dynamic>> getCompanyProfile() {
    return _client.get(ApiConstants.companyProfile);
  }
}
