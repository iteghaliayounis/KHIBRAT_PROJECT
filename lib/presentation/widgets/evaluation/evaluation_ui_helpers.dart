import 'package:flutter/material.dart';

/// Everything in this file is purely presentational: it decides *how* to
/// draw a value that already came from the backend (an icon for a
/// review_type string, a color for a status, a "3 min" label from a
/// question count). It never invents evaluation content.
class EvaluationUiHelpers {
  EvaluationUiHelpers._();

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Formats an ISO-ish date string ("2026-08-31" or full timestamp) as
  /// "Aug 31". Falls back to the raw string if it can't be parsed so we
  /// never hide backend data because of a formatting quirk.
  static String formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return '${_months[parsed.month - 1]} ${parsed.day}';
  }

  /// Equivalent of HTML `dir="auto"`: pick RTL/LTR from the first strong
  /// directional character. Does not reverse or mutate the string — Flutter's
  /// Unicode BiDi algorithm then renders Arabic / English / mixed correctly.
  static TextDirection autoTextDirection(String text) {
    for (final codePoint in text.runes) {
      if (_isStrongRtl(codePoint)) return TextDirection.rtl;
      if (_isStrongLtr(codePoint)) return TextDirection.ltr;
    }
    return TextDirection.ltr;
  }

  static bool _isStrongRtl(int c) {
    return (c >= 0x0590 && c <= 0x08FF) ||
        (c >= 0xFB1D && c <= 0xFDFF) ||
        (c >= 0xFE70 && c <= 0xFEFF);
  }

  static bool _isStrongLtr(int c) {
    return (c >= 0x0041 && c <= 0x005A) ||
        (c >= 0x0061 && c <= 0x007A) ||
        (c >= 0x00C0 && c <= 0x024F) ||
        (c >= 0x1E00 && c <= 0x1EFF);
  }

  /// Maps a free-form `review_type` string coming from the backend to an
  /// icon + color pair, defaulting gracefully for any type not seen yet
  /// (so new review types added on the backend don't break the UI).
/// Maps a free-form `review_type` and `status` coming from the backend to an
  /// icon + color pair.
  static ({IconData icon, Color color, Color background}) iconFor(String? reviewType, {String? status}) {
    final type = (reviewType ?? '').toLowerCase();
    final isCompleted = (status ?? '').toLowerCase() == 'completed';

    // 1. إذا كانت الحالة مكتملة (Completed)
    if (isCompleted) {
      return (
        icon: Icons.description_rounded, // أيقونة المستند المكتمل
        color: const Color(0xFF835C21),    // لون برونزي دافئ للأيقونة
        background: const Color(0xFFFCD88A), // لون خلفية ذهبي دافئ
      );
    }

    // 2. إذا كانت الحالة معلقة (Pending)
    if (type.contains('peer')) {
      return (
        icon: Icons.groups_rounded, 
        color: Colors.white, 
        background: const Color(0xFF002173) // كحلي فاخر
      );
    }
    if (type.contains('manager')) {
      return (
        icon: Icons.assignment_rounded, 
        color: Colors.white, 
        background: const Color(0xFF002173) // كحلي فاخر
      );
    }
    if (type.contains('self')) {
      return (
        icon: Icons.description_rounded, 
        color: const Color(0xFF835C21), 
        background: const Color(0xFFFCD88A) // ذهبي
      );
    }

    // Default Pending State
    return (
      icon: Icons.rate_review_rounded, 
      color: Colors.white, 
      background: const Color(0xFF002173)
    );
  }

  /// Human title used on cards / headers when the backend doesn't already
  /// send a display label — built purely from `review_type`.
  static String titleFor(String? reviewType, {required String fallback}) {
    final type = (reviewType ?? '').trim();
    if (type.isEmpty) return fallback;
    // "self" -> "Self Evaluation", "peer_evaluation" -> "Peer Evaluation"
    final words = type.replaceAll('_', ' ').split(' ').where((w) => w.isNotEmpty);
    final capitalized = words.map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase()).join(' ');
    if (capitalized.toLowerCase().contains('evaluation')) return capitalized;
    return '$capitalized Evaluation';
  }

  static const List<String> ratingLabels = ['Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];

  static String ratingLabelFor(int rating) {
    if (rating < 1 || rating > ratingLabels.length) return '';
    return ratingLabels[rating - 1];
  }
}
