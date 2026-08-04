import 'package:get/get.dart';
import '../../core/errors/api_exception.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/attendance_models.dart';
import '../../data/repositories/attendance_repository.dart';
import '../widgets/app_feedback.dart';
import '../widgets/attendance/attendance_action_sheet.dart';
import '../widgets/attendance/attendance_ui_helpers.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository _repository;

  AttendanceController({AttendanceRepository? repository})
      : _repository = repository ?? AttendanceRepository();

  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final RxnString errorMessage = RxnString();

  /// Selected month as DateTime (day ignored; year+month drive the query).
  final Rx<DateTime> selectedMonth = DateTime.now().obs;

  final Rxn<AttendanceDashboardModel> dashboard = Rxn<AttendanceDashboardModel>();

  String get monthQuery => AttendanceUiHelpers.monthQuery(selectedMonth.value);

  AttendanceRecordModel? get activeCheckIn => dashboard.value?.activeCheckIn;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    selectedMonth.value = DateTime(now.year, now.month);
    fetchDashboard();
  }

  Future<void> fetchDashboard({bool silent = false}) async {
    if (silent) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    errorMessage.value = null;
    try {
      final result = await _repository.getDashboard(month: monthQuery);
      dashboard.value = result;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      if (silent) AppFeedback.showError(e.message);
    } catch (_) {
      errorMessage.value = 'generic_error';
      if (silent) AppFeedback.showError('generic_error');
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  @override
  Future<void> refresh() => fetchDashboard(silent: true);

  void previousMonth() {
    final m = selectedMonth.value;
    selectedMonth.value = DateTime(m.year, m.month - 1);
    fetchDashboard();
  }

  void nextMonth() {
    final m = selectedMonth.value;
    selectedMonth.value = DateTime(m.year, m.month + 1);
    fetchDashboard();
  }

  void selectMonth(DateTime month) {
    selectedMonth.value = DateTime(month.year, month.month);
    fetchDashboard();
  }

  void openActionSheet() {
    AttendanceActionSheet.show(
      onCheckIn: () => _openScanner(AttendanceScanMode.checkIn),
      onCheckOut: () => _openScanner(AttendanceScanMode.checkOut),
    );
  }

  Future<void> _openScanner(AttendanceScanMode mode) async {
    final result = await Get.toNamed(
      AppRoutes.attendanceScanner,
      arguments: {'mode': mode.name},
    );
    if (result == true) {
      await fetchDashboard(silent: true);
    }
  }
}

enum AttendanceScanMode { checkIn, checkOut }
