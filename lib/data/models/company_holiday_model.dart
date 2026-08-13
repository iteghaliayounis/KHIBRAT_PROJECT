class CompanyHolidayModel {
  final String id;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool repeatsAnnually;

  const CompanyHolidayModel({
    required this.id,
    required this.name,
    this.startDate,
    this.endDate,
    required this.repeatsAnnually,
  });

  factory CompanyHolidayModel.fromJson(Map<String, dynamic> json) {
    return CompanyHolidayModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      repeatsAnnually: json['repeats_annually'] == true,
    );
  }

  /// Weekly holidays come without dates; the weekday is in [name]
  /// (e.g. "Friday", "Saturday", "الجمعة").
  bool get isWeeklyHoliday => startDate == null && endDate == null;

  /// Dart weekday: Monday = 1 … Sunday = 7.
  int? get weekday {
    if (!isWeeklyHoliday) return null;
    return weekdayFromName(name);
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return null;
    return DateTime.tryParse(text);
  }

  static int? weekdayFromName(String raw) {
    final n = raw.trim().toLowerCase();
    const map = <String, int>{
      'monday': DateTime.monday,
      'mon': DateTime.monday,
      'الاثنين': DateTime.monday,
      'اثنين': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'tue': DateTime.tuesday,
      'الثلاثاء': DateTime.tuesday,
      'ثلاثاء': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'wed': DateTime.wednesday,
      'الأربعاء': DateTime.wednesday,
      'الاربعاء': DateTime.wednesday,
      'أربعاء': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'thu': DateTime.thursday,
      'الخميس': DateTime.thursday,
      'خميس': DateTime.thursday,
      'friday': DateTime.friday,
      'fri': DateTime.friday,
      'الجمعة': DateTime.friday,
      'جمعة': DateTime.friday,
      'saturday': DateTime.saturday,
      'sat': DateTime.saturday,
      'السبت': DateTime.saturday,
      'سبت': DateTime.saturday,
      'sunday': DateTime.sunday,
      'sun': DateTime.sunday,
      'الأحد': DateTime.sunday,
      'الاحد': DateTime.sunday,
      'أحد': DateTime.sunday,
      'احد': DateTime.sunday,
    };
    return map[n];
  }

  /// Whether [day] falls on this official (dated) holiday.
  bool coversDay(DateTime day) {
    if (isWeeklyHoliday || startDate == null) return false;
    final d = DateTime(day.year, day.month, day.day);
    final start = startDate!;
    final end = endDate ?? start;

    if (repeatsAnnually) {
      final startMd = DateTime(d.year, start.month, start.day);
      final endMd = DateTime(d.year, end.month, end.day);
      if (endMd.isBefore(startMd)) {
        return !d.isBefore(startMd) || !d.isAfter(endMd);
      }
      return !d.isBefore(startMd) && !d.isAfter(endMd);
    }

    final startNorm = DateTime(start.year, start.month, start.day);
    final endNorm = DateTime(end.year, end.month, end.day);
    return !d.isBefore(startNorm) && !d.isAfter(endNorm);
  }
}
