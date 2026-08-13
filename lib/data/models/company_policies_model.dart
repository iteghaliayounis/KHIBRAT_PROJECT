class AttendancePolicyModel {
  final String workStartTime;
  final String workEndTime;
  final int allowedLateMinutes;
  final int allowedEarlyLeaveMinutes;
  final int minimumDailyHours;

  const AttendancePolicyModel({
    required this.workStartTime,
    required this.workEndTime,
    required this.allowedLateMinutes,
    required this.allowedEarlyLeaveMinutes,
    required this.minimumDailyHours,
  });

  factory AttendancePolicyModel.fromJson(Map<String, dynamic> json) {
    return AttendancePolicyModel(
      workStartTime: json['work_start_time']?.toString() ?? '',
      workEndTime: json['work_end_time']?.toString() ?? '',
      allowedLateMinutes: _asInt(json['allowed_late_minutes']),
      allowedEarlyLeaveMinutes: _asInt(json['allowed_early_leave_minutes']),
      minimumDailyHours: _asInt(json['minimum_daily_hours']),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class LeavePolicyItemModel {
  final String id;
  final String name;
  final int allocationValue;
  final String allocationUnit;
  final bool requiresProof;

  const LeavePolicyItemModel({
    required this.id,
    required this.name,
    required this.allocationValue,
    required this.allocationUnit,
    required this.requiresProof,
  });

  bool get isHourly => allocationUnit.toLowerCase() == 'hours';

  factory LeavePolicyItemModel.fromJson(Map<String, dynamic> json) {
    return LeavePolicyItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      allocationValue: AttendancePolicyModel._asInt(json['allocation_value']),
      allocationUnit: json['allocation_unit']?.toString() ?? 'days',
      requiresProof: json['requires_proof'] == true,
    );
  }
}

class CompanyPoliciesModel {
  final AttendancePolicyModel attendancePolicy;
  final List<LeavePolicyItemModel> leavePolicies;

  const CompanyPoliciesModel({
    required this.attendancePolicy,
    required this.leavePolicies,
  });

  factory CompanyPoliciesModel.fromJson(Map<String, dynamic> json) {
    final attendance = json['attendance_policy'];
    final leaves = json['leave_policies'];
    return CompanyPoliciesModel(
      attendancePolicy: attendance is Map<String, dynamic>
          ? AttendancePolicyModel.fromJson(attendance)
          : const AttendancePolicyModel(
              workStartTime: '',
              workEndTime: '',
              allowedLateMinutes: 0,
              allowedEarlyLeaveMinutes: 0,
              minimumDailyHours: 0,
            ),
      leavePolicies: leaves is List
          ? leaves
              .whereType<Map>()
              .map((e) => LeavePolicyItemModel.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList()
          : const [],
    );
  }
}
