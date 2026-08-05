import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// شارة حالة طلب العمل الإضافي (قيد المراجعة / مقبول / مرفوض)
/// ⚠️ عدّل قيم status القادمة من الباك اند إذا كانت مختلفة عن الافتراض
/// (pending_department_manager / approved / rejected) لتطابق فعلياً.
class OvertimeStatusBadge extends StatelessWidget {
  final String status;

  const OvertimeStatusBadge({super.key, required this.status});

  _StatusStyle get _style {
    switch (status) {
      case 'approved':
        return _StatusStyle(
          label: 'overtime_status_approved'.tr,
          bg: const Color(0xFFE8F8F0),
          fg: const Color(0xFF16A34A),
          icon: Icons.check_circle,
        );
      case 'rejected':
        return _StatusStyle(
          label: 'overtime_status_rejected'.tr,
          bg: const Color(0xFFFCEBEE),
          fg: const Color(0xFFDC2626),
          icon: Icons.cancel,
        );
      case 'pending_department_manager':
      default:
        return _StatusStyle(
          label: 'overtime_status_pending'.tr,
          bg: const Color(0xFFFFF7E0),
          fg: const Color(0xFFB08900),
          icon: Icons.access_time_filled,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        style.label,
        style: GoogleFonts.cairo(
          color: style.fg,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusStyle {
  final String label;
  final Color bg;
  final Color fg;
  final IconData icon;

  _StatusStyle({
    required this.label,
    required this.bg,
    required this.fg,
    required this.icon,
  });
}
