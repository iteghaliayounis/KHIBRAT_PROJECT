import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/evaluation_models.dart';
import '../controllers/evaluation_controller.dart';
import '../widgets/evaluation/evaluation_ui_helpers.dart';
import '../widgets/evaluation/star_rating_input.dart';
import '../widgets/evaluation/submit_confirmation_sheet.dart';
import '../widgets/evaluation/text_answer_input.dart';

class EvaluationDetailView extends GetView<EvaluationController> {
  const EvaluationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.step.value) {
        case EvaluationStep.loading:
          return const _LoadingScaffold();
        case EvaluationStep.error:
          return _ErrorScaffold(
            message: controller.errorMessage.value ?? 'generic_error',
            onRetry: controller.fetchReviewDetail,
          );
        case EvaluationStep.intro:
          return const _IntroScaffold();
        case EvaluationStep.questions:
          return const _QuestionsScaffold();
        case EvaluationStep.readOnlySummary:
          return const _ReadOnlySummaryScaffold();
        case EvaluationStep.completed:
          return const _CompletedScaffold();
      }
    });
  }
}

// ─────────────────────────── Loading / Error ───────────────────────────

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorScaffold({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _evaluationAppBar(title: 'evaluation'.tr, onBack: () => Get.back()),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 42, color: AppColors.error),
              const SizedBox(height: 12),
              Text(message.tr, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              TextButton(onPressed: onRetry, child: Text('retry'.tr)),
            ],
          ),
        ),
      ),
    );
  }
}

