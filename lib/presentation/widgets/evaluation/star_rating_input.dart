import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'evaluation_ui_helpers.dart';

/// Star picker for `response_type == 'rating'` questions.
///
/// Shows 1..5 numbers under the stars before an answer is picked, and the
/// matching descriptive label once one is — matching the reference design.
class StarRatingInput extends StatelessWidget {
  final int value; // 0 = unanswered
  final ValueChanged<int> onChanged;
  final int maxStars;

  const StarRatingInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.maxStars = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxStars, (index) {
            final starValue = index + 1;
            final filled = starValue <= value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: () => onChanged(starValue),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      filled ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 44,
                      color: filled ? AppColors.secondary : const Color(0xFFD9D9D9),
                    ),
                    if (value == 0) ...[
                      const SizedBox(height: 6),
                      Text('$starValue', style: AppTextStyles.bodySmall),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
        if (value > 0) ...[
          const SizedBox(height: 14),
          Text(
            EvaluationUiHelpers.ratingLabelFor(value),
            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
          ),
        ],
      ],
    );
  }
}
