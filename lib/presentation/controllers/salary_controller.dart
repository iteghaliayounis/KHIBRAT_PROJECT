import 'package:get/get.dart';
import '../../core/errors/api_exception.dart';
import '../../data/models/salary_models.dart';
import '../../data/repositories/salary_repository.dart';
import '../widgets/app_feedback.dart';
import '../widgets/salary/advance_apply_sheet.dart';
import '../widgets/salary/salary_detail_sheet.dart';

enum SalaryTab { salaries, advances }

class SalaryController extends GetxController {
  final SalaryRepository _repository;

  SalaryController({SalaryRepository? repository})
      : _repository = repository ?? SalaryRepository();

  final Rx<SalaryTab> selectedTab = SalaryTab.salaries.obs;

  final RxBool isLoadingSalaries = true.obs;
  final RxBool isLoadingAdvances = true.obs;
  final RxBool isLoadingDetail = false.obs;
  final RxBool isSubmittingAdvance = false.obs;

  final RxnString salariesError = RxnString();
  final RxnString advancesError = RxnString();
  final RxnString advanceErrorMsg = RxnString();

  final Rxn<SalariesDashboardModel> salariesDashboard = Rxn<SalariesDashboardModel>();
  final Rxn<AdvanceEligibilityModel> eligibility = Rxn<AdvanceEligibilityModel>();
  final RxList<AdvanceRecordModel> advances = <AdvanceRecordModel>[].obs;
  final Rxn<SalaryDetailModel> currentDetail = Rxn<SalaryDetailModel>();

  // Advance form — empty defaults; limits come from eligibility API
  final RxDouble requestedAmount = 0.0.obs;
  final RxInt repaymentMonths = 1.obs;
  final RxString reason = ''.obs;

  double get calculatedInstallment {
    final months = repaymentMonths.value;
    if (months <= 0) return 0;
    return (requestedAmount.value / months).roundToDouble();
  }

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    await Future.wait([
      fetchSalaries(),
      fetchEligibility(),
      fetchAdvances(),
    ]);
  }

  void selectTab(SalaryTab tab) => selectedTab.value = tab;

  Future<void> fetchSalaries() async {
    isLoadingSalaries.value = true;
    salariesError.value = null;
    try {
      salariesDashboard.value = await _repository.getSalaries(year: DateTime.now().year);
    } on ApiException catch (e) {
      salariesError.value = e.message;
    } catch (_) {
      salariesError.value = 'generic_error';
    } finally {
      isLoadingSalaries.value = false;
    }
  }

  Future<void> fetchEligibility() async {
    try {
      eligibility.value = await _repository.getEligibility();
    } on ApiException catch (e) {
      AppFeedback.showError(e.message);
    } catch (_) {
      AppFeedback.showError('generic_error');
    }
  }

  Future<void> fetchAdvances() async {
    isLoadingAdvances.value = true;
    advancesError.value = null;
    try {
      final page = await _repository.getAdvancesList();
      advances.assignAll(page.data);
    } on ApiException catch (e) {
      advancesError.value = e.message;
    } catch (_) {
      advancesError.value = 'generic_error';
    } finally {
      isLoadingAdvances.value = false;
    }
  }

  Future<void> openSalaryDetails(String id) async {
    currentDetail.value = null;
    isLoadingDetail.value = true;
    SalaryDetailSheet.show(controller: this);
    try {
      currentDetail.value = await _repository.getSalaryDetail(id);
    } on ApiException catch (e) {
      AppFeedback.showError(e.message);
      Get.back();
    } catch (_) {
      AppFeedback.showError('generic_error');
      Get.back();
    } finally {
      isLoadingDetail.value = false;
    }
  }

  void openAdvanceRequestSheet() {
    advanceErrorMsg.value = null;
    final elig = eligibility.value;
    if (elig != null) {
      if (requestedAmount.value > elig.maxAllowedAmount) {
        requestedAmount.value = 0;
      }
      if (repaymentMonths.value < 1) {
        repaymentMonths.value = 1;
      }
      if (repaymentMonths.value > elig.maxRepaymentMonths) {
        repaymentMonths.value = elig.maxRepaymentMonths;
      }
    }
    AdvanceApplySheet.show(controller: this);
  }

  Future<void> submitAdvance() async {
    advanceErrorMsg.value = null;
    final amount = requestedAmount.value;
    final months = repaymentMonths.value;
    final why = reason.value.trim();

    if (amount <= 0 || months <= 0 || why.isEmpty) {
      advanceErrorMsg.value = 'salary_advance_form_invalid'.tr;
      return;
    }

    isSubmittingAdvance.value = true;
    try {
      final result = await _repository.applyForAdvance(
        requestedAmount: amount,
        repaymentMonths: months,
        reason: why,
      );
      Get.back();
      selectedTab.value = SalaryTab.advances;
      AppFeedback.showSuccess(
        result.message.isNotEmpty ? result.message : 'salary_advance_success',
      );
      // Refresh from Backend so UI reflects real eligibility + list
      await Future.wait([
        fetchEligibility(),
        fetchAdvances(),
      ]);
    } on ApiException catch (e) {
      if (e.statusCode == 422) {
        advanceErrorMsg.value = e.message;
      } else {
        AppFeedback.showError(e.message);
      }
    } catch (_) {
      AppFeedback.showError('generic_error');
    } finally {
      isSubmittingAdvance.value = false;
    }
  }
}
