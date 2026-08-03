import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/routes/app_routes.dart';
import '../../data/models/leave_dashboard_model.dart';
import '../controllers/leave_dashboard_controller.dart';

class LeaveDashboardView extends GetView<LeaveDashboardController> {
  const LeaveDashboardView({super.key});

  static const _navy = Color(0xFF002166);
  static const _gold = Color(0xFFCBA158);
  static const _bg = Color(0xFFFAFBFD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.dashboard.value == null) {
                  return const Center(
                    child: CircularProgressIndicator(color: _navy),
                  );
                }

                final data = controller.dashboard.value;
                return RefreshIndicator(
                  color: _navy,
                  onRefresh: controller.loadDashboard,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      _buildBalanceCard(data),
                      const SizedBox(height: 16),
                      _buildNewRequestButton(),
                      const SizedBox(height: 28),
                      _buildHistoryHeader(),
                      const SizedBox(height: 12),
                      if (data == null || data.leaveHistory.isEmpty)
                        _buildEmptyHistory()
                      else
                        ...data.leaveHistory.map(_buildHistoryCard),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _circleIconButton(
            icon: Icons.arrow_forward_ios_rounded,
            onTap: () => Get.back(),
          ),
          Expanded(
            child: Text(
              'leave_dashboard_title'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _navy,
              ),
            ),
          ),
          // مساحة فارغة لموازنة العنوان مع زر الرجوع
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: _navy, size: 16),
      ),
    );
  }

  Widget _buildBalanceCard(LeaveDashboardModel? data) {
    final year = DateTime.now().year;
    final total = data?.totalAllowedDays ?? 0;
    final used = data?.totalUsedDays ?? 0;
    final remaining = data?.remainingDays ?? 0;
    final progress = total > 0 ? (used / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _navy.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${'annual_balance_for'.tr} $year',
                  style: GoogleFonts.cairo(
                    color: _gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.event_available_rounded, color: _gold, size: 22),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _statBox(
                  label: 'total_days'.tr,
                  value: '$total',
                  highlighted: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statBox(
                  label: 'used_days'.tr,
                  value: '$used',
                  highlighted: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statBox(
                  label: 'remaining_days'.tr,
                  value: '$remaining',
                  highlighted: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation(_gold),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'leave_usage_summary'
                  .trParams({'used': '$used', 'total': '$total'}),
              style: GoogleFonts.cairo(
                color: Colors.white.withOpacity(0.85),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox({
    required String label,
    required String value,
    required bool highlighted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlighted ? _gold : Colors.white.withOpacity(0.25),
          width: highlighted ? 1.6 : 1,
        ),
        color: highlighted ? Colors.white.withOpacity(0.06) : Colors.transparent,
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: Colors.white.withOpacity(0.75),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: highlighted ? _gold : Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewRequestButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () => Get.toNamed(AppRoutes.applyLeave),
        style: ElevatedButton.styleFrom(
          backgroundColor: _navy,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flight_takeoff_rounded, size: 20),
            const SizedBox(width: 10),
            Text(
              'new_leave_request'.tr,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Row(
      children: [
        Icon(Icons.history_rounded, color: _navy.withOpacity(0.7), size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'previous_leaves_history'.tr,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'sorted_descending'.tr,
            style: GoogleFonts.cairo(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyHistory() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.event_busy_rounded, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'no_leave_history'.tr,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(LeaveHistoryModel item) {
    final statusMeta = _statusMeta(item.status);
    final dateText = _formatDisplayDate(item.startDate);
    final daysLabel = item.durationDays == 1
        ? 'one_day'.tr
        : 'days_count'.trParams({'count': '${item.durationDays}'});

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusMeta.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(statusMeta.icon, color: statusMeta.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.leaveTypeName} - $daysLabel',
                  style: GoogleFonts.cairo(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$dateText | ${statusMeta.label}',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusMeta.bg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusMeta.shortLabel,
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusMeta.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _StatusMeta _statusMeta(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'completed':
        return _StatusMeta(
          label: 'leave_status_approved'.tr,
          shortLabel: 'leave_status_accepted'.tr,
          color: const Color(0xFF2E7D32),
          bg: const Color(0xFFE8F5E9),
          icon: Icons.check_circle_rounded,
        );
      case 'rejected':
        return _StatusMeta(
          label: 'leave_status_rejected'.tr,
          shortLabel: 'leave_status_rejected'.tr,
          color: const Color(0xFFC62828),
          bg: const Color(0xFFFFEBEE),
          icon: Icons.cancel_rounded,
        );
      default:
        return _StatusMeta(
          label: 'leave_status_pending_review'.tr,
          shortLabel: 'leave_status_under_study'.tr,
          color: const Color(0xFFC9A227),
          bg: const Color(0xFFFFF8E1),
          icon: Icons.hourglass_top_rounded,
        );
    }
  }

  String _formatDisplayDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    try {
      final date = DateTime.parse(raw);
      final locale = Get.locale?.languageCode == 'ar' ? 'ar' : 'en';
      return DateFormat('d MMMM yyyy', locale).format(date);
    } catch (_) {
      return raw;
    }
  }
}

class _StatusMeta {
  final String label;
  final String shortLabel;
  final Color color;
  final Color bg;
  final IconData icon;

  const _StatusMeta({
    required this.label,
    required this.shortLabel,
    required this.color,
    required this.bg,
    required this.icon,
  });
}
