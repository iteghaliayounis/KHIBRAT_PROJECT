import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../../core/errors/api_exception.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/leave_type_model.dart';
import '../../domain/usecases/apply_leave_usecase.dart';
import '../../domain/usecases/get_leave_types_usecase.dart';
import '../widgets/app_feedback.dart';

/// UI duration options. Mapped to API `duration_type` on submit.
enum LeaveDurationUi { singleDay, multipleDays, hourly }

class ApplyLeaveController extends GetxController {
  final GetLeaveTypesUseCase _getLeaveTypes;
  final ApplyLeaveUseCase _applyLeave;

  ApplyLeaveController(this._getLeaveTypes, this._applyLeave);

  final reasonController = TextEditingController();

  final RxBool isLoadingTypes = false.obs;
  final RxBool isSubmitting = false.obs;

  final RxList<LeaveTypeModel> leaveTypes = <LeaveTypeModel>[].obs;
  final Rxn<LeaveTypeModel> selectedType = Rxn<LeaveTypeModel>();
  final Rxn<LeaveDurationUi> selectedDuration = Rxn<LeaveDurationUi>();

  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> startTime = Rxn<TimeOfDay>();
  final Rxn<TimeOfDay> endTime = Rxn<TimeOfDay>();

  final RxnString attachmentPath = RxnString();
  final RxnString attachmentName = RxnString();

  /// Duration chips based on leave type `allocation_unit` from company policy.
  /// hours → ساعية فقط | days → يوم واحد / أكثر من يوم
  List<LeaveDurationUi> get availableDurations {
    final type = selectedType.value;
    if (type == null) {
      return const [LeaveDurationUi.singleDay, LeaveDurationUi.multipleDays];
    }
    if (type.isHourly) {
      return const [LeaveDurationUi.hourly];
    }
    return const [LeaveDurationUi.singleDay, LeaveDurationUi.multipleDays];
  }

  bool get requiresProof => selectedType.value?.requiresProof ?? false;

  @override
  void onInit() {
    super.onInit();
    loadLeaveTypes();
  }

  Future<void> loadLeaveTypes() async {
    isLoadingTypes.value = true;
    try {
      final types = await _getLeaveTypes();
      // إزالة التكرار الظاهر من الـ API (سجلات مكررة بنفس الاسم في سياسات الشركة)
      final unique = <String, LeaveTypeModel>{};
      for (final type in types) {
        final key = type.name.trim().toLowerCase();
        unique.putIfAbsent(key, () => type);
      }
      leaveTypes.assignAll(unique.values.toList());
    } on ApiException catch (e) {
      AppFeedback.showError(e.message);
    } catch (e) {
      AppFeedback.showError(e.toString());
    } finally {
      isLoadingTypes.value = false;
    }
  }

  void selectLeaveType(LeaveTypeModel? type) {
    selectedType.value = type;
    final options = availableDurations;
    if (selectedDuration.value == null ||
        !options.contains(selectedDuration.value)) {
      selectedDuration.value = options.isNotEmpty ? options.first : null;
    }
    // Reset fields that may no longer apply
    if (selectedDuration.value != LeaveDurationUi.multipleDays) {
      endDate.value = null;
    }
    if (selectedDuration.value != LeaveDurationUi.hourly) {
      startTime.value = null;
      endTime.value = null;
    }
  }

  void selectDuration(LeaveDurationUi duration) {
    selectedDuration.value = duration;
    if (duration != LeaveDurationUi.multipleDays) {
      endDate.value = null;
    }
    if (duration != LeaveDurationUi.hourly) {
      startTime.value = null;
      endTime.value = null;
    }
  }

  void setStartDate(DateTime date) {
    startDate.value = date;
    final end = endDate.value;
    if (end != null && end.isBefore(date)) {
      endDate.value = null;
    }
  }

  Future<void> pickAttachment() async {
    // file_picker 11.x: pickFiles is static (no FilePicker.platform)
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg'],
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.size > 5 * 1024 * 1024) {
      AppFeedback.showError('leave_attachment_too_large');
      return;
    }
    if (file.path == null || file.path!.isEmpty) {
      AppFeedback.showError('generic_error');
      return;
    }
    attachmentPath.value = file.path;
    attachmentName.value = file.name;
  }

  void clearAttachment() {
    attachmentPath.value = null;
    attachmentName.value = null;
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Maps UI duration to API `duration_type` (single_day | multiple_days).
  String _apiDurationType(LeaveDurationUi ui) {
    switch (ui) {
      case LeaveDurationUi.multipleDays:
        return 'multiple_days';
      case LeaveDurationUi.singleDay:
      case LeaveDurationUi.hourly:
        return 'single_day';
    }
  }

  bool _validate() {
    if (selectedType.value == null) {
      AppFeedback.showError('leave_type_required');
      return false;
    }
    if (selectedDuration.value == null) {
      AppFeedback.showError('leave_duration_required');
      return false;
    }
    if (startDate.value == null) {
      AppFeedback.showError('leave_start_date_required');
      return false;
    }

    final duration = selectedDuration.value!;
    if (duration == LeaveDurationUi.multipleDays) {
      if (endDate.value == null) {
        AppFeedback.showError('leave_end_date_required');
        return false;
      }
      if (endDate.value!.isBefore(startDate.value!)) {
        AppFeedback.showError('leave_end_before_start');
        return false;
      }
    }

    if (duration == LeaveDurationUi.hourly) {
      if (startTime.value == null || endTime.value == null) {
        AppFeedback.showError('leave_time_required');
        return false;
      }
    }

    if (requiresProof &&
        (attachmentPath.value == null || attachmentPath.value!.isEmpty)) {
      AppFeedback.showError('leave_attachment_required');
      return false;
    }

    return true;
  }

  Future<void> submit() async {
    if (!_validate()) return;

    isSubmitting.value = true;
    try {
      final duration = selectedDuration.value!;
      await _applyLeave(
        leaveTypeId: selectedType.value!.id,
        durationType: _apiDurationType(duration),
        startDate: _formatDate(startDate.value!),
        endDate: duration == LeaveDurationUi.multipleDays
            ? _formatDate(endDate.value!)
            : null,
        startTime: duration == LeaveDurationUi.hourly
            ? _formatTime(startTime.value!)
            : null,
        endTime: duration == LeaveDurationUi.hourly
            ? _formatTime(endTime.value!)
            : null,
        reason: reasonController.text.trim().isEmpty
            ? null
            : reasonController.text.trim(),
        attachmentPath: attachmentPath.value,
        attachmentFileName: attachmentName.value,
      );

      AppFeedback.showSuccess('leave_apply_success');
      Get.offNamedUntil(
        AppRoutes.leaveDashboard,
        (route) => route.settings.name == AppRoutes.home,
      );
    } on ApiException catch (e) {
      AppFeedback.showError(e.message);
    } catch (e) {
      AppFeedback.showError(e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
