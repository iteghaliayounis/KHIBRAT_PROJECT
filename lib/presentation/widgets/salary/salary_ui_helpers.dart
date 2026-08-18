import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/salary_models.dart';

class SalaryUiHelpers {
  SalaryUiHelpers._();

  static const List<String> _monthsEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static const List<String> _monthsAr = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  static String monthName(int month, {bool? isArabic}) {
    final ar = isArabic ?? Get.locale?.languageCode == 'ar';
    if (month < 1 || month > 12) return '$month';
    return ar ? _monthsAr[month - 1] : _monthsEn[month - 1];
  }

  static String monthYearLabel(int month, int year) =>
      '${monthName(month)} $year';

  static String formatNumber(num? value) {
    if (value == null) return '0';
    final n = value.round();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }

  static String resolveCurrency(String? value) {
    final c = value?.trim();
    if (c == null || c.isEmpty) return 'SYP';
    return c.toUpperCase();
  }

  static String formatMoney(num? value, {String? currency}) =>
      '${formatNumber(value)} ${resolveCurrency(currency)}';

  static String currencyLabel(String? value) {
    final code = resolveCurrency(value);
    if (code == 'USD') return 'salary_currency_usd'.tr;
    if (code == 'SYP') return 'salary_currency_syp'.tr;
    return code;
  }

  static String formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    return raw.split(' ').first;
  }

  static String paymentSummaryKey(SalaryRecordModel record) {
    final summary = (record.paymentSummary ?? '').toLowerCase();
    if (summary == 'with_additions_and_deductions') {
      return 'salary_summary_full';
    }
    if (summary == 'with_deductions') {
      return 'salary_summary_deductions';
    }
    if (summary == 'with_additions') {
      return 'salary_summary_additions';
    }
    if (record.status == 'draft') return 'salary_summary_draft';
    return 'salary_summary_transferred';
  }

  static Color salaryStatusDot(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return AppColors.success;
      case 'draft':
        return const Color(0xFFF59E0B);
      default:
        return AppColors.textSecondary;
    }
  }

  static String normalizeAdvanceStatus(String status) {
    return status.trim().toLowerCase().replaceAll('-', '_');
  }

  static String advanceStatusLabelKey(String status) {
    switch (normalizeAdvanceStatus(status)) {
      case 'pending_department_manager':
        return 'advance_status_pending_manager';
      case 'pending_hr':
        return 'advance_status_pending_hr';
      case 'approved':
        return 'advance_status_approved';
      case 'rejected_by_manager':
        return 'advance_status_rejected_by_manager';
      case 'rejected_by_hr':
        return 'advance_status_rejected_by_hr';
      case 'paid_off':
        return 'advance_status_paid_off';
      default:
        return 'advance_status_unknown';
    }
  }

  static String advanceStatusLabel(String status) {
    return advanceStatusLabelKey(status).tr;
  }

  static Color advanceStatusBg(String status) {
    switch (normalizeAdvanceStatus(status)) {
      case 'pending_department_manager':
      case 'pending_hr':
        return const Color(0xFFFEF3C7);
      case 'approved':
        return const Color(0xFFD1FAE5);
      case 'rejected_by_manager':
      case 'rejected_by_hr':
        return const Color(0xFFFFE4E6);
      case 'paid_off':
        return const Color(0xFFE0E7FF);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  static Color advanceStatusFg(String status) {
    switch (normalizeAdvanceStatus(status)) {
      case 'pending_department_manager':
      case 'pending_hr':
        return const Color(0xFF78350F);
      case 'approved':
        return const Color(0xFF065F46);
      case 'rejected_by_manager':
      case 'rejected_by_hr':
        return const Color(0xFF9F1239);
      case 'paid_off':
        return const Color(0xFF3730A3);
      default:
        return const Color(0xFF334155);
    }
  }

  /// Maps Backend line-item `type` to a localized label; falls back to API label.
  static String lineItemLabel(String type, String fallbackLabel) {
    final key = switch (type.toLowerCase().trim()) {
      'overtime' || 'overtime_amount' => 'salary_line_overtime',
      'bonus' || 'bonus_amount' => 'salary_line_bonus',
      'manual_bonus' => 'salary_line_manual_bonus',
      'late' || 'lateness' || 'late_deduction' => 'salary_line_late',
      'advance' || 'loan' || 'advance_installment' || 'loan_deduction' =>
        'salary_line_advance',
      'absence' || 'absent_deduction' => 'salary_line_absence',
      'manual_deduction' => 'salary_line_manual_deduction',
      'transportation' => 'salary_line_transportation',
      'incentives' => 'salary_line_incentives',
      'social_security' => 'salary_line_social_security',
      _ => null,
    };
    if (key == null) {
      return fallbackLabel.isNotEmpty ? fallbackLabel : type;
    }
    return key.tr;
  }
}
