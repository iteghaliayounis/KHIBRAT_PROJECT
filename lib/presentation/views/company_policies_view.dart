import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/khubrat_colors.dart';
import '../../data/models/company_policies_model.dart';
import '../controllers/company_policies_controller.dart';

class CompanyPoliciesView extends GetView<CompanyPoliciesController> {
  const CompanyPoliciesView({super.key});

  static const _navy = Color(0xFF002166);
  static const _gold = Color(0xFFA3813F);
  static const _goldSoft = Color(0xFFCBA158);
  static const _green = Color(0xFF2E7D32);
  static const _red = Color(0xFFD32F2F);
  static const _weekendBg = Color(0xFFE8F0FE);
  static const _holidayBg = Color(0xFFFFF3E0);
  static const _holidayBorder = Color(0xFFFFB74D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.policies.value == null) {
                return const Center(
                  child: CircularProgressIndicator(color: _navy),
                );
              }

              final error = controller.errorMessage.value;
              if (error != null && controller.policies.value == null) {
                return _buildError(error);
              }

              final policies = controller.policies.value;
              if (policies == null) return const SizedBox.shrink();

              return RefreshIndicator(
                color: _navy,
                onRefresh: controller.loadAll,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    _buildAttendanceSection(policies.attendancePolicy),
                    const SizedBox(height: 16),
                    _buildLeavePoliciesSection(),
                    const SizedBox(height: 16),
                    _buildHolidaysCalendar(context),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ───────────────── Header (sharp corners) ─────────────────
  Widget _buildHeader(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      width: double.infinity,
      color: _navy,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
          child: Row(
            children: [
              _backButton(isRtl: isRtl),
              Expanded(
                child: Text(
                  'company_policies_title'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton({required bool isRtl}) {
    return InkWell(
      onTap: () => Get.back(),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isRtl
              ? Icons.arrow_forward_ios_rounded
              : Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  // ───────────────── Section 1: Attendance ─────────────────
  Widget _buildAttendanceSection(AttendancePolicyModel attendance) {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time_rounded, color: Get.context!.khubrat.title, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'official_work_hours'.tr,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Get.context!.khubrat.title,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _timeMiniCard(
                  icon: Icons.login_rounded,
                  iconColor: _green,
                  label: 'arrival_time'.tr,
                  value: CompanyPoliciesController.formatWorkTime(
                    attendance.workStartTime,
                  ),
                  valueColor: _green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _timeMiniCard(
                  icon: Icons.logout_rounded,
                  iconColor: _red,
                  label: 'departure_time'.tr,
                  value: CompanyPoliciesController.formatWorkTime(
                    attendance.workEndTime,
                  ),
                  valueColor: _red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Get.context!.khubrat.inputFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Get.context!.khubrat.chipBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.work_outline_rounded, color: Get.context!.khubrat.title, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'daily_work_hours'.tr,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Get.context!.khubrat.textSecondary,
                    ),
                  ),
                ),
                Text(
                  'hours_count'.trParams({
                    'count': '${attendance.minimumDailyHours}',
                  }),
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Get.context!.khubrat.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _limitOutlineCard(
                  label: 'allowed_late_limit'.tr,
                  value: 'minutes_count'.trParams({
                    'count': '${attendance.allowedLateMinutes}',
                  }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _limitOutlineCard(
                  label: 'allowed_early_leave_limit'.tr,
                  value: 'minutes_count'.trParams({
                    'count': '${attendance.allowedEarlyLeaveMinutes}',
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeMiniCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    final palette = Get.context!.khubrat;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: palette.inputFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.chipBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _limitOutlineCard({required String label, required String value}) {
    final palette = Get.context!.khubrat;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _goldSoft.withOpacity(0.85), width: 1.2),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: palette.textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: _gold,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── Section 2: Leave policies ─────────────────
  Widget _buildLeavePoliciesSection() {
    final featured = controller.featuredLeave;
    final grid = controller.gridLeaves;

    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'leave_terms_policies'.tr,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Get.context!.khubrat.title,
            ),
          ),
          const SizedBox(height: 14),
          if (featured != null) ...[
            _buildFeaturedLeaveCard(featured),
            const SizedBox(height: 12),
          ],
          if (grid.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 10) / 2;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: grid
                      .map(
                        (item) => SizedBox(
                          width: itemWidth,
                          child: _buildLeaveGridCard(item),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturedLeaveCard(LeavePolicyItemModel item) {
    final unitLabel = item.isHourly ? 'unit_hour'.tr : 'unit_day'.tr;
    final displayName = _cleanLeaveName(item.name);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: _goldSoft,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'max_allowed_limit'.tr,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${item.allocationValue}',
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _goldSoft,
                    height: 1,
                  ),
                ),
                Text(
                  unitLabel,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveGridCard(LeavePolicyItemModel item) {
    final palette = Get.context!.khubrat;
    final icon = _iconForLeave(item.name);
    final valueText = item.isHourly
        ? 'hours_count'.trParams({'count': '${item.allocationValue}'})
        : 'days_count'.trParams({'count': '${item.allocationValue}'});

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
      decoration: BoxDecoration(
        color: palette.inputFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.chipBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: palette.isDark
                  ? const Color(0xFF3A2A12)
                  : const Color(0xFFF3E9D8),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _gold, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            _cleanLeaveName(item.name),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'max_limit'.tr,
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            valueText,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: palette.title,
            ),
          ),
        ],
      ),
    );
  }

  String _cleanLeaveName(String name) {
    return name
        .replaceAll(RegExp(r'\s+Leave\s+Allocation$', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+Allocation$', caseSensitive: false), '')
        .trim();
  }

  IconData _iconForLeave(String name) {
    final n = name.toLowerCase();
    if (n.contains('hourly') || n.contains('hour')) {
      return Icons.hourglass_bottom_rounded;
    }
    if (n.contains('sick')) return Icons.medical_services_outlined;
    if (n.contains('travel')) return Icons.flight_rounded;
    if (n.contains('marriage') || n.contains('wedding')) {
      return Icons.favorite_rounded;
    }
    if (n.contains('maternity') || n.contains('pregnancy')) {
      return Icons.child_friendly_rounded;
    }
    if (n.contains('umrah') || n.contains('hajj')) {
      return Icons.mosque_rounded;
    }
    if (n.contains('paid') || n.contains('annual') || n.contains('free')) {
      return Icons.calendar_month_rounded;
    }
    return Icons.event_note_rounded;
  }

  // ───────────────── Section 3: Holidays calendar ─────────────────
  Widget _buildHolidaysCalendar(BuildContext context) {
    final locale = Get.locale?.languageCode ?? 'ar';
    final palette = context.khubrat;

    return Obx(() {
      final month = controller.focusedMonth.value;
      final monthLabel = controller.monthTitle(locale);
      final quarterKey = 'quarter_${controller.quarter}';

      return _sectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: palette.title, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'company_holidays_calendar'.trParams({
                      'month': monthLabel,
                    }),
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: palette.title,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: palette.inputFill,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: palette.chipBorder),
                  ),
                  child: Text(
                    quarterKey.tr,
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: controller.previousMonth,
                  icon: Icon(Icons.chevron_left_rounded, color: palette.title),
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  monthLabel,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: palette.title,
                  ),
                ),
                IconButton(
                  onPressed: controller.nextMonth,
                  icon: Icon(Icons.chevron_right_rounded, color: palette.title),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 4),
            _buildWeekdayHeader(palette),
            const SizedBox(height: 6),
            _buildMonthGrid(month, palette),
            const SizedBox(height: 14),
            _buildLegend(palette),
          ],
        ),
      );
    });
  }

  Widget _buildWeekdayHeader(KhubratColors palette) {
    final labels = [
      'cal_sun'.tr,
      'cal_mon'.tr,
      'cal_tue'.tr,
      'cal_wed'.tr,
      'cal_thu'.tr,
      'cal_fri'.tr,
      'cal_sat'.tr,
    ];
    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMonthGrid(DateTime month, KhubratColors palette) {
    final first = DateTime(month.year, month.month, 1);
    final startOffset = first.weekday % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final totalCells = ((startOffset + daysInMonth + 6) ~/ 7) * 7;
    final weekendBg = palette.isDark ? const Color(0xFF1B3A6E) : _weekendBg;
    final holidayBg = palette.isDark ? const Color(0xFF3A2A12) : _holidayBg;
    final weekendBorder =
        palette.isDark ? const Color(0xFF3A6AB0) : const Color(0xFFBBDEFB);
    final holidayBorder =
        palette.isDark ? const Color(0xFFCBA158) : _holidayBorder;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final dayNum = index - startOffset + 1;
        if (dayNum < 1 || dayNum > daysInMonth) {
          return const SizedBox.shrink();
        }
        final date = DateTime(month.year, month.month, dayNum);
        final weekly = controller.isWeeklyHoliday(date);
        final holiday = controller.officialHolidayFor(date);
        final isHoliday = holiday != null;

        Color? bg;
        Color border = Colors.transparent;
        if (isHoliday) {
          bg = holidayBg;
          border = holidayBorder;
        } else if (weekly) {
          bg = weekendBg;
          border = weekendBorder;
        }

        final tooltip = holiday?.name ??
            controller.weeklyHolidayFor(date)?.name ??
            '';

        return Tooltip(
          message: tooltip,
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: border, width: 1),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$dayNum',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
                  ),
                ),
                if (isHoliday)
                  const Positioned(
                    top: 2,
                    right: 2,
                    child: Icon(
                      Icons.wb_sunny_rounded,
                      size: 10,
                      color: Color(0xFFFF9800),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegend(KhubratColors palette) {
    final weeklyDays = controller.weeklyLegendDaysLabel();
    final weekendBg = palette.isDark ? const Color(0xFF1B3A6E) : _weekendBg;
    final holidayBg = palette.isDark ? const Color(0xFF3A2A12) : _holidayBg;
    final weekendBorder =
        palette.isDark ? const Color(0xFF3A6AB0) : const Color(0xFFBBDEFB);
    final holidayBorder =
        palette.isDark ? const Color(0xFFCBA158) : _holidayBorder;
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (weeklyDays.isNotEmpty)
          _legendItem(
            color: weekendBg,
            border: weekendBorder,
            label: 'legend_weekly_holiday'.trParams({'days': weeklyDays}),
            textColor: palette.textSecondary,
          ),
        _legendItem(
          color: holidayBg,
          border: holidayBorder,
          label: 'legend_official_holiday'.tr,
          textColor: palette.textSecondary,
        ),
      ],
    );
  }

  Widget _legendItem({
    required Color color,
    required Color border,
    required String label,
    required Color textColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }

  // ───────────────── Shared ─────────────────
  Widget _sectionCard({required Widget child}) {
    final palette = Get.context!.khubrat;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.chipBorder),
        boxShadow: [
          BoxShadow(
            color: palette.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.isNotEmpty ? message : 'company_policies_load_error'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Get.context!.khubrat.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: controller.loadAll,
              child: Text(
                'company_policies_retry'.tr,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w700,
                  color: Get.context!.khubrat.title,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