AppBar _evaluationAppBar({required String title, required VoidCallback onBack}) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
      onPressed: onBack,
    ),
    title: Text(title, style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

// ─────────────────────────────── Intro (Pending only) ───────────────────────────────

class _IntroScaffold extends GetView<EvaluationController> {
  const _IntroScaffold();

  @override
  Widget build(BuildContext context) {
    final review = controller.review.value!;
    final iconInfo = EvaluationUiHelpers.iconFor(review.reviewType);
    final isSelf = (review.reviewType ?? '').toLowerCase().contains('self');
    final personName = review.employee?.displayName ?? '';
    final hasPersonName = personName.isNotEmpty;
    final questionsCount = review.questionsCount ?? controller.totalQuestions;
    final canStart = controller.totalQuestions > 0;

    return Scaffold(
      appBar: _evaluationAppBar(title: 'evaluation'.tr, onBack: () => Get.back()),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: Icon(iconInfo.icon, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 18),
              Text(
                EvaluationUiHelpers.titleFor(review.reviewType, fallback: 'evaluation_default_title'.tr).toUpperCase(),
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text(
                isSelf
                    ? 'self_reflection_subtitle'.tr
                    : 'evaluating_someone_subtitle'.trParams({'name': personName}),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              if (hasPersonName)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEDEDED)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('for_label'.tr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          Text(personName, style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: _InfoChip(
                  icon: Icons.list_alt_rounded,
                  label: 'questions_count'.trParams({'count': '$questionsCount'}),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  isSelf
                      ? 'about_to_evaluate_self'.tr
                      : 'about_to_evaluate_other'.trParams({'name': personName}),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(28)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: canStart ? controller.startQuestions : null,
                      child: Center(
                        child: Text('start_evaluation'.tr, style: AppTextStyles.button),
                      ),
                    ),
                  ),
                ),
              ),
              if (!canStart) ...[
                const SizedBox(height: 10),
                Text('no_questions_available'.tr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Flexible(child: Text(label, style: AppTextStyles.bodySmall, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

// ────────────────────────────── Questions (Pending only) ──────────────────────────────

class _QuestionsScaffold extends GetView<EvaluationController> {
  const _QuestionsScaffold();

  void _handlePrimaryAction(BuildContext context) {
    if (!controller.currentQuestionAnswered) return;
    if (controller.isLastQuestion) {
      _showSubmitSheet(context);
    } else {
      controller.goNext();
    }
  }

  void _showSubmitSheet(BuildContext context) {
    Get.bottomSheet(
      Obx(
        () => SubmitConfirmationSheet(
          isSubmitting: controller.isSubmitting.value,
          onConfirm: controller.submit,
          onCancel: () => Get.back(),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final question = controller.currentQuestion;
      final index = controller.currentQuestionIndex.value;
      final total = controller.totalQuestions;
      controller.answersTick.value; // subscribe to answer edits

      return Scaffold(
        appBar: _evaluationAppBar(title: 'evaluation'.tr, onBack: controller.goBack),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'question_of'.trParams({'current': '${index + 1}', 'total': '$total'}),
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    Text(
                      '${(controller.progressPercent * 100).round()}%',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Container(height: 6, color: const Color(0xFFEDEDED)),
                      LayoutBuilder(
                        builder: (context, constraints) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 6,
                          width: constraints.maxWidth * controller.progressPercent,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(colors: AppColors.goldGradient),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: question == null
                      ? Center(child: Text('no_questions_available'.tr, style: AppTextStyles.bodyMedium))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.only(top: 28),
                          child: Column(
                            children: [
                              Text(
                                question.question,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                              ),
                              if (question.helpText != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  question.helpText!,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                              const SizedBox(height: 32),
                              _buildAnswerInput(question),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: OutlinedButton(
                          onPressed: controller.goBack,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE0E0E0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.textSecondary),
                              const SizedBox(width: 6),
                              Text('back'.tr, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: controller.currentQuestionAnswered
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(27),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(27),
                              onTap: () => _handlePrimaryAction(context),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller.isLastQuestion ? 'submit'.tr : 'next'.tr,
                                      style: AppTextStyles.button,
                                    ),
                                    if (!controller.isLastQuestion) ...[
                                      const SizedBox(width: 6),
                                      const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAnswerInput(EvaluationQuestionModel question) {
    final answer = controller.answerFor(question.id);
    if (question.isRating) {
      return StarRatingInput(
        value: answer?.rating ?? 0,
        onChanged: (value) => controller.setRating(question.id, value),
      );
    }
    final textController = controller.textControllerFor(question.id);
    return TextAnswerInput(
      controller: textController,
      maxLength: question.maxLength,
      charCount: textController.text.length,
      onChanged: (value) => controller.setText(question.id, value),
    );
  }
}

// ────────────────────── Completed READ ONLY summary ──────────────────────

class _ReadOnlySummaryScaffold extends GetView<EvaluationController> {
  const _ReadOnlySummaryScaffold();

  @override
  Widget build(BuildContext context) {
    final review = controller.review.value!;
    final personName = review.employee?.displayName ?? '';
    final hasPersonName = personName.isNotEmpty;
    final questions = controller.questions;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: _evaluationAppBar(title: 'evaluation'.tr, onBack: () => Get.back()),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Text(
                    EvaluationUiHelpers.titleFor(review.reviewType, fallback: 'evaluation_default_title'.tr),
                    style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'completed'.tr,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                  ),
                  if (hasPersonName) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFEDEDED)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${'for_label'.tr} $personName',
                              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  if (questions.isEmpty)
                    Text('no_questions_available'.tr, style: AppTextStyles.bodyMedium)
                  else
                    ...questions.map((q) => _ReadOnlyQuestionCard(question: q)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(28)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: controller.done,
                      child: Center(child: Text('done'.tr, style: AppTextStyles.button)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyQuestionCard extends GetView<EvaluationController> {
  final EvaluationQuestionModel question;
  const _ReadOnlyQuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    // Answers come only from the review's answers[] list, matched by
    // evaluation_template_question_id / question.id — never from question.comment.
    final submitted = controller.submittedAnswerFor(question.id);
    final rating = submitted?.rating ?? 0;
    // Exact API string — no trim/reverse/split/replace.
    final comment = submitted?.comment;
    final hasComment = comment != null && comment.isNotEmpty;

    assert(() {
      debugPrint(
        'EVAL_UI_CARD q=${question.id} type=${question.responseType} '
        'submitted=${submitted != null} hasComment=$hasComment '
        'len=${comment?.length ?? 0}',
      );
      return true;
    }());

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.question, style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
          if (question.helpText != null) ...[
            const SizedBox(height: 4),
            Text(question.helpText!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 14),
          if (question.isRating)
            IgnorePointer(
              child: StarRatingInput(value: rating, onChanged: (_) {}),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEDEDED)),
              ),
              child: hasComment
                  ? _AutoDirectionCommentText(comment: comment!)
                  : const SizedBox(height: 20),
            ),
        ],
      ),
    );
  }
}

/// Renders [comment] exactly as returned by the API.
///
/// Uses a [Directionality] bidi isolate (dir=auto) so:
/// - Arabic → RTL base direction
/// - English → LTR base direction
/// - Mixed → first strong character decides; Unicode BiDi handles the rest
///
/// Font note: the app theme uses OpenSans (no Arabic glyphs). A static
/// [AppTextStyles] Cairo style can fail to paint Arabic on Windows while
/// Latin still shows. Building Cairo at paint-time with system Arabic
/// fallbacks fixes that without mutating the string.
class _AutoDirectionCommentText extends StatelessWidget {
  final String comment;
  const _AutoDirectionCommentText({required this.comment});

  static const List<String> _arabicCapableFallbacks = <String>[
    'Segoe UI',
    'Tahoma',
    'Arial',
    'Noto Naskh Arabic',
    'Noto Sans Arabic',
  ];

  @override
  Widget build(BuildContext context) {
    assert(() {
      debugPrint(
        'EVAL_ANSWER_COMMENT length=${comment.length} '
        'hasArabic=${comment.runes.any((r) => r >= 0x0600 && r <= 0x06FF)}',
      );
      return true;
    }());

    final direction = EvaluationUiHelpers.autoTextDirection(comment);

    // Fresh GoogleFonts.cairo() each build so glyphs for this exact string
    // are available; fallbacks cover Windows when the downloadable font
    // subset is Latin-only.
    final style = GoogleFonts.cairo(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      height: 1.45,
    ).copyWith(fontFamilyFallback: _arabicCapableFallbacks);

    return Directionality(
      textDirection: direction,
      child: Text(
        comment,
        textAlign: TextAlign.start,
        softWrap: true,
        style: style,
      ),
    );
  }
}

// ────────────────────────────── Post-submit success ──────────────────────────────

class _CompletedScaffold extends GetView<EvaluationController> {
  const _CompletedScaffold();

  @override
  Widget build(BuildContext context) {
    final userName = controller.currentUserDisplayName;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(color: Color(0xFFFFF3E0), shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: AppColors.accent, size: 52),
              ),
              const SizedBox(height: 24),
              Text(
                'evaluation_completed_title'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(
                'evaluation_completed_subtitle'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 18),
              Container(width: 40, height: 2, color: const Color(0xFFEDEDED)),
              const SizedBox(height: 18),
              if (userName.isNotEmpty)
                Text(
                  'thank_you_name'.trParams({'name': userName}),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              const SizedBox(height: 6),
              Text(
                'feedback_recorded'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 34),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(28)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: controller.done,
                      child: Center(child: Text('done'.tr, style: AppTextStyles.button)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
