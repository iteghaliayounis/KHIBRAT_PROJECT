/// يمثل عنصر طلب عمل إضافي واحد
/// يُستخدم لتحويل استجابة POST /api/employee/overtime/apply
/// وأيضاً كل عنصر بقائمة GET /api/employee/overtime (السجل)
class OvertimeModel {
  final String? id;
  final String requestDate;
  final String durationType; // 'hour' | 'day'
  final int unitsRequested;
  final int? unitsApproved;
  final String reason;
  final String status; // pending_department_manager | approved | rejected ...
  final String? rejectionReason;
  final double? calculatedAmount;
  final double? unitAmount;
  final double? estimatedAmount;
  final String? currency;
  final String? createdAt;

  const OvertimeModel({
    this.id,
    required this.requestDate,
    required this.durationType,
    required this.unitsRequested,
    this.unitsApproved,
    required this.reason,
    required this.status,
    this.rejectionReason,
    this.calculatedAmount,
    this.unitAmount,
    this.estimatedAmount,
    this.currency,
    this.createdAt,
  });

  factory OvertimeModel.fromJson(Map<String, dynamic> json) {
    double? _toDoubleOrNull(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return OvertimeModel(
      id: json['id']?.toString(),
      requestDate: json['request_date']?.toString() ?? '',
      durationType: json['duration_type']?.toString() ?? '',
      // ملاحظة: استجابة apply تستخدم "units_requested"
      unitsRequested: json['units_requested'] is int
          ? json['units_requested'] as int
          : int.tryParse(json['units_requested']?.toString() ?? '') ?? 0,
      unitsApproved: json['units_approved'] == null
          ? null
          : (json['units_approved'] is int
              ? json['units_approved'] as int
              : int.tryParse(json['units_approved'].toString())),
      reason: json['reason']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      rejectionReason: json['rejection_reason']?.toString(),
      calculatedAmount: _toDoubleOrNull(json['calculated_amount']),
      unitAmount: _toDoubleOrNull(json['unit_amount']),
      estimatedAmount: _toDoubleOrNull(json['estimated_amount']),
      currency: json['currency']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  /// عدد الساعات لطلبات type=hour، دائماً 1 لطلبات type=day
  bool get isFullDay => durationType == 'day';
}
