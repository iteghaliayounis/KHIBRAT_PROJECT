import 'package:flutter/foundation.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/evaluation_models.dart';

/// Talks to the `/api/evaluations/my-reviews...` endpoints. Every value
/// shown in the UI is sourced from these responses — nothing is mocked here.
class EvaluationRepository {
  final ApiClient _client;

  EvaluationRepository({ApiClient? client}) : _client = client ?? ApiClient.instance;

  /// GET /api/evaluations/my-reviews (optionally filtered by [status]:
  /// 'pending' | 'completed').
  Future<MyReviewsResponseModel> getMyReviews({String? status}) async {
    final json = await _client.get(
      ApiConstants.myReviews,
      queryParameters: (status != null && status.isNotEmpty) ? {'status': status} : null,
    );
    return MyReviewsResponseModel.fromJson(json);
  }

  /// GET /api/evaluations/my-reviews/{review} — full detail including the
  /// dynamic `questions` list used to build the question flow.
  Future<EvaluationReviewModel> getReviewDetail(dynamic reviewId) async {
    final json = await _client.get(ApiConstants.myReviewDetail(reviewId));
    final data = json['data'] is Map ? Map<String, dynamic>.from(json['data']) : json;

    assert(() {
      final answers = data['answers'];
      if (answers is List) {
        for (final raw in answers) {
          if (raw is! Map) continue;
          final map = Map<String, dynamic>.from(raw);
          // Log answer-level keys only (not nested question) to find where
          // the text body actually lives when `comment` is null.
          final keys = map.keys.where((k) => k != 'question').toList();
          debugPrint(
            'EVAL_RAW_ANSWER keys=$keys '
            'commentType=${map['comment']?.runtimeType} comment=${map['comment']} '
            'textType=${map['text']?.runtimeType} text=${map['text']} '
            'value=${map['value']} content=${map['content']}',
          );
        }
      }
      return true;
    }());

    return EvaluationReviewModel.fromJson(data);
  }

  /// POST /api/evaluations/my-reviews/{review}/submit
  ///
  /// The review is only ever treated as Completed once this call succeeds —
  /// callers must not flip local state to "completed" ahead of the response.
  Future<void> submitReview(dynamic reviewId, List<EvaluationAnswerModel> answers) async {
    await _client.post(
      ApiConstants.submitReview(reviewId),
      data: {'answers': answers.map((a) => a.toJson()).toList()},
    );
  }
}
