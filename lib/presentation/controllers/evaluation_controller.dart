import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/errors/api_exception.dart';
import '../../core/utils/storage_service.dart';
import '../../data/models/evaluation_models.dart';
import '../../data/repositories/evaluation_repository.dart';
import '../widgets/app_feedback.dart';
import 'my_evaluations_controller.dart';

enum EvaluationStep { loading, error, intro, questions, readOnlySummary, completed }

class EvaluationController extends GetxController {
  final EvaluationRepository _repository;
  final dynamic reviewId;
  final bool readOnly;

  EvaluationController({
    required this.reviewId,
    this.readOnly = false,
    EvaluationRepository? repository,
  }) : _repository = repository ?? EvaluationRepository();

  final Rx<EvaluationStep> step = EvaluationStep.loading.obs;
  final RxnString errorMessage = RxnString();
  final Rxn<EvaluationReviewModel> review = Rxn<EvaluationReviewModel>();

  final RxInt currentQuestionIndex = 0.obs;
  final RxBool isSubmitting = false.obs;

  /// question.id -> in-memory answer, kept alive for the whole flow so
  /// Back/Next never loses what the user already entered.
  final Map<dynamic, EvaluationAnswerModel> _answers = {};

  /// question.id -> owned TextEditingController, so text fields keep focus
  /// and cursor position across rebuilds instead of being recreated.
  final Map<dynamic, TextEditingController> _textControllers = {};

  List<EvaluationQuestionModel> get questions => review.value?.questions ?? const [];
  int get totalQuestions => questions.length;

  EvaluationQuestionModel? get currentQuestion =>
      currentQuestionIndex.value < questions.length ? questions[currentQuestionIndex.value] : null;

  bool get isFirstQuestion => currentQuestionIndex.value == 0;
  bool get isLastQuestion => totalQuestions == 0 || currentQuestionIndex.value == totalQuestions - 1;

  double get progressPercent => totalQuestions == 0 ? 0 : (currentQuestionIndex.value + 1) / totalQuestions;

  /// True when viewing an already-completed review (or forced via route args).
  bool get isViewOnly => readOnly || (review.value?.isCompleted ?? false);

  @override
  void onInit() {
    super.onInit();
    fetchReviewDetail();
  }

  @override
  void onClose() {
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.onClose();
  }

  Future<void> fetchReviewDetail() async {
    step.value = EvaluationStep.loading;
    errorMessage.value = null;
    try {
      final detail = await _repository.getReviewDetail(reviewId);
      review.value = detail;

      assert(() {
        for (final a in detail.answers ?? const []) {
          debugPrint(
            'EVAL_PARSED_ANSWER id=${a.questionId} '
            'rating=${a.rating} '
            'commentNull=${a.comment == null} '
            'commentLen=${a.comment?.length ?? 0} '
            'comment="${a.comment}"',
          );
        }
        for (final q in detail.questions ?? const []) {
          final matched = detail.answerForQuestion(q.id);
          debugPrint(
            'EVAL_Q id=${q.id} type=${q.responseType} '
            'matched=${matched != null} matchedCommentLen=${matched?.comment?.length ?? 0}',
          );
        }
        return true;
      }());

      final viewOnly = readOnly || detail.isCompleted;
      if (viewOnly) {
        // Completed → READ ONLY summary. Do not open intro / Start / Submit.
        // Do not create fresh editable answers — only map backend answers[].
        _hydrateSubmittedAnswers(detail);
        step.value = EvaluationStep.readOnlySummary;
      } else {
        _prepareAnswerSlots(detail.questions ?? const []);
        step.value = EvaluationStep.intro;
      }
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      step.value = EvaluationStep.error;
    } catch (_) {
      errorMessage.value = 'generic_error';
      step.value = EvaluationStep.error;
    }
  }

  void _prepareAnswerSlots(List<EvaluationQuestionModel> questions) {
    for (final q in questions) {
      _answers.putIfAbsent(q.id, () => EvaluationAnswerModel(questionId: q.id, responseType: q.responseType));
      if (q.isText || !q.isRating) {
        _textControllers.putIfAbsent(q.id, () => TextEditingController());
      }
    }
  }

  /// Maps `answers[]` from the detail response onto each question by
  /// `evaluation_template_question_id == questions[].id`.
  void _hydrateSubmittedAnswers(EvaluationReviewModel detail) {
    _answers.clear();
    for (final q in detail.questions ?? const []) {
      final submitted = detail.answerForQuestion(q.id);
      _answers[q.id] = EvaluationAnswerModel(
        questionId: q.id,
        responseType: q.responseType,
        rating: submitted?.rating,
        text: submitted?.comment,
      );
      if (q.isText || !q.isRating) {
        final c = _textControllers.putIfAbsent(q.id, () => TextEditingController());
        c.text = submitted?.comment ?? '';
      }
    }
  }

  void startQuestions() {
    if (isViewOnly) return;
    currentQuestionIndex.value = 0;
    step.value = EvaluationStep.questions;
  }

  EvaluationAnswerModel? answerFor(dynamic questionId) => _answers[questionId];

  EvaluationSubmittedAnswerModel? submittedAnswerFor(dynamic questionId) =>
      review.value?.answerForQuestion(questionId);

  TextEditingController textControllerFor(dynamic questionId) =>
      _textControllers[questionId] ??= TextEditingController();

  /// Bumped on every answer mutation so `Obx` widgets watching it rebuild —
  /// the answers themselves live in a plain (non-Rx) map keyed by question id.
  final RxInt answersTick = 0.obs;

  void setRating(dynamic questionId, int rating) {
    if (isViewOnly) return;
    final answer = _answers[questionId];
    if (answer != null) answer.rating = rating;
    answersTick.value++;
  }

  void setText(dynamic questionId, String text) {
    if (isViewOnly) return;
    final answer = _answers[questionId];
    if (answer != null) answer.text = text;
    answersTick.value++;
  }

  void goNext() {
    if (currentQuestionIndex.value < totalQuestions - 1) {
      currentQuestionIndex.value++;
    }
  }

  void goBack() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    } else if (!isViewOnly) {
      // Back from the first question returns to the intro summary (pending only).
      step.value = EvaluationStep.intro;
    } else {
      Get.back();
    }
  }

  bool get currentQuestionAnswered {
    final q = currentQuestion;
    if (q == null) return false;
    return _answers[q.id]?.isAnswered ?? false;
  }

  Future<void> submit() async {
    if (isViewOnly || isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      await _repository.submitReview(reviewId, _answers.values.toList());
      // Only now — after backend confirmation — do we treat it as completed.
      step.value = EvaluationStep.completed;
      if (Get.isBottomSheetOpen ?? false) Get.back();
      _refreshMyEvaluationsIfPresent();
    } on ApiException catch (e) {
      AppFeedback.showError(e.message);
    } catch (_) {
      AppFeedback.showError('generic_error');
    } finally {
      isSubmitting.value = false;
    }
  }

  void _refreshMyEvaluationsIfPresent() {
    if (Get.isRegistered<MyEvaluationsController>()) {
      Get.find<MyEvaluationsController>().refresh();
    }
  }

  /// Used only on the post-submit success screen ("Thank you, [Name]!").
  String get currentUserDisplayName {
    final user = StorageService.instance.user;
    return (user?['full_name'] ?? user?['name'] ?? user?['email'] ?? '').toString();
  }

  void done() {
    _refreshMyEvaluationsIfPresent();
    Get.back();
  }
}
