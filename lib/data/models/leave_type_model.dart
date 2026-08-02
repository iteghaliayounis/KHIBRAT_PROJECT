class LeaveTypeModel {
  final String id;
  final String name;
  final int allocationValue;
  final String allocationUnit;
  final bool requiresProof;

  const LeaveTypeModel({
    required this.id,
    required this.name,
    required this.allocationValue,
    required this.allocationUnit,
    required this.requiresProof,
  });

  bool get isHourly => allocationUnit.toLowerCase() == 'hours';

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      allocationValue: _asInt(json['allocation_value']),
      allocationUnit: json['allocation_unit']?.toString() ?? 'days',
      requiresProof: json['requires_proof'] == true,
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
