import 'package:get/get.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/company_profile_model.dart';
import '../../domain/usecases/get_company_profile_usecase.dart';

class CompanyInfoController extends GetxController {
  final GetCompanyProfileUseCase _getCompanyProfileUseCase;

  CompanyInfoController({GetCompanyProfileUseCase? getCompanyProfileUseCase})
      : _getCompanyProfileUseCase =
            getCompanyProfileUseCase ?? GetCompanyProfileUseCase();

  final RxBool isLoading = false.obs;
  final Rxn<CompanyProfileModel> profile = Rxn<CompanyProfileModel>();
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      profile.value = await _getCompanyProfileUseCase();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
