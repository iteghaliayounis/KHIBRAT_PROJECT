import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/overtime_model.dart';
import '../../data/models/overtime_preview_model.dart';
import '../../domain/usecases/apply_overtime_usecase.dart';
import '../../domain/usecases/get_overtime_preview_usecase.dart';
import '../../domain/usecases/get_overtime_requests_usecase.dart';

class OvertimeController extends GetxController {
  final GetOvertimePreviewUsecase getPreviewUsecase;
  final ApplyOvertimeUsecase applyUsecase;
  final GetOvertimeRequestsUsecase getRequestsUsecase;

  OvertimeController({
    required this.getPreviewUsecase,
    required this.applyUsecase,
    required this.getRequestsUsecase,
  });

  // ---------------- حقول الفورم ----------------
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  /// 'day' أو 'hour'
  final RxString durationType = 'day'.obs;

  /// عدد الساعات المطلوبة (يُستخدم فقط لما durationType == 'hour')
  final RxInt hoursCount = 1.obs;

  final TextEditingController reasonController = TextEditingController();

  // ---------------- كاردات المعاينة ----------------
  final Rx<OvertimePreviewModel?> dayPreview = Rx<OvertimePreviewModel?>(null);
  final Rx<OvertimePreviewModel?> hourPreview = Rx<OvertimePreviewModel?>(null);
  final RxBool isLoadingDayPreview = false.obs;
  final RxBool isLoadingHourPreview = false.obs;

  // ---------------- الإرسال ----------------
  final RxBool isSubmitting = false.obs;

  // ---------------- السجل ----------------
  final RxList<OvertimeModel> historyList = <OvertimeModel>[].obs;
  final RxBool isLoadingHistory = false.obs;

  static const int minHours = 1;
  static const int maxHours =
      12; // ⚠️ افتراض: أقصى عدد ساعات، عدّلها إذا في قيمة رسمية مختلفة

  @override
  void onInit() {
    super.onInit();
    fetchDayPreview();
    fetchHourPreview();
    fetchHistory();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  // ---------------- اختيار التاريخ ----------------
  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      // locale: const Locale('ar'),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  String get formattedDate {
    if (selectedDate.value == null) return '';
    return DateFormat('yyyy-MM-dd').format(selectedDate.value!);
  }

  // ---------------- نوع المدة ----------------
  void selectDurationType(String type) {
    if (durationType.value == type) return;
    durationType.value = type;
  }

  // ---------------- عداد الساعات ----------------
  void incrementHours() {
    if (hoursCount.value >= maxHours) return;
    hoursCount.value++;
    fetchHourPreview();
  }

  void decrementHours() {
    if (hoursCount.value <= minHours) return;
    hoursCount.value--;
    fetchHourPreview();
  }

  // ---------------- كارد الزيادة ليوم كامل (units ثابت = 1 دائماً) ----------------
  Future<void> fetchDayPreview() async {
    try {
      isLoadingDayPreview.value = true;
      dayPreview.value = await getPreviewUsecase.call(
        durationType: 'day',
        units: 1,
      );
    } catch (_) {
      // فشل جلب معاينة اليوم الكامل لا يوقف باقي الشاشة، بس منسيب الكارد فاضي
      dayPreview.value = null;
    } finally {
      isLoadingDayPreview.value = false;
    }
  }

  // ---------------- كارد الزيادة على الساعة (بيتحدث مع كل تغيير بالعداد) ----------------
  Future<void> fetchHourPreview() async {
    try {
      isLoadingHourPreview.value = true;
      hourPreview.value = await getPreviewUsecase.call(
        durationType: 'hour',
        units: hoursCount.value,
      );
    } catch (_) {
      hourPreview.value = null;
    } finally {
      isLoadingHourPreview.value = false;
    }
  }

  // ---------------- إرسال الطلب ----------------
  Future<void> submitRequest() async {
    if (selectedDate.value == null) {
      Get.snackbar('تنبيه', 'يرجى اختيار تاريخ العمل الإضافي المطلوب');
      return;
    }
    if (reasonController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'يرجى كتابة سبب الطلب');
      return;
    }

    final units = durationType.value == 'day' ? 1 : hoursCount.value;

    try {
      isSubmitting.value = true;
      final result = await applyUsecase.call(
        requestDate: formattedDate,
        durationType: durationType.value,
        units: units,
        reason: reasonController.text.trim(),
      );

      // إضافة الطلب الجديد لأعلى السجل مباشرة بدون انتظار إعادة تحميل كامل
      historyList.insert(0, result);

      Get.snackbar('تم الإرسال', 'تم إرسال طلب العمل الإضافي بنجاح');
      _resetForm();
    } on ApiException catch (e) {
      Get.snackbar('حدث خطأ', e.message);
    } catch (_) {
      Get.snackbar('حدث خطأ', 'تعذر إرسال الطلب، يرجى المحاولة لاحقاً');
    } finally {
      isSubmitting.value = false;
    }
  }

  void _resetForm() {
    selectedDate.value = null;
    durationType.value = 'day';
    hoursCount.value = 1;
    reasonController.clear();
  }

  // ---------------- سجل الطلبات السابقة ----------------
  Future<void> fetchHistory() async {
    try {
      isLoadingHistory.value = true;
      final list = await getRequestsUsecase.call();
      // ترتيب تنازلي حسب تاريخ الإنشاء (الأحدث بالأعلى)
      list.sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));
      historyList.assignAll(list);
    } catch (_) {
      // تجاهل الخطأ هون، ممكن نضيف حالة "تعذر تحميل السجل" بالواجهة لاحقاً
    } finally {
      isLoadingHistory.value = false;
    }
  }
}
