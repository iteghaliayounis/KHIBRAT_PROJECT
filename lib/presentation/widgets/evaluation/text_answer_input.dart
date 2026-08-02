import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Free-text answer box for `response_type == 'text'` questions.
///
/// Only enforces a character limit when the question actually carries a
/// [maxLength] from the backend — never a client-invented default.
///
/// Takes an externally-owned [controller] (one per question, kept alive by
/// the evaluation controller) so answers survive Back/Next navigation and
/// the field doesn't lose focus/cursor position on every rebuild.
class TextAnswerInput extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLength;
  final ValueChanged<String> onChanged;
  final int charCount;

  const TextAnswerInput({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.charCount,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.inputBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: 6,
            minLines: 6,
            maxLength: maxLength,
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
            style: AppTextStyles.bodyLarge,
            decoration: InputDecoration(
              hintText: 'write_your_answer'.tr,
              hintStyle: AppTextStyles.hint,
              border: InputBorder.none,
              isCollapsed: true,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            maxLength != null ? '$charCount / $maxLength' : '$charCount',
            style: AppTextStyles.bodySmall,
          ),
        ),
      ],
    );
  }
}
