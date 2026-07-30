import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

enum CustomButtonStyle { navy, gold }

/// Shared pill-shaped button used for Login, Continue, Save actions.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final CustomButtonStyle style;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.style = CustomButtonStyle.navy,
  });

  @override
  Widget build(BuildContext context) {
    final bool isGold = style == CustomButtonStyle.gold;

    // تحديد لون النص والأيقونة مؤشّر التحميل ديناميكياً
    // إذا كان الزر ذهبي -> اللون نيلي داكن (AppColors.primary)
    // إذا كان الزر نيلي -> اللون أبيض
    final Color contentColor = isGold ? AppColors.primary : Colors.white;

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: isGold ? AppColors.goldGradient : AppColors.navyGradient,
            begin: Alignment.topCenter,    // تدرج رأسي ليطابق التصميم
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: (isGold ? AppColors.accent : AppColors.primary).withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: isLoading ? null : onPressed,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation(contentColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // السهم يأتي أولاً ليكون بالشكل:  ← متابعة  (مثل الصورة بالضبط)
                        if (icon != null) ...[
                          Icon(icon, color: contentColor, size: 22),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: AppTextStyles.button.copyWith(
                            color: contentColor, // استخدام اللون الديناميكي
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}