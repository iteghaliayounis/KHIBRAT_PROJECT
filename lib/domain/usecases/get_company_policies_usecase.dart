import 'package:khibrat_flutter2/data/models/company_policies_model.dart';
import 'package:khibrat_flutter2/data/repositories/company_policies_repository.dart';

class GetCompanyPoliciesUseCase {
  final CompanyPoliciesRepository _repository;

  GetCompanyPoliciesUseCase({CompanyPoliciesRepository? repository})
      : _repository = repository ?? CompanyPoliciesRepository();

  Future<CompanyPoliciesModel> call() => _repository.getCompanyPolicies();
}
