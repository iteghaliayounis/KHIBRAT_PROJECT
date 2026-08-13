import 'package:khibrat_flutter2/data/models/company_holiday_model.dart';
import 'package:khibrat_flutter2/data/repositories/company_policies_repository.dart';

class GetCompanyHolidaysUseCase {
  final CompanyPoliciesRepository _repository;

  GetCompanyHolidaysUseCase({CompanyPoliciesRepository? repository})
      : _repository = repository ?? CompanyPoliciesRepository();

  Future<List<CompanyHolidayModel>> call() =>
      _repository.getCompanyHolidays();
}
