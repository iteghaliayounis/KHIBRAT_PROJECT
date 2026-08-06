import 'package:khibrat_flutter2/core/errors/api_exception.dart';
import 'package:khibrat_flutter2/data/models/company_profile_model.dart';
import 'package:khibrat_flutter2/data/providers/company_provider.dart';

class CompanyRepository {
  final CompanyProvider _provider;

  CompanyRepository({CompanyProvider? provider})
      : _provider = provider ?? CompanyProvider();

  Future<CompanyProfileModel> getCompanyProfile() async {
    try {
      final resp = await _provider.getCompanyProfile();
      final success = resp['success'] == true;
      if (!success) {
        throw ApiException(
          message: resp['message']?.toString() ?? 'Failed to load company profile',
        );
      }
      final data = resp['data'];
      if (data is! Map<String, dynamic>) {
        throw ApiException(message: 'Invalid company profile response');
      }
      return CompanyProfileModel.fromJson(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.generic(e.toString());
    }
  }
}
