import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/company_holiday_model.dart';
import '../../data/models/company_policies_model.dart';
import '../../domain/usecases/get_company_holidays_usecase.dart';
import '../../domain/usecases/get_company_policies_usecase.dart';

class CompanyPoliciesController extends GetxController {
  final GetCompanyPoliciesUseCase _getPolicies;
  final GetCompanyHolidaysUseCase _getHolidays;

  CompanyPoliciesController({
    GetCompanyPoliciesUseCase? getPolicies,
    GetCompanyHolidaysUseCase? getHolidays,
  })  : _getPolicies = getPolicies ?? GetCompanyPoliciesUseCase(),
        _getHolidays = getHolidays ?? GetCompanyHolidaysUseCase();

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final Rxn<CompanyPoliciesModel> policies = Rxn<CompanyPoliciesModel>();
  final RxList<CompanyHolidayModel> holidays = <CompanyHolidayModel>[].obs;

  /// Displayed calendar month (day = 1).
  final Rx<DateTime> focusedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final results = await Future.wait([
        _getPolicies(),
        _getHolidays(),
      ]);
      policies.value = results[0] as CompanyPoliciesModel;
      holidays.assignAll(results[1] as List<CompanyHolidayModel>);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void previousMonth() {
    final m = focusedMonth.value;
    focusedMonth.value = DateTime(m.year, m.month - 1);
  }

  void nextMonth() {
    final m = focusedMonth.value;
    focusedMonth.value = DateTime(m.year, m.month + 1);
  }

  /// Featured leave: Paid Free Days if present, else highest day-allocation.
  LeavePolicyItemModel? get featuredLeave {
    final list = policies.value?.leavePolicies ?? const [];
    if (list.isEmpty) return null;
    final paid = list.where((e) {
      final n = e.name.toLowerCase();
      return n.contains('paid free') ||
          n.contains('free days') ||
          n.contains('annual');
    });
    if (paid.isNotEmpty) return paid.first;
    final daysOnly = list.where((e) => !e.isHourly).toList();
    if (daysOnly.isEmpty) return list.first;
    daysOnly.sort((a, b) => b.allocationValue.compareTo(a.allocationValue));
    return daysOnly.first;
  }

  List<LeavePolicyItemModel> get gridLeaves {
    final list = policies.value?.leavePolicies ?? const [];
    final featured = featuredLeave;
    if (featured == null) return list;
    return list.where((e) => e.id != featured.id).toList();
  }

  List<CompanyHolidayModel> get weeklyHolidays =>
      holidays.where((h) => h.isWeeklyHoliday && h.weekday != null).toList();

  List<int> get weeklyWeekdays => weeklyHolidays
      .map((h) => h.weekday!)
      .toSet()
      .toList()
    ..sort();

  bool isWeeklyHoliday(DateTime day) => weeklyWeekdays.contains(day.weekday);

  CompanyHolidayModel? weeklyHolidayFor(DateTime day) {
    for (final h in weeklyHolidays) {
      if (h.weekday == day.weekday) return h;
    }
    return null;
  }

  CompanyHolidayModel? officialHolidayFor(DateTime day) {
    for (final h in holidays) {
      if (!h.isWeeklyHoliday && h.coversDay(day)) return h;
    }
    return null;
  }

  String weeklyLegendDaysLabel() {
    const order = [
      DateTime.sunday,
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
    ];
    const keys = {
      DateTime.sunday: 'weekday_sunday',
      DateTime.monday: 'weekday_monday',
      DateTime.tuesday: 'weekday_tuesday',
      DateTime.wednesday: 'weekday_wednesday',
      DateTime.thursday: 'weekday_thursday',
      DateTime.friday: 'weekday_friday',
      DateTime.saturday: 'weekday_saturday',
    };
    final names = <String>[];
    for (final weekday in order) {
      if (weeklyWeekdays.contains(weekday)) {
        names.add(keys[weekday]!.tr);
      }
    }
    return names.join('/');
  }

  int get quarter {
    final m = focusedMonth.value.month;
    return ((m - 1) ~/ 3) + 1;
  }

  String monthTitle(String locale) {
    final m = focusedMonth.value;
    return DateFormat.yMMMM(locale).format(m);
  }

  /// Formats "08:00:00" -> "AM 08:00" / "17:00:00" -> "PM 05:00"
  static String formatWorkTime(String raw) {
    final parts = raw.split(':');
    if (parts.length < 2) return raw;
    var hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1].padLeft(2, '0');
    final isPm = hour >= 12;
    final period = isPm ? 'PM' : 'AM';
    var displayHour = hour % 12;
    if (displayHour == 0) displayHour = 12;
    return '$period ${displayHour.toString().padLeft(2, '0')}:$minute';
  }
}
