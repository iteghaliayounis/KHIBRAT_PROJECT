import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/theme/khubrat_colors.dart';
import '../../data/models/leave_type_model.dart';
import '../controllers/apply_leave_controller.dart';

class ApplyLeaveView extends GetView<ApplyLeaveController> {
  const ApplyLeaveView({super.key});

  static const _navy = Color(0xFF002166);
  static const _accent = Color(0xFF835C21);
  static const _gold = Color(0xFFCBA158);

  @override
  Widget build(BuildContext context) {
    final palette = context.khubrat;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: palette.isDark ? Colors.transparent : palette.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    _buildHeader(palette),
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoadingTypes.value &&
                            controller.leaveTypes.isEmpty) {
                          return Center(
                            child: CircularProgressIndicator(color: palette.title),
                          );
                        }
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _sectionLabel(
                                icon: Icons.sell_outlined,
                                text: 'requested_leave_type'.tr,
                              ),
                              const SizedBox(height: 8),
                              _buildLeaveTypeDropdown(palette),
                              const SizedBox(height: 22),
                              _sectionLabel(
                                icon: Icons.access_time_rounded,
                                text: 'leave_duration'.tr,
                              ),
                              const SizedBox(height: 10),
                              _buildDurationChips(palette),
                              const SizedBox(height: 22),
                              ..._buildDateTimeFields(context),
                              const SizedBox(height: 22),
                              _sectionLabel(
                                icon: Icons.attach_file_rounded,
                                text: 'upload_proof_file'.tr,
                              ),
                              const SizedBox(height: 10),
                              _buildAttachmentBox(palette),
                              const SizedBox(height: 22),
                              _sectionLabel(
                                icon: Icons.notes_rounded,
                                text: 'leave_reason_detail'.tr,
                              ),
                              const SizedBox(height: 8),
                              _buildReasonField(palette),
                              const SizedBox(height: 28),
                              _buildSubmitButton(),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(KhubratColors palette) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: Text(
              'new_leave_request_title'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: palette.title,
              ),
            ),
          ),
          InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: palette.inputFill,
                shape: BoxShape.circle,
                border: Border.all(color: palette.chipBorder),
              ),
              child: Icon(Icons.close_rounded, color: palette.title, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _accent),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _accent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveTypeDropdown(KhubratColors palette) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: palette.inputFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: palette.inputBorder),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<LeaveTypeModel>(
            isExpanded: true,
            value: controller.selectedType.value,
            dropdownColor: palette.surface,
            hint: Text(
              'select_leave_type'.tr,
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: palette.hint,
              ),
            ),
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: palette.title),
            style: GoogleFonts.cairo(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
            items: controller.leaveTypes
                .map(
                  (type) => DropdownMenuItem<LeaveTypeModel>(
                    value: type,
                    child: Text(
                      type.requiresProof
                          ? '${type.name} (${'requires_proof_hint'.tr})'
                          : type.name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: controller.selectLeaveType,
          ),
        ),
      );
    });
  }

  Widget _buildDurationChips(KhubratColors palette) {
    return Obx(() {
      final options = controller.availableDurations;
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((option) {
          final selected = controller.selectedDuration.value == option;
          return GestureDetector(
            onTap: () => controller.selectDuration(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: selected
                    ? (palette.isDark
                        ? _navy.withValues(alpha: 0.28)
                        : _navy.withValues(alpha: 0.06))
                    : palette.inputFill,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? _navy : palette.chipBorder,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _durationIcon(option),
                    size: 16,
                    color: selected ? palette.title : palette.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _durationLabel(option),
                    style: GoogleFonts.cairo(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: selected ? palette.title : palette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  IconData _durationIcon(LeaveDurationUi option) {
    switch (option) {
      case LeaveDurationUi.singleDay:
        return Icons.calendar_today_rounded;
      case LeaveDurationUi.multipleDays:
        return Icons.date_range_rounded;
      case LeaveDurationUi.hourly:
        return Icons.schedule_rounded;
    }
  }

  String _durationLabel(LeaveDurationUi option) {
    switch (option) {
      case LeaveDurationUi.singleDay:
        return 'duration_single_day'.tr;
      case LeaveDurationUi.multipleDays:
        return 'duration_multiple_days'.tr;
      case LeaveDurationUi.hourly:
        return 'duration_hourly'.tr;
    }
  }

  List<Widget> _buildDateTimeFields(BuildContext context) {
    return [
      Obx(() {
        final duration = controller.selectedDuration.value;
        final widgets = <Widget>[
          _sectionLabel(
            icon: Icons.calendar_month_rounded,
            text: 'start_date'.tr,
          ),
          const SizedBox(height: 8),
          _dateField(
            context: context,
            value: controller.startDate.value,
            onPicked: controller.setStartDate,
          ),
        ];

        if (duration == LeaveDurationUi.multipleDays) {
          widgets.addAll([
            const SizedBox(height: 16),
            _sectionLabel(
              icon: Icons.calendar_month_rounded,
              text: 'end_date'.tr,
            ),
            const SizedBox(height: 8),
            _dateField(
              context: context,
              value: controller.endDate.value,
              onPicked: (d) => controller.endDate.value = d,
              firstDate: controller.startDate.value,
            ),
          ]);
        }

        if (duration == LeaveDurationUi.hourly) {
          widgets.addAll([
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _sectionLabel(
                        icon: Icons.access_time_rounded,
                        text: 'start_time'.tr,
                      ),
                      const SizedBox(height: 8),
                      _timeField(
                        context: context,
                        value: controller.startTime.value,
                        onPicked: (t) => controller.startTime.value = t,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _sectionLabel(
                        icon: Icons.access_time_rounded,
                        text: 'end_time'.tr,
                      ),
                      const SizedBox(height: 8),
                      _timeField(
                        context: context,
                        value: controller.endTime.value,
                        onPicked: (t) => controller.endTime.value = t,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        );
      }),
    ];
  }

  Widget _dateField({
    required BuildContext context,
    required DateTime? value,
    required ValueChanged<DateTime> onPicked,
    DateTime? firstDate,
  }) {
    final palette = context.khubrat;
    final locale = Get.locale?.languageCode == 'ar' ? 'ar' : 'en';
    final text = value == null
        ? 'select_date'.tr
        : DateFormat('yyyy/MM/dd', locale).format(value);

    return InkWell(
      onTap: () async {
        final first = _dateOnly(firstDate ?? DateTime.now());
        final last = _dateOnly(DateTime.now().add(const Duration(days: 365 * 2)));
        // لازم initialDate يكون بين firstDate و lastDate وإلا AssertionError
        var initial = _dateOnly(value ?? DateTime.now());
        if (initial.isBefore(first)) initial = first;
        if (initial.isAfter(last)) initial = last;

        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: first,
          lastDate: last,
        );
        if (picked != null) onPicked(picked);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: palette.inputFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: palette.inputBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 18, color: _gold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.cairo(
                  fontSize: 13.5,
                  fontWeight: value == null ? FontWeight.w400 : FontWeight.w600,
                  color: value == null ? palette.hint : palette.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  Widget _timeField({
    required BuildContext context,
    required TimeOfDay? value,
    required ValueChanged<TimeOfDay> onPicked,
  }) {
    final palette = context.khubrat;
    final text = value == null
        ? 'select_time'.tr
        : '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: value ?? TimeOfDay.now(),
        );
        if (picked != null) onPicked(picked);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: palette.inputFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: palette.inputBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule_rounded, size: 18, color: _gold),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: value == null ? FontWeight.w400 : FontWeight.w600,
                  color: value == null ? palette.hint : palette.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentBox(KhubratColors palette) {
    return Obx(() {
      final hasFile = controller.attachmentPath.value != null;
      return GestureDetector(
        onTap: controller.pickAttachment,
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: palette.chipBorder,
            radius: 16,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            decoration: BoxDecoration(
              color: palette.inputFill,
              borderRadius: BorderRadius.circular(16),
            ),
            child: hasFile
                ? Column(
                    children: [
                      Icon(Icons.insert_drive_file_rounded,
                          color: palette.title, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        controller.attachmentName.value ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.clearAttachment,
                        child: Text(
                          'remove_attachment'.tr,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(Icons.cloud_upload_rounded,
                          color: palette.title, size: 36),
                      const SizedBox(height: 10),
                      Text(
                        'tap_or_drag_file'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'attachment_formats_hint'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          color: palette.hint,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }

  Widget _buildReasonField(KhubratColors palette) {
    return TextField(
      controller: controller.reasonController,
      maxLines: 4,
      style: GoogleFonts.cairo(fontSize: 13.5, color: palette.textPrimary),
      decoration: InputDecoration(
        hintText: 'leave_reason_hint'.tr,
        hintStyle: GoogleFonts.cairo(
          fontSize: 13,
          color: palette.hint,
        ),
        filled: true,
        fillColor: palette.inputFill,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _gold, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final loading = controller.isSubmitting.value;
      return SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: loading ? null : controller.submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: _navy,
            disabledBackgroundColor: _navy.withOpacity(0.6),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      'submit_leave_request'.tr,
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
    });
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
