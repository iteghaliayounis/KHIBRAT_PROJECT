import 'package:get/get.dart';

import '../../core/errors/api_exception.dart';
import '../../core/utils/storage_service.dart';
import '../../data/models/leave_dashboard_model.dart';
import '../../domain/usecases/get_leave_dashboard_usecase.dart';
import '../widgets/app_feedback.dart';

class LeaveDashboardController extends GetxController {
  final GetLeaveDashboardUseCase _getDashboard;

  LeaveDashboardController(this._getDashboard);

  final RxBool isLoading = false.obs;
  final Rxn<LeaveDashboardModel> dashboard = Rxn<LeaveDashboardModel>();

  String get userInitial {
    final name = StorageService.instance.user?['full_name']?.toString() ??
        StorageService.instance.user?['name']?.toString() ??
        '';
    if (name.isEmpty) return 'خ';
    return String.fromCharCodes(name.trim().runes.take(1));
  }

  String get userName {
    return StorageService.instance.user?['full_name']?.toString() ??
        StorageService.instance.user?['name']?.toString() ??
        '';
  }

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      dashboard.value = await _getDashboard();
    } on ApiException catch (e) {
      AppFeedback.showError(e.message);
    } catch (e) {
      AppFeedback.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
