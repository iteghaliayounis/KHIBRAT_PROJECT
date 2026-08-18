/// Models for Salary slips & Advances. Defensive parsing only.
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
  return double.tryParse(v.toString().replaceAll(',', ''));
}

String? _asString(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

bool _asBool(dynamic v, {bool fallback = false}) {
  if (v == null) return fallback;
  if (v is bool) return v;
  if (v is num) return v != 0;
  final s = v.toString().toLowerCase();
  if (s == 'true' || s == '1') return true;
  if (s == 'false' || s == '0') return false;
  return fallback;
}

/// Generic Laravel-style paginated list.
class PaginatedList<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;
  final int? from;
  final int? to;
  final String? nextPageUrl;
  final String? prevPageUrl;

  const PaginatedList({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.from,
    this.to,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemParser,
  ) {
    final list = json['data'];
    final items = list is List
        ? list
            .whereType<Map>()
            .map((e) => itemParser(Map<String, dynamic>.from(e)))
            .toList()
        : <T>[];

    return PaginatedList<T>(
      data: items,
      currentPage: _asInt(json['current_page']) ?? 1,
      lastPage: _asInt(json['last_page']) ?? 1,
      total: _asInt(json['total']) ?? items.length,
      from: _asInt(json['from']),
      to: _asInt(json['to']),
      nextPageUrl: _asString(json['next_page_url']),
      prevPageUrl: _asString(json['prev_page_url']),
    );
  }
}

class AdvanceEligibilityModel {
  final double basicSalary;
  final double maxAllowedAmount;
  final int maxRepaymentMonths;
  final bool allowMultipleActiveAdvances;
  final bool policyConfigured;
  final bool hasDepartmentManager;
  final bool hasActiveAdvance;
  final String currency;
  final Map<String, dynamic>? activeAdvanceDetails;

  const AdvanceEligibilityModel({
    required this.basicSalary,
    required this.maxAllowedAmount,
    required this.maxRepaymentMonths,
    required this.allowMultipleActiveAdvances,
    required this.policyConfigured,
    required this.hasDepartmentManager,
    required this.hasActiveAdvance,
    this.currency = 'SYP',
    this.activeAdvanceDetails,
  });

  factory AdvanceEligibilityModel.fromJson(Map<String, dynamic> json) {
    final root = (json['data'] is Map) ? Map<String, dynamic>.from(json['data']) : json;
    Map<String, dynamic>? details;
    final raw = root['active_advance_details'];
    if (raw is Map) details = Map<String, dynamic>.from(raw);

    return AdvanceEligibilityModel(
      basicSalary: _asDouble(root['basic_salary']) ?? 0,
      maxAllowedAmount: _asDouble(root['max_allowed_amount']) ?? 0,
      maxRepaymentMonths: _asInt(root['max_repayment_months']) ?? 0,
      allowMultipleActiveAdvances: _asBool(root['allow_multiple_active_advances']),
      policyConfigured: _asBool(root['policy_configured']),
      hasDepartmentManager: _asBool(root['has_department_manager']),
      hasActiveAdvance: _asBool(root['has_active_advance']),
      currency: _asString(root['currency']) ?? 'SYP',
      activeAdvanceDetails: details,
    );
  }

  AdvanceEligibilityModel copyWith({bool? hasActiveAdvance, String? currency}) {
    return AdvanceEligibilityModel(
      basicSalary: basicSalary,
      maxAllowedAmount: maxAllowedAmount,
      maxRepaymentMonths: maxRepaymentMonths,
      allowMultipleActiveAdvances: allowMultipleActiveAdvances,
      policyConfigured: policyConfigured,
      hasDepartmentManager: hasDepartmentManager,
      hasActiveAdvance: hasActiveAdvance ?? this.hasActiveAdvance,
      currency: currency ?? this.currency,
      activeAdvanceDetails: activeAdvanceDetails,
    );
  }
}

class AdvanceRecordModel {
  final String id;
  final double requestedAmount;
  final int repaymentMonths;
  final double monthlyInstallment;
  final String status;
  final String currency;
  final String? rejectionReason;
  final String? createdAt;

  const AdvanceRecordModel({
    required this.id,
    required this.requestedAmount,
    required this.repaymentMonths,
    required this.monthlyInstallment,
    required this.status,
    this.currency = 'SYP',
    this.rejectionReason,
    this.createdAt,
  });

  factory AdvanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AdvanceRecordModel(
      id: _asString(json['id']) ?? '',
      requestedAmount: _asDouble(json['requested_amount']) ?? 0,
      repaymentMonths: _asInt(json['repayment_months']) ?? 0,
      monthlyInstallment: _asDouble(json['monthly_installment']) ?? 0,
      status: (_asString(json['status']) ?? 'unknown').toLowerCase(),
      currency: _asString(json['currency']) ?? 'SYP',
      rejectionReason: _asString(json['rejection_reason']),
      createdAt: _asString(json['created_at']),
    );
  }
}

