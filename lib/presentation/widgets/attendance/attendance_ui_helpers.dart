import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Presentational helpers for Attendance — format API values for display only.
class AttendanceUiHelpers {
  AttendanceUiHelpers._();

  static const String emptyValue = '—';

  static const List<String> _monthsEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static const List<String> _monthsAr = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  /// Formats `YYYY-MM` as "August 2026" / "أغسطس 2026".
  static String formatMonthLabel(String yyyyMm, {required bool isArabic}) {
    final parts = yyyyMm.split('-');
    if (parts.length < 2) return yyyyMm;
    final year = parts[0];
    final month = int.tryParse(parts[1]) ?? 0;
    if (month < 1 || month > 12) return yyyyMm;
    final name = isArabic ? _monthsAr[month - 1] : _monthsEn[month - 1];
    return '$name $year';
  }

  /// `YYYY-MM-DD` → display date, or [emptyValue].
  static String formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return emptyValue;
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
  }

  /// `YYYY-MM-DD HH:mm:ss` → `HH:mm`, or [emptyValue].
  static String formatTime(String? raw) {
    if (raw == null || raw.isEmpty) return emptyValue;
    final normalized = raw.contains('T') ? raw : raw.replaceFirst(' ', 'T');
    final parsed = DateTime.tryParse(normalized);
    if (parsed == null) {
      // Fallback: take HH:mm from the string if present.
      final match = RegExp(r'(\d{2}):(\d{2})').firstMatch(raw);
      if (match != null) return '${match.group(1)}:${match.group(2)}';
      return raw;
    }
    return '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
  }

  static String formatMinutes(int? minutes) {
    if (minutes == null) return emptyValue;
    return '$minutes';
  }

  static String formatWorkHours(double hours) {
    if (hours == hours.roundToDouble()) return '${hours.toInt()}';
    return hours.toStringAsFixed(1);
  }

  /// Safe label for any backend status (known or future).
  static String statusLabelKey(String status) {
    switch (status.toLowerCase()) {
      case 'checked_in':
        return 'attendance_status_checked_in';
      case 'completed':
        return 'attendance_status_completed';
      default:
        return 'attendance_status_unknown';
    }
  }

  static String typeLabelKey(String type) {
    switch (type.toLowerCase()) {
      case 'present':
        return 'attendance_type_present';
      case 'absent':
        return 'attendance_type_absent';
      case 'leave':
        return 'attendance_type_leave';
      default:
        return 'attendance_type_unknown';
    }
  }

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'checked_in':
        return AppColors.primary;
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  static String monthQuery(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}';
}
