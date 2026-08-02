/// Models for the "My Evaluations" feature.
///
/// Every field is read defensively (multiple possible backend key names are
/// tried) because the exact Laravel resource shape wasn't pinned down in the
/// spec. Nothing here is hard-coded content — these classes only describe
/// *how* to read whatever the backend sends.
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

bool _idsEqual(dynamic a, dynamic b) {
  if (a == null || b == null) return false;
  if (a == b) return true;
  return a.toString() == b.toString();
}

/// A person referenced by a review: the employee being evaluated, or the
/// reviewer.
///
/// Backend shapes observed:
/// - employee: `{ id, employee_code, job_title, department, user: { full_name, email } }`
/// - reviewer: `{ id, full_name, email, ... }` (flat, or nested user)
class EvaluationPersonModel {
  final dynamic id;
  final String? fullName;
  final String? email;
  final String? employeeCode;
  final String? jobTitle;
  final String? department;

  const EvaluationPersonModel({
    this.id,
    this.fullName,
    this.email,
    this.employeeCode,
    this.jobTitle,
    this.department,
  });

  factory EvaluationPersonModel.fromJson(Map<String, dynamic> json) {
    final userRaw = json['user'];
    final user = userRaw is Map ? Map<String, dynamic>.from(userRaw) : null;

    // Prefer nested user.full_name (employee.user.full_name), then flat full_name
    // (reviewer.full_name). Never invent a name when one exists nested.
    final fullName = _asString(
      user?['full_name'] ??
          user?['name'] ??
          json['full_name'] ??
          json['name'] ??
          json['fullname'],
    );

    final email = _asString(user?['email'] ?? json['email']);

    final departmentRaw = json['department'] ?? json['department_name'];
    final department = departmentRaw is Map
        ? _asString(departmentRaw['name'] ?? departmentRaw['title'])
        : _asString(departmentRaw);

    return EvaluationPersonModel(
      id: json['id'] ?? user?['id'],
      fullName: fullName,
      email: email,
      employeeCode: _asString(json['employee_code'] ?? json['code']),
      jobTitle: _asString(json['job_title'] ?? json['title'] ?? json['position']),
      department: department,
    );
  }

  /// Display name from API only — empty string when the backend truly has none.
  String get displayName => fullName ?? email ?? '';
}

class EvaluationCycleModel {
  final dynamic id;
  final String? name;
  final String? startDate;
  final String? endDate;
  final String? status;

  const EvaluationCycleModel({this.id, this.name, this.startDate, this.endDate, this.status});

  factory EvaluationCycleModel.fromJson(Map<String, dynamic> json) {
    return EvaluationCycleModel(
      id: json['id'],
      name: _asString(json['name']),
      startDate: _asString(json['start_date'] ?? json['starts_at']),
      endDate: _asString(json['end_date'] ?? json['ends_at']),
      status: _asString(json['status']),
    );
  }
}

/// A single evaluation question. [responseType] drives which input widget
/// is rendered ('rating', 'text', ...). Unknown types fall back to a plain
/// text field so new question types added on the backend don't crash the app.
class EvaluationQuestionModel {
  final dynamic id;
  final String question;
  final String responseType;
  final num? weight;
  final int? sortOrder;

  /// Optional character limit for text questions. Only enforced when the
  /// backend actually sends it — the UI must not invent a fixed value.
  final int? maxLength;

  /// Optional supporting text shown under the question title, if the
  /// backend provides one (e.g. description / hint / help_text).
  final String? helpText;

  const EvaluationQuestionModel({
    required this.id,
    required this.question,
    required this.responseType,
    this.weight,
    this.sortOrder,
    this.maxLength,
    this.helpText,
  });

  factory EvaluationQuestionModel.fromJson(Map<String, dynamic> json) {
    return EvaluationQuestionModel(
      id: json['id'],
      question: _asString(json['question'] ?? json['text'] ?? json['title']) ?? '',
      responseType: (_asString(json['response_type'] ?? json['type']) ?? 'text').toLowerCase(),
      weight: json['weight'] is num ? json['weight'] as num : _asDouble(json['weight']),
      sortOrder: _asInt(json['sort_order'] ?? json['order']),
      maxLength: _asInt(json['max_length'] ?? json['character_limit'] ?? json['char_limit']),
      helpText: _asString(json['description'] ?? json['hint'] ?? json['help_text'] ?? json['subtitle']),
    );
  }

  bool get isRating => responseType == 'rating';
  bool get isText => responseType == 'text';
}

