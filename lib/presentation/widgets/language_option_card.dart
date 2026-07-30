import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class LanguageOptionCard extends StatelessWidget {
  final String label;
  final String countryCode;
  final bool selected;
  final VoidCallback onTap;

  const LanguageOptionCard({
    super.key,
    required this.label,
    required this.countryCode,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(32), // حواف دائرية كاملة
          border: Border.all(
            color: selected
                ? Colors.white.withOpacity(0.4)
                : Colors.white.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // أيقونة الاختيار
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.secondary : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppColors.secondary
                      : Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: AppColors.primary,
                    )
                  : null,
            ),
            
            const Spacer(),

            // النص والرمز
            Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              countryCode,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}