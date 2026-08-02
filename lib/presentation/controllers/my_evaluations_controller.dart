import 'package:get/get.dart';
import '../../core/errors/api_exception.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/evaluation_models.dart';
import '../../data/repositories/evaluation_repository.dart';
import '../widgets/app_feedback.dart';

class MyEvaluationsController extends GetxController {
  final EvaluationRepository _repository;
  MyEvaluationsController({EvaluationRepository? repository})
      : _repository = repository ?? EvaluationRepository();

  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final RxnString errorMessage = RxnString();

  final RxInt pending = 0.obs;
  final RxInt completed = 0.obs;
  final RxDouble completionPercentage = 0.0.obs;
  final RxList<EvaluationReviewModel> pendingReviews = <EvaluationReviewModel>[].obs;
  final RxList<EvaluationReviewModel> completedReviews = <EvaluationReviewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyReviews();
  }

  Future<void> fetchMyReviews({bool silent = false}) async {
    if (silent) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    errorMessage.value = null;
    try {
      final response = await _repository.getMyReviews();
      pending.value = response.pending;
      completed.value = response.completed;
      completionPercentage.value = response.completionPercentage;
      pendingReviews.value = response.data.where((r) => r.isPending).toList();
      completedReviews.value = response.data.where((r) => r.isCompleted).toList();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      if (silent) AppFeedback.showError(e.message);
    } catch (_) {
      errorMessage.value = 'generic_error';
      if (silent) AppFeedback.showError('generic_error');
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  @override
  Future<void> refresh() => fetchMyReviews(silent: true);

  /// Opens the review addressed by [review.id] — never creates a new one.
  void startReview(EvaluationReviewModel review) {
    Get.toNamed(AppRoutes.evaluationDetail, arguments: {'reviewId': review.id});
  }

  /// For completed reviews, opens the same detail flow read-only if the
  /// backend supports fetching a completed review's detail.
  void openCompletedReview(EvaluationReviewModel review) {
    Get.toNamed(AppRoutes.evaluationDetail, arguments: {'reviewId': review.id, 'readOnly': true});
  }
}