/// A submitted answer returned by GET detail for a completed review.
/// Linked to a question via [questionId] (== questions[].id /
/// answers[].evaluation_template_question_id).
class EvaluationSubmittedAnswerModel {
  final dynamic id;
  final dynamic questionId;
  final int? rating;
  final String? comment;

  const EvaluationSubmittedAnswerModel({
    this.id,
    required this.questionId,
    this.rating,
    this.comment,
  });

  factory EvaluationSubmittedAnswerModel.fromJson(Map<String, dynamic> json) {
    // Link keys observed from the real API:
    // - answers[].evaluation_template_question_id
    // - answers[].question.id  (nested relation)
    // - answers[].question_id  (flat fallback)
    final nestedQuestion = json['question'];
    final nestedQuestionId = nestedQuestion is Map ? nestedQuestion['id'] : null;

    return EvaluationSubmittedAnswerModel(
      id: json['id'],
      questionId: json['evaluation_template_question_id'] ??
          nestedQuestionId ??
          json['question_id'] ??
          json['evaluation_question_id'],
      rating: _asInt(json['rating']),
      // Text body lives on the answer object. Prefer `comment` (GET contract),
      // then `text` (submit payload / some responses). Never read nested
      // question.* fields.
      comment: _answerTextContent(json),
    );
  }
}

/// Reads the textual answer from an **answer** JSON object only.
///
/// Prefer [comment], then common answer-level aliases ([text], …).
/// Never reads `question.comment` or any nested question field.
/// Returns the exact String with no reverse/split/replace.
///
/// Also unwraps locale maps like `{ "ar": "...", "en": "..." }` when the
/// backend stores multilingual values as objects instead of plain strings
/// (plain English strings still work as-is).
String? _answerTextContent(Map<String, dynamic> json) {
  final candidates = <dynamic>[
    json['comment'],
    json['text'],
    json['value'],
    json['content'],
    json['body'],
    json['answer_text'],
  ];
  // Only if `answer` itself is a plain String or locale map — not a question object.
  final answerField = json['answer'];
  if (answerField is String || answerField is Map) {
    candidates.add(answerField);
  }

  String? firstEmpty;
  for (final raw in candidates) {
    final extracted = _coerceAnswerString(raw);
    if (extracted == null) continue;
    if (extracted.isNotEmpty) return extracted;
    firstEmpty ??= extracted;
  }
  return firstEmpty;
}

/// Coerces a JSON value into an answer string without mutating characters.
/// Supports plain strings and locale maps; ignores unrelated types/Maps that
/// look like nested models (e.g. objects with an `id` + `question` key).
String? _coerceAnswerString(dynamic raw) {
  if (raw == null) return null;
  if (raw is String) return raw;
  if (raw is! Map) return null;

  final map = Map<String, dynamic>.from(raw);
  // Nested question/model shapes — never treat as answer text.
  if (map.containsKey('question') || map.containsKey('response_type')) {
    return null;
  }

  for (final localeKey in ['ar', 'ar_SY', 'ar_SA', 'en', 'en_US', 'en_GB']) {
    final v = map[localeKey];
    if (v is String && v.isNotEmpty) return v;
  }
  for (final v in map.values) {
    if (v is String && v.isNotEmpty) return v;
  }
  for (final v in map.values) {
    if (v is String) return v;
  }
  return null;
}

/// A user's in-progress answer to a single question. Kept in memory only
/// (answers must survive Back/Next navigation but nothing is persisted or
/// considered final until the Submit API succeeds).
class EvaluationAnswerModel {
  final dynamic questionId;
  final String responseType;
  int? rating;
  String? text;

  EvaluationAnswerModel({required this.questionId, required this.responseType, this.rating, this.text});

  bool get isAnswered {
    if (responseType == 'rating') return rating != null && rating! > 0;
    if (responseType == 'text') return (text ?? '').trim().isNotEmpty;
    return (text ?? '').trim().isNotEmpty || rating != null;
  }

  Map<String, dynamic> toJson() {
    // Backend GET exposes text answers as `comment`. Submit with both
    // `comment` and `text` so either contract shape persists correctly.
    return {
      'question_id': questionId,
      if (responseType == 'rating') 'rating': rating,
      if (responseType == 'text') ...{
        'comment': text,
        'text': text,
      },
      if (responseType != 'rating' && responseType != 'text') 'value': text ?? rating,
    };
  }
}

