class LeaveBalanceModel {
  final String id;
  final String name;
  final int allocationValue;
  final int usedValue;
  final int remainingValue;

  const LeaveBalanceModel({
    required this.id,
    required this.name,
    required this.allocationValue,
    required this.usedValue,
    required this.remainingValue,
  });

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      allocationValue: leaveAsInt(json['allocation_value']),
      usedValue: leaveAsInt(json['used_value']),
      remainingValue: leaveAsInt(json['remaining_value']),
    );
  }
}

class LeaveHistoryModel {
  final String id;
  final String leaveTypeName;
  final String? startDate;
  final int durationDays;
  final String status;

  const LeaveHistoryModel({
    required this.id,
    required this.leaveTypeName,
    this.startDate,
    required this.durationDays,
    required this.status,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryModel(
      id: json['id']?.toString() ?? '',
      leaveTypeName: json['leave_type_name']?.toString() ?? '',
      startDate: json['start_date']?.toString(),
      durationDays: leaveAsInt(json['duration_days']),
      status: json['status']?.toString() ?? 'pending',
    );
  }
}

class LeaveDashboardModel {
  final int totalAllowedDays;
  final int totalUsedDays;
  final int remainingDays;
  final List<LeaveBalanceModel> balances;
  final List<LeaveHistoryModel> leaveHistory;

  const LeaveDashboardModel({
    required this.totalAllowedDays,
    required this.totalUsedDays,
    required this.remainingDays,
    required this.balances,
    required this.leaveHistory,
  });

  factory LeaveDashboardModel.fromJson(Map<String, dynamic> json) {
    final balancesJson = json['balances'];
    final historyJson = json['leave_history'];

    return LeaveDashboardModel(
      totalAllowedDays: leaveAsInt(json['total_allowed_days']),
      totalUsedDays: leaveAsInt(json['total_used_days']),
      remainingDays: leaveAsInt(json['remaining_days']),
      balances: balancesJson is List
          ? balancesJson
              .whereType<Map>()
              .map((e) => LeaveBalanceModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      leaveHistory: historyJson is List
          ? historyJson
              .whereType<Map>()
              .map((e) => LeaveHistoryModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

int leaveAsInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
