import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/models/overtime_model.dart';
import 'overtime_status_badge.dart';

class OvertimeHistoryCard extends StatelessWidget {
  final OvertimeModel item;

  const OvertimeHistoryCard({super.key, required this.item});

  Color get _iconColor {
    switch (item.status) {
      case 'approved':
        return const Color(0xFF16A34A);
      case 'rejected':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFFB08900);
    }
  }

  IconData get _icon {
    switch (item.status) {
      case 'approved':
        return Icons.check;
      case 'rejected':
        return Icons.close;
      default:
        return Icons.access_time_filled;
    }
  }

  String get _subtitle {
    String dateLabel = item.requestDate;
    try {
      final parsed = DateTime.parse(item.requestDate);
      // تنسيق التاريخ يتبع لغة التطبيق الحالية (عربي/إنجليزي)
      final locale = Get.locale?.languageCode == 'ar' ? 'ar' : 'en';
      dateLabel = DateFormat('d MMMM yyyy', locale).format(parsed);
    } catch (_) {}

    final unitsLabel = item.isFullDay
        ? 'overtime_full_day_short'.tr
        : 'overtime_hours_worked_count'.trParams({
            'count': '${item.unitsRequested}',
          });

    return '$dateLabel | $unitsLabel';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFF4)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, size: 16, color: _iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'overtime_history_item_title'.tr,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OvertimeStatusBadge(status: item.status),
        ],
      ),
    );
  }
}