/// A review assigned to the current user, as returned by
/// GET /api/evaluations/my-reviews (list form) and
/// GET /api/evaluations/my-reviews/{review} (detail form, includes questions).
class EvaluationReviewModel {
  final dynamic id;
  final String? reviewType; // e.g. self / peer / manager — raw backend value
  final String status; // e.g. pending / completed
  final String? dueDate;
  final String? completedAt;
  final EvaluationPersonModel? employee;
  final EvaluationPersonModel? reviewer;
  final EvaluationCycleModel? cycle;
  final int? questionsCount;
  final List<EvaluationQuestionModel>? questions;
  final List<EvaluationSubmittedAnswerModel>? answers;

  const EvaluationReviewModel({
    required this.id,
    required this.status,
    this.reviewType,
    this.dueDate,
    this.completedAt,
    this.employee,
    this.reviewer,
    this.cycle,
    this.questionsCount,
    this.questions,
    this.answers,
  });

  factory EvaluationReviewModel.fromJson(Map<String, dynamic> json) {
    final questionsJson = json['questions'];
    final parsedQuestions = questionsJson is List
        ? (questionsJson
            .whereType<Map>()
            .map((q) => EvaluationQuestionModel.fromJson(Map<String, dynamic>.from(q)))
            .toList()
          ..sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0)))
        : null;

    final answersJson = json['answers'];
    final parsedAnswers = answersJson is List
        ? answersJson
            .whereType<Map>()
            .map((a) => EvaluationSubmittedAnswerModel.fromJson(Map<String, dynamic>.from(a)))
            .toList()
        : null;

    final employeeJson = json['employee'] ?? json['evaluatee'] ?? json['target'];
    final reviewerJson = json['reviewer'] ?? json['evaluator'];
    final cycleJson = json['cycle'] ?? json['evaluation_cycle'];

    return EvaluationReviewModel(
      id: json['id'],
      reviewType: _asString(json['review_type'] ?? json['type']),
      status: (_asString(json['status']) ?? 'pending').toLowerCase(),
      dueDate: _asString(json['due_date'] ?? json['due_at']),
      completedAt: _asString(json['submitted_at'] ?? json['submitted_at']),
      employee: employeeJson is Map ? EvaluationPersonModel.fromJson(Map<String, dynamic>.from(employeeJson)) : null,
      reviewer: reviewerJson is Map ? EvaluationPersonModel.fromJson(Map<String, dynamic>.from(reviewerJson)) : null,
      cycle: cycleJson is Map ? EvaluationCycleModel.fromJson(Map<String, dynamic>.from(cycleJson)) : null,
      questionsCount: _asInt(json['questions_count']) ?? parsedQuestions?.length,
      questions: parsedQuestions,
      answers: parsedAnswers,
    );
  }

  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';

  /// Finds the submitted answer for [questionId] by matching
  /// `answers[].evaluation_template_question_id` or `answers[].question.id`
  /// to `questions[].id`.
  EvaluationSubmittedAnswerModel? answerForQuestion(dynamic questionId) {
    final list = answers;
    if (list == null || list.isEmpty || questionId == null) return null;
    for (final a in list) {
      if (a.questionId != null && _idsEqual(a.questionId, questionId)) return a;
    }
    return null;
  }

  /// True when [dueDate] is in the past and the review is still pending.
  bool get isOverdue {
    if (!isPending || dueDate == null) return false;
    final parsed = DateTime.tryParse(dueDate!);
    if (parsed == null) return false;
    return parsed.isBefore(DateTime.now());
  }
}

/// The full response of GET /api/evaluations/my-reviews.
class MyReviewsResponseModel {
  final int pending;
  final int completed;
  final double completionPercentage;
  final List<EvaluationReviewModel> data;

  const MyReviewsResponseModel({
    required this.pending,
    required this.completed,
    required this.completionPercentage,
    required this.data,
  });

  factory MyReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    // Some backends nest counters/list under a "data"/"meta" wrapper —
    // handle both a flat and a nested shape without assuming either.
    final root = (json['data'] is Map && json['data']['data'] is List)
        ? Map<String, dynamic>.from(json['data'])
        : json;

    final listJson = root['data'];
    final reviews = listJson is List
        ? listJson.whereType<Map>().map((e) => EvaluationReviewModel.fromJson(Map<String, dynamic>.from(e))).toList()
        : <EvaluationReviewModel>[];

    final pending = _asInt(root['pending']) ?? reviews.where((r) => r.isPending).length;
    final completed = _asInt(root['completed']) ?? reviews.where((r) => r.isCompleted).length;
    final total = pending + completed;
    final percentage = _asDouble(root['completion_percentage']) ??
        (total == 0 ? 0.0 : (completed / total) * 100);

    return MyReviewsResponseModel(
      pending: pending,
      completed: completed,
      completionPercentage: percentage,
      data: reviews,
    );
  }
}
