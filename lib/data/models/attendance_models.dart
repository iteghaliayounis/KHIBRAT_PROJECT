/// Models for the Attendance feature.
/// Defensive parsing only — no invented business fields.
library;

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

String? _asString(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

/// A single attendance day record from the dashboard / check-in / check-out APIs.
class AttendanceRecordModel {
  final dynamic id;
  final String? workDate;
  final String? checkInTime;
  final String? checkOutTime;
  final int? lateMinutes;
  final int? earlyLeaveMinutes;
  final int? totalWorkMinutes;
  final String status;
  final String attendanceType;

  const AttendanceRecordModel({
    required this.id,
    required this.status,
    required this.attendanceType,
    this.workDate,
    this.checkInTime,
    this.checkOutTime,
    this.lateMinutes,
    this.earlyLeaveMinutes,
    this.totalWorkMinutes,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id'],
      workDate: _asString(json['work_date']),
      checkInTime: _asString(json['check_in_time']),
      checkOutTime: _asString(json['check_out_time']),
      lateMinutes: _asInt(json['late_minutes']),
      earlyLeaveMinutes: _asInt(json['early_leave_minutes']),
      totalWorkMinutes: _asInt(json['total_work_minutes']),
      status: (_asString(json['status']) ?? 'unknown').toLowerCase(),
      attendanceType: (_asString(json['attendance_type']) ?? 'unknown').toLowerCase(),
    );
  }

  bool get isCheckedIn => status == 'checked_in';
  bool get isCompleted => status == 'completed';
}

/// Full GET /api/employee/attendance/dashboard payload (under `data`).
class AttendanceDashboardModel {
  final String? month;
  final int presentDays;
  final int absentDays;
  final int leaveDays;
  final int totalLateMinutes;
  final double totalWorkHours;
  final List<AttendanceRecordModel> records;

  const AttendanceDashboardModel({
    this.month,
    required this.presentDays,
    required this.absentDays,
    required this.leaveDays,
    required this.totalLateMinutes,
    required this.totalWorkHours,
    required this.records,
  });

  factory AttendanceDashboardModel.fromJson(Map<String, dynamic> json) {
    final root = (json['data'] is Map) ? Map<String, dynamic>.from(json['data']) : json;

    final listJson = root['records'];
    final records = listJson is List
        ? listJson
            .whereType<Map>()
            .map((e) => AttendanceRecordModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <AttendanceRecordModel>[];

    return AttendanceDashboardModel(
      month: _asString(root['month']),
      presentDays: _asInt(root['present_days']) ?? 0,
      absentDays: _asInt(root['absent_days']) ?? 0,
      leaveDays: _asInt(root['leave_days']) ?? 0,
      totalLateMinutes: _asInt(root['total_late_minutes']) ?? 0,
      totalWorkHours: _asDouble(root['total_work_hours']) ?? 0,
      records: records,
    );
  }

  /// Today's open check-in (status checked_in, no check-out), if present in [records].
  AttendanceRecordModel? get activeCheckIn {
    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    for (final r in records) {
      if (r.workDate == todayKey && r.isCheckedIn && r.checkOutTime == null) {
        return r;
      }
    }
    return null;
  }
}

/// Result of check-in / check-out POST (message + record data).
class AttendanceActionResult {
  final String message;
  final AttendanceRecordModel record;

  const AttendanceActionResult({required this.message, required this.record});

  factory AttendanceActionResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? Map<String, dynamic>.from(json['data']) : json;
    return AttendanceActionResult(
      message: _asString(json['message']) ?? '',
      record: AttendanceRecordModel.fromJson(data),
    );
  }
}