class AdvanceApplyResult {
  final String message;
  final AdvanceRecordModel record;

  const AdvanceApplyResult({required this.message, required this.record});

  factory AdvanceApplyResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? Map<String, dynamic>.from(json['data']) : json;
    return AdvanceApplyResult(
      message: _asString(json['message']) ?? '',
      record: AdvanceRecordModel.fromJson(data),
    );
  }
}

class LastReceivedSalaryModel {
  final double amount;
  final int month;
  final int year;
  final String? period;
  final String? receivedAt;
  final String? paymentSummary;
  final String? salaryRecordId;

  const LastReceivedSalaryModel({
    required this.amount,
    required this.month,
    required this.year,
    this.period,
    this.receivedAt,
    this.paymentSummary,
    this.salaryRecordId,
  });

  factory LastReceivedSalaryModel.fromJson(Map<String, dynamic> json) {
    return LastReceivedSalaryModel(
      amount: _asDouble(json['amount']) ?? 0,
      month: _asInt(json['month']) ?? 1,
      year: _asInt(json['year']) ?? DateTime.now().year,
      period: _asString(json['period']),
      receivedAt: _asString(json['received_at']),
      paymentSummary: _asString(json['payment_summary']),
      salaryRecordId: _asString(json['salary_record_id']),
    );
  }
}

class SalaryRecordModel {
  final String id;
  final int month;
  final int year;
  final String? period;
  final double baseSalary;
  final double totalAdditions;
  final double totalDeductions;
  final double netSalary;
  final String status;
  final bool isReceived;
  final String? paymentSummary;
  final String? receivedAt;

  const SalaryRecordModel({
    required this.id,
    required this.month,
    required this.year,
    required this.baseSalary,
    required this.totalAdditions,
    required this.totalDeductions,
    required this.netSalary,
    required this.status,
    required this.isReceived,
    this.period,
    this.paymentSummary,
    this.receivedAt,
  });

  factory SalaryRecordModel.fromJson(Map<String, dynamic> json) {
    return SalaryRecordModel(
      id: _asString(json['id']) ?? '',
      month: _asInt(json['month']) ?? 1,
      year: _asInt(json['year']) ?? DateTime.now().year,
      period: _asString(json['period']),
      baseSalary: _asDouble(json['base_salary']) ?? 0,
      totalAdditions: _asDouble(json['total_additions']) ?? 0,
      totalDeductions: _asDouble(json['total_deductions']) ?? 0,
      netSalary: _asDouble(json['net_salary']) ?? 0,
      status: (_asString(json['status']) ?? 'unknown').toLowerCase(),
      isReceived: _asBool(json['is_received']),
      paymentSummary: _asString(json['payment_summary']),
      receivedAt: _asString(json['received_at']),
    );
  }
}

class SalaryLineItemModel {
  final String type;
  final String label;
  final double amount;

  const SalaryLineItemModel({
    required this.type,
    required this.label,
    required this.amount,
  });

  factory SalaryLineItemModel.fromJson(Map<String, dynamic> json) {
    return SalaryLineItemModel(
      type: _asString(json['type']) ?? '',
      label: _asString(json['label']) ?? '',
      amount: _asDouble(json['amount']) ?? 0,
    );
  }
}

class SalaryComponentsModel {
  final double baseSalary;
  final double overtimeAmount;
  final double bonusAmount;
  final double manualBonus;
  final double lateDeduction;
  final double absentDeduction;
  final double loanDeduction;
  final double manualDeduction;

  const SalaryComponentsModel({
    required this.baseSalary,
    required this.overtimeAmount,
    required this.bonusAmount,
    required this.manualBonus,
    required this.lateDeduction,
    required this.absentDeduction,
    required this.loanDeduction,
    required this.manualDeduction,
  });

