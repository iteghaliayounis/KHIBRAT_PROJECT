import 'package:khibrat_flutter2/data/models/company_profile_model.dart';
import 'package:khibrat_flutter2/data/repositories/company_repository.dart';

class GetCompanyProfileUseCase {
  final CompanyRepository _repository;

  GetCompanyProfileUseCase({CompanyRepository? repository})
      : _repository = repository ?? CompanyRepository();

  Future<CompanyProfileModel> call() => _repository.getCompanyProfile();
}
