/// يمثل نتيجة تابع المعاينة GET /api/employee/overtime/preview
/// (مقدار الزيادة المتوقع سواء لطلب ساعات أو ليوم دوام كامل)
class OvertimePreviewModel {
  final bool ok;
  final String durationType; // 'hour' | 'day'
  final int units;
  final String ruleType; // overtime_hour | overtime_day
  final String ruleValue; // نسبة الزيادة كما ترجع من السيرفر كنص
  final String valueType; // percent | fixed ...
  final double unitAmount; // قيمة الزيادة (بعد ضرب عدد الوحدات)
  final double estimatedAmount; // المبلغ التقديري الكلي

  const OvertimePreviewModel({
    required this.ok,
    required this.durationType,
    required this.units,
    required this.ruleType,
    required this.ruleValue,
    required this.valueType,
    required this.unitAmount,
    required this.estimatedAmount,
  });

  factory OvertimePreviewModel.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    return OvertimePreviewModel(
      ok: json['ok'] == true,
      durationType: json['duration_type']?.toString() ?? '',
      units: json['units'] is int
          ? json['units'] as int
          : int.tryParse(json['units']?.toString() ?? '') ?? 0,
      ruleType: json['rule_type']?.toString() ?? '',
      ruleValue: json['rule_value']?.toString() ?? '0',
      valueType: json['value_type']?.toString() ?? '',
      unitAmount: _toDouble(json['unit_amount']),
      estimatedAmount: _toDouble(json['estimated_amount']),
    );
  }
}