  factory SalaryComponentsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SalaryComponentsModel(
        baseSalary: 0,
        overtimeAmount: 0,
        bonusAmount: 0,
        manualBonus: 0,
        lateDeduction: 0,
        absentDeduction: 0,
        loanDeduction: 0,
        manualDeduction: 0,
      );
    }
    return SalaryComponentsModel(
      baseSalary: _asDouble(json['base_salary']) ?? 0,
      overtimeAmount: _asDouble(json['overtime_amount']) ?? 0,
      bonusAmount: _asDouble(json['bonus_amount']) ?? 0,
      manualBonus: _asDouble(json['manual_bonus']) ?? 0,
      lateDeduction: _asDouble(json['late_deduction']) ?? 0,
      absentDeduction: _asDouble(json['absent_deduction']) ?? 0,
      loanDeduction: _asDouble(json['loan_deduction']) ?? 0,
      manualDeduction: _asDouble(json['manual_deduction']) ?? 0,
    );
  }
}

class SalaryDetailModel {
  final String id;
  final int month;
  final int year;
  final String? period;
  final double baseSalary;
  final double totalAdditions;
  final double totalDeductions;
  final double netSalary;
  final String status;
  final bool isReceived;
  final String? paymentSummary;
  final String? receivedAt;
  final SalaryComponentsModel components;
  final List<SalaryLineItemModel> additions;
  final List<SalaryLineItemModel> deductions;
  final List<SalaryLineItemModel> adjustments;

  const SalaryDetailModel({
    required this.id,
    required this.month,
    required this.year,
    required this.baseSalary,
    required this.totalAdditions,
    required this.totalDeductions,
    required this.netSalary,
    required this.status,
    required this.isReceived,
    required this.components,
    required this.additions,
    required this.deductions,
    required this.adjustments,
    this.period,
    this.paymentSummary,
    this.receivedAt,
  });

  factory SalaryDetailModel.fromJson(Map<String, dynamic> json) {
    final root = (json['data'] is Map) ? Map<String, dynamic>.from(json['data']) : json;

    List<SalaryLineItemModel> parseLines(dynamic raw) {
      if (raw is! List) return [];
      return raw
          .whereType<Map>()
          .map((e) => SalaryLineItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return SalaryDetailModel(
      id: _asString(root['id']) ?? '',
      month: _asInt(root['month']) ?? 1,
      year: _asInt(root['year']) ?? DateTime.now().year,
      period: _asString(root['period']),
      baseSalary: _asDouble(root['base_salary']) ?? 0,
      totalAdditions: _asDouble(root['total_additions']) ?? 0,
      totalDeductions: _asDouble(root['total_deductions']) ?? 0,
      netSalary: _asDouble(root['net_salary']) ?? 0,
      status: (_asString(root['status']) ?? 'unknown').toLowerCase(),
      isReceived: _asBool(root['is_received']),
      paymentSummary: _asString(root['payment_summary']),
      receivedAt: _asString(root['received_at']),
      components: SalaryComponentsModel.fromJson(
        root['components'] is Map ? Map<String, dynamic>.from(root['components']) : null,
      ),
      additions: parseLines(root['additions']),
      deductions: parseLines(root['deductions']),
      adjustments: parseLines(root['adjustments']),
    );
  }
}

class SalariesDashboardModel {
  final LastReceivedSalaryModel? lastReceivedSalary;
  final PaginatedList<SalaryRecordModel> records;

  const SalariesDashboardModel({
    required this.lastReceivedSalary,
    required this.records,
  });

  factory SalariesDashboardModel.fromJson(Map<String, dynamic> json) {
    final root = (json['data'] is Map) ? Map<String, dynamic>.from(json['data']) : json;

    LastReceivedSalaryModel? last;
    final lastRaw = root['last_received_salary'];
    if (lastRaw is Map) {
      last = LastReceivedSalaryModel.fromJson(Map<String, dynamic>.from(lastRaw));
    }

    final recordsRaw = root['records'];
    final PaginatedList<SalaryRecordModel> records;
    if (recordsRaw is Map) {
      records = PaginatedList.fromJson(
        Map<String, dynamic>.from(recordsRaw),
        SalaryRecordModel.fromJson,
      );
    } else if (recordsRaw is List) {
      // HTML mock / flat list fallback
      records = PaginatedList(
        data: recordsRaw
            .whereType<Map>()
            .map((e) => SalaryRecordModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        currentPage: 1,
        lastPage: 1,
        total: recordsRaw.length,
      );
    } else {
      records = const PaginatedList(data: [], currentPage: 1, lastPage: 1, total: 0);
    }

    return SalariesDashboardModel(lastReceivedSalary: last, records: records);
  }
}
